package com.foodcourt.controller.owner;

import com.foodcourt.entity.Product;
import com.foodcourt.entity.Stall;
import com.foodcourt.entity.User;
import com.foodcourt.service.ProductService;
import com.foodcourt.service.StallService;
import com.foodcourt.service.impl.ProductServiceImpl;
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

@WebServlet("/owner/products")
@MultipartConfig(maxFileSize = 5 * 1024 * 1024, maxRequestSize = 8 * 1024 * 1024)
public class OwnerProductServlet extends HttpServlet {
    private final ProductService productService = new ProductServiceImpl();
    private final StallService stallService = new StallServiceImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("user");
        if (user == null || user.getRoleType() != User.RoleType.OWNER) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String action = req.getParameter("action");
        String stallIdStr = req.getParameter("stallId");

        if (stallIdStr == null || stallIdStr.isEmpty()) {
            // Select stall first
            List<Stall> stalls = stallService.getStallsByOwner(user.getId());
            req.setAttribute("stalls", stalls);
            req.getRequestDispatcher("/jsp/owner/product_stall_select.jsp").forward(req, resp);
            return;
        }

        int stallId = Integer.parseInt(stallIdStr);
        // Verify ownership
        Optional<Stall> stallOpt = stallService.getStallById(stallId);
        if (stallOpt.isEmpty() || !stallOpt.get().getOwnerId().equals(user.getId())) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        if ("edit".equals(action) || "create".equals(action)) {
            req.setAttribute("stallId", stallId);
            if ("edit".equals(action)) {
                String idStr = req.getParameter("id");
                if (idStr != null) {
                    Optional<Product> productOpt = productService.getProductById(Integer.parseInt(idStr));
                    if (productOpt.isPresent() && productOpt.get().getStallId() == stallId) {
                        req.setAttribute("product", productOpt.get());
                    } else {
                        resp.sendError(HttpServletResponse.SC_FORBIDDEN);
                        return;
                    }
                }
            }
            req.getRequestDispatcher("/jsp/owner/product_form.jsp").forward(req, resp);
        } else {
            List<Product> products = productService.getProductsByStallId(stallId);
            req.setAttribute("products", products);
            req.setAttribute("stall", stallOpt.get());
            req.getRequestDispatcher("/jsp/owner/products.jsp").forward(req, resp);
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
        int stallId = Integer.parseInt(req.getParameter("stallId"));

        // Verify ownership
        Optional<Stall> stallOpt = stallService.getStallById(stallId);
        if (stallOpt.isEmpty() || !stallOpt.get().getOwnerId().equals(user.getId())) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        if ("delete".equals(action)) {
            int id = Integer.parseInt(req.getParameter("id"));
            Optional<Product> product = productService.getProductById(id);
            if (product.isPresent() && product.get().getStallId() == stallId) {
                productService.deleteProduct(id);
            }
            resp.sendRedirect(req.getContextPath() + "/owner/products?stallId=" + stallId);
            return;
        }

        // Handle Create or Update
        String idStr = req.getParameter("id");
        String name = req.getParameter("productName");
        String priceStr = req.getParameter("price");
        String description = req.getParameter("description");
        String statusStr = req.getParameter("status");
        String imageUrl = req.getParameter("imageUrl");

        Product product = new Product();
        Product existingProduct = null;
        if (idStr != null && !idStr.isEmpty()) {
            product.setId(Integer.parseInt(idStr));
            Optional<Product> existing = productService.getProductById(product.getId());
            if (existing.isEmpty() || existing.get().getStallId() != stallId) {
                resp.sendError(HttpServletResponse.SC_FORBIDDEN);
                return;
            }
            existingProduct = existing.get();
        }

        String uploadedImageUrl = storeImageIfPresent(req, "imageFile");
        if (uploadedImageUrl != null) {
            imageUrl = uploadedImageUrl;
        } else if ((imageUrl == null || imageUrl.isBlank()) && existingProduct != null) {
            imageUrl = existingProduct.getImageUrl();
        }

        product.setProductName(name);
        product.setPrice(new BigDecimal(priceStr));
        product.setDescription(description);
        product.setImageUrl(imageUrl);
        product.setStatus(Product.Status.valueOf(statusStr));
        product.setStallId(stallId);

        if (product.getId() == null) {
            productService.createProduct(product);
        } else {
            productService.updateProduct(product);
        }

        resp.sendRedirect(req.getContextPath() + "/owner/products?stallId=" + stallId);
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
        String newFileName = "product-" + UUID.randomUUID() + extension;
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
