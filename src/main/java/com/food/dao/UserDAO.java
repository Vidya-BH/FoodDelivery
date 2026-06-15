package com.food.dao;

import com.food.model.User;
import java.util.List;

public interface UserDAO {
    boolean addUser(User user);
    User getUserById(int id);
    User getUserByUsername(String username);
    User getUserByEmail(String email);
    User loginUser(String username, String password);
    List<User> getAllUsers();
    boolean updateUser(User user);
    boolean deleteUser(int id);
}
