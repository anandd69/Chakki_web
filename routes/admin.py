from flask import (Blueprint, render_template, request, redirect,
                   url_for, flash, jsonify, session, current_app)
from flask_login import login_user, logout_user, current_user
from functools import wraps
from models import (db, AdminUser, Product, ProductVariant, ProductRelated, ProductImage,
                    Category, Setting, WhyCard, ProcessStep, Testimonial,
                    FooterLink, Order, OrderItem, OrderReview)
from datetime import datetime, timedelta
from sqlalchemy import func, extract
import os, uuid
from werkzeug.utils import secure_filename

admin = Blueprint('admin', __name__, url_prefix='/admin')

ALLOWED_EXTENSIONS = {'png', 'jpg', 'jpeg', 'webp', 'gif'}

def allowed_file(filename):
    return '.' in filename and filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS

def save_product_image(file):
    """Save uploaded image, return filename or None."""
    if not file or file.filename == '':
        return None
    if not allowed_file(file.filename):
        return None
    ext = secure_filename(file.filename).rsplit('.', 1)[1].lower()
    filename = f"{uuid.uuid4().hex}.{ext}"
    upload_dir = os.path.join(current_app.static_folder, 'uploads', 'products')
    os.makedirs(upload_dir, exist_ok=True)
    file.save(os.path.join(upload_dir, filename))
    return filename

def delete_product_image(filename):
    """Delete old product image file if it exists."""
    if not filename:
        return
    path = os.path.join(current_app.static_folder, 'uploads', 'products', filename)
    try:
        if os.path.exists(path):
            os.remove(path)
    except Exception:
        pass

def admin_required(f):
    @wraps(f)
    def decorated_function(*args, **kwargs):
        if not current_user.is_authenticated:
            return redirect(url_for('admin.login', next=request.path))
        if not isinstance(current_user, AdminUser):
            logout_user()
            flash('Admin access required. Please log in as admin.', 'warning')
            return redirect(url_for('admin.login'))
        return f(*args, **kwargs)
    return decorated_function

@admin.route('/login', methods=['GET', 'POST'])
def login():
    if current_user.is_authenticated and isinstance(current_user, AdminUser):
        return redirect(url_for('admin.dashboard'))
    error = None
    if request.method == 'POST':
        username = request.form.get('username', '').strip()
        password = request.form.get('password', '')
        user = AdminUser.query.filter_by(username=username, is_active=True).first()
        if user and user.check_password(password):
            if current_user.is_authenticated:
                logout_user()
            login_user(user, remember=True)
            user.last_login = datetime.utcnow()
            db.session.commit()
            next_url = request.args.get('next') or url_for('admin.dashboard')
            return redirect(next_url)
        error = 'Invalid username or password.'
    return render_template('admin/login.html', error=error)

@admin.route('/logout')
@admin_required
def logout():
    logout_user()
    return redirect(url_for('admin.login'))

@admin.route('/')
@admin.route('/dashboard')
@admin_required
def dashboard():
    today    = datetime.utcnow().date()
    week_ago = datetime.utcnow() - timedelta(days=7)

    total_orders   = Order.query.count()
    today_orders   = Order.query.filter(func.date(Order.created_at) == today).count()
    pending_orders = Order.query.filter_by(status='pending').count()
    total_revenue  = db.session.query(func.sum(Order.total_amount)).filter(
                         Order.status != 'cancelled').scalar() or 0
    week_revenue   = db.session.query(func.sum(Order.total_amount)).filter(
                         Order.created_at >= week_ago,
                         Order.status != 'cancelled').scalar() or 0

    status_counts = dict(db.session.query(Order.status, func.count(Order.id))
                         .group_by(Order.status).all())

    recent_orders = Order.query.order_by(Order.created_at.desc()).limit(5).all()

    chart_labels, chart_data = [], []
    for i in range(6, -1, -1):
        d   = datetime.utcnow().date() - timedelta(days=i)
        rev = db.session.query(func.sum(Order.total_amount)).filter(
                  func.date(Order.created_at) == d,
                  Order.status != 'cancelled').scalar() or 0
        chart_labels.append(d.strftime('%d %b'))
        chart_data.append(float(rev))

    return render_template('admin/dashboard.html',
        total_orders=total_orders, today_orders=today_orders,
        pending_orders=pending_orders, total_revenue=total_revenue,
        week_revenue=week_revenue, status_counts=status_counts,
        recent_orders=recent_orders,
        chart_labels=chart_labels, chart_data=chart_data)

