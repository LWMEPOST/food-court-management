-- Additional Users (Owners)
INSERT IGNORE INTO users (username, password_hash, email, phone, role_type, status) VALUES
('owner_wang', 'owner123', 'owner_wang@foodcourt.com', '13900000011', 'OWNER', 'ACTIVE'),
('owner_zhao', 'owner123', 'owner_zhao@foodcourt.com', '13900000012', 'OWNER', 'ACTIVE'),
('owner_chen', 'owner123', 'owner_chen@foodcourt.com', '13900000013', 'OWNER', 'ACTIVE'),
('owner_liu', 'owner123', 'owner_liu@foodcourt.com', '13900000014', 'OWNER', 'ACTIVE');

-- Additional Users (Diners)
INSERT IGNORE INTO users (username, password_hash, email, phone, role_type, status) VALUES
('diner_01', 'diner123', 'diner01@fc.com', '13700000011', 'DINER', 'ACTIVE'),
('diner_02', 'diner123', 'diner02@fc.com', '13700000012', 'DINER', 'ACTIVE'),
('diner_03', 'diner123', 'diner03@fc.com', '13700000013', 'DINER', 'ACTIVE'),
('diner_04', 'diner123', 'diner04@fc.com', '13700000014', 'DINER', 'ACTIVE'),
('diner_05', 'diner123', 'diner05@fc.com', '13700000015', 'DINER', 'ACTIVE'),
('diner_06', 'diner123', 'diner06@fc.com', '13700000016', 'DINER', 'ACTIVE'),
('diner_07', 'diner123', 'diner07@fc.com', '13700000017', 'DINER', 'ACTIVE'),
('diner_08', 'diner123', 'diner08@fc.com', '13700000018', 'DINER', 'ACTIVE'),
('diner_09', 'diner123', 'diner09@fc.com', '13700000019', 'DINER', 'ACTIVE'),
('diner_10', 'diner123', 'diner10@fc.com', '13700000020', 'DINER', 'ACTIVE');

