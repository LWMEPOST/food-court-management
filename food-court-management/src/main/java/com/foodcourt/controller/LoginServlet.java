package com.foodcourt.controller;

import com.foodcourt.entity.User;
import com.foodcourt.service.UserService;
import com.foodcourt.service.impl.UserServiceImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private final UserService userService = new UserServiceImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/jsp/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String username = req.getParameter("username");
        String password = req.getParameter("password");

        try {
            User user = userService.login(username, password);
            if (user != null) {
                HttpSession session = req.getSession();
                session.setAttribute("user", user);
                
                // Redirect based on role
                switch (user.getRoleType()) {
                    case ADMIN:
                        resp.sendRedirect(req.getContextPath() + "/admin/dashboard"); // Placeholder
                        break;
                    case OWNER:
                        resp.sendRedirect(req.getContextPath() + "/owner/dashboard"); // Placeholder
                        break;
                    case DINER:
                    default:
                        resp.sendRedirect(req.getContextPath() + "/home");
                        break;
                }
            } else {
                req.setAttribute("error", "用户名或密码错误");
                req.getRequestDispatcher("/jsp/login.jsp").forward(req, resp);
            }
        } catch (RuntimeException e) {
            req.setAttribute("error", e.getMessage());
            req.getRequestDispatcher("/jsp/login.jsp").forward(req, resp);
        }
    }
}
