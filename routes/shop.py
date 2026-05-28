from flask import (Blueprint, render_template, request, session,
                   redirect, url_for, jsonify, flash)
from flask_login import current_user, login_required
from models import (db, Product, ProductVariant, Category, Setting, WhyCard,
                    ProcessStep, Testimonial, FooterLink, Order, OrderItem,
                    Cart, User, UserAddress, generate_order_number)
from functools import wraps
import re

shop = Blueprint('shop', __name__)

def user_login_required(f):
    @wraps(f)
    def decorated(*args, **kwargs):
        if not current_user.is_authenticated or not isinstance(current_user, User):
            flash('Please log in to continue.', 'warning')
            return redirect(url_for('auth.login', next=request.path))
        return f(*args, **kwargs)
    return decorated

def get_cart():
    if not current_user.is_authenticated or not isinstance(current_user, User):
        return {}
    items = (Cart.query
             .filter_by(user_id=current_user.id)
             .join(Cart.variant)
             .all())
    result = {}
    for item in items:
        v = item.variant
        if v and v.product:
            result[str(item.variant_id)] = {
                'variant_id':     item.variant_id,
                'product_id':     v.product_id,
                'name':           v.product.name,
                'size':           v.size_label,
                'price':          float(v.price),
                'emoji':          v.product.emoji,
                'image_url':      v.product.cover_image_url,
                'qty':            item.quantity,
                'delivery_charge': float(v.product.delivery_charge or 0),
            }
    return result

def get_cart_count():
    if not current_user.is_authenticated or not isinstance(current_user, User):
        return 0
    result = db.session.query(db.func.sum(Cart.quantity))\
               .filter_by(user_id=current_user.id).scalar()
    return int(result or 0)

def get_cart_total():
    return sum(i['qty'] * i['price'] for i in get_cart().values())

def get_cart_delivery():
    """Return the highest delivery charge among all products in the cart."""
    cart = get_cart()
    if not cart:
        return 0.0
    return max((i.get('delivery_charge', 0.0) for i in cart.values()), default=0.0)

def get_footer_links():
    links = (FooterLink.query
             .filter_by(is_active=True)
             .order_by(FooterLink.column_name, FooterLink.sort_order)
             .all())
    grouped = {}
    for lnk in links:
        grouped.setdefault(lnk.column_name, []).append(lnk)
    return grouped

def base_context():
    return {
        'settings':     Setting.all_dict(),
        'cart_count':   get_cart_count(),
        'footer_links': get_footer_links(),
    }

@shop.route('/')
def home():
    ctx = base_context()
    featured     = Product.query.filter_by(is_active=True, is_featured=True).order_by(Product.sort_order).all()
    ctx.update({
        'products':      featured,
        'why_cards':     WhyCard.query.filter_by(is_active=True).order_by(WhyCard.sort_order).all(),
        'process_steps': ProcessStep.query.filter_by(is_active=True).order_by(ProcessStep.step_number).all(),
        'testimonials':  Testimonial.query.filter_by(is_active=True).order_by(Testimonial.sort_order).all(),
    })
    return render_template('home.html', **ctx)

@shop.route('/products')
def products():
    ctx      = base_context()
    cat_slug = request.args.get('category')
    query    = Product.query.filter_by(is_active=True)
    active_cat = None
    if cat_slug:
        cat = Category.query.filter_by(slug=cat_slug, is_active=True).first()
        if cat:
            query = query.filter_by(category_id=cat.id)
            active_cat = cat
    ctx.update({
        'products':   query.order_by(Product.sort_order).all(),
        'categories': Category.query.filter_by(is_active=True).order_by(Category.sort_order).all(),
        'active_cat': active_cat,
    })
    return render_template('products.html', **ctx)

@shop.route('/products/<slug>')
def product_detail(slug):
    ctx     = base_context()
    product = Product.query.filter_by(slug=slug, is_active=True).first_or_404()
    related = product.related_products
    if not related:
        related = (Product.query
                   .filter_by(category_id=product.category_id, is_active=True)
                   .filter(Product.id != product.id)
                   .limit(3).all())
    ctx.update({
        'product':  product,
        'variants': ProductVariant.query.filter_by(product_id=product.id).all(),
        'related':  related,
    })
    return render_template('product_detail.html', **ctx)

@shop.route('/track-order', methods=['GET', 'POST'])
def track_order():
    ctx    = base_context()
    orders = []
    order  = None
    error  = None
    if request.method == 'POST':
        q = request.form.get('query', '').strip()
        if q:
            q_upper = q.upper()
            by_number = Order.query.filter(Order.order_number == q_upper).first()
            if by_number:
                orders = [by_number]
            elif current_user.is_authenticated and isinstance(current_user, User):
                orders = Order.query.filter(
                    Order.customer_phone == q,
                    Order.user_id == current_user.id
                ).order_by(Order.created_at.desc()).all()
            if not orders:
                error = 'No order found. Check your order number or phone.'
            elif len(orders) == 1:
                order = orders[0]
    ctx.update({'order': order, 'orders': orders, 'error': error})
    return render_template('track_order.html', **ctx)

