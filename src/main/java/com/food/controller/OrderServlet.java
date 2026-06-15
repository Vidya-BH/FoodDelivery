package com.food.controller;

import com.food.dao.OrderDAO;
import com.food.dao.RestaurantDAO;
import com.food.dao.UserDAO;
import com.food.daoimpl.OrderDAOImpl;
import com.food.daoimpl.RestaurantDAOImpl;
import com.food.daoimpl.UserDAOImpl;
import com.food.model.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/order")
public class OrderServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private OrderDAO orderDAO;
    private RestaurantDAO restaurantDAO;
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        orderDAO = new OrderDAOImpl();
        restaurantDAO = new RestaurantDAOImpl();
        userDAO = new UserDAOImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String action = request.getParameter("action");
        if ("details".equals(action)) {
            viewOrderDetails(request, response);
            return;
        }

        // Default: Load order history based on role
        loadHistory(request, response, user);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String action = request.getParameter("action");
        if ("checkout".equals(action)) {
            placeOrder(request, response, user, session);
        } else if ("updateStatus".equals(action)) {
            updateStatus(request, response, user);
        } else {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
        }
    }

    private void loadHistory(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        String role = user.getRole();

        if ("CUSTOMER".equals(role)) {
            List<Order> orders = orderDAO.getOrdersByUser(user.getId());
            request.setAttribute("orders", orders);
            request.getRequestDispatcher("/orders.jsp").forward(request, response);
        } else if ("OWNER".equals(role)) {
            List<Restaurant> rests = restaurantDAO.getRestaurantsByOwner(user.getId());
            List<Order> ownerOrders = new ArrayList<>();
            for (Restaurant r : rests) {
                ownerOrders.addAll(orderDAO.getOrdersByRestaurant(r.getId()));
            }
            request.setAttribute("restaurants", rests);
            request.setAttribute("orders", ownerOrders);
            request.getRequestDispatcher("/orders.jsp").forward(request, response);
        } else if ("ADMIN".equals(role)) {
            List<Order> allOrders = orderDAO.getAllOrders();
            List<User> allUsers = userDAO.getAllUsers();
            List<Restaurant> allRests = restaurantDAO.getAllRestaurants();
            request.setAttribute("orders", allOrders);
            request.setAttribute("users", allUsers);
            request.setAttribute("restaurants", allRests);
            request.getRequestDispatcher("/admin.jsp").forward(request, response);
        }
    }

    private void viewOrderDetails(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int orderId = Integer.parseInt(request.getParameter("id"));
            Order order = orderDAO.getOrderById(orderId);
            if (order != null) {
                List<OrderItem> items = orderDAO.getOrderItems(orderId);
                request.setAttribute("order", order);
                request.setAttribute("orderItems", items);
                request.getRequestDispatcher("/orderDetails.jsp").forward(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/order?error=Order not found.");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/order");
        }
    }

    private void placeOrder(HttpServletRequest request, HttpServletResponse response, User user, HttpSession session)
            throws IOException {
        Cart cart = (Cart) session.getAttribute("cart");
        if (cart == null || cart.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/cart.jsp?error=Your cart is empty.");
            return;
        }

        String deliveryAddress = request.getParameter("deliveryAddress");
        String paymentMethod = request.getParameter("paymentMethod");

        if (deliveryAddress == null || deliveryAddress.trim().isEmpty() ||
            paymentMethod == null || paymentMethod.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/checkout.jsp?error=Please specify delivery address and payment method.");
            return;
        }

        // Extract restaurant ID from cart
        int restaurantId = cart.getItems().iterator().next().getMenu().getRestaurantId();

        Order order = new Order();
        order.setUserId(user.getId());
        order.setRestaurantId(restaurantId);
        order.setTotalAmount(cart.getTotalPrice());
        order.setStatus("PENDING");
        order.setDeliveryAddress(deliveryAddress.trim());
        order.setPaymentMethod(paymentMethod.trim());

        List<OrderItem> items = new ArrayList<>();
        for (CartItem ci : cart.getItems()) {
            OrderItem oi = new OrderItem();
            oi.setMenuId(ci.getMenu().getId());
            oi.setQuantity(ci.getQuantity());
            oi.setPrice(ci.getMenu().getPrice());
            items.add(oi);
        }

        boolean success = orderDAO.placeOrder(order, items);
        if (success) {
            cart.clear(); // Clear customer cart on success
            response.sendRedirect(request.getContextPath() + "/order?msg=Order placed successfully!");
        } else {
            response.sendRedirect(request.getContextPath() + "/checkout.jsp?error=Failed to place your order. Please try again.");
        }
    }

    private void updateStatus(HttpServletRequest request, HttpServletResponse response, User user)
            throws IOException {
        String role = user.getRole();
        if (!"OWNER".equals(role) && !"ADMIN".equals(role)) {
            response.sendRedirect(request.getContextPath() + "/index.jsp?error=Unauthorized");
            return;
        }

        try {
            int orderId = Integer.parseInt(request.getParameter("orderId"));
            String status = request.getParameter("status");

            // Simple validation of status values
            if (status != null && (status.equals("PENDING") || status.equals("PREPARING") ||
                                   status.equals("OUT_FOR_DELIVERY") || status.equals("DELIVERED") ||
                                   status.equals("CANCELLED"))) {
                
                boolean success = orderDAO.updateOrderStatus(orderId, status);
                if (success) {
                    response.sendRedirect(request.getContextPath() + "/order?msg=Order status updated.");
                } else {
                    response.sendRedirect(request.getContextPath() + "/order?error=Failed to update status.");
                }
            } else {
                response.sendRedirect(request.getContextPath() + "/order?error=Invalid status.");
            }
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/order?error=Error processing request.");
        }
    }
}
