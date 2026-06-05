<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <link rel="icon" href="data:image/svg+xml,<svg xmlns=%22http://www.w3.org/2000/svg%22 viewBox=%220 0 100 100%22><text y=%22.9em%22 font-size=%2290%22>🍜</text></svg>">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>用户管理 - 管理员后台</title>
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
                <a href="${pageContext.request.contextPath}/admin/users" class="list-group-item list-group-item-action active">用户管理</a>
                <a href="${pageContext.request.contextPath}/admin/stalls" class="list-group-item list-group-item-action">摊位管理</a>
                <a href="${pageContext.request.contextPath}/admin/categories" class="list-group-item list-group-item-action">品类管理</a>
                <a href="${pageContext.request.contextPath}/admin/orders" class="list-group-item list-group-item-action">订单监管</a>
                <a href="${pageContext.request.contextPath}/admin/leases" class="list-group-item list-group-item-action">租赁管理</a>
            </div>
        </div>
        <div class="col-lg-9">
            <div class="fc-card p-4">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <div>
                        <h4 class="fw-bold mb-1">用户管理</h4>
                        <div class="text-muted">管理食客与商户账号状态</div>
                    </div>
                    <div class="d-flex align-items-center gap-2">
                        <form action="${pageContext.request.contextPath}/admin/users" method="get" class="d-flex align-items-center gap-2">
                            <input type="text" class="form-control form-control-sm" name="keyword" value="${param.keyword}" placeholder="搜索用户名或角色">
                            <button type="submit" class="btn btn-sm btn-outline-dark">搜索</button>
                        </form>
                        <span class="badge bg-light text-dark">当前列表</span>
                    </div>
                </div>
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>用户名</th>
                                <th>角色</th>
                                <th>状态</th>
                                <th>注册时间</th>
                                <th>操作</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${userList}" var="u">
                                <tr>
                                    <td>${u.id}</td>
                                    <td>${u.username}</td>
                                    <td>
                                        ${u.roleType == 'DINER' ? '食客' : (u.roleType == 'OWNER' ? '摊主' : '管理员')}
                                    </td>
                                    <td>
                                        <span class="badge bg-${u.status == 'ACTIVE' ? 'success' : (u.status == 'PENDING' ? 'warning' : 'secondary')}">
                                            ${u.status == 'ACTIVE' ? '正常' : (u.status == 'PENDING' ? '待审核' : '已禁用')}
                                        </span>
                                    </td>
                                    <td>${u.createdAt}</td>
                                    <td>
                                        <c:if test="${u.status == 'PENDING'}">
                                            <form action="${pageContext.request.contextPath}/admin/users" method="post" class="d-inline">
                                                <input type="hidden" name="action" value="updateStatus">
                                                <input type="hidden" name="userId" value="${u.id}">
                                                <input type="hidden" name="status" value="ACTIVE">
                                                <button type="submit" class="btn btn-sm btn-success">激活</button>
                                            </form>
                                        </c:if>
                                        <c:if test="${u.status == 'ACTIVE' && u.roleType != 'ADMIN'}">
                                            <form action="${pageContext.request.contextPath}/admin/users" method="post" class="d-inline">
                                                <input type="hidden" name="action" value="updateStatus">
                                                <input type="hidden" name="userId" value="${u.id}">
                                                <input type="hidden" name="status" value="INACTIVE">
                                                <button type="submit" class="btn btn-sm btn-warning">禁用</button>
                                            </form>
                                        </c:if>
                                        <c:if test="${u.status == 'INACTIVE'}">
                                            <form action="${pageContext.request.contextPath}/admin/users" method="post" class="d-inline">
                                                <input type="hidden" name="action" value="updateStatus">
                                                <input type="hidden" name="userId" value="${u.id}">
                                                <input type="hidden" name="status" value="ACTIVE">
                                                <button type="submit" class="btn btn-sm btn-success">启用</button>
                                            </form>
                                        </c:if>
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
