<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <link rel="icon" href="data:image/svg+xml,<svg xmlns=%22http://www.w3.org/2000/svg%22 viewBox=%220 0 100 100%22><text y=%22.9em%22 font-size=%2290%22>🍜</text></svg>">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>订单监管 - 管理员后台</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        :root {
            --fc-primary: #28313b;
            --fc-secondary: #3a506b;
            --fc-accent: #ffb703;
            --fc-bg: #f5f7fa;
            --fc-surface: #ffffff;
            --fc-text: #1e2a36;
            --fc-muted: #627183;
            --fc-border: #e3e8ef;
            --fc-shadow: 0 12px 24px rgba(30, 42, 54, 0.12);
            --fc-radius-md: 12px;
        }

        body.theme-admin {
            background: var(--fc-bg);
            color: var(--fc-text);
            font-family: "Segoe UI", "PingFang SC", "Microsoft YaHei", system-ui, sans-serif;
        }

        .fc-nav {
            background: linear-gradient(120deg, #28313b, #3a506b);
            box-shadow: 0 10px 24px rgba(40, 49, 59, 0.28);
        }

        .fc-nav .nav-link,
        .fc-nav .navbar-brand {
            color: #fff;
        }

        .fc-sidebar {
            background: #ffffff;
            border: 1px solid var(--fc-border);
            border-radius: var(--fc-radius-md);
            box-shadow: 0 10px 24px rgba(30, 42, 54, 0.08);
        }

        .fc-sidebar .list-group-item {
            border: none;
            padding: 12px 16px;
            color: var(--fc-text);
        }

        .fc-sidebar .list-group-item.active {
            background: rgba(40, 49, 59, 0.12);
            color: var(--fc-primary);
            font-weight: 600;
        }

        .fc-card {
            background: var(--fc-surface);
            border: 1px solid var(--fc-border);
            border-radius: var(--fc-radius-md);
            box-shadow: var(--fc-shadow);
        }

        .table thead th {
            color: var(--fc-muted);
            font-weight: 600;
        }
    </style>
</head>
<body class="theme-admin">
    <nav class="navbar navbar-expand-lg fc-nav">
        <div class="container">
            <a class="navbar-brand fw-bold" href="${pageContext.request.contextPath}/admin/dashboard">美食街管理后台</a>
            <div class="collapse navbar-collapse">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/logout">退出</a></li>
                </ul>
            </div>
        </div>
    </nav>

    <main class="container py-4">
        <div class="row g-4">
            <div class="col-lg-3">
                <div class="list-group fc-sidebar">
                    <a href="${pageContext.request.contextPath}/admin/dashboard" class="list-group-item list-group-item-action">运营概览</a>
                    <a href="${pageContext.request.contextPath}/admin/users" class="list-group-item list-group-item-action">用户管理</a>
                    <a href="${pageContext.request.contextPath}/admin/stalls" class="list-group-item list-group-item-action">摊位管理</a>
                    <a href="${pageContext.request.contextPath}/admin/categories" class="list-group-item list-group-item-action">品类管理</a>
                    <a href="${pageContext.request.contextPath}/admin/orders" class="list-group-item list-group-item-action active">订单监管</a>
                    <a href="${pageContext.request.contextPath}/admin/leases" class="list-group-item list-group-item-action">租赁管理</a>
                </div>
            </div>
            <div class="col-lg-9">
                <div class="fc-card p-4">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <div>
                            <h4 class="fw-bold mb-1">订单监管</h4>
                            <div class="text-muted">监控全站订单状态与支付情况</div>
                        </div>
                        <div class="d-flex align-items-center gap-2">
                            <form action="${pageContext.request.contextPath}/admin/orders" method="get" class="d-flex align-items-center gap-2">
                                <input type="text" class="form-control form-control-sm" name="keyword" value="${param.keyword}" placeholder="搜索订单号、取餐号或摊位">
                                <button type="submit" class="btn btn-sm btn-outline-dark">搜索</button>
                            </form>
                            <span class="badge bg-light text-dark">最新订单</span>
                        </div>
                    </div>
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0">
                        <thead>
                            <tr>
                                <th>订单号</th>
                                <th>取餐号</th>
                                <th>食客</th>
                                <th>摊位</th>
                                <th>金额</th>
                                <th>时间</th>
                                <th>状态</th>
                                <th>支付</th>
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
                                    <td>${order.userName}</td>
                                    <td>${order.stallName}</td>
                                    <td>¥${order.totalAmount}</td>
                                    <td><fmt:formatDate value="${order.orderTime}" pattern="yyyy-MM-dd HH:mm"/></td>
                                    <td>
                                        <span class="badge 
                                            ${order.status == 'PENDING' ? 'text-bg-warning' : 
                                              order.status == 'CONFIRMED' ? 'text-bg-info' : 
                                              order.status == 'PREPARING' ? 'text-bg-primary' : 
                                              order.status == 'COMPLETED' ? 'text-bg-success' : 'text-bg-secondary'}">
                                            <c:choose>
                                                <c:when test="${order.status == 'PENDING'}">待确认</c:when>
                                                <c:when test="${order.status == 'CONFIRMED'}">已确认</c:when>
                                                <c:when test="${order.status == 'PREPARING'}">制作中</c:when>
                                                <c:when test="${order.status == 'COMPLETED'}">已完成</c:when>
                                                <c:when test="${order.status == 'CANCELLED'}">已取消</c:when>
                                                <c:otherwise>${order.status}</c:otherwise>
                                            </c:choose>
                                        </span>
                                    </td>
                                    <td>
                                        <span class="badge ${order.paymentStatus == 'PAID' ? 'text-bg-success' : 'text-bg-danger'}">
                                            ${order.paymentStatus == 'PAID' ? '已支付' : '未支付'}
                                        </span>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                    </div>
                </div>
            </div>
        </div>
    </main>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
