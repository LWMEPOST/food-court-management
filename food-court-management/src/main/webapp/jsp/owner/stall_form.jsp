<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <link rel="icon" href="data:image/svg+xml,<svg xmlns=%22http://www.w3.org/2000/svg%22 viewBox=%220 0 100 100%22><text y=%22.9em%22 font-size=%2290%22>🍜</text></svg>">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${empty stall ? '新增' : '编辑'}摊位 - 摊主中心</title>
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

        .fc-location-box {
            border: 1px solid var(--fc-border);
            border-radius: var(--fc-radius-md);
            background: var(--fc-surface);
            padding: 12px;
        }

        .fc-location-item.active {
            background: rgba(31, 122, 140, 0.12);
            color: var(--fc-primary);
            border-color: transparent;
        }

        .fc-image-preview {
            border: 1px dashed var(--fc-border);
            border-radius: var(--fc-radius-md);
            background: #f8fbfc;
            height: 180px;
            overflow: hidden;
        }

        .fc-image-preview img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            display: none;
        }

        .fc-image-placeholder {
            height: 100%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--fc-muted);
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
                    <h4 class="fw-bold mb-1">${empty stall ? '新增摊位' : '编辑摊位'}</h4>
                    <div class="text-muted">完善摊位信息，帮助食客快速找到你</div>
                </div>
                <div>
                    <form action="${pageContext.request.contextPath}/owner/stalls" method="post" enctype="multipart/form-data">
                        <input type="hidden" name="id" value="${stall.id}">
                        
                        <div class="mb-3">
                            <label for="stallName" class="form-label">摊位名称</label>
                            <input type="text" class="form-control" id="stallName" name="stallName" value="${stall.stallName}" required>
                        </div>
                        
                        <div class="mb-3">
                            <label for="categoryId" class="form-label">所属品类</label>
                            <select class="form-select" id="categoryId" name="categoryId" required>
                                <option value="">请选择品类...</option>
                                <c:forEach items="${categories}" var="cat">
                                    <option value="${cat.id}" ${stall.categoryId == cat.id ? 'selected' : ''}>${cat.categoryName}</option>
                                </c:forEach>
                            </select>
                        </div>
                        
                        <div class="mb-3">
                            <label for="location" class="form-label">位置</label>
                            <div class="mb-2">
                                <input type="text" class="form-control" id="locationSearch" placeholder="搜索品类或摊位编号" autocomplete="off">
                            </div>
                            <div class="fc-location-box mb-2">
                                <div id="locationList" class="list-group"></div>
                                <div class="d-flex justify-content-between align-items-center mt-2">
                                    <button type="button" class="btn btn-sm btn-outline-dark" id="locationPrev">上一页</button>
                                    <div class="text-muted small" id="locationPageInfo"></div>
                                    <button type="button" class="btn btn-sm btn-outline-dark" id="locationNext">下一页</button>
                                </div>
                            </div>
                            <input type="text" class="form-control" id="location" name="location" value="${stall.location}" placeholder="请选择摊位位置" readonly required>
                            <div id="locationData" class="d-none" data-categories='[
                                <c:forEach items="${categories}" var="cat" varStatus="status">
                                    {"id":${cat.id},"name":"${cat.categoryName}","capacity":${cat.regionCapacity != null ? cat.regionCapacity : 20}}${!status.last ? ',' : ''}
                                </c:forEach>
                            ]'
                            data-stalls='[
                                <c:forEach items="${allStalls}" var="stallItem" varStatus="status">
                                    {"id":${stallItem.id},"categoryId":${stallItem.categoryId},"location":"${stallItem.location}"}${!status.last ? ',' : ''}
                                </c:forEach>
                            ]'
                            data-current-id="${stall.id}"></div>
                        </div>
                        
                        <div class="mb-3">
                            <label for="status" class="form-label">状态</label>
                            <select class="form-select" id="status" name="status" required>
                                <option value="OPEN" ${stall.status == 'OPEN' ? 'selected' : ''}>营业中</option>
                                <option value="CLOSED" ${stall.status == 'CLOSED' ? 'selected' : ''}>已打烊</option>
                                <option value="MAINTENANCE" ${stall.status == 'MAINTENANCE' ? 'selected' : ''}>维修中</option>
                            </select>
                        </div>
                        
                        <div class="mb-3">
                            <label for="description" class="form-label">描述</label>
                            <textarea class="form-control" id="description" name="description" rows="3">${stall.description}</textarea>
                        </div>

                        <div class="mb-3">
                            <label for="backgroundImage" class="form-label">背景图</label>
                            <input type="file" class="form-control mb-2" id="backgroundFile" name="backgroundFile" accept="image/*">
                            <input type="text" class="form-control" id="backgroundImage" name="backgroundImage" value="${stall.backgroundImageUrl}" placeholder="https://example.com/banner.jpg">
                            <div class="fc-image-preview mt-2">
                                <img id="backgroundPreview" alt="摊位背景图预览">
                                <div id="backgroundPlaceholder" class="fc-image-placeholder">暂无图片</div>
                            </div>
                            <input type="hidden" id="stallBackgroundUrlRaw" value="<c:out value='${stall.backgroundImageUrl}'/>">
                            <input type="hidden" id="stallImagesRaw" value="<c:out value='${stall.images}'/>">
                        </div>
                        
                        <div class="d-flex justify-content-between">
                            <a href="${pageContext.request.contextPath}/owner/stalls" class="btn btn-outline-dark">返回</a>
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
    const locationDataEl = document.getElementById('locationData');
    const locationSource = locationDataEl ? JSON.parse(locationDataEl.dataset.categories || '[]') : [];

    const locationListEl = document.getElementById('locationList');
    const locationSearchEl = document.getElementById('locationSearch');
    const locationPrevEl = document.getElementById('locationPrev');
    const locationNextEl = document.getElementById('locationNext');
    const locationPageInfoEl = document.getElementById('locationPageInfo');
    const locationInputEl = document.getElementById('location');
    const categorySelectEl = document.getElementById('categoryId');
    const stallsSource = locationDataEl ? JSON.parse(locationDataEl.dataset.stalls || '[]') : [];
    const currentStallId = locationDataEl ? Number(locationDataEl.dataset.currentId || 0) : 0;

    const pageSize = 10;
    let currentPage = 1;
    let currentKeyword = '';

    const existingLocation = locationInputEl.value ? locationInputEl.value.trim() : '';

    const getAvailableLocations = () => {
        const categoryId = Number(categorySelectEl.value || 0);
        if (!categoryId) {
            return [];
        }
        const category = locationSource.find((item) => Number(item.id) === categoryId);
        if (!category) {
            return [];
        }
        const capacity = Number(category.capacity || 0);
        if (!capacity) {
            return [];
        }
        const taken = new Set();
        stallsSource.forEach((stall) => {
            if (Number(stall.categoryId) === categoryId && Number(stall.id) !== currentStallId) {
                taken.add(String(stall.location));
            }
        });
        const list = [];
        Array.from({ length: capacity }, (_, index) => {
            const code = String(index + 1).padStart(2, '0');
            const value = category.name + '区-' + code;
            if (!taken.has(value)) {
                list.push({ value: value, label: category.name + '区 · ' + code + '号' });
            }
        });
        if (existingLocation && !list.some((item) => item.value === existingLocation)) {
            list.unshift({ value: existingLocation, label: existingLocation });
        }
        return list;
    };

    const filterLocations = () => {
        const keyword = currentKeyword.trim().toLowerCase();
        const allLocations = getAvailableLocations();
        if (!keyword) {
            return allLocations;
        }
        return allLocations.filter((item) => item.label.toLowerCase().includes(keyword) || item.value.toLowerCase().includes(keyword));
    };

    const renderLocations = () => {
        const list = filterLocations();
        const totalPages = Math.max(1, Math.ceil(list.length / pageSize));
        currentPage = Math.min(currentPage, totalPages);
        const start = (currentPage - 1) * pageSize;
        const items = list.slice(start, start + pageSize);

        locationListEl.innerHTML = '';
        if (!categorySelectEl.value) {
            const empty = document.createElement('div');
            empty.className = 'text-muted small';
            empty.textContent = '请选择品类后查看位置';
            locationListEl.appendChild(empty);
            locationPrevEl.disabled = true;
            locationNextEl.disabled = true;
            locationPageInfoEl.textContent = '未选择品类';
            locationSearchEl.disabled = true;
            return;
        }
        locationSearchEl.disabled = false;
        if (items.length === 0) {
            const empty = document.createElement('div');
            empty.className = 'text-muted small';
            empty.textContent = categorySelectEl.value ? '该区域已无剩余位置' : '没有匹配的位置';
            locationListEl.appendChild(empty);
        } else {
            items.forEach((item) => {
                const button = document.createElement('button');
                button.type = 'button';
                button.className = 'list-group-item list-group-item-action fc-location-item' + (locationInputEl.value === item.value ? ' active' : '');
                button.textContent = item.label;
                button.addEventListener('click', () => {
                    locationInputEl.value = item.value;
                    renderLocations();
                });
                locationListEl.appendChild(button);
            });
        }

        locationPrevEl.disabled = currentPage <= 1;
        locationNextEl.disabled = currentPage >= totalPages;
        locationPageInfoEl.textContent = '第 ' + currentPage + ' / ' + totalPages + ' 页';
    };

    locationSearchEl.addEventListener('input', (event) => {
        currentKeyword = event.target.value;
        currentPage = 1;
        renderLocations();
    });

    categorySelectEl.addEventListener('change', () => {
        currentKeyword = '';
        currentPage = 1;
        locationSearchEl.value = '';
        const availableValues = getAvailableLocations().map((item) => item.value);
        if (locationInputEl.value && !availableValues.includes(locationInputEl.value)) {
            locationInputEl.value = '';
        }
        renderLocations();
    });

    locationPrevEl.addEventListener('click', () => {
        if (currentPage > 1) {
            currentPage -= 1;
            renderLocations();
        }
    });

    locationNextEl.addEventListener('click', () => {
        currentPage += 1;
        renderLocations();
    });

    const backgroundInputEl = document.getElementById('backgroundImage');
    const backgroundFileEl = document.getElementById('backgroundFile');
    const backgroundPreviewEl = document.getElementById('backgroundPreview');
    const backgroundPlaceholderEl = document.getElementById('backgroundPlaceholder');
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

    const updatePreview = (url) => {
        if (url) {
            backgroundPreviewEl.src = url;
            backgroundPreviewEl.style.display = 'block';
            backgroundPlaceholderEl.style.display = 'none';
        } else {
            backgroundPreviewEl.removeAttribute('src');
            backgroundPreviewEl.style.display = 'none';
            backgroundPlaceholderEl.style.display = 'flex';
        }
    };

    const initialImageUrl = extractImageUrl(stallBackgroundUrlRawEl ? stallBackgroundUrlRawEl.value : '')
        || extractImageUrl(stallImagesRawEl ? stallImagesRawEl.value : '');
    if (initialImageUrl) {
        backgroundInputEl.value = initialImageUrl;
    }
    updatePreview(backgroundInputEl.value.trim());

    backgroundInputEl.addEventListener('input', (event) => {
        updatePreview(event.target.value.trim());
    });

    if (backgroundFileEl) {
        backgroundFileEl.addEventListener('change', () => {
            if (backgroundFileEl.files && backgroundFileEl.files.length > 0) {
                const fileUrl = URL.createObjectURL(backgroundFileEl.files[0]);
                backgroundInputEl.value = '';
                updatePreview(fileUrl);
            }
        });
    }

    renderLocations();
</script>
</body>
</html>