@shop.route('/order-success/<order_number>')
def order_success(order_number):
    order = Order.query.filter_by(order_number=order_number).first_or_404()
    ctx   = base_context()
    ctx['order'] = order
    return render_template('order_success.html', **ctx)

@shop.route('/api/variant/<int:variant_id>')
def api_variant(variant_id):
    v = ProductVariant.query.get_or_404(variant_id)
    return jsonify({
        'id': v.id, 'price': float(v.price),
        'mrp': float(v.mrp) if v.mrp else None,
        'stock': v.stock_qty, 'discount': v.discount_pct,
    })

@shop.route('/cart')
@user_login_required
def cart():
    ctx             = base_context()
    cart_items      = list(get_cart().values())
    total           = get_cart_total()
    delivery_charge = get_cart_delivery()
    ctx.update({
        'cart_items':      cart_items,
        'subtotal':        total,
        'delivery_charge': delivery_charge,
        'grand_total':     total + delivery_charge,
    })
    return render_template('cart.html', **ctx)

@shop.route('/add-to-cart', methods=['POST'])
def add_to_cart():
    if not current_user.is_authenticated or not isinstance(current_user, User):
        return jsonify({
            'success':  False,
            'message':  'Please log in to add items to cart.',
            'redirect': url_for('auth.login'),
        }), 401

    data       = request.get_json() or request.form
    variant_id = int(data.get('variant_id', 0))
    qty        = max(1, int(data.get('qty', 1)))

    variant = ProductVariant.query.get(variant_id)
    if not variant:
        return jsonify({'success': False, 'message': 'Product not found'}), 404
    if variant.stock_qty < qty:
        return jsonify({'success': False, 'message': 'Insufficient stock'}), 400

    cart_item = Cart.query.filter_by(
        user_id=current_user.id, variant_id=variant_id
    ).first()
    if cart_item:
        cart_item.quantity += qty
    else:
        cart_item = Cart(user_id=current_user.id, variant_id=variant_id, quantity=qty)
        db.session.add(cart_item)
    db.session.commit()

    return jsonify({
        'success':    True,
        'message':    f'{variant.product.name} added to cart!',
        'cart_count': get_cart_count(),
        'cart_total': get_cart_total(),
    })

@shop.route('/update-cart', methods=['POST'])
@user_login_required
def update_cart():
    data       = request.get_json() or request.form
    variant_id = int(data.get('variant_id', 0))
    qty        = int(data.get('qty', 0))

    cart_item = Cart.query.filter_by(
        user_id=current_user.id, variant_id=variant_id
    ).first()
    if cart_item:
        if qty <= 0:
            db.session.delete(cart_item)
        else:
            cart_item.quantity = qty
        db.session.commit()

    total           = get_cart_total()
    delivery_charge = get_cart_delivery()

    return jsonify({
        'success':         True,
        'cart_count':      get_cart_count(),
        'subtotal':        total,
        'delivery_charge': delivery_charge,
        'grand_total':     total + delivery_charge,
    })

@shop.route('/checkout')
@user_login_required
def checkout():
    if not get_cart():
        flash('Your cart is empty.', 'warning')
        return redirect(url_for('shop.products'))
    ctx             = base_context()
    cart_items      = list(get_cart().values())
    total           = get_cart_total()
    delivery_charge = get_cart_delivery()

    saved_addresses = (UserAddress.query
                       .filter_by(user_id=current_user.id)
                       .order_by(UserAddress.is_default.desc(), UserAddress.created_at.asc())
                       .all())

    ctx.update({
        'cart_items':      cart_items,
        'subtotal':        total,
        'delivery_charge': delivery_charge,
        'grand_total':     total + delivery_charge,
        'user':            current_user,
        'saved_addresses': saved_addresses,
        'single_mode':     False,
        'single_item':     None,
    })
    return render_template('checkout.html', **ctx)

@shop.route('/buy-now', methods=['POST'])
@user_login_required
def buy_now():
    data       = request.get_json(silent=True) or request.form
    variant_id = int(data.get('variant_id', 0))
    qty        = max(1, int(data.get('qty', 1)))

    variant = ProductVariant.query.get(variant_id)
    if not variant or not variant.product:
        if request.is_json:
            return jsonify({'success': False, 'message': 'Product not found'}), 404
        flash('Product not found.', 'danger')
        return redirect(url_for('shop.products'))

    if variant.stock_qty < qty:
        if request.is_json:
            return jsonify({'success': False, 'message': 'Insufficient stock'}), 400
        flash('Insufficient stock.', 'danger')
        return redirect(url_for('shop.products'))

    session['buy_now'] = {'variant_id': variant_id, 'qty': qty}

    if request.is_json:
        return jsonify({'success': True, 'redirect': url_for('shop.checkout_single')})
    return redirect(url_for('shop.checkout_single'))

