<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
    
    <footer>
        <div class="container">
            <div class="row g-4">
                <div class="col-md-4">
                    <h5 class="text-white fw-bold"><i class="bi bi-lightning-charge-fill text-warning"></i> SmartFood</h5>
                    <p class="text-muted">The ultimate premium platform connecting food lovers with their favorite chefs. Experience visual excellence and speed in every bite.</p>
                </div>
                <div class="col-md-2 offset-md-1">
                    <h5>Quick Links</h5>
                    <ul class="list-unstyled">
                        <li><a href="${pageContext.request.contextPath}/index.jsp">Home</a></li>
                        <li><a href="${pageContext.request.contextPath}/login.jsp">Sign In</a></li>
                        <li><a href="${pageContext.request.contextPath}/register.jsp">Create Account</a></li>
                    </ul>
                </div>
                <div class="col-md-2">
                    <h5>Support</h5>
                    <ul class="list-unstyled">
                        <li><a href="#">FAQ</a></li>
                        <li><a href="#">Help Center</a></li>
                        <li><a href="#">Terms & Privacy</a></li>
                    </ul>
                </div>
                <div class="col-md-3">
                    <h5>Newsletter</h5>
                    <p class="text-muted">Subscribe to get the latest promo codes and restaurant updates.</p>
                    <div class="input-group">
                        <input type="email" class="form-control bg-dark border-secondary text-white" placeholder="Your Email">
                        <button class="btn btn-primary" type="button"><i class="bi bi-send"></i></button>
                    </div>
                </div>
            </div>
            <hr class="border-secondary my-4">
            <div class="d-flex flex-column flex-md-row justify-content-between align-items-center text-muted">
                <p class="mb-0">&copy; 2026 SmartFood System. All rights reserved.</p>
                <div class="d-flex gap-3 mt-3 mt-md-0">
                    <a href="#" class="fs-5"><i class="bi bi-facebook"></i></a>
                    <a href="#" class="fs-5"><i class="bi bi-instagram"></i></a>
                    <a href="#" class="fs-5"><i class="bi bi-twitter"></i></a>
                </div>
            </div>
        </div>
    </footer>

    <!-- Bootstrap 5 Bundle JS (includes Popper) -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <!-- Cart Utility Script -->
    <script src="${pageContext.request.contextPath}/js/cart.js"></script>
    <!-- Validation Script -->
    <script src="${pageContext.request.contextPath}/js/validation.js"></script>
</body>
</html>
