package com.foodcourt.service.impl;

import com.foodcourt.dao.ProductDao;
import com.foodcourt.dao.impl.ProductDaoImpl;
import com.foodcourt.entity.Product;
import com.foodcourt.service.ProductService;

import java.util.List;
import java.util.Optional;

public class ProductServiceImpl implements ProductService {
    private final ProductDao productDao = new ProductDaoImpl();

    @Override
    public List<Product> getProductsByStallId(Integer stallId) {
        return productDao.findByStallId(stallId);
    }

    @Override
    public List<Product> getLatestAvailableProducts(int limit) {
        return productDao.findLatestAvailable(limit);
    }

    @Override
    public Optional<Product> getProductById(Integer id) {
        return productDao.findById(id);
    }

    @Override
    public Product createProduct(Product product) {
        return productDao.save(product);
    }

    @Override
    public boolean updateProduct(Product product) {
        return productDao.update(product);
    }

    @Override
    public boolean deleteProduct(Integer id) {
        return productDao.delete(id);
    }
}
