<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
    <link rel="icon" href="data:image/svg+xml,<svg xmlns=%22http://www.w3.org/2000/svg%22 viewBox=%220 0 100 100%22><text y=%22.9em%22 font-size=%2290%22>🍜</text></svg>">
    <title>订单管理 - 摊主中心</title>
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
                <div class="fc-sidebar list-group">
                    <a href="${pageContext.request.contextPath}/owner/dashboard" class="list-group-item list-group-item-action">经营概览</a>
                    <a href="${pageContext.request.contextPath}/owner/stalls" class="list-group-item list-group-item-action">我的摊位</a>
                    <a href="${pageContext.request.contextPath}/owner/products" class="list-group-item list-group-item-action">商品管理</a>
                    <a href="${pageContext.request.contextPath}/owner/orders" class="list-group-item list-group-item-action active">订单管理</a>
                    <a href="${pageContext.request.contextPath}/owner/leases" class="list-group-item list-group-item-action">合同管理</a>
                </div>
            </div>
            <div class="col-lg-9">
                <div class="fc-card p-4">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <h4 class="fw-bold mb-0">订单管理</h4>
                        <span class="badge bg-light text-dark">实时更新</span>
                    </div>
                    <c:if test="${not empty sessionScope.message}">
                        <div class="alert alert-success alert-dismissible fade show" role="alert">
                            ${sessionScope.message}
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="关闭"></button>
                        </div>
                        <c:remove var="message" scope="session"/>
                    </c:if>

                    <c:if test="${empty orders}">
                        <div class="alert alert-info">暂无订单</div>
                    </c:if>

                    <c:if test="${not empty orders}">
                        <div class="table-responsive">
                            <table class="table table-hover align-middle mb-0">
                                <thead class="table-light">
                                    <tr>
                                        <th>订单号</th>
                                        <th>取餐号</th>
                                        <th>摊位</th>
                                        <th>下单时间</th>
                                        <th>金额</th>
                                        <th>支付</th>
                                        <th>状态</th>
                                        <th>操作</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="order" items="${orders}">
                                        <tr>
                                            <td>
                                                <a href="${pageContext.request.contextPath}/owner/order/detail?id=${order.id}">
                                                    <c:choose>
                                                        <c:when test="${order.paymentStatus == 'PAID'}">${order.orderNumber}</c:when>
                                                        <c:otherwise>待生成</c:otherwise>
                                                    </c:choose>
                                                </a>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${order.paymentStatus == 'PAID' && not empty order.pickupNumber}">${order.pickupNumber}</c:when>
                                                    <c:otherwise>待生成</c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>${order.stallName}</td>
                                            <td><fmt:formatDate value="${order.orderTime}" pattern="yyyy-MM-dd HH:mm"/></td>
                                            <td>¥${order.totalAmount}</td>
                                            <td>${order.paymentMethod}</td>
                                            <td>
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
                                            </td>
                                            <td>
                                                <form action="${pageContext.request.contextPath}/owner/orders" method="post" class="d-inline">
                                                    <input type="hidden" name="orderId" value="${order.id}">
                                                    <c:if test="${order.status == 'PENDING'}">
                                                        <button type="submit" name="action" value="confirm" class="btn btn-sm btn-outline-success">确认</button>
                                                        <button type="submit" name="action" value="cancel" class="btn btn-sm btn-outline-danger">拒绝</button>
                                                    </c:if>
                                                    <c:if test="${order.status == 'CONFIRMED'}">
                                                        <button type="submit" name="action" value="prepare" class="btn btn-sm btn-outline-primary">开始准备</button>
                                                        <button type="submit" name="action" value="cancel" class="btn btn-sm btn-outline-danger">取消</button>
                                                    </c:if>
                                                    <c:if test="${order.status == 'PREPARING'}">
                                                        <button type="submit" name="action" value="complete" class="btn btn-sm btn-success">完成</button>
                                                    </c:if>
                                                    <c:if test="${order.status == 'COMPLETED' || order.status == 'CANCELLED'}">
                                                        <button type="button" class="btn btn-sm btn-secondary" disabled>无操作</button>
                                                    </c:if>
                                                </form>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>
    </main>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
