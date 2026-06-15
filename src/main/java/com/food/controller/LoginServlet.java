package com.food.controller;

import com.food.dao.UserDAO;
import com.food.daoimpl.UserDAOImpl;
import com.food.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet({"/login", "/logout"})
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAOImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();
        
        if ("/logout".equals(path)) {
            HttpSession session = request.getSession(false);
            if (session != null) {
                session.invalidate();
            }
            response.sendRedirect(request.getContextPath() + "/login.jsp?msg=Logged out successfully.");
        } else {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        if (username == null || username.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=Please fill in all fields.");
            return;
        }

        User user = userDAO.loginUser(username.trim(), password);

        if (user != null) {
            HttpSession session = request.getSession(true);
            session.setAttribute("user", user);
            
            // Instantiating cart for customer session
            if ("CUSTOMER".equals(user.getRole())) {
                session.setAttribute("cart", new com.food.model.Cart());
            }

            // Redirect based on role
            switch (user.getRole()) {
                case "CUSTOMER":
                    response.sendRedirect(request.getContextPath() + "/home.jsp");
                    break;
                case "OWNER":
                    response.sendRedirect(request.getContextPath() + "/orders.jsp");
                    break;
                case "ADMIN":
                    response.sendRedirect(request.getContextPath() + "/admin.jsp");
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/index.jsp");
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=Invalid username or password.");
        }
    }
}
