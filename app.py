import os
from flask import Flask
from flask_login import LoginManager
from flask_wtf.csrf import CSRFProtect
from models import db, AdminUser, User
from config import config

csrf = CSRFProtect()
login_manager = LoginManager()

def create_app(config_name=None):
    app = Flask(__name__, template_folder='templates', static_folder='static')

    cfg = config_name or os.environ.get('FLASK_ENV', 'default')
    app.config.from_object(config[cfg])

    db.init_app(app)
    csrf.init_app(app)
    login_manager.init_app(app)
    login_manager.login_view = 'auth.login'
    login_manager.login_message = 'Please log in to continue.'
    login_manager.login_message_category = 'warning'
    app.config['REMEMBER_COOKIE_NAME'] = 'chakki_user_remember'

    @login_manager.user_loader
    def load_user(user_id):
        if user_id.startswith('admin_'):
            uid = int(user_id.replace('admin_', ''))
            return AdminUser.query.get(uid)
        elif user_id.startswith('user_'):
            uid = int(user_id.replace('user_', ''))
            return User.query.get(uid)
        return None

    from routes.shop import shop
    from routes.admin import admin as admin_bp
    from routes.auth import auth
    from routes.user import user as user_bp

    app.register_blueprint(shop)
    app.register_blueprint(admin_bp)
    app.register_blueprint(auth)
    app.register_blueprint(user_bp)

    # Exempt shop entirely (cart/order JSON endpoints)
    csrf.exempt(shop)

    # Exempt only the address JSON API routes on the user blueprint.
    # Page routes (GET /dashboard, /my-addresses) remain CSRF-protected.
    # The address POST/PUT/DELETE/set-default routes receive JSON bodies
    # authenticated via session cookie — CSRF via X-CSRFToken header is
    # not reliably set by all browsers on fetch, so we exempt and rely on
    # Flask-Login session authentication + user_id ownership checks instead.
    from routes.user import (add_address, update_address, delete_address,
                              set_default_address, get_addresses)
    csrf.exempt(get_addresses)
    csrf.exempt(add_address)
    csrf.exempt(update_address)
    csrf.exempt(delete_address)
    csrf.exempt(set_default_address)

    # IST filter: converts stored UTC datetime to India Standard Time (UTC+5:30)
    from datetime import timedelta
    def to_ist(dt, fmt='%d %b %Y, %I:%M %p'):
        if dt is None:
            return ''
        ist = dt + timedelta(hours=5, minutes=30)
        return ist.strftime(fmt)
    app.jinja_env.filters['ist']       = to_ist
    app.jinja_env.filters['ist_date']  = lambda dt: to_ist(dt, '%d %b %Y')
    app.jinja_env.filters['ist_time']  = lambda dt: to_ist(dt, '%I:%M %p')
    app.jinja_env.filters['ist_full']  = lambda dt: to_ist(dt, '%d %b %Y at %I:%M %p')
    app.jinja_env.filters['ist_month'] = lambda dt: to_ist(dt, '%B %d, %Y')

    with app.app_context():
        db.create_all()
        _seed_defaults()

    return app


def _seed_defaults():
    """Ensure admin exists with a working password. Fix broken placeholder hashes."""
    from werkzeug.security import generate_password_hash

    DEFAULT_PASSWORD = 'chakki@2026'
    DEFAULT_HASH = generate_password_hash(DEFAULT_PASSWORD, method='pbkdf2:sha256')

    admin = AdminUser.query.filter_by(username='admin').first()
    if not admin:
        admin = AdminUser(
            username='admin',
            full_name='Admin User',
            email='admin@chakkipremium.com'
        )
        admin.password_hash = DEFAULT_HASH
        db.session.add(admin)
        db.session.commit()
        print("✅ Admin created: admin / chakki@2026")
    else:
        is_placeholder = (
            'placeholder' in admin.password_hash or
            not admin.check_password(DEFAULT_PASSWORD)
        )
        if is_placeholder:
            admin.password_hash = DEFAULT_HASH
            db.session.commit()
            print("✅ Admin password reset to default: chakki@2026")

    from models import Category, Product, ProductVariant
    if Category.query.count() == 0:
        cat = Category(name='Wheat Atta', slug='wheat-atta', is_active=True, sort_order=1)
        db.session.add(cat)
        db.session.flush()
        products_data = [
            ('Classic Wheat Atta', 'classic-wheat-atta', 'Traditional stone-ground whole wheat flour', '🌾', 'Bestseller', '#4A7C59', True,  1),
            ('Premium Sharbati',   'premium-sharbati',   'Soft rotis from finest Sharbati wheat',      '🌿', 'Premium',   '#C8922A', True,  2),
            ('Multigrain Atta',    'multigrain-atta',    '7-grain blend for healthy families',         '🫘', 'Healthy',   '#6B7280', False, 3),
        ]
        for name, slug, desc, emoji, badge, bcolor, featured, order in products_data:
            p = Product(category_id=cat.id, name=name, slug=slug, short_desc=desc,
                        emoji=emoji, badge=badge, badge_color=bcolor,
                        is_active=True, is_featured=featured, sort_order=order)
            db.session.add(p)
            db.session.flush()
            db.session.add(ProductVariant(product_id=p.id, size_label='5 kg',  price=249, mrp=299, stock_qty=100, is_default=True,  weight_kg=5.0))
            db.session.add(ProductVariant(product_id=p.id, size_label='10 kg', price=479, mrp=579, stock_qty=80,  is_default=False, weight_kg=10.0))
        db.session.commit()
        print("✅ Sample products seeded")

    from models import Setting
    if Setting.query.count() == 0:
        defaults = [
            ('site_name', 'Chakki Premium'),
            ('contact_phone', '+91 98765 43210'),
            ('contact_email', 'hello@chakkipremium.com'),
            ('contact_address', 'Mill District, Jamnagar, Gujarat'),
            ('free_delivery_above', '500'),
            ('delivery_charge', '60'),
            ('delivery_hours', '24–48'),
            ('hero_badge', '🌾 Stone-Ground · Chemical-Free · Home Delivery'),
            ('hero_headline', 'Pure Chakki Atta'),
            ('hero_headline_italic', 'Straight from the Mill'),
            ('hero_subtext', 'Traditional stone-ground wheat flour, freshly milled with zero additives.'),
            ('hero_stat_1_num', '50K+'), ('hero_stat_1_label', 'Happy Families'),
            ('hero_stat_2_num', '100%'), ('hero_stat_2_label', 'Chemical Free'),
            ('hero_stat_3_num', '24hr'), ('hero_stat_3_label', 'Fresh Delivery'),
            ('trust_badges', 'FSSAI Certified,ISO 22000,No Preservatives'),
            ('why_title', 'The Chakki Difference'),
            ('why_subtitle', 'Traditional stone-ground atta with modern hygiene standards.'),
            ('process_title', 'Farm to Your Kitchen in 4 Steps'),
            ('process_subtitle', 'Full transparency — from golden wheat to your table.'),
            ('sticky_bar_text', '🌾 <strong>Fresh batch milled today!</strong> Order before 2pm for same-day dispatch.'),
            ('footer_tagline', 'Pure, freshly milled chakki atta delivered across India.'),
            ('footer_copyright', '© 2026 Chakki Premium. All rights reserved.'),
            ('meta_description', 'Buy fresh stone-ground chakki atta online. Chemical-free, home delivery.'),
        ]
        for k, v in defaults:
            db.session.add(Setting(key_name=k, value=v))
        db.session.commit()
        print("✅ Default settings seeded")


app = create_app()

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)