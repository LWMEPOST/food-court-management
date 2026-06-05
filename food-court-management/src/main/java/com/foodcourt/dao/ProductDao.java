package com.foodcourt.dao;

import com.foodcourt.entity.Product;
import java.util.List;
import java.util.Optional;

public interface ProductDao {
    List<Product> findByStallId(Integer stallId);
    List<Product> findLatestAvailable(int limit);
    Optional<Product> findById(Integer id);
    Product save(Product product);
    boolean update(Product product);
    boolean delete(Integer id);
}
