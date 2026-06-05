package com.foodcourt.controller.owner;

import com.foodcourt.entity.Lease;
import com.foodcourt.entity.Stall;
import com.foodcourt.entity.User;
import com.foodcourt.service.LeaseService;
import com.foodcourt.service.StallService;
import com.foodcourt.service.impl.LeaseServiceImpl;
import com.foodcourt.service.impl.StallServiceImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.List;

@WebServlet("/owner/leases")
public class OwnerLeaseServlet extends HttpServlet {
    private final LeaseService leaseService = new LeaseServiceImpl();
    private final StallService stallService = new StallServiceImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        User user = (User) session.getAttribute("user");
        if (user == null || user.getRoleType() != User.RoleType.OWNER) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String action = req.getParameter("action");
        if ("apply".equals(action)) {
            // Get stalls owned by user to select from, or potentially unassigned stalls if they can lease new ones
            // For simplicity, assuming they apply for their existing stalls (renewal) or new ones (need logic)
            // Let's assume they can only renew or formalize existing stalls for now, or select from list.
            List<Stall> stalls = stallService.getStallsByOwner(user.getId());
            req.setAttribute("stalls", stalls);
            req.getRequestDispatcher("/jsp/owner/leases/form.jsp").forward(req, resp);
        } else {
            List<Lease> leases = leaseService.getLeasesByOwner(user.getId());
            req.setAttribute("leases", leases);
            req.getRequestDispatcher("/jsp/owner/leases/list.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }
        User user = (User) session.getAttribute("user");
        if (user == null || user.getRoleType() != User.RoleType.OWNER) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        try {
            int stallId = Integer.parseInt(req.getParameter("stallId"));
            String typeStr = req.getParameter("type");
            String startDateStr = req.getParameter("startDate");
            String endDateStr = req.getParameter("endDate");

            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
            Timestamp startDate = new Timestamp(dateFormat.parse(startDateStr).getTime());
            Timestamp endDate = new Timestamp(dateFormat.parse(endDateStr).getTime());

            Lease lease = new Lease();
            lease.setStallId(stallId);
            lease.setOwnerId(user.getId());
            lease.setType(Lease.Type.valueOf(typeStr));
            lease.setStartDate(startDate);
            lease.setEndDate(endDate);
            lease.setStatus(Lease.Status.PENDING);

            leaseService.createLeaseApplication(lease);

            resp.sendRedirect(req.getContextPath() + "/owner/leases?submitted=true");
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "提交申请失败：" + e.getMessage());
            List<Stall> stalls = stallService.getStallsByOwner(user.getId());
            req.setAttribute("stalls", stalls);
            req.getRequestDispatcher("/jsp/owner/leases/form.jsp").forward(req, resp);
        }
    }
}
