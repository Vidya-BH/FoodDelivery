<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="header.jsp" />

<div class="container py-5 my-3 flex-grow-1 d-flex align-items-center justify-content-center">
    <div class="w-100" style="max-width: 550px;">
        <div class="glass-card animate-fade-in">
            <div class="text-center mb-4">
                <i class="bi bi-person-plus-fill text-primary fs-1"></i>
                <h2 class="fw-bold mt-2">Create Account</h2>
                <p class="text-muted">Register to buy delicious food or partner with us</p>
            </div>
            
            <form action="register" method="POST" novalidate>
                <div class="row g-3">
                    <div class="col-md-6">
                        <label for="username" class="form-label">Username</label>
                        <div class="input-group">
                            <span class="input-group-text bg-white border-end-0 text-muted"><i class="bi bi-person"></i></span>
                            <input type="text" class="form-control border-start-0" id="username" name="username" placeholder="Username" required>
                        </div>
                    </div>
                    
                    <div class="col-md-6">
                        <label for="password" class="form-label">Password</label>
                        <div class="input-group">
                            <span class="input-group-text bg-white border-end-0 text-muted"><i class="bi bi-lock"></i></span>
                            <input type="password" class="form-control border-start-0" id="password" name="password" placeholder="Min 6 chars" required>
                        </div>
                    </div>
                    
                    <div class="col-md-6">
                        <label for="email" class="form-label">Email Address</label>
                        <div class="input-group">
                            <span class="input-group-text bg-white border-end-0 text-muted"><i class="bi bi-envelope"></i></span>
                            <input type="email" class="form-control border-start-0" id="email" name="email" placeholder="example@mail.com" required>
                        </div>
                    </div>

                    <div class="col-md-6">
                        <label for="phone" class="form-label">Phone Number</label>
                        <div class="input-group">
                            <span class="input-group-text bg-white border-end-0 text-muted"><i class="bi bi-phone"></i></span>
                            <input type="tel" class="form-control border-start-0" id="phone" name="phone" placeholder="10-digit number" required>
                        </div>
                    </div>
                    
                    <div class="col-12">
                        <label class="form-label">Account Role</label>
                        <div class="d-flex gap-4">
                            <div class="form-check">
                                <input class="form-check-input" type="radio" name="role" id="roleCustomer" value="CUSTOMER" 
                                       <c:if test="${empty param.role or param.role == 'CUSTOMER'}">checked</c:if>>
                                <label class="form-check-label" for="roleCustomer">
                                    <i class="bi bi-bag-heart text-primary"></i> Customer (Order Food)
                                </label>
                            </div>
                            <div class="form-check">
                                <input class="form-check-input" type="radio" name="role" id="roleOwner" value="OWNER"
                                       <c:if test="${param.role == 'OWNER'}">checked</c:if>>
                                <label class="form-check-label" for="roleOwner">
                                    <i class="bi bi-shop text-warning"></i> Restaurant Owner
                                </label>
                            </div>
                        </div>
                    </div>

                    <div class="col-12">
                        <label for="address" class="form-label">Delivery/Business Address</label>
                        <textarea class="form-control" id="address" name="address" rows="3" placeholder="Enter complete address details..." required></textarea>
                    </div>
                </div>
                
                <button type="submit" class="btn btn-primary w-100 py-3 rounded-3 mt-4 mb-3">Sign Up</button>
            </form>
            
            <div class="text-center text-muted">
                Already have an account? <a href="login.jsp" class="text-primary fw-semibold">Sign In here</a>
            </div>
        </div>
    </div>
</div>

<jsp:include page="footer.jsp" />
