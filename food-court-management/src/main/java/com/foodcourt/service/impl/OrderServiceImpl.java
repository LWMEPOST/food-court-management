package com.foodcourt.service.impl;

import com.foodcourt.dao.OrderDao;
import com.foodcourt.dao.impl.OrderDaoImpl;
import com.foodcourt.entity.Order;
import com.foodcourt.entity.OrderItem;
import com.foodcourt.service.OrderService;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

public class OrderServiceImpl implements OrderService {
    private final OrderDao orderDao = new OrderDaoImpl();

    @Override
    public Order createOrder(Order order, List<OrderItem> items) {
        String tempOrderNumber = "TMP" + UUID.randomUUID().toString().replace("-", "").substring(0, 20).toUpperCase();
        order.setOrderNumber(tempOrderNumber);
        // Status might be set by controller, but ensure defaults
        if (order.getStatus() == null) order.setStatus(Order.Status.PENDING);
        if (order.getPaymentStatus() == null) order.setPaymentStatus(Order.PaymentStatus.UNPAID);
        
        // Save Order
        Order savedOrder = orderDao.save(order);
        
        // Set Order ID for items
        for (OrderItem item : items) {
            item.setOrderId(savedOrder.getId());
        }
        
        // Save Items
        orderDao.saveOrderItems(items);
        
        return savedOrder;
    }

    @Override
    public List<Order> getAllOrders() {
        return orderDao.findAll();
    }

    @Override
    public Optional<Order> getOrderById(Integer id) {
        Optional<Order> order = orderDao.findById(id);
        if (order.isPresent()) {
            order.get().setOrderItems(orderDao.findItemsByOrderId(id));
        }
        return order;
    }

    @Override
    public List<Order> getOrdersByUserId(Integer userId) {
        return orderDao.findByUserId(userId);
    }

    @Override
    public List<Order> getOrdersByStallId(Integer stallId) {
        return orderDao.findByStallId(stallId);
    }

    @Override
    public boolean updateOrderStatus(Integer orderId, Order.Status status) {
        return orderDao.updateStatus(orderId, status);
    }

    @Override
    public boolean updatePaymentStatus(Integer orderId, Order.PaymentStatus status) {
        return orderDao.updatePaymentStatus(orderId, status);
    }

    @Override
    public List<OrderItem> getOrderItems(Integer orderId) {
        return orderDao.findItemsByOrderId(orderId);
    }
}
