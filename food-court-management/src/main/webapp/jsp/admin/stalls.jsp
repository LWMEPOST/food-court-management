<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <link rel="icon" href="data:image/svg+xml,<svg xmlns=%22http://www.w3.org/2000/svg%22 viewBox=%220 0 100 100%22><text y=%22.9em%22 font-size=%2290%22>🍜</text></svg>">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>摊位管理 - 管理员后台</title>
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
    </div>
</nav>

<main class="container py-4">
    <div class="row g-4">
        <div class="col-lg-3">
            <div class="list-group fc-sidebar">
                <a href="${pageContext.request.contextPath}/admin/dashboard" class="list-group-item list-group-item-action">运营概览</a>
                <a href="${pageContext.request.contextPath}/admin/users" class="list-group-item list-group-item-action">用户管理</a>
                <a href="${pageContext.request.contextPath}/admin/stalls" class="list-group-item list-group-item-action active">摊位管理</a>
                <a href="${pageContext.request.contextPath}/admin/categories" class="list-group-item list-group-item-action">品类管理</a>
                <a href="${pageContext.request.contextPath}/admin/orders" class="list-group-item list-group-item-action">订单监管</a>
                <a href="${pageContext.request.contextPath}/admin/leases" class="list-group-item list-group-item-action">租赁管理</a>
            </div>
        </div>
        <div class="col-lg-9">
            <div class="fc-card p-4">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <div>
                        <h4 class="fw-bold mb-1">摊位管理</h4>
                        <div class="text-muted">统一查看摊位信息与状态</div>
                    </div>
                    <div class="d-flex align-items-center gap-2">
                        <form action="${pageContext.request.contextPath}/admin/stalls" method="get" class="d-flex align-items-center gap-2">
                            <input type="text" class="form-control form-control-sm" name="keyword" value="${param.keyword}" placeholder="搜索摊位、摊主或品类">
                            <button type="submit" class="btn btn-sm btn-outline-dark">搜索</button>
                        </form>
                        <span class="badge bg-light text-dark">全量摊位</span>
                    </div>
                </div>
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead>
                            <tr>
                                <th>名称</th>
                                <th>摊主</th>
                                <th>品类</th>
                                <th>状态</th>
                                <th>创建时间</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${stalls}" var="stall">
                                <tr>
                                    <td>${stall.stallName}</td>
                                    <td>${stall.ownerName}</td>
                                    <td>${stall.categoryName}</td>
                                    <td>
                                        <span class="badge ${stall.status == 'OPEN' ? 'text-bg-success' : (stall.status == 'MAINTENANCE' ? 'text-bg-warning' : 'text-bg-secondary')}">
                                            ${stall.status == 'OPEN' ? '营业中' : (stall.status == 'MAINTENANCE' ? '维修中' : '已打烊')}
                                        </span>
                                    </td>
                                    <td>${stall.createdAt}</td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</main>
</body>
</html>
