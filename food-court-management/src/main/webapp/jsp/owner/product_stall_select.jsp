<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <link rel="icon" href="data:image/svg+xml,<svg xmlns=%22http://www.w3.org/2000/svg%22 viewBox=%220 0 100 100%22><text y=%22.9em%22 font-size=%2290%22>🍜</text></svg>">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>选择摊位 - 商品管理</title>
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

        .fc-card {
            background: var(--fc-surface);
            border: 1px solid var(--fc-border);
            border-radius: var(--fc-radius-md);
            box-shadow: var(--fc-shadow);
        }

        .list-group-item {
            border: none;
            padding: 16px 18px;
        }

        .list-group-item + .list-group-item {
            border-top: 1px solid var(--fc-border);
        }
    </style>
</head>
<body class="theme-owner">
<nav class="navbar navbar-expand-lg fc-nav">
    <div class="container">
        <a class="navbar-brand fw-bold" href="${pageContext.request.contextPath}/owner/dashboard">摊主中心</a>
    </div>
</nav>

<main class="container py-4">
    <div class="row justify-content-center">
        <div class="col-lg-6">
            <div class="fc-card p-4">
                <div class="mb-3">
                    <h4 class="fw-bold mb-1">选择摊位</h4>
                    <div class="text-muted">进入摊位后可管理商品与上架状态</div>
                </div>
                <div class="list-group list-group-flush">
                    <c:forEach items="${stalls}" var="stall">
                        <a href="${pageContext.request.contextPath}/owner/products?stallId=${stall.id}" class="list-group-item list-group-item-action d-flex justify-content-between align-items-center">
                            ${stall.stallName}
                            <span class="badge bg-dark rounded-pill">进入管理</span>
                        </a>
                    </c:forEach>
                    <c:if test="${empty stalls}">
                        <div class="list-group-item text-center text-muted">
                            您还没有摊位，请先<a href="${pageContext.request.contextPath}/owner/stalls">创建摊位</a>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>
    </div>
</main>
</body>
</html>