-- Additional Stalls (Total 12 new to reach 16)
INSERT INTO stalls (stall_name, location, status, owner_id, category_id, description, rent_fee, images) VALUES
('脆皮汉堡屋', 'A区-15号', 'OPEN', (SELECT id FROM users WHERE username='owner_wang'), (SELECT id FROM categories WHERE category_name='西式快餐'), '正宗美式汉堡', 3500.00, '["https://images.unsplash.com/photo-1568901346375-23c9450c58cd?auto=format&fit=crop&w=800&q=80"]'),
('披萨天堂', 'A区-16号', 'OPEN', (SELECT id FROM users WHERE username='owner_wang'), (SELECT id FROM categories WHERE category_name='西式快餐'), '意式手工披萨', 3600.00, '["https://images.unsplash.com/photo-1513104890138-7c749659a591?auto=format&fit=crop&w=800&q=80"]'),
('樱花寿司', 'B区-05号', 'OPEN', (SELECT id FROM users WHERE username='owner_zhao'), (SELECT id FROM categories WHERE category_name='日韩料理'), '新鲜现做寿司', 4000.00, '["https://images.unsplash.com/photo-1579871494447-9811cf80d66c?auto=format&fit=crop&w=800&q=80"]'),
('泡菜小屋', 'B区-06号', 'OPEN', (SELECT id FROM users WHERE username='owner_zhao'), (SELECT id FROM categories WHERE category_name='日韩料理'), '韩式泡菜锅与石锅拌饭', 3800.00, '["https://images.unsplash.com/photo-1580651315530-69c8e0026377?auto=format&fit=crop&w=800&q=80"]'),
('老北京炸酱面馆', 'C区-08号', 'OPEN', (SELECT id FROM users WHERE username='owner_chen'), (SELECT id FROM categories WHERE category_name='中式快餐'), '老北京炸酱面', 3000.00, '["https://images.unsplash.com/photo-1552611052-33e04de081de?auto=format&fit=crop&w=800&q=80"]'),
('川味麻辣香锅', 'C区-09号', 'OPEN', (SELECT id FROM users WHERE username='owner_chen'), (SELECT id FROM categories WHERE category_name='中式快餐'), '正宗川味麻辣香锅', 3200.00, '["https://images.unsplash.com/photo-1563245372-f21724e3856d?auto=format&fit=crop&w=800&q=80"]'),
('鲜果汁吧', 'D区-01号', 'OPEN', (SELECT id FROM users WHERE username='owner_liu'), (SELECT id FROM categories WHERE category_name='甜品饮品'), '鲜榨果汁与奶昔', 2500.00, '["https://images.unsplash.com/photo-1603569283847-aa295f0d016a?auto=format&fit=crop&w=800&q=80"]'),
('奶茶世界', 'D区-02号', 'OPEN', (SELECT id FROM users WHERE username='owner_liu'), (SELECT id FROM categories WHERE category_name='甜品饮品'), '网红珍珠奶茶', 2800.00, '["https://images.unsplash.com/photo-1558857563-b31cf1d65052?auto=format&fit=crop&w=800&q=80"]'),
('健康沙拉碗', 'E区-01号', 'OPEN', (SELECT id FROM users WHERE username='owner_wang'), (SELECT id FROM categories WHERE category_name='健康轻食'), '低脂鸡胸肉沙拉', 2400.00, '["https://images.unsplash.com/photo-1512621776951-a57141f2eefd?auto=format&fit=crop&w=800&q=80"]'),
('素食悦享', 'E区-02号', 'OPEN', (SELECT id FROM users WHERE username='owner_wang'), (SELECT id FROM categories WHERE category_name='健康轻食'), '素食主义者的天堂', 2300.00, '["https://images.unsplash.com/photo-1511690656952-34342d5c2899?auto=format&fit=crop&w=800&q=80"]'),
('深夜烧烤', 'A区-20号', 'OPEN', (SELECT id FROM users WHERE username='owner_li'), (SELECT id FROM categories WHERE category_name='小吃烧烤'), '深夜撸串好去处', 3100.00, '["https://images.unsplash.com/photo-1529193591184-b1d580690dd0?auto=format&fit=crop&w=800&q=80"]'),
('粤式点心楼', 'C区-12号', 'OPEN', (SELECT id FROM users WHERE username='owner_chen'), (SELECT id FROM categories WHERE category_name='中式快餐'), '广式早茶点心', 3300.00, '["https://images.unsplash.com/photo-1496116218417-1a781b1c423c?auto=format&fit=crop&w=800&q=80"]');

