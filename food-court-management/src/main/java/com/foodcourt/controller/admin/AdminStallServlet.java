package com.foodcourt.controller.admin;

import com.foodcourt.entity.Stall;
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

@WebServlet("/admin/stalls")
public class AdminStallServlet extends HttpServlet {
    private final StallService stallService = new StallServiceImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User user = (User) session.getAttribute("user");
        if (user == null || user.getRoleType() != User.RoleType.ADMIN) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String keyword = req.getParameter("keyword");
        List<Stall> stalls = stallService.getAllStalls();
        if (keyword != null && !keyword.isBlank()) {
            String normalized = keyword.trim().toLowerCase();
            stalls = stalls.stream()
                    .filter(stall -> matchesKeyword(stall, normalized))
                    .toList();
        }
        req.setAttribute("stalls", stalls);
        req.getRequestDispatcher("/jsp/admin/stalls.jsp").forward(req, resp);
    }

    private boolean matchesKeyword(Stall stall, String keyword) {
        if (stall == null) {
            return false;
        }
        return containsIgnoreCase(stall.getStallName(), keyword)
                || containsIgnoreCase(stall.getOwnerName(), keyword)
                || containsIgnoreCase(stall.getCategoryName(), keyword)
                || containsIgnoreCase(statusLabel(stall.getStatus()), keyword)
                || containsIgnoreCase(stall.getStatus() != null ? stall.getStatus().name() : null, keyword);
    }

    private boolean containsIgnoreCase(String source, String keyword) {
        return source != null && !keyword.isBlank() && source.toLowerCase().contains(keyword);
    }

    private String statusLabel(Stall.Status status) {
        if (status == null) {
            return null;
        }
        return switch (status) {
            case OPEN -> "营业中";
            case MAINTENANCE -> "维修中";
            case CLOSED -> "已打烊";
            case RENTED -> "已租";
        };
    }
}
