# 美食街摊位管理系统

## 项目介绍

本项目是一个基于 Java Web 的美食街摊位管理系统，为摊主、顾客和管理员提供摊位维护、商品管理、购物车、在线下单、订单跟踪和后台管理等功能。

## 技术栈

- Java Servlet / JSP
- Maven
- MySQL
- HikariCP 数据库连接池
- Log4j2
- Bootstrap 5

## 部署要求

- JDK 8 或以上
- Maven 3.x
- MySQL 5.7/8.0
- Tomcat 9/10
- 浏览器环境

## 运行流程

1. 创建 MySQL 数据库并导入项目 SQL。
2. 修改数据库连接配置，确保账号、密码和库名正确。
3. 执行 mvn clean package 构建项目。
4. 将 WAR 部署到 Tomcat 或使用 IDE 运行 Web 项目。
5. 访问系统首页，按管理员、摊主、顾客角色测试业务流程。

## 项目结构

- food-court-management：系统主体代码
- src/main/java：Servlet、DAO、Service 等后端代码
- src/main/webapp：JSP 页面和静态资源
- pom.xml：依赖和构建配置

## 上传说明

本仓库只保留项目运行和二次开发所需的代码、配置、数据库脚本及少量必要静态资源。

以下内容不会上传：论文、答辩材料、临时文档、依赖目录、构建产物、压缩包、数据集、模型权重、视频、日志、本地工具包以及密钥配置。
