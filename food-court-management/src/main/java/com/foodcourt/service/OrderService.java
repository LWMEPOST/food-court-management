package com.foodcourt.service;

import com.foodcourt.entity.Order;
import com.foodcourt.entity.OrderItem;
import java.util.List;
import java.util.Optional;

public interface OrderService {
    Order createOrder(Order order, List<OrderItem> items);
    List<Order> getAllOrders();
    Optional<Order> getOrderById(Integer id);
    List<Order> getOrdersByUserId(Integer userId);
    List<Order> getOrdersByStallId(Integer stallId);
    boolean updateOrderStatus(Integer orderId, Order.Status status);
    boolean updatePaymentStatus(Integer orderId, Order.PaymentStatus status);
    List<OrderItem> getOrderItems(Integer orderId);
}