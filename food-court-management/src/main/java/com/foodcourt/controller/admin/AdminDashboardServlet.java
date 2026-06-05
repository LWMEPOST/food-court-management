package com.foodcourt.controller.admin;

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
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@WebServlet("/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {
    private final StallService stallService = new StallServiceImpl();
    private final OrderService orderService = new OrderServiceImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("user");
        if (user.getRoleType() != User.RoleType.ADMIN) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN, "无权限访问");
            return;
        }

        // Gather Data
        List<Stall> stalls = stallService.getAllStalls();
        List<Order> orders = orderService.getAllOrders();

        // 1. Stall Occupancy Rate (Rented / Total)
        long totalStalls = stalls.size();
        long rentedStalls = stalls.stream().filter(s -> s.getOwnerId() != null).count();
        double occupancyRate = totalStalls == 0 ? 0 : (double) rentedStalls / totalStalls * 100;

        // 2. Order Payment Rate (Paid / Total Orders)
        long totalOrders = orders.size();
        long paidOrders = orders.stream().filter(o -> o.getPaymentStatus() == Order.PaymentStatus.PAID).count();
        double paymentRate = totalOrders == 0 ? 0 : (double) paidOrders / totalOrders * 100;

        // 3. Popular Stalls (Top 5 by Order Count)
        Map<String, Long> stallOrderCounts = orders.stream()
                .collect(Collectors.groupingBy(o -> o.getStallName() != null ? o.getStallName() : "未知摊位", Collectors.counting()));

        List<Map.Entry<String, Long>> topStalls = stallOrderCounts.entrySet().stream()
                .sorted(Map.Entry.<String, Long>comparingByValue().reversed())
                .limit(5)
                .collect(Collectors.toList());

        List<String> topStallNames = topStalls.stream().map(Map.Entry::getKey).collect(Collectors.toList());
        List<Long> topStallData = topStalls.stream().map(Map.Entry::getValue).collect(Collectors.toList());

        // Set Attributes
        req.setAttribute("totalStalls", totalStalls);
        req.setAttribute("rentedStalls", rentedStalls);
        req.setAttribute("occupancyRate", String.format("%.1f", occupancyRate));
        
        req.setAttribute("totalOrders", totalOrders);
        req.setAttribute("paidOrders", paidOrders);
        req.setAttribute("paymentRate", String.format("%.1f", paymentRate));

        req.setAttribute("topStallNames", topStallNames);
        req.setAttribute("topStallData", topStallData);

        req.getRequestDispatcher("/jsp/admin/dashboard.jsp").forward(req, resp);
    }
}
