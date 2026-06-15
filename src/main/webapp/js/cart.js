// AJAX Shopping Cart Management

function addToCart(menuId, itemName) {
    const qtyInput = document.getElementById('qty-' + menuId);
    const quantity = qtyInput ? qtyInput.value : 1;

    const params = new URLSearchParams();
    params.append('action', 'add');
    params.append('menuId', menuId);
    params.append('quantity', quantity);
    params.append('ajax', 'true');

    fetch('cart', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
            'X-Requested-With': 'XMLHttpRequest'
        },
        body: params
    })
    .then(response => {
        if (!response.ok) {
            throw new Error('Network response was not ok');
        }
        return response.json();
    })
    .then(data => {
        if (data.status === 'success') {
            showToast(data.message || (itemName + ' added to cart!'), 'success');
            // Update cart badges in navbar if they exist
            updateNavbarCartBadge(data.totalQuantity);
        } else {
            showToast(data.message || 'Failed to add item.', 'danger');
        }
    })
    .catch(error => {
        console.error('Error adding to cart:', error);
        showToast('Error adding item to cart. Please try again.', 'danger');
    });
}

function updateQuantity(menuId, newQty) {
    if (newQty <= 0) {
        removeItem(menuId);
        return;
    }

    const params = new URLSearchParams();
    params.append('action', 'update');
    params.append('menuId', menuId);
    params.append('quantity', newQty);
    params.append('ajax', 'true');

    fetch('cart', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
            'X-Requested-With': 'XMLHttpRequest'
        },
        body: params
    })
    .then(response => response.json())
    .then(data => {
        if (data.status === 'success') {
            // Update row subtotal
            const priceVal = parseFloat(document.getElementById('price-' + menuId).innerText.replace('$', ''));
            const subtotalEl = document.getElementById('subtotal-' + menuId);
            if (subtotalEl) {
                subtotalEl.innerText = '$' + (priceVal * newQty).toFixed(2);
            }
            
            // Update summary totals
            updateCartSummary(data.totalQuantity, data.totalPrice);
        } else {
            showToast('Failed to update quantity.', 'danger');
        }
    })
    .catch(error => {
        console.error('Error updating cart quantity:', error);
    });
}

function removeItem(menuId) {
    const params = new URLSearchParams();
    params.append('action', 'remove');
    params.append('menuId', menuId);
    params.append('ajax', 'true');

    fetch('cart', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
            'X-Requested-With': 'XMLHttpRequest'
        },
        body: params
    })
    .then(response => response.json())
    .then(data => {
        if (data.status === 'success') {
            const row = document.getElementById('cart-row-' + menuId);
            if (row) {
                row.remove();
            }
            
            updateCartSummary(data.totalQuantity, data.totalPrice);
            
            if (data.totalQuantity === 0) {
                location.reload(); // Refresh to show "Empty Cart" view
            } else {
                showToast('Item removed from cart.', 'success');
            }
        } else {
            showToast('Failed to remove item.', 'danger');
        }
    })
    .catch(error => {
        console.error('Error removing cart item:', error);
    });
}

function updateCartSummary(totalQty, totalPrice) {
    updateNavbarCartBadge(totalQty);
    
    const qtySummaryEl = document.getElementById('cart-summary-qty');
    const priceSummaryEl = document.getElementById('cart-summary-total');
    
    if (qtySummaryEl) qtySummaryEl.innerText = totalQty;
    if (priceSummaryEl) priceSummaryEl.innerText = '$' + totalPrice.toFixed(2);
}

function updateNavbarCartBadge(count) {
    const badges = document.querySelectorAll('.cart-badge');
    badges.forEach(badge => {
        badge.innerText = count;
        if (count > 0) {
            badge.style.display = 'inline-block';
        } else {
            badge.style.display = 'none';
        }
    });
}

function showToast(message, type = 'success') {
    let container = document.getElementById('toast-container');
    if (!container) {
        container = document.createElement('div');
        container.id = 'toast-container';
        container.className = 'toast-container';
        document.body.appendChild(container);
    }

    const toast = document.createElement('div');
    toast.className = `custom-toast`;
    if (type === 'danger') {
        toast.style.borderLeftColor = 'var(--danger)';
    } else if (type === 'warning') {
        toast.style.borderLeftColor = 'var(--warning)';
    }

    const textSpan = document.createElement('span');
    textSpan.innerText = message;
    toast.appendChild(textSpan);

    container.appendChild(toast);

    setTimeout(() => {
        toast.style.opacity = '0';
        toast.style.transform = 'translateY(10px)';
        toast.style.transition = 'all 0.4s ease';
        setTimeout(() => toast.remove(), 400);
    }, 3500);
}
