<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <link rel="icon" href="data:image/svg+xml,<svg xmlns=%22http://www.w3.org/2000/svg%22 viewBox=%220 0 100 100%22><text y=%22.9em%22 font-size=%2290%22>🍜</text></svg>">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${empty product ? '新增' : '编辑'}商品 - 摊主中心</title>
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

        .fc-card {
            background: var(--fc-surface);
            border: 1px solid var(--fc-border);
            border-radius: var(--fc-radius-md);
            box-shadow: var(--fc-shadow);
        }

        .form-control:focus,
        .form-select:focus {
            border-color: var(--fc-primary);
            box-shadow: 0 0 0 0.2rem rgba(31, 122, 140, 0.2);
        }
    </style>
</head>
<body class="theme-owner">
<nav class="navbar navbar-expand-lg fc-nav">
    <div class="container">
        <a class="navbar-brand fw-bold" href="${pageContext.request.contextPath}/owner/dashboard">摊主中心</a>
    </div>
</nav>

<main class="container py-4">
    <div class="row justify-content-center">
        <div class="col-lg-8">
            <div class="fc-card p-4">
                <div class="mb-4">
                    <h4 class="fw-bold mb-1">${empty product ? '新增商品' : '编辑商品'}</h4>
                    <div class="text-muted">完善商品信息，提升摊位曝光与下单转化</div>
                </div>
                <div>
                    <form action="${pageContext.request.contextPath}/owner/products" method="post" enctype="multipart/form-data">
                        <input type="hidden" name="id" value="${product.id}">
                        <input type="hidden" name="stallId" value="${stallId}">
                        
                        <div class="mb-3">
                            <label for="productName" class="form-label">商品名称</label>
                            <input type="text" class="form-control" id="productName" name="productName" value="${product.productName}" required>
                        </div>
                        
                        <div class="mb-3">
                            <label for="price" class="form-label">价格</label>
                            <div class="input-group">
                                <span class="input-group-text">¥</span>
                                <input type="number" class="form-control" id="price" name="price" value="${product.price}" step="0.01" min="0" required>
                            </div>
                        </div>
                        
                        <div class="mb-3">
                            <label for="imageFile" class="form-label">图片上传</label>
                            <input type="file" class="form-control" id="imageFile" name="imageFile" accept="image/*">
                        </div>

                        <div class="mb-3">
                            <label for="imageUrl" class="form-label">图片链接</label>
                            <input type="text" class="form-control" id="imageUrl" name="imageUrl" value="${product.imageUrl}" placeholder="https://example.com/image.jpg">
                        </div>
                        
                        <div class="mb-3">
                            <label for="status" class="form-label">状态</label>
                            <select class="form-select" id="status" name="status" required>
                                <option value="AVAILABLE" ${product.status == 'AVAILABLE' ? 'selected' : ''}>上架</option>
                                <option value="UNAVAILABLE" ${product.status == 'UNAVAILABLE' ? 'selected' : ''}>下架</option>
                            </select>
                        </div>
                        
                        <div class="mb-3">
                            <label for="description" class="form-label">描述</label>
                            <textarea class="form-control" id="description" name="description" rows="3">${product.description}</textarea>
                        </div>
                        
                        <div class="d-flex justify-content-between">
                            <a href="${pageContext.request.contextPath}/owner/products?stallId=${stallId}" class="btn btn-outline-dark">返回</a>
                            <button type="submit" class="btn btn-dark">保存</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</main>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    const imageFileEl = document.getElementById('imageFile');
    const imageUrlEl = document.getElementById('imageUrl');
    if (imageFileEl && imageUrlEl) {
        imageFileEl.addEventListener('change', () => {
            if (imageFileEl.files && imageFileEl.files.length > 0) {
                imageUrlEl.value = '';
            }
        });
    }
</script>
</body>
</html>