@admin.route('/products')
@admin_required
def products():
    products = Product.query.order_by(Product.sort_order).all()
    return render_template('admin/products.html', products=products)

def _save_product_fields(p, form, files):
    """Apply all form fields to a Product instance."""
    p.category_id     = form.get('category_id') or None
    p.name            = form['name'].strip()
    p.slug            = form.get('slug', '').strip()
    p.short_desc      = form.get('short_desc', '').strip()
    p.subtitle        = form.get('subtitle', '').strip() or None
    p.offer_label     = form.get('offer_label', '').strip() or None
    p.stock_label     = form.get('stock_label', '').strip() or None
    p.delivery_text   = form.get('delivery_text', '').strip() or None
    p.freshness_text  = form.get('freshness_text', '').strip() or None
    p.highlights      = form.get('highlights', '').strip() or None
    p.weight_label    = form.get('weight_label', '').strip() or None
    p.size_label_text = form.get('size_label_text', '').strip() or None
    p.delivery_charge  = float(form.get('delivery_charge') or 0)
    p.description     = form.get('description', '').strip()
    p.emoji           = form.get('emoji', '🌾').strip()
    p.badge           = form.get('badge', '').strip() or None
    p.badge_color     = form.get('badge_color', '#4A7C59')
    p.is_active       = 'is_active' in form
    p.is_featured     = 'is_featured' in form
    p.sort_order      = int(form.get('sort_order', 0))

    # Image upload
    img_file = files.get('product_image')
    if img_file and img_file.filename:
        old_img = p.image_filename
        new_filename = save_product_image(img_file)
        if new_filename:
            p.image_filename = new_filename
            if old_img:
                delete_product_image(old_img)
    elif form.get('remove_image') == '1' and p.image_filename:
        delete_product_image(p.image_filename)
        p.image_filename = None

def _save_variants(p, form):
    """Sync variants from form data."""
    variant_ids = form.getlist('variant_id[]')
    labels      = form.getlist('variant_label[]')
    prices      = form.getlist('variant_price[]')
    mrps        = form.getlist('variant_mrp[]')
    stocks      = form.getlist('variant_stock[]')
    weights     = form.getlist('variant_weight[]')

    existing_variants = {str(v.id): v for v in p.variants}
    submitted_ids = set()

    for i, lbl in enumerate(labels):
        if not lbl.strip():
            continue
        vid = variant_ids[i] if i < len(variant_ids) else ''
        price_val = float(prices[i] or 0) if i < len(prices) and prices[i] else 0.0
        mrp_val   = float(mrps[i]) if i < len(mrps) and mrps[i] else None
        stock_val = int(stocks[i]) if i < len(stocks) and stocks[i] else 100
        wt_val    = float(weights[i]) if i < len(weights) and weights[i] else None

        if vid and vid in existing_variants:
            v = existing_variants[vid]
            v.size_label = lbl.strip()
            v.price      = price_val
            v.mrp        = mrp_val
            v.stock_qty  = stock_val
            v.weight_kg  = wt_val
            submitted_ids.add(vid)
        else:
            v = ProductVariant(
                product_id=p.id, size_label=lbl.strip(),
                price=price_val, mrp=mrp_val,
                stock_qty=stock_val, weight_kg=wt_val,
                is_default=(i == 0),
            )
            db.session.add(v)

    for old_id, old_v in existing_variants.items():
        if old_id not in submitted_ids:
            db.session.delete(old_v)

def _save_related(p, form):
    """Sync related products selection."""
    selected_ids = form.getlist('related_products[]')
    # Remove all existing
    ProductRelated.query.filter_by(product_id=p.id).delete()
    for i, rid_str in enumerate(selected_ids):
        try:
            rid = int(rid_str)
            if rid != p.id:
                db.session.add(ProductRelated(
                    product_id=p.id, related_id=rid, sort_order=i
                ))
        except (ValueError, TypeError):
            pass

