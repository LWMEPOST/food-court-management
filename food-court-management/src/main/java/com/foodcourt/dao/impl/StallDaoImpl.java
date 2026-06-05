package com.foodcourt.dao.impl;

import com.foodcourt.dao.StallDao;
import com.foodcourt.entity.Stall;
import com.foodcourt.util.DatabaseUtil;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class StallDaoImpl implements StallDao {
    private static final Logger logger = LogManager.getLogger(StallDaoImpl.class);

    @Override
    public List<Stall> findAll() {
        String sql = "SELECT s.*, u.username as owner_name, c.category_name " +
                     "FROM stalls s " +
                     "LEFT JOIN users u ON s.owner_id = u.id " +
                     "LEFT JOIN categories c ON s.category_id = c.id " +
                     "ORDER BY s.created_at DESC";
        return executeQuery(sql);
    }

    @Override
    public List<Stall> findLatestOpen(int limit) {
        String sql = "SELECT s.*, u.username as owner_name, c.category_name " +
                     "FROM stalls s " +
                     "LEFT JOIN users u ON s.owner_id = u.id " +
                     "LEFT JOIN categories c ON s.category_id = c.id " +
                     "WHERE s.status = ? ORDER BY s.created_at DESC LIMIT ?";
        return executeQuery(sql, Stall.Status.OPEN.name(), limit);
    }

    @Override
    public List<Stall> findByOwnerId(Integer ownerId) {
        String sql = "SELECT s.*, u.username as owner_name, c.category_name " +
                     "FROM stalls s " +
                     "LEFT JOIN users u ON s.owner_id = u.id " +
                     "LEFT JOIN categories c ON s.category_id = c.id " +
                     "WHERE s.owner_id = ? ORDER BY s.created_at DESC";
        return executeQuery(sql, ownerId);
    }

    @Override
    public List<Stall> findByCategoryId(Integer categoryId) {
        String sql = "SELECT s.*, u.username as owner_name, c.category_name " +
                     "FROM stalls s " +
                     "LEFT JOIN users u ON s.owner_id = u.id " +
                     "LEFT JOIN categories c ON s.category_id = c.id " +
                     "WHERE s.category_id = ? ORDER BY s.created_at DESC";
        return executeQuery(sql, categoryId);
    }

    @Override
    public Optional<Stall> findById(Integer id) {
        String sql = "SELECT s.*, u.username as owner_name, c.category_name " +
                     "FROM stalls s " +
                     "LEFT JOIN users u ON s.owner_id = u.id " +
                     "LEFT JOIN categories c ON s.category_id = c.id " +
                     "WHERE s.id = ?";
        List<Stall> list = executeQuery(sql, id);
        return list.isEmpty() ? Optional.empty() : Optional.of(list.get(0));
    }

    @Override
    public Stall save(Stall stall) {
        String sql = "INSERT INTO stalls (stall_name, location, status, owner_id, category_id, description, background_image_url, rent_fee, images) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setString(1, stall.getStallName());
            stmt.setString(2, stall.getLocation());
            stmt.setString(3, stall.getStatus().name());
            setNullableInt(stmt, 4, stall.getOwnerId());
            setNullableInt(stmt, 5, stall.getCategoryId());
            stmt.setString(6, stall.getDescription());
            stmt.setString(7, stall.getBackgroundImageUrl());
            stmt.setBigDecimal(8, stall.getRentFee());
            stmt.setString(9, stall.getImages());

            int affectedRows = stmt.executeUpdate();
            if (affectedRows == 0) {
                throw new SQLException("Creating stall failed, no rows affected.");
            }

            try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    stall.setId(generatedKeys.getInt(1));
                } else {
                    throw new SQLException("Creating stall failed, no ID obtained.");
                }
            }
            return stall;
        } catch (SQLException e) {
            logger.error("Error saving stall: " + stall.getStallName(), e);
            throw new RuntimeException(e);
        }
    }

    @Override
    public boolean update(Stall stall) {
        String sql = "UPDATE stalls SET stall_name=?, location=?, status=?, owner_id=?, category_id=?, description=?, background_image_url=?, rent_fee=?, images=? WHERE id=?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, stall.getStallName());
            stmt.setString(2, stall.getLocation());
            stmt.setString(3, stall.getStatus().name());
            setNullableInt(stmt, 4, stall.getOwnerId());
            setNullableInt(stmt, 5, stall.getCategoryId());
            stmt.setString(6, stall.getDescription());
            stmt.setString(7, stall.getBackgroundImageUrl());
            stmt.setBigDecimal(8, stall.getRentFee());
            stmt.setString(9, stall.getImages());
            stmt.setInt(10, stall.getId());

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            logger.error("Error updating stall: " + stall.getId(), e);
            return false;
        }
    }

    @Override
    public boolean delete(Integer id) {
        String sql = "DELETE FROM stalls WHERE id=?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            logger.error("Error deleting stall: " + id, e);
            return false;
        }
    }

    private List<Stall> executeQuery(String sql, Object... params) {
        List<Stall> list = new ArrayList<>();
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            for (int i = 0; i < params.length; i++) {
                stmt.setObject(i + 1, params[i]);
            }

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToStall(rs));
                }
            }
        } catch (SQLException e) {
            logger.error("Error executing query", e);
        }
        return list;
    }

    private Stall mapResultSetToStall(ResultSet rs) throws SQLException {
        Stall stall = new Stall();
        stall.setId(rs.getInt("id"));
        stall.setStallName(rs.getString("stall_name"));
        stall.setLocation(rs.getString("location"));
        stall.setStatus(Stall.Status.valueOf(rs.getString("status")));
        stall.setOwnerId(rs.getInt("owner_id"));
        if (rs.wasNull()) stall.setOwnerId(null);
        stall.setCategoryId(rs.getInt("category_id"));
        if (rs.wasNull()) stall.setCategoryId(null);
        stall.setDescription(rs.getString("description"));
        try {
            stall.setBackgroundImageUrl(rs.getString("background_image_url"));
        } catch (SQLException e) {
            stall.setBackgroundImageUrl(null);
        }
        stall.setRentFee(rs.getBigDecimal("rent_fee"));
        stall.setImages(rs.getString("images"));
        stall.setCreatedAt(rs.getTimestamp("created_at"));
        stall.setUpdatedAt(rs.getTimestamp("updated_at"));
        
        // Transient fields
        try {
            stall.setOwnerName(rs.getString("owner_name"));
            stall.setCategoryName(rs.getString("category_name"));
        } catch (SQLException e) {
            // Ignore if columns not present
        }
        return stall;
    }

    private void setNullableInt(PreparedStatement stmt, int index, Integer value) throws SQLException {
        if (value != null) {
            stmt.setInt(index, value);
        } else {
            stmt.setNull(index, Types.INTEGER);
        }
    }
}
