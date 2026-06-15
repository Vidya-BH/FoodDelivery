<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:if test="${empty order}">
    <%
        response.sendRedirect(request.getContextPath() + "/order");
        return;
    %>
</c:if>
<jsp:include page="header.jsp" />

<section class="py-5 bg-light flex-grow-1 animate-fade-in">
    <div class="container">
        
        <!-- Back navigation link -->
        <div class="mb-4">
            <a href="order" class="btn btn-outline-secondary rounded-pill px-4"><i class="bi bi-arrow-left"></i> Back to Dashboard</a>
        </div>

        <div class="row g-4">
            <!-- Receipt breakdown -->
            <div class="col-lg-8">
                <div class="card border-0 shadow-sm rounded-4 p-4 bg-white">
                    <div class="d-flex justify-content-between align-items-center mb-4 pb-2 border-bottom">
                        <h4 class="fw-bold mb-0 text-dark"><i class="bi bi-file-earmark-text text-primary"></i> Receipt Details</h4>
                        <span class="order-badge badge-${order.status.toLowerCase()} fs-6 py-2 px-3">${order.status}</span>
                    </div>

                    <div class="table-responsive">
                        <table class="table align-middle">
                            <thead>
                                <tr class="text-muted border-bottom">
                                    <th scope="col">Dish Name</th>
                                    <th scope="col" class="text-center">Price</th>
                                    <th scope="col" class="text-center">Quantity</th>
                                    <th scope="col" class="text-end">Subtotal</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="item" items="${orderItems}">
                                    <tr>
                                        <td>
                                            <div class="d-flex align-items-center gap-2">
                                                <i class="bi bi-check-circle text-success fs-5"></i>
                                                <span class="fw-bold text-dark">${item.itemName}</span>
                                            </div>
                                        </td>
                                        <td class="text-center">$${item.price}</td>
                                        <td class="text-center">${item.quantity}</td>
                                        <td class="text-end fw-bold text-dark">$${item.price * item.quantity}</td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>

                    <div class="d-flex justify-content-end align-items-center gap-3 mt-4 fs-5 fw-bold">
                        <span class="text-muted">Grand Total:</span>
                        <span class="text-primary fs-3 fw-extrabold">$${order.totalAmount}</span>
                    </div>
                </div>
            </div>

            <!-- Order Metadata Info -->
            <div class="col-lg-4">
                <div class="card border-0 shadow-sm rounded-4 p-4 bg-white mb-4">
                    <h5 class="fw-bold mb-3 text-dark"><i class="bi bi-info-circle text-primary"></i> Order Metadata</h5>
                    <ul class="list-unstyled mb-0">
                        <li class="mb-2"><strong>Order Reference:</strong> #ORD-${order.id}</li>
                        <li class="mb-2"><strong>Placement Date:</strong> ${order.orderDate}</li>
                        <li class="mb-2"><strong>Restaurant Source:</strong> ${order.restaurantName}</li>
                        <li class="mb-2"><strong>Payment Method:</strong> ${order.paymentMethod}</li>
                    </ul>
                </div>

                <div class="card border-0 shadow-sm rounded-4 p-4 bg-white">
                    <h5 class="fw-bold mb-3 text-dark"><i class="bi bi-geo-alt text-primary"></i> Shipping Address</h5>
                    <p class="text-muted mb-0">${order.deliveryAddress}</p>
                </div>
            </div>
        </div>
    </div>
</section>

<jsp:include page="footer.jsp" />
