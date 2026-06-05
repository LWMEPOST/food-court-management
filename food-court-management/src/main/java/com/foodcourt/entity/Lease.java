package com.foodcourt.entity;

import java.sql.Timestamp;

public class Lease {
    private Integer id;
    private Integer stallId;
    private Integer ownerId;
    private Type type;
    private Status status;
    private Timestamp startDate;
    private Timestamp endDate;
    private String contractContent;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    // Transient fields
    private String stallName;
    private String ownerName;

    public enum Type {
        NEW, RENEWAL
    }

    public enum Status {
        PENDING, APPROVED, REJECTED, ACTIVE, EXPIRED, TERMINATED
    }

    // Getters and Setters
    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }

    public Integer getStallId() { return stallId; }
    public void setStallId(Integer stallId) { this.stallId = stallId; }

    public Integer getOwnerId() { return ownerId; }
    public void setOwnerId(Integer ownerId) { this.ownerId = ownerId; }

    public Type getType() { return type; }
    public void setType(Type type) { this.type = type; }

    public Status getStatus() { return status; }
    public void setStatus(Status status) { this.status = status; }

    public Timestamp getStartDate() { return startDate; }
    public void setStartDate(Timestamp startDate) { this.startDate = startDate; }

    public Timestamp getEndDate() { return endDate; }
    public void setEndDate(Timestamp endDate) { this.endDate = endDate; }

    public String getContractContent() { return contractContent; }
    public void setContractContent(String contractContent) { this.contractContent = contractContent; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }

    public String getStallName() { return stallName; }
    public void setStallName(String stallName) { this.stallName = stallName; }

    public String getOwnerName() { return ownerName; }
    public void setOwnerName(String ownerName) { this.ownerName = ownerName; }
}
