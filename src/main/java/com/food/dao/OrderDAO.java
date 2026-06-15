package com.food.dao;

import com.food.model.Order;
import com.food.model.OrderItem;
import java.util.List;

public interface OrderDAO {
    boolean placeOrder(Order order, List<OrderItem> items);
    Order getOrderById(int id);
    List<Order> getOrdersByUser(int userId);
    List<Order> getOrdersByRestaurant(int restaurantId);
    List<Order> getAllOrders();
    boolean updateOrderStatus(int orderId, String status);
    List<OrderItem> getOrderItems(int orderId);
}
