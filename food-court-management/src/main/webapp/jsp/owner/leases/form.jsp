<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <link rel="icon" href="data:image/svg+xml,<svg xmlns=%22http://www.w3.org/2000/svg%22 viewBox=%220 0 100 100%22><text y=%22.9em%22 font-size=%2290%22>🍜</text></svg>">
    <meta charset="UTF-8">
    <title>提交申请 - 美食街摊主中心</title>
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
            border: 1px solid var(--fc-border);
            border-radius: var(--fc-radius-md);
            box-shadow: 0 10px 24px rgba(30, 42, 54, 0.08);
            background: var(--fc-surface);
        }
    </style>
</head>
<body class="theme-admin">
<nav class="navbar navbar-expand-lg fc-nav">
    <div class="container">
        <a class="navbar-brand fw-bold" href="${pageContext.request.contextPath}/owner/dashboard">美食街摊主中心</a>
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
                <a href="${pageContext.request.contextPath}/owner/stalls" class="list-group-item list-group-item-action">我的摊位</a>
                <a href="${pageContext.request.contextPath}/owner/products" class="list-group-item list-group-item-action">商品管理</a>
                <a href="${pageContext.request.contextPath}/owner/orders" class="list-group-item list-group-item-action">订单管理</a>
                <a href="${pageContext.request.contextPath}/owner/leases" class="list-group-item list-group-item-action active">合同管理</a>
            </div>
        </div>
        <div class="col-lg-9">
            <div class="fc-card p-4">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h4 class="fw-bold mb-0">提交租赁/续租申请</h4>
                </div>
                
                <c:if test="${not empty error}">
                    <div class="alert alert-danger">${error}</div>
                </c:if>

                <form action="${pageContext.request.contextPath}/owner/leases" method="post">
                    <div class="mb-3">
                        <label for="stallId" class="form-label">选择摊位</label>
                        <select class="form-select" id="stallId" name="stallId" required>
                            <option value="">请选择摊位...</option>
                            <c:forEach items="${stalls}" var="stall">
                                <option value="${stall.id}">${stall.stallName}</option>
                            </c:forEach>
                        </select>
                        <div class="form-text">只能对已拥有的摊位提交续租申请。</div>
                    </div>
                    
                    <div class="mb-3">
                        <label for="type" class="form-label">申请类型</label>
                        <select class="form-select" id="type" name="type" required>
                            <option value="RENEWAL">续租</option>
                            <!-- <option value="NEW">新租 (暂不支持)</option> -->
                        </select>
                    </div>

                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="startDate" class="form-label">开始日期</label>
                            <input type="date" class="form-control" id="startDate" name="startDate" required>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label for="endDate" class="form-label">结束日期</label>
                            <input type="date" class="form-control" id="endDate" name="endDate" required>
                        </div>
                    </div>

                    <button type="submit" class="btn btn-primary">提交申请</button>
                    <a href="${pageContext.request.contextPath}/owner/leases" class="btn btn-secondary">返回</a>
                </form>
            </div>
        </div>
    </div>
</main>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
