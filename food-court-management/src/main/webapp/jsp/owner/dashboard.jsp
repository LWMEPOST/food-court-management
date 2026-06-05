<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <link rel="icon" href="data:image/svg+xml,<svg xmlns=%22http://www.w3.org/2000/svg%22 viewBox=%220 0 100 100%22><text y=%22.9em%22 font-size=%2290%22>🍜</text></svg>">
    <meta charset="UTF-8">
    <title>摊主中心 - 美食街管理系统</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        :root {
            --fc-primary: #1f7a8c;
            --fc-secondary: #4fb286;
            --fc-accent: #ff8a65;
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
                <li class="nav-item"><span class="nav-link">欢迎, ${sessionScope.user.username}</span></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/logout">退出</a></li>
            </ul>
        </div>
    </div>
</nav>

<main class="container py-4">
    <div class="row g-4">
        <div class="col-lg-3">
            <div class="fc-sidebar list-group">
                <a href="#" class="list-group-item list-group-item-action active">经营概览</a>
                <a href="${pageContext.request.contextPath}/owner/stalls" class="list-group-item list-group-item-action">我的摊位</a>
                <a href="${pageContext.request.contextPath}/owner/products" class="list-group-item list-group-item-action">商品管理</a>
                <a href="${pageContext.request.contextPath}/owner/orders" class="list-group-item list-group-item-action">订单管理</a>
                <a href="${pageContext.request.contextPath}/owner/leases" class="list-group-item list-group-item-action">合同管理</a>
            </div>
        </div>
        <div class="col-lg-9">
            <div class="fc-card p-4">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h4 class="fw-bold mb-0">摊位经营概况</h4>
                    <span class="badge bg-light text-dark">今日</span>
                </div>
                <c:if test="${sessionScope.user.status == 'PENDING'}">
                    <div class="alert alert-warning" role="alert">
                        您的账号正在审核中，部分功能可能受限。
                    </div>
                </c:if>
                <div class="row g-3">
                    <div class="col-md-4">
                        <div class="fc-card p-3 h-100">
                            <div class="text-muted">待处理订单</div>
                            <div class="display-6 fw-bold">${pendingOrderCount}</div>
                            <a href="${pageContext.request.contextPath}/owner/orders" class="btn btn-outline-dark w-100 mt-2">去处理</a>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="fc-card p-3 h-100">
                            <div class="text-muted">今日营业额</div>
                            <div class="display-6 fw-bold">¥${todayRevenue}</div>
                            <div class="text-muted">较昨日 ${revenueChangePercent}%</div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="fc-card p-3 h-100">
                            <div class="text-muted">上新商品</div>
                            <div class="display-6 fw-bold">${totalProductCount}</div>
                            <a href="${pageContext.request.contextPath}/owner/products" class="btn btn-outline-dark w-100 mt-2">去上新</a>
                        </div>
                    </div>
                </div>
                <div class="fc-card p-3 mt-4">
                    <h6 class="fw-bold">经营建议</h6>
                    <p class="text-muted mb-0">晚高峰建议上新套餐与热饮，提升转化率。</p>
                </div>
            </div>
        </div>
    </div>
</main>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
