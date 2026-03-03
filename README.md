# 美食街摊位管理系统

## 项目简介

美食街摊位管理系统是一个基于Java Web技术开发的在线美食订购平台，为美食街的摊主和顾客提供便捷的订单管理和商品浏览服务。

## 技术栈

- **后端框架**: Java Servlet + JSP
- **数据库**: MySQL
- **连接池**: HikariCP
- **前端框架**: Bootstrap 5
- **日志框架**: Log4j2
- **构建工具**: Maven

## 功能模块

### 1. 用户管理
- 用户注册与登录
- 角色区分：管理员、摊主、顾客
- 账户状态管理

### 2. 摊位管理
- 摊位信息维护
- 摊位状态管理（营业中、已打烊、维修中）
- 摊位分类管理

### 3. 商品管理
- 商品上架与下架
- 商品价格与库存管理
- 商品图片管理

### 4. 订单管理
- 在线下单
- 订单状态跟踪（待确认、已确认、制作中、已完成）
- 订单历史查询
- 支付状态管理

### 5. 购物车
- 商品添加与删除
- 数量调整
- 批量结算

## 系统角色

| 角色 | 功能权限 |
|------|----------|
| 管理员 | 用户管理、摊位管理、订单管理、品类管理 |
| 摊主 | 摊位管理、商品管理、订单处理 |
| 顾客 | 浏览摊位、下单购买、查看订单 |

## 项目结构

```
food-court-management/
├── src/main/java/com/foodcourt/
│   ├── controller/    # 控制器层
│   ├── dao/           # 数据访问层
│   ├── entity/        # 实体类
│   ├── service/       # 业务逻辑层
│   └── util/          # 工具类
├── src/main/webapp/
│   ├── jsp/           # JSP页面
│   └── index.jsp      # 首页
├── src/main/resources/
│   ├── db.properties  # 数据库配置
│   └── log4j2.xml     # 日志配置
└── sql/
    └── init.sql       # 数据库初始化脚本
```

## 快速开始

### 环境要求
- JDK 17+
- MySQL 8.0+
- Maven 3.8+

### 安装步骤

1. **克隆项目**
   ```bash
   git clone https://github.com/LWMEPOST/food-court-management.git
   cd food-court-management
   ```

2. **配置数据库**
   - 创建MySQL数据库
   - 修改 `src/main/resources/db.properties` 中的数据库连接信息
   - 执行 `sql/init.sql` 初始化数据库

3. **构建项目**
   ```bash
   mvn clean package
   ```

4. **部署运行**
   - 将生成的WAR文件部署到Tomcat服务器
   - 访问 `http://localhost:8080/food-court-management`

## 数据库配置

在 `src/main/resources/db.properties` 中配置：

```properties
db.url=jdbc:mysql://localhost:3306/foodcourt?useSSL=false&serverTimezone=UTC
db.username=your_username
db.password=your_password
db.driver=com.mysql.cj.jdbc.Driver
db.pool.size=10
db.pool.minIdle=5
db.pool.timeout=30000
```

## 默认账号

系统初始化后会创建以下默认账号：

| 角色 | 用户名 | 密码 |
|------|--------|------|
| 管理员 | admin | admin123 |
| 摊主 | owner | owner123 |
| 顾客 | diner | diner123 |

## 更新日志

### v1.0.0 (2026-01-10)
- 初始版本发布
- 实现基础的用户管理、摊位管理、订单管理功能
- 支持中文界面显示

---

**注意**: 本项目为学习演示项目，请勿用于生产环境。
