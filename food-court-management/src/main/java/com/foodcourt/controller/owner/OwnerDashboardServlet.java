package com.foodcourt.controller.owner;

import com.foodcourt.entity.Order;
import com.foodcourt.entity.Product;
import com.foodcourt.entity.Stall;
import com.foodcourt.entity.User;
import com.foodcourt.service.OrderService;
import com.foodcourt.service.ProductService;
import com.foodcourt.service.StallService;
import com.foodcourt.service.impl.OrderServiceImpl;
import com.foodcourt.service.impl.ProductServiceImpl;
import com.foodcourt.service.impl.StallServiceImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.time.ZoneId;
import java.util.List;

@WebServlet("/owner/dashboard")
public class OwnerDashboardServlet extends HttpServlet {
    private final StallService stallService = new StallServiceImpl();
    private final OrderService orderService = new OrderServiceImpl();
    private final ProductService productService = new ProductServiceImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("user");
        if (user.getRoleType() != User.RoleType.OWNER) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN, "无权限访问");
            return;
        }

        List<Stall> stalls = stallService.getStallsByOwner(user.getId());
        LocalDate today = LocalDate.now();
        LocalDate yesterday = today.minusDays(1);
        BigDecimal todayRevenue = BigDecimal.ZERO;
        BigDecimal yesterdayRevenue = BigDecimal.ZERO;
        int pendingOrderCount = 0;
        int totalProductCount = 0;

        for (Stall stall : stalls) {
            List<Order> orders = orderService.getOrdersByStallId(stall.getId());
            for (Order order : orders) {
                if (order.getStatus() == Order.Status.PENDING
                        || order.getStatus() == Order.Status.CONFIRMED
                        || order.getStatus() == Order.Status.PREPARING) {
                    pendingOrderCount++;
                }
                if (order.getPaymentStatus() == Order.PaymentStatus.PAID && order.getOrderTime() != null) {
                    LocalDate orderDate = order.getOrderTime().toInstant().atZone(ZoneId.systemDefault()).toLocalDate();
                    if (orderDate.equals(today)) {
                        todayRevenue = todayRevenue.add(order.getTotalAmount());
                    } else if (orderDate.equals(yesterday)) {
                        yesterdayRevenue = yesterdayRevenue.add(order.getTotalAmount());
                    }
                }
            }

            List<Product> products = productService.getProductsByStallId(stall.getId());
            totalProductCount += products.size();
        }

        double revenueChangePercent;
        if (yesterdayRevenue.compareTo(BigDecimal.ZERO) == 0) {
            revenueChangePercent = todayRevenue.compareTo(BigDecimal.ZERO) == 0 ? 0 : 100;
        } else {
            revenueChangePercent = todayRevenue.subtract(yesterdayRevenue)
                    .divide(yesterdayRevenue, 4, RoundingMode.HALF_UP)
                    .multiply(BigDecimal.valueOf(100))
                    .doubleValue();
        }

        req.setAttribute("pendingOrderCount", pendingOrderCount);
        req.setAttribute("todayRevenue", todayRevenue.setScale(2, RoundingMode.HALF_UP));
        req.setAttribute("revenueChangePercent", String.format("%.1f", revenueChangePercent));
        req.setAttribute("totalProductCount", totalProductCount);

        req.getRequestDispatcher("/jsp/owner/dashboard.jsp").forward(req, resp);
    }
}
