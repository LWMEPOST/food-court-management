/*
Navicat MySQL Data Transfer

Source Server         : localhost_3306
Source Server Version : 80044
Source Host           : localhost:3306
Source Database       : food_court_db

Target Server Type    : MYSQL
Target Server Version : 80044
File Encoding         : 65001

Date: 2026-01-31 11:46:14
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for categories
-- ----------------------------
DROP TABLE IF EXISTS `categories`;
CREATE TABLE `categories` (
  `id` int NOT NULL AUTO_INCREMENT,
  `category_name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `sort_order` int DEFAULT '0',
  `icon_url` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `region_capacity` int DEFAULT '20',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `category_name` (`category_name`),
  KEY `idx_sort_order` (`sort_order`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Records of categories
-- ----------------------------
INSERT INTO `categories` VALUES ('1', '中式快餐', '传统中式美食', '1', null, '24', '2026-01-30 21:54:32');
INSERT INTO `categories` VALUES ('2', '西式快餐', '汉堡、披萨等西式美食', '2', null, '18', '2026-01-30 21:54:32');
INSERT INTO `categories` VALUES ('3', '日韩料理', '日本、韩国特色美食', '3', null, '16', '2026-01-30 21:54:32');
INSERT INTO `categories` VALUES ('4', '甜品饮品', '各类甜品和饮品', '4', null, '14', '2026-01-30 21:54:32');
INSERT INTO `categories` VALUES ('5', '小吃烧烤', '地方特色小吃和烧烤', '5', null, '20', '2026-01-30 21:54:32');
INSERT INTO `categories` VALUES ('6', '健康轻食', '低卡路里健康餐食', '6', null, '12', '2026-01-30 21:54:32');

-- ----------------------------
-- Table structure for complaints
-- ----------------------------
DROP TABLE IF EXISTS `complaints`;
CREATE TABLE `complaints` (
  `id` int NOT NULL AUTO_INCREMENT,
  `complaint_number` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `complainant_id` int NOT NULL,
  `respondent_id` int DEFAULT NULL,
  `order_id` int DEFAULT NULL,
  `complaint_type` enum('SERVICE','QUALITY','HYGIENE','OTHER') COLLATE utf8mb4_unicode_ci NOT NULL,
  `content` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `evidence_url` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` enum('PENDING','PROCESSING','RESOLVED','CLOSED') COLLATE utf8mb4_unicode_ci DEFAULT 'PENDING',
  `resolution` text COLLATE utf8mb4_unicode_ci,
  `complaint_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `resolution_time` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `complaint_number` (`complaint_number`),
  KEY `respondent_id` (`respondent_id`),
  KEY `order_id` (`order_id`),
  KEY `idx_complaint_number` (`complaint_number`),
  KEY `idx_complainant_id` (`complainant_id`),
  KEY `idx_status` (`status`),
  KEY `idx_complaint_time` (`complaint_time`),
  CONSTRAINT `complaints_ibfk_1` FOREIGN KEY (`complainant_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `complaints_ibfk_2` FOREIGN KEY (`respondent_id`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  CONSTRAINT `complaints_ibfk_3` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Records of complaints
-- ----------------------------

-- ----------------------------
-- Table structure for contracts
-- ----------------------------
DROP TABLE IF EXISTS `contracts`;
CREATE TABLE `contracts` (
  `id` int NOT NULL AUTO_INCREMENT,
  `contract_number` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `stall_id` int NOT NULL,
  `owner_id` int NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `rent_amount` decimal(10,2) NOT NULL,
  `deposit_amount` decimal(10,2) DEFAULT '0.00',
  `contract_url` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` enum('DRAFT','SIGNED','EXPIRED','TERMINATED') COLLATE utf8mb4_unicode_ci DEFAULT 'DRAFT',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `signed_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `contract_number` (`contract_number`),
  KEY `idx_contract_number` (`contract_number`),
  KEY `idx_stall_id` (`stall_id`),
  KEY `idx_owner_id` (`owner_id`),
  KEY `idx_status` (`status`),
  CONSTRAINT `contracts_ibfk_1` FOREIGN KEY (`stall_id`) REFERENCES `stalls` (`id`) ON DELETE CASCADE,
  CONSTRAINT `contracts_ibfk_2` FOREIGN KEY (`owner_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Records of contracts
-- ----------------------------

-- ----------------------------
-- Table structure for leases
-- ----------------------------
DROP TABLE IF EXISTS `leases`;
CREATE TABLE `leases` (
  `id` int NOT NULL AUTO_INCREMENT,
  `stall_id` int DEFAULT NULL,
  `owner_id` int NOT NULL,
  `type` enum('NEW','RENEWAL') COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` enum('PENDING','APPROVED','REJECTED','ACTIVE','EXPIRED','TERMINATED') COLLATE utf8mb4_unicode_ci DEFAULT 'PENDING',
  `start_date` timestamp NOT NULL,
  `end_date` timestamp NOT NULL,
  `contract_content` longtext COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_owner_id` (`owner_id`),
  KEY `idx_stall_id` (`stall_id`),
  KEY `idx_status` (`status`),
  CONSTRAINT `leases_ibfk_1` FOREIGN KEY (`stall_id`) REFERENCES `stalls` (`id`) ON DELETE SET NULL,
  CONSTRAINT `leases_ibfk_2` FOREIGN KEY (`owner_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Records of leases
-- ----------------------------
INSERT INTO `leases` VALUES ('1', '15', '2', 'RENEWAL', 'APPROVED', '2026-01-29 16:00:00', '2027-01-29 16:00:00', '美食街摊位租赁合同\n\n合同编号：LEASE-1\n甲方：美食街管理方\n乙方（摊主）：owner_li\n\n根据相关法律法规，甲乙双方经友好协商，达成如下协议：\n1. 租赁标的：摊位ID 15\n2. 租赁期限：自 2026-01-30 起至 2027-01-30 止。\n3. 租金支付：乙方应按时缴纳租金及管理费。\n4. 经营规范：乙方需遵守美食街各项管理规定。\n\n甲方盖章：[电子章]\n乙方签字：[电子签名]\n日期：2026-01-30', '2026-01-30 22:23:59', '2026-01-30 22:24:17');

-- ----------------------------
-- Table structure for operation_logs
-- ----------------------------
DROP TABLE IF EXISTS `operation_logs`;
CREATE TABLE `operation_logs` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int DEFAULT NULL,
  `operation_type` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `operation_desc` text COLLATE utf8mb4_unicode_ci,
  `request_url` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `request_method` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `request_params` text COLLATE utf8mb4_unicode_ci,
  `response_result` text COLLATE utf8mb4_unicode_ci,
  `ip_address` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_agent` text COLLATE utf8mb4_unicode_ci,
  `operation_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_operation_type` (`operation_type`),
  KEY `idx_operation_time` (`operation_time`),
  CONSTRAINT `operation_logs_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Records of operation_logs
-- ----------------------------

-- ----------------------------
-- Table structure for orders
-- ----------------------------
DROP TABLE IF EXISTS `orders`;
CREATE TABLE `orders` (
  `id` int NOT NULL AUTO_INCREMENT,
  `order_number` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `pickup_number` varchar(32) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_id` int NOT NULL,
  `stall_id` int NOT NULL,
  `total_amount` decimal(10,2) NOT NULL,
  `status` enum('PENDING','CONFIRMED','PREPARING','COMPLETED','CANCELLED') COLLATE utf8mb4_unicode_ci DEFAULT 'PENDING',
  `payment_status` enum('UNPAID','PAID','REFUNDED') COLLATE utf8mb4_unicode_ci DEFAULT 'UNPAID',
  `payment_method` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `notes` text COLLATE utf8mb4_unicode_ci,
  `order_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `completion_time` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `order_number` (`order_number`),
  KEY `idx_order_number` (`order_number`),
  KEY `idx_pickup_number` (`pickup_number`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_stall_id` (`stall_id`),
  KEY `idx_status` (`status`),
  KEY `idx_order_time` (`order_time`),
  CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `orders_ibfk_2` FOREIGN KEY (`stall_id`) REFERENCES `stalls` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Records of orders
-- ----------------------------
INSERT INTO `orders` VALUES ('1', 'ORD001', null, '10', '5', '45.00', 'COMPLETED', 'PAID', '微信支付', '不要洋葱', '2026-01-30 21:55:25', null);
INSERT INTO `orders` VALUES ('2', 'ORD002', null, '11', '6', '55.00', 'COMPLETED', 'PAID', '支付宝', '', '2026-01-30 21:55:25', null);
INSERT INTO `orders` VALUES ('3', 'ORD003', null, '12', '7', '68.00', 'COMPLETED', 'PAID', '微信支付', '', '2026-01-30 21:55:25', null);
INSERT INTO `orders` VALUES ('4', 'ORD004', null, '13', '8', '38.00', 'COMPLETED', 'PAID', '微信支付', '', '2026-01-30 21:55:25', null);
INSERT INTO `orders` VALUES ('5', 'ORD005', null, '14', '5', '90.00', 'COMPLETED', 'PAID', '微信支付', '双份订单', '2026-01-30 21:55:25', null);
INSERT INTO `orders` VALUES ('6', 'ORD006', null, '15', '7', '136.00', 'COMPLETED', 'PAID', '支付宝', '家庭装', '2026-01-30 21:55:25', null);
INSERT INTO `orders` VALUES ('7', 'ORD007', null, '16', '12', '22.00', 'COMPLETED', 'PAID', '微信支付', '', '2026-01-30 21:55:25', null);
INSERT INTO `orders` VALUES ('8', 'ORD008', null, '17', '12', '44.00', 'COMPLETED', 'PAID', '微信支付', '两杯', '2026-01-30 21:55:25', null);
INSERT INTO `orders` VALUES ('9', 'ORD009', null, '18', '12', '22.00', 'COMPLETED', 'PAID', '微信支付', '', '2026-01-30 21:55:25', null);
INSERT INTO `orders` VALUES ('10', 'ORD010', null, '19', '10', '58.00', 'COMPLETED', 'PAID', '微信支付', '中辣', '2026-01-30 21:55:25', null);
INSERT INTO `orders` VALUES ('11', 'TMPCD71585076284D598475', null, '20', '5', '90.00', 'COMPLETED', 'PAID', '微信支付', null, '2026-01-30 21:57:02', null);
INSERT INTO `orders` VALUES ('12', 'TMP8AA5238921634FBF8E86', null, '20', '5', '125.00', 'COMPLETED', 'PAID', '微信支付', '使用优惠券: FC10', '2026-01-30 22:02:29', null);
INSERT INTO `orders` VALUES ('13', 'TMPA7A32D703AB9438C8230', null, '20', '5', '35.00', 'COMPLETED', 'PAID', '微信支付', '使用优惠券: FC10', '2026-01-30 22:09:38', null);
INSERT INTO `orders` VALUES ('14', 'TMP75514334FB0144F791DD', null, '20', '15', '18.00', 'COMPLETED', 'PAID', '微信支付', null, '2026-01-30 22:12:14', null);
INSERT INTO `orders` VALUES ('15', 'TMP1F521F3BB9CE45EAA48E', 'P202601300001', '20', '5', '80.00', 'COMPLETED', 'PAID', '微信支付', '使用优惠券: FC10', '2026-01-30 22:14:37', null);

-- ----------------------------
-- Table structure for order_items
-- ----------------------------
DROP TABLE IF EXISTS `order_items`;
CREATE TABLE `order_items` (
  `id` int NOT NULL AUTO_INCREMENT,
  `order_id` int NOT NULL,
  `product_id` int NOT NULL,
  `quantity` int NOT NULL,
  `unit_price` decimal(10,2) NOT NULL,
  `subtotal` decimal(10,2) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_order_id` (`order_id`),
  KEY `idx_product_id` (`product_id`),
  CONSTRAINT `order_items_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE,
  CONSTRAINT `order_items_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE,
  CONSTRAINT `order_items_chk_1` CHECK ((`quantity` > 0))
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Records of order_items
-- ----------------------------
INSERT INTO `order_items` VALUES ('1', '11', '9', '2', '45.00', '90.00');
INSERT INTO `order_items` VALUES ('2', '12', '9', '3', '45.00', '135.00');
INSERT INTO `order_items` VALUES ('3', '13', '9', '1', '45.00', '45.00');
INSERT INTO `order_items` VALUES ('4', '14', '19', '3', '6.00', '18.00');
INSERT INTO `order_items` VALUES ('5', '15', '9', '2', '45.00', '90.00');

-- ----------------------------
-- Table structure for order_number_sequences
-- ----------------------------
DROP TABLE IF EXISTS `order_number_sequences`;
CREATE TABLE `order_number_sequences` (
  `date_key` date NOT NULL,
  `current_seq` int NOT NULL,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`date_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Records of order_number_sequences
-- ----------------------------

-- ----------------------------
-- Table structure for pickup_number_sequences
-- ----------------------------
DROP TABLE IF EXISTS `pickup_number_sequences`;
CREATE TABLE `pickup_number_sequences` (
  `date_key` date NOT NULL,
  `current_seq` int NOT NULL,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`date_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Records of pickup_number_sequences
-- ----------------------------
INSERT INTO `pickup_number_sequences` VALUES ('2026-01-30', '1', '2026-01-30 22:14:37');

-- ----------------------------
-- Table structure for products
-- ----------------------------
DROP TABLE IF EXISTS `products`;
CREATE TABLE `products` (
  `id` int NOT NULL AUTO_INCREMENT,
  `product_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `stall_id` int NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `image_url` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` enum('AVAILABLE','UNAVAILABLE') COLLATE utf8mb4_unicode_ci DEFAULT 'AVAILABLE',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_stall_id` (`stall_id`),
  KEY `idx_status` (`status`),
  CONSTRAINT `products_ibfk_1` FOREIGN KEY (`stall_id`) REFERENCES `stalls` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Records of products
-- ----------------------------
INSERT INTO `products` VALUES ('1', '炙火烤肉拼盘', '1', '38.00', '浓郁炭香 + 特制蘸料', 'https://images.unsplash.com/photo-1504674900247-0877df9cc836?auto=format&fit=crop&w=900&q=80', 'AVAILABLE', '2026-01-30 21:54:32', '2026-01-30 21:54:32');
INSERT INTO `products` VALUES ('2', '香辣烤鸡翅', '1', '22.00', '酥脆外皮 + 辣度可选', 'https://images.unsplash.com/photo-1482049016688-2d3e1b311543?auto=format&fit=crop&w=900&q=80', 'AVAILABLE', '2026-01-30 21:54:32', '2026-01-30 21:54:32');
INSERT INTO `products` VALUES ('3', '深夜海鲜捞', '2', '48.00', '鲜香浓郁，搭配多重口味选择', 'https://images.unsplash.com/photo-1473093295043-cdd812d0e601?auto=format&fit=crop&w=900&q=80', 'AVAILABLE', '2026-01-30 21:54:32', '2026-01-30 21:54:32');
INSERT INTO `products` VALUES ('4', '秘制牛肉串', '2', '16.00', '精选肉串 | 香气扑鼻', 'https://images.unsplash.com/photo-1526318896980-cf78c088247c?auto=format&fit=crop&w=900&q=80', 'AVAILABLE', '2026-01-30 21:54:32', '2026-01-30 21:54:32');
INSERT INTO `products` VALUES ('5', '轻乳酪芝士杯', '3', '18.00', '细腻绵密，低糖轻负担', 'https://images.unsplash.com/photo-1488477181946-6428a0291777?auto=format&fit=crop&w=900&q=80', 'AVAILABLE', '2026-01-30 21:54:32', '2026-01-30 21:54:32');
INSERT INTO `products` VALUES ('6', '抹茶奶盖', '3', '15.00', '茶香浓郁，回甘清爽', 'https://images.unsplash.com/photo-1543353071-873f17a7a088?auto=format&fit=crop&w=900&q=80', 'AVAILABLE', '2026-01-30 21:54:32', '2026-01-30 21:54:32');
INSERT INTO `products` VALUES ('7', '招牌牛杂面', '4', '26.00', '浓汤熬制 | 深夜食堂', 'https://images.unsplash.com/photo-1504674900247-0877df9cc836?auto=format&fit=crop&w=900&q=80', 'AVAILABLE', '2026-01-30 21:54:32', '2026-01-30 21:54:32');
INSERT INTO `products` VALUES ('8', '秘制酸辣粉', '4', '20.00', '酸辣开胃 | 现煮现吃', 'https://images.unsplash.com/photo-1504674900247-0877df9cc836?auto=format&fit=crop&w=900&q=80', 'AVAILABLE', '2026-01-30 21:54:32', '2026-01-30 21:54:32');
INSERT INTO `products` VALUES ('9', '经典牛肉汉堡', '5', '45.00', '多汁牛肉饼', 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd', 'AVAILABLE', '2026-01-30 21:55:25', '2026-01-30 21:55:25');
INSERT INTO `products` VALUES ('10', '意式腊肠披萨', '6', '55.00', '经典风味', 'https://images.unsplash.com/photo-1513104890138-7c749659a591', 'AVAILABLE', '2026-01-30 21:55:25', '2026-01-30 21:55:25');
INSERT INTO `products` VALUES ('11', '三文鱼刺身', '7', '68.00', '新鲜三文鱼', 'https://images.unsplash.com/photo-1579871494447-9811cf80d66c', 'AVAILABLE', '2026-01-30 21:55:25', '2026-01-30 21:55:25');
INSERT INTO `products` VALUES ('12', '韩式石锅拌饭', '8', '38.00', '蔬菜拌饭', 'https://images.unsplash.com/photo-1580651315530-69c8e0026377', 'AVAILABLE', '2026-01-30 21:55:25', '2026-01-30 21:55:25');
INSERT INTO `products` VALUES ('13', '老北京炸酱面', '9', '22.00', '传统酱香', 'https://images.unsplash.com/photo-1552611052-33e04de081de', 'AVAILABLE', '2026-01-30 21:55:25', '2026-01-30 21:55:25');
INSERT INTO `products` VALUES ('14', '麻辣香锅套餐', '10', '58.00', '荤素搭配', 'https://images.unsplash.com/photo-1563245372-f21724e3856d', 'AVAILABLE', '2026-01-30 21:55:25', '2026-01-30 21:55:25');
INSERT INTO `products` VALUES ('15', '鲜榨橙汁', '11', '18.00', '现榨果汁', 'https://images.unsplash.com/photo-1603569283847-aa295f0d016a', 'AVAILABLE', '2026-01-30 21:55:25', '2026-01-30 21:55:25');
INSERT INTO `products` VALUES ('16', '黑糖珍珠奶茶', '12', '22.00', '香甜Q弹', 'https://images.unsplash.com/photo-1558857563-b31cf1d65052', 'AVAILABLE', '2026-01-30 21:55:25', '2026-01-30 21:55:25');
INSERT INTO `products` VALUES ('17', '鸡肉凯撒沙拉', '13', '35.00', '健康首选', 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd', 'AVAILABLE', '2026-01-30 21:55:25', '2026-01-30 21:55:25');
INSERT INTO `products` VALUES ('18', '牛油果吐司', '14', '28.00', '绵密口感', 'https://images.unsplash.com/photo-1511690656952-34342d5c2899', 'AVAILABLE', '2026-01-30 21:55:25', '2026-01-30 21:55:25');
INSERT INTO `products` VALUES ('19', '羊肉串', '15', '6.00', '香辣入味', 'https://images.unsplash.com/photo-1529193591184-b1d580690dd0', 'AVAILABLE', '2026-01-30 21:55:25', '2026-01-30 21:55:25');
INSERT INTO `products` VALUES ('20', '水晶虾饺', '16', '26.00', '现蒸美味', 'https://images.unsplash.com/photo-1496116218417-1a781b1c423c', 'AVAILABLE', '2026-01-30 21:55:25', '2026-01-30 21:55:25');

-- ----------------------------
-- Table structure for reviews
-- ----------------------------
DROP TABLE IF EXISTS `reviews`;
CREATE TABLE `reviews` (
  `id` int NOT NULL AUTO_INCREMENT,
  `order_id` int NOT NULL,
  `user_id` int NOT NULL,
  `stall_id` int NOT NULL,
  `rating` tinyint DEFAULT NULL,
  `comment` text COLLATE utf8mb4_unicode_ci,
  `reply` text COLLATE utf8mb4_unicode_ci,
  `review_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `reply_time` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_order_id` (`order_id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_stall_id` (`stall_id`),
  KEY `idx_rating` (`rating`),
  CONSTRAINT `reviews_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE,
  CONSTRAINT `reviews_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `reviews_ibfk_3` FOREIGN KEY (`stall_id`) REFERENCES `stalls` (`id`) ON DELETE CASCADE,
  CONSTRAINT `reviews_chk_1` CHECK (((`rating` >= 1) and (`rating` <= 5)))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Records of reviews
-- ----------------------------

-- ----------------------------
-- Table structure for roles
-- ----------------------------
DROP TABLE IF EXISTS `roles`;
CREATE TABLE `roles` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `role_name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `permissions` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  CONSTRAINT `roles_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Records of roles
-- ----------------------------

-- ----------------------------
-- Table structure for stalls
-- ----------------------------
DROP TABLE IF EXISTS `stalls`;
CREATE TABLE `stalls` (
  `id` int NOT NULL AUTO_INCREMENT,
  `stall_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `location` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` enum('OPEN','CLOSED','MAINTENANCE','RENTED') COLLATE utf8mb4_unicode_ci DEFAULT 'CLOSED',
  `owner_id` int DEFAULT NULL,
  `category_id` int DEFAULT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `background_image_url` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `rent_fee` decimal(10,2) DEFAULT '0.00',
  `images` json DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_owner_id` (`owner_id`),
  KEY `idx_category_id` (`category_id`),
  KEY `idx_status` (`status`),
  CONSTRAINT `stalls_ibfk_1` FOREIGN KEY (`owner_id`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  CONSTRAINT `stalls_ibfk_2` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Records of stalls
-- ----------------------------
INSERT INTO `stalls` VALUES ('1', '辣味研究所', 'A区-12号', 'MAINTENANCE', '2', '5', '川味街头小吃 | 排队必吃', null, '3200.00', '[\"https://images.unsplash.com/photo-1504674900247-0877df9cc836?auto=format&fit=crop&w=900&q=80\"]', '2026-01-30 21:54:32');
INSERT INTO `stalls` VALUES ('2', '炭火串串屋', 'A区-08号', 'OPEN', '2', '5', '精选肉串 | 香气扑鼻', null, '2800.00', '[\"https://images.unsplash.com/photo-1498654896293-37aacf113fd9?auto=format&fit=crop&w=900&q=80\"]', '2026-01-30 21:54:32');
INSERT INTO `stalls` VALUES ('3', '暖心甜品铺', 'B区-03号', 'OPEN', '3', '4', '手作甜品 | 低糖轻负担', null, '2600.00', '[\"https://images.unsplash.com/photo-1512058564366-18510be2db19?auto=format&fit=crop&w=900&q=80\"]', '2026-01-30 21:54:32');
INSERT INTO `stalls` VALUES ('4', '招牌牛杂面', 'C区-05号', 'OPEN', '3', '1', '浓汤熬制 | 深夜食堂', null, '3000.00', '[\"https://images.unsplash.com/photo-1504674900247-0877df9cc836?auto=format&fit=crop&w=900&q=80\"]', '2026-01-30 21:54:32');
INSERT INTO `stalls` VALUES ('5', '脆皮汉堡屋', 'A区-15号', 'OPEN', '6', '2', '正宗美式汉堡', null, '3500.00', '[\"https://images.unsplash.com/photo-1568901346375-23c9450c58cd?auto=format&fit=crop&w=800&q=80\"]', '2026-01-30 21:55:25');
INSERT INTO `stalls` VALUES ('6', '披萨天堂', 'A区-16号', 'OPEN', '6', '2', '意式手工披萨', null, '3600.00', '[\"https://images.unsplash.com/photo-1513104890138-7c749659a591?auto=format&fit=crop&w=800&q=80\"]', '2026-01-30 21:55:25');
INSERT INTO `stalls` VALUES ('7', '樱花寿司', 'B区-05号', 'OPEN', '7', '3', '新鲜现做寿司', null, '4000.00', '[\"https://images.unsplash.com/photo-1579871494447-9811cf80d66c?auto=format&fit=crop&w=800&q=80\"]', '2026-01-30 21:55:25');
INSERT INTO `stalls` VALUES ('8', '泡菜小屋', 'B区-06号', 'OPEN', '7', '3', '韩式泡菜锅与石锅拌饭', null, '3800.00', '[\"https://images.unsplash.com/photo-1580651315530-69c8e0026377?auto=format&fit=crop&w=800&q=80\"]', '2026-01-30 21:55:25');
INSERT INTO `stalls` VALUES ('9', '老北京炸酱面馆', 'C区-08号', 'OPEN', '8', '1', '老北京炸酱面', null, '3000.00', '[\"https://images.unsplash.com/photo-1552611052-33e04de081de?auto=format&fit=crop&w=800&q=80\"]', '2026-01-30 21:55:25');
INSERT INTO `stalls` VALUES ('10', '川味麻辣香锅', 'C区-09号', 'OPEN', '8', '1', '正宗川味麻辣香锅', null, '3200.00', '[\"https://images.unsplash.com/photo-1563245372-f21724e3856d?auto=format&fit=crop&w=800&q=80\"]', '2026-01-30 21:55:25');
INSERT INTO `stalls` VALUES ('11', '鲜果汁吧', 'D区-01号', 'OPEN', '9', '4', '鲜榨果汁与奶昔', null, '2500.00', '[\"https://images.unsplash.com/photo-1603569283847-aa295f0d016a?auto=format&fit=crop&w=800&q=80\"]', '2026-01-30 21:55:25');
INSERT INTO `stalls` VALUES ('12', '奶茶世界', 'D区-02号', 'OPEN', '9', '4', '网红珍珠奶茶', null, '2800.00', '[\"https://images.unsplash.com/photo-1558857563-b31cf1d65052?auto=format&fit=crop&w=800&q=80\"]', '2026-01-30 21:55:25');
INSERT INTO `stalls` VALUES ('13', '健康沙拉碗', 'E区-01号', 'OPEN', '6', '6', '低脂鸡胸肉沙拉', null, '2400.00', '[\"https://images.unsplash.com/photo-1512621776951-a57141f2eefd?auto=format&fit=crop&w=800&q=80\"]', '2026-01-30 21:55:25');
INSERT INTO `stalls` VALUES ('14', '素食悦享', 'E区-02号', 'OPEN', '6', '6', '素食主义者的天堂', null, '2300.00', '[\"https://images.unsplash.com/photo-1511690656952-34342d5c2899?auto=format&fit=crop&w=800&q=80\"]', '2026-01-30 21:55:25');
INSERT INTO `stalls` VALUES ('15', '深夜烧烤', 'A区-20号', 'OPEN', '2', '5', '深夜撸串好去处', null, '3100.00', '[\"https://images.unsplash.com/photo-1529193591184-b1d580690dd0?auto=format&fit=crop&w=800&q=80\"]', '2026-01-30 21:55:25');
INSERT INTO `stalls` VALUES ('16', '粤式点心楼', 'C区-12号', 'OPEN', '8', '1', '广式早茶点心', null, '3300.00', '[\"https://images.unsplash.com/photo-1496116218417-1a781b1c423c?auto=format&fit=crop&w=800&q=80\"]', '2026-01-30 21:55:25');

-- ----------------------------
-- Table structure for users
-- ----------------------------
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `password_hash` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `phone` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `role_type` enum('ADMIN','OWNER','DINER') COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` enum('ACTIVE','INACTIVE','PENDING') COLLATE utf8mb4_unicode_ci DEFAULT 'PENDING',
  `avatar_url` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `phone` (`phone`),
  KEY `idx_username` (`username`),
  KEY `idx_email` (`email`),
  KEY `idx_phone` (`phone`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Records of users
-- ----------------------------
INSERT INTO `users` VALUES ('1', 'admin', 'admin123', 'admin@foodcourt.com', '13800138000', 'ADMIN', 'ACTIVE', null, '2026-01-30 21:54:32', '2026-01-30 21:54:32');
INSERT INTO `users` VALUES ('2', 'owner_li', 'owner123', 'owner1@foodcourt.com', '13900000001', 'OWNER', 'ACTIVE', null, '2026-01-30 21:54:32', '2026-01-30 21:54:32');
INSERT INTO `users` VALUES ('3', 'owner_zhang', 'owner123', 'owner2@foodcourt.com', '13900000002', 'OWNER', 'ACTIVE', null, '2026-01-30 21:54:32', '2026-01-30 21:54:32');
INSERT INTO `users` VALUES ('4', 'diner_xiao', 'diner123', 'diner1@foodcourt.com', '13700000001', 'DINER', 'ACTIVE', null, '2026-01-30 21:54:32', '2026-01-30 21:54:32');
INSERT INTO `users` VALUES ('5', 'diner_mei', 'diner123', 'diner2@foodcourt.com', '13700000002', 'DINER', 'ACTIVE', null, '2026-01-30 21:54:32', '2026-01-30 21:54:32');
INSERT INTO `users` VALUES ('6', 'owner_wang', 'owner123', 'owner_wang@foodcourt.com', '13900000011', 'OWNER', 'ACTIVE', null, '2026-01-30 21:55:25', '2026-01-30 21:55:25');
INSERT INTO `users` VALUES ('7', 'owner_zhao', 'owner123', 'owner_zhao@foodcourt.com', '13900000012', 'OWNER', 'ACTIVE', null, '2026-01-30 21:55:25', '2026-01-30 21:55:25');
INSERT INTO `users` VALUES ('8', 'owner_chen', 'owner123', 'owner_chen@foodcourt.com', '13900000013', 'OWNER', 'ACTIVE', null, '2026-01-30 21:55:25', '2026-01-30 21:55:25');
INSERT INTO `users` VALUES ('9', 'owner_liu', 'owner123', 'owner_liu@foodcourt.com', '13900000014', 'OWNER', 'ACTIVE', null, '2026-01-30 21:55:25', '2026-01-30 21:55:25');
INSERT INTO `users` VALUES ('10', 'diner_01', 'diner123', 'diner01@fc.com', '13700000011', 'DINER', 'ACTIVE', null, '2026-01-30 21:55:25', '2026-01-30 21:55:25');
INSERT INTO `users` VALUES ('11', 'diner_02', 'diner123', 'diner02@fc.com', '13700000012', 'DINER', 'ACTIVE', null, '2026-01-30 21:55:25', '2026-01-30 21:55:25');
INSERT INTO `users` VALUES ('12', 'diner_03', 'diner123', 'diner03@fc.com', '13700000013', 'DINER', 'ACTIVE', null, '2026-01-30 21:55:25', '2026-01-30 21:55:25');
INSERT INTO `users` VALUES ('13', 'diner_04', 'diner123', 'diner04@fc.com', '13700000014', 'DINER', 'ACTIVE', null, '2026-01-30 21:55:25', '2026-01-30 21:55:25');
INSERT INTO `users` VALUES ('14', 'diner_05', 'diner123', 'diner05@fc.com', '13700000015', 'DINER', 'ACTIVE', null, '2026-01-30 21:55:25', '2026-01-30 21:55:25');
INSERT INTO `users` VALUES ('15', 'diner_06', 'diner123', 'diner06@fc.com', '13700000016', 'DINER', 'ACTIVE', null, '2026-01-30 21:55:25', '2026-01-30 21:55:25');
INSERT INTO `users` VALUES ('16', 'diner_07', 'diner123', 'diner07@fc.com', '13700000017', 'DINER', 'ACTIVE', null, '2026-01-30 21:55:25', '2026-01-30 21:55:25');
INSERT INTO `users` VALUES ('17', 'diner_08', 'diner123', 'diner08@fc.com', '13700000018', 'DINER', 'ACTIVE', null, '2026-01-30 21:55:25', '2026-01-30 21:55:25');
INSERT INTO `users` VALUES ('18', 'diner_09', 'diner123', 'diner09@fc.com', '13700000019', 'DINER', 'ACTIVE', null, '2026-01-30 21:55:25', '2026-01-30 21:55:25');
INSERT INTO `users` VALUES ('19', 'diner_10', 'diner123', 'diner10@fc.com', '13700000020', 'DINER', 'ACTIVE', null, '2026-01-30 21:55:25', '2026-01-30 21:55:25');
INSERT INTO `users` VALUES ('20', 'cs1', '123456', '123@163.com', '18759456287', 'DINER', 'ACTIVE', null, '2026-01-30 21:56:24', '2026-01-30 21:56:24');
