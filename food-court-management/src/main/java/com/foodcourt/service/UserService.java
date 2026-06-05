package com.foodcourt.service;

import com.foodcourt.entity.User;
import java.util.Optional;

public interface UserService {
    User login(String username, String password);
    boolean register(User user);
    Optional<User> getUserById(Integer id);
    java.util.List<User> getAllUsers();
    boolean updateUserStatus(Integer userId, User.Status status);
}