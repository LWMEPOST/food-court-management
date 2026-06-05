<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <link rel="icon" href="data:image/svg+xml,<svg xmlns=%22http://www.w3.org/2000/svg%22 viewBox=%220 0 100 100%22><text y=%22.9em%22 font-size=%2290%22>🍜</text></svg>">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>用户注册 - 美食街摊位管理系统</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        :root {
            --fc-primary: #ff6b35;
            --fc-secondary: #ffb703;
            --fc-bg: #fff7f0;
            --fc-surface: #ffffff;
            --fc-text: #2a1a10;
            --fc-muted: #6b4e3d;
            --fc-border: #f2d9cb;
            --fc-shadow: 0 18px 40px rgba(255, 107, 53, 0.18);
            --fc-radius-lg: 18px;
        }

        body.theme-auth {
            background: linear-gradient(180deg, #fff1e6, #fff8f1);
            color: var(--fc-text);
            font-family: "Segoe UI", "PingFang SC", "Microsoft YaHei", system-ui, sans-serif;
        }

        .fc-auth-card {
            background: var(--fc-surface);
            border: 1px solid var(--fc-border);
            border-radius: var(--fc-radius-lg);
            box-shadow: var(--fc-shadow);
            padding: 32px;
        }

        .fc-brand {
            font-weight: 800;
            color: var(--fc-primary);
            letter-spacing: 1px;
            font-size: 20px;
        }

        .form-control:focus,
        .form-select:focus {
            border-color: var(--fc-primary);
            box-shadow: 0 0 0 0.2rem rgba(255, 107, 53, 0.2);
        }

        .btn-primary {
            background: var(--fc-primary);
            border-color: var(--fc-primary);
        }

        .btn-primary:hover {
            background: #f05a25;
            border-color: #f05a25;
        }
    </style>
</head>
<body class="theme-auth">

<main class="container">
    <div class="row align-items-center justify-content-center min-vh-100 py-5">
        <div class="col-lg-6 col-md-8">
            <div class="fc-auth-card">
                <div class="text-center mb-4">
                    <div class="fc-brand">美食街</div>
                    <h3 class="fw-bold mb-1">创建新账号</h3>
                    <p class="text-muted mb-0">加入街区，开启你的美食旅程</p>
                </div>

                <c:if test="${not empty error}">
                    <div class="alert alert-danger" role="alert">
                        ${error}
                    </div>
                </c:if>

                <form action="${pageContext.request.contextPath}/register" method="post">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label for="username" class="form-label">用户名</label>
                            <input type="text" class="form-control" id="username" name="username" required>
                        </div>
                        <div class="col-md-6">
                            <label for="phone" class="form-label">手机号</label>
                            <input type="tel" class="form-control" id="phone" name="phone">
                        </div>
                        <div class="col-12">
                            <label for="email" class="form-label">邮箱</label>
                            <input type="email" class="form-control" id="email" name="email" required>
                        </div>
                        <div class="col-md-6">
                            <label for="password" class="form-label">密码</label>
                            <input type="password" class="form-control" id="password" name="password" required>
                        </div>
                        <div class="col-md-6">
                            <label for="confirmPassword" class="form-label">确认密码</label>
                            <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" required>
                        </div>
                        <div class="col-12">
                            <label for="roleType" class="form-label">注册角色</label>
                            <select class="form-select" id="roleType" name="roleType" required>
                                <option value="DINER">食客</option>
                                <option value="OWNER">摊主</option>
                            </select>
                            <div class="form-text">摊主账号需要管理员审核后才能登录</div>
                        </div>
                    </div>
                    <div class="d-grid mt-4">
                        <button type="submit" class="btn btn-primary btn-lg">注册</button>
                    </div>
                    <div class="mt-3 text-center">
                        <a href="${pageContext.request.contextPath}/login" class="link-dark">已有账号？去登录</a>
                    </div>
                </form>
            </div>
        </div>
    </div>
</main>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
