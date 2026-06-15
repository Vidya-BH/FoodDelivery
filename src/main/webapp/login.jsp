<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:include page="header.jsp" />

<div class="container py-5 my-5 flex-grow-1 d-flex align-items-center justify-content-center">
    <div class="w-100" style="max-width: 450px;">
        <div class="glass-card animate-fade-in">
            <div class="text-center mb-4">
                <i class="bi bi-shield-lock-fill text-primary fs-1"></i>
                <h2 class="fw-bold mt-2">Welcome Back</h2>
                <p class="text-muted">Sign in to start ordering delicious food</p>
            </div>
            
            <form action="login" method="POST">
                <div class="mb-3">
                    <label for="username" class="form-label">Username</label>
                    <div class="input-group">
                        <span class="input-group-text bg-white border-end-0 text-muted"><i class="bi bi-person"></i></span>
                        <input type="text" class="form-control border-start-0" id="username" name="username" placeholder="Enter username" required>
                    </div>
                </div>
                
                <div class="mb-4">
                    <label for="password" class="form-label">Password</label>
                    <div class="input-group">
                        <span class="input-group-text bg-white border-end-0 text-muted"><i class="bi bi-lock"></i></span>
                        <input type="password" class="form-control border-start-0" id="password" name="password" placeholder="Enter password" required>
                    </div>
                </div>
                
                <button type="submit" class="btn btn-primary w-100 py-3 rounded-3 mb-3">Sign In</button>
            </form>
            
            <div class="text-center text-muted mt-3">
                Don't have an account? <a href="register.jsp" class="text-primary fw-semibold">Sign Up here</a>
            </div>
        </div>
    </div>
</div>

<jsp:include page="footer.jsp" />