@admin.route('/products/new', methods=['GET', 'POST'])
@admin_required
def product_new():
    categories   = Category.query.filter_by(is_active=True).all()
    all_products = Product.query.filter_by(is_active=True).order_by(Product.name).all()
    if request.method == 'POST':
        slug = request.form.get('slug', '').strip()
        if Product.query.filter_by(slug=slug).first():
            flash('A product with that slug already exists.', 'danger')
            return render_template('admin/product_form.html',
                                   product=None, categories=categories,
                                   all_products=all_products, selected_related_ids=[])
        p = Product(name=request.form['name'].strip(), slug=slug)
        db.session.add(p)
        db.session.flush()
        _save_product_fields(p, request.form, request.files)
        _save_variants(p, request.form)
        _save_related(p, request.form)
        db.session.flush()
        # Handle multi-image upload for new products
        new_images = request.files.getlist('product_images_new')
        for i, img_file in enumerate(new_images[:10]):
            if img_file and img_file.filename:
                fname = save_product_image(img_file)
                if fname:
                    pi = ProductImage(
                        product_id=p.id, filename=fname,
                        alt_text=p.name, is_primary=(i == 0),
                        is_active=True, sort_order=i,
                    )
                    db.session.add(pi)
        db.session.commit()
        flash('Product created successfully!', 'success')
        return redirect(url_for('admin.products'))
    return render_template('admin/product_form.html',
                           product=None, categories=categories,
                           all_products=all_products, selected_related_ids=[])

@admin.route('/products/<int:pid>/edit', methods=['GET', 'POST'])
@admin_required
def product_edit(pid):
    p            = Product.query.get_or_404(pid)
    categories   = Category.query.filter_by(is_active=True).all()
    all_products = Product.query.filter_by(is_active=True).filter(Product.id != pid).order_by(Product.name).all()
    selected_related_ids = [r.related_id for r in
                            ProductRelated.query.filter_by(product_id=pid).order_by(ProductRelated.sort_order).all()]
    if request.method == 'POST':
        new_slug = request.form.get('slug', '').strip()
        existing = Product.query.filter_by(slug=new_slug).first()
        if existing and existing.id != pid:
            flash('A product with that slug already exists.', 'danger')
            return render_template('admin/product_form.html',
                                   product=p, categories=categories,
                                   all_products=all_products,
                                   selected_related_ids=selected_related_ids)
        _save_product_fields(p, request.form, request.files)
        _save_variants(p, request.form)
        _save_related(p, request.form)
        db.session.commit()
        flash('Product updated!', 'success')
        return redirect(url_for('admin.products'))
    return render_template('admin/product_form.html',
                           product=p, categories=categories,
                           all_products=all_products,
                           selected_related_ids=selected_related_ids)

@admin.route('/products/<int:pid>/delete', methods=['POST'])
@admin_required
def product_delete(pid):
    p = Product.query.get_or_404(pid)
    if p.image_filename:
        delete_product_image(p.image_filename)
    db.session.delete(p)
    db.session.commit()
    return jsonify({'success': True})

@admin.route('/orders')
@admin_required
def orders():
    page          = request.args.get('page', 1, type=int)
    status_filter = request.args.get('status', '')
    query = Order.query
    if status_filter:
        query = query.filter_by(status=status_filter)
    orders = query.order_by(Order.created_at.desc()).paginate(
        page=page, per_page=20, error_out=False)
    return render_template('admin/orders.html', orders=orders, status_filter=status_filter)

@admin.route('/orders/<int:oid>')
@admin_required
def order_detail(oid):
    order = Order.query.get_or_404(oid)
    return render_template('admin/order_detail.html', order=order)

@admin.route('/orders/<int:oid>/status', methods=['POST'])
@admin_required
def update_order_status(oid):
    order = Order.query.get_or_404(oid)
    data  = request.get_json() or request.form
    new_status = data.get('status')
    valid = ['pending', 'confirmed', 'processing', 'shipped', 'delivered', 'cancelled']
    if new_status in valid:
        order.status = new_status
        db.session.commit()
        return jsonify({'success': True, 'status': new_status, 'color': order.status_color})
    return jsonify({'success': False, 'message': 'Invalid status'}), 400

