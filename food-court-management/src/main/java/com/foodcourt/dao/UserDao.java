package com.foodcourt.dao;

import com.foodcourt.entity.User;
import java.util.Optional;

public interface UserDao {
    Optional<User> findByUsername(String username);
    Optional<User> findByEmail(String email);
    Optional<User> findById(Integer id);
    java.util.List<User> findAll();
    User save(User user);
    boolean update(User user);
    boolean delete(Integer id);
}