package com.foodcourt.controller.order;

import com.foodcourt.entity.Order;
import com.foodcourt.entity.OrderItem;
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
import java.util.Optional;

@WebServlet("/order/detail")
public class OrderDetailServlet extends HttpServlet {
    private final OrderService orderService = new OrderServiceImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        String idStr = req.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/order/list");
            return;
        }

        try {
            int orderId = Integer.parseInt(idStr);
            Optional<Order> orderOpt = orderService.getOrderById(orderId);

            if (orderOpt.isPresent()) {
                Order order = orderOpt.get();
                // Security check: ensure the order belongs to the user OR the user is an admin/owner (though this servlet is primarily for diners, basic check is good)
                // For simplicity, we assume if you are a DINER, you can only see your own orders.
                if (user.getRoleType() == User.RoleType.DINER && !order.getUserId().equals(user.getId())) {
                    resp.sendError(HttpServletResponse.SC_FORBIDDEN, "无权限访问");
                    return;
                }

                List<OrderItem> items = orderService.getOrderItems(orderId);
                order.setOrderItems(items);
                
                req.setAttribute("order", order);
                req.getRequestDispatcher("/jsp/order/detail.jsp").forward(req, resp);
            } else {
                resp.sendError(HttpServletResponse.SC_NOT_FOUND, "订单不存在");
            }
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/order/list");
        }
    }
}
