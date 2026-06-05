package com.foodcourt.dao.impl;

import com.foodcourt.dao.LeaseDao;
import com.foodcourt.entity.Lease;
import com.foodcourt.util.DatabaseUtil;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class LeaseDaoImpl implements LeaseDao {
    private static final Logger logger = LogManager.getLogger(LeaseDaoImpl.class);

    @Override
    public List<Lease> findAll() {
        String sql = "SELECT l.*, s.stall_name, u.username as owner_name " +
                     "FROM leases l " +
                     "LEFT JOIN stalls s ON l.stall_id = s.id " +
                     "LEFT JOIN users u ON l.owner_id = u.id " +
                     "ORDER BY l.created_at DESC";
        return executeQuery(sql);
    }

    @Override
    public List<Lease> findByOwnerId(Integer ownerId) {
        String sql = "SELECT l.*, s.stall_name, u.username as owner_name " +
                     "FROM leases l " +
                     "LEFT JOIN stalls s ON l.stall_id = s.id " +
                     "LEFT JOIN users u ON l.owner_id = u.id " +
                     "WHERE l.owner_id = ? ORDER BY l.created_at DESC";
        return executeQuery(sql, ownerId);
    }

    @Override
    public Optional<Lease> findById(Integer id) {
        String sql = "SELECT l.*, s.stall_name, u.username as owner_name " +
                     "FROM leases l " +
                     "LEFT JOIN stalls s ON l.stall_id = s.id " +
                     "LEFT JOIN users u ON l.owner_id = u.id " +
                     "WHERE l.id = ?";
        List<Lease> leases = executeQuery(sql, id);
        return leases.isEmpty() ? Optional.empty() : Optional.of(leases.get(0));
    }

    @Override
    public Lease save(Lease lease) {
        String sql = "INSERT INTO leases (stall_id, owner_id, type, status, start_date, end_date, contract_content) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            setStatementParams(stmt, lease);

            int affectedRows = stmt.executeUpdate();
            if (affectedRows == 0) {
                throw new SQLException("Creating lease failed, no rows affected.");
            }

            try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    lease.setId(generatedKeys.getInt(1));
                } else {
                    throw new SQLException("Creating lease failed, no ID obtained.");
                }
            }
            return lease;
        } catch (SQLException e) {
            logger.error("Error saving lease", e);
            throw new RuntimeException(e);
        }
    }

    @Override
    public boolean update(Lease lease) {
        String sql = "UPDATE leases SET stall_id=?, owner_id=?, type=?, status=?, start_date=?, end_date=?, contract_content=? " +
                     "WHERE id=?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            setStatementParams(stmt, lease);
            stmt.setInt(8, lease.getId());

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            logger.error("Error updating lease", e);
            return false;
        }
    }

    @Override
    public boolean delete(Integer id) {
        String sql = "DELETE FROM leases WHERE id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            logger.error("Error deleting lease", e);
            return false;
        }
    }

    private void setStatementParams(PreparedStatement stmt, Lease lease) throws SQLException {
        stmt.setObject(1, lease.getStallId());
        stmt.setInt(2, lease.getOwnerId());
        stmt.setString(3, lease.getType().name());
        stmt.setString(4, lease.getStatus().name());
        stmt.setTimestamp(5, lease.getStartDate());
        stmt.setTimestamp(6, lease.getEndDate());
        stmt.setString(7, lease.getContractContent());
    }

    private List<Lease> executeQuery(String sql, Object... params) {
        List<Lease> list = new ArrayList<>();
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            for (int i = 0; i < params.length; i++) {
                stmt.setObject(i + 1, params[i]);
            }

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToLease(rs));
                }
            }
        } catch (SQLException e) {
            logger.error("Error executing lease query", e);
        }
        return list;
    }

    private Lease mapResultSetToLease(ResultSet rs) throws SQLException {
        Lease lease = new Lease();
        lease.setId(rs.getInt("id"));
        lease.setStallId((Integer) rs.getObject("stall_id"));
        lease.setOwnerId(rs.getInt("owner_id"));
        lease.setType(Lease.Type.valueOf(rs.getString("type")));
        lease.setStatus(Lease.Status.valueOf(rs.getString("status")));
        lease.setStartDate(rs.getTimestamp("start_date"));
        lease.setEndDate(rs.getTimestamp("end_date"));
        lease.setContractContent(rs.getString("contract_content"));
        lease.setCreatedAt(rs.getTimestamp("created_at"));
        lease.setUpdatedAt(rs.getTimestamp("updated_at"));
        
        // Transient
        try {
            lease.setStallName(rs.getString("stall_name"));
        } catch (SQLException ignored) {}
        try {
            lease.setOwnerName(rs.getString("owner_name"));
        } catch (SQLException ignored) {}
        
        return lease;
    }
}
