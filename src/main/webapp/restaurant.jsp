<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:if test="${empty restaurant}">
    <%
        response.sendRedirect(request.getContextPath() + "/home.jsp");
        return;
    %>
</c:if>
<jsp:include page="header.jsp" />

<!-- Restaurant Jumbotron Profile -->
<section class="py-5 text-white" style="background: linear-gradient(135deg, #1E293B 0%, #0F172A 100%);">
    <div class="container py-3">
        <div class="row align-items-center g-4">
            <div class="col-md-3 text-center text-md-start">
                <img src="${pageContext.request.contextPath}${restaurant.imagePath}" alt="${restaurant.name}" class="img-fluid rounded-4 shadow-lg border border-secondary" style="max-height: 200px; width: 100%; object-fit: cover;" onerror="this.src='${pageContext.request.contextPath}/images/default_rest.jpg'">
            </div>
            <div class="col-md-9 text-center text-md-start">
                <span class="badge bg-warning text-dark fw-bold mb-2"><i class="bi bi-star-fill"></i> ${restaurant.rating} Rating</span>
                <h1 class="fw-bold mb-2">${restaurant.name}</h1>
                <p class="text-light-accent mb-3"><i class="bi bi-shop"></i> ${restaurant.cuisineType} &nbsp;|&nbsp; <i class="bi bi-clock"></i> ${restaurant.deliveryTime} Delivery</p>
                <div class="d-flex flex-wrap justify-content-center justify-content-md-start gap-3 text-muted fs-6">
                    <span><i class="bi bi-geo-alt"></i> ${restaurant.address}</span>
                    <span><i class="bi bi-telephone"></i> ${restaurant.phone}</span>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- Menu Catalog Section -->
<section class="py-5 bg-light flex-grow-1">
    <div class="container">
        <h2 class="fw-bold mb-4">Restaurant Menu</h2>
        
        <div class="row g-4">
            <c:choose>
                <c:when test="${not empty menuItems}">
                    <c:forEach var="item" items="${menuItems}">
                        <div class="col-md-6 col-lg-4 animate-fade-in">
                            <div class="food-card">
                                <div class="food-card-img-wrapper">
                                    <img src="${pageContext.request.contextPath}${item.imagePath}" alt="${item.itemName}" class="food-card-img" onerror="this.src='${pageContext.request.contextPath}/images/default_food.jpg'">
                                    <c:if test="${not item.isAvailable}">
                                        <div class="position-absolute top-0 start-0 w-100 h-100 bg-dark bg-opacity-75 d-flex align-items-center justify-content-center">
                                            <span class="badge bg-danger fs-6 py-2 px-3">OUT OF STOCK</span>
                                        </div>
                                    </c:if>
                                </div>
                                <div class="food-card-body">
                                    <h4 class="food-card-title">${item.itemName}</h4>
                                    <p class="food-card-desc">${item.description}</p>
                                    
                                    <div class="food-card-meta">
                                        <span class="food-price">$${item.price}</span>
                                        <c:choose>
                                            <c:when test="${item.isAvailable}">
                                                <div class="d-flex align-items-center gap-2">
                                                    <input type="number" id="qty-${item.id}" value="1" min="1" max="10" class="form-control text-center" style="width: 65px; padding: 0.4rem 0.5rem;">
                                                    <button onclick="addToCart(${item.id}, '${item.itemName}')" class="btn btn-primary rounded-pill px-3 py-2">
                                                        <i class="bi bi-plus-lg"></i> Add
                                                    </button>
                                                </div>
                                            </c:when>
                                            <c:otherwise>
                                                <button class="btn btn-secondary rounded-pill px-3 py-2" disabled>Unavailable</button>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="col-12 text-center py-5">
                        <i class="bi bi-egg-fried text-muted" style="font-size: 4rem;"></i>
                        <h3 class="mt-3 fw-bold">Menu is Empty</h3>
                        <p class="text-muted">This restaurant hasn't added any menu items yet.</p>
                        <a href="restaurant" class="btn btn-secondary rounded-pill mt-3">Back to Restaurants</a>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</section>

<jsp:include page="footer.jsp" />
