package com.foodcourt.controller.admin;

import com.foodcourt.entity.Order;
import com.foodcourt.entity.User;
import com.foodcourt.service.OrderService;
import com.foodcourt.service.impl.OrderServiceImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin/orders")
public class AdminOrderServlet extends HttpServlet {
    private final OrderService orderService = new OrderServiceImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User user = (User) session.getAttribute("user");
        if (user == null || user.getRoleType() != User.RoleType.ADMIN) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String keyword = req.getParameter("keyword");
        List<Order> orders = orderService.getAllOrders();
        if (keyword != null && !keyword.isBlank()) {
            String normalized = keyword.trim().toLowerCase();
            orders = orders.stream()
                    .filter(order -> matchesKeyword(order, normalized))
                    .toList();
        }
        req.setAttribute("orders", orders);
        req.getRequestDispatcher("/jsp/admin/orders.jsp").forward(req, resp);
    }

    private boolean matchesKeyword(Order order, String keyword) {
        if (order == null) {
            return false;
        }
        return containsIgnoreCase(order.getOrderNumber(), keyword)
                || containsIgnoreCase(order.getPickupNumber(), keyword)
                || containsIgnoreCase(order.getStallName(), keyword)
                || containsIgnoreCase(order.getUserName(), keyword)
                || containsIgnoreCase(order.getId() != null ? String.valueOf(order.getId()) : null, keyword);
    }

    private boolean containsIgnoreCase(String source, String keyword) {
        return source != null && !keyword.isBlank() && source.toLowerCase().contains(keyword);
    }
}
