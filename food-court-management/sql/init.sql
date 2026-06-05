-- 创建数据库
CREATE DATABASE IF NOT EXISTS food_court_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE food_court_db;

-- 用户表 (users)
CREATE TABLE IF NOT EXISTS users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(20) UNIQUE,
    role_type ENUM('ADMIN', 'OWNER', 'DINER') NOT NULL,
    status ENUM('ACTIVE', 'INACTIVE', 'PENDING') DEFAULT 'PENDING',
    avatar_url VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_username (username),
    INDEX idx_email (email),
    INDEX idx_phone (phone)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 角色权限表 (roles)
CREATE TABLE IF NOT EXISTS roles (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    role_name VARCHAR(50) NOT NULL,
    permissions TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_user_id (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 品类表 (categories)
CREATE TABLE IF NOT EXISTS categories (
    id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(50) UNIQUE NOT NULL,
    description TEXT,
    sort_order INT DEFAULT 0,
    icon_url VARCHAR(255),
    region_capacity INT DEFAULT 20,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_sort_order (sort_order)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 摊位表 (stalls)
CREATE TABLE IF NOT EXISTS stalls (
    id INT PRIMARY KEY AUTO_INCREMENT,
    stall_name VARCHAR(100) NOT NULL,
    location VARCHAR(200) NOT NULL,
    status ENUM('OPEN', 'CLOSED', 'MAINTENANCE', 'RENTED') DEFAULT 'CLOSED',
    owner_id INT,
    category_id INT,
    description TEXT,
    background_image_url VARCHAR(255),
    rent_fee DECIMAL(10,2) DEFAULT 0.00,
    images JSON,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (owner_id) REFERENCES users(id) ON DELETE SET NULL,
    FOREIGN KEY (category_id) REFERENCES categories(id),
    INDEX idx_owner_id (owner_id),
    INDEX idx_category_id (category_id),
    INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS leases (
    id INT PRIMARY KEY AUTO_INCREMENT,
    stall_id INT,
    owner_id INT NOT NULL,
    type ENUM('NEW', 'RENEWAL') NOT NULL,
    status ENUM('PENDING', 'APPROVED', 'REJECTED', 'ACTIVE', 'EXPIRED', 'TERMINATED') DEFAULT 'PENDING',
    start_date TIMESTAMP NOT NULL,
    end_date TIMESTAMP NOT NULL,
    contract_content LONGTEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (stall_id) REFERENCES stalls(id) ON DELETE SET NULL,
    FOREIGN KEY (owner_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_owner_id (owner_id),
    INDEX idx_stall_id (stall_id),
    INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 商品表 (products)
CREATE TABLE IF NOT EXISTS products (
    id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(100) NOT NULL,
    stall_id INT NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    description TEXT,
    image_url VARCHAR(255),
    status ENUM('AVAILABLE', 'UNAVAILABLE') DEFAULT 'AVAILABLE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (stall_id) REFERENCES stalls(id) ON DELETE CASCADE,
    INDEX idx_stall_id (stall_id),
    INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 订单表 (orders)
CREATE TABLE IF NOT EXISTS orders (
    id INT PRIMARY KEY AUTO_INCREMENT,
    order_number VARCHAR(32) UNIQUE NOT NULL,
    pickup_number VARCHAR(32),
    user_id INT NOT NULL,
    stall_id INT NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL,
    status ENUM('PENDING', 'CONFIRMED', 'PREPARING', 'COMPLETED', 'CANCELLED') DEFAULT 'PENDING',
    payment_status ENUM('UNPAID', 'PAID', 'REFUNDED') DEFAULT 'UNPAID',
    payment_method VARCHAR(50),
    notes TEXT,
    order_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    completion_time TIMESTAMP NULL,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (stall_id) REFERENCES stalls(id) ON DELETE CASCADE,
    INDEX idx_order_number (order_number),
    INDEX idx_pickup_number (pickup_number),
    INDEX idx_user_id (user_id),
    INDEX idx_stall_id (stall_id),
    INDEX idx_status (status),
    INDEX idx_order_time (order_time)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS order_number_sequences (
    date_key DATE PRIMARY KEY,
    current_seq INT NOT NULL,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS pickup_number_sequences (
    date_key DATE PRIMARY KEY,
    current_seq INT NOT NULL,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 订单明细表 (order_items)
CREATE TABLE IF NOT EXISTS order_items (
    id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    unit_price DECIMAL(10,2) NOT NULL,
    subtotal DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
    INDEX idx_order_id (order_id),
    INDEX idx_product_id (product_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 评价表 (reviews)
CREATE TABLE IF NOT EXISTS reviews (
    id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    user_id INT NOT NULL,
    stall_id INT NOT NULL,
    rating TINYINT CHECK (rating >= 1 AND rating <= 5),
    comment TEXT,
    reply TEXT,
    review_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    reply_time TIMESTAMP NULL,
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (stall_id) REFERENCES stalls(id) ON DELETE CASCADE,
    INDEX idx_order_id (order_id),
    INDEX idx_user_id (user_id),
    INDEX idx_stall_id (stall_id),
    INDEX idx_rating (rating)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 投诉表 (complaints)
CREATE TABLE IF NOT EXISTS complaints (
    id INT PRIMARY KEY AUTO_INCREMENT,
    complaint_number VARCHAR(32) UNIQUE NOT NULL,
    complainant_id INT NOT NULL,
    respondent_id INT,
    order_id INT,
    complaint_type ENUM('SERVICE', 'QUALITY', 'HYGIENE', 'OTHER') NOT NULL,
    content TEXT NOT NULL,
    evidence_url VARCHAR(255),
    status ENUM('PENDING', 'PROCESSING', 'RESOLVED', 'CLOSED') DEFAULT 'PENDING',
    resolution TEXT,
    complaint_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    resolution_time TIMESTAMP NULL,
    FOREIGN KEY (complainant_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (respondent_id) REFERENCES users(id) ON DELETE SET NULL,
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE SET NULL,
    INDEX idx_complaint_number (complaint_number),
    INDEX idx_complainant_id (complainant_id),
    INDEX idx_status (status),
    INDEX idx_complaint_time (complaint_time)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 合同表 (contracts)
CREATE TABLE IF NOT EXISTS contracts (
    id INT PRIMARY KEY AUTO_INCREMENT,
    contract_number VARCHAR(32) UNIQUE NOT NULL,
    stall_id INT NOT NULL,
    owner_id INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    rent_amount DECIMAL(10,2) NOT NULL,
    deposit_amount DECIMAL(10,2) DEFAULT 0.00,
    contract_url VARCHAR(255),
    status ENUM('DRAFT', 'SIGNED', 'EXPIRED', 'TERMINATED') DEFAULT 'DRAFT',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    signed_at TIMESTAMP NULL,
    FOREIGN KEY (stall_id) REFERENCES stalls(id) ON DELETE CASCADE,
    FOREIGN KEY (owner_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_contract_number (contract_number),
    INDEX idx_stall_id (stall_id),
    INDEX idx_owner_id (owner_id),
    INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 操作日志表 (operation_logs)
CREATE TABLE IF NOT EXISTS operation_logs (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    operation_type VARCHAR(50) NOT NULL,
    operation_desc TEXT,
    request_url VARCHAR(255),
    request_method VARCHAR(10),
    request_params TEXT,
    response_result TEXT,
    ip_address VARCHAR(45),
    user_agent TEXT,
    operation_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL,
    INDEX idx_user_id (user_id),
    INDEX idx_operation_type (operation_type),
    INDEX idx_operation_time (operation_time)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 插入默认管理员账户 (password: admin123)
-- 注意：这里使用明文作为演示，实际应用中应存储哈希值
INSERT INTO users (username, password_hash, email, phone, role_type, status) 
VALUES ('admin', 'admin123', 'admin@foodcourt.com', '13800138000', 'ADMIN', 'ACTIVE');

-- 插入默认品类数据
INSERT INTO categories (category_name, description, sort_order, region_capacity) VALUES
('中式快餐', '传统中式美食', 1, 24),
('西式快餐', '汉堡、披萨等西式美食', 2, 18),
('日韩料理', '日本、韩国特色美食', 3, 16),
('甜品饮品', '各类甜品和饮品', 4, 14),
('小吃烧烤', '地方特色小吃和烧烤', 5, 20),
('健康轻食', '低卡路里健康餐食', 6, 12);

INSERT INTO users (username, password_hash, email, phone, role_type, status) VALUES
('owner_li', 'owner123', 'owner1@foodcourt.com', '13900000001', 'OWNER', 'ACTIVE'),
('owner_zhang', 'owner123', 'owner2@foodcourt.com', '13900000002', 'OWNER', 'ACTIVE'),
('diner_xiao', 'diner123', 'diner1@foodcourt.com', '13700000001', 'DINER', 'ACTIVE'),
('diner_mei', 'diner123', 'diner2@foodcourt.com', '13700000002', 'DINER', 'ACTIVE');

INSERT INTO stalls (stall_name, location, status, owner_id, category_id, description, rent_fee, images) VALUES
('辣味研究所', 'A区-12号', 'OPEN', (SELECT id FROM users WHERE username='owner_li'), (SELECT id FROM categories WHERE category_name='小吃烧烤'), '川味街头小吃 | 排队必吃', 3200.00, '["https://images.unsplash.com/photo-1504674900247-0877df9cc836?auto=format&fit=crop&w=900&q=80"]'),
('炭火串串屋', 'A区-08号', 'OPEN', (SELECT id FROM users WHERE username='owner_li'), (SELECT id FROM categories WHERE category_name='小吃烧烤'), '精选肉串 | 香气扑鼻', 2800.00, '["https://images.unsplash.com/photo-1498654896293-37aacf113fd9?auto=format&fit=crop&w=900&q=80"]'),
('暖心甜品铺', 'B区-03号', 'OPEN', (SELECT id FROM users WHERE username='owner_zhang'), (SELECT id FROM categories WHERE category_name='甜品饮品'), '手作甜品 | 低糖轻负担', 2600.00, '["https://images.unsplash.com/photo-1512058564366-18510be2db19?auto=format&fit=crop&w=900&q=80"]'),
('招牌牛杂面', 'C区-05号', 'OPEN', (SELECT id FROM users WHERE username='owner_zhang'), (SELECT id FROM categories WHERE category_name='中式快餐'), '浓汤熬制 | 深夜食堂', 3000.00, '["https://images.unsplash.com/photo-1504674900247-0877df9cc836?auto=format&fit=crop&w=900&q=80"]');

INSERT INTO products (product_name, stall_id, price, description, image_url, status) VALUES
('炙火烤肉拼盘', (SELECT id FROM stalls WHERE stall_name='辣味研究所'), 38.00, '浓郁炭香 + 特制蘸料', 'https://images.unsplash.com/photo-1504674900247-0877df9cc836?auto=format&fit=crop&w=900&q=80', 'AVAILABLE'),
('香辣烤鸡翅', (SELECT id FROM stalls WHERE stall_name='辣味研究所'), 22.00, '酥脆外皮 + 辣度可选', 'https://images.unsplash.com/photo-1482049016688-2d3e1b311543?auto=format&fit=crop&w=900&q=80', 'AVAILABLE'),
('深夜海鲜捞', (SELECT id FROM stalls WHERE stall_name='炭火串串屋'), 48.00, '鲜香浓郁，搭配多重口味选择', 'https://images.unsplash.com/photo-1473093295043-cdd812d0e601?auto=format&fit=crop&w=900&q=80', 'AVAILABLE'),
('秘制牛肉串', (SELECT id FROM stalls WHERE stall_name='炭火串串屋'), 16.00, '精选肉串 | 香气扑鼻', 'https://images.unsplash.com/photo-1526318896980-cf78c088247c?auto=format&fit=crop&w=900&q=80', 'AVAILABLE'),
('轻乳酪芝士杯', (SELECT id FROM stalls WHERE stall_name='暖心甜品铺'), 18.00, '细腻绵密，低糖轻负担', 'https://images.unsplash.com/photo-1488477181946-6428a0291777?auto=format&fit=crop&w=900&q=80', 'AVAILABLE'),
('抹茶奶盖', (SELECT id FROM stalls WHERE stall_name='暖心甜品铺'), 15.00, '茶香浓郁，回甘清爽', 'https://images.unsplash.com/photo-1543353071-873f17a7a088?auto=format&fit=crop&w=900&q=80', 'AVAILABLE'),
('招牌牛杂面', (SELECT id FROM stalls WHERE stall_name='招牌牛杂面'), 26.00, '浓汤熬制 | 深夜食堂', 'https://images.unsplash.com/photo-1504674900247-0877df9cc836?auto=format&fit=crop&w=900&q=80', 'AVAILABLE'),
('秘制酸辣粉', (SELECT id FROM stalls WHERE stall_name='招牌牛杂面'), 20.00, '酸辣开胃 | 现煮现吃', 'https://images.unsplash.com/photo-1504674900247-0877df9cc836?auto=format&fit=crop&w=900&q=80', 'AVAILABLE');
