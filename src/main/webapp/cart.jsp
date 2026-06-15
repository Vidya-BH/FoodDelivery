<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="header.jsp" />

<section class="py-5 bg-light flex-grow-1">
    <div class="container">
        <h2 class="fw-bold mb-4"><i class="bi bi-cart3"></i> Shopping Cart</h2>
        
        <c:choose>
            <c:when test="${not empty sessionScope.cart and not sessionScope.cart.isEmpty()}">
                <div class="row g-4">
                    <!-- Cart List -->
                    <div class="col-lg-8 animate-fade-in">
                        <div class="card border-0 shadow-sm rounded-4 p-4 bg-white">
                            <div class="table-responsive">
                                <table class="table align-middle">
                                    <thead>
                                        <tr class="text-muted border-bottom">
                                            <th scope="col">Dish</th>
                                            <th scope="col" class="text-center">Price</th>
                                            <th scope="col" class="text-center" style="width: 120px;">Qty</th>
                                            <th scope="col" class="text-center">Subtotal</th>
                                            <th scope="col"></th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="item" items="${sessionScope.cart.getItems()}">
                                            <tr id="cart-row-${item.menu.id}">
                                                <td>
                                                    <div class="d-flex align-items-center gap-3">
                                                        <img src="${pageContext.request.contextPath}${item.menu.imagePath}" alt="${item.menu.itemName}" class="rounded-3 shadow-sm" style="width: 70px; height: 50px; object-fit: cover;" onerror="this.src='${pageContext.request.contextPath}/images/default_food.jpg'">
                                                        <div>
                                                            <h6 class="fw-bold mb-0">${item.menu.itemName}</h6>
                                                            <small class="text-muted">Tasty Selection</small>
                                                        </div>
                                                    </div>
                                                </td>
                                                <td class="text-center" id="price-${item.menu.id}">$${item.menu.price}</td>
                                                <td class="text-center">
                                                    <input type="number" value="${item.quantity}" min="1" max="10" 
                                                           class="form-control text-center mx-auto" 
                                                           onchange="updateQuantity(${item.menu.id}, this.value)" 
                                                           style="width: 70px; padding: 0.35rem 0.5rem;">
                                                </td>
                                                <td class="text-center fw-bold text-dark" id="subtotal-${item.menu.id}">$${item.subtotal}</td>
                                                <td class="text-end">
                                                    <button onclick="removeItem(${item.menu.id})" class="btn btn-sm btn-outline-danger border-0 rounded-circle p-2">
                                                        <i class="bi bi-trash fs-5"></i>
                                                    </button>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                            
                            <div class="d-flex justify-content-between align-items-center mt-4">
                                <a href="restaurant" class="btn btn-outline-secondary rounded-pill px-4"><i class="bi bi-arrow-left"></i> Continue Shopping</a>
                                <button onclick="removeItem('clear')" class="btn btn-outline-danger rounded-pill px-4" onclick="location.href='cart?action=clear'">
                                    <i class="bi bi-x-circle"></i> Clear Cart
                                </button>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Cart Summary panel -->
                    <div class="col-lg-4 animate-fade-in">
                        <div class="cart-summary bg-white border-0">
                            <h4 class="fw-bold mb-4 pb-2 border-bottom text-dark">Order Summary</h4>
                            <div class="d-flex justify-content-between mb-3 text-muted">
                                <span>Items Count:</span>
                                <span id="cart-summary-qty" class="fw-semibold text-dark">${sessionScope.cart.totalQuantity}</span>
                            </div>
                            <div class="d-flex justify-content-between mb-3 text-muted">
                                <span>Delivery Fee:</span>
                                <span class="text-success fw-semibold">FREE</span>
                            </div>
                            <hr class="my-3">
                            <div class="d-flex justify-content-between align-items-center mb-4">
                                <span class="fs-5 fw-bold text-dark">Estimated Total:</span>
                                <span id="cart-summary-total" class="fs-4 fw-extrabold text-primary">${sessionScope.cart.totalPrice}</span>
                            </div>
                            
                            <a href="checkout.jsp" class="btn btn-primary w-100 py-3 rounded-pill fs-5 shadow"><i class="bi bi-check2-circle"></i> Proceed to Checkout</a>
                        </div>
                    </div>
                </div>
            </c:when>
            
            <c:otherwise>
                <!-- Empty Cart State -->
                <div class="text-center py-5 bg-white rounded-4 shadow-sm animate-fade-in">
                    <i class="bi bi-cart-x text-muted" style="font-size: 6rem;"></i>
                    <h2 class="fw-bold mt-3">Your Cart is Empty</h2>
                    <p class="text-muted mb-4">Add delicious food items from a restaurant to place an order.</p>
                    <a href="restaurant" class="btn btn-primary btn-lg rounded-pill px-5">Browse Restaurants</a>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</section>

<jsp:include page="footer.jsp" />