@admin.route('/reviews')
@admin_required
def reviews():
    all_reviews = OrderReview.query.order_by(OrderReview.created_at.desc()).all()
    return render_template('admin/reviews.html', reviews=all_reviews)

@admin.route('/reviews/<int:rid>/delete', methods=['POST'])
@admin_required
def review_delete(rid):
    r = OrderReview.query.get_or_404(rid)
    db.session.delete(r)
    db.session.commit()
    return jsonify({'success': True})

@admin.route('/testimonials')
@admin_required
def testimonials():
    items = Testimonial.query.order_by(Testimonial.sort_order).all()
    return render_template('admin/testimonials.html', testimonials=items)

@admin.route('/testimonials/save', methods=['POST'])
@admin_required
def testimonial_save():
    tid = request.form.get('id')
    t   = Testimonial.query.get(int(tid)) if tid else Testimonial()
    t.reviewer_name  = request.form['reviewer_name'].strip()
    t.reviewer_city  = request.form.get('reviewer_city', '').strip()
    t.avatar_initial = t.reviewer_name[0].upper() if t.reviewer_name else 'A'
    t.rating         = int(request.form.get('rating', 5))
    t.review_text    = request.form['review_text'].strip()
    t.is_active      = 'is_active' in request.form
    t.sort_order     = int(request.form.get('sort_order', 0))
    if not tid:
        db.session.add(t)
    db.session.commit()
    flash('Testimonial saved!', 'success')
    return redirect(url_for('admin.testimonials'))

@admin.route('/testimonials/<int:tid>/delete', methods=['POST'])
@admin_required
def testimonial_delete(tid):
    t = Testimonial.query.get_or_404(tid)
    db.session.delete(t)
    db.session.commit()
    return jsonify({'success': True})

@admin.route('/content')
@admin_required
def content():
    settings      = Setting.all_dict()
    why_cards     = WhyCard.query.order_by(WhyCard.sort_order).all()
    process_steps = ProcessStep.query.order_by(ProcessStep.step_number).all()
    footer_links  = FooterLink.query.order_by(FooterLink.column_name, FooterLink.sort_order).all()
    testimonials  = Testimonial.query.order_by(Testimonial.sort_order).all()
    return render_template('admin/content.html',
        settings=settings, why_cards=why_cards,
        process_steps=process_steps, footer_links=footer_links,
        testimonials=testimonials)

@admin.route('/content/settings', methods=['POST'])
@admin_required
def save_settings():
    editable_keys = [
        'site_name','hero_badge','hero_headline','hero_headline_italic','hero_subtext',
        'hero_stat_1_num','hero_stat_1_label','hero_stat_2_num','hero_stat_2_label',
        'hero_stat_3_num','hero_stat_3_label','trust_badges','why_title','why_subtitle',
        'process_title','process_subtitle','sticky_bar_text','footer_tagline',
        'footer_copyright','contact_phone','contact_email','contact_address',
        'free_delivery_above','delivery_hours',
    ]
    for k in editable_keys:
        if k in request.form:
            Setting.set(k, request.form[k])
    flash('Settings saved!', 'success')
    return redirect(url_for('admin.content'))

@admin.route('/content/why-card/save', methods=['POST'])
@admin_required
def why_card_save():
    cid = request.form.get('id')
    c   = WhyCard.query.get(int(cid)) if cid else WhyCard()
    c.icon        = request.form['icon'].strip()
    c.title       = request.form['title'].strip()
    c.description = request.form.get('description', '').strip()
    c.sort_order  = int(request.form.get('sort_order', 0))
    c.is_active   = 'is_active' in request.form
    if not cid:
        db.session.add(c)
    db.session.commit()
    flash('Why card saved!', 'success')
    return redirect(url_for('admin.content') + '#why')

