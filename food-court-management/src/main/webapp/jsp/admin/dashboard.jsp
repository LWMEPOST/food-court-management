<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <link rel="icon" href="data:image/svg+xml,<svg xmlns=%22http://www.w3.org/2000/svg%22 viewBox=%220 0 100 100%22><text y=%22.9em%22 font-size=%2290%22>🍜</text></svg>">
    <meta charset="UTF-8">
    <title>管理员控制台 - 美食街管理系统</title>
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
                <a href="${pageContext.request.contextPath}/admin/dashboard" class="list-group-item list-group-item-action active">运营概览</a>
                <a href="${pageContext.request.contextPath}/admin/users" class="list-group-item list-group-item-action">用户管理</a>
                <a href="${pageContext.request.contextPath}/admin/stalls" class="list-group-item list-group-item-action">摊位管理</a>
                <a href="${pageContext.request.contextPath}/admin/categories" class="list-group-item list-group-item-action">品类管理</a>
                <a href="${pageContext.request.contextPath}/admin/orders" class="list-group-item list-group-item-action">订单监管</a>
                <a href="${pageContext.request.contextPath}/admin/leases" class="list-group-item list-group-item-action">租赁管理</a>
            </div>
        </div>
        <div class="col-lg-9">
            <div class="fc-card p-4">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h4 class="fw-bold mb-0">美食街运营概况</h4>
                    <span class="badge bg-light text-dark">今日</span>
                </div>
                <p class="text-muted">集中查看平台关键指标与待处理事项。</p>
                <div class="row g-3">
                    <div class="col-md-4">
                        <div class="fc-card p-3 h-100">
                            <div class="text-muted">摊位出租率</div>
                            <div class="display-6 fw-bold">${occupancyRate}%</div>
                            <div class="text-muted">已租 ${rentedStalls} / 总计 ${totalStalls}</div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="fc-card p-3 h-100">
                            <div class="text-muted">订单缴费率</div>
                            <div class="display-6 fw-bold">${paymentRate}%</div>
                            <div class="text-muted">已付 ${paidOrders} / 总单 ${totalOrders}</div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="fc-card p-3 h-100">
                            <div class="text-muted">总订单量</div>
                            <div class="display-6 fw-bold">${totalOrders}</div>
                            <div class="text-muted">平台累计交易</div>
                        </div>
                    </div>
                </div>
                
                <div class="row mt-4">
                    <div class="col-12">
                        <div class="fc-card p-4">
                            <h5 class="fw-bold mb-3">热门摊位排行 (Top 5)</h5>
                            <canvas id="popularStallsChart" height="100"></canvas>
                        </div>
                    </div>
                </div>

                <div class="fc-card p-3 mt-4">
                    <h6 class="fw-bold">风险提示</h6>
                    <p class="text-muted mb-0">当前暂无异常波动，建议持续关注高峰期订单。</p>
                </div>
            </div>
        </div>
    </div>
</main>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
    const ctx = document.getElementById('popularStallsChart').getContext('2d');
    
    // Prepare data from JSP
    const labels = [
        <c:forEach items="${topStallNames}" var="name" varStatus="status">
            "${name}"${!status.last ? ',' : ''}
        </c:forEach>
    ];
    
    const data = [
        <c:forEach items="${topStallData}" var="count" varStatus="status">
            ${count}${!status.last ? ',' : ''}
        </c:forEach>
    ];

    new Chart(ctx, {
        type: 'bar',
        data: {
            labels: labels,
            datasets: [{
                label: '订单数量',
                data: data,
                backgroundColor: 'rgba(255, 107, 53, 0.6)',
                borderColor: 'rgba(255, 107, 53, 1)',
                borderWidth: 1,
                borderRadius: 4
            }]
        },
        options: {
            responsive: true,
            scales: {
                y: {
                    beginAtZero: true,
                    ticks: {
                        precision: 0
                    }
                }
            },
            plugins: {
                legend: {
                    display: false
                }
            }
        }
    });
</script>
</body>
</html>
