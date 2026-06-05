package com.foodcourt.controller.stall;

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
import java.util.Optional;
import java.util.stream.Collectors;

@WebServlet("/stall/detail")
public class StallDetailServlet extends HttpServlet {
    private final StallService stallService = new StallServiceImpl();
    private final ProductService productService = new ProductServiceImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String idStr = req.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/stall/list");
            return;
        }

        try {
            int stallId = Integer.parseInt(idStr);
            Optional<Stall> stallOpt = stallService.getStallById(stallId);

            if (stallOpt.isPresent()) {
                Stall stall = stallOpt.get();
                if (stall.getStatus() != Stall.Status.OPEN) {
                    req.setAttribute("error", "该摊位暂时未营业");
                }
                
                List<Product> products = productService.getProductsByStallId(stallId);
                // Filter only AVAILABLE products for diners
                products = products.stream()
                        .filter(p -> p.getStatus() == Product.Status.AVAILABLE)
                        .collect(Collectors.toList());

                req.setAttribute("stall", stall);
                req.setAttribute("products", products);
                req.getRequestDispatcher("/jsp/stall/detail.jsp").forward(req, resp);
            } else {
                resp.sendError(HttpServletResponse.SC_NOT_FOUND, "摊位未找到");
            }
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/stall/list");
        }
    }
}