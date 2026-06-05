package com.foodcourt.controller;

import com.foodcourt.entity.User;
import com.foodcourt.service.UserService;
import com.foodcourt.service.impl.UserServiceImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    private final UserService userService = new UserServiceImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/jsp/register.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String username = req.getParameter("username");
        String password = req.getParameter("password");
        String confirmPassword = req.getParameter("confirmPassword");
        String email = req.getParameter("email");
        String phone = req.getParameter("phone");
        String roleTypeStr = req.getParameter("roleType");

        if (!password.equals(confirmPassword)) {
            req.setAttribute("error", "密码不匹配");
            req.getRequestDispatcher("/jsp/register.jsp").forward(req, resp);
            return;
        }

        try {
            User user = new User();
            user.setUsername(username);
            user.setPasswordHash(password); // In real app, hash this!
            user.setEmail(email);
            user.setPhone(phone);
            user.setRoleType(User.RoleType.valueOf(roleTypeStr));

            if (userService.register(user)) {
                resp.sendRedirect(req.getContextPath() + "/login?registered=true");
            } else {
                req.setAttribute("error", "注册失败，请重试。");
                req.getRequestDispatcher("/jsp/register.jsp").forward(req, resp);
            }
        } catch (RuntimeException e) {
            req.setAttribute("error", e.getMessage());
            req.getRequestDispatcher("/jsp/register.jsp").forward(req, resp);
        }
    }
}