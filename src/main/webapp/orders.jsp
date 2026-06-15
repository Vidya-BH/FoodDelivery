<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:if test="${empty orders and empty restaurants}">
    <%
        response.sendRedirect(request.getContextPath() + "/order");
        return;
    %>
</c:if>
<jsp:include page="header.jsp" />

<section class="py-5 bg-light flex-grow-1">
    <div class="container">
        
        <!-- ================= CUSTOMER VIEW ================= -->
        <c:if test="${sessionScope.user.role == 'CUSTOMER'}">
            <h2 class="fw-bold mb-4"><i class="bi bi-clock-history text-primary"></i> Order History</h2>
            
            <c:choose>
                <c:when test="${not empty orders}">
                    <div class="card border-0 shadow-sm rounded-4 p-4 bg-white animate-fade-in">
                        <div class="table-responsive">
                            <table class="table align-middle">
                                <thead>
                                    <tr class="text-muted border-bottom">
                                        <th scope="col">Order ID</th>
                                        <th scope="col">Restaurant</th>
                                        <th scope="col">Date & Time</th>
                                        <th scope="col" class="text-center">Total Amount</th>
                                        <th scope="col" class="text-center">Status</th>
                                        <th scope="col" class="text-end">Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="ord" items="${orders}">
                                        <tr>
                                            <td><strong>#ORD-${ord.id}</strong></td>
                                            <td>${ord.restaurantName}</td>
                                            <td>${ord.orderDate}</td>
                                            <td class="text-center fw-bold">$${ord.totalAmount}</td>
                                            <td class="text-center">
                                                <span class="order-badge badge-${ord.status.toLowerCase()}">
                                                    ${ord.status}
                                                </span>
                                            </td>
                                            <td class="text-end">
                                                <a href="order?action=details&id=${ord.id}" class="btn btn-sm btn-outline-primary rounded-pill px-3">
                                                    <i class="bi bi-eye"></i> Details
                                                </a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="text-center py-5 bg-white rounded-4 shadow-sm animate-fade-in">
                        <i class="bi bi-journal-x text-muted" style="font-size: 5rem;"></i>
                        <h3 class="fw-bold mt-3">No Orders Placed Yet</h3>
                        <p class="text-muted">You haven't ordered any food items yet. Start browsing now!</p>
                        <a href="restaurant" class="btn btn-primary rounded-pill px-4 py-2 mt-2">Browse Restaurants</a>
                    </div>
                </c:otherwise>
            </c:choose>
        </c:if>

        <!-- ================= RESTAURANT OWNER VIEW ================= -->
        <c:if test="${sessionScope.user.role == 'OWNER'}">
            <h2 class="fw-bold mb-4"><i class="bi bi-speedometer2 text-primary"></i> Restaurant Owner Portal</h2>

            <!-- Bootstrap Nav Tabs -->
            <ul class="nav nav-pills mb-4 gap-2 border-bottom pb-3" id="ownerTabs" role="tablist">
                <li class="nav-item" role="presentation">
                    <button class="nav-link active rounded-pill px-4 py-2" id="orders-tab" data-bs-toggle="pill" data-bs-target="#ordersPanel" type="button" role="tab">
                        <i class="bi bi-receipt"></i> Incoming Orders
                    </button>
                </li>
                <li class="nav-item" role="presentation">
                    <button class="nav-link rounded-pill px-4 py-2" id="restaurant-tab" data-bs-toggle="pill" data-bs-target="#restaurantPanel" type="button" role="tab">
                        <i class="bi bi-shop"></i> My Restaurant & Menu
                    </button>
                </li>
            </ul>

            <!-- Tab Panels -->
            <div class="tab-content" id="ownerTabContent">
                
                <!-- Tab 1: Incoming Orders -->
                <div class="tab-pane fade show active" id="ordersPanel" role="tabpanel">
                    <c:choose>
                        <c:when test="${not empty orders}">
                            <div class="card border-0 shadow-sm rounded-4 p-4 bg-white animate-fade-in">
                                <div class="table-responsive">
                                    <table class="table align-middle">
                                        <thead>
                                            <tr class="text-muted border-bottom">
                                                <th scope="col">Order ID</th>
                                                <th scope="col">Customer</th>
                                                <th scope="col">Restaurant</th>
                                                <th scope="col">Address</th>
                                                <th scope="col" class="text-center">Total</th>
                                                <th scope="col" class="text-center">Current Status</th>
                                                <th scope="col" class="text-center" style="width: 220px;">Advance Status</th>
                                                <th scope="col" class="text-end">Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="ord" items="${orders}">
                                                <tr>
                                                    <td><strong>#ORD-${ord.id}</strong></td>
                                                    <td>${ord.customerUsername}</td>
                                                    <td>${ord.restaurantName}</td>
                                                    <td><small class="text-muted">${ord.deliveryAddress}</small></td>
                                                    <td class="text-center fw-bold">$${ord.totalAmount}</td>
                                                    <td class="text-center">
                                                        <span class="order-badge badge-${ord.status.toLowerCase()}">
                                                            ${ord.status}
                                                        </span>
                                                    </td>
                                                    <td class="text-center">
                                                        <form action="order" method="POST" class="d-flex gap-2 align-items-center">
                                                            <input type="hidden" name="action" value="updateStatus">
                                                            <input type="hidden" name="orderId" value="${ord.id}">
                                                            <select name="status" class="form-select form-select-sm rounded-3" onchange="this.form.submit()">
                                                                <option value="PENDING" <c:if test="${ord.status == 'PENDING'}">selected</c:if>>PENDING</option>
                                                                <option value="PREPARING" <c:if test="${ord.status == 'PREPARING'}">selected</c:if>>PREPARING</option>
                                                                <option value="OUT_FOR_DELIVERY" <c:if test="${ord.status == 'OUT_FOR_DELIVERY'}">selected</c:if>>OUT_FOR_DELIVERY</option>
                                                                <option value="DELIVERED" <c:if test="${ord.status == 'DELIVERED'}">selected</c:if>>DELIVERED</option>
                                                                <option value="CANCELLED" <c:if test="${ord.status == 'CANCELLED'}">selected</c:if>>CANCELLED</option>
                                                            </select>
                                                        </form>
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
                        </c:when>
                        <c:otherwise>
                            <div class="text-center py-5 bg-white rounded-4 shadow-sm animate-fade-in">
                                <i class="bi bi-clock-history text-muted" style="font-size: 5rem;"></i>
                                <h4 class="fw-bold mt-3">No Incoming Orders Yet</h4>
                                <p class="text-muted">Orders placed by customers will appear here in real-time.</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- Tab 2: My Restaurant & Menu -->
                <div class="tab-pane fade" id="restaurantPanel" role="tabpanel">
                    
                    <!-- Case A: No restaurant configured -->
                    <c:choose>
                        <c:when test="${empty restaurants}">
                            <div class="card border-0 shadow-sm rounded-4 p-5 bg-white max-w-600 mx-auto animate-fade-in">
                                <div class="text-center mb-4">
                                    <i class="bi bi-shop text-warning fs-1"></i>
                                    <h3 class="fw-bold mt-2">Register Your Restaurant</h3>
                                    <p class="text-muted">You must list your restaurant before adding food items to the menu.</p>
                                </div>
                                <form action="restaurant" method="POST">
                                    <input type="hidden" name="action" value="add">
                                    <div class="mb-3">
                                        <label for="name" class="form-label">Restaurant Name</label>
                                        <input type="text" class="form-control" id="name" name="name" required>
                                    </div>
                                    <div class="row g-3 mb-3">
                                        <div class="col-md-6">
                                            <label for="cuisineType" class="form-label">Cuisine Type</label>
                                            <input type="text" class="form-control" id="cuisineType" name="cuisineType" placeholder="Italian, Japanese, etc." required>
                                        </div>
                                        <div class="col-md-6">
                                            <label for="deliveryTime" class="form-label">Delivery Time Estimate</label>
                                            <input type="text" class="form-control" id="deliveryTime" name="deliveryTime" placeholder="e.g. 20-30 min" required>
                                        </div>
                                    </div>
                                    <div class="row g-3 mb-3">
                                        <div class="col-md-6">
                                            <label for="phone" class="form-label">Contact Phone</label>
                                            <input type="tel" class="form-control" id="phone" name="phone" required>
                                        </div>
                                        <div class="col-md-6">
                                            <label for="address" class="form-label">Business Address</label>
                                            <input type="text" class="form-control" id="address" name="address" required>
                                        </div>
                                    </div>
                                    <button type="submit" class="btn btn-primary w-100 py-3 rounded-pill mt-3">Register Restaurant</button>
                                </form>
                            </div>
                        </c:when>

                        <!-- Case B: Restaurant is already configured -->
                        <c:otherwise>
                            <c:forEach var="rest" items="${restaurants}">
                                <div class="row g-4 animate-fade-in">
                                    <!-- Restaurant Info Column -->
                                    <div class="col-lg-4">
                                        <div class="card border-0 shadow-sm rounded-4 p-4 bg-white mb-4">
                                            <h4 class="fw-bold mb-3 text-dark"><i class="bi bi-info-circle text-primary"></i> Restaurant Info</h4>
                                            <form action="restaurant" method="POST">
                                                <input type="hidden" name="action" value="update">
                                                <input type="hidden" name="id" value="${rest.id}">
                                                
                                                <div class="mb-3">
                                                    <label class="form-label">Restaurant Name</label>
                                                    <input type="text" class="form-control" name="name" value="${rest.name}" required>
                                                </div>
                                                <div class="mb-3">
                                                    <label class="form-label">Cuisine Type</label>
                                                    <input type="text" class="form-control" name="cuisineType" value="${rest.cuisineType}" required>
                                                </div>
                                                <div class="mb-3">
                                                    <label class="form-label">Delivery Time</label>
                                                    <input type="text" class="form-control" name="deliveryTime" value="${rest.deliveryTime}" required>
                                                </div>
                                                <div class="mb-3">
                                                    <label class="form-label">Address</label>
                                                    <input type="text" class="form-control" name="address" value="${rest.address}" required>
                                                </div>
                                                <div class="mb-3">
                                                    <label class="form-label">Contact Phone</label>
                                                    <input type="text" class="form-control" name="phone" value="${rest.phone}" required>
                                                </div>
                                                <button type="submit" class="btn btn-outline-primary w-100 rounded-pill mt-2">Update Info</button>
                                            </form>
                                        </div>
                                    </div>

                                    <!-- Menu Items Column -->
                                    <div class="col-lg-8">
                                        <div class="card border-0 shadow-sm rounded-4 p-4 bg-white">
                                            <div class="d-flex justify-content-between align-items-center mb-4">
                                                <h4 class="fw-bold mb-0 text-dark"><i class="bi bi-egg-fried text-primary"></i> Menu Management</h4>
                                                <!-- Add Menu Item trigger modal button -->
                                                <button type="button" class="btn btn-primary btn-sm rounded-pill px-3 py-2" data-bs-toggle="modal" data-bs-target="#addMenuModal-${rest.id}">
                                                    <i class="bi bi-plus-circle"></i> Add Dish
                                                </button>
                                            </div>
                                            
                                            <!-- List Menu items -->
                                            <%
                                                // Load menus dynamically since we are looping inside restaurants loops
                                                Restaurant rest = (Restaurant) pageContext.getAttribute("rest");
                                                com.food.dao.MenuDAO mDao = new com.food.daoimpl.MenuDAOImpl();
                                                pageContext.setAttribute("restMenus", mDao.getMenuItemsByRestaurant(rest.getId()));
                                            %>
                                            <div class="table-responsive">
                                                <table class="table align-middle">
                                                    <thead>
                                                        <tr class="text-muted border-bottom">
                                                            <th scope="col">Dish</th>
                                                            <th scope="col" class="text-center">Price</th>
                                                            <th scope="col" class="text-center">Availability</th>
                                                            <th scope="col" class="text-end">Actions</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                        <c:forEach var="menuItem" items="${restMenus}">
                                                            <tr>
                                                                <td>
                                                                    <div class="d-flex align-items-center gap-3">
                                                                        <img src="${pageContext.request.contextPath}${menuItem.imagePath}" alt="${menuItem.itemName}" class="rounded-3 shadow-sm" style="width: 50px; height: 40px; object-fit: cover;" onerror="this.src='${pageContext.request.contextPath}/images/default_food.jpg'">
                                                                        <div>
                                                                            <h6 class="fw-bold mb-0">${menuItem.itemName}</h6>
                                                                            <small class="text-muted text-truncate d-inline-block" style="max-width: 180px;">${menuItem.description}</small>
                                                                        </div>
                                                                    </div>
                                                                </td>
                                                                <td class="text-center fw-bold">$${menuItem.price}</td>
                                                                <td class="text-center">
                                                                    <c:choose>
                                                                        <c:when test="${menuItem.isAvailable}">
                                                                            <span class="badge bg-success">In Stock</span>
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <span class="badge bg-danger">Out of Stock</span>
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </td>
                                                                <td class="text-end">
                                                                    <div class="d-flex gap-2 justify-content-end">
                                                                        <!-- Edit Trigger -->
                                                                        <button type="button" class="btn btn-sm btn-outline-secondary" data-bs-toggle="modal" data-bs-target="#editMenuModal-${menuItem.id}">Edit</button>
                                                                        <!-- Delete Trigger -->
                                                                        <form action="restaurant" method="POST" onsubmit="return confirm('Are you sure you want to delete this dish?')">
                                                                            <input type="hidden" name="action" value="deleteMenu">
                                                                            <input type="hidden" name="menuId" value="${menuItem.id}">
                                                                            <button type="submit" class="btn btn-sm btn-outline-danger">Delete</button>
                                                                        </form>
                                                                    </div>
                                                                </td>
                                                            </tr>

                                                            <!-- MODAL: Edit Menu Item -->
                                                            <div class="modal fade" id="editMenuModal-${menuItem.id}" tabindex="-1" aria-hidden="true">
                                                                <div class="modal-dialog modal-dialog-centered">
                                                                    <div class="modal-content rounded-4 border-0 shadow">
                                                                        <div class="modal-header border-bottom-0">
                                                                            <h5 class="fw-bold modal-title">Edit Menu Dish</h5>
                                                                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                                                        </div>
                                                                        <form action="restaurant" method="POST">
                                                                            <input type="hidden" name="action" value="updateMenu">
                                                                            <input type="hidden" name="menuId" value="${menuItem.id}">
                                                                            <div class="modal-body">
                                                                                <div class="mb-3">
                                                                                    <label class="form-label">Dish Name</label>
                                                                                    <input type="text" class="form-control" name="itemName" value="${menuItem.itemName}" required>
                                                                                </div>
                                                                                <div class="mb-3">
                                                                                    <label class="form-label">Description</label>
                                                                                    <textarea class="form-control" name="description" rows="2">${menuItem.description}</textarea>
                                                                                </div>
                                                                                <div class="row g-2 mb-3">
                                                                                    <div class="col-6">
                                                                                        <label class="form-label">Price ($)</label>
                                                                                        <input type="number" step="0.01" class="form-control" name="price" value="${menuItem.price}" required>
                                                                                    </div>
                                                                                    <div class="col-6 d-flex align-items-end ps-3 pb-2">
                                                                                        <div class="form-check">
                                                                                            <input class="form-check-input" type="checkbox" name="isAvailable" id="isAvail-${menuItem.id}" <c:if test="${menuItem.isAvailable}">checked</c:if>>
                                                                                            <label class="form-check-label" for="isAvail-${menuItem.id}">In Stock</label>
                                                                                        </div>
                                                                                    </div>
                                                                                </div>
                                                                            </div>
                                                                            <div class="modal-footer border-top-0">
                                                                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                                                                                <button type="submit" class="btn btn-primary">Save Changes</button>
                                                                            </div>
                                                                        </form>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </c:forEach>
                                                    </tbody>
                                                </table>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <!-- MODAL: Add Menu Item -->
                                <div class="modal fade" id="addMenuModal-${rest.id}" tabindex="-1" aria-hidden="true">
                                    <div class="modal-dialog modal-dialog-centered">
                                        <div class="modal-content rounded-4 border-0 shadow">
                                            <div class="modal-header border-bottom-0">
                                                <h5 class="fw-bold modal-title">Add Menu Dish</h5>
                                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                            </div>
                                            <form action="restaurant" method="POST">
                                                <input type="hidden" name="action" value="addMenu">
                                                <input type="hidden" name="restaurantId" value="${rest.id}">
                                                <div class="modal-body">
                                                    <div class="mb-3">
                                                        <label class="form-label">Dish Name</label>
                                                        <input type="text" class="form-control" name="itemName" required>
                                                    </div>
                                                    <div class="mb-3">
                                                        <label class="form-label">Description</label>
                                                        <textarea class="form-control" name="description" rows="2" placeholder="Describe the taste and key ingredients..."></textarea>
                                                    </div>
                                                    <div class="mb-3">
                                                        <label class="form-label">Price ($)</label>
                                                        <input type="number" step="0.01" class="form-control" name="price" placeholder="9.99" required>
                                                    </div>
                                                </div>
                                                <div class="modal-footer border-top-0">
                                                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                                                    <button type="submit" class="btn btn-primary">Add Dish</button>
                                                </div>
                                            </form>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </c:if>
    </div>
</section>

<jsp:include page="footer.jsp" />
