from flask import (Blueprint, render_template, redirect, url_for,
                   flash, request, jsonify)
from flask_login import login_required, current_user
from models import db, Order, User, AdminUser, Cart, Setting, FooterLink, OrderReview, UserAddress
from functools import wraps
import re

user = Blueprint('user', __name__, url_prefix='/user')

# ── HELPERS ───────────────────────────────────────────────

def _base_ctx():
    s = Setting.all_dict()
    links = FooterLink.query.filter_by(is_active=True)\
                .order_by(FooterLink.column_name, FooterLink.sort_order).all()
    grouped = {}
    for lnk in links:
        grouped.setdefault(lnk.column_name, []).append(lnk)
    cart_count = 0
    if current_user.is_authenticated and isinstance(current_user, User):
        cart_count = db.session.query(db.func.sum(Cart.quantity))\
                       .filter_by(user_id=current_user.id).scalar() or 0
    return {'settings': s, 'cart_count': cart_count, 'footer_links': grouped}


def user_required(f):
    @wraps(f)
    @login_required
    def decorated_function(*args, **kwargs):
        if isinstance(current_user, AdminUser):
            flash('Admin users cannot access the user dashboard.', 'danger')
            return redirect(url_for('admin.dashboard'))
        return f(*args, **kwargs)
    return decorated_function


def _validate_address_data(data):
    errors = {}
    full_name = str(data.get('full_name', '')).strip()
    phone     = str(data.get('phone', '')).strip()
    address   = str(data.get('address_line', '')).strip()
    city      = str(data.get('city', '')).strip()
    pincode   = str(data.get('pincode', '')).strip()

    if not full_name:
        errors['full_name'] = 'Name is required.'
    if not phone or not re.match(r'^[6-9]\d{9}$', phone):
        errors['phone'] = 'Enter a valid 10-digit mobile number.'
    if not address or len(address) < 10:
        errors['address_line'] = 'Enter a complete address (at least 10 characters).'
    if pincode and not re.match(r'^\d{6}$', pincode):
        errors['pincode'] = 'Enter a valid 6-digit PIN code.'

    return errors, full_name, phone, address, city, pincode


# ── DASHBOARD ─────────────────────────────────────────────

@user.route('/dashboard')
@user_required
def dashboard():
    orders    = Order.query.filter_by(user_id=current_user.id)\
                    .order_by(Order.created_at.desc()).all()
    addresses = UserAddress.query.filter_by(user_id=current_user.id)\
                    .order_by(UserAddress.is_default.desc(), UserAddress.created_at.asc()).all()
    ctx = _base_ctx()
    ctx.update(orders=orders, user=current_user, addresses=addresses)
    return render_template('user/dashboard.html', **ctx)


@user.route('/orders')
@user_required
def orders():
    orders = Order.query.filter_by(user_id=current_user.id)\
                  .order_by(Order.created_at.desc()).all()
    ctx = _base_ctx()
    ctx.update(orders=orders, user=current_user, addresses=[])
    return render_template('user/dashboard.html', **ctx)


# ── ORDER DETAIL ──────────────────────────────────────────

@user.route('/orders/<order_number>')
@user_required
def order_detail(order_number):
    order = Order.query.filter_by(
        order_number=order_number,
        user_id=current_user.id
    ).first_or_404()
    ctx = _base_ctx()
    try:
        order_review = order.review
    except Exception:
        order_review = None
    ctx.update(order=order, user=current_user, order_review=order_review)
    return render_template('user/order_detail.html', **ctx)


@user.route('/orders/<order_number>/review', methods=['POST'])
@user_required
def submit_review(order_number):
    order = Order.query.filter_by(
        order_number=order_number, user_id=current_user.id
    ).first_or_404()

    if order.status != 'delivered':
        flash('You can only review delivered orders.', 'danger')
        return redirect(url_for('user.order_detail', order_number=order_number))

    try:
        existing = order.review
    except Exception:
        existing = None

    if existing:
        flash('You have already reviewed this order.', 'warning')
        return redirect(url_for('user.order_detail', order_number=order_number))

    rating = request.form.get('rating', '5')
    text   = request.form.get('review_text', '').strip()

    if not text or len(text) < 10:
        flash('Please write at least 10 characters in your review.', 'danger')
        return redirect(url_for('user.order_detail', order_number=order_number))

    try:
        rating = int(rating)
    except (ValueError, TypeError):
        rating = 5
    if not 1 <= rating <= 5:
        rating = 5

    review = OrderReview(
        order_id=order.id,
        user_id=current_user.id,
        rating=rating,
        review_text=text,
    )
    db.session.add(review)
    db.session.commit()
    flash('Thank you for your review!', 'success')
    return redirect(url_for('user.order_detail', order_number=order_number))


