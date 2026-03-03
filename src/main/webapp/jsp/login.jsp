<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <link rel="icon" href="data:image/svg+xml,<svg xmlns=%22http://www.w3.org/2000/svg%22 viewBox=%220 0 100 100%22><text y=%22.9em%22 font-size=%2290%22>🍜</text></svg>">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>用户登录 - 美食街摊位管理系统</title>
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

        .form-control:focus {
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
        <div class="col-lg-5 col-md-7">
            <div class="fc-auth-card">
                <div class="text-center mb-4">
                    <div class="fc-brand">美食街</div>
                    <h3 class="fw-bold mb-1">欢迎回来</h3>
                    <p class="text-muted mb-0">登录后继续探索街区美味</p>
                </div>

                <c:if test="${not empty error}">
                    <div class="alert alert-danger" role="alert">
                        ${error}
                    </div>
                </c:if>

                <form action="${pageContext.request.contextPath}/login" method="post">
                    <div class="mb-3">
                        <label for="username" class="form-label">用户名</label>
                        <input type="text" class="form-control" id="username" name="username" required>
                    </div>
                    <div class="mb-3">
                        <label for="password" class="form-label">密码</label>
                        <input type="password" class="form-control" id="password" name="password" required>
                    </div>
                    <div class="d-grid">
                        <button type="submit" class="btn btn-primary btn-lg">登录</button>
                    </div>
                    <div class="mt-3 text-center">
                        <a href="${pageContext.request.contextPath}/register" class="link-dark">没有账号？去注册</a>
                    </div>
                </form>
            </div>
        </div>
    </div>
</main>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
