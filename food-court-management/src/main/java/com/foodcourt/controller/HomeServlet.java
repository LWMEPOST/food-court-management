package com.foodcourt.controller;

import com.foodcourt.entity.Product;
import com.foodcourt.entity.Stall;
import com.foodcourt.service.ProductService;
import com.foodcourt.service.StallService;
import com.foodcourt.service.impl.ProductServiceImpl;
import com.foodcourt.service.impl.StallServiceImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet({"/", "/home"})
public class HomeServlet extends HttpServlet {
    private final ProductService productService = new ProductServiceImpl();
    private final StallService stallService = new StallServiceImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<Product> featuredProducts = productService.getLatestAvailableProducts(6);
        List<Stall> recommendedStalls = stallService.getLatestOpenStalls(4);

        Product promotionProduct = featuredProducts.isEmpty() ? null : featuredProducts.get(0);

        req.setAttribute("featuredProducts", featuredProducts);
        req.setAttribute("recommendedStalls", recommendedStalls);
        req.setAttribute("promotionProduct", promotionProduct);
        req.getRequestDispatcher("/index.jsp").forward(req, resp);
    }
}
