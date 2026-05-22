from flask import Blueprint, render_template, request, redirect, url_for, flash, session
from flask_login import login_user, logout_user, login_required, current_user
from models import db, User, Cart, AdminUser, Setting, FooterLink
from datetime import datetime
import re

auth = Blueprint('auth', __name__, url_prefix='/auth')

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
    else:
        cart = session.get('cart', {})
        cart_count = sum(item['qty'] for item in cart.values())

    return {'settings': s, 'cart_count': cart_count, 'footer_links': grouped}

@auth.route('/register', methods=['GET', 'POST'])
def register():
    if current_user.is_authenticated and isinstance(current_user, User):
        return redirect(url_for('user.dashboard'))

    if request.method == 'POST':
        email            = request.form.get('email', '').strip().lower()
        password         = request.form.get('password', '')
        confirm_password = request.form.get('confirm_password', '')
        full_name        = request.form.get('full_name', '').strip()
        phone            = request.form.get('phone', '').strip()

        errors = {}
        if not email or not re.match(r'^[^@]+@[^@]+\.[^@]+$', email):
            errors['email'] = 'Please enter a valid email address.'
        elif User.query.filter_by(email=email).first():
            errors['email'] = 'Email already registered. Please login instead.'

        if not password or len(password) < 6:
            errors['password'] = 'Password must be at least 6 characters.'
        if password != confirm_password:
            errors['confirm_password'] = 'Passwords do not match.'
        if not full_name or len(full_name) < 2:
            errors['full_name'] = 'Please enter your full name.'
        if phone and not re.match(r'^[6-9]\d{9}$', phone):
            errors['phone'] = 'Enter a valid 10-digit Indian mobile number.'

        if errors:
            for msg in errors.values():
                flash(msg, 'danger')
            ctx = _base_ctx()
            ctx.update(email=email, full_name=full_name, phone=phone)
            return render_template('auth/register.html', **ctx)

        user = User(email=email, full_name=full_name, phone=phone or None)
        user.set_password(password)
        db.session.add(user)
        db.session.commit()
        flash('Account created! Please login.', 'success')
        return redirect(url_for('auth.login'))

    ctx = _base_ctx()
    return render_template('auth/register.html', **ctx)

@auth.route('/login', methods=['GET', 'POST'])
def login():
    if current_user.is_authenticated and isinstance(current_user, User):
        return redirect(url_for('user.dashboard'))

    if request.method == 'POST':
        email    = request.form.get('email', '').strip().lower()
        password = request.form.get('password', '')
        remember = 'remember' in request.form

        user = User.query.filter_by(email=email, is_active=True).first()
        if user and user.check_password(password):
            login_user(user, remember=remember)
            user.last_login = datetime.utcnow()
            db.session.commit()
            _merge_guest_cart(user.id)
            next_page = request.args.get('next')
            if next_page and next_page.startswith('/'):
                return redirect(next_page)
            return redirect(url_for('shop.home'))

        flash('Invalid email or password.', 'danger')

    ctx = _base_ctx()
    return render_template('auth/login.html', **ctx)

@auth.route('/logout')
@login_required
def logout():
    logout_user()
    session.pop('cart', None)
    flash('You have been logged out.', 'info')
    return redirect(url_for('shop.home'))

def _merge_guest_cart(user_id):
    guest_cart = session.get('cart', {})
    if not guest_cart:
        return
    for variant_id_str, item in guest_cart.items():
        variant_id = int(variant_id_str)
        qty = item['qty']
        existing = Cart.query.filter_by(user_id=user_id, variant_id=variant_id).first()
        if existing:
            existing.quantity += qty
        else:
            db.session.add(Cart(user_id=user_id, variant_id=variant_id, quantity=qty))
    db.session.commit()
    session.pop('cart', None)
    session.modified = True
