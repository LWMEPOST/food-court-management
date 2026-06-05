package com.foodcourt.entity;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class Stall {
    private Integer id;
    private String stallName;
    private String location;
    private Status status;
    private Integer ownerId;
    private Integer categoryId;
    private String description;
    private String backgroundImageUrl;
    private BigDecimal rentFee;
    private String images; // JSON string
    private Timestamp createdAt;
    private Timestamp updatedAt;

    // Transient fields for display
    private String ownerName;
    private String categoryName;

    public enum Status {
        OPEN, CLOSED, MAINTENANCE, RENTED
    }

    // Getters and Setters
    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }

    public String getStallName() { return stallName; }
    public void setStallName(String stallName) { this.stallName = stallName; }

    public String getLocation() { return location; }
    public void setLocation(String location) { this.location = location; }

    public Status getStatus() { return status; }
    public void setStatus(Status status) { this.status = status; }

    public Integer getOwnerId() { return ownerId; }
    public void setOwnerId(Integer ownerId) { this.ownerId = ownerId; }

    public Integer getCategoryId() { return categoryId; }
    public void setCategoryId(Integer categoryId) { this.categoryId = categoryId; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getBackgroundImageUrl() { return backgroundImageUrl; }
    public void setBackgroundImageUrl(String backgroundImageUrl) { this.backgroundImageUrl = backgroundImageUrl; }

    public BigDecimal getRentFee() { return rentFee; }
    public void setRentFee(BigDecimal rentFee) { this.rentFee = rentFee; }

    public String getImages() { return images; }
    public void setImages(String images) { this.images = images; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }

    public String getOwnerName() { return ownerName; }
    public void setOwnerName(String ownerName) { this.ownerName = ownerName; }

    public String getCategoryName() { return categoryName; }
    public void setCategoryName(String categoryName) { this.categoryName = categoryName; }
}
