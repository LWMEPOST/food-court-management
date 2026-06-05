package com.foodcourt.controller.admin;

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
import java.util.List;

@WebServlet("/admin/users")
public class AdminUserServlet extends HttpServlet {
    private final UserService userService = new UserServiceImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User user = (User) session.getAttribute("user");
        if (user == null || user.getRoleType() != User.RoleType.ADMIN) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String keyword = req.getParameter("keyword");
        List<User> userList = userService.getAllUsers();
        if (keyword != null && !keyword.isBlank()) {
            String normalized = keyword.trim().toLowerCase();
            userList = userList.stream()
                    .filter(candidate -> matchesKeyword(candidate, normalized))
                    .toList();
        }
        req.setAttribute("userList", userList);
        req.getRequestDispatcher("/jsp/admin/users.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User user = (User) session.getAttribute("user");
        if (user == null || user.getRoleType() != User.RoleType.ADMIN) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        String action = req.getParameter("action");
        if ("updateStatus".equals(action)) {
            int userId = Integer.parseInt(req.getParameter("userId"));
            String statusStr = req.getParameter("status");
            User.Status status = User.Status.valueOf(statusStr);
            userService.updateUserStatus(userId, status);
        }

        resp.sendRedirect(req.getContextPath() + "/admin/users");
    }

    private boolean matchesKeyword(User user, String keyword) {
        if (user == null) {
            return false;
        }
        return containsIgnoreCase(user.getUsername(), keyword)
                || containsIgnoreCase(roleLabel(user.getRoleType()), keyword)
                || containsIgnoreCase(statusLabel(user.getStatus()), keyword)
                || containsIgnoreCase(user.getRoleType() != null ? user.getRoleType().name() : null, keyword)
                || containsIgnoreCase(user.getStatus() != null ? user.getStatus().name() : null, keyword);
    }

    private boolean containsIgnoreCase(String source, String keyword) {
        return source != null && !keyword.isBlank() && source.toLowerCase().contains(keyword);
    }

    private String roleLabel(User.RoleType roleType) {
        if (roleType == null) {
            return null;
        }
        return switch (roleType) {
            case DINER -> "食客";
            case OWNER -> "摊主";
            case ADMIN -> "管理员";
        };
    }

    private String statusLabel(User.Status status) {
        if (status == null) {
            return null;
        }
        return switch (status) {
            case ACTIVE -> "正常";
            case PENDING -> "待审核";
            case INACTIVE -> "已禁用";
        };
    }
}
