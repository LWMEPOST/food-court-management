package com.foodcourt.controller.admin;

import com.foodcourt.dao.CategoryDao;
import com.foodcourt.dao.impl.CategoryDaoImpl;
import com.foodcourt.entity.Category;
import com.foodcourt.entity.User;
import com.foodcourt.service.StallService;
import com.foodcourt.service.impl.StallServiceImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;
import java.util.Optional;

@WebServlet("/admin/categories")
public class AdminCategoryServlet extends HttpServlet {
    private final StallService stallService = new StallServiceImpl();
    private final CategoryDao categoryDao = new CategoryDaoImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User user = (User) session.getAttribute("user");
        if (user == null || user.getRoleType() != User.RoleType.ADMIN) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String keyword = req.getParameter("keyword");
        List<Category> categories = stallService.getAllCategories();
        if (keyword != null && !keyword.isBlank()) {
            String normalized = keyword.trim().toLowerCase();
            categories = categories.stream()
                    .filter(category -> matchesKeyword(category, normalized))
                    .toList();
        }
        req.setAttribute("categories", categories);
        req.getRequestDispatcher("/jsp/admin/categories.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User user = (User) session.getAttribute("user");
        if (user == null || user.getRoleType() != User.RoleType.ADMIN) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String action = req.getParameter("action");
        if ("updateCapacity".equals(action)) {
            String idStr = req.getParameter("id");
            String capacityStr = req.getParameter("regionCapacity");
            if (idStr != null && capacityStr != null) {
                int id = Integer.parseInt(idStr);
                int capacity = Integer.parseInt(capacityStr);
                Optional<Category> categoryOpt = categoryDao.findById(id);
                if (categoryOpt.isPresent()) {
                    Category category = categoryOpt.get();
                    category.setRegionCapacity(capacity);
                    categoryDao.update(category);
                }
            }
        }

        resp.sendRedirect(req.getContextPath() + "/admin/categories");
    }

    private boolean matchesKeyword(Category category, String keyword) {
        if (category == null) {
            return false;
        }
        return containsIgnoreCase(category.getCategoryName(), keyword)
                || containsIgnoreCase(category.getDescription(), keyword);
    }

    private boolean containsIgnoreCase(String source, String keyword) {
        return source != null && !keyword.isBlank() && source.toLowerCase().contains(keyword);
    }
}
