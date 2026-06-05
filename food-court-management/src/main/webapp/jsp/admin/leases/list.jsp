<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <link rel="icon" href="data:image/svg+xml,<svg xmlns=%22http://www.w3.org/2000/svg%22 viewBox=%220 0 100 100%22><text y=%22.9em%22 font-size=%2290%22>🍜</text></svg>">
    <meta charset="UTF-8">
    <title>租赁管理 - 美食街管理系统</title>
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
        <a class="navbar-brand fw-bold" href="${pageContext.request.contextPath}/admin/dashboard">美食街管理后台</a>
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
                <a href="${pageContext.request.contextPath}/admin/dashboard" class="list-group-item list-group-item-action">运营概览</a>
                <a href="${pageContext.request.contextPath}/admin/users" class="list-group-item list-group-item-action">用户管理</a>
                <a href="${pageContext.request.contextPath}/admin/stalls" class="list-group-item list-group-item-action">摊位管理</a>
                <a href="${pageContext.request.contextPath}/admin/categories" class="list-group-item list-group-item-action">品类管理</a>
                <a href="${pageContext.request.contextPath}/admin/orders" class="list-group-item list-group-item-action">订单监管</a>
                <a href="${pageContext.request.contextPath}/admin/leases" class="list-group-item list-group-item-action active">租赁管理</a>
            </div>
        </div>
        <div class="col-lg-9">
            <div class="fc-card p-4">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h4 class="fw-bold mb-0">租赁与合同管理</h4>
                    <form action="${pageContext.request.contextPath}/admin/leases" method="get" class="d-flex align-items-center gap-2">
                        <input type="text" class="form-control form-control-sm" name="keyword" value="${param.keyword}" placeholder="搜索摊位、摊主或状态">
                        <button type="submit" class="btn btn-sm btn-outline-dark">搜索</button>
                    </form>
                </div>
                
                <div class="table-responsive">
                    <table class="table table-hover">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>摊位</th>
                                <th>摊主</th>
                                <th>类型</th>
                                <th>起止时间</th>
                                <th>状态</th>
                                <th>操作</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${leases}" var="lease">
                                <tr>
                                    <td>${lease.id}</td>
                                    <td>${lease.stallName}</td>
                                    <td>${lease.ownerName}</td>
                                    <td>
                                        <c:if test="${lease.type == 'NEW'}">新租</c:if>
                                        <c:if test="${lease.type == 'RENEWAL'}">续租</c:if>
                                    </td>
                                    <td>
                                        <fmt:formatDate value="${lease.startDate}" pattern="yyyy-MM-dd"/> 至 
                                        <fmt:formatDate value="${lease.endDate}" pattern="yyyy-MM-dd"/>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${lease.status == 'PENDING'}"><span class="badge bg-warning text-dark">待审核</span></c:when>
                                            <c:when test="${lease.status == 'APPROVED'}"><span class="badge bg-info text-dark">已通过</span></c:when>
                                            <c:when test="${lease.status == 'REJECTED'}"><span class="badge bg-danger">已拒绝</span></c:when>
                                            <c:when test="${lease.status == 'ACTIVE'}"><span class="badge bg-success">生效中</span></c:when>
                                            <c:when test="${lease.status == 'EXPIRED'}"><span class="badge bg-secondary">已过期</span></c:when>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:if test="${lease.status == 'PENDING'}">
                                            <form action="${pageContext.request.contextPath}/admin/leases" method="post" class="d-inline">
                                                <input type="hidden" name="action" value="updateStatus">
                                                <input type="hidden" name="leaseId" value="${lease.id}">
                                                <input type="hidden" name="status" value="APPROVED">
                                                <button type="submit" class="btn btn-sm btn-success">通过</button>
                                            </form>
                                            <form action="${pageContext.request.contextPath}/admin/leases" method="post" class="d-inline">
                                                <input type="hidden" name="action" value="updateStatus">
                                                <input type="hidden" name="leaseId" value="${lease.id}">
                                                <input type="hidden" name="status" value="REJECTED">
                                                <button type="submit" class="btn btn-sm btn-danger">拒绝</button>
                                            </form>
                                        </c:if>
                                        <c:if test="${lease.status == 'APPROVED' && empty lease.contractContent}">
                                            <form action="${pageContext.request.contextPath}/admin/leases" method="post" class="d-inline">
                                                <input type="hidden" name="action" value="generateContract">
                                                <input type="hidden" name="leaseId" value="${lease.id}">
                                                <button type="submit" class="btn btn-sm btn-primary">生成合同</button>
                                            </form>
                                        </c:if>
                                        <c:if test="${not empty lease.contractContent}">
                                            <button type="button" class="btn btn-sm btn-outline-secondary" data-bs-toggle="modal" data-bs-target="#contractModal${lease.id}">
                                                查看合同
                                            </button>

                                            <!-- Modal -->
                                            <div class="modal fade" id="contractModal${lease.id}" tabindex="-1" aria-labelledby="contractModalLabel${lease.id}" aria-hidden="true">
                                                <div class="modal-dialog modal-lg">
                                                    <div class="modal-content">
                                                        <div class="modal-header">
                                                            <h5 class="modal-title" id="contractModalLabel${lease.id}">合同详情 - ${lease.stallName}</h5>
                                                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="关闭"></button>
                                                        </div>
                                                        <div class="modal-body">
                                                            <pre class="bg-light p-3 border rounded" style="white-space: pre-wrap;">${lease.contractContent}</pre>
                                                        </div>
                                                        <div class="modal-footer">
                                                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">关闭</button>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
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
