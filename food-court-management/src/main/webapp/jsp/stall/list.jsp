<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <link rel="icon" href="data:image/svg+xml,<svg xmlns=%22http://www.w3.org/2000/svg%22 viewBox=%220 0 100 100%22><text y=%22.9em%22 font-size=%2290%22>🍜</text></svg>">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>摊位列表 - 美食街</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        :root {
            --fc-primary: #ff6b35;
            --fc-secondary: #ffb703;
            --fc-accent: #f25c54;
            --fc-bg: #fff8f1;
            --fc-surface: #ffffff;
            --fc-text: #2e1f14;
            --fc-muted: #7a6a5a;
            --fc-border: #f1e4d8;
            --fc-shadow: 0 12px 24px rgba(46, 31, 20, 0.12);
            --fc-radius-lg: 18px;
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

        .fc-page-hero {
            background: #fff1e6;
            border-radius: var(--fc-radius-lg);
            padding: 32px 28px;
            border: 1px solid #ffe2cc;
        }

        .fc-chip {
            border-radius: 999px;
            border: 1px solid #ffd7bf;
            padding: 8px 16px;
            background: #fff;
            color: var(--fc-text);
            font-weight: 600;
            font-size: 14px;
        }

        .fc-chip.active {
            background: var(--fc-primary);
            color: #fff;
            border-color: var(--fc-primary);
        }

        .fc-card {
            border: 1px solid var(--fc-border);
            border-radius: var(--fc-radius-md);
            box-shadow: 0 10px 24px rgba(46, 31, 20, 0.08);
            overflow: hidden;
            background: var(--fc-surface);
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }

        .fc-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 18px 32px rgba(46, 31, 20, 0.14);
        }

        .fc-stall-cover {
            height: 140px;
            background: linear-gradient(135deg, rgba(255, 107, 53, 0.9), rgba(255, 183, 3, 0.9));
            color: #fff;
            padding: 16px;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }

        .fc-stall-cover span {
            font-size: 13px;
            opacity: 0.9;
        }

        .fc-badge {
            background: rgba(255, 255, 255, 0.2);
            border: 1px solid rgba(255, 255, 255, 0.4);
            padding: 4px 10px;
            border-radius: 999px;
            font-size: 12px;
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
    <section class="fc-page-hero mb-4">
        <div class="row align-items-center">
            <div class="col-lg-8">
                <h2 class="fw-bold">今天想吃点什么？</h2>
                <p class="text-muted">一键浏览美食街热门摊位，快速找到你最想吃的那一口。</p>
            </div>
            <div class="col-lg-4 text-lg-end">
                <a class="btn btn-dark px-4" href="${pageContext.request.contextPath}/cart">去购物车</a>
            </div>
        </div>
    </section>

    <section class="mb-4">
        <div class="d-flex flex-wrap gap-2">
            <a href="${pageContext.request.contextPath}/stall/list" class="fc-chip ${empty param.categoryId ? 'active' : ''}">全部</a>
            <c:forEach items="${categories}" var="cat">
                <a href="${pageContext.request.contextPath}/stall/list?categoryId=${cat.id}" class="fc-chip ${param.categoryId == cat.id ? 'active' : ''}">${cat.categoryName}</a>
            </c:forEach>
        </div>
    </section>

    <div class="row g-4">
        <c:forEach items="${stalls}" var="stall" varStatus="status">
            <div class="col-md-4">
                <div class="fc-card h-100">
                    <div class="fc-stall-cover">
                        <div class="d-flex justify-content-between align-items-start">
                            <span>${stall.categoryName}</span>
                            <c:if test="${status.index < 3}">
                                <span class="fc-badge">人气推荐</span>
                            </c:if>
                        </div>
                        <div>
                            <div class="fw-bold fs-5">${stall.stallName}</div>
                            <div class="small">位置：${stall.location}</div>
                        </div>
                    </div>
                    <div class="p-3">
                        <p class="text-muted mb-3">${stall.description}</p>
                        <a href="${pageContext.request.contextPath}/stall/detail?id=${stall.id}" class="btn btn-outline-dark w-100">进入摊位</a>
                    </div>
                </div>
            </div>
        </c:forEach>
        <c:if test="${empty stalls}">
            <div class="col-12 text-center py-5">
                <p class="text-muted">暂无摊位数据</p>
            </div>
        </c:if>
    </div>
</main>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
