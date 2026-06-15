package com.food.dao;

import com.food.model.Menu;
import java.util.List;

public interface MenuDAO {
    boolean addMenuItem(Menu menu);
    Menu getMenuItemById(int id);
    List<Menu> getMenuItemsByRestaurant(int restaurantId);
    boolean updateMenuItem(Menu menu);
    boolean deleteMenuItem(int id);
}
