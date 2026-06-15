<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:if test="${empty restaurants}">
    <%
        response.sendRedirect(request.getContextPath() + "/restaurant");
        return;
    %>
</c:if>
<jsp:include page="header.jsp" />

<!-- Dashboard Header / Search -->
<section class="py-5 bg-dark text-white text-center">
    <div class="container py-3">
        <h1 class="fw-bold mb-3">Explore Local Restaurants</h1>
        <p class="text-light-accent mb-4">Find your favorite cuisine, rating, or delivery time.</p>
        
        <!-- Search bar -->
        <div class="row justify-content-center">
            <div class="col-md-8 col-lg-6">
                <form action="restaurant" method="GET" class="input-group input-group-lg shadow rounded-pill overflow-hidden">
                    <input type="hidden" name="action" value="search">
                    <input type="text" class="form-control border-0 px-4" name="query" value="${query}" placeholder="Search restaurants or cuisines...">
                    <button class="btn btn-primary px-4" type="submit"><i class="bi bi-search"></i> Search</button>
                </form>
                <c:if test="${not empty query}">
                    <div class="mt-3 text-light-accent">
                        Showing results for "<strong>${query}</strong>" - <a href="restaurant" class="text-warning text-decoration-none">Clear search</a>
                    </div>
                </c:if>
            </div>
        </div>
    </div>
</section>

<!-- Restaurant Catalog -->
<section class="py-5 bg-light flex-grow-1">
    <div class="container">
        <div class="row g-4">
            <c:choose>
                <c:when test="${not empty restaurants}">
                    <c:forEach var="rest" items="${restaurants}">
                        <div class="col-md-6 col-lg-4 animate-fade-in">
                            <div class="food-card">
                                <div class="food-card-img-wrapper">
                                    <img src="${pageContext.request.contextPath}${rest.imagePath}" alt="${rest.name}" class="food-card-img" onerror="this.src='${pageContext.request.contextPath}/images/default_rest.jpg'">
                                    <div class="food-card-badge">
                                        <i class="bi bi-star-fill text-white"></i> ${rest.rating}
                                    </div>
                                </div>
                                <div class="food-card-body">
                                    <div class="d-flex justify-content-between align-items-start mb-2">
                                        <h4 class="food-card-title mb-0">${rest.name}</h4>
                                        <span class="badge bg-light text-dark border">${rest.cuisineType}</span>
                                    </div>
                                    <p class="food-card-desc text-muted mb-3"><i class="bi bi-geo-alt-fill text-danger"></i> ${rest.address}</p>
                                    
                                    <div class="food-card-meta">
                                        <span class="text-muted"><i class="bi bi-clock-history text-primary"></i> ${rest.deliveryTime}</span>
                                        <a href="restaurant?action=view&id=${rest.id}" class="btn btn-primary rounded-pill px-3 py-2">View Menu</a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="col-12 text-center py-5">
                        <i class="bi bi-emoji-frown text-muted" style="font-size: 4rem;"></i>
                        <h3 class="mt-3 fw-bold">No Restaurants Found</h3>
                        <p class="text-muted">We couldn't find any restaurants matching your query. Try searching another term.</p>
                        <a href="restaurant" class="btn btn-primary rounded-pill mt-3">Reset Filters</a>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</section>

<jsp:include page="footer.jsp" />
