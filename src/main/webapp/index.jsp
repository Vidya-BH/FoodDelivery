<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:include page="header.jsp" />

<!-- Hero Section -->
<section class="hero-section text-center text-md-start">
    <div class="container">
        <div class="row align-items-center g-5">
            <div class="col-lg-6 animate-fade-in">
                <span class="badge bg-warning text-dark fw-bold mb-3 px-3 py-2 rounded-pill"><i class="bi bi-star-fill"></i> Best Food Delivery System</span>
                <h1 class="hero-title">Delicious Food, Delivered <span>Straight To Your Door</span></h1>
                <p class="lead text-light-accent mb-4">Craving pizza, sushi, or gourmet burgers? Browse top local kitchens, customize your meals, and track delivery in real-time with zero hassle.</p>
                <div class="d-flex flex-column flex-sm-row gap-3">
                    <a href="${pageContext.request.contextPath}/restaurant" class="btn btn-primary btn-lg rounded-pill px-4 py-3"><i class="bi bi-search"></i> Order Now</a>
                    <a href="${pageContext.request.contextPath}/register.jsp?role=OWNER" class="btn btn-outline-light btn-lg rounded-pill px-4 py-3"><i class="bi bi-shop"></i> Partner with Us</a>
                </div>
            </div>
            <div class="col-lg-6 text-center animate-fade-in">
                <!-- Stacked floating cards mockup or high-quality food image -->
                <img src="${pageContext.request.contextPath}/images/burger_rest.jpg" alt="Premium Burger" class="img-fluid rounded-4 shadow-lg border border-secondary" style="max-height: 400px; object-fit: cover; width: 100%;">
            </div>
        </div>
    </div>
</section>

<!-- Categories Section -->
<section class="py-5 bg-white">
    <div class="container py-4">
        <div class="text-center mb-5">
            <h2 class="fw-bold">Popular Food Categories</h2>
            <p class="text-muted">Explore hand-crafted cuisines tailored to your cravings.</p>
        </div>
        <div class="row g-4 justify-content-center">
            <div class="col-6 col-md-3">
                <div class="card border-0 text-center shadow-sm p-4 hover-shadow rounded-4 transition" style="cursor: pointer;" onclick="location.href='restaurant?action=search&query=Italian'">
                    <div class="bg-light p-3 rounded-circle d-inline-block mb-3">
                        <span class="fs-1">🍕</span>
                    </div>
                    <h5 class="fw-bold">Italian</h5>
                    <p class="text-muted mb-0">3 Restaurants</p>
                </div>
            </div>
            <div class="col-6 col-md-3">
                <div class="card border-0 text-center shadow-sm p-4 hover-shadow rounded-4 transition" style="cursor: pointer;" onclick="location.href='restaurant?action=search&query=Japanese'">
                    <div class="bg-light p-3 rounded-circle d-inline-block mb-3">
                        <span class="fs-1">🍣</span>
                    </div>
                    <h5 class="fw-bold">Japanese</h5>
                    <p class="text-muted mb-0">3 Restaurants</p>
                </div>
            </div>
            <div class="col-6 col-md-3">
                <div class="card border-0 text-center shadow-sm p-4 hover-shadow rounded-4 transition" style="cursor: pointer;" onclick="location.href='restaurant?action=search&query=American'">
                    <div class="bg-light p-3 rounded-circle d-inline-block mb-3">
                        <span class="fs-1">🍔</span>
                    </div>
                    <h5 class="fw-bold">American</h5>
                    <p class="text-muted mb-0">3 Restaurants</p>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- Features Info -->
<section class="py-5 bg-light">
    <div class="container py-4">
        <div class="row g-5 align-items-center">
            <div class="col-lg-6">
                <img src="${pageContext.request.contextPath}/images/pizza_rest.jpg" alt="Premium Dining" class="img-fluid rounded-4 shadow-lg" style="max-height: 400px; object-fit: cover; width:100%;">
            </div>
            <div class="col-lg-6">
                <h2 class="fw-bold mb-4">Why Food Lovers Choose SmartFood?</h2>
                
                <div class="d-flex align-items-start gap-3 mb-4">
                    <div class="bg-primary text-white p-2 rounded-3 fs-4"><i class="bi bi-lightning-charge"></i></div>
                    <div>
                        <h5 class="fw-bold mb-1">Ultra-Fast Delivery</h5>
                        <p class="text-muted">Fresh, hot food arriving at your doorstep in less than 30 minutes average.</p>
                    </div>
                </div>

                <div class="d-flex align-items-start gap-3 mb-4">
                    <div class="bg-primary text-white p-2 rounded-3 fs-4"><i class="bi bi-shield-check"></i></div>
                    <div>
                        <h5 class="fw-bold mb-1">Verified Partners</h5>
                        <p class="text-muted">We source only the cleanest, highest-rated local restaurants in town.</p>
                    </div>
                </div>

                <div class="d-flex align-items-start gap-3">
                    <div class="bg-primary text-white p-2 rounded-3 fs-4"><i class="bi bi-sliders"></i></div>
                    <div>
                        <h5 class="fw-bold mb-1">Complete Flexiblity</h5>
                        <p class="text-muted">Easily modify quantities, add special instructions, and select dynamic order statuses.</p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<jsp:include page="footer.jsp" />
