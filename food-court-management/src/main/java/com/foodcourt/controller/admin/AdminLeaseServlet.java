package com.foodcourt.controller.admin;

import com.foodcourt.entity.Lease;
import com.foodcourt.entity.User;
import com.foodcourt.service.LeaseService;
import com.foodcourt.service.impl.LeaseServiceImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;
import java.util.Optional;

@WebServlet("/admin/leases")
public class AdminLeaseServlet extends HttpServlet {
    private final LeaseService leaseService = new LeaseServiceImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User user = (User) session.getAttribute("user");
        if (user == null || user.getRoleType() != User.RoleType.ADMIN) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String action = req.getParameter("action");
        if ("view".equals(action)) {
            // Not implemented for this iteration, simple list is enough
        }

        String keyword = req.getParameter("keyword");
        List<Lease> leases = leaseService.getAllLeases();
        if (keyword != null && !keyword.isBlank()) {
            String normalized = keyword.trim().toLowerCase();
            leases = leases.stream()
                    .filter(lease -> matchesKeyword(lease, normalized))
                    .toList();
        }
        req.setAttribute("leases", leases);
        req.getRequestDispatcher("/jsp/admin/leases/list.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User user = (User) session.getAttribute("user");
        if (user == null || user.getRoleType() != User.RoleType.ADMIN) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        String action = req.getParameter("action");
        try {
            if ("updateStatus".equals(action)) {
                int leaseId = Integer.parseInt(req.getParameter("leaseId"));
                String statusStr = req.getParameter("status");
                Lease.Status status = Lease.Status.valueOf(statusStr);
                
                if (status == Lease.Status.APPROVED) {
                    // Logic to set start/end date could be here or in service, 
                    // for now just approve it.
                }
                
                leaseService.updateLeaseStatus(leaseId, status);
            } else if ("generateContract".equals(action)) {
                int leaseId = Integer.parseInt(req.getParameter("leaseId"));
                Optional<Lease> leaseOpt = leaseService.getLeaseById(leaseId);
                if (leaseOpt.isPresent()) {
                    Lease lease = leaseOpt.get();
                    String contract = leaseService.generateContract(lease);
                    lease.setContractContent(contract);
                    leaseService.updateLease(lease);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            // Handle error appropriately
        }

        resp.sendRedirect(req.getContextPath() + "/admin/leases");
    }

    private boolean matchesKeyword(Lease lease, String keyword) {
        if (lease == null) {
            return false;
        }
        return containsIgnoreCase(lease.getStallName(), keyword)
                || containsIgnoreCase(lease.getOwnerName(), keyword)
                || containsIgnoreCase(statusLabel(lease.getStatus()), keyword)
                || containsIgnoreCase(typeLabel(lease.getType()), keyword)
                || containsIgnoreCase(lease.getStatus() != null ? lease.getStatus().name() : null, keyword)
                || containsIgnoreCase(lease.getType() != null ? lease.getType().name() : null, keyword)
                || containsIgnoreCase(lease.getId() != null ? String.valueOf(lease.getId()) : null, keyword);
    }

    private boolean containsIgnoreCase(String source, String keyword) {
        return source != null && !keyword.isBlank() && source.toLowerCase().contains(keyword);
    }

    private String statusLabel(Lease.Status status) {
        if (status == null) {
            return null;
        }
        return switch (status) {
            case PENDING -> "待审核";
            case APPROVED -> "已通过";
            case REJECTED -> "已拒绝";
            case ACTIVE -> "生效中";
            case EXPIRED -> "已过期";
            case TERMINATED -> "已终止";
        };
    }

    private String typeLabel(Lease.Type type) {
        if (type == null) {
            return null;
        }
        return switch (type) {
            case NEW -> "新租";
            case RENEWAL -> "续租";
        };
    }
}
