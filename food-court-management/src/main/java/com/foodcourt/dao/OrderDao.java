package com.foodcourt.dao;

import com.foodcourt.entity.Order;
import com.foodcourt.entity.OrderItem;
import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

public interface OrderDao {
    Order save(Order order);
    void saveOrderItems(List<OrderItem> items);
    Optional<Order> findById(Integer id);
    List<Order> findAll();
    List<Order> findByUserId(Integer userId);
    List<Order> findByStallId(Integer stallId);
    List<OrderItem> findItemsByOrderId(Integer orderId);
    boolean updateStatus(Integer orderId, Order.Status status);
    boolean updatePaymentStatus(Integer orderId, Order.PaymentStatus status);
    String generateNextOrderNumber(LocalDate date);
    String generateNextPickupNumber(LocalDate date);
    void ensureDailySequence(LocalDate date);
    void ensureDailyPickupSequence(LocalDate date);
}
