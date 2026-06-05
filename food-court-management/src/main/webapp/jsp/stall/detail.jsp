<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <link rel="icon" href="data:image/svg+xml,<svg xmlns=%22http://www.w3.org/2000/svg%22 viewBox=%220 0 100 100%22><text y=%22.9em%22 font-size=%2290%22>🍜</text></svg>">
    <meta charset="UTF-8">
    <title>${stall.stallName} - 美食街</title>
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

        .fc-hero {
            --fc-hero-image: url("https://images.unsplash.com/photo-1476224203421-9ac39bcb3327?auto=format&fit=crop&w=1400&q=80");
            background-image: linear-gradient(120deg, rgba(38, 24, 12, 0.6), rgba(255, 107, 53, 0.25)), var(--fc-hero-image);
            background-position: center;
            background-size: cover;
            background-repeat: no-repeat;
            border-radius: var(--fc-radius-lg);
            color: #fff;
            padding: 56px 40px;
            box-shadow: var(--fc-shadow);
        }

        .fc-card {
            border: 1px solid var(--fc-border);
            border-radius: var(--fc-radius-md);
            box-shadow: 0 10px 24px rgba(46, 31, 20, 0.08);
            overflow: hidden;
            background: var(--fc-surface);
        }

        .fc-menu-card {
            border: 1px solid var(--fc-border);
            border-radius: var(--fc-radius-md);
            overflow: hidden;
            background: var(--fc-surface);
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }

        .fc-menu-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 16px 28px rgba(46, 31, 20, 0.12);
        }

        .fc-image {
            height: 170px;
            object-fit: cover;
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
    <nav aria-label="breadcrumb" class="mb-3">
        <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/index.jsp">首页</a></li>
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/stall/list">摊位列表</a></li>
            <li class="breadcrumb-item active" aria-current="page">${stall.stallName}</li>
        </ol>
    </nav>

    <section class="fc-hero mb-4" id="stallHero">
        <input type="hidden" id="stallBackgroundUrlRaw" value="<c:out value='${stall.backgroundImageUrl}'/>">
        <input type="hidden" id="stallImagesRaw" value="<c:out value='${stall.images}'/>">
        <c:if test="${not empty sessionScope.message}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                ${sessionScope.message}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="关闭"></button>
            </div>
            <c:remove var="message" scope="session"/>
        </c:if>
        <h1 class="display-6 fw-bold">${stall.stallName}</h1>
        <p class="fs-6">${stall.description}</p>
        <div class="d-flex gap-3 flex-wrap">
            <span class="badge bg-success">营业中</span>
            <span class="badge bg-light text-dark">位置：${stall.location}</span>
        </div>
    </section>

    <section class="row g-4 mb-4">
        <div class="col-lg-4">
            <div class="fc-card p-4 h-100">
                <h5 class="fw-bold">店铺信息</h5>
                <p class="text-muted mb-2">品类：${stall.categoryName}</p>
                <p class="text-muted mb-2">今日推荐：热销招牌菜</p>
                <div class="mt-3">
                    <a class="btn btn-dark w-100" href="${pageContext.request.contextPath}/cart">查看购物车</a>
                </div>
            </div>
        </div>
        <div class="col-lg-8">
            <div class="fc-card p-4 h-100">
                <h5 class="fw-bold mb-3">人气菜单</h5>
                <p class="text-muted">精选上新与销量靠前的菜品，支持一键加入购物车。</p>
                <div class="d-flex flex-wrap gap-2">
                    <span class="badge bg-light text-dark">现做现出</span>
                    <span class="badge bg-light text-dark">支持自取</span>
                    <span class="badge bg-light text-dark">推荐搭配</span>
                </div>
            </div>
        </div>
    </section>

    <h3 class="fw-bold mb-3">菜单</h3>
    <div class="row g-4">
        <c:forEach items="${products}" var="p">
            <div class="col-md-3">
                <div class="fc-menu-card h-100">
                    <c:if test="${not empty p.imageUrl}">
                        <img src="${p.imageUrl}" class="w-100 fc-image" alt="${p.productName}">
                    </c:if>
                    <c:if test="${empty p.imageUrl}">
                        <div class="fc-image d-flex align-items-center justify-content-center bg-light text-muted">暂无图片</div>
                    </c:if>
                    <div class="p-3">
                        <h6 class="fw-bold">${p.productName}</h6>
                        <p class="text-muted small">${p.description}</p>
                        <div class="d-flex justify-content-between align-items-center">
                            <span class="fw-bold text-danger">¥${p.price}</span>
                        </div>
                    </div>
                    <div class="px-3 pb-3">
                        <c:choose>
                            <c:when test="${not empty sessionScope.user}">
                                <form action="${pageContext.request.contextPath}/cart" method="post">
                                    <input type="hidden" name="action" value="add">
                                    <input type="hidden" name="productId" value="${p.id}">
                                    <button type="submit" class="btn btn-outline-dark w-100">加入购物车</button>
                                </form>
                            </c:when>
                            <c:otherwise>
                                <a href="${pageContext.request.contextPath}/login" class="btn btn-secondary w-100">登录后购买</a>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </c:forEach>
        <c:if test="${empty products}">
            <div class="col-12 text-center py-5">
                <p class="text-muted">摊主还没上架商品，请稍后再来</p>
            </div>
        </c:if>
    </div>
</main>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    const heroEl = document.getElementById('stallHero');
    const stallBackgroundUrlRawEl = document.getElementById('stallBackgroundUrlRaw');
    const stallImagesRawEl = document.getElementById('stallImagesRaw');

    const extractImageUrl = (raw) => {
        if (!raw) {
            return '';
        }
        const trimmed = raw.trim();
        if (!trimmed) {
            return '';
        }
        if (trimmed.startsWith('[')) {
            try {
                const parsed = JSON.parse(trimmed);
                if (Array.isArray(parsed) && parsed.length > 0) {
                    return String(parsed[0]);
                }
            } catch (error) {
                return '';
            }
        }
        return trimmed;
    };

    if (heroEl) {
        const heroImageUrl = extractImageUrl(stallBackgroundUrlRawEl ? stallBackgroundUrlRawEl.value : '')
            || extractImageUrl(stallImagesRawEl ? stallImagesRawEl.value : '');
        if (heroImageUrl) {
            heroEl.style.setProperty('--fc-hero-image', 'url("' + heroImageUrl + '")');
        }
    }
</script>
</body>
</html>
