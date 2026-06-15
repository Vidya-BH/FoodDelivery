package com.food.dao;

import com.food.model.Restaurant;
import java.util.List;

public interface RestaurantDAO {
    boolean addRestaurant(Restaurant restaurant);
    Restaurant getRestaurantById(int id);
    List<Restaurant> getAllRestaurants();
    List<Restaurant> getRestaurantsByOwner(int ownerId);
    List<Restaurant> searchRestaurants(String query);
    boolean updateRestaurant(Restaurant restaurant);
    boolean deleteRestaurant(int id);
}