# ── ADDRESS API (CSRF-exempt JSON endpoints) ──────────────
# These routes are authenticated via Flask-Login session cookies.
# They accept JSON bodies, not HTML forms, so CSRF token in body
# is not applicable — exemption is applied in app.py via csrf.exempt(user)
# for these specific methods. Instead we enforce login + user ownership.

@user.route('/addresses', methods=['GET'])
@user_required
def get_addresses():
    addrs = UserAddress.query\
                .filter_by(user_id=current_user.id)\
                .order_by(UserAddress.is_default.desc(), UserAddress.created_at.asc())\
                .all()
    return jsonify({'success': True, 'addresses': [a.to_dict() for a in addrs]})


@user.route('/addresses', methods=['POST'])
@user_required
def add_address():
    data = request.get_json(silent=True) or {}
    errors, full_name, phone, address, city, pincode = _validate_address_data(data)
    if errors:
        return jsonify({'success': False, 'errors': errors}), 422

    label       = str(data.get('label', '')).strip()[:60]
    set_default = str(data.get('is_default', 'false')).lower() in ('true', '1', 'yes')

    existing_count = UserAddress.query.filter_by(user_id=current_user.id).count()
    if set_default or existing_count == 0:
        UserAddress.query.filter_by(user_id=current_user.id).update({'is_default': False})
        set_default = True

    addr = UserAddress(
        user_id      = current_user.id,
        label        = label or None,
        full_name    = full_name,
        phone        = phone,
        address_line = address,
        city         = city or None,
        pincode      = pincode or None,
        is_default   = set_default,
    )
    try:
        db.session.add(addr)
        db.session.commit()
    except Exception as e:
        db.session.rollback()
        return jsonify({'success': False, 'message': f'Database error: {str(e)}'}), 500

    return jsonify({'success': True, 'address': addr.to_dict()})


@user.route('/addresses/<int:addr_id>', methods=['PUT'])
@user_required
def update_address(addr_id):
    addr = UserAddress.query.filter_by(id=addr_id, user_id=current_user.id).first_or_404()
    data = request.get_json(silent=True) or {}
    errors, full_name, phone, address, city, pincode = _validate_address_data(data)
    if errors:
        return jsonify({'success': False, 'errors': errors}), 422

    label       = str(data.get('label', '')).strip()[:60]
    set_default = str(data.get('is_default', 'false')).lower() in ('true', '1', 'yes')

    if set_default:
        UserAddress.query.filter_by(user_id=current_user.id).update({'is_default': False})

    addr.label        = label or None
    addr.full_name    = full_name
    addr.phone        = phone
    addr.address_line = address
    addr.city         = city or None
    addr.pincode      = pincode or None
    addr.is_default   = set_default

    try:
        db.session.commit()
    except Exception as e:
        db.session.rollback()
        return jsonify({'success': False, 'message': f'Database error: {str(e)}'}), 500

    return jsonify({'success': True, 'address': addr.to_dict()})


@user.route('/addresses/<int:addr_id>', methods=['DELETE'])
@user_required
def delete_address(addr_id):
    addr = UserAddress.query.filter_by(id=addr_id, user_id=current_user.id).first_or_404()
    was_default = addr.is_default
    try:
        db.session.delete(addr)
        db.session.commit()
    except Exception as e:
        db.session.rollback()
        return jsonify({'success': False, 'message': f'Database error: {str(e)}'}), 500

    if was_default:
        next_addr = UserAddress.query\
                        .filter_by(user_id=current_user.id)\
                        .order_by(UserAddress.created_at.asc())\
                        .first()
        if next_addr:
            next_addr.is_default = True
            db.session.commit()

    return jsonify({'success': True})


@user.route('/addresses/<int:addr_id>/set-default', methods=['POST'])
@user_required
def set_default_address(addr_id):
    addr = UserAddress.query.filter_by(id=addr_id, user_id=current_user.id).first_or_404()
    try:
        UserAddress.query.filter_by(user_id=current_user.id).update({'is_default': False})
        addr.is_default = True
        db.session.commit()
    except Exception as e:
        db.session.rollback()
        return jsonify({'success': False, 'message': f'Database error: {str(e)}'}), 500

    return jsonify({'success': True, 'address': addr.to_dict()})


# ── DEDICATED ADDRESSES PAGE ──────────────────────────────

@user.route('/my-addresses')
@user_required
def addresses_page():
    addresses = UserAddress.query\
                    .filter_by(user_id=current_user.id)\
                    .order_by(UserAddress.is_default.desc(), UserAddress.created_at.asc())\
                    .all()
    ctx = _base_ctx()
    ctx.update(user=current_user, addresses=addresses)
    return render_template('user/addresses.html', **ctx)