package com.foodcourt.entity;

import java.sql.Timestamp;

public class Category {
    private Integer id;
    private String categoryName;
    private String description;
    private Integer sortOrder;
    private String iconUrl;
    private Integer regionCapacity;
    private Timestamp createdAt;

    // Getters and Setters
    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }

    public String getCategoryName() { return categoryName; }
    public void setCategoryName(String categoryName) { this.categoryName = categoryName; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public Integer getSortOrder() { return sortOrder; }
    public void setSortOrder(Integer sortOrder) { this.sortOrder = sortOrder; }

    public String getIconUrl() { return iconUrl; }
    public void setIconUrl(String iconUrl) { this.iconUrl = iconUrl; }

    public Integer getRegionCapacity() { return regionCapacity; }
    public void setRegionCapacity(Integer regionCapacity) { this.regionCapacity = regionCapacity; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}
