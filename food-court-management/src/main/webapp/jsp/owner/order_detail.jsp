<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <link rel="icon" href="data:image/svg+xml,<svg xmlns=%22http://www.w3.org/2000/svg%22 viewBox=%220 0 100 100%22><text y=%22.9em%22 font-size=%2290%22>🍜</text></svg>">
    <meta charset="UTF-8">
    <title>订单详情 - 摊主中心</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        :root {
            --fc-primary: #1f7a8c;
            --fc-secondary: #4fb286;
            --fc-bg: #f4fafb;
            --fc-surface: #ffffff;
            --fc-text: #0f2d3a;
            --fc-muted: #4e6a73;
            --fc-border: #dde9ec;
            --fc-shadow: 0 12px 24px rgba(15, 45, 58, 0.12);
            --fc-radius-md: 12px;
        }

        body.theme-owner {
            background: var(--fc-bg);
            color: var(--fc-text);
            font-family: "Segoe UI", "PingFang SC", "Microsoft YaHei", system-ui, sans-serif;
        }

        .fc-nav {
            background: linear-gradient(120deg, #1f7a8c, #3aa6b9);
            box-shadow: 0 10px 24px rgba(31, 122, 140, 0.24);
        }

        .fc-nav .nav-link,
        .fc-nav .navbar-brand {
            color: #fff;
        }

        .fc-sidebar {
            background: #ffffff;
            border: 1px solid var(--fc-border);
            border-radius: var(--fc-radius-md);
            box-shadow: 0 10px 24px rgba(15, 45, 58, 0.08);
        }

        .fc-sidebar .list-group-item {
            border: none;
            padding: 12px 16px;
            color: var(--fc-text);
        }

        .fc-sidebar .list-group-item.active {
            background: rgba(31, 122, 140, 0.12);
            color: var(--fc-primary);
            font-weight: 600;
        }

        .fc-card {
            border: 1px solid var(--fc-border);
            border-radius: var(--fc-radius-md);
            box-shadow: 0 10px 24px rgba(15, 45, 58, 0.08);
            background: var(--fc-surface);
        }
    </style>
</head>
<body class="theme-owner">
    <nav class="navbar navbar-expand-lg fc-nav">
        <div class="container">
            <a class="navbar-brand fw-bold" href="${pageContext.request.contextPath}/owner/dashboard">摊主中心</a>
            <div class="collapse navbar-collapse">
                <ul class="navbar-nav ms-auto align-items-lg-center gap-lg-2">
                    <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/logout">退出</a></li>
                </ul>
            </div>
        </div>
    </nav>

    <main class="container py-4">
        <div class="row g-4">
            <div class="col-lg-3">
                <div class="list-group fc-sidebar">
                    <a href="${pageContext.request.contextPath}/owner/dashboard" class="list-group-item list-group-item-action">经营概览</a>
                    <a href="${pageContext.request.contextPath}/owner/stalls" class="list-group-item list-group-item-action">我的摊位</a>
                    <a href="${pageContext.request.contextPath}/owner/products" class="list-group-item list-group-item-action">商品管理</a>
                    <a href="${pageContext.request.contextPath}/owner/orders" class="list-group-item list-group-item-action active">订单管理</a>
                    <a href="${pageContext.request.contextPath}/owner/leases" class="list-group-item list-group-item-action">合同管理</a>
                </div>
            </div>
            <div class="col-lg-9">
                <nav aria-label="breadcrumb" class="mb-3">
                    <ol class="breadcrumb">
                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/owner/orders">订单管理</a></li>
                        <li class="breadcrumb-item active" aria-current="page">
                            <c:choose>
                                <c:when test="${order.paymentStatus == 'PAID'}">订单 ${order.orderNumber}</c:when>
                                <c:otherwise>订单详情</c:otherwise>
                            </c:choose>
                        </li>
                    </ol>
                </nav>

                <div class="fc-card p-4 mb-4">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <h4 class="fw-bold mb-0">订单详情</h4>
                        <span class="badge 
                            ${order.status == 'PENDING' ? 'text-bg-warning' : 
                              order.status == 'CONFIRMED' ? 'text-bg-info' : 
                              order.status == 'PREPARING' ? 'text-bg-primary' : 
                              order.status == 'COMPLETED' ? 'text-bg-success' : 'text-bg-secondary'}">
                            <c:choose>
                                <c:when test="${order.status == 'PENDING'}">待确认</c:when>
                                <c:when test="${order.status == 'CONFIRMED'}">已确认</c:when>
                                <c:when test="${order.status == 'PREPARING'}">准备中</c:when>
                                <c:when test="${order.status == 'COMPLETED'}">已完成</c:when>
                                <c:when test="${order.status == 'CANCELLED'}">已取消</c:when>
                                <c:otherwise>${order.status}</c:otherwise>
                            </c:choose>
                        </span>
                    </div>
                    <div class="row">
                        <div class="col-md-6">
                            <p><strong>订单号:</strong>
                                <c:choose>
                                    <c:when test="${order.paymentStatus == 'PAID'}">${order.orderNumber}</c:when>
                                    <c:otherwise>待生成</c:otherwise>
                                </c:choose>
                            </p>
                            <p><strong>取餐号:</strong>
                                <c:choose>
                                    <c:when test="${order.paymentStatus == 'PAID' && not empty order.pickupNumber}">${order.pickupNumber}</c:when>
                                    <c:otherwise>待生成</c:otherwise>
                                </c:choose>
                            </p>
                            <p><strong>摊位:</strong> ${order.stallName}</p>
                            <p><strong>下单时间:</strong> <fmt:formatDate value="${order.orderTime}" pattern="yyyy-MM-dd HH:mm:ss"/></p>
                        </div>
                        <div class="col-md-6">
                            <p><strong>支付方式:</strong> ${order.paymentMethod}</p>
                            <p><strong>支付状态:</strong>
                                <span class="badge ${order.paymentStatus == 'PAID' ? 'text-bg-success' : 'text-bg-danger'}">
                                    ${order.paymentStatus == 'PAID' ? '已支付' : '未支付'}
                                </span>
                            </p>
                            <p><strong>订单金额:</strong> ¥${order.totalAmount}</p>
                        </div>
                    </div>
                </div>

                <div class="fc-card p-3">
                    <h5 class="fw-bold mb-3">订单项</h5>
                    <div class="table-responsive">
                        <table class="table mb-0">
                            <thead class="table-light">
                                <tr>
                                    <th>商品</th>
                                    <th class="text-center">价格</th>
                                    <th class="text-center">数量</th>
                                    <th class="text-end">小计</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="item" items="${order.orderItems}">
                                    <tr>
                                        <td>${item.productName}</td>
                                        <td class="text-center">¥${item.unitPrice}</td>
                                        <td class="text-center">${item.quantity}</td>
                                        <td class="text-end">¥${item.subtotal}</td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                            <tfoot class="table-light">
                                <tr>
                                    <td colspan="3" class="text-end"><strong>总计:</strong></td>
                                    <td class="text-end"><strong>¥${order.totalAmount}</strong></td>
                                </tr>
                            </tfoot>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
