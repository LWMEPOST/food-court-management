<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <link rel="icon" href="data:image/svg+xml,<svg xmlns=%22http://www.w3.org/2000/svg%22 viewBox=%220 0 100 100%22><text y=%22.9em%22 font-size=%2290%22>🍜</text></svg>">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>美食街 - 城市烟火里的好味道</title>
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
            --fc-shadow: 0 14px 30px rgba(46, 31, 20, 0.16);
            --fc-radius-lg: 20px;
            --fc-radius-md: 14px;
        }

        body {
            background-color: var(--fc-bg);
            /* 增加点阵纹理，减少纯色背景的单调感 */
            background-image: radial-gradient(#ffe4d1 1px, transparent 1px);
            background-size: 32px 32px;
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

        .fc-nav .nav-link:hover {
            color: #fff3df;
        }

        .fc-hero {
            background: linear-gradient(120deg, rgba(26, 16, 6, 0.65), rgba(255, 107, 53, 0.25)),
                url("https://images.unsplash.com/photo-1504674900247-0877df9cc836?auto=format&fit=crop&w=1600&q=80") center/cover;
            border-radius: var(--fc-radius-lg);
            color: #fff;
            padding: 72px 48px;
            box-shadow: var(--fc-shadow);
        }

        .fc-hero .btn {
            border-radius: 999px;
            padding: 12px 28px;
            font-weight: 600;
        }

        .fc-section-title {
            font-weight: 700;
            letter-spacing: 0.5px;
            position: relative;
            padding-left: 16px;
        }
        
        /* 增加标题装饰竖线，提升层次感 */
        .fc-section-title::before {
            content: '';
            position: absolute;
            left: 0;
            top: 50%;
            transform: translateY(-50%);
            width: 6px;
            height: 24px;
            background: var(--fc-primary);
            border-radius: 4px;
        }

        .fc-card {
            border: 1px solid var(--fc-border);
            /* 增加顶部彩色边框，打破白色单调 */
            border-top: 4px solid var(--fc-secondary);
            border-radius: var(--fc-radius-md);
            box-shadow: 0 12px 26px rgba(46, 31, 20, 0.08);
            overflow: hidden;
            background: #fffcf9; /* 稍微暖一点的白色背景 */
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }

        .fc-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 18px 32px rgba(46, 31, 20, 0.16);
            border-top-color: var(--fc-primary); /* 悬停时边框变色 */
        }

        .fc-chip {
            /* 修改为渐变背景，解决颜色暗淡问题 */
            background: linear-gradient(135deg, var(--fc-secondary), var(--fc-primary));
            color: #fff;
            border-radius: 999px;
            padding: 6px 14px;
            font-size: 13px;
            font-weight: 600;
            box-shadow: 0 4px 10px rgba(255, 107, 53, 0.2);
            text-shadow: 0 1px 2px rgba(0,0,0,0.1);
        }

        .fc-stat {
            background: #ffffff;
            border-radius: var(--fc-radius-md);
            padding: 16px;
            border: 1px solid var(--fc-border);
            box-shadow: 0 6px 16px rgba(46, 31, 20, 0.06); /* 增加投影 */
        }
        
        /* 针对统计数字进行颜色和大小增强 */
        .fc-stat .fw-bold {
            color: var(--fc-primary);
            font-size: 2rem !important;
            letter-spacing: -0.5px;
        }

        .fc-image {
            height: 180px;
            object-fit: cover;
        }

        .fc-pill {
            border-radius: 999px;
            border: 1px solid #ffd7bf;
            padding: 8px 16px;
            color: var(--fc-text);
            background: #fff;
            transition: all 0.2s;
        }
        
        .fc-pill:hover {
            background: var(--fc-primary);
            color: #fff;
            border-color: var(--fc-primary);
        }

        .fc-pill strong {
            color: var(--fc-primary);
        }
        
        .fc-pill:hover strong {
            color: #fff;
        }

        .fc-footer {
            border-top: 1px dashed #f1d8c5;
            color: var(--fc-muted);
        }
    </style>
</head>
<body>

<nav class="navbar navbar-expand-lg fc-nav">
    <div class="container">
        <a class="navbar-brand fw-bold" href="${pageContext.request.contextPath}/index.jsp">美食街</a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav ms-auto align-items-lg-center gap-lg-2">
                <li class="nav-item"><a class="nav-link" href="#featured">特色菜</a></li>
                <li class="nav-item"><a class="nav-link" href="#stalls">推荐摊位</a></li>
                <li class="nav-item"><a class="nav-link" href="#promotions">活动</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/stall/list">浏览美食</a></li>
                <c:choose>
                    <c:when test="${not empty sessionScope.user}">
                        <li class="nav-item"><span class="nav-link">你好，${sessionScope.user.username}</span></li>
                        <c:if test="${sessionScope.user.roleType == 'DINER'}">
                            <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/cart">购物车</a></li>
                            <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/order/list">我的订单</a></li>
                        </c:if>
                        <c:if test="${sessionScope.user.roleType == 'ADMIN'}">
                            <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/dashboard">管理后台</a></li>
                        </c:if>
                        <c:if test="${sessionScope.user.roleType == 'OWNER'}">
                            <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/owner/dashboard">摊主中心</a></li>
                        </c:if>
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

<main class="container py-5">
    <section class="fc-hero mb-5">
        <div class="row align-items-center">
            <div class="col-lg-7">
                <div class="d-flex gap-2 mb-3 flex-wrap">
                    <span class="fc-chip">城市烟火</span>
                    <span class="fc-chip">今日必吃</span>
                    <span class="fc-chip">精选摊位</span>
                </div>
                <h1 class="display-5 fw-bold">一站式发现美味，今晚就去美食街</h1>
                <p class="fs-5 mt-3">热闹街区氛围 + 地道手作美味 + 便捷下单体验，让每一次逛吃都充满惊喜。</p>
                <div class="d-flex gap-3 mt-4 flex-wrap">
                    <a class="btn btn-light text-dark" href="${pageContext.request.contextPath}/stall/list">立即逛吃</a>
                    <a class="btn btn-outline-light" href="#promotions">查看优惠</a>
                </div>
            </div>
            <div class="col-lg-5 mt-4 mt-lg-0">
                <div class="row g-3">
                    <div class="col-6">
                        <div class="fc-stat">
                            <div class="fw-bold fs-4">120+</div>
                            <div class="text-muted">今日上新菜品</div>
                        </div>
                    </div>
                    <div class="col-6">
                        <div class="fc-stat">
                            <div class="fw-bold fs-4">30min</div>
                            <div class="text-muted">平均出餐时长</div>
                        </div>
                    </div>
                    <div class="col-12">
                        <div class="fc-stat">
                            <div class="fw-bold fs-4">5,000+</div>
                            <div class="text-muted">今日食客已打卡</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <section id="featured" class="mb-5">
        <div class="d-flex justify-content-between align-items-center mb-3">
            <h2 class="fc-section-title">特色菜品直达</h2>
            <a class="fc-pill" href="${pageContext.request.contextPath}/stall/list"><strong>全部美食</strong> →</a>
        </div>
        <div class="row g-4">
            <c:choose>
                <c:when test="${not empty featuredProducts}">
                    <c:forEach items="${featuredProducts}" var="product">
                        <div class="col-md-4">
                            <div class="fc-card h-100">
                                <c:if test="${not empty product.imageUrl}">
                                    <img class="fc-image w-100" src="${product.imageUrl}" alt="${product.productName}" />
                                </c:if>
                                <c:if test="${empty product.imageUrl}">
                                    <div class="fc-image w-100 d-flex align-items-center justify-content-center text-muted bg-light">暂无图片</div>
                                </c:if>
                                <div class="p-3">
                                    <div class="d-flex justify-content-between align-items-center">
                                        <h5 class="fw-bold mb-1">${product.productName}</h5>
                                        <span class="fc-chip">热销</span>
                                    </div>
                                    <c:choose>
                                        <c:when test="${not empty product.description}">
                                            <p class="text-muted">${product.description}</p>
                                        </c:when>
                                        <c:otherwise>
                                            <p class="text-muted">街区招牌推荐</p>
                                        </c:otherwise>
                                    </c:choose>
                                    <div class="d-flex justify-content-between align-items-center">
                                        <span class="fw-semibold">￥${product.price}</span>
                                        <a class="btn btn-outline-dark" href="${pageContext.request.contextPath}/stall/detail?id=${product.stallId}">查看摊位</a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="col-md-4">
                        <div class="fc-card h-100">
                            <img class="fc-image w-100" src="https://images.unsplash.com/photo-1504674900247-0877df9cc836?auto=format&fit=crop&w=900&q=80" alt="招牌烤肉" />
                            <div class="p-3">
                                <div class="d-flex justify-content-between align-items-center">
                                    <h5 class="fw-bold mb-1">炙火烤肉拼盘</h5>
                                    <span class="fc-chip">热销</span>
                                </div>
                                <p class="text-muted">浓郁炭香 + 特制蘸料，街区明星摊位出品</p>
                                <a class="btn btn-outline-dark w-100" href="${pageContext.request.contextPath}/stall/list">立即下单</a>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="fc-card h-100">
                            <img class="fc-image w-100" src="https://images.unsplash.com/photo-1473093295043-cdd812d0e601?auto=format&fit=crop&w=900&q=80" alt="海鲜捞" />
                            <div class="p-3">
                                <div class="d-flex justify-content-between align-items-center">
                                    <h5 class="fw-bold mb-1">深夜海鲜捞</h5>
                                    <span class="fc-chip">必点</span>
                                </div>
                                <p class="text-muted">鲜香浓郁，搭配多重口味选择</p>
                                <a class="btn btn-outline-dark w-100" href="${pageContext.request.contextPath}/stall/list">查看摊位</a>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="fc-card h-100">
                            <img class="fc-image w-100" src="https://images.unsplash.com/photo-1499028344343-cd173ffc68a9?auto=format&fit=crop&w=900&q=80" alt="爆汁汉堡" />
                            <div class="p-3">
                                <div class="d-flex justify-content-between align-items-center">
                                    <h5 class="fw-bold mb-1">招牌爆汁汉堡</h5>
                                    <span class="fc-chip">新品</span>
                                </div>
                                <p class="text-muted">厚切牛肉 + 芝士流心</p>
                                <a class="btn btn-outline-dark w-100" href="${pageContext.request.contextPath}/stall/list">立即逛吃</a>
                            </div>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </section>

    <section id="stalls" class="mb-5">
        <div class="d-flex justify-content-between align-items-center mb-3">
            <h2 class="fc-section-title">推荐摊位</h2>
            <a class="fc-pill" href="${pageContext.request.contextPath}/stall/list"><strong>更多摊位</strong> →</a>
        </div>
        <div class="row g-4">
            <c:choose>
                <c:when test="${not empty recommendedStalls}">
                    <c:forEach items="${recommendedStalls}" var="stall">
                        <div class="col-md-3">
                            <div class="fc-card h-100 p-3">
                                <h5 class="fw-bold">${stall.stallName}</h5>
                                <c:choose>
                                    <c:when test="${not empty stall.description}">
                                        <p class="text-muted mb-3">${stall.description}</p>
                                    </c:when>
                                    <c:otherwise>
                                        <p class="text-muted mb-3">${stall.categoryName} | 热门摊位</p>
                                    </c:otherwise>
                                </c:choose>
                                <div class="d-flex gap-2 flex-wrap">
                                    <c:if test="${not empty stall.categoryName}">
                                        <span class="fc-chip">${stall.categoryName}</span>
                                    </c:if>
                                    <span class="fc-chip">${stall.location}</span>
                                </div>
                                <a class="btn btn-dark w-100 mt-3" href="${pageContext.request.contextPath}/stall/detail?id=${stall.id}">进店看看</a>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="col-md-3">
                        <div class="fc-card h-100 p-3">
                            <h5 class="fw-bold">辣味研究所</h5>
                            <p class="text-muted mb-3">川味街头小吃 | 排队必吃</p>
                            <div class="d-flex gap-2 flex-wrap">
                                <span class="fc-chip">辣度自选</span>
                                <span class="fc-chip">夜宵王</span>
                            </div>
                            <a class="btn btn-dark w-100 mt-3" href="${pageContext.request.contextPath}/stall/list">进店看看</a>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="fc-card h-100 p-3">
                            <h5 class="fw-bold">炭火串串屋</h5>
                            <p class="text-muted mb-3">精选肉串 | 香气扑鼻</p>
                            <div class="d-flex gap-2 flex-wrap">
                                <span class="fc-chip">今日推荐</span>
                                <span class="fc-chip">多人套餐</span>
                            </div>
                            <a class="btn btn-dark w-100 mt-3" href="${pageContext.request.contextPath}/stall/list">进店看看</a>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="fc-card h-100 p-3">
                            <h5 class="fw-bold">暖心甜品铺</h5>
                            <p class="text-muted mb-3">手作甜品 | 低糖轻负担</p>
                            <div class="d-flex gap-2 flex-wrap">
                                <span class="fc-chip">拍照友好</span>
                                <span class="fc-chip">下午茶</span>
                            </div>
                            <a class="btn btn-dark w-100 mt-3" href="${pageContext.request.contextPath}/stall/list">进店看看</a>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="fc-card h-100 p-3">
                            <h5 class="fw-bold">招牌牛杂面</h5>
                            <p class="text-muted mb-3">浓汤熬制 | 深夜食堂</p>
                            <div class="d-flex gap-2 flex-wrap">
                                <span class="fc-chip">热腾腾</span>
                                <span class="fc-chip">一碗满足</span>
                            </div>
                            <a class="btn btn-dark w-100 mt-3" href="${pageContext.request.contextPath}/stall/list">进店看看</a>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </section>

    <section id="promotions" class="mb-5">
        <div class="d-flex justify-content-between align-items-center mb-3">
            <h2 class="fc-section-title">限时优惠与活动</h2>
        </div>
        <div class="row g-4">
            <div class="col-lg-7">
                <div class="fc-card h-100">
                    <c:choose>
                        <c:when test="${not empty promotionProduct}">
                            <div class="p-4">
                                <h4 class="fw-bold">${promotionProduct.productName}</h4>
                                <c:choose>
                                    <c:when test="${not empty promotionProduct.description}">
                                        <p class="text-muted">${promotionProduct.description}</p>
                                    </c:when>
                                    <c:otherwise>
                                        <p class="text-muted">今日人气推荐，限时热卖中。</p>
                                    </c:otherwise>
                                </c:choose>
                                <div class="d-flex align-items-center justify-content-between">
                                    <span class="fw-semibold">￥${promotionProduct.price}</span>
                                    <a class="btn btn-dark" href="${pageContext.request.contextPath}/stall/detail?id=${promotionProduct.stallId}">立即使用</a>
                                </div>
                            </div>
                            <c:if test="${not empty promotionProduct.imageUrl}">
                                <img class="fc-image w-100" src="${promotionProduct.imageUrl}" alt="${promotionProduct.productName}" />
                            </c:if>
                            <c:if test="${empty promotionProduct.imageUrl}">
                                <div class="fc-image w-100 d-flex align-items-center justify-content-center text-muted bg-light">暂无图片</div>
                            </c:if>
                        </c:when>
                        <c:otherwise>
                            <div class="p-4">
                                <h4 class="fw-bold">夜宵畅吃券</h4>
                                <p class="text-muted">21:00-23:00 全场满 60 减 12，夜猫子必备福利。</p>
                                <a class="btn btn-dark" href="${pageContext.request.contextPath}/stall/list">立即使用</a>
                            </div>
                            <img class="fc-image w-100" src="https://images.unsplash.com/photo-1498654896293-37aacf113fd9?auto=format&fit=crop&w=1200&q=80" alt="夜宵畅吃" />
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
            <div class="col-lg-5">
                <div class="fc-card h-100 p-4">
                    <h4 class="fw-bold">美食地图导览</h4>
                    <p class="text-muted">从入口到摊位，一眼找到想吃的那一口。</p>
                    <div class="d-flex flex-column gap-3">
                        <div class="fc-stat">
                            <div class="fw-semibold">A区 夜宵热卖</div>
                            <div class="text-muted">串串、烤肉、麻辣拌</div>
                        </div>
                        <div class="fc-stat">
                            <div class="fw-semibold">B区 甜品轻食</div>
                            <div class="text-muted">甜品、饮品、轻食沙拉</div>
                        </div>
                        <a class="btn btn-outline-dark mt-2" href="${pageContext.request.contextPath}/stall/list">查看摊位分布</a>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <section class="fc-footer text-center py-4">
        <div>美食街 · 热闹、好吃、随时来逛</div>
        <div class="mt-2">营业时间 10:00 - 24:00 | 客服热线 400-888-8888</div>
    </section>
</main>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
