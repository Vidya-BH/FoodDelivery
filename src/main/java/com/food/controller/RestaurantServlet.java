package com.food.controller;

import com.food.dao.MenuDAO;
import com.food.dao.RestaurantDAO;
import com.food.daoimpl.MenuDAOImpl;
import com.food.daoimpl.RestaurantDAOImpl;
import com.food.model.Menu;
import com.food.model.Restaurant;
import com.food.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/restaurant")
public class RestaurantServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private RestaurantDAO restaurantDAO;
    private MenuDAO menuDAO;

    @Override
    public void init() throws ServletException {
        restaurantDAO = new RestaurantDAOImpl();
        menuDAO = new MenuDAOImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "view":
                viewRestaurantMenu(request, response);
                break;
            case "search":
                searchRestaurants(request, response);
                break;
            case "list":
            default:
                listRestaurants(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        switch (action) {
            case "add":
                addRestaurant(request, response, user);
                break;
            case "update":
                updateRestaurant(request, response, user);
                break;
            case "delete":
                deleteRestaurant(request, response, user);
                break;
            case "addMenu":
                addMenuItem(request, response, user);
                break;
            case "updateMenu":
                updateMenuItem(request, response, user);
                break;
            case "deleteMenu":
                deleteMenuItem(request, response, user);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/index.jsp");
        }
    }

    private void listRestaurants(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Restaurant> list = restaurantDAO.getAllRestaurants();
        request.setAttribute("restaurants", list);
        request.getRequestDispatcher("/home.jsp").forward(request, response);
    }

    private void searchRestaurants(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String query = request.getParameter("query");
        List<Restaurant> list;
        if (query == null || query.trim().isEmpty()) {
            list = restaurantDAO.getAllRestaurants();
        } else {
            list = restaurantDAO.searchRestaurants(query.trim());
        }
        request.setAttribute("restaurants", list);
        request.setAttribute("query", query);
        request.getRequestDispatcher("/home.jsp").forward(request, response);
    }

    private void viewRestaurantMenu(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr == null) {
            response.sendRedirect(request.getContextPath() + "/home.jsp");
            return;
        }

        try {
            int restaurantId = Integer.parseInt(idStr);
            Restaurant restaurant = restaurantDAO.getRestaurantById(restaurantId);
            if (restaurant != null) {
                List<Menu> menuItems = menuDAO.getMenuItemsByRestaurant(restaurantId);
                request.setAttribute("restaurant", restaurant);
                request.setAttribute("menuItems", menuItems);
                request.getRequestDispatcher("/restaurant.jsp").forward(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/home.jsp?error=Restaurant not found.");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/home.jsp");
        }
    }

    private void addRestaurant(HttpServletRequest request, HttpServletResponse response, User owner)
            throws IOException {
        if (!"OWNER".equals(owner.getRole())) {
            response.sendRedirect(request.getContextPath() + "/index.jsp?error=Unauthorized");
            return;
        }

        String name = request.getParameter("name");
        String cuisine = request.getParameter("cuisineType");
        String deliveryTime = request.getParameter("deliveryTime");
        String address = request.getParameter("address");
        String phone = request.getParameter("phone");

        Restaurant rest = new Restaurant(0, name, cuisine, deliveryTime, address, phone, 4.0, "/images/default_rest.jpg", owner.getId());
        boolean success = restaurantDAO.addRestaurant(rest);
        if (success) {
            response.sendRedirect(request.getContextPath() + "/orders.jsp?msg=Restaurant added successfully.");
        } else {
            response.sendRedirect(request.getContextPath() + "/orders.jsp?error=Failed to add restaurant.");
        }
    }

    private void updateRestaurant(HttpServletRequest request, HttpServletResponse response, User owner)
            throws IOException {
        if (!"OWNER".equals(owner.getRole())) {
            response.sendRedirect(request.getContextPath() + "/index.jsp?error=Unauthorized");
            return;
        }

        try {
            int id = Integer.parseInt(request.getParameter("id"));
            Restaurant rest = restaurantDAO.getRestaurantById(id);
            if (rest == null || rest.getOwnerId() != owner.getId()) {
                response.sendRedirect(request.getContextPath() + "/orders.jsp?error=Unauthorized");
                return;
            }

            rest.setName(request.getParameter("name"));
            rest.setCuisineType(request.getParameter("cuisineType"));
            rest.setDeliveryTime(request.getParameter("deliveryTime"));
            rest.setAddress(request.getParameter("address"));
            rest.setPhone(request.getParameter("phone"));

            boolean success = restaurantDAO.updateRestaurant(rest);
            if (success) {
                response.sendRedirect(request.getContextPath() + "/orders.jsp?msg=Restaurant details updated.");
            } else {
                response.sendRedirect(request.getContextPath() + "/orders.jsp?error=Failed to update restaurant.");
            }
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/orders.jsp?error=Invalid inputs.");
        }
    }

    private void deleteRestaurant(HttpServletRequest request, HttpServletResponse response, User user)
            throws IOException {
        if (!"ADMIN".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/index.jsp?error=Unauthorized");
            return;
        }

        try {
            int id = Integer.parseInt(request.getParameter("id"));
            boolean success = restaurantDAO.deleteRestaurant(id);
            if (success) {
                response.sendRedirect(request.getContextPath() + "/admin.jsp?msg=Restaurant deleted successfully.");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin.jsp?error=Failed to delete restaurant.");
            }
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/admin.jsp?error=Invalid request.");
        }
    }

    private void addMenuItem(HttpServletRequest request, HttpServletResponse response, User owner)
            throws IOException {
        if (!"OWNER".equals(owner.getRole())) {
            response.sendRedirect(request.getContextPath() + "/index.jsp?error=Unauthorized");
            return;
        }

        try {
            int restId = Integer.parseInt(request.getParameter("restaurantId"));
            Restaurant rest = restaurantDAO.getRestaurantById(restId);
            if (rest == null || rest.getOwnerId() != owner.getId()) {
                response.sendRedirect(request.getContextPath() + "/orders.jsp?error=Unauthorized");
                return;
            }

            String name = request.getParameter("itemName");
            String desc = request.getParameter("description");
            double price = Double.parseDouble(request.getParameter("price"));
            
            Menu menu = new Menu(0, restId, name, desc, price, true, "/images/default_food.jpg");
            boolean success = menuDAO.addMenuItem(menu);
            if (success) {
                response.sendRedirect(request.getContextPath() + "/orders.jsp?msg=Menu item added.");
            } else {
                response.sendRedirect(request.getContextPath() + "/orders.jsp?error=Failed to add menu item.");
            }
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/orders.jsp?error=Invalid menu inputs.");
        }
    }

    private void updateMenuItem(HttpServletRequest request, HttpServletResponse response, User owner)
            throws IOException {
        if (!"OWNER".equals(owner.getRole())) {
            response.sendRedirect(request.getContextPath() + "/index.jsp?error=Unauthorized");
            return;
        }

        try {
            int menuId = Integer.parseInt(request.getParameter("menuId"));
            Menu menu = menuDAO.getMenuItemById(menuId);
            if (menu == null) {
                response.sendRedirect(request.getContextPath() + "/orders.jsp?error=Item not found.");
                return;
            }

            Restaurant rest = restaurantDAO.getRestaurantById(menu.getRestaurantId());
            if (rest == null || rest.getOwnerId() != owner.getId()) {
                response.sendRedirect(request.getContextPath() + "/orders.jsp?error=Unauthorized");
                return;
            }

            menu.setItemName(request.getParameter("itemName"));
            menu.setDescription(request.getParameter("description"));
            menu.setPrice(Double.parseDouble(request.getParameter("price")));
            menu.setAvailable(request.getParameter("isAvailable") != null);

            boolean success = menuDAO.updateMenuItem(menu);
            if (success) {
                response.sendRedirect(request.getContextPath() + "/orders.jsp?msg=Menu item updated.");
            } else {
                response.sendRedirect(request.getContextPath() + "/orders.jsp?error=Failed to update menu item.");
            }
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/orders.jsp?error=Invalid menu inputs.");
        }
    }

    private void deleteMenuItem(HttpServletRequest request, HttpServletResponse response, User owner)
            throws IOException {
        if (!"OWNER".equals(owner.getRole())) {
            response.sendRedirect(request.getContextPath() + "/index.jsp?error=Unauthorized");
            return;
        }

        try {
            int menuId = Integer.parseInt(request.getParameter("menuId"));
            Menu menu = menuDAO.getMenuItemById(menuId);
            if (menu == null) {
                response.sendRedirect(request.getContextPath() + "/orders.jsp?error=Item not found.");
                return;
            }

            Restaurant rest = restaurantDAO.getRestaurantById(menu.getRestaurantId());
            if (rest == null || rest.getOwnerId() != owner.getId()) {
                response.sendRedirect(request.getContextPath() + "/orders.jsp?error=Unauthorized");
                return;
            }

            boolean success = menuDAO.deleteMenuItem(menuId);
            if (success) {
                response.sendRedirect(request.getContextPath() + "/orders.jsp?msg=Menu item deleted.");
            } else {
                response.sendRedirect(request.getContextPath() + "/orders.jsp?error=Failed to delete menu item.");
            }
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/orders.jsp?error=Invalid action.");
        }
    }
}
