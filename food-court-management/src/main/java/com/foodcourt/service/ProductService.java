package com.foodcourt.service;

import com.foodcourt.entity.Product;
import java.util.List;
import java.util.Optional;

public interface ProductService {
    List<Product> getProductsByStallId(Integer stallId);
    List<Product> getLatestAvailableProducts(int limit);
    Optional<Product> getProductById(Integer id);
    Product createProduct(Product product);
    boolean updateProduct(Product product);
    boolean deleteProduct(Integer id);
}
