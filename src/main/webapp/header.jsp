<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    // Prevent back-button caching of sensitive pages
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SmartFood - Premium Food Delivery</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Custom Premium Styles -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
</head>
<body>

    <!-- Dynamic Header Navbar -->
    <nav class="navbar navbar-expand-lg navbar-dark sticky-top">
        <div class="container">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/index.jsp">
                <i class="bi bi-lightning-charge-fill text-warning"></i> Smart<span>Food</span>
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                    <c:choose>
                        <c:when test="${not empty sessionScope.user}">
                            <c:if test="${sessionScope.user.role == 'CUSTOMER'}">
                                <li class="nav-item">
                                    <a class="nav-link" href="${pageContext.request.contextPath}/restaurant"><i class="bi bi-shop"></i> Browse Restaurants</a>
                                </li>
                                <li class="nav-item">
                                    <a class="nav-link" href="${pageContext.request.contextPath}/order"><i class="bi bi-clock-history"></i> My Orders</a>
                                </li>
                            </c:if>
                            <c:if test="${sessionScope.user.role == 'OWNER'}">
                                <li class="nav-item">
                                    <a class="nav-link" href="${pageContext.request.contextPath}/order"><i class="bi bi-graph-up-arrow"></i> Owner Dashboard</a>
                                </li>
                            </c:if>
                            <c:if test="${sessionScope.user.role == 'ADMIN'}">
                                <li class="nav-item">
                                    <a class="nav-link" href="${pageContext.request.contextPath}/order"><i class="bi bi-shield-lock"></i> Admin Console</a>
                                </li>
                            </c:if>
                        </c:when>
                        <c:otherwise>
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/index.jsp">Home</a>
                            </li>
                        </c:otherwise>
                    </c:choose>
                </ul>
                <div class="d-flex align-items-center gap-3">
                    <c:choose>
                        <c:when test="${not empty sessionScope.user}">
                            <c:if test="${sessionScope.user.role == 'CUSTOMER'}">
                                <a href="${pageContext.request.contextPath}/cart.jsp" class="btn position-relative text-white p-2">
                                    <i class="bi bi-cart3 fs-4"></i>
                                    <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger cart-badge" 
                                          style="display: ${not empty sessionScope.cart and sessionScope.cart.totalQuantity > 0 ? 'inline-block' : 'none'};">
                                        ${sessionScope.cart.totalQuantity}
                                    </span>
                                </a>
                            </c:if>
                            <span class="text-light-accent d-none d-md-inline"><i class="bi bi-person-circle"></i> Hello, <strong>${sessionScope.user.username}</strong></span>
                            <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline-light nav-btn-outline rounded-pill px-3 py-1">Logout</a>
                        </c:when>
                        <c:otherwise>
                            <a href="${pageContext.request.contextPath}/login.jsp" class="btn text-white me-2">Login</a>
                            <a href="${pageContext.request.contextPath}/register.jsp" class="btn nav-btn">Sign Up</a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </nav>

    <!-- Global Toast/Alert Container for Messaging -->
    <c:if test="${not empty param.error}">
        <div class="container mt-3">
            <div class="alert alert-danger alert-dismissible fade show rounded-3" role="alert">
                <i class="bi bi-exclamation-triangle-fill"></i> ${param.error}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </div>
    </c:if>
    <c:if test="${not empty param.msg}">
        <div class="container mt-3">
            <div class="alert alert-success alert-dismissible fade show rounded-3" role="alert">
                <i class="bi bi-check-circle-fill"></i> ${param.msg}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </div>
    </c:if>
