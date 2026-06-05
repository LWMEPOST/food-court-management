package com.foodcourt.controller.owner;

import com.foodcourt.entity.Order;
import com.foodcourt.entity.OrderItem;
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
import java.util.Optional;

@WebServlet("/owner/order/detail")
public class OwnerOrderDetailServlet extends HttpServlet {
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

        String idStr = req.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/owner/orders");
            return;
        }

        try {
            int orderId = Integer.parseInt(idStr);
            Optional<Order> orderOpt = orderService.getOrderById(orderId);
            if (orderOpt.isEmpty()) {
                resp.sendError(HttpServletResponse.SC_NOT_FOUND);
                return;
            }

            Order order = orderOpt.get();
            List<Stall> stalls = stallService.getStallsByOwner(user.getId());
            boolean owns = false;
            for (Stall stall : stalls) {
                if (stall.getId().equals(order.getStallId())) {
                    owns = true;
                    order.setStallName(stall.getStallName());
                    break;
                }
            }

            if (!owns) {
                resp.sendError(HttpServletResponse.SC_FORBIDDEN);
                return;
            }

            List<OrderItem> items = orderService.getOrderItems(orderId);
            order.setOrderItems(items);
            req.setAttribute("order", order);
            req.getRequestDispatcher("/jsp/owner/order_detail.jsp").forward(req, resp);
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/owner/orders");
        }
    }
}