@admin.route('/content/why-card/<int:cid>/delete', methods=['POST'])
@admin_required
def why_card_delete(cid):
    c = WhyCard.query.get_or_404(cid)
    db.session.delete(c)
    db.session.commit()
    return jsonify({'success': True})

@admin.route('/content/process-step/save', methods=['POST'])
@admin_required
def process_step_save():
    sid = request.form.get('id')
    s   = ProcessStep.query.get(int(sid)) if sid else ProcessStep()
    s.step_number = int(request.form['step_number'])
    s.title       = request.form['title'].strip()
    s.description = request.form.get('description', '').strip()
    s.is_active   = 'is_active' in request.form
    if not sid:
        db.session.add(s)
    db.session.commit()
    flash('Process step saved!', 'success')
    return redirect(url_for('admin.content') + '#process')

@admin.route('/content/process-step/<int:sid>/delete', methods=['POST'])
@admin_required
def process_step_delete(sid):
    s = ProcessStep.query.get_or_404(sid)
    db.session.delete(s)
    db.session.commit()
    return jsonify({'success': True})

@admin.route('/content/footer-link/save', methods=['POST'])
@admin_required
def footer_link_save():
    lid = request.form.get('id')
    lnk = FooterLink.query.get(int(lid)) if lid else FooterLink()
    lnk.column_name = request.form['column_name'].strip()
    lnk.label       = request.form['label'].strip()
    lnk.url         = request.form['url'].strip()
    lnk.sort_order  = int(request.form.get('sort_order', 0))
    lnk.is_active   = 'is_active' in request.form
    if not lid:
        db.session.add(lnk)
    db.session.commit()
    flash('Footer link saved!', 'success')
    return redirect(url_for('admin.content') + '#footer')

@admin.route('/content/footer-link/<int:lid>/delete', methods=['POST'])
@admin_required
def footer_link_delete(lid):
    lnk = FooterLink.query.get_or_404(lid)
    db.session.delete(lnk)
    db.session.commit()
    return jsonify({'success': True})

@admin.route('/categories')
@admin_required
def categories():
    cats = Category.query.order_by(Category.sort_order).all()
    return render_template('admin/categories.html', categories=cats)

@admin.route('/categories/save', methods=['POST'])
@admin_required
def category_save():
    cid  = request.form.get('id')
    slug = request.form.get('slug', '').strip()
    c    = Category.query.get(int(cid)) if cid else Category()
    existing = Category.query.filter_by(slug=slug).first()
    if existing and (not cid or existing.id != int(cid)):
        flash('A category with that slug already exists.', 'danger')
        return redirect(url_for('admin.categories'))
    c.name        = request.form['name'].strip()
    c.slug        = slug
    c.description = request.form.get('description', '').strip()
    c.sort_order  = int(request.form.get('sort_order', 0))
    c.is_active   = 'is_active' in request.form
    if not cid:
        db.session.add(c)
    db.session.commit()
    flash('Category saved!', 'success')
    return redirect(url_for('admin.categories'))

@admin.route('/analytics')
@admin_required
def analytics():
    months_data = []
    for i in range(5, -1, -1):
        d   = datetime.utcnow().replace(day=1) - timedelta(days=i * 28)
        d   = d.replace(day=1)
        rev = db.session.query(func.sum(Order.total_amount)).filter(
            extract('year',  Order.created_at) == d.year,
            extract('month', Order.created_at) == d.month,
            Order.status != 'cancelled'
        ).scalar() or 0
        cnt = Order.query.filter(
            extract('year',  Order.created_at) == d.year,
            extract('month', Order.created_at) == d.month,
        ).count()
        months_data.append({'month': d.strftime('%b %Y'), 'revenue': float(rev), 'orders': cnt})

    top_products = db.session.query(
        OrderItem.product_name,
        func.sum(OrderItem.quantity).label('qty'),
        func.sum(OrderItem.subtotal).label('rev')
    ).group_by(OrderItem.product_name)\
     .order_by(func.sum(OrderItem.subtotal).desc()).limit(5).all()

    return render_template('admin/analytics.html',
        months_data=months_data, top_products=top_products)


# ── GALLERY API ROUTES ────────────────────────────────────

