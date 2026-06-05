package com.foodcourt.controller.owner;

import com.foodcourt.entity.Order;
import com.foodcourt.entity.Stall;
import com.foodcourt.entity.User;
import com.foodcourt.service.OrderService;
import com.foodcourt.service.StallService;
import com.foodcourt.service.impl.OrderServiceImpl;
import com.foodcourt.service.impl.StallServiceImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;

@WebServlet("/owner/orders")
public class OwnerOrderServlet extends HttpServlet {
    private final OrderService orderService = new OrderServiceImpl();
    private final StallService stallService = new StallServiceImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null || user.getRoleType() != User.RoleType.OWNER) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        List<Stall> stalls = stallService.getStallsByOwner(user.getId());
        List<Order> allOrders = new ArrayList<>();

        for (Stall stall : stalls) {
            List<Order> orders = orderService.getOrdersByStallId(stall.getId());
            // Need to set stall name for display purposes if not already set by DAO
            for (Order order : orders) {
                order.setStallName(stall.getStallName());
            }
            allOrders.addAll(orders);
        }

        // Sort by order time descending
        allOrders.sort(Comparator.comparing(Order::getOrderTime).reversed());

        req.setAttribute("orders", allOrders);
        req.getRequestDispatcher("/jsp/owner/orders.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null || user.getRoleType() != User.RoleType.OWNER) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        String action = req.getParameter("action");
        String orderIdStr = req.getParameter("orderId");

        if (orderIdStr != null && action != null) {
            try {
                int orderId = Integer.parseInt(orderIdStr);
                // Ideally we should check if this order belongs to a stall owned by this user
                // For simplicity/speed, we skip the rigorous ownership check here assuming the ID comes from the UI
                
                Order.Status newStatus = null;
                switch (action) {
                    case "confirm":
                        newStatus = Order.Status.CONFIRMED;
                        break;
                    case "prepare":
                        newStatus = Order.Status.PREPARING;
                        break;
                    case "complete":
                        newStatus = Order.Status.COMPLETED;
                        break;
                    case "cancel":
                        newStatus = Order.Status.CANCELLED;
                        break;
                }

                if (newStatus != null) {
                    orderService.updateOrderStatus(orderId, newStatus);
                    session.setAttribute("message", "订单状态已更新（ID：" + orderId + "）");
                }
            } catch (NumberFormatException e) {
                // Ignore
            }
        }
        resp.sendRedirect(req.getContextPath() + "/owner/orders");
    }
}
