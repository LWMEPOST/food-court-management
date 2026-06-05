<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
    <link rel="icon" href="data:image/svg+xml,<svg xmlns=%22http://www.w3.org/2000/svg%22 viewBox=%220 0 100 100%22><text y=%22.9em%22 font-size=%2290%22>🍜</text></svg>">
    <title>我的订单 - 美食街</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        :root {
            --fc-primary: #ff6b35;
            --fc-secondary: #ffb703;
            --fc-bg: #fff8f1;
            --fc-surface: #ffffff;
            --fc-text: #2e1f14;
            --fc-muted: #7a6a5a;
            --fc-border: #f1e4d8;
            --fc-shadow: 0 12px 24px rgba(46, 31, 20, 0.12);
            --fc-radius-md: 12px;
        }

        body.theme-diner {
            background: var(--fc-bg);
            color: var(--fc-text);
            font-family: "Segoe UI", "PingFang SC", "Microsoft YaHei", system-ui, sans-serif;
        }

        .fc-nav {
            background: linear-gradient(120deg, #ff6b35, #ff8f5a);
            box-shadow: 0 10px 24px rgba(255, 107, 53, 0.28);
        }

        .fc-nav .nav-link,
        .fc-nav .navbar-brand {
            color: #fff;
        }

        .fc-card {
            border: 1px solid var(--fc-border);
            border-radius: var(--fc-radius-md);
            box-shadow: 0 10px 24px rgba(46, 31, 20, 0.08);
            background: var(--fc-surface);
        }
    </style>
</head>
<body class="theme-diner">
    <nav class="navbar navbar-expand-lg fc-nav">
        <div class="container">
            <a class="navbar-brand fw-bold" href="${pageContext.request.contextPath}/index.jsp">美食街</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto align-items-lg-center gap-lg-2">
                    <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/stall/list">逛摊位</a></li>
                    <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/order/list">我的订单</a></li>
                    <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/cart">购物车</a></li>
                    <c:choose>
                        <c:when test="${not empty sessionScope.user}">
                            <li class="nav-item"><span class="nav-link">你好，${sessionScope.user.username}</span></li>
                            <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/logout">退出</a></li>
                        </c:when>
                        <c:otherwise>
                            <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/login">登录</a></li>
                            <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/register">注册</a></li>
                        </c:otherwise>
                    </c:choose>
                </ul>
            </div>
        </div>
    </nav>

    <main class="container py-4">
        <div class="d-flex justify-content-between align-items-center mb-3">
            <h2 class="fw-bold">我的订单</h2>
            <a href="${pageContext.request.contextPath}/stall/list" class="btn btn-outline-dark">继续逛吃</a>
        </div>
        <c:if test="${not empty sessionScope.message}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                ${sessionScope.message}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="关闭"></button>
            </div>
            <c:remove var="message" scope="session"/>
        </c:if>

        <c:if test="${empty orders}">
            <div class="fc-card p-4 text-center">
                <h5 class="fw-bold">暂无订单</h5>
                <p class="text-muted">快去挑选心仪的摊位吧。</p>
                <a href="${pageContext.request.contextPath}/stall/list" class="btn btn-dark">浏览摊位</a>
            </div>
        </c:if>

        <c:if test="${not empty orders}">
            <div class="fc-card p-3">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-light">
                            <tr>
                                <th>订单号</th>
                                <th>取餐号</th>
                                <th>摊位</th>
                                <th>日期</th>
                                <th>总计</th>
                                <th>状态</th>
                                <th>操作</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="order" items="${orders}">
                                <tr>
                                    <td>
                                        <c:choose>
                                            <c:when test="${order.paymentStatus == 'PAID'}">${order.orderNumber}</c:when>
                                            <c:otherwise>待生成</c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${order.paymentStatus == 'PAID' && not empty order.pickupNumber}">${order.pickupNumber}</c:when>
                                            <c:otherwise>待生成</c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>${order.stallName}</td>
                                    <td><fmt:formatDate value="${order.orderTime}" pattern="yyyy-MM-dd HH:mm"/></td>
                                    <td>¥${order.totalAmount}</td>
                                    <td>
                                        <span class="badge 
                                            ${order.status == 'PENDING' ? 'text-bg-warning' : 
                                              order.status == 'CONFIRMED' ? 'text-bg-info' : 
                                              order.status == 'PREPARING' ? 'text-bg-primary' : 
                                              order.status == 'COMPLETED' ? 'text-bg-success' : 'text-bg-secondary'}">
                                            ${order.status == 'PENDING' ? '待确认' : 
                                              order.status == 'CONFIRMED' ? '已确认' : 
                                              order.status == 'PREPARING' ? '制作中' : 
                                              order.status == 'COMPLETED' ? '已完成' : '未知状态'}
                                        </span>
                                    </td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/order/detail?id=${order.id}" class="btn btn-sm btn-outline-dark">查看详情</a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </c:if>
    </main>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
