package com.foodcourt.controller.order;

import com.foodcourt.entity.Order;
import com.foodcourt.entity.OrderItem;
import com.foodcourt.entity.User;
import com.foodcourt.model.ShoppingCart;
import com.foodcourt.service.OrderService;
import com.foodcourt.service.impl.OrderServiceImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@WebServlet("/order/checkout")
public class CheckoutServlet extends HttpServlet {
    private final OrderService orderService = new OrderServiceImpl();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("user");
        ShoppingCart cart = (ShoppingCart) session.getAttribute("cart");

        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        if (cart == null || cart.getItems().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/cart");
            return;
        }

        // Group items by Stall ID
        Map<Integer, List<ShoppingCart.CartItem>> itemsByStall = cart.getItems().stream()
                .collect(Collectors.groupingBy(item -> item.getProduct().getStallId()));

        BigDecimal cartTotalAmount = cart.getTotalAmount();
        Object couponCodeObj = session.getAttribute("cartCoupon");
        Object discountObj = session.getAttribute("cartDiscount");
        BigDecimal cartDiscount = discountObj instanceof BigDecimal ? (BigDecimal) discountObj : BigDecimal.ZERO;
        if (cartDiscount.compareTo(cartTotalAmount) > 0) {
            cartDiscount = cartTotalAmount;
        }

        String paymentMethod = req.getParameter("paymentMethod");
        if (paymentMethod == null || paymentMethod.isEmpty()) {
            paymentMethod = "微信支付"; // Default
        }

        try {
            List<Map.Entry<Integer, List<ShoppingCart.CartItem>>> entries = new ArrayList<>(itemsByStall.entrySet());
            BigDecimal remainingDiscount = cartDiscount;
            for (int i = 0; i < entries.size(); i++) {
                Map.Entry<Integer, List<ShoppingCart.CartItem>> entry = entries.get(i);
                Integer stallId = entry.getKey();
                List<ShoppingCart.CartItem> cartItems = entry.getValue();

                Order order = new Order();
                order.setUserId(user.getId());
                order.setStallId(stallId);
                order.setPaymentMethod(paymentMethod);
                order.setStatus(Order.Status.PENDING); // Initial status
                order.setPaymentStatus(Order.PaymentStatus.PAID); // Simulating successful payment
                
                // Calculate total for this stall's order
                BigDecimal orderTotal = cartItems.stream()
                        .map(ShoppingCart.CartItem::getSubtotal)
                        .reduce(BigDecimal.ZERO, BigDecimal::add);
                if (couponCodeObj instanceof String && cartDiscount.compareTo(BigDecimal.ZERO) > 0 && cartTotalAmount.compareTo(BigDecimal.ZERO) > 0) {
                    BigDecimal discountForOrder;
                    if (i == entries.size() - 1) {
                        discountForOrder = remainingDiscount;
                    } else {
                        discountForOrder = orderTotal.multiply(cartDiscount)
                                .divide(cartTotalAmount, 2, java.math.RoundingMode.HALF_UP);
                        if (discountForOrder.compareTo(remainingDiscount) > 0) {
                            discountForOrder = remainingDiscount;
                        }
                    }
                    remainingDiscount = remainingDiscount.subtract(discountForOrder);
                    orderTotal = orderTotal.subtract(discountForOrder);
                    order.setNotes("使用优惠券: " + couponCodeObj);
                }
                if (orderTotal.compareTo(BigDecimal.ZERO) < 0) {
                    orderTotal = BigDecimal.ZERO;
                }
                order.setTotalAmount(orderTotal);


                List<OrderItem> orderItems = new ArrayList<>();
                for (ShoppingCart.CartItem cartItem : cartItems) {
                    OrderItem orderItem = new OrderItem();
                    orderItem.setProductId(cartItem.getProduct().getId());
                    orderItem.setProductName(cartItem.getProduct().getProductName());
                    orderItem.setUnitPrice(cartItem.getProduct().getPrice());
                    orderItem.setQuantity(cartItem.getQuantity());
                    orderItem.setSubtotal(cartItem.getSubtotal());
                    orderItems.add(orderItem);
                }

                Order savedOrder = orderService.createOrder(order, orderItems);
                orderService.updatePaymentStatus(savedOrder.getId(), Order.PaymentStatus.PAID);
            }

            // Clear cart and redirect
            cart.clear();
            session.removeAttribute("cartDiscount");
            session.removeAttribute("cartCoupon");
            session.setAttribute("message", "下单成功！");
            resp.sendRedirect(req.getContextPath() + "/order/list");

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "下单失败: " + e.getMessage());
            resp.sendRedirect(req.getContextPath() + "/cart");
        }
    }
}
