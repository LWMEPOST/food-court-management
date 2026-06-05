package com.foodcourt.util;

import java.nio.file.Files;
import java.nio.file.Paths;
import java.sql.Connection;
import java.sql.Statement;

public class MockDataRunner {
    public static void main(String[] args) {
        System.out.println("开始导入模拟数据...");
        
        // Path to the SQL file - assuming run from project root
        String sqlFilePath = "sql/mock_data_expansion.sql";
        
        try (Connection conn = DatabaseUtil.getConnection();
             Statement stmt = conn.createStatement()) {
            
            // Read the file content
            String sql = new String(Files.readAllBytes(Paths.get(sqlFilePath)), "UTF-8");
            
            // Split by semicolon to get individual statements
            // Note: This is a simple splitter and might break if semicolons are inside strings.
            // Given our mock data, we don't have semicolons inside the content strings, so it's safe.
            String[] statements = sql.split(";");
            
            int successCount = 0;
            int failCount = 0;

            for (String s : statements) {
                String query = s.trim();
                if (query.isEmpty()) continue;
                
                try {
                    stmt.execute(query);
                    successCount++;
                    // Print a brief success message (first 50 chars)
                    String preview = query.length() > 50 ? query.substring(0, 50) + "..." : query;
                    System.out.println("Success: " + preview.replace("\n", " "));
                } catch (Exception e) {
                    failCount++;
                    System.err.println("Failed to execute: " + query);
                    System.err.println("Error: " + e.getMessage());
                }
            }
            
            System.out.println("----------------------------------------");
            System.out.println("导入摘要:");
            System.out.println("成功执行语句数: " + successCount);
            System.out.println("失败语句数: " + failCount);
            System.out.println("模拟数据导入流程结束。");
            
        } catch (Exception e) {
            e.printStackTrace();
            System.err.println("严重错误: " + e.getMessage());
        } finally {
            // Close the pool since this is a standalone app
            DatabaseUtil.close();
        }
    }
}
