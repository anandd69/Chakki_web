/* ============================================================
   CHAKKI PREMIUM — Main JavaScript
   ============================================================ */

function getCsrfToken() {
    const meta = document.querySelector('meta[name="csrf-token"]');
    return meta ? meta.getAttribute('content') : '';
}

// ── TOAST ────────────────────────────────────────────────
function showToast(message, type = 'info', duration = 3500) {
    const container = document.getElementById('toast-container');
    if (!container) return;
    const toast = document.createElement('div');
    toast.className = `toast toast-${type}`;
    toast.textContent = message;
    container.appendChild(toast);
    setTimeout(() => {
        toast.style.animation = 'fadeOut 0.4s ease forwards';
        setTimeout(() => toast.remove(), 400);
    }, duration);
}

// ── CART BADGE ───────────────────────────────────────────
function updateCartBadge(count) {
    const badge = document.getElementById('cartBadge');
    if (!badge) return;
    badge.textContent = count;
    badge.style.display = count > 0 ? 'flex' : 'none';
}

// ── ADD TO CART ──────────────────────────────────────────
async function addToCart(variantId, qty = 1) {
    try {
        const resp = await fetch('/add-to-cart', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json', 'X-CSRFToken': getCsrfToken() },
            body: JSON.stringify({ variant_id: variantId, qty: qty }),
        });
        const data = await resp.json();

        if (resp.status === 401 || data.redirect) {
            // Not logged in — redirect to login
            showToast('Please log in to add items to cart.', 'error', 2000);
            setTimeout(() => { window.location.href = data.redirect || '/auth/login'; }, 1200);
            return { success: false };
        }

        if (data.success) {
            updateCartBadge(data.cart_count);
            showToast(data.message || 'Added to cart! Redirecting...', 'success', 900);
            // Redirect to cart after brief toast
            setTimeout(() => { window.location.href = '/cart'; }, 950);
        } else {
            showToast(data.message || 'Could not add to cart.', 'error');
        }
        return data;
    } catch (err) {
        showToast('Network error. Please try again.', 'error');
        return { success: false };
    }
}

// addToCartSync: used by quick-order/checkout flows — does NOT redirect to cart
async function addToCartSync(variantId, qty = 1) {
    try {
        const resp = await fetch('/add-to-cart', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json', 'X-CSRFToken': getCsrfToken() },
            body: JSON.stringify({ variant_id: variantId, qty: qty }),
        });
        const data = await resp.json();
        if (resp.status === 401 || data.redirect) {
            showToast('Please log in to add items to cart.', 'error', 2000);
            setTimeout(() => { window.location.href = data.redirect || '/auth/login'; }, 1200);
            return { success: false };
        }
        if (data.success) {
            updateCartBadge(data.cart_count);
        } else {
            showToast(data.message || 'Could not add to cart.', 'error');
        }
        return data;
    } catch (err) {
        showToast('Network error. Please try again.', 'error');
        return { success: false };
    }
}

// ── STICKY BAR ───────────────────────────────────────────
(function () {
    const bar = document.getElementById('stickyBar');
    if (!bar) return;
    let shown = false;
    window.addEventListener('scroll', () => {
        if (window.scrollY > 500 && !shown) { bar.classList.add('show'); shown = true; }
        else if (window.scrollY <= 500 && shown) { bar.classList.remove('show'); shown = false; }
    }, { passive: true });
})();

// ── HAMBURGER ────────────────────────────────────────────
(function () {
    const btn = document.getElementById('hamburger');
    const links = document.getElementById('navLinks');
    if (!btn || !links) return;
    btn.addEventListener('click', () => links.classList.toggle('open'));
    document.addEventListener('click', (e) => {
        if (!btn.contains(e.target) && !links.contains(e.target))
            links.classList.remove('open');
    });
})();

// ── SCROLL REVEAL ────────────────────────────────────────
(function () {
    if (!('IntersectionObserver' in window)) {
        document.querySelectorAll('.scroll-reveal').forEach(el => el.classList.add('visible'));
        return;
    }
    const obs = new IntersectionObserver((entries) => {
        entries.forEach(e => { if (e.isIntersecting) { e.target.classList.add('visible'); obs.unobserve(e.target); } });
    }, { threshold: 0.1, rootMargin: '0px 0px -40px 0px' });
    document.querySelectorAll('.scroll-reveal').forEach(el => obs.observe(el));
})();

// ── SMOOTH SCROLL ────────────────────────────────────────
document.querySelectorAll('a[href^="#"]').forEach(a => {
    a.addEventListener('click', function (e) {
        const target = document.querySelector(this.getAttribute('href'));
        if (target) { e.preventDefault(); target.scrollIntoView({ behavior: 'smooth', block: 'start' }); }
    });
});

// ── INPUT SANITIZERS ─────────────────────────────────────
document.querySelectorAll('input[type=tel]').forEach(i => {
    i.addEventListener('input', function () { this.value = this.value.replace(/\D/g, '').slice(0, 10); });
});
document.querySelectorAll('input[name=pincode]').forEach(i => {
    i.addEventListener('input', function () { this.value = this.value.replace(/\D/g, '').slice(0, 6); });
});

// ── ACTIVE NAV ───────────────────────────────────────────
(function () {
    const path = window.location.pathname;
    document.querySelectorAll('.nav-links a').forEach(a => {
        const href = a.getAttribute('href');
        if (href === path || (path.startsWith('/products') && href && href.includes('/products')))
            a.classList.add('active');
    });
})();