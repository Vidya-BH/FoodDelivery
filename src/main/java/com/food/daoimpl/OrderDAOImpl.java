package com.food.daoimpl;

import com.food.dao.OrderDAO;
import com.food.model.Order;
import com.food.model.OrderItem;
import com.food.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class OrderDAOImpl implements OrderDAO {

    @Override
    public boolean placeOrder(Order order, List<OrderItem> items) {
        String orderSql = "INSERT INTO orders (user_id, restaurant_id, total_amount, status, delivery_address, payment_method) VALUES (?, ?, ?, ?, ?, ?)";
        String itemSql = "INSERT INTO order_items (order_id, menu_id, quantity, price) VALUES (?, ?, ?, ?)";
        
        Connection conn = null;
        PreparedStatement orderPs = null;
        PreparedStatement itemPs = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false); // Start transaction

            // 1. Insert Order
            orderPs = conn.prepareStatement(orderSql, Statement.RETURN_GENERATED_KEYS);
            orderPs.setInt(1, order.getUserId());
            orderPs.setInt(2, order.getRestaurantId());
            orderPs.setDouble(3, order.getTotalAmount());
            orderPs.setString(4, order.getStatus());
            orderPs.setString(5, order.getDeliveryAddress());
            orderPs.setString(6, order.getPaymentMethod());
            
            int affectedRows = orderPs.executeUpdate();
            if (affectedRows == 0) {
                conn.rollback();
                return false;
            }

            // Get generated Order ID
            rs = orderPs.getGeneratedKeys();
            int orderId = 0;
            if (rs.next()) {
                orderId = rs.getInt(1);
            } else {
                conn.rollback();
                return false;
            }

            // 2. Insert Order Items
            itemPs = conn.prepareStatement(itemSql);
            for (OrderItem item : items) {
                itemPs.setInt(1, orderId);
                itemPs.setInt(2, item.getMenuId());
                itemPs.setInt(3, item.getQuantity());
                itemPs.setDouble(4, item.getPrice());
                itemPs.addBatch();
            }
            
            itemPs.executeBatch();
            conn.commit(); // Commit transaction
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            if (conn != null) {
                try {
                    conn.rollback(); // Rollback on error
                } catch (Exception ex) {
                    ex.printStackTrace();
                }
            }
            return false;
        } finally {
            // Close resources
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (orderPs != null) orderPs.close(); } catch (Exception e) {}
            try { if (itemPs != null) itemPs.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }
    }

    @Override
    public Order getOrderById(int id) {
        String sql = "SELECT o.*, r.name as restaurant_name, u.username as customer_username " +
                     "FROM orders o " +
                     "JOIN restaurants r ON o.restaurant_id = r.id " +
                     "JOIN users u ON o.user_id = u.id " +
                     "WHERE o.id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return extractOrderFromResultSet(rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public List<Order> getOrdersByUser(int userId) {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT o.*, r.name as restaurant_name, u.username as customer_username " +
                     "FROM orders o " +
                     "JOIN restaurants r ON o.restaurant_id = r.id " +
                     "JOIN users u ON o.user_id = u.id " +
                     "WHERE o.user_id = ? " +
                     "ORDER BY o.order_date DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(extractOrderFromResultSet(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public List<Order> getOrdersByRestaurant(int restaurantId) {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT o.*, r.name as restaurant_name, u.username as customer_username " +
                     "FROM orders o " +
                     "JOIN restaurants r ON o.restaurant_id = r.id " +
                     "JOIN users u ON o.user_id = u.id " +
                     "WHERE o.restaurant_id = ? " +
                     "ORDER BY o.order_date DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, restaurantId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(extractOrderFromResultSet(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public List<Order> getAllOrders() {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT o.*, r.name as restaurant_name, u.username as customer_username " +
                     "FROM orders o " +
                     "JOIN restaurants r ON o.restaurant_id = r.id " +
                     "JOIN users u ON o.user_id = u.id " +
                     "ORDER BY o.order_date DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(extractOrderFromResultSet(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public boolean updateOrderStatus(int orderId, String status) {
        String sql = "UPDATE orders SET status = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, orderId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public List<OrderItem> getOrderItems(int orderId) {
        List<OrderItem> list = new ArrayList<>();
        String sql = "SELECT oi.*, m.item_name " +
                     "FROM order_items oi " +
                     "JOIN menus m ON oi.menu_id = m.id " +
                     "WHERE oi.order_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    OrderItem item = new OrderItem();
                    item.setId(rs.getInt("id"));
                    item.setOrderId(rs.getInt("order_id"));
                    item.setMenuId(rs.getInt("menu_id"));
                    item.setQuantity(rs.getInt("quantity"));
                    item.setPrice(rs.getDouble("price"));
                    item.setItemName(rs.getString("item_name"));
                    list.add(item);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    private Order extractOrderFromResultSet(ResultSet rs) throws Exception {
        Order order = new Order();
        order.setId(rs.getInt("id"));
        order.setUserId(rs.getInt("user_id"));
        order.setRestaurantId(rs.getInt("restaurant_id"));
        order.setTotalAmount(rs.getDouble("total_amount"));
        order.setStatus(rs.getString("status"));
        order.setOrderDate(rs.getTimestamp("order_date"));
        order.setDeliveryAddress(rs.getString("delivery_address"));
        order.setPaymentMethod(rs.getString("payment_method"));
        
        // Populate display fields
        order.setRestaurantName(rs.getString("restaurant_name"));
        order.setCustomerUsername(rs.getString("customer_username"));
        return order;
    }
}
