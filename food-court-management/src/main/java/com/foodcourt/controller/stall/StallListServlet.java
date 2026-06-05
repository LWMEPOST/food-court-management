package com.foodcourt.controller.stall;

import com.foodcourt.entity.Category;
import com.foodcourt.entity.Stall;
import com.foodcourt.service.StallService;
import com.foodcourt.service.impl.StallServiceImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet("/stall/list")
public class StallListServlet extends HttpServlet {
    private final StallService stallService = new StallServiceImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String categoryIdStr = req.getParameter("categoryId");
        List<Stall> stalls;

        if (categoryIdStr != null && !categoryIdStr.isEmpty()) {
            try {
                int categoryId = Integer.parseInt(categoryIdStr);
                stalls = stallService.getStallsByCategory(categoryId);
            } catch (NumberFormatException e) {
                stalls = stallService.getAllStalls();
            }
        } else {
            stalls = stallService.getAllStalls();
        }

        // Filter only OPEN stalls for diners
        stalls = stalls.stream()
                .filter(s -> s.getStatus() == Stall.Status.OPEN)
                .collect(Collectors.toList());

        List<Category> categories = stallService.getAllCategories();

        req.setAttribute("stalls", stalls);
        req.setAttribute("categories", categories);
        req.getRequestDispatcher("/jsp/stall/list.jsp").forward(req, resp);
    }
}