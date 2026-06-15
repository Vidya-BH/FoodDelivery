package com.food.controller;

import com.food.dao.UserDAO;
import com.food.daoimpl.UserDAOImpl;
import com.food.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAOImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/register.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String role = request.getParameter("role"); // CUSTOMER or OWNER

        // Form server-side check
        if (username == null || username.trim().isEmpty() ||
            password == null || password.trim().isEmpty() ||
            email == null || email.trim().isEmpty() ||
            phone == null || phone.trim().isEmpty() ||
            address == null || address.trim().isEmpty() ||
            role == null || role.trim().isEmpty()) {
            
            response.sendRedirect(request.getContextPath() + "/register.jsp?error=All fields are required.");
            return;
        }

        // Validate role input
        if (!"CUSTOMER".equals(role) && !"OWNER".equals(role)) {
            response.sendRedirect(request.getContextPath() + "/register.jsp?error=Invalid role selected.");
            return;
        }

        // Check duplicates
        if (userDAO.getUserByUsername(username.trim()) != null) {
            response.sendRedirect(request.getContextPath() + "/register.jsp?error=Username is already taken.");
            return;
        }

        if (userDAO.getUserByEmail(email.trim()) != null) {
            response.sendRedirect(request.getContextPath() + "/register.jsp?error=Email is already registered.");
            return;
        }

        User newUser = new User(0, username.trim(), password, email.trim(), phone.trim(), address.trim(), role);
        boolean success = userDAO.addUser(newUser);

        if (success) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?msg=Account created successfully. Please login.");
        } else {
            response.sendRedirect(request.getContextPath() + "/register.jsp?error=Registration failed. Please try again.");
        }
    }
}
