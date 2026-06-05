package com.foodcourt.controller.owner;

import com.foodcourt.entity.Category;
import com.foodcourt.entity.Stall;
import com.foodcourt.entity.User;
import com.foodcourt.service.StallService;
import com.foodcourt.service.impl.StallServiceImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import java.io.IOException;
import java.math.BigDecimal;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

@WebServlet("/owner/stalls")
@MultipartConfig(maxFileSize = 5 * 1024 * 1024, maxRequestSize = 8 * 1024 * 1024)
public class OwnerStallServlet extends HttpServlet {
    private final StallService stallService = new StallServiceImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("user");
        if (user == null || user.getRoleType() != User.RoleType.OWNER) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String action = req.getParameter("action");
        if ("edit".equals(action) || "create".equals(action)) {
            List<Category> categories = stallService.getAllCategories();
            List<Stall> allStalls = stallService.getAllStalls();
            req.setAttribute("categories", categories);
            req.setAttribute("allStalls", allStalls);
            
            if ("edit".equals(action)) {
                String idStr = req.getParameter("id");
                if (idStr != null) {
                    Optional<Stall> stallOpt = stallService.getStallById(Integer.parseInt(idStr));
                    if (stallOpt.isPresent() && stallOpt.get().getOwnerId().equals(user.getId())) {
                        req.setAttribute("stall", stallOpt.get());
                    } else {
                        resp.sendError(HttpServletResponse.SC_FORBIDDEN);
                        return;
                    }
                }
            }
            req.getRequestDispatcher("/jsp/owner/stall_form.jsp").forward(req, resp);
        } else {
            List<Stall> stalls = stallService.getStallsByOwner(user.getId());
            req.setAttribute("stalls", stalls);
            req.getRequestDispatcher("/jsp/owner/stalls.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("user");
        if (user == null || user.getRoleType() != User.RoleType.OWNER) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        String action = req.getParameter("action");
        if ("updateStatus".equals(action)) {
            int id = Integer.parseInt(req.getParameter("id"));
            String statusStr = req.getParameter("status");
            Optional<Stall> stallOpt = stallService.getStallById(id);
            if (stallOpt.isPresent() && stallOpt.get().getOwnerId().equals(user.getId())) {
                Stall existing = stallOpt.get();
                existing.setStatus(Stall.Status.valueOf(statusStr));
                stallService.updateStall(existing);
            }
            resp.sendRedirect(req.getContextPath() + "/owner/stalls");
            return;
        }
        if ("delete".equals(action)) {
            int id = Integer.parseInt(req.getParameter("id"));
            Optional<Stall> stall = stallService.getStallById(id);
            if (stall.isPresent() && stall.get().getOwnerId().equals(user.getId())) {
                stallService.deleteStall(id);
            }
            resp.sendRedirect(req.getContextPath() + "/owner/stalls");
            return;
        }

        // Handle Create or Update
        String idStr = req.getParameter("id");
        String name = req.getParameter("stallName");
        String location = req.getParameter("location");
        String categoryIdStr = req.getParameter("categoryId");
        String description = req.getParameter("description");
        String statusStr = req.getParameter("status");
        String backgroundImage = req.getParameter("backgroundImage");

        Stall stall = new Stall();
        Stall existingStall = null;
        if (idStr != null && !idStr.isEmpty()) {
            stall.setId(Integer.parseInt(idStr));
            Optional<Stall> existing = stallService.getStallById(stall.getId());
            if (existing.isEmpty() || !existing.get().getOwnerId().equals(user.getId())) {
                resp.sendError(HttpServletResponse.SC_FORBIDDEN);
                return;
            }
            existingStall = existing.get();
        }

        stall.setStallName(name);
        stall.setLocation(location);
        stall.setCategoryId(Integer.parseInt(categoryIdStr));
        stall.setDescription(description);
        stall.setStatus(Stall.Status.valueOf(statusStr));
        stall.setOwnerId(user.getId());
        stall.setRentFee(BigDecimal.ZERO); // Default or managed by admin
        String uploadedBackgroundUrl = storeImageIfPresent(req, "backgroundFile");
        if (uploadedBackgroundUrl != null) {
            backgroundImage = uploadedBackgroundUrl;
        } else if ((backgroundImage == null || backgroundImage.isBlank()) && existingStall != null) {
            backgroundImage = existingStall.getBackgroundImageUrl();
        }
        String backgroundImageUrl = (backgroundImage != null && !backgroundImage.isBlank()) ? backgroundImage.trim() : null;
        stall.setBackgroundImageUrl(backgroundImageUrl);
        if (backgroundImageUrl != null) {
            String safeUrl = backgroundImageUrl.replace("\"", "\\\"");
            stall.setImages("[\"" + safeUrl + "\"]");
        } else {
            stall.setImages(null);
        }
        
        if (stall.getId() == null) {
            stallService.createStall(stall);
        } else {
            stallService.updateStall(stall);
        }

        resp.sendRedirect(req.getContextPath() + "/owner/stalls");
    }

    private String storeImageIfPresent(HttpServletRequest req, String partName) throws IOException, ServletException {
        Part part = req.getPart(partName);
        if (part == null || part.getSize() == 0) {
            return null;
        }
        String contentType = part.getContentType();
        if (contentType == null || !contentType.startsWith("image/")) {
            return null;
        }
        String submittedFileName = part.getSubmittedFileName();
        String fileName = (submittedFileName == null) ? "" : Paths.get(submittedFileName).getFileName().toString();
        String extension = "";
        int dotIndex = fileName.lastIndexOf('.');
        if (dotIndex > -1) {
            extension = fileName.substring(dotIndex);
        }
        String newFileName = "stall-" + UUID.randomUUID() + extension;
        Path runtimeUploadDir = resolveRuntimeUploadsDir();
        Path projectUploadDir = resolveProjectUploadsDir();
        Path primaryUploadDir = runtimeUploadDir != null ? runtimeUploadDir : projectUploadDir;
        if (primaryUploadDir == null) {
            return null;
        }
        Files.createDirectories(primaryUploadDir);
        Path primaryTarget = primaryUploadDir.resolve(newFileName);
        Files.copy(part.getInputStream(), primaryTarget, StandardCopyOption.REPLACE_EXISTING);
        if (projectUploadDir != null && !projectUploadDir.equals(primaryUploadDir)) {
            Files.createDirectories(projectUploadDir);
            Files.copy(primaryTarget, projectUploadDir.resolve(newFileName), StandardCopyOption.REPLACE_EXISTING);
        }
        if (runtimeUploadDir != null && !runtimeUploadDir.equals(primaryUploadDir)) {
            Files.createDirectories(runtimeUploadDir);
            Files.copy(primaryTarget, runtimeUploadDir.resolve(newFileName), StandardCopyOption.REPLACE_EXISTING);
        }
        return req.getContextPath() + "/uploads/" + newFileName;
    }

    private Path resolveProjectUploadsDir() {
        Path projectRoot = resolveProjectRootFromUserDir();
        if (projectRoot == null) {
            projectRoot = resolveProjectRootFromRuntime();
        }
        if (projectRoot == null) {
            return null;
        }
        return projectRoot.resolve(Paths.get("src", "main", "webapp", "uploads"));
    }

    private Path resolveProjectRootFromUserDir() {
        Path current = Paths.get(System.getProperty("user.dir"));
        while (current != null) {
            if (Files.exists(current.resolve("pom.xml"))) {
                return current;
            }
            current = current.getParent();
        }
        return null;
    }

    private Path resolveProjectRootFromRuntime() {
        String realPath = getServletContext().getRealPath("/");
        if (realPath == null || realPath.isBlank()) {
            return null;
        }
        Path current = Paths.get(realPath);
        while (current != null) {
            if (Files.exists(current.resolve("pom.xml"))) {
                return current;
            }
            current = current.getParent();
        }
        return null;
    }

    private Path resolveRuntimeUploadsDir() {
        String realPath = getServletContext().getRealPath("/uploads");
        if (realPath == null || realPath.isBlank()) {
            return null;
        }
        return Paths.get(realPath);
    }
}
