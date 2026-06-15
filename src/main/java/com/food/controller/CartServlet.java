package com.food.controller;

import com.food.dao.MenuDAO;
import com.food.daoimpl.MenuDAOImpl;
import com.food.model.Cart;
import com.food.model.Menu;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/cart")
public class CartServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private MenuDAO menuDAO;

    @Override
    public void init() throws ServletException {
        menuDAO = new MenuDAOImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/cart.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(true);
        Cart cart = (Cart) session.getAttribute("cart");
        if (cart == null) {
            cart = new Cart();
            session.setAttribute("cart", cart);
        }

        String action = request.getParameter("action");
        if (action == null) {
            response.sendRedirect(request.getContextPath() + "/cart.jsp");
            return;
        }

        boolean isAjax = "true".equals(request.getParameter("ajax")) || 
                         "XMLHttpRequest".equals(request.getHeader("X-Requested-With"));

        try {
            switch (action) {
                case "add":
                    int menuId = Integer.parseInt(request.getParameter("menuId"));
                    int quantity = Integer.parseInt(request.getParameter("quantity"));
                    Menu menu = menuDAO.getMenuItemById(menuId);
                    
                    if (menu != null) {
                        // Enforce single-restaurant rule
                        if (!cart.isEmpty()) {
                            int existingRestId = cart.getItems().iterator().next().getMenu().getRestaurantId();
                            if (existingRestId != menu.getRestaurantId()) {
                                if (isAjax) {
                                    response.setContentType("application/json");
                                    response.getWriter().write("{\"status\":\"error\", \"message\":\"Cart already contains items from another restaurant. Please clear it first.\"}");
                                } else {
                                    response.sendRedirect(request.getContextPath() + "/restaurant?action=view&id=" + menu.getRestaurantId() 
                                            + "&error=Your cart contains items from a different restaurant. Clear it first.");
                                }
                                return;
                            }
                        }
                        
                        cart.addItem(menu, quantity);
                        if (isAjax) {
                            response.setContentType("application/json");
                            response.getWriter().write(String.format(
                                "{\"status\":\"success\", \"message\":\"%s added to cart!\", \"totalQuantity\":%d, \"totalPrice\":%.2f}",
                                menu.getItemName(), cart.getTotalQuantity(), cart.getTotalPrice()
                            ));
                            return;
                        }
                    }
                    break;

                case "update":
                    int updateId = Integer.parseInt(request.getParameter("menuId"));
                    int updateQty = Integer.parseInt(request.getParameter("quantity"));
                    cart.updateQuantity(updateId, updateQty);
                    
                    if (isAjax) {
                        response.setContentType("application/json");
                        response.getWriter().write(String.format(
                            "{\"status\":\"success\", \"totalQuantity\":%d, \"totalPrice\":%.2f}",
                            cart.getTotalQuantity(), cart.getTotalPrice()
                        ));
                        return;
                    }
                    break;

                case "remove":
                    int removeId = Integer.parseInt(request.getParameter("menuId"));
                    cart.removeItem(removeId);
                    
                    if (isAjax) {
                        response.setContentType("application/json");
                        response.getWriter().write(String.format(
                            "{\"status\":\"success\", \"totalQuantity\":%d, \"totalPrice\":%.2f}",
                            cart.getTotalQuantity(), cart.getTotalPrice()
                        ));
                        return;
                    }
                    break;

                case "clear":
                    cart.clear();
                    if (isAjax) {
                        response.setContentType("application/json");
                        response.getWriter().write("{\"status\":\"success\", \"totalQuantity\":0, \"totalPrice\":0.0}");
                        return;
                    }
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            if (isAjax) {
                response.setStatus(500);
                response.getWriter().write("{\"status\":\"error\", \"message\":\"An error occurred.\"}");
                return;
            }
        }

        // Standard fallback redirect
        response.sendRedirect(request.getContextPath() + "/cart.jsp");
    }
}
