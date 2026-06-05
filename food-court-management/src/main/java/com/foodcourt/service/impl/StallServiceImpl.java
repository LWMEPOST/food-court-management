package com.foodcourt.service.impl;

import com.foodcourt.dao.CategoryDao;
import com.foodcourt.dao.StallDao;
import com.foodcourt.dao.impl.CategoryDaoImpl;
import com.foodcourt.dao.impl.StallDaoImpl;
import com.foodcourt.entity.Category;
import com.foodcourt.entity.Stall;
import com.foodcourt.service.StallService;

import java.util.List;
import java.util.Optional;

public class StallServiceImpl implements StallService {
    private final StallDao stallDao = new StallDaoImpl();
    private final CategoryDao categoryDao = new CategoryDaoImpl();

    @Override
    public List<Stall> getAllStalls() {
        return stallDao.findAll();
    }

    @Override
    public List<Stall> getLatestOpenStalls(int limit) {
        return stallDao.findLatestOpen(limit);
    }

    @Override
    public List<Stall> getStallsByOwner(Integer ownerId) {
        return stallDao.findByOwnerId(ownerId);
    }

    @Override
    public List<Stall> getStallsByCategory(Integer categoryId) {
        return stallDao.findByCategoryId(categoryId);
    }

    @Override
    public Optional<Stall> getStallById(Integer id) {
        return stallDao.findById(id);
    }

    @Override
    public Stall createStall(Stall stall) {
        // Business validation logic can go here
        return stallDao.save(stall);
    }

    @Override
    public boolean updateStall(Stall stall) {
        // Business validation logic can go here
        return stallDao.update(stall);
    }

    @Override
    public boolean deleteStall(Integer id) {
        // Check if stall has active orders or contracts before deleting
        return stallDao.delete(id);
    }

    @Override
    public List<Category> getAllCategories() {
        return categoryDao.findAll();
    }
}
