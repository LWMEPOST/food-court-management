package com.foodcourt.dao;

import com.foodcourt.entity.Category;
import java.util.List;
import java.util.Optional;

public interface CategoryDao {
    List<Category> findAll();
    Optional<Category> findById(Integer id);
    Category save(Category category);
    boolean update(Category category);
    boolean delete(Integer id);
}