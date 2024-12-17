-- MySQL dump 10.13  Distrib 8.0.36, for Win64 (x86_64)
--
-- Host: localhost    Database: new_database
-- ------------------------------------------------------
-- Server version	8.0.37

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `alembic_version`
--

DROP TABLE IF EXISTS `alembic_version`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `alembic_version` (
  `version_num` varchar(32) NOT NULL,
  PRIMARY KEY (`version_num`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `alembic_version`
--

LOCK TABLES `alembic_version` WRITE;
/*!40000 ALTER TABLE `alembic_version` DISABLE KEYS */;
INSERT INTO `alembic_version` VALUES ('339ef6407ce9');
/*!40000 ALTER TABLE `alembic_version` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `brands`
--

DROP TABLE IF EXISTS `brands`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `brands` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `description` text,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `brands`
--

LOCK TABLES `brands` WRITE;
/*!40000 ALTER TABLE `brands` DISABLE KEYS */;
INSERT INTO `brands` VALUES (1,'Apple','Apple Inc. là một công ty công nghệ đa quốc gia của Mỹ chuyên thiết kế, sản xuất và bán các sản phẩm điện tử tiêu dùng, phần mềm máy tính và dịch vụ trực tuyến.'),(2,'Samsung','Samsung Electronics Co., Ltd. là một công ty điện tử đa quốc gia của Hàn Quốc chuyên sản xuất các thiết bị điện tử và công nghệ thông tin.'),(3,'Sony','Sony Corporation là một tập đoàn đa quốc gia của Nhật Bản chuyên sản xuất các sản phẩm điện tử tiêu dùng, giải trí và tài chính.'),(4,'LG','LG Electronics Inc. là một công ty điện tử đa quốc gia của Hàn Quốc chuyên sản xuất các sản phẩm điện tử tiêu dùng, thiết bị gia dụng và truyền thông di động.'),(5,'Xiaomi','Xiaomi Corporation là một công ty điện tử tiêu dùng và phần mềm của Trung Quốc, chuyên sản xuất điện thoại thông minh, ứng dụng di động và thiết bị gia dụng thông minh.'),(6,'Huawei','Huawei Technologies Co., Ltd. là một tập đoàn công nghệ đa quốc gia của Trung Quốc chuyên sản xuất và kinh doanh thiết bị viễn thông và thiết bị điện tử tiêu dùng.'),(7,'OnePlus','OnePlus Technology Co., Ltd. là một công ty sản xuất điện thoại thông minh của Trung Quốc, nổi tiếng với các sản phẩm điện thoại thông minh cao cấp với giá cả phải chăng.'),(8,'Oppo','OPPO Electronics Corp. là một công ty điện tử tiêu dùng và truyền thông di động của Trung Quốc chuyên sản xuất điện thoại thông minh, thiết bị nghe nhạc và các thiết bị điện tử khác.'),(9,'Vivo','Vivo Communication Technology Co. Ltd. là một công ty công nghệ của Trung Quốc chuyên sản xuất điện thoại thông minh, phần mềm và phụ kiện điện thoại di động.'),(10,'Nokia','Nokia Corporation là một tập đoàn đa quốc gia của Phần Lan chuyên sản xuất thiết bị viễn thông, công nghệ thông tin và thiết bị điện tử tiêu dùng.');
/*!40000 ALTER TABLE `brands` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `categories`
--

DROP TABLE IF EXISTS `categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `categories` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `description` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `categories`
--

LOCK TABLES `categories` WRITE;
/*!40000 ALTER TABLE `categories` DISABLE KEYS */;
INSERT INTO `categories` VALUES (1,'Điện Thoại Thông Minh','Thiết bị kết hợp máy tính, điện thoại di động và trợ lý số.'),(2,'Phụ Kiện','Các bộ phận bổ trợ tăng cường khả năng của thiết bị.'),(3,'Thiết Bị Đeo','Các thiết bị điện tử có thể đeo được như phụ kiện.');
/*!40000 ALTER TABLE `categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `discounts`
--

DROP TABLE IF EXISTS `discounts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `discounts` (
  `id` int NOT NULL AUTO_INCREMENT,
  `description` text,
  `discount_amount` decimal(10,2) NOT NULL,
  `valid_from` datetime DEFAULT NULL,
  `valid_to` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `discounts`
--

LOCK TABLES `discounts` WRITE;
/*!40000 ALTER TABLE `discounts` DISABLE KEYS */;
INSERT INTO `discounts` VALUES (1,'Khuyến mãi mùa hè',25.00,'2024-06-01 00:00:00','2024-08-31 00:00:00'),(2,'Giảm giá đặc biệt cuối năm',30.00,'2024-12-01 00:00:00','2024-12-31 00:00:00'),(3,'Giảm giá sinh nhật',60.00,'2024-06-01 00:00:00','2024-08-31 00:00:00'),(4,'Khuyến mãi Black Friday',50.00,'2024-06-01 00:00:00','2024-08-31 00:00:00'),(5,'Giảm giá Tết',15.00,'2024-06-01 00:00:00','2024-08-31 00:00:00'),(6,'Giảm 20% cho đơn hàng từ đầu năm đến cuối tháng 6 năm 2024',16.00,'2024-01-01 00:00:00','2024-06-30 00:00:00'),(7,'Khuyến mãi 15% mùa xuân, áp dụng từ tháng 2 đến giữa tháng 7 năm 2024',57.00,'2024-02-01 00:00:00','2024-07-15 00:00:00'),(8,'Giảm 10% cho mùa hè, từ tháng 3 đến cuối tháng 8 năm 2024',30.00,'2024-03-01 00:00:00','2024-08-20 00:00:00'),(9,'Ưu đãi 25% cho mùa tựu trường, bắt đầu từ tháng 4 đến cuối tháng 9 năm 2024',29.00,'2024-04-01 00:00:00','2024-09-25 00:00:00'),(10,'Giảm 30% cho bộ sưu tập thu, từ tháng 5 đến cuối tháng 10 năm 2024',80.00,'2024-05-01 00:00:00','2024-10-30 00:00:00');
/*!40000 ALTER TABLE `discounts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_details`
--

DROP TABLE IF EXISTS `order_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_details` (
  `id` int NOT NULL AUTO_INCREMENT,
  `order_id` int DEFAULT NULL,
  `product_id` int DEFAULT NULL,
  `quantity` int NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `discount` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `order_id` (`order_id`),
  KEY `product_id` (`product_id`),
  CONSTRAINT `order_details_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`),
  CONSTRAINT `order_details_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=69 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_details`
--

LOCK TABLES `order_details` WRITE;
/*!40000 ALTER TABLE `order_details` DISABLE KEYS */;
INSERT INTO `order_details` VALUES (15,NULL,2,2,15999000.00,0.00),(16,NULL,3,4,5599600.00,0.00),(17,NULL,1,2,13499250.00,0.00),(18,NULL,8,2,4990000.00,0.00),(19,NULL,1,1,13499250.00,0.00),(20,NULL,3,1,5599600.00,0.00),(21,NULL,6,1,6900000.00,0.00),(26,NULL,2,1,15999000.00,0.00),(27,NULL,4,2,5999500.00,0.00),(28,NULL,5,1,16149150.00,0.00),(29,NULL,6,1,6900000.00,0.00),(31,NULL,2,3,15999000.00,0.00),(33,NULL,3,2,5599600.00,0.00),(34,NULL,6,1,6900000.00,0.00),(35,NULL,2,4,15999000.00,0.00),(36,NULL,4,4,5999500.00,0.00),(37,26,3,2,5599600.00,0.00),(38,26,7,3,7500000.00,0.00),(39,27,2,3,15999000.00,0.00),(40,27,9,2,6035000.00,0.00),(41,28,2,2,15999000.00,0.00),(42,28,6,1,6900000.00,0.00),(43,29,8,4,4990000.00,0.00),(45,30,3,2,5599600.00,0.00),(46,30,7,4,7500000.00,0.00),(47,31,3,2,5599600.00,0.00),(48,31,4,1,5999500.00,0.00),(49,31,9,1,6035000.00,0.00),(50,32,3,1,5599600.00,0.00),(51,32,7,2,7500000.00,0.00),(52,33,6,1,6900000.00,0.00),(53,34,8,3,4990000.00,0.00),(54,35,3,1,5599600.00,0.00),(55,36,2,3,15999000.00,0.00),(56,36,7,4,7500000.00,0.00),(57,37,2,2,15999000.00,0.00),(58,38,4,2,5999500.00,0.00),(59,69,3,4,5599600.00,0.00),(60,69,7,3,7500000.00,0.00),(61,70,2,2,15999000.00,0.00),(62,71,2,4,15999000.00,0.00),(63,72,8,2,4990000.00,0.00),(64,74,4,2,5999500.00,0.00),(65,73,4,2,5999500.00,0.00),(66,74,7,2,7500000.00,0.00),(67,73,7,2,7500000.00,0.00),(68,75,7,3,7500000.00,0.00);
/*!40000 ALTER TABLE `order_details` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orders` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int DEFAULT NULL,
  `order_date` datetime DEFAULT NULL,
  `total` decimal(10,2) NOT NULL,
  `status` enum('processing','shipped','cancelled') NOT NULL,
  `address` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=76 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orders`
--

LOCK TABLES `orders` WRITE;
/*!40000 ALTER TABLE `orders` DISABLE KEYS */;
INSERT INTO `orders` VALUES (26,51,'2024-07-07 11:26:29',33699200.00,'cancelled','fsdfsf'),(27,62,'2024-07-07 12:21:40',60067000.00,'cancelled','fsdfsf'),(28,62,'2024-07-07 12:23:02',38898000.00,'shipped','fsdfsf'),(29,62,'2024-07-07 12:25:15',24360000.00,'processing','fsdfsf'),(30,62,'2024-07-07 12:27:49',41199200.00,'cancelled','fsdfsf'),(31,62,'2024-07-07 12:28:19',23233700.00,'cancelled','fsdfsf'),(32,62,'2024-07-07 12:29:20',20599600.00,'cancelled','fsdfsf'),(33,38,'2024-07-07 12:35:57',6900000.00,'cancelled','fsdfsf'),(34,51,'2024-07-07 13:09:46',14970000.00,'processing','fsdfsf'),(35,47,'2024-07-07 13:57:37',5599600.00,'cancelled','fsdfsf'),(36,47,'2024-07-08 00:33:57',77997000.00,'shipped','fsdfsf'),(37,47,'2024-07-08 00:44:27',31998000.00,'shipped','fsdfsf'),(38,47,'2024-07-08 01:35:13',11999000.00,'processing','fsdfsf'),(69,67,'2024-07-08 08:22:00',44898400.00,'cancelled','fsdfsf'),(70,67,'2024-07-08 08:46:44',31998000.00,'cancelled','fsdfsf'),(71,67,'2024-07-08 08:50:19',63996000.00,'cancelled','fsdfsf'),(72,67,'2024-07-08 09:02:43',9980000.00,'cancelled','fsdfsf'),(73,67,'2024-07-08 09:32:54',26999000.00,'cancelled','fdsaf'),(74,67,'2024-07-08 09:32:54',26999000.00,'cancelled','fdsaf'),(75,67,'2024-07-08 09:34:18',22500000.00,'processing','fdsaf');
/*!40000 ALTER TABLE `orders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `payments`
--

DROP TABLE IF EXISTS `payments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `payments` (
  `id` int NOT NULL AUTO_INCREMENT,
  `order_id` int DEFAULT NULL,
  `amount` decimal(10,2) NOT NULL,
  `payment_date` datetime DEFAULT NULL,
  `payment_method` enum('credit_card','paypal','cash') NOT NULL,
  PRIMARY KEY (`id`),
  KEY `order_id` (`order_id`),
  CONSTRAINT `payments_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=40 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payments`
--

LOCK TABLES `payments` WRITE;
/*!40000 ALTER TABLE `payments` DISABLE KEYS */;
INSERT INTO `payments` VALUES (9,NULL,54396400.00,'2024-07-07 09:56:15','cash'),(10,NULL,36978500.00,'2024-07-07 10:04:59','cash'),(11,NULL,25998850.00,'2024-07-07 10:09:27','cash'),(12,NULL,53247150.00,'2024-07-07 10:21:05','cash'),(13,NULL,52397000.00,'2024-07-07 10:22:26','cash'),(14,NULL,18099200.00,'2024-07-07 11:07:06','cash'),(15,NULL,87994000.00,'2024-07-07 11:17:06','cash'),(16,26,33699200.00,'2024-07-07 11:26:29','cash'),(17,27,60067000.00,'2024-07-07 12:21:40','cash'),(18,28,38898000.00,'2024-07-07 12:23:02','cash'),(19,29,24360000.00,'2024-07-07 12:25:15','cash'),(20,30,41199200.00,'2024-07-07 12:27:49','cash'),(21,31,23233700.00,'2024-07-07 12:28:19','cash'),(22,32,20599600.00,'2024-07-07 12:29:20','cash'),(23,33,6900000.00,'2024-07-07 12:35:57','cash'),(24,34,14970000.00,'2024-07-07 13:09:46','cash'),(25,35,5599600.00,'2024-07-07 13:57:37','cash'),(26,36,77997000.00,'2024-07-08 00:33:57','cash'),(27,37,31998000.00,'2024-07-08 00:44:27','cash'),(28,38,11999000.00,'2024-07-08 01:35:13','cash'),(29,69,44898400.00,'2024-07-08 08:22:00','cash'),(30,70,31998000.00,'2024-07-08 08:46:44','cash'),(31,71,63996000.00,'2024-07-08 08:50:19','cash'),(32,71,-63996000.00,'2024-07-08 08:50:40','cash'),(33,72,9980000.00,'2024-07-08 09:02:43','paypal'),(34,72,-9980000.00,'2024-07-08 09:02:53','paypal'),(35,74,26999000.00,'2024-07-08 09:32:54','cash'),(36,73,26999000.00,'2024-07-08 09:32:54','cash'),(37,73,-26999000.00,'2024-07-08 09:33:02','cash'),(38,74,-26999000.00,'2024-07-08 09:33:07','cash'),(39,75,22500000.00,'2024-07-08 09:34:18','cash');
/*!40000 ALTER TABLE `payments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product_discounts`
--

DROP TABLE IF EXISTS `product_discounts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_discounts` (
  `product_id` int NOT NULL,
  `discount_id` int NOT NULL,
  PRIMARY KEY (`product_id`,`discount_id`),
  KEY `discount_id` (`discount_id`),
  CONSTRAINT `product_discounts_ibfk_1` FOREIGN KEY (`discount_id`) REFERENCES `discounts` (`id`),
  CONSTRAINT `product_discounts_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product_discounts`
--

LOCK TABLES `product_discounts` WRITE;
/*!40000 ALTER TABLE `product_discounts` DISABLE KEYS */;
INSERT INTO `product_discounts` VALUES (1,1),(2,2),(3,3),(4,4),(5,5),(6,6),(9,9);
/*!40000 ALTER TABLE `product_discounts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product_images`
--

DROP TABLE IF EXISTS `product_images`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_images` (
  `id` int NOT NULL AUTO_INCREMENT,
  `product_id` int DEFAULT NULL,
  `url` varchar(255) NOT NULL,
  `description` text,
  PRIMARY KEY (`id`),
  KEY `product_id` (`product_id`),
  CONSTRAINT `product_images_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=49 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product_images`
--

LOCK TABLES `product_images` WRITE;
/*!40000 ALTER TABLE `product_images` DISABLE KEYS */;
INSERT INTO `product_images` VALUES (1,1,'https://cdn.tgdd.vn/Products/Images/42/249948/samsung-galaxy-s23-ultra-green-thumbnew-600x600.jpg','Hình ảnh iPhone 13'),(2,1,'https://cdn.tgdd.vn/Products/Images/42/249948/samsung-galaxy-s23-ultra-xanh-1.jpg','Hình ảnh Galaxy S21'),(3,1,'https://cdn.tgdd.vn/Products/Images/42/249948/samsung-galaxy-s23-ultra-1-2.jpg','Hình ảnh Pixel 6'),(4,2,'https://cdn.tgdd.vn/Products/Images/42/321895/oppo-reno11-f-purple-thumb-600x600.jpg','Hình ảnh OnePlus 9'),(5,2,'https://cdn.tgdd.vn/Products/Images/42/321895/oppo-reno11-f-purple-thumb-600x600.jpg','Hình ảnh Galaxy Note 20'),(6,2,'https://cdn.tgdd.vn/Products/Images/42/321895/oppo-reno-11f-tim-1.jpg','Hình ảnh Galaxy Note 20'),(7,3,'https://cdn.tgdd.vn/Products/Images/42/305658/iphone-15-pro-max-blue-thumbnew-600x600.jpg',NULL),(8,3,'https://cdn.tgdd.vn/Products/Images/42/305658/iphone-15-pro-max-blue-1-1.jpg',NULL),(9,3,'https://cdn.tgdd.vn/Products/Images/42/305658/iphone-15-pro-max-tu-nhien-1-1.jpg',NULL),(11,4,'https://cdn.tgdd.vn/Products/Images/42/309831/xiaomi-redmi-note-13-gold-thumb-600x600.jpg',NULL),(12,4,'https://cdn.tgdd.vn/Products/Images/42/309831/xiaomi-redmi-note-13-vang-1-1.jpg',NULL),(13,4,'https://cdn.tgdd.vn/Products/Images/42/309831/redmi-note-13-xanh-1.jpg',NULL),(14,5,'https://cdn.tgdd.vn/Products/Images/42/311354/oppo-a58-4g-green-thumb-600x600.jpg',NULL),(15,5,'https://cdn.tgdd.vn/Products/Images/42/311354/oppo-a58-xanh-8gb-1.jpg',NULL),(16,5,'https://cdn.tgdd.vn/Products/Images/42/311354/oppo-a58-den-8gb-1.jpg',NULL),(22,6,'https://cdn.tgdd.vn/Products/Images/42/307172/samsung-galaxy-s24-plus-black-thumb-600x600.jpg','Redmi Note 10 Front View'),(23,6,'https://cdn.tgdd.vn/Products/Images/42/307172/samsung-galaxy-s24-plus-den-1.jpg','Realme 8 Front View'),(24,6,'https://cdn.tgdd.vn/Products/Images/42/307172/samsung-galaxy-s24-plus-tim-1.jpg','Vivo Y20s Front View'),(25,7,'https://cdn.tgdd.vn/Products/Images/42/298377/samsung-galaxy-a34-5g-xanh-la-ma-thumb-600x600.jpg','Oppo A94 Front View'),(26,7,'https://cdn.tgdd.vn/Products/Images/42/298377/samsung-galaxy-a34-xanh-glr-1.jpg','Huawei P40 Lite Front View'),(27,7,'https://cdn.tgdd.vn/Products/Images/42/298377/samsung-galaxy-a34-den-1.jpg',NULL),(28,8,'https://cdn.tgdd.vn/Products/Images/42/274018/samsung-galaxy-a24-green-thumb-600x600.jpg',NULL),(29,8,'https://cdn.tgdd.vn/Products/Images/42/274018/samsung-galaxy-a24-xanh-1.jpg',NULL),(30,8,'https://cdn.tgdd.vn/Products/Images/42/274018/samsung-galaxy-a24-den-1.jpg',NULL),(31,9,'https://cdn.tgdd.vn/Products/Images/42/323546/masstel-fami-50-green-thumb-600x600.jpg',NULL),(32,9,'https://cdn.tgdd.vn/Products/Images/42/323546/masstel-fami-50-green-1-1.jpg',NULL),(33,9,'https://cdn.tgdd.vn/Products/Images/42/323546/masstel-fami-50-black-1-1.jpg',NULL),(34,NULL,'https://cdn.tgdd.vn/Products/Images/42/298538/xiaomi-14-green-thumbnew-600x600.jpg',NULL),(35,NULL,'https://cdn.tgdd.vn/Products/Images/42/298538/xiaomi-14-green-thumbnew-600x600.jpg',NULL),(36,NULL,'https://cdn.tgdd.vn/Products/Images/42/298538/xiaomi-14-trang-1.jpg',NULL),(37,NULL,'4.PNG',NULL),(38,NULL,'5.PNG',NULL),(39,NULL,'6.PNG',NULL),(40,NULL,'4.PNG',NULL),(41,NULL,'5.PNG',NULL),(42,NULL,'6.PNG',NULL),(43,NULL,'5.PNG',NULL),(44,NULL,'6.PNG',NULL),(45,NULL,'7.PNG',NULL),(46,NULL,'5.PNG',NULL),(47,NULL,'6.PNG',NULL),(48,NULL,'7.PNG',NULL);
/*!40000 ALTER TABLE `product_images` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `products`
--

DROP TABLE IF EXISTS `products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `products` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `description` text,
  `price` decimal(10,2) NOT NULL,
  `stock` int NOT NULL,
  `category_id` int DEFAULT NULL,
  `screen` varchar(255) DEFAULT NULL,
  `cpu` varchar(255) DEFAULT NULL,
  `ram` varchar(255) DEFAULT NULL,
  `storage` varchar(255) DEFAULT NULL,
  `camera` varchar(255) DEFAULT NULL,
  `os` varchar(255) DEFAULT NULL,
  `features` text,
  `is_new` tinyint(1) DEFAULT NULL,
  `battery` int DEFAULT NULL,
  `promotion_text` varchar(255) DEFAULT NULL,
  `brand_id` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `category_id` (`category_id`),
  KEY `brand_id` (`brand_id`),
  CONSTRAINT `products_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`),
  CONSTRAINT `products_ibfk_2` FOREIGN KEY (`brand_id`) REFERENCES `brands` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `products`
--

LOCK TABLES `products` WRITE;
/*!40000 ALTER TABLE `products` DISABLE KEYS */;
INSERT INTO `products` VALUES (1,'iPhone 13','Điện thoại Apple với chip A15.',17999000.00,12,1,'6.1 inch','A15 Bionic','4GB','128GB','12MP trước, 12MP sau','iOS','Nhận diện khuôn mặt, Chống nước',1,4000,'Khuyến mãi đặc biệt cho mùa hè',1),(2,'Galaxy S21','Điện thoại Samsung với camera độ phân giải cao.',15999000.00,34,1,'6.2 inch','Exynos 2100','8GB','256GB','10MP trước, 64MP sau','Android','Chống nước, hỗ trợ 5G',1,4500,'Giảm giá 20% cho sinh viên',2),(3,'Pixel 6','Điện thoại Google với cải tiến AI.',13999000.00,40,1,'6.4 inch','Google Tensor','8GB','128GB','8MP trước, 50MP sau','Android','Nhận diện giọng nói aaa',1,3000,'Sản phẩm sẽ được giảm 500.000₫ khi mua hàng online bằng thẻ VPBank hoặc tin nhắn SMS',3),(4,'OnePlus 9','Điện thoại thông minh với hiệu năng cao từ OnePlus.',11999000.00,14,1,'6.55 inch','Snapdragon 888','8GB','128GB','16MP trước, 48MP + 50MP + 2MP sau','Android','Hỗ trợ 5G, màn hình 120Hz',1,3500,'Giảm giá 15% khi mua online',4),(5,'Samsung Galaxy Note 20','Điện thoại thông minh với bút S-Pen.',18999000.00,25,1,'6.7 inch','Exynos 990','8GB','256GB','10MP trước, 64MP + 12MP + 12MP sau','Android','Bút S-Pen, Màn hình Infinity-O',1,5000,'Khuyến mãi 10% cho khách hàng thân thiết',2),(6,'Xiaomi Redmi Note 10','Điện thoại tầm trung với hiệu năng tốt.',6900000.00,11,1,'6.43 inch','Snapdragon 678','4GB','64GB','13MP trước, 48MP+8MP+2MP+2MP sau','Android','Pin lớn, AMOLED display',1,3200,'Freeship toàn quốc',5),(7,'Realme 8','Điện thoại Realme với màn hình sáng và rõ nét.',7500000.00,104,1,'6.4 inch','Helio G95','8GB','128GB','16MP trước, 64MP+8MP+2MP+2MP sau','Android','Super AMOLED, Sạc nhanh',1,4100,'Sản phẩm sẽ được giảm 500.000₫ khi mua hàng online bằng thẻ VPBank hoặc tin nhắn SMS',6),(8,'Vivo Y20s','Điện thoại Vivo với pin khủng lên đến 5000mAh.',4990000.00,82,1,'6.51 inch','Snapdragon 460','6GB','128GB','8MP trước, 13MP+2MP+2MP sau','Android','Pin lớn, Thiết kế thời trang',1,3800,'Tặng kèm ốp lưng khi mua sản phẩm',7),(9,'Oppo A94','Oppo A94 với chế độ chơi game tối ưu.',8500000.00,70,1,'6.43 inch','Helio P95','8GB','128GB','16MP trước, 48MP+8MP+2MP+2MP sau','Android','Chế độ Game Focus, Màn hình AMOLED',1,4400,'Giảm giá 30% cho mùa khai trường',8);
/*!40000 ALTER TABLE `products` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ratings`
--

DROP TABLE IF EXISTS `ratings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ratings` (
  `id` int NOT NULL AUTO_INCREMENT,
  `product_id` int DEFAULT NULL,
  `user_id` int DEFAULT NULL,
  `score` int NOT NULL,
  `comment` text,
  `rating_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `product_id` (`product_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `ratings_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`),
  CONSTRAINT `ratings_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=39 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ratings`
--

LOCK TABLES `ratings` WRITE;
/*!40000 ALTER TABLE `ratings` DISABLE KEYS */;
INSERT INTO `ratings` VALUES (11,1,1,5,'Sản phẩm rất tốt!','2023-07-01 00:00:00'),(12,1,2,4,'Sản phẩm ổn nhưng giá hơi cao.','2023-07-02 00:00:00'),(13,2,3,5,'Đáng giá tiền!','2023-07-03 00:00:00'),(14,2,2,3,'Bình thường.','2023-07-04 00:00:00'),(15,3,3,5,'Tuyệt vời!','2023-07-05 00:00:00'),(16,3,1,4,'Khá tốt.','2023-07-06 00:00:00'),(17,4,2,5,'Rất hài lòng.','2023-07-07 00:00:00'),(18,4,3,5,'Sản phẩm chất lượng.','2023-07-08 00:00:00'),(19,5,1,4,'Tốt nhưng giá hơi cao.','2023-07-09 00:00:00'),(20,5,2,5,'Rất tốt!','2023-07-10 00:00:00'),(26,6,1,4,'Giá tốt, hiệu năng ổn định, camera tốt.','2024-07-06 09:59:39'),(27,7,2,5,'Màn hình sáng, màu sắc đẹp, thích hợp để xem phim.','2024-07-06 09:59:39'),(28,8,3,3,'Pin trâu nhưng hiệu năng không quá nổi bật.','2024-07-06 09:59:39'),(29,9,2,4,'Rất thích chế độ chơi game, không bị giật lag.','2024-07-06 09:59:39'),(31,2,NULL,1,'sản phẩm này rất tệ đừng mua','2024-07-07 13:48:22'),(32,8,NULL,5,'xuất sắc','2024-07-07 13:48:43'),(33,6,38,5,'sản phẩm rất tốt tôi rất thích','2024-07-07 13:49:57'),(34,6,51,4,'sada','2024-07-07 13:52:01'),(35,9,51,1,'máy đểu đừng tin','2024-07-07 13:52:22'),(36,6,47,5,'sản phẩm hiệu năng rất tốt','2024-07-07 13:53:25'),(37,2,47,3,'sản phẩm này rất tốt mọi người nên mua ','2024-07-08 00:34:21');
/*!40000 ALTER TABLE `ratings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `full_name` varchar(255) NOT NULL,
  `birth_date` date DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `phone_number` varchar(15) DEFAULT NULL,
  `role` enum('customer','admin') NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=83 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'nguyenvana','matkhau123','nguyenvana@email.com','Nguyễn Văn A','1985-03-22','123 Đường Phố Nội, Thành Phố','555-0123','customer'),(2,'lethib','matkhau123','lethib@email.com','Lê Thị B','1990-07-15','456 Đường Phố Ngoại, Thị Xã','555-0456','customer'),(3,'admin','adminpass','admin.email@admin.com','Quản Trị Viên','1980-01-01','789 Đường Phố, Làng','555-0789','admin'),(38,'admin1','pbkdf2:sha256:600000$EWl9KORJY2UTDoBz$84d1acc39afe001be73932eafe8a100322d2fb7efa2bf65ce04a13d041b12367','admin15222@gmail.com','admin1',NULL,'samsung galaxy, hà nội','0928371721','customer'),(46,'admin144','pbkdf2:sha256:600000$pZZNCCnSKsJ84Wbs$072bb848988bb4f93820d1785386f47841a2c8b5b3909496dc33b69b0c73f1cb','admin@gmail.com','Lê Văn Na','2024-07-23','Hà Nội','0928374521','customer'),(47,'testtk','pbkdf2:sha256:600000$ENLgJ9jp8BRNkL5u$a2721ab0277db83ac33d36c22005738e7e41c83307e53b3fb3d4f6099ca3c991','ctv55345@gmail.com','ctv55345@gmail.com',NULL,'Hà Đông,Hà Nội ','764564554','admin'),(51,'test123ff','pbkdf2:sha256:600000$hdFJ02jRp6yDvEQ1$bb430646cc6b51cad2ffe164cb71c9d5286b5e429486fd114e29e61da7fc9896','admin15322@gmail.com','test123ff',NULL,'simdaidasdadsadasdaasdaa','1283947562','customer'),(52,'test@gmail.com','pbkdf2:sha256:600000$0kWRIoTNkkcUxqOI$bc93d8bb1cf6e42d9bdca003dfcf5a836aed755285257731cbe6c9e02553d63e','sdsd@gmail.com','sdsd','2024-07-04','Hà Nội','0392817172','customer'),(55,'admin133','pbkdf2:sha256:600000$pFEG5QFVyG8sWSwd$31f4bccdee5e98b0f5486d8f98b1ec1d1f6615c311d548b49380ac625c448978','ctv553421@gmail.com','sadasd','2024-07-09','Hà Nội','0928374521','customer'),(56,'admin18','pbkdf2:sha256:600000$DJ1FzG9OEhT5Zssw$6bd88158063021b2e2149213a0fc92f02a1549469926a2fc35d9655c265772f7','admin18@gmail.com','admin18','2024-07-17','Hà Nội','0392817172','customer'),(60,'admin18x','pbkdf2:sha256:600000$0jfIbDWDNgkmKW10$80850028bc1208f7bfdf7b0b5120c89b8c2371667a8f6a84475c84f1368276cf','anhloi610@gmail.com','admin18x',NULL,NULL,NULL,'customer'),(62,'admin18x1','pbkdf2:sha256:600000$ttj9Fte4Aempexpv$6472974947a53b63547cc020477792b7c3394405cacbe3679c2ec51d723eca6b','','sdsd',NULL,'None','None','customer'),(63,'test666','pbkdf2:sha256:600000$0FVqMbZ1Xaapqp0L$ad2a8f911353f7eb31dde6b18b241b86c119a2dba4eae6551973133f20dd8c25','test666@gmail.com','test666',NULL,NULL,NULL,'customer'),(64,'test3333','pbkdf2:sha256:600000$hKRrMVNfYWAHzUEs$16ccb800106c976d5922520207f14f421303f9d11dd3117e591c0a4cba75cdde','test3333@gmail.com','test3333',NULL,NULL,NULL,'customer'),(67,'test123ffx','pbkdf2:sha256:600000$DANxdqic7JRkXJEG$ed4d51bf5b007f6dd6e3c5d9a6cf7b70484abbbaec968956b16cba206e15658f','admin15212@gmail.com','admin15222',NULL,'Thanh oai hà nội','292928228222','customer'),(75,'testtkxx12','testtkxx12','adminxxx@gmail.com','Lê Văn Na','2024-07-17','Hà Nội','0987271234','admin'),(82,'testtk23','pbkdf2:sha256:600000$luLP1Csnp4wuvtov$1e140186a46f42805f896247a33151f38535b98131c74b66be569660457767f8','testtk23@gmail.com','testtk23',NULL,NULL,NULL,'admin');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-07-08 16:42:51
