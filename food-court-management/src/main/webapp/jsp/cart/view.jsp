<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <link rel="icon" href="data:image/svg+xml,<svg xmlns=%22http://www.w3.org/2000/svg%22 viewBox=%220 0 100 100%22><text y=%22.9em%22 font-size=%2290%22>🍜</text></svg>">
    <meta charset="UTF-8">
    <title>购物车 - 美食街</title>
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

        .fc-card {
            border: 1px solid var(--fc-border);
            border-radius: var(--fc-radius-md);
            box-shadow: 0 10px 24px rgba(46, 31, 20, 0.08);
            background: var(--fc-surface);
        }

        .fc-summary {
            border: 1px dashed #f5c8a9;
            background: #fff2e6;
            border-radius: var(--fc-radius-md);
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
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h2 class="fw-bold">我的购物车</h2>
        <a href="${pageContext.request.contextPath}/stall/list" class="btn btn-outline-dark">继续逛吃</a>
    </div>

    <c:if test="${not empty sessionScope.message}">
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            ${sessionScope.message}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="关闭"></button>
        </div>
        <c:remove var="message" scope="session"/>
    </c:if>

    <c:if test="${not empty sessionScope.error}">
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            ${sessionScope.error}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="关闭"></button>
        </div>
        <c:remove var="error" scope="session"/>
    </c:if>

    <c:if test="${empty sessionScope.cart || empty sessionScope.cart.items}">
        <div class="fc-card p-4 text-center">
            <h5 class="fw-bold">购物车空空如也</h5>
            <p class="text-muted">去挑选一些心动美食吧。</p>
            <a class="btn btn-dark" href="${pageContext.request.contextPath}/stall/list">去逛摊位</a>
        </div>
    </c:if>

    <c:if test="${not empty sessionScope.cart && not empty sessionScope.cart.items}">
        <div class="row g-4">
            <div class="col-lg-8">
                <div class="fc-card p-3">
                    <div class="table-responsive">
                        <table class="table align-middle mb-0">
                            <thead>
                                <tr>
                                    <th>商品</th>
                                    <th>单价</th>
                                    <th>数量</th>
                                    <th>小计</th>
                                    <th>操作</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${sessionScope.cart.items}" var="item">
                                    <tr>
                                        <td>
                                            <div class="fw-bold">${item.product.productName}</div>
                                        </td>
                                        <td>¥${item.product.price}</td>
                                        <td>
                                            <form action="${pageContext.request.contextPath}/cart" method="post" class="d-flex" style="width: 160px;">
                                                <input type="hidden" name="action" value="update">
                                                <input type="hidden" name="productId" value="${item.product.id}">
                                                <input type="number" name="quantity" value="${item.quantity}" min="1" class="form-control me-2">
                                                <button type="submit" class="btn btn-sm btn-outline-secondary">更新</button>
                                            </form>
                                        </td>
                                        <td>¥${item.subtotal}</td>
                                        <td>
                                            <form action="${pageContext.request.contextPath}/cart" method="post">
                                                <input type="hidden" name="action" value="remove">
                                                <input type="hidden" name="productId" value="${item.product.id}">
                                                <button type="submit" class="btn btn-sm btn-outline-danger">删除</button>
                                            </form>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
            <div class="col-lg-4">
                <div class="fc-card fc-summary p-4">
                    <c:set var="discount" value="${sessionScope.cartDiscount != null ? sessionScope.cartDiscount : 0}" />
                    <c:set var="payable" value="${sessionScope.cart.totalAmount - discount}" />
                    <h5 class="fw-bold">订单汇总</h5>
                    <div class="d-flex justify-content-between mt-3">
                        <span class="text-muted">商品合计</span>
                        <span class="fw-bold">¥${sessionScope.cart.totalAmount}</span>
                    </div>
                    <div class="d-flex justify-content-between mt-2">
                        <span class="text-muted">优惠</span>
                        <span class="fw-bold">¥${discount}</span>
                    </div>
                    <hr>
                    <div class="d-flex justify-content-between">
                        <span class="fw-bold">应付金额</span>
                        <span class="fw-bold text-danger">¥${payable}</span>
                    </div>
                    <div class="mt-3">
                        <div class="text-muted mb-2">优惠券</div>
                        <form action="${pageContext.request.contextPath}/cart" method="post" class="d-flex gap-2">
                            <input type="hidden" name="action" value="applyCoupon">
                            <input type="text" class="form-control" name="couponCode" placeholder="输入优惠码，例如 FC10" value="${sessionScope.cartCoupon}">
                            <button type="submit" class="btn btn-outline-dark">使用</button>
                        </form>
                    </div>
                    <form action="${pageContext.request.contextPath}/order/checkout" method="post" class="mt-4">
                        <button type="submit" class="btn btn-dark w-100 btn-lg">去结算</button>
                    </form>
                    <form action="${pageContext.request.contextPath}/cart" method="post" class="mt-3">
                        <input type="hidden" name="action" value="clear">
                        <button type="submit" class="btn btn-outline-danger w-100">清空购物车</button>
                    </form>
                </div>
            </div>
        </div>
    </c:if>
</main>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
