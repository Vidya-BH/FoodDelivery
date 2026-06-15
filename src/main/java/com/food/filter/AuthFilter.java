package com.food.filter;

import com.food.model.User;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebFilter("/*")
public class AuthFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Init if needed
    }

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;
        
        String uri = request.getRequestURI();
        String contextPath = request.getContextPath();
        String path = uri.substring(contextPath.length());

        // Normalize path (remove trailing slashes, keep root as empty/slash)
        if (path.length() > 1 && path.endsWith("/")) {
            path = path.substring(0, path.length() - 1);
        }

        // Allow static resources and public login/register/index pages
        boolean isStaticAsset = path.startsWith("/css/") || path.startsWith("/js/") || path.startsWith("/images/");
        boolean isPublicPage = path.isEmpty() || path.equals("/") || path.equals("/index.jsp") 
                || path.equals("/login.jsp") || path.equals("/register.jsp") 
                || path.equals("/login") || path.equals("/register");

        if (isStaticAsset || isPublicPage) {
            chain.doFilter(req, res);
            return;
        }

        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        // Check if user is logged in
        if (user == null) {
            response.sendRedirect(contextPath + "/login.jsp?error=Please login to access this page.");
            return;
        }

        String role = user.getRole();

        // 1. Admin Page Authorization
        if (path.contains("admin.jsp") || path.startsWith("/admin")) {
            if (!"ADMIN".equals(role)) {
                response.sendRedirect(contextPath + "/index.jsp?error=Access denied: Administrators only.");
                return;
            }
        }

        // 2. Customer Page Authorization (browsing, cart, checkout, home)
        boolean isCustomerOnly = path.contains("home.jsp") || path.contains("restaurant.jsp") 
                || path.contains("cart.jsp") || path.contains("checkout.jsp")
                || path.startsWith("/cart") || path.startsWith("/restaurant");

        if (isCustomerOnly && !"CUSTOMER".equals(role)) {
            if ("OWNER".equals(role)) {
                response.sendRedirect(contextPath + "/orders.jsp");
            } else if ("ADMIN".equals(role)) {
                response.sendRedirect(contextPath + "/admin.jsp");
            } else {
                response.sendRedirect(contextPath + "/index.jsp?error=Access denied.");
            }
            return;
        }

        // 3. Restaurant Owner operations (e.g. adding menu items, viewing order panel)
        // If owner tries to go to customer checkout, redirect them
        
        chain.doFilter(req, res);
    }

    @Override
    public void destroy() {
        // Destroy if needed
    }
}