-- Additional Products
INSERT INTO products (product_name, stall_id, price, description, image_url, status) VALUES
('经典牛肉汉堡', (SELECT id FROM stalls WHERE stall_name='脆皮汉堡屋'), 45.00, '多汁牛肉饼', 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd', 'AVAILABLE'),
('意式腊肠披萨', (SELECT id FROM stalls WHERE stall_name='披萨天堂'), 55.00, '经典风味', 'https://images.unsplash.com/photo-1513104890138-7c749659a591', 'AVAILABLE'),
('三文鱼刺身', (SELECT id FROM stalls WHERE stall_name='樱花寿司'), 68.00, '新鲜三文鱼', 'https://images.unsplash.com/photo-1579871494447-9811cf80d66c', 'AVAILABLE'),
('韩式石锅拌饭', (SELECT id FROM stalls WHERE stall_name='泡菜小屋'), 38.00, '蔬菜拌饭', 'https://images.unsplash.com/photo-1580651315530-69c8e0026377', 'AVAILABLE'),
('老北京炸酱面', (SELECT id FROM stalls WHERE stall_name='老北京炸酱面馆'), 22.00, '传统酱香', 'https://images.unsplash.com/photo-1552611052-33e04de081de', 'AVAILABLE'),
('麻辣香锅套餐', (SELECT id FROM stalls WHERE stall_name='川味麻辣香锅'), 58.00, '荤素搭配', 'https://images.unsplash.com/photo-1563245372-f21724e3856d', 'AVAILABLE'),
('鲜榨橙汁', (SELECT id FROM stalls WHERE stall_name='鲜果汁吧'), 18.00, '现榨果汁', 'https://images.unsplash.com/photo-1603569283847-aa295f0d016a', 'AVAILABLE'),
('黑糖珍珠奶茶', (SELECT id FROM stalls WHERE stall_name='奶茶世界'), 22.00, '香甜Q弹', 'https://images.unsplash.com/photo-1558857563-b31cf1d65052', 'AVAILABLE'),
('鸡肉凯撒沙拉', (SELECT id FROM stalls WHERE stall_name='健康沙拉碗'), 35.00, '健康首选', 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd', 'AVAILABLE'),
('牛油果吐司', (SELECT id FROM stalls WHERE stall_name='素食悦享'), 28.00, '绵密口感', 'https://images.unsplash.com/photo-1511690656952-34342d5c2899', 'AVAILABLE'),
('羊肉串', (SELECT id FROM stalls WHERE stall_name='深夜烧烤'), 6.00, '香辣入味', 'https://images.unsplash.com/photo-1529193591184-b1d580690dd0', 'AVAILABLE'),
('水晶虾饺', (SELECT id FROM stalls WHERE stall_name='粤式点心楼'), 26.00, '现蒸美味', 'https://images.unsplash.com/photo-1496116218417-1a781b1c423c', 'AVAILABLE');

-- Mock Orders
INSERT INTO orders (order_number, user_id, stall_id, total_amount, status, payment_status, payment_method, notes) VALUES
('ORD001', (SELECT id FROM users WHERE username='diner_01'), (SELECT id FROM stalls WHERE stall_name='脆皮汉堡屋'), 45.00, 'COMPLETED', 'PAID', '微信支付', '不要洋葱'),
('ORD002', (SELECT id FROM users WHERE username='diner_02'), (SELECT id FROM stalls WHERE stall_name='披萨天堂'), 55.00, 'COMPLETED', 'PAID', '支付宝', ''),
('ORD003', (SELECT id FROM users WHERE username='diner_03'), (SELECT id FROM stalls WHERE stall_name='樱花寿司'), 68.00, 'COMPLETED', 'PAID', '微信支付', ''),
('ORD004', (SELECT id FROM users WHERE username='diner_04'), (SELECT id FROM stalls WHERE stall_name='泡菜小屋'), 38.00, 'COMPLETED', 'PAID', '微信支付', ''),
('ORD005', (SELECT id FROM users WHERE username='diner_05'), (SELECT id FROM stalls WHERE stall_name='脆皮汉堡屋'), 90.00, 'COMPLETED', 'PAID', '微信支付', '双份订单'),
('ORD006', (SELECT id FROM users WHERE username='diner_06'), (SELECT id FROM stalls WHERE stall_name='樱花寿司'), 136.00, 'COMPLETED', 'PAID', '支付宝', '家庭装'),
('ORD007', (SELECT id FROM users WHERE username='diner_07'), (SELECT id FROM stalls WHERE stall_name='奶茶世界'), 22.00, 'COMPLETED', 'PAID', '微信支付', ''),
('ORD008', (SELECT id FROM users WHERE username='diner_08'), (SELECT id FROM stalls WHERE stall_name='奶茶世界'), 44.00, 'COMPLETED', 'PAID', '微信支付', '两杯'),
('ORD009', (SELECT id FROM users WHERE username='diner_09'), (SELECT id FROM stalls WHERE stall_name='奶茶世界'), 22.00, 'COMPLETED', 'PAID', '微信支付', ''),
('ORD010', (SELECT id FROM users WHERE username='diner_10'), (SELECT id FROM stalls WHERE stall_name='川味麻辣香锅'), 58.00, 'COMPLETED', 'PAID', '微信支付', '中辣');
