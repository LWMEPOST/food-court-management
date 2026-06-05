package com.foodcourt.dao.impl;

import com.foodcourt.dao.OrderDao;
import com.foodcourt.entity.Order;
import com.foodcourt.entity.OrderItem;
import com.foodcourt.util.DatabaseUtil;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import java.sql.*;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class OrderDaoImpl implements OrderDao {
    private static final Logger logger = LogManager.getLogger(OrderDaoImpl.class);

    @Override
    public Order save(Order order) {
        String sql = "INSERT INTO orders (order_number, pickup_number, user_id, stall_id, total_amount, status, payment_status, payment_method, notes) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setString(1, order.getOrderNumber());
            stmt.setString(2, order.getPickupNumber());
            stmt.setInt(3, order.getUserId());
            stmt.setInt(4, order.getStallId());
            stmt.setBigDecimal(5, order.getTotalAmount());
            stmt.setString(6, order.getStatus().name());
            stmt.setString(7, order.getPaymentStatus().name());
            stmt.setString(8, order.getPaymentMethod());
            stmt.setString(9, order.getNotes());

            int affectedRows = stmt.executeUpdate();
            if (affectedRows == 0) {
                throw new SQLException("Creating order failed, no rows affected.");
            }

            try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    order.setId(generatedKeys.getInt(1));
                } else {
                    throw new SQLException("Creating order failed, no ID obtained.");
                }
            }
            return order;
        } catch (SQLException e) {
            logger.error("Error saving order", e);
            throw new RuntimeException(e);
        }
    }

    @Override
    public void saveOrderItems(List<OrderItem> items) {
        String sql = "INSERT INTO order_items (order_id, product_id, quantity, unit_price, subtotal) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            for (OrderItem item : items) {
                stmt.setInt(1, item.getOrderId());
                stmt.setInt(2, item.getProductId());
                stmt.setInt(3, item.getQuantity());
                stmt.setBigDecimal(4, item.getUnitPrice());
                stmt.setBigDecimal(5, item.getSubtotal());
                stmt.addBatch();
            }
            stmt.executeBatch();
        } catch (SQLException e) {
            logger.error("Error saving order items", e);
            throw new RuntimeException(e);
        }
    }

    @Override
    public Optional<Order> findById(Integer id) {
        String sql = "SELECT o.*, s.stall_name, u.username FROM orders o " +
                     "LEFT JOIN stalls s ON o.stall_id = s.id " +
                     "LEFT JOIN users u ON o.user_id = u.id " +
                     "WHERE o.id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(mapResultSetToOrder(rs));
                }
            }
        } catch (SQLException e) {
            logger.error("Error finding order by id: " + id, e);
        }
        return Optional.empty();
    }

    @Override
    public List<Order> findAll() {
        String sql = "SELECT o.*, s.stall_name, u.username FROM orders o " +
                     "LEFT JOIN stalls s ON o.stall_id = s.id " +
                     "LEFT JOIN users u ON o.user_id = u.id " +
                     "ORDER BY o.order_time DESC";
        List<Order> list = new ArrayList<>();
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                list.add(mapResultSetToOrder(rs));
            }
        } catch (SQLException e) {
            logger.error("Error finding all orders", e);
        }
        return list;
    }

    @Override
    public List<Order> findByUserId(Integer userId) {
        String sql = "SELECT o.*, s.stall_name, u.username FROM orders o " +
                     "LEFT JOIN stalls s ON o.stall_id = s.id " +
                     "LEFT JOIN users u ON o.user_id = u.id " +
                     "WHERE o.user_id = ? ORDER BY o.order_time DESC";
        return executeOrderQuery(sql, userId);
    }

    @Override
    public List<Order> findByStallId(Integer stallId) {
        String sql = "SELECT o.*, s.stall_name, u.username FROM orders o " +
                     "LEFT JOIN stalls s ON o.stall_id = s.id " +
                     "LEFT JOIN users u ON o.user_id = u.id " +
                     "WHERE o.stall_id = ? ORDER BY o.order_time DESC";
        return executeOrderQuery(sql, stallId);
    }

    @Override
    public List<OrderItem> findItemsByOrderId(Integer orderId) {
        List<OrderItem> items = new ArrayList<>();
        String sql = "SELECT oi.*, p.product_name FROM order_items oi " +
                     "LEFT JOIN products p ON oi.product_id = p.id " +
                     "WHERE oi.order_id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, orderId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    OrderItem item = new OrderItem();
                    item.setId(rs.getInt("id"));
                    item.setOrderId(rs.getInt("order_id"));
                    item.setProductId(rs.getInt("product_id"));
                    item.setQuantity(rs.getInt("quantity"));
                    item.setUnitPrice(rs.getBigDecimal("unit_price"));
                    item.setSubtotal(rs.getBigDecimal("subtotal"));
                    item.setProductName(rs.getString("product_name"));
                    items.add(item);
                }
            }
        } catch (SQLException e) {
            logger.error("Error finding order items", e);
        }
        return items;
    }

    @Override
    public boolean updateStatus(Integer orderId, Order.Status status) {
        String sql = "UPDATE orders SET status = ? WHERE id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, status.name());
            stmt.setInt(2, orderId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            logger.error("Error updating order status", e);
            return false;
        }
    }

    @Override
    public boolean updatePaymentStatus(Integer orderId, Order.PaymentStatus status) {
        String selectSql = "SELECT payment_status, order_number, pickup_number FROM orders WHERE id = ? FOR UPDATE";
        String updateSqlPaid = "UPDATE orders SET payment_status = ?, order_number = ?, pickup_number = ? WHERE id = ?";
        String updateSqlOnly = "UPDATE orders SET payment_status = ? WHERE id = ?";
        try (Connection conn = DatabaseUtil.getConnection()) {
            if (status == Order.PaymentStatus.PAID) {
                conn.setAutoCommit(false);
                try {
                    Order.PaymentStatus currentStatus = null;
                    String currentOrderNumber = null;
                    String currentPickupNumber = null;
                    try (PreparedStatement stmt = conn.prepareStatement(selectSql)) {
                        stmt.setInt(1, orderId);
                        try (ResultSet rs = stmt.executeQuery()) {
                            if (rs.next()) {
                                String statusValue = rs.getString("payment_status");
                                currentStatus = statusValue == null ? null : Order.PaymentStatus.valueOf(statusValue);
                                currentOrderNumber = rs.getString("order_number");
                                currentPickupNumber = rs.getString("pickup_number");
                            } else {
                                conn.rollback();
                                return false;
                            }
                        }
                    }

                    if (currentStatus == Order.PaymentStatus.PAID && currentOrderNumber != null && currentPickupNumber != null) {
                        conn.commit();
                        return true;
                    }

                    String orderNumber = (currentStatus == Order.PaymentStatus.PAID && currentOrderNumber != null)
                            ? currentOrderNumber
                            : generateNextSequence(conn, "order_number_sequences", LocalDate.now(), 6, "");
                    String pickupNumber = (currentStatus == Order.PaymentStatus.PAID && currentPickupNumber != null)
                            ? currentPickupNumber
                            : generateNextSequence(conn, "pickup_number_sequences", LocalDate.now(), 4, "P");

                    try (PreparedStatement stmt = conn.prepareStatement(updateSqlPaid)) {
                        stmt.setString(1, status.name());
                        stmt.setString(2, orderNumber);
                        stmt.setString(3, pickupNumber);
                        stmt.setInt(4, orderId);
                        boolean updated = stmt.executeUpdate() > 0;
                        conn.commit();
                        return updated;
                    }
                } catch (SQLException e) {
                    conn.rollback();
                    throw e;
                }
            } else {
                try (PreparedStatement stmt = conn.prepareStatement(updateSqlOnly)) {
                    stmt.setString(1, status.name());
                    stmt.setInt(2, orderId);
                    return stmt.executeUpdate() > 0;
                }
            }
        } catch (SQLException e) {
            logger.error("Error updating payment status", e);
            return false;
        }
    }

    @Override
    public String generateNextOrderNumber(LocalDate date) {
        try (Connection conn = DatabaseUtil.getConnection()) {
            conn.setAutoCommit(false);
            try {
                String orderNumber = generateNextSequence(conn, "order_number_sequences", date, 6, "");
                conn.commit();
                return orderNumber;
            } catch (SQLException e) {
                conn.rollback();
                throw e;
            }
        } catch (SQLException e) {
            logger.error("Error generating order number", e);
            throw new RuntimeException(e);
        }
    }

    @Override
    public String generateNextPickupNumber(LocalDate date) {
        try (Connection conn = DatabaseUtil.getConnection()) {
            conn.setAutoCommit(false);
            try {
                String pickupNumber = generateNextSequence(conn, "pickup_number_sequences", date, 4, "P");
                conn.commit();
                return pickupNumber;
            } catch (SQLException e) {
                conn.rollback();
                throw e;
            }
        } catch (SQLException e) {
            logger.error("Error generating pickup number", e);
            throw new RuntimeException(e);
        }
    }

    @Override
    public void ensureDailySequence(LocalDate date) {
        try (Connection conn = DatabaseUtil.getConnection()) {
            conn.setAutoCommit(false);
            try {
                ensureDailySequenceInternal(conn, "order_number_sequences", date);
                conn.commit();
            } catch (SQLException e) {
                conn.rollback();
                throw e;
            }
        } catch (SQLException e) {
            logger.error("Error ensuring daily order sequence", e);
            throw new RuntimeException(e);
        }
    }

    @Override
    public void ensureDailyPickupSequence(LocalDate date) {
        try (Connection conn = DatabaseUtil.getConnection()) {
            conn.setAutoCommit(false);
            try {
                ensureDailySequenceInternal(conn, "pickup_number_sequences", date);
                conn.commit();
            } catch (SQLException e) {
                conn.rollback();
                throw e;
            }
        } catch (SQLException e) {
            logger.error("Error ensuring daily pickup sequence", e);
            throw new RuntimeException(e);
        }
    }

    private List<Order> executeOrderQuery(String sql, Integer param) {
        List<Order> list = new ArrayList<>();
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, param);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToOrder(rs));
                }
            }
        } catch (SQLException e) {
            logger.error("Error executing order query", e);
        }
        return list;
    }

    private Order mapResultSetToOrder(ResultSet rs) throws SQLException {
        Order order = new Order();
        order.setId(rs.getInt("id"));
        order.setOrderNumber(rs.getString("order_number"));
        order.setPickupNumber(rs.getString("pickup_number"));
        order.setUserId(rs.getInt("user_id"));
        order.setStallId(rs.getInt("stall_id"));
        order.setTotalAmount(rs.getBigDecimal("total_amount"));
        order.setStatus(Order.Status.valueOf(rs.getString("status")));
        order.setPaymentStatus(Order.PaymentStatus.valueOf(rs.getString("payment_status")));
        order.setPaymentMethod(rs.getString("payment_method"));
        order.setNotes(rs.getString("notes"));
        order.setOrderTime(rs.getTimestamp("order_time"));
        order.setCompletionTime(rs.getTimestamp("completion_time"));
        order.setStallName(rs.getString("stall_name"));
        order.setUserName(rs.getString("username"));
        return order;
    }

    private String generateNextSequence(Connection conn, String tableName, LocalDate date, int digits, String prefix) throws SQLException {
        String selectSql = "SELECT current_seq FROM " + tableName + " WHERE date_key = ? FOR UPDATE";
        String insertSql = "INSERT INTO " + tableName + " (date_key, current_seq) VALUES (?, ?)";
        String updateSql = "UPDATE " + tableName + " SET current_seq = ? WHERE date_key = ?";
        String dateKey = date.format(DateTimeFormatter.BASIC_ISO_DATE);

        Integer currentSeq = null;
        try (PreparedStatement stmt = conn.prepareStatement(selectSql)) {
            stmt.setDate(1, Date.valueOf(date));
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    currentSeq = rs.getInt(1);
                }
            }
        }

        int nextSeq = currentSeq == null ? 1 : currentSeq + 1;
        if (currentSeq == null) {
            try (PreparedStatement stmt = conn.prepareStatement(insertSql)) {
                stmt.setDate(1, Date.valueOf(date));
                stmt.setInt(2, nextSeq);
                stmt.executeUpdate();
            }
        } else {
            try (PreparedStatement stmt = conn.prepareStatement(updateSql)) {
                stmt.setInt(1, nextSeq);
                stmt.setDate(2, Date.valueOf(date));
                stmt.executeUpdate();
            }
        }
        return prefix + dateKey + String.format("%0" + digits + "d", nextSeq);
    }

    private void ensureDailySequenceInternal(Connection conn, String tableName, LocalDate date) throws SQLException {
        String selectSql = "SELECT current_seq FROM " + tableName + " WHERE date_key = ? FOR UPDATE";
        String insertSql = "INSERT INTO " + tableName + " (date_key, current_seq) VALUES (?, ?)";
        boolean exists = false;
        try (PreparedStatement stmt = conn.prepareStatement(selectSql)) {
            stmt.setDate(1, Date.valueOf(date));
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    exists = true;
                }
            }
        }

        if (!exists) {
            try (PreparedStatement stmt = conn.prepareStatement(insertSql)) {
                stmt.setDate(1, Date.valueOf(date));
                stmt.setInt(2, 0);
                stmt.executeUpdate();
            }
        }
    }
}
