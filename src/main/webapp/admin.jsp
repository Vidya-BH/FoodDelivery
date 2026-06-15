<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:if test="${empty orders and empty users and empty restaurants}">
    <%
        response.sendRedirect(request.getContextPath() + "/order");
        return;
    %>
</c:if>
<jsp:include page="header.jsp" />

<section class="py-5 bg-light flex-grow-1">
    <div class="container">
        <h2 class="fw-bold mb-4"><i class="bi bi-shield-lock-fill text-primary"></i> Administrator Console</h2>

        <!-- Bootstrap Nav Tabs -->
        <ul class="nav nav-pills mb-4 gap-2 border-bottom pb-3" id="adminTabs" role="tablist">
            <li class="nav-item" role="presentation">
                <button class="nav-link active rounded-pill px-4 py-2" id="users-tab" data-bs-toggle="pill" data-bs-target="#usersPanel" type="button" role="tab">
                    <i class="bi bi-people"></i> Manage Users
                </button>
            </li>
            <li class="nav-item" role="presentation">
                <button class="nav-link rounded-pill px-4 py-2" id="restaurants-tab" data-bs-toggle="pill" data-bs-target="#restaurantsPanel" type="button" role="tab">
                    <i class="bi bi-shop"></i> Manage Restaurants
                </button>
            </li>
            <li class="nav-item" role="presentation">
                <button class="nav-link rounded-pill px-4 py-2" id="system-orders-tab" data-bs-toggle="pill" data-bs-target="#systemOrdersPanel" type="button" role="tab">
                    <i class="bi bi-receipt"></i> System Orders
                </button>
            </li>
        </ul>

        <!-- Tab Panels -->
        <div class="tab-content animate-fade-in" id="adminTabContent">
            
            <!-- Tab 1: Manage Users -->
            <div class="tab-pane fade show active" id="usersPanel" role="tabpanel">
                <div class="card border-0 shadow-sm rounded-4 p-4 bg-white">
                    <div class="table-responsive">
                        <table class="table align-middle">
                            <thead>
                                <tr class="text-muted border-bottom">
                                    <th scope="col">User ID</th>
                                    <th scope="col">Username</th>
                                    <th scope="col">Email</th>
                                    <th scope="col">Phone</th>
                                    <th scope="col" class="text-center">Role</th>
                                    <th scope="col" class="text-end">Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="usr" items="${users}">
                                    <tr>
                                        <td><strong>#USR-${usr.id}</strong></td>
                                        <td>${usr.username}</td>
                                        <td>${usr.email}</td>
                                        <td>${usr.phone}</td>
                                        <td class="text-center">
                                            <span class="badge ${usr.role == 'ADMIN' ? 'bg-dark' : (usr.role == 'OWNER' ? 'bg-warning text-dark' : 'bg-secondary')}">
                                                ${usr.role}
                                            </span>
                                        </td>
                                        <td class="text-end">
                                            <!-- Block deletion of Admin itself for safety -->
                                            <c:choose>
                                                <c:when test="${usr.role == 'ADMIN'}">
                                                    <span class="text-muted small">Protected</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <!-- Simple form call or action block to delete user if needed (can expand here) -->
                                                    <span class="text-muted small">Active</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <!-- Tab 2: Manage Restaurants -->
            <div class="tab-pane fade" id="restaurantsPanel" role="tabpanel">
                <div class="card border-0 shadow-sm rounded-4 p-4 bg-white">
                    <div class="table-responsive">
                        <table class="table align-middle">
                            <thead>
                                <tr class="text-muted border-bottom">
                                    <th scope="col">Rest ID</th>
                                    <th scope="col">Name</th>
                                    <th scope="col">Cuisine</th>
                                    <th scope="col">Delivery Time</th>
                                    <th scope="col" class="text-center">Rating</th>
                                    <th scope="col" class="text-end">Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="rest" items="${restaurants}">
                                    <tr>
                                        <td><strong>#RST-${rest.id}</strong></td>
                                        <td>
                                            <div class="d-flex align-items-center gap-3">
                                                <img src="${pageContext.request.contextPath}${rest.imagePath}" alt="${rest.name}" class="rounded-3" style="width: 50px; height: 35px; object-fit: cover;" onerror="this.src='${pageContext.request.contextPath}/images/default_rest.jpg'">
                                                <span class="fw-bold">${rest.name}</span>
                                            </div>
                                        </td>
                                        <td>${rest.cuisineType}</td>
                                        <td>${rest.deliveryTime}</td>
                                        <td class="text-center fw-bold text-warning"><i class="bi bi-star-fill"></i> ${rest.rating}</td>
                                        <td class="text-end">
                                            <form action="restaurant" method="POST" onsubmit="return confirm('Are you sure you want to delete this restaurant from the system?')">
                                                <input type="hidden" name="action" value="delete">
                                                <input type="hidden" name="id" value="${rest.id}">
                                                <button type="submit" class="btn btn-sm btn-outline-danger rounded-pill px-3">Delete</button>
                                            </form>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <!-- Tab 3: System Orders -->
            <div class="tab-pane fade" id="systemOrdersPanel" role="tabpanel">
                <div class="card border-0 shadow-sm rounded-4 p-4 bg-white">
                    <div class="table-responsive">
                        <table class="table align-middle">
                            <thead>
                                <tr class="text-muted border-bottom">
                                    <th scope="col">Order ID</th>
                                    <th scope="col">Customer</th>
                                    <th scope="col">Restaurant</th>
                                    <th scope="col">Date & Time</th>
                                    <th scope="col" class="text-center">Total</th>
                                    <th scope="col" class="text-center">Status</th>
                                    <th scope="col" class="text-end">Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="ord" items="${orders}">
                                    <tr>
                                        <td><strong>#ORD-${ord.id}</strong></td>
                                        <td>${ord.customerUsername}</td>
                                        <td>${ord.restaurantName}</td>
                                        <td>${ord.orderDate}</td>
                                        <td class="text-center fw-bold text-primary">$${ord.totalAmount}</td>
                                        <td class="text-center">
                                            <span class="order-badge badge-${ord.status.toLowerCase()}">
                                                ${ord.status}
                                            </span>
                                        </td>
                                        <td class="text-end">
                                            <a href="order?action=details&id=${ord.id}" class="btn btn-sm btn-outline-secondary rounded-pill px-3">Details</a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<jsp:include page="footer.jsp" />
