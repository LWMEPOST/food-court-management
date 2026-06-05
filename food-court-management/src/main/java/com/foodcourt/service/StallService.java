package com.foodcourt.service;

import com.foodcourt.entity.Category;
import com.foodcourt.entity.Stall;
import java.util.List;
import java.util.Optional;

public interface StallService {
    List<Stall> getAllStalls();
    List<Stall> getLatestOpenStalls(int limit);
    List<Stall> getStallsByOwner(Integer ownerId);
    List<Stall> getStallsByCategory(Integer categoryId);
    Optional<Stall> getStallById(Integer id);
    Stall createStall(Stall stall);
    boolean updateStall(Stall stall);
    boolean deleteStall(Integer id);
    List<Category> getAllCategories();
}
