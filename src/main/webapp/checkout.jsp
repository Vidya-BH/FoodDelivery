<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:if test="${empty sessionScope.cart or sessionScope.cart.isEmpty()}">
    <%
        response.sendRedirect(request.getContextPath() + "/cart.jsp");
        return;
    %>
</c:if>
<jsp:include page="header.jsp" />

<section class="py-5 bg-light flex-grow-1">
    <div class="container">
        <h2 class="fw-bold mb-4"><i class="bi bi-wallet2"></i> Checkout</h2>
        
        <div class="row g-4">
            <!-- Checkout Form details -->
            <div class="col-lg-7 animate-fade-in">
                <div class="card border-0 shadow-sm rounded-4 p-4 bg-white">
                    <h4 class="fw-bold mb-4 text-dark"><i class="bi bi-truck text-primary"></i> Delivery Details</h4>
                    
                    <form action="order" method="POST" novalidate>
                        <input type="hidden" name="action" value="checkout">
                        
                        <div class="mb-3">
                            <label for="customerName" class="form-label">Customer Name</label>
                            <input type="text" class="form-control" id="customerName" value="${sessionScope.user.username}" disabled>
                        </div>

                        <div class="mb-3">
                            <label for="deliveryAddress" class="form-label">Delivery Address</label>
                            <textarea class="form-control" id="deliveryAddress" name="deliveryAddress" rows="3" required>${sessionScope.user.address}</textarea>
                            <div class="form-text">Specify correct shipping address details for prompt delivery.</div>
                        </div>

                        <h4 class="fw-bold mt-5 mb-4 text-dark"><i class="bi bi-credit-card-2-front text-primary"></i> Payment Method</h4>
                        <div class="mb-4">
                            <div class="form-check p-3 border rounded-3 mb-2 d-flex align-items-center gap-3">
                                <input class="form-check-input ms-0" type="radio" name="paymentMethod" id="cod" value="Cash on Delivery" checked>
                                <label class="form-check-label w-100 cursor-pointer" for="cod">
                                    <i class="bi bi-cash-stack text-success fs-5"></i> Cash on Delivery
                                </label>
                            </div>
                            <div class="form-check p-3 border rounded-3 d-flex align-items-center gap-3">
                                <input class="form-check-input ms-0" type="radio" name="paymentMethod" id="card" value="Credit/Debit Card">
                                <label class="form-check-label w-100 cursor-pointer" for="card">
                                    <i class="bi bi-credit-card text-primary fs-5"></i> Credit / Debit Card (Pay on Delivery)
                                </label>
                            </div>
                        </div>

                        <button type="submit" class="btn btn-primary w-100 py-3 rounded-pill fs-5 mt-3 shadow"><i class="bi bi-bag-check"></i> Place Order</button>
                    </form>
                </div>
            </div>

            <!-- Cart items review -->
            <div class="col-lg-5 animate-fade-in">
                <div class="cart-summary bg-white border-0">
                    <h4 class="fw-bold mb-4 pb-2 border-bottom text-dark">Order Items Review</h4>
                    <ul class="list-unstyled mb-0">
                        <c:forEach var="item" items="${sessionScope.cart.getItems()}">
                            <li class="d-flex justify-content-between align-items-center mb-3">
                                <div>
                                    <h6 class="fw-bold mb-0 text-dark">${item.menu.itemName}</h6>
                                    <small class="text-muted">Quantity: ${item.quantity}</small>
                                </div>
                                <span class="fw-semibold text-dark">$${item.subtotal}</span>
                            </li>
                        </c:forEach>
                    </ul>
                    <hr class="my-3">
                    <div class="d-flex justify-content-between mb-3 text-muted">
                        <span>Items Count:</span>
                        <span>${sessionScope.cart.totalQuantity}</span>
                    </div>
                    <div class="d-flex justify-content-between mb-3 text-muted">
                        <span>Shipping/Delivery:</span>
                        <span class="text-success fw-bold">FREE</span>
                    </div>
                    <hr class="my-3">
                    <div class="d-flex justify-content-between align-items-center">
                        <span class="fs-5 fw-bold text-dark">Total Amount:</span>
                        <span class="fs-4 fw-extrabold text-primary">$${sessionScope.cart.totalPrice}</span>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<jsp:include page="footer.jsp" />
