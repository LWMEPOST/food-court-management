package com.foodcourt.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.OutputStream;
import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/uploads/*")
public class UploadsServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String pathInfo = req.getPathInfo();
        if (pathInfo == null || pathInfo.equals("/")) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        String rawFileName = pathInfo.substring(1);
        String decodedFileName = URLDecoder.decode(rawFileName, StandardCharsets.UTF_8);
        if (decodedFileName.isBlank()
                || decodedFileName.contains("..")
                || decodedFileName.contains("/")
                || decodedFileName.contains("\\")) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        Path filePath = resolveUploadsFile(decodedFileName);
        if (filePath == null || !Files.exists(filePath)) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        String contentType = Files.probeContentType(filePath);
        if (contentType == null || contentType.isBlank()) {
            contentType = "application/octet-stream";
        }

        resp.setContentType(contentType);
        resp.setContentLengthLong(Files.size(filePath));
        try (OutputStream outputStream = resp.getOutputStream()) {
            Files.copy(filePath, outputStream);
        }
    }

    private Path resolveUploadsFile(String fileName) {
        for (Path baseDir : resolveUploadDirectories()) {
            Path candidate = baseDir.resolve(fileName);
            if (Files.exists(candidate)) {
                return candidate;
            }
        }
        return null;
    }

    private List<Path> resolveUploadDirectories() {
        List<Path> directories = new ArrayList<>();
        Path runtimeUploadDir = resolveRuntimeUploadsDir();
        if (runtimeUploadDir != null) {
            directories.add(runtimeUploadDir);
        }

        Path projectUploadDir = resolveProjectUploadsDir();
        if (projectUploadDir != null && !directories.contains(projectUploadDir)) {
            directories.add(projectUploadDir);
        }

        Path targetUploadDir = resolveTargetUploadsDir(projectUploadDir);
        if (targetUploadDir != null && !directories.contains(targetUploadDir)) {
            directories.add(targetUploadDir);
        }

        return directories;
    }

    private Path resolveRuntimeUploadsDir() {
        String realPath = getServletContext().getRealPath("/uploads");
        if (realPath == null || realPath.isBlank()) {
            return null;
        }
        return Paths.get(realPath);
    }

    private Path resolveProjectUploadsDir() {
        Path current = Paths.get(System.getProperty("user.dir"));
        Path projectRoot = null;
        while (current != null) {
            if (Files.exists(current.resolve("pom.xml"))) {
                projectRoot = current;
                break;
            }
            current = current.getParent();
        }
        if (projectRoot == null) {
            return null;
        }
        return projectRoot.resolve(Paths.get("src", "main", "webapp", "uploads"));
    }

    private Path resolveTargetUploadsDir(Path projectUploadDir) {
        if (projectUploadDir == null) {
            return null;
        }
        Path projectRoot = projectUploadDir.getParent().getParent().getParent().getParent();
        if (projectRoot == null) {
            return null;
        }
        return projectRoot.resolve(Paths.get("target", "food-court", "uploads"));
    }
}