@admin.route('/products/<int:pid>/images/upload', methods=['POST'])
@admin_required
def product_images_upload(pid):
    p = Product.query.get_or_404(pid)
    files = request.files.getlist('images')
    if not files:
        return jsonify({'success': False, 'message': 'No files provided'}), 400

    current_count = ProductImage.query.filter_by(product_id=pid).count()
    added = []
    errors = []

    for f in files:
        if current_count >= 10:
            errors.append(f'{f.filename}: max 10 images per product')
            continue
        if not f or f.filename == '':
            continue
        filename = save_product_image(f)
        if not filename:
            errors.append(f'{f.filename}: unsupported format')
            continue
        # First image auto-set as primary if no primary exists
        is_primary = (current_count == 0 and
                      not ProductImage.query.filter_by(product_id=pid, is_primary=True).first())
        img = ProductImage(
            product_id=pid,
            filename=filename,
            alt_text=p.name,
            is_primary=is_primary,
            is_active=True,
            sort_order=current_count,
        )
        db.session.add(img)
        db.session.flush()
        current_count += 1
        added.append({'id': img.id, 'url': img.url, 'is_primary': img.is_primary,
                      'is_active': img.is_active, 'sort_order': img.sort_order})

    db.session.commit()
    return jsonify({'success': True, 'added': added, 'errors': errors})


@admin.route('/products/images/<int:img_id>/toggle-active', methods=['POST'])
@admin_required
def product_image_toggle_active(img_id):
    img = ProductImage.query.get_or_404(img_id)
    img.is_active = not img.is_active
    db.session.commit()
    return jsonify({'success': True, 'is_active': img.is_active})


@admin.route('/products/images/<int:img_id>/set-primary', methods=['POST'])
@admin_required
def product_image_set_primary(img_id):
    img = ProductImage.query.get_or_404(img_id)
    # Unset all others
    ProductImage.query.filter_by(product_id=img.product_id).update({'is_primary': False})
    img.is_primary = True
    img.is_active  = True  # Primary must be active
    db.session.commit()
    return jsonify({'success': True})


@admin.route('/products/images/<int:img_id>/delete', methods=['POST'])
@admin_required
def product_image_delete(img_id):
    img = ProductImage.query.get_or_404(img_id)
    was_primary = img.is_primary
    product_id  = img.product_id
    delete_product_image(img.filename)
    db.session.delete(img)
    db.session.flush()
    # If deleted was primary, promote first remaining
    if was_primary:
        first = (ProductImage.query
                 .filter_by(product_id=product_id)
                 .order_by(ProductImage.sort_order, ProductImage.id)
                 .first())
        if first:
            first.is_primary = True
    db.session.commit()
    return jsonify({'success': True})


@admin.route('/products/images/reorder', methods=['POST'])
@admin_required
def product_images_reorder():
    data = request.get_json() or {}
    ordered_ids = data.get('ids', [])
    for i, img_id in enumerate(ordered_ids):
        ProductImage.query.filter_by(id=img_id).update({'sort_order': i})
    db.session.commit()
    return jsonify({'success': True})


@admin.route('/products/images/<int:img_id>/alt', methods=['POST'])
@admin_required
def product_image_alt(img_id):
    img = ProductImage.query.get_or_404(img_id)
    data = request.get_json() or {}
    img.alt_text = data.get('alt', '').strip() or img.alt_text
    db.session.commit()
    return jsonify({'success': True})

@admin.route('/settings/password', methods=['GET', 'POST'])
@admin_required
def change_password():
    error = None
    if request.method == 'POST':
        current  = request.form.get('current_password', '')
        new_pw   = request.form.get('new_password', '')
        confirm  = request.form.get('confirm_password', '')
        if not current_user.check_password(current):
            error = 'Current password is incorrect.'
        elif len(new_pw) < 6:
            error = 'New password must be at least 6 characters.'
        elif new_pw != confirm:
            error = 'Passwords do not match.'
        else:
            current_user.set_password(new_pw)
            db.session.commit()
            flash('Password changed successfully!', 'success')
            return redirect(url_for('admin.dashboard'))
    return render_template('admin/change_password.html', error=error)