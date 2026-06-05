package com.foodcourt.dao;

import com.foodcourt.entity.Stall;
import java.util.List;
import java.util.Optional;

public interface StallDao {
    List<Stall> findAll();
    List<Stall> findLatestOpen(int limit);
    List<Stall> findByOwnerId(Integer ownerId);
    List<Stall> findByCategoryId(Integer categoryId);
    Optional<Stall> findById(Integer id);
    Stall save(Stall stall);
    boolean update(Stall stall);
    boolean delete(Integer id);
}