@shop.route('/checkout/single')
@user_login_required
def checkout_single():
    buy_now = session.get('buy_now')
    if not buy_now:
        flash('No item selected for checkout.', 'warning')
        return redirect(url_for('shop.products'))

    variant = ProductVariant.query.get(buy_now['variant_id'])
    if not variant or not variant.product:
        session.pop('buy_now', None)
        flash('Product no longer available.', 'danger')
        return redirect(url_for('shop.products'))

    qty             = buy_now['qty']
    price           = float(variant.price)
    total           = qty * price
    delivery_charge = float(variant.product.delivery_charge or 0)

    ctx = base_context()

    single_item = {
        'variant_id':      variant.id,
        'product_id':      variant.product_id,
        'name':            variant.product.name,
        'size':            variant.size_label,
        'price':           price,
        'emoji':           variant.product.emoji,
        'image_url':       variant.product.cover_image_url,
        'qty':             qty,
        'delivery_charge': delivery_charge,
    }

    saved_addresses = (UserAddress.query
                       .filter_by(user_id=current_user.id)
                       .order_by(UserAddress.is_default.desc(), UserAddress.created_at.asc())
                       .all())

    ctx.update({
        'cart_items':      [single_item],
        'subtotal':        total,
        'delivery_charge': delivery_charge,
        'grand_total':     total + delivery_charge,
        'user':            current_user,
        'saved_addresses': saved_addresses,
        'single_mode':     True,
        'single_item':     single_item,
    })
    return render_template('checkout.html', **ctx)

@shop.route('/place-order', methods=['POST'])
@user_login_required
def place_order():
    data        = request.get_json(silent=True) or request.form
    single_mode = str(data.get('single_mode', 'false')).lower() in ('true', '1', 'yes')

    if single_mode:
        buy_now = session.get('buy_now')
        if not buy_now:
            return jsonify({'success': False, 'message': 'Session expired. Please try again.'}), 400
        variant = ProductVariant.query.get(buy_now['variant_id'])
        if not variant or not variant.product:
            return jsonify({'success': False, 'message': 'Product no longer available.'}), 400
        qty   = buy_now['qty']
        price = float(variant.price)
        items_to_order = [{
            'variant_id':      variant.id,
            'product_id':      variant.product_id,
            'name':            variant.product.name,
            'size':            variant.size_label,
            'price':           price,
            'qty':             qty,
            'delivery_charge': float(variant.product.delivery_charge or 0),
        }]
        subtotal = qty * price
    else:
        cart = get_cart()
        if not cart:
            return jsonify({'success': False, 'message': 'Cart is empty'}), 400
        items_to_order = list(cart.values())
        subtotal = sum(i['qty'] * i['price'] for i in items_to_order)

    address = str(data.get('address', '')).strip()
    city    = str(data.get('city', '')).strip()
    pincode = str(data.get('pincode', '')).strip()
    notes   = str(data.get('notes', '')).strip()
    phone   = str(data.get('phone', '')).strip()
    name    = str(data.get('name', '')).strip()

    if not name:
        name = current_user.full_name or ''
    if not phone:
        phone = current_user.phone or ''
    email = current_user.email

    errors = {}
    if not address or len(address) < 10:
        errors['address'] = 'Please enter a complete delivery address.'
    if not phone or not re.match(r'^[6-9]\d{9}$', phone):
        errors['phone'] = 'Please add or enter a valid 10-digit mobile number.'
    if pincode and not re.match(r'^\d{6}$', pincode):
        errors['pincode'] = 'Enter a valid 6-digit PIN code.'

    if errors:
        return jsonify({'success': False, 'errors': errors}), 422

    delivery_charge = max(
        (float(i.get('delivery_charge', 0)) for i in items_to_order), default=0.0
    )
    grand_total = subtotal + delivery_charge

    order = Order(
        user_id          = current_user.id,
        order_number     = generate_order_number(),
        customer_name    = name,
        customer_phone   = phone,
        customer_email   = email,
        delivery_address = address,
        city             = city,
        pincode          = pincode,
        subtotal         = subtotal,
        delivery_charge  = delivery_charge,
        total_amount     = grand_total,
        payment_method   = 'COD',
        notes            = notes or None,
    )
    db.session.add(order)
    db.session.flush()

    for item in items_to_order:
        db.session.add(OrderItem(
            order_id      = order.id,
            product_id    = item['product_id'],
            variant_id    = item['variant_id'],
            product_name  = item['name'],
            variant_label = item['size'],
            quantity      = item['qty'],
            unit_price    = item['price'],
            subtotal      = item['qty'] * item['price'],
        ))

    if single_mode:
        session.pop('buy_now', None)
    else:
        Cart.query.filter_by(user_id=current_user.id).delete()

    db.session.commit()

    return jsonify({
        'success':      True,
        'order_number': order.order_number,
        'redirect':     url_for('shop.order_success', order_number=order.order_number),
    })