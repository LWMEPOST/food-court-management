package com.foodcourt.service.impl;

import com.foodcourt.dao.UserDao;
import com.foodcourt.dao.impl.UserDaoImpl;
import com.foodcourt.entity.User;
import com.foodcourt.service.UserService;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import java.util.Optional;

public class UserServiceImpl implements UserService {
    private static final Logger logger = LogManager.getLogger(UserServiceImpl.class);
    private final UserDao userDao = new UserDaoImpl();

    @Override
    public User login(String username, String password) {
        Optional<User> userOpt = userDao.findByUsername(username);
        
        if (userOpt.isPresent()) {
            User user = userOpt.get();
            // In a real application, use BCrypt or similar to verify password hash
            // For now, simple string comparison as per initial setup
            if (user.getPasswordHash().equals(password)) {
                if (user.getStatus() == User.Status.ACTIVE) {
                    return user;
                } else {
                    logger.warn("User {} attempted login but is not ACTIVE", username);
                    throw new RuntimeException("账户未激活");
                }
            }
        }
        return null;
    }

    @Override
    public boolean register(User user) {
        // Check if username or email already exists
        if (userDao.findByUsername(user.getUsername()).isPresent()) {
            throw new RuntimeException("用户名已存在");
        }
        if (userDao.findByEmail(user.getEmail()).isPresent()) {
            throw new RuntimeException("邮箱已存在");
        }
        
        // Set default status based on role
        if (user.getRoleType() == User.RoleType.OWNER) {
            user.setStatus(User.Status.PENDING);
        } else {
            user.setStatus(User.Status.ACTIVE);
        }
        
        try {
            userDao.save(user);
            return true;
        } catch (Exception e) {
            logger.error("Registration failed", e);
            return false;
        }
    }

    @Override
    public Optional<User> getUserById(Integer id) {
        return userDao.findById(id);
    }

    @Override
    public java.util.List<User> getAllUsers() {
        return userDao.findAll();
    }

    @Override
    public boolean updateUserStatus(Integer userId, User.Status status) {
        Optional<User> userOpt = userDao.findById(userId);
        if (userOpt.isPresent()) {
            User user = userOpt.get();
            user.setStatus(status);
            return userDao.update(user);
        }
        return false;
    }
}