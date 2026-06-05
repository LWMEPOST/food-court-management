<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <link rel="icon" href="data:image/svg+xml,<svg xmlns=%22http://www.w3.org/2000/svg%22 viewBox=%220 0 100 100%22><text y=%22.9em%22 font-size=%2290%22>🍜</text></svg>">
    <meta charset="UTF-8">
    <title>商品管理 - ${stall.stallName}</title>
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
                <a href="${pageContext.request.contextPath}/owner/products" class="list-group-item list-group-item-action active">商品管理</a>
                <a href="${pageContext.request.contextPath}/owner/orders" class="list-group-item list-group-item-action">订单管理</a>
                <a href="${pageContext.request.contextPath}/owner/leases" class="list-group-item list-group-item-action">合同管理</a>
            </div>
        </div>
        <div class="col-lg-9">
            <nav aria-label="breadcrumb" class="mb-3">
                <ol class="breadcrumb">
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/owner/dashboard">首页</a></li>
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/owner/products">选择摊位</a></li>
                    <li class="breadcrumb-item active" aria-current="page">${stall.stallName}</li>
                </ol>
            </nav>

            <div class="fc-card p-4">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h4 class="fw-bold mb-0">商品列表</h4>
                    <a href="${pageContext.request.contextPath}/owner/products?action=create&stallId=${stall.id}" class="btn btn-dark">新增商品</a>
                </div>

                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-light">
                            <tr>
                                <th>图片</th>
                                <th>名称</th>
                                <th>价格</th>
                                <th>状态</th>
                                <th>操作</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${products}" var="p">
                                <tr>
                                    <td>
                                        <c:if test="${not empty p.imageUrl}">
                                            <img src="${p.imageUrl}" alt="${p.productName}" style="width: 56px; height: 56px; object-fit: cover; border-radius: 8px;">
                                        </c:if>
                                    </td>
                                    <td class="fw-semibold">${p.productName}</td>
                                    <td>¥${p.price}</td>
                                    <td>
                                        <span class="badge bg-${p.status == 'AVAILABLE' ? 'success' : 'secondary'}">
                                            ${p.status == 'AVAILABLE' ? '上架' : '下架'}
                                        </span>
                                    </td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/owner/products?action=edit&id=${p.id}&stallId=${stall.id}" class="btn btn-sm btn-outline-dark">编辑</a>
                                        <form action="${pageContext.request.contextPath}/owner/products" method="post" class="d-inline" onsubmit="return confirm('确定要删除吗？');">
                                            <input type="hidden" name="action" value="delete">
                                            <input type="hidden" name="id" value="${p.id}">
                                            <input type="hidden" name="stallId" value="${stall.id}">
                                            <button type="submit" class="btn btn-sm btn-outline-danger">删除</button>
                                        </form>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty products}">
                                <tr>
                                    <td colspan="5" class="text-center text-muted">暂无商品数据</td>
                                </tr>
                            </c:if>
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
