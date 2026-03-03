package com.foodcourt.util;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.Properties;

public class DatabaseUtil {
    private static final Logger logger = LogManager.getLogger(DatabaseUtil.class);
    private static HikariDataSource dataSource;

    static {
        try (InputStream input = DatabaseUtil.class.getClassLoader().getResourceAsStream("db.properties")) {
            if (input == null) {
                logger.error("抱歉，找不到db.properties文件");
                throw new RuntimeException("未找到db.properties文件");
            }

            Properties prop = new Properties();
            prop.load(input);

            HikariConfig config = new HikariConfig();
            config.setJdbcUrl(prop.getProperty("db.url"));
            config.setUsername(prop.getProperty("db.username"));
            config.setPassword(prop.getProperty("db.password"));
            config.setDriverClassName(prop.getProperty("db.driver"));
            
            // Pool configuration
            config.setMaximumPoolSize(Integer.parseInt(prop.getProperty("db.pool.size", "10")));
            config.setMinimumIdle(Integer.parseInt(prop.getProperty("db.pool.minIdle", "5")));
            config.setConnectionTimeout(Long.parseLong(prop.getProperty("db.pool.timeout", "30000")));

            dataSource = new HikariDataSource(config);
            logger.info("Database connection pool initialized successfully.");

        } catch (IOException ex) {
            logger.error("加载数据库配置失败", ex);
            throw new RuntimeException("加载数据库配置失败", ex);
        }
    }

    public static Connection getConnection() throws SQLException {
        return dataSource.getConnection();
    }

    public static void close() {
        if (dataSource != null && !dataSource.isClosed()) {
            dataSource.close();
            logger.info("Database connection pool closed.");
        }
    }
}
