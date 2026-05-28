-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: May 24, 2026 at 09:32 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `chakki_db1`
--

-- --------------------------------------------------------

--
-- Table structure for table `admin_users`
--

CREATE TABLE `admin_users` (
  `id` int(11) NOT NULL,
  `username` varchar(80) NOT NULL,
  `password_hash` varchar(256) NOT NULL,
  `full_name` varchar(120) DEFAULT NULL,
  `email` varchar(120) DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  `last_login` datetime DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `admin_users`
--

INSERT INTO `admin_users` (`id`, `username`, `password_hash`, `full_name`, `email`, `is_active`, `last_login`, `created_at`) VALUES
(1, 'admin', 'pbkdf2:sha256:1000000$BzCDqrINzKLHeyTA$29bde37b58c29b27c2a7a7121b872eec39d94c62a9196397b7fbae186ed45cc2', 'Admin User', 'admin@chakkipremium.com', 1, '2026-05-22 17:19:08', '2026-05-09 14:49:43');

-- --------------------------------------------------------

--
-- Table structure for table `carts`
--

CREATE TABLE `carts` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `variant_id` int(11) NOT NULL,
  `quantity` int(11) NOT NULL DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `carts`
--

INSERT INTO `carts` (`id`, `user_id`, `variant_id`, `quantity`, `created_at`, `updated_at`) VALUES
(8, 3, 1, 13, '2026-05-10 09:23:53', '2026-05-10 09:23:58');

-- --------------------------------------------------------

--
-- Table structure for table `categories`
--

CREATE TABLE `categories` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `slug` varchar(100) NOT NULL,
  `description` text DEFAULT NULL,
  `sort_order` int(11) DEFAULT 0,
  `is_active` tinyint(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `categories`
--

INSERT INTO `categories` (`id`, `name`, `slug`, `description`, `sort_order`, `is_active`) VALUES
(1, 'Premium Wheat Atta', 'premium-wheat-atta', 'Our flagship range of stone-ground whole wheat flours sourced directly from the golden wheat belts of Madhya Pradesh and Punjab. Milled fresh daily on traditional chakki stones to retain every nutrient, fibre and natural aroma of the grain.', 1, 1),
(2, 'Multigrain & Wellness', 'multigrain-wellness', 'Thoughtfully crafted multi-grain and fortified flour blends designed for health-conscious families. Each blend combines ancient grains, seeds and legumes to deliver superior nutrition, sustained energy and exceptional taste in every roti.', 2, 1),
(3, 'Millet Collection', 'millet-collection', 'A curated selection of India\'s finest single-origin millets — Bajra, Jowar, Ragi, Foxtail and more — stone-ground to a silky-smooth flour that honours centuries of traditional Indian cooking while meeting modern nutritional standards.', 3, 1),
(4, 'Traditional Regional Flours', 'traditional-regional-flours', 'Authentic heritage flours celebrating the diverse culinary traditions of India. From Rajasthani Besan to Gujarati Juvar and South Indian Rice Flour, each variety is milled true to its regional character for genuine home-kitchen flavours.', 4, 1),
(5, 'Organic & Specialty Grains', 'organic-specialty-grains', 'Certified organic and specialty grain flours for the discerning pantry. Grown without synthetic pesticides, cold-milled to preserve delicate phytonutrients, and packed in eco-conscious packaging. The purest grain-to-kitchen experience possible.', 5, 0);

-- --------------------------------------------------------

--
-- Table structure for table `footer_links`
--

CREATE TABLE `footer_links` (
  `id` int(11) NOT NULL,
  `column_name` varchar(50) NOT NULL,
  `label` varchar(100) NOT NULL,
  `url` varchar(200) NOT NULL,
  `sort_order` int(11) DEFAULT 0,
  `is_active` tinyint(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `footer_links`
--

INSERT INTO `footer_links` (`id`, `column_name`, `label`, `url`, `sort_order`, `is_active`) VALUES
(6, 'Radom Column', 'Login Link', 'http://127.0.0.1:5000/auth/login', 0, 1);

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

CREATE TABLE `orders` (
  `id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `order_number` varchar(20) NOT NULL,
  `customer_name` varchar(150) NOT NULL,
  `customer_phone` varchar(20) NOT NULL,
  `customer_email` varchar(150) DEFAULT NULL,
  `delivery_address` text NOT NULL,
  `city` varchar(100) DEFAULT NULL,
  `pincode` varchar(10) DEFAULT NULL,
  `subtotal` decimal(10,2) NOT NULL,
  `delivery_charge` decimal(10,2) DEFAULT 0.00,
  `total_amount` decimal(10,2) NOT NULL,
  `payment_method` varchar(50) DEFAULT 'COD',
  `status` enum('pending','confirmed','processing','shipped','delivered','cancelled') DEFAULT 'pending',
  `notes` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `orders`
--

INSERT INTO `orders` (`id`, `user_id`, `order_number`, `customer_name`, `customer_phone`, `customer_email`, `delivery_address`, `city`, `pincode`, `subtotal`, `delivery_charge`, `total_amount`, `payment_method`, `status`, `notes`, `created_at`, `updated_at`) VALUES
(2, NULL, 'CP260509BVHM44', 'anand', '7336463777', 'anand@gmail.com', 'wwe,reached', 'Jamnagar', '344211', 1495.00, 0.00, 1495.00, 'COD', 'confirmed', NULL, '2026-05-09 09:30:51', '2026-05-09 09:32:56'),
(3, NULL, 'CP260509GLQN5R', 'manan', '7336463777', 'anand@gmail.com', 'wwe,reached', 'Jamnagar', '344211', 558.00, 0.00, 558.00, 'COD', 'cancelled', NULL, '2026-05-09 09:31:40', '2026-05-09 09:32:58'),
(4, NULL, 'CP260509FA6QY3', 'manan', '7336463777', 'anand@gmail.com', 'wwe,reached', 'Jamnagar', '344211', 320.00, 60.00, 380.00, 'COD', 'pending', NULL, '2026-05-09 09:35:32', '2026-05-09 09:35:32'),
(5, NULL, 'CP260509897U4D', 'full name', '7336463777', 's@gmail.com', 'wwe,reached', 'Jamnagar', '344211', 320.00, 60.00, 380.00, 'COD', 'delivered', NULL, '2026-05-09 09:37:43', '2026-05-10 09:45:43'),
(6, NULL, 'CP26051009CUJ7', 'mike', '8492492833', 'mike@gmail.com', '12121, tuu', 'Jamnagar', '221232', 640.00, 0.00, 640.00, 'COD', 'delivered', 'hrkk, yit', '2026-05-10 09:20:28', '2026-05-10 09:45:50'),
(7, 3, 'CP26051088L478', 'makesome noise', '9913783138', 'make@gmail.com', 'st-12, Jamnapar, Delhi', 'Delhi', '327991', 598.00, 0.00, 598.00, 'COD', 'shipped', NULL, '2026-05-10 09:23:25', '2026-05-10 09:43:12'),
(8, NULL, 'CP260510VT9OI1', 'mike', '8492492833', 'mike@gmail.com', '123, flat-03, Piyoal Colony, Guavava Road, Elephant', '', '', 3458.00, 0.00, 3458.00, 'COD', 'pending', NULL, '2026-05-10 09:47:43', '2026-05-10 09:47:43'),
(9, NULL, 'CP260510CXMZW7', 'mike', '8492492833', 'mike@gmail.com', '1213,3dd, Po', '', '', 1860.00, 0.00, 1860.00, 'COD', 'pending', NULL, '2026-05-10 09:49:19', '2026-05-10 09:49:19'),
(10, NULL, 'CP260510YEMYM9', 'mike', '8492492833', 'mike@gmail.com', '22235,dfgd', '', '', 2900.00, 0.00, 2900.00, 'COD', 'delivered', NULL, '2026-05-10 09:50:16', '2026-05-10 09:51:41'),
(11, 4, 'CP26051050QXSU', 'ab', '8998839193', 'a@gmail.com', 'juhu, Mumbai', 'Mumbai', '381830', 299.00, 60.00, 359.00, 'COD', 'delivered', NULL, '2026-05-10 10:31:00', '2026-05-10 10:31:58'),
(12, NULL, 'CP260512SWU2F5', 'mohan', '9313121212', 'm@gmail.com', 'juhu, Mumbai', 'Mumbai', '381830', 13349.00, 0.00, 13349.00, 'COD', 'delivered', 'ss fsdf', '2026-05-12 07:17:20', '2026-05-12 07:18:35'),
(13, 4, 'CP260512ZTAVJ7', 'ab', '8998839193', 'a@gmail.com', 'juhu, Mumbai', 'Kerla', '381830', 249.00, 60.00, 309.00, 'COD', 'delivered', 'like it', '2026-05-12 07:29:51', '2026-05-12 07:33:34'),
(14, 4, 'CP260512M6R84D', 'ab', '8998839193', 'a@gmail.com', 'juhu, Mumbai', 'Mumbai', '381830', 249.00, 60.00, 309.00, 'COD', 'shipped', NULL, '2026-05-12 07:34:15', '2026-05-12 07:34:51'),
(15, 4, 'CP260516DMCQVC', 'badaca', '8998839193', 'a@gmail.com', 'jamnapar, 5792835', 'delhi', '424352', 1316.00, 0.00, 1316.00, 'COD', 'shipped', NULL, '2026-05-16 11:21:25', '2026-05-16 11:29:38'),
(16, 4, 'CP260517EZZD5Y', 'ab', '8998839193', 'a@gmail.com', 'Batak N, 727', 'Sarangpu', '492859', 279.00, 60.00, 339.00, 'COD', 'delivered', NULL, '2026-05-16 22:38:51', '2026-05-16 22:40:24'),
(17, 4, 'CP260518J0MEPY', 'ab', '8998839193', 'a@gmail.com', 'Batak N, 727', 'Sarangpu', '492859', 747.00, 0.00, 747.00, 'COD', 'pending', NULL, '2026-05-18 13:58:45', '2026-05-18 13:58:45'),
(18, 4, 'CP260520DE8BA1', 'ab', '8998839193', 'a@gmail.com', 'Batak N, 727', 'Sarangpu', '492859', 249.00, 60.00, 309.00, 'COD', 'delivered', NULL, '2026-05-20 07:11:44', '2026-05-20 07:12:56'),
(19, 4, 'CP260520M4C5HX', 'ab', '8998839193', 'a@gmail.com', 'Batak N, 727', 'Sarangpu', '492859', 319.00, 60.00, 379.00, 'COD', 'delivered', NULL, '2026-05-20 11:47:16', '2026-05-20 11:48:15'),
(20, 4, 'CP2605205CJ0AL', 'ab', '8998839193', 'a@gmail.com', 'evss  dbb rgggr', '', '', 2273.00, 0.00, 2273.00, 'COD', 'pending', NULL, '2026-05-20 12:42:13', '2026-05-20 12:42:13'),
(21, 4, 'CP260520LFQA0W', 'ab', '8998839193', 'a@gmail.com', 'rryty uututtu', '', '', 599.00, 0.00, 599.00, 'COD', 'pending', NULL, '2026-05-20 12:42:48', '2026-05-20 12:42:48'),
(22, 4, 'CP260520U0XQM6', 'ab', '8998839193', 'a@gmail.com', '769 7uhujfu', '', '', 727.00, 0.00, 727.00, 'COD', 'pending', NULL, '2026-05-20 12:43:17', '2026-05-20 12:43:17'),
(23, 4, 'CP260522BZCHI6', 'ab', '8998839193', 'a@gmail.com', 'bajra road, gayhu gali, juvar park, chokha nagar', 'Kerla', '381830', 349.00, 60.00, 409.00, 'COD', 'delivered', 'heyy', '2026-05-22 11:43:57', '2026-05-22 11:45:25'),
(24, 4, 'CP260522CO9SA5', 'ab', '8998839193', 'a@gmail.com', 'Batak N, 727', 'Sarangpu', '492859', 349.00, 60.00, 409.00, 'COD', 'pending', NULL, '2026-05-22 11:46:08', '2026-05-22 11:46:08'),
(25, 4, 'CP260522WKMQWM', 'ab', '8998839193', 'a@gmail.com', 'Batak N, 727', 'Sarangpu', '492859', 528.00, 0.00, 528.00, 'COD', 'pending', NULL, '2026-05-22 11:46:47', '2026-05-22 11:46:47'),
(26, 4, 'CP260522P0XKY9', 'ab', '8998839193', 'a@gmail.com', 'Batak N, 727', 'Sarangpu', '492859', 249.00, 60.00, 309.00, 'COD', 'pending', NULL, '2026-05-22 11:47:00', '2026-05-22 11:47:00');

-- --------------------------------------------------------

--
-- Table structure for table `order_items`
--

CREATE TABLE `order_items` (
  `id` int(11) NOT NULL,
  `order_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `variant_id` int(11) NOT NULL,
  `product_name` varchar(200) DEFAULT NULL,
  `variant_label` varchar(50) DEFAULT NULL,
  `quantity` int(11) NOT NULL,
  `unit_price` decimal(10,2) NOT NULL,
  `subtotal` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `order_items`
--

INSERT INTO `order_items` (`id`, `order_id`, `product_id`, `variant_id`, `product_name`, `variant_label`, `quantity`, `unit_price`, `subtotal`) VALUES
(2, 2, 2, 3, 'Premium Sharbati', '5 kg', 5, 299.00, 1495.00),
(3, 3, 3, 5, 'Multigrain Atta', '5 kg', 2, 279.00, 558.00),
(4, 4, 4, 7, 'Classic Sharbati Atta', '5 kg', 1, 320.00, 320.00),
(5, 5, 4, 7, 'Classic Sharbati Atta', '5 kg', 1, 320.00, 320.00),
(6, 6, 4, 7, 'Classic Sharbati Atta', '5 kg', 2, 320.00, 640.00),
(7, 7, 2, 3, 'Premium Sharbati', '5 kg', 2, 299.00, 598.00),
(8, 8, 3, 5, 'Multigrain Atta', '5 kg', 2, 279.00, 558.00),
(9, 8, 2, 11, 'Premium Sharbati', '50 kg', 1, 2900.00, 2900.00),
(10, 9, 4, 8, 'Classic Sharbati Atta', '10 kg', 3, 620.00, 1860.00),
(11, 10, 2, 11, 'Premium Sharbati', '50 kg', 1, 2900.00, 2900.00),
(12, 11, 2, 3, 'Premium Sharbati', '5 kg', 1, 299.00, 299.00),
(13, 12, 2, 3, 'Premium Sharbati', '5 kg', 1, 299.00, 299.00),
(14, 12, 2, 10, 'Premium Sharbati', '25 kg', 9, 1450.00, 13050.00),
(15, 13, 1, 1, 'Classic Wheat Atta', '5 kg', 1, 249.00, 249.00),
(16, 14, 1, 1, 'Classic Wheat Atta', '5 kg', 1, 249.00, 249.00),
(17, 15, 1, 1, 'Classic Wheat Atta', '5 kg', 4, 249.00, 996.00),
(18, 15, 4, 7, 'Classic Sharbati Atta', '5 kg', 1, 320.00, 320.00),
(19, 16, 3, 5, 'Multigrain Atta', '5 kg', 1, 279.00, 279.00),
(20, 17, 1, 1, 'Classic Wheat Atta', '5 kg', 3, 249.00, 747.00),
(21, 18, 1, 1, 'Classic Wheat Atta', '5 kg', 1, 249.00, 249.00),
(22, 19, 3, 5, 'Saath Anaaj Multigrain Atta', '5 kg', 1, 319.00, 319.00),
(23, 20, 1, 1, 'Sharbati Gold Chakki Atta', '5 kg', 4, 349.00, 1396.00),
(24, 20, 3, 5, 'Saath Anaaj Multigrain Atta', '5 kg', 1, 319.00, 319.00),
(25, 20, 4, 7, 'Diabetic Care Atta Blend', '5 kg', 2, 279.00, 558.00),
(26, 21, 3, 17, 'Saath Anaaj Multigrain Atta', '10 kg', 1, 599.00, 599.00),
(27, 22, 1, 1, 'Sharbati Gold Chakki Atta', '5 kg', 1, 349.00, 349.00),
(28, 22, 104, 207, 'Premium Chakki Fresh Atta', '5 kg', 1, 279.00, 279.00),
(29, 22, 109, 219, 'Pearl Millet Bajra Flour', '1 kg', 1, 99.00, 99.00),
(30, 23, 1, 1, 'Sharbati Gold Chakki Atta', '5 kg', 1, 349.00, 349.00),
(31, 24, 1, 1, 'Sharbati Gold Chakki Atta', '5 kg', 1, 349.00, 349.00),
(32, 25, 2, 3, 'Classic MP Whole Wheat Atta', '5 kg', 1, 249.00, 249.00),
(33, 25, 104, 207, 'Premium Chakki Fresh Atta', '5 kg', 1, 279.00, 279.00),
(34, 26, 2, 3, 'Classic MP Whole Wheat Atta', '5 kg', 1, 249.00, 249.00);

-- --------------------------------------------------------

--
-- Table structure for table `order_reviews`
--

CREATE TABLE `order_reviews` (
  `id` int(11) NOT NULL,
  `order_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `rating` int(11) NOT NULL,
  `review_text` text NOT NULL,
  `created_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `order_reviews`
--

INSERT INTO `order_reviews` (`id`, `order_id`, `user_id`, `rating`, `review_text`, `created_at`) VALUES
(1, 11, 4, 4, 'Just A Test', '2026-05-12 05:30:03'),
(2, 13, 4, 2, 'Just a test', '2026-05-12 13:05:32'),
(3, 16, 4, 5, '123321123321', '2026-05-17 04:11:09');

-- --------------------------------------------------------

--
-- Table structure for table `process_steps`
--

CREATE TABLE `process_steps` (
  `id` int(11) NOT NULL,
  `step_number` int(11) NOT NULL,
  `title` varchar(100) NOT NULL,
  `description` text DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `process_steps`
--

INSERT INTO `process_steps` (`id`, `step_number`, `title`, `description`, `is_active`) VALUES
(1, 1, 'Source Premium Wheat', 'Directly from certified farms in MP and Punjab.', 1),
(2, 2, 'Clean and Sort', 'Triple cleaned to remove dust, husk and impurities.', 1),
(3, 3, 'Stone Mill Fresh', 'Ground on traditional chakki stones at low temperature.', 1),
(4, 4, 'Pack and Deliver', 'Sealed same day and dispatched to your doorstep.', 1);

-- --------------------------------------------------------

--
-- Table structure for table `products`
--

CREATE TABLE `products` (
  `id` int(11) NOT NULL,
  `category_id` int(11) DEFAULT NULL,
  `name` varchar(200) NOT NULL,
  `slug` varchar(200) NOT NULL,
  `short_desc` varchar(300) DEFAULT NULL,
  `subtitle` varchar(300) DEFAULT NULL,
  `offer_label` varchar(100) DEFAULT NULL,
  `stock_label` varchar(100) DEFAULT NULL,
  `delivery_text` varchar(200) DEFAULT NULL,
  `freshness_text` varchar(200) DEFAULT NULL,
  `highlights` text DEFAULT NULL,
  `weight_label` varchar(100) DEFAULT NULL,
  `size_label_text` varchar(100) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `emoji` varchar(10) DEFAULT 'U0001F33E',
  `image_filename` varchar(255) DEFAULT NULL,
  `badge` varchar(50) DEFAULT NULL,
  `badge_color` varchar(20) DEFAULT '#4A7C59',
  `is_active` tinyint(1) DEFAULT 1,
  `is_featured` tinyint(1) DEFAULT 0,
  `sort_order` int(11) DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `products`
--

INSERT INTO `products` (`id`, `category_id`, `name`, `slug`, `short_desc`, `subtitle`, `offer_label`, `stock_label`, `delivery_text`, `freshness_text`, `highlights`, `weight_label`, `size_label_text`, `description`, `emoji`, `image_filename`, `badge`, `badge_color`, `is_active`, `is_featured`, `sort_order`, `created_at`) VALUES
(1, 1, 'Sharbati Gold Chakki Atta', 'sharbati-gold-chakki-atta', 'India\'s finest MP Sharbati wheat, stone-ground fresh daily for cloud-soft rotis that stay pliable for hours.', 'MP Sharbati Wheat | Traditional Chakki Ground | Zero Additives', 'Save 17% Today', 'In Stock — Ships Today', 'Free delivery on orders above Rs.500. Express dispatch within 24 hrs.', 'Milled this morning. Best consumed within 45 days of milling date printed on pack.', 'Single-origin MP Sharbati wheat|Stone-ground at low temperature|High protein 12.5g per 100g|No bleaching agents or maida|Soft rotis that stay fresh for 8+ hours|FSSAI certified facility|Resealable freshness-lock packaging', 'Available in 5 kg, 10 kg & 25 kg', 'Choose Pack Size', 'Sharbati Gold Chakki Atta is the crown jewel of our premium wheat collection. We source only the finest Sharbati variety wheat from the fertile black-soil farms of Sehore, Madhya Pradesh — a region celebrated across India for producing the world\'s most flavourful wheat grains.\r\n\r\nOur traditional stone-grinding process operates at ambient temperature, ensuring that the bran, germ and endosperm are milled together as nature intended. This means your atta retains its full complement of dietary fibre, B-vitamins, iron and natural wheat oils — nutrients that industrial roller mills strip away.\r\n\r\nThe result is a golden, fragrant flour with a naturally sweet undertone that makes rotis that are soft, elastic and perfectly puffed on the tawa. Chapatis made from Sharbati Gold remain pliable for hours, making them ideal for packed lunch boxes and long meals. The flour also performs beautifully for parathas, puris, theplas and whole-wheat bread.\r\n\r\nEvery batch is triple-cleaned before milling to remove dust, husk fragments and foreign matter. We test each batch for moisture, ash content and protein level in our in-house quality lab before it reaches your kitchen. Zero preservatives, zero bleaching agents, zero compromises.', '🌾', NULL, 'Bestseller', '#c8922a', 1, 1, 1, '2026-05-09 14:49:43'),
(2, 1, 'Classic MP Whole Wheat Atta', 'classic-mp-whole-wheat-atta', 'Everyday whole wheat flour from premium MP wheat farms, freshly chakki-ground for wholesome family nutrition.', 'Whole Wheat | Daily Nutrition | Family Pack Available', 'Buy 10 kg, Save Rs.60', 'In Stock — Ready to Ship', 'Free delivery above Rs.500. Delivered in 24–48 hours.', 'Ground fresh. Seal date printed on pack. Consume within 60 days.', 'Premium MP whole wheat|100% whole grain — bran intact|Rich in dietary fibre 11g per 100g|No maida blending|Soft golden rotis every time|Suitable for diabetic-friendly diets|Available in bulk packs for families', 'Available in 5 kg, 10 kg & 25 kg', 'Choose Pack Size', 'Classic MP Whole Wheat Atta brings the nourishing goodness of undivided whole wheat to your daily table. Unlike blended commercial brands that mix refined maida into their atta, every gram of Classic MP is 100% whole wheat — bran, germ and all — for maximum fibre, minerals and sustained energy release.\r\n\r\nSourced from carefully selected farms across the Narmada valley in Madhya Pradesh, the wheat grains are cleaned three times through vibrating sieves and aspirators before entering our chakki. Our stone-grinding wheels rotate at a controlled speed to build minimal heat, keeping the flour temperature below 35°C throughout the process. This low-temperature milling preserves heat-sensitive B-vitamins and the natural wheat aroma that makes fresh chakki atta so distinctive.\r\n\r\nThe flour yields rotis with a warm, golden hue and a mildly nutty flavour that pairs beautifully with any sabzi, dal or curry. It is equally at home in chapati, paratha, puri, thepla, or wholesome wheat-based snacks. The consistent protein level (11g per 100g) gives good gluten development for elastic, pliable dough that is easy to roll thin.\r\n\r\nPacked in food-grade, moisture-barrier bags to lock in freshness from mill to kitchen.', '🌾', NULL, 'Daily Pick', '#4a7c59', 1, 0, 2, '2026-05-09 14:49:43'),
(3, 2, 'Saath Anaaj Multigrain Atta', 'saath-anaaj-multigrain-atta', 'A precision-blended 7-grain flour — wheat, oats, ragi, soy, maize, barley and flaxseed — for complete family nutrition.', '7 Grains | Complete Nutrition | High Fibre', 'Save 15% on 10 kg Pack', 'In Stock — Ships Today', 'Free delivery above Rs.500. Dispatched within 24 hours.', 'Blended and packed fresh. Best before 60 days from packing date on pack.', 'Precision 7-grain blend|Wheat, oats, ragi, soy, maize, barley and flaxseed|Protein-rich 14g per 100g|Omega-3 from flaxseed|High dietary fibre 13g per 100g|Low GI energy release|No artificial fortification — real whole grain nutrition', 'Available in 5 kg & 10 kg', 'Choose Pack Size', 'Saath Anaaj Multigrain Atta is our most celebrated wellness product — a meticulously researched blend of seven whole grains that work synergistically to deliver nutrition that no single grain can provide alone.\r\n\r\nThe seven grains are: whole wheat (the base — familiar flavour and gluten structure), rolled oats (soluble beta-glucan fibre for cholesterol management), finger millet / ragi (exceptional calcium and iron), soy flour (complete plant protein with all essential amino acids), maize flour (natural carotenoids for eye health), hulled barley (prebiotic fibre for gut health) and ground golden flaxseed (plant-sourced omega-3 fatty acids and lignans).\r\n\r\nEach grain is sourced, cleaned and milled or processed individually at its optimum particle size before being blended in our precise recipe ratios. This ensures that each ingredient is at its nutritional best when the grains come together — a meaningful difference compared to brands that blend grains before milling.\r\n\r\nThe resulting atta has a beautifully complex, nutty-earthy flavour with a satisfying density. Rotis are slightly darker than plain wheat atta, have a pleasant chew and a fragrance that makes the kitchen smell like a traditional chakki. Children generally love the flavour, and parents love what\'s inside.', '🌿', NULL, 'Bestseller', '#4a7c59', 1, 0, 7, '2026-05-09 14:49:43'),
(4, 2, 'Diabetic Care Atta Blend', 'diabetic-care-atta-blend', 'Low GI flour blend with methi, karela and barley — specially formulated to support healthy blood-sugar management.', 'Low GI | Blood Sugar Support | Clinician-Recommended', 'Special Health Pack Price', 'In Stock', 'Ships within 24 hours. Free delivery above Rs.500.', 'Blended fresh to order. Store cool and dry. Best within 45 days of opening.', 'Low glycaemic index blend|Contains fenugreek (methi) seed powder|Bitter gourd (karela) extract|High barley beta-glucan content|Protein 13g per 100g|Approved by consulting diabetologists|Mild, pleasant taste despite functional ingredients', 'Available in 2 kg & 5 kg', 'Choose Pack Size', 'Diabetic Care Atta Blend is a rigorously formulated functional flour designed in consultation with nutritionists and diabetologists to support healthy blood-glucose management as part of a balanced diet. It is not a medicine — but it is the smartest flour a person managing diabetes or prediabetes can choose.\r\n\r\nThe base is a whole wheat and dehusked barley blend chosen for the highest available beta-glucan content — a soluble fibre that forms a viscous gel in the gut, slowing carbohydrate absorption and blunting post-meal blood-glucose spikes. To this we add precisely measured fenugreek (methi) seed powder, which contains 4-hydroxyisoleucine — an amino acid studied for its role in improving insulin sensitivity. A controlled quantity of bitter gourd (karela) extract contributes polypeptide-P and charantin, compounds associated with glucose regulation in traditional Ayurvedic medicine.\r\n\r\nDespite its functional ingredient list, this atta has a mild, pleasant, slightly earthy taste. Rotis are soft, have a subtle herbal fragrance and pair naturally with dal, sabzi or yoghurt without tasting medicinal. The protein content of 13g per 100g supports satiety and reduces the need for frequent snacking.\r\n\r\nEach batch is tested for glycaemic index before release. Certified FSSAI. Recommended as a dietary supplement — not a replacement for medical treatment.', '🌿', NULL, 'Clinician Pick', '#3a7d44', 1, 0, 8, '2026-05-09 09:33:54'),
(104, 1, 'Premium Chakki Fresh Atta', 'premium-chakki-fresh-atta', 'Consistently fine, soft and fresh — our premium all-purpose chakki atta for everyday family cooking at its best.', 'Fine Ground | Soft Rotis | Family Value Packs', 'Best Value — Bulk Packs Available', 'In Stock — High Volume', 'Same-day dispatch on orders before 2 PM. Free above Rs.500.', 'Milled and packed same day. Freshness guaranteed up to 60 days from packing.', 'Premium whole wheat blend|Finely ground for soft rotis|Consistent quality batch to batch|High absorption dough — less water needed|Rotis stay soft 6+ hours|Ideal for large families|Available in 5 kg, 10 kg, 25 kg and 50 kg sacks', 'Available in 5 kg, 10 kg, 25 kg & 50 kg', 'Choose Pack Size', 'Premium Chakki Fresh Atta is our most versatile and consistently popular flour — the go-to choice for large families, hostel kitchens and catering operations that demand reliable quality at scale. We blend carefully selected wheat varieties from MP and Punjab to achieve a flour with balanced protein, absorption and extensibility that produces soft, pillowy rotis every single time — regardless of who is making them.\r\n\r\nThe blend is refined through multiple cleaning stages and stone-ground to a consistently fine particle size that hydrates quickly and evenly. The dough comes together in minutes, requires less water than coarser-ground flours, and is forgiving to roll — even for beginner cooks. Chapatis puff beautifully on the tawa and remain soft and flexible for six or more hours after cooking.\r\n\r\nWe offer this flour in generous pack sizes up to 50 kg, making it the most economical choice per kilogram for larger households. Each sack is packed in double-layer, food-grade woven polypropylene with an inner moisture barrier to protect freshness through long storage. The packing date and best-before window are clearly printed on every bag for full transparency.\r\n\r\nThis is the flour that tens of thousands of Indian families trust to start their morning — because a great day begins with a great roti.', '🌾', NULL, 'Family Value', '#4a7c59', 1, 1, 6, '2026-05-20 02:30:00'),
(105, 2, 'Protein Plus High-Protein Atta', 'protein-plus-high-protein-atta', 'Power-packed flour blend with chickpea, soy and quinoa for athletes, gym-goers and active families.', 'High Protein 20g/100g | Gym-Friendly | Clean Label', '10% Off on First Order', 'In Stock — Ready to Ship', 'Dispatched within 24 hours. Free delivery above Rs.500.', 'Freshly blended and packed. Best within 45 days. Refrigerate after opening in summer.', 'Ultra-high protein 20g per 100g|Chickpea flour for complete amino acids|Soy protein for muscle recovery|Quinoa for all essential amino acids|Low in simple carbohydrates|No artificial protein isolate added|Suitable for vegetarians and vegans', 'Available in 2 kg & 5 kg', 'Choose Pack Size', 'Protein Plus High-Protein Atta is engineered for active individuals who want the tradition of a roti with the nutrition of a protein shake. By blending whole wheat with high-protein chickpea flour (besan), soy flour and finely ground quinoa, we have created a flour that delivers 20g of complete protein per 100g — nearly double what plain wheat atta provides.\r\n\r\nThe chickpea flour contributes the amino acids that wheat is deficient in, particularly lysine, creating a protein that is more nutritionally complete than either grain alone. The soy flour layer adds branched-chain amino acids (BCAAs) — leucine, isoleucine and valine — that are critical for muscle protein synthesis and recovery after training. Quinoa, though used in smaller proportions, brings all nine essential amino acids and a suite of antioxidant phytonutrients.\r\n\r\nThe atta produces rotis with a slightly denser texture than plain wheat atta and a pleasantly earthy, nutty flavour that grows on you quickly. It behaves well on the tawa without crumbling and is equally excellent made into high-protein wraps, stuffed parathas or protein pancakes. Athletes typically replace their morning meal with two large rotis from Protein Plus and report staying full for 4–5 hours.\r\n\r\nNo artificial protein powder, no isolates, no fillers — just whole food ingredients, stone-ground and blended with care.', '🌿', NULL, 'Fitness Pick', '#2d6a4f', 1, 1, 9, '2026-05-20 02:30:00'),
(109, 3, 'Pearl Millet Bajra Flour', 'pearl-millet-bajra-flour', 'Fresh stone-ground Bajra flour from Rajasthan\'s premium pearl millet farms. Traditional rotis and theplas.', 'Rajasthani Bajra | Stone Ground | Gluten Free', 'Save 12% — Buy 2 Packs', 'In Stock — Ships Today', 'Free delivery above Rs.500. Dispatched within 24 hours.', 'Stone-ground fresh from whole Bajra grains. Best within 30 days of opening.', 'Premium Rajasthani pearl millet|Naturally gluten-free|Rich in iron 8mg per 100g|High magnesium and phosphorus|Warming energy — ideal for winters|Traditional Rajasthani bajre ki roti|No sieving — full bran retained', 'Available in 1 kg, 2 kg & 5 kg', 'Choose Pack Size', 'Pearl Millet Bajra Flour is a winter staple beloved across Rajasthan, Haryana and Gujarat for centuries — and our chakki-ground version brings that tradition to your table with full nutritional integrity intact. We source the finest Rajasthani pearl millet, distinguished by its larger grain size, superior iron content and naturally earthy aroma.\r\n\r\nBajra is naturally gluten-free, making it an excellent choice for those with gluten sensitivity or celiac disease. It is extraordinarily rich in iron (8mg per 100g — nearly half the daily adult requirement), magnesium, phosphorus and B-vitamins. Traditional wisdom holds that bajra generates body heat — making bajra rotis the perfect warming meal during India\'s cold winter months, especially eaten with ghee and gud (jaggery).\r\n\r\nOur bajra flour is stone-ground from whole, uncleaned bajra grains with the outer bran fully retained. We do not sieve out any bran fraction, which is how the full fibre, mineral and antioxidant content is preserved. The flour is slightly coarser than wheat atta, which is traditional and necessary for properly textured bajre ki roti.\r\n\r\nBajra roti requires a slightly different technique — typically hand-patted rather than rolled with a belan — and our flour produces the authentic smoky, earthy taste that Rajasthani families have known for generations. It is equally excellent for bajra khichdi, bajra soup and traditional tilli bajra laddoos.', '🌾', NULL, 'Gluten Free', '#8b6914', 1, 0, 13, '2026-05-20 02:30:00'),
(110, 3, 'Finger Millet Ragi Flour', 'finger-millet-ragi-flour', 'South India\'s beloved Ragi, chakki-ground to a silky flour. Highest calcium of any grain — naturally.', 'Karnataka Ragi | Highest Calcium | Baby Food Safe', 'Nutrition Pack — Best Value', 'In Stock', 'Delivered in 24–48 hours. Free above Rs.500.', 'Stone-milled fresh. Packed in airtight seal. Best within 45 days of opening.', 'Highest calcium grain — 344mg per 100g|More calcium than milk per calorie|Rich in iron, zinc and antioxidants|Naturally gluten-free|Safe and recommended for babies from 6 months|Traditional Ragi mudde, dosa and porridge|Deep reddish-brown colour — 100% natural', 'Available in 1 kg & 2 kg', 'Choose Pack Size', 'Finger Millet Ragi Flour is sourced from the red laterite hillside farms of Karnataka and Tamil Nadu — the heartland of India\'s finest ragi cultivation. Ragi is nothing short of a nutritional miracle: it contains more calcium per 100g than any other grain on earth, and more calcium per calorie than cow\'s milk. At 344mg of calcium per 100g, it is an exceptional dietary calcium source for vegetarians, vegans, lactose-intolerant individuals and growing children.\r\n\r\nRagi is also remarkably rich in iron (3.9mg per 100g), zinc, polyphenol antioxidants and the amino acid methionine — rare in plant foods. Its protein quality is superior to most other millets, and its high tannin and phytate content, while reducing some mineral absorption if consumed raw, is largely neutralised by cooking, fermentation or sprouting.\r\n\r\nOur ragi flour is stone-ground to a fine, consistent texture that is suitable for a wide range of traditional South Indian preparations: ragi mudde (Kannada staple), ragi dosa and idli batter, ragi roti (a Chettinad speciality), ragi sankati and ragi ambali (cooling summer porridge). It is also widely used to make ragi porridge for infants from 6 months, as it is naturally gluten-free and easy to digest.\r\n\r\nThe flour has a characteristic deep reddish-brown colour and a pleasantly earthy, slightly tannic flavour that mellows beautifully when paired with ghee, jaggery, coconut or yoghurt.', '🌾', NULL, 'Calcium Rich', '#8d4e1c', 1, 0, 14, '2026-05-20 02:30:00'),
(114, 3, 'Mixed Millet Powerhouse Atta', 'mixed-millet-powerhouse-atta', 'Five millets in one blend — Bajra, Ragi, Jowar, Foxtail and Little Millet — for maximum millet nutrition.', '5-Millet Blend | Complete Millet Nutrition | Everyday Use', 'Save 18% on 5 kg Pack', 'In Stock', 'Dispatched within 24 hours. Free delivery above Rs.500.', 'Freshly blended and milled. Resealable pack. Best within 45 days of opening.', 'Five complete millets in one flour|Bajra for iron, Ragi for calcium|Jowar for gut health, Foxtail for B-vitamins|Little Millet for easy digestion|Naturally gluten-free blend|All-day sustained energy|Ideal for millet beginners and enthusiasts alike', 'Available in 2 kg & 5 kg', 'Choose Pack Size', 'Mixed Millet Powerhouse Atta is the perfect introduction to millet cooking for families who know they should eat more millets but find it challenging to buy and use five different flours simultaneously. We have done the research, sourced all five varieties and blended them in a nutritionally optimised ratio that delivers the unique benefits of each millet in a single, convenient flour.\r\n\r\nThe blend: Pearl millet Bajra (25%) for its outstanding iron content and warming energy; Finger millet Ragi (25%) for unmatched calcium and antioxidants; Sorghum Jowar (20%) for resistant starch and gut-microbiome support; Foxtail millet (20%) for B-vitamins and low glycaemic response; and Little millet Kutki (10%) for its light digestibility and cooling properties.\r\n\r\nThe resulting flour is naturally gluten-free and produces rotis with a pleasantly complex earthy flavour and a slightly dense, chewy texture that is characteristic of millet breads — nutritionally rich, deeply satisfying and quite unlike any wheat roti you have eaten. We recommend adding 20–30% plain wheat atta for beginners who find 100% millet roti too crumbly to handle initially.\r\n\r\nThe all-day sustained energy release from the low-GI millet blend makes this an outstanding choice for lunch rotis — keeping you full and energised through the afternoon without a blood-sugar crash.', '🌾', NULL, 'Millet Power', '#6d8b74', 1, 0, 18, '2026-05-20 02:30:00'),
(115, 4, 'Premium Besan Chickpea Flour', 'premium-besan-chickpea-flour', 'Stone-ground Chana Dal besan from Rajasthan\'s finest chickpeas. Silky texture for perfect pakoras and kadhi.', 'Rajasthani Chana Dal | Fine Ground | Zero Lumps', 'Best Besan in India — Our Promise', 'In Stock — Ships Today', 'Free delivery above Rs.500. Dispatched within 24 hours.', 'Stone-ground fresh from premium chana dal. Best within 90 days.', 'Premium Bengal gram chana dal|Stone-ground for silky smooth texture|Rich protein 22g per 100g|Zero lumping — consistent fineness|Natural yellow colour — no colour added|Authentic pakora, kadhi and halwa base|Batch-tested for fineness and moisture', 'Available in 1 kg & 2 kg', 'Choose Pack Size', 'Premium Besan Chickpea Flour is the flour that separates an ordinary pakora from a legendary one. Made exclusively from the finest split Bengal gram (chana dal) sourced from the dry-farming districts of Rajasthan and Haryana, our besan is stone-ground to a particle size that is consistently finer and more uniform than the roller-milled besan available in most supermarkets.\r\n\r\nThe difference shows immediately when you make the batter: our besan dissolves into water without lumps, creates a batter with superior viscosity and adhesion, and fries to a crispier, more golden coating that holds its crunch longer after coming out of the oil. Kadhis made with our besan are thicker, creamier and more flavourful. Besan halwa has a deeper golden colour and a richer, nuttier taste. Dhokla and khaman ferment and steam to a fluffier, spongier texture.\r\n\r\nThe nutritional profile is exceptional — 22g of protein per 100g, high fibre, rich in iron and folate, and a low glycaemic index that makes besan one of the most nutritionally dense legume-derived flours available. It is naturally gluten-free, making it a versatile flour for those avoiding wheat.\r\n\r\nEach batch is tested for moisture content and particle fineness in our quality lab before packing. The natural warm-yellow colour comes entirely from the chana dal — we never add turmeric or food colouring.', '🌿', NULL, 'Kitchen Star', '#d4a017', 1, 0, 19, '2026-05-20 02:30:00'),
(116, 4, 'Traditional Rajasthani Bajre Ki Bari', 'rajasthani-bajra-coarse-flour', 'Coarse-ground Bajra flour in traditional Rajasthani style — for authentic bhakri, rotla and winter thalis.', 'Coarse Ground | Authentic Rajasthan | Winter Staple', 'Heritage Village Recipe Pack', 'Seasonal — In Stock', 'Ships within 24–48 hours. Free delivery above Rs.500.', 'Coarse-ground to traditional consistency. Best within 30 days of opening.', 'Coarse-grind traditional style|From Barmer and Jodhpur district bajra|Maximum bran for intense nutrition|Authentic earthy smoky flavour|Traditional bajre ki roti hand-pat technique|Pairs with ker sangri and lahsun chutney|Seasonal grain — October harvest', 'Available in 1 kg & 2 kg', 'Choose Pack Size', 'Rajasthani Bajre Ki Bari is not the same as our standard fine-ground bajra flour. This is a deliberately coarse-ground preparation in the style demanded by traditional Rajasthani village kitchens — where bajra roti (also called rotla) is made by hand-patting the dough onto a flat stone or brass thali, with no rolling pin involved, and cooked on a wood-fire or gas tawa with a rougher, smokier character than any roller-milled bajra product can deliver.\r\n\r\nWe source this bajra exclusively from the districts of Barmer and Jodhpur in Rajasthan — desert-grown bajra that develops exceptional flavour intensity from the extreme dry heat and sandy soil of the Thar. The grains are cleaned and coarse-ground on our chakki stones in a single slow pass that preserves large bran particles and retains the robust texture that Rajasthani cooks expect.\r\n\r\nThe resulting flour is darker than standard bajra flour, visibly coarser, and intensely aromatic when water is added to the dough — with a characteristic smoky, earthy scent that evokes Rajasthani village cooking. Rotlas made from this flour have a thick, dense, crumbly texture (unlike wheat roti) and an assertive, satisfying flavour that pairs perfectly with ker sangri sabzi, lahsun ki chutney and a generous pour of desi ghee.\r\n\r\nThis is not everyday flour — it is festival, heritage and comfort food for anyone who grew up in Rajasthan or loves authentic regional Indian cooking.', '🌾', NULL, 'Regional Pride', '#c46a00', 1, 0, 20, '2026-05-20 02:30:00'),
(118, 4, 'Gujarati Juvar Flour', 'gujarati-juvar-flour', 'White jowar flour milled Gujarati-style for rotla, dhebra and traditional winter thali dishes.', 'Gujarati Rotla | Winter Warmth | Stone Ground', 'Traditional Gujarat Recipe Pack', 'In Stock', 'Dispatched within 24 hours. Free delivery above Rs.500.', 'Stone-ground fresh. Airtight packed. Best within 45 days of opening.', 'Gujarat white jowar selection|Traditional rotla flour consistency|Richer in fibre than wheat atta|Natural sweet undertone|Soft, pliable rotla on clay tawa|Pairs with bajra and methi dhebra|High iron and magnesium content', 'Available in 1 kg & 2 kg', 'Choose Pack Size', 'Gujarati Juvar Flour is white jowar milled to the particular consistency that Gujarati home cooks expect for making traditional rotla — the thick, soft, wholesome flatbread that has been the backbone of the Gujarati winter meal for generations. While the grain is botanically the same as Maharashtrian jowar, we source a specific white jowar variety grown in Saurashtra and North Gujarat that has a subtler, slightly sweeter flavour profile than the darker Vidarbha varieties — making it distinctly suited to Gujarati rotla rather than Maharashtrian bhakri.\r\n\r\nThe milling is calibrated for medium-fine consistency — coarser than besan but finer than bajra flour — which gives the dough the right balance of cohesion and coarseness for hand-patting rotlas that hold together without cracking while remaining thick and rustic in character. The flour produces rotlas with a warm ivory-white colour, a gentle earthy aroma and a naturally mild sweetness that makes them ideal for pairing with the sweet-sour flavours of Gujarati dal and vegetable dishes.\r\n\r\nJuvar rotla is traditionally cooked on a clay tawa (matlo) over a moderate flame, which gives it a slightly smoky, charred-edge character. On a regular iron tawa it also performs beautifully with minimal practice. The flour is naturally gluten-free and rich in iron (2.7mg per 100g) and magnesium — supporting bone health and energy metabolism.\r\n\r\nAlso excellent for traditional Gujarati bajra-methi na dhebra (flatbreads with fenugreek leaves and millet) and juvar khichdi.', '🌾', NULL, 'Gujarat Special', '#f0a500', 1, 0, 22, '2026-05-20 02:30:00'),
(121, 5, 'Certified Organic Wheat Atta', 'certified-organic-wheat-atta', 'NPOP-certified 100% organic wheat flour — zero pesticides, zero synthetic fertilisers, zero compromises.', 'NPOP Certified Organic | Zero Pesticide | Premium Clean Label', 'Certified Organic — Premium Pricing', 'In Stock', 'Ships within 24 hours. Free delivery above Rs.500.', 'Certified batch. Seal date on pack. Best within 45 days. Store cool and dry.', 'NPOP India certified organic|Zero synthetic pesticide residue|No chemical fertilisers in soil|Regenerative farm practices|Stone-ground in dedicated organic mill|Separate storage — no cross-contamination|Certificate number on every pack', 'Available in 1 kg, 2 kg & 5 kg', 'Choose Pack Size', 'Certified Organic Wheat Atta is our flagship clean-label product — a flour for customers who demand full transparency, verified provenance and absolute freedom from synthetic chemical residues in the food they feed their families.\r\n\r\nEvery grain that goes into this flour is sourced from farms that have been certified organic under India\'s National Programme for Organic Production (NPOP) — the government-administered certification system that ensures farms have been free from synthetic pesticides and chemical fertilisers for a minimum of three years before certification. The certification number is printed on every pack so you can trace exactly which farms contributed to your flour.\r\n\r\nOur organic wheat is processed in a separate, dedicated section of our mill with independent storage bins, separate cleaning equipment and dedicated chakki stones that never contact non-organic grain. This prevents cross-contamination, which is a meaningful concern in many facilities that claim to produce organic flour without true separation protocols.\r\n\r\nThe farming practices on our partner organic farms go beyond mere certification compliance — they practise crop rotation, cover cropping, composting and natural pest management techniques that actively improve soil health over time. The result is wheat grown in genuinely living soil, with a richer natural flavour profile that many customers describe as noticeably more aromatic and complex than conventional wheat.\r\n\r\nThe flour produces soft, flavourful rotis with the authentic whole-wheat taste that comes from grain grown in healthy, microbe-rich soil. Every batch is tested for pesticide residues in an accredited third-party laboratory.', '🌿', NULL, 'Certified Organic', '#2ecc71', 1, 1, 25, '2026-05-20 02:30:00'),
(122, 5, 'Organic Amaranth Rajgira Flour', 'organic-amaranth-rajgira-flour', 'Cold-milled organic Rajgira flour — India\'s sacred fasting grain with complete amino acids and exceptional calcium.', 'Navratri Vrat | Complete Protein | Gluten Free', 'Navratri Festival Pack', 'In Stock', 'Dispatched within 24 hours. Free delivery above Rs.500.', 'Cold-milled organic. Airtight packed. Best within 45 days. Refrigerate in summer.', 'Certified organic amaranth|Complete protein — all 9 essential amino acids|High calcium 159mg per 100g|Rich in lysine (rare in grains)|Naturally gluten-free|Traditional Navratri vrat (fasting) grain|Approved by FSSAI for vrat foods', 'Available in 500g & 1 kg', 'Choose Pack Size', 'Organic Amaranth Rajgira Flour holds a unique place in Indian food culture as the grain of sacred fasting — consumed during Navratri, Ekadashi and other religious fasting periods when cereals (grains defined as grains) are avoided. Amaranth, botanically a seed rather than a true grain, is permissible during Hindu vrats and is traditionally used to make rajgira ki roti, rajgira halwa, rajgira laddoo and rajgira kheer.\r\n\r\nBeyond its cultural significance, amaranth is nutritionally remarkable in ways that make it stand apart from virtually every other plant food. It is one of the very few plant sources that contains all nine essential amino acids in nutritionally meaningful quantities — making it a complete protein by the same standard as meat or eggs. This is extraordinarily rare in the plant kingdom and makes rajgira flour an outstanding protein source for vegetarians and vegans.\r\n\r\nIts lysine content deserves special mention — lysine is the amino acid most deficient in cereal grains, which is why plant-based diets often struggle with protein quality. Amaranth\'s high lysine content makes it an ideal complement to any grain-based diet. Its calcium level of 159mg per 100g is also impressive for a grain, supporting bone health across all age groups.\r\n\r\nWe source certified organic amaranth from partner farms in Maharashtra and Rajasthan and cold-mill it to preserve the delicate unsaturated fatty acids and heat-sensitive lysine content. The flour has a pleasant, slightly earthy, mild flavour that is easy to work with and pairs beautifully with sweetened preparations involving jaggery, ghee and nuts.', '🌿', NULL, 'Vrat Special', '#8e44ad', 1, 0, 26, '2026-05-20 02:30:00'),
(124, 5, 'Organic Cold-Pressed Flaxseed Meal', 'organic-cold-pressed-flaxseed-meal', 'Freshly cold-milled organic golden flaxseed meal — the richest plant source of Omega-3 ALA and lignans.', 'Omega-3 ALA | Lignan Rich | Add to Any Flour', 'Nutrition Booster — Add to Your Atta', 'In Stock', 'Dispatched within 24 hours. Free delivery above Rs.500.', 'Cold-milled organic. Airtight nitrogen-flushed pack. Refrigerate after opening. Best within 21 days.', 'Certified organic golden flaxseed|Highest plant-source Omega-3 ALA 22g per 100g|Rich in SDG lignans — hormonal balance|High soluble fibre for gut health|Cold-milled to preserve delicate ALA|Add 1–2 tbsp to any atta for omega boost|Nutty, pleasant flavour — invisible in rotis', 'Available in 250g & 500g', 'Choose Pack Size', 'Organic Cold-Pressed Flaxseed Meal is not a flour in the traditional sense — it is a nutritional supplement in meal form that we produce for our customers who want to enhance the omega-3 fatty acid content of their everyday rotis without any perceptible change in taste or texture.\r\n\r\nFlaxseed is the single richest plant-source of alpha-linolenic acid (ALA) — the plant-form omega-3 fatty acid — providing 22g of ALA per 100g of meal. While ALA must be converted to EPA and DHA (the more directly usable omega-3 forms) in the body, flaxseed\'s high concentration ensures meaningful conversion even at the body\'s modest conversion rate. Nutritionists broadly recommend 1–2 tablespoons of ground flaxseed daily as a practical, affordable way to increase plant-based omega-3 intake.\r\n\r\nFlaxseed is also the world\'s richest dietary source of lignans — a class of phytoestrogens that have been extensively studied for their role in hormonal balance, particularly in supporting oestrogen metabolism in peri-menopausal and menopausal women, and for their association with reduced breast cancer risk in population studies.\r\n\r\nThe key requirement for bioavailability is that flaxseed must be ground before consumption — whole flaxseeds pass through the digestive system largely undigested. We cold-mill our organic golden flaxseed and nitrogen-flush the packs immediately after milling to prevent the highly unsaturated ALA from oxidising. After opening, refrigerate and consume within 21 days for maximum freshness.\r\n\r\nSimply add 1–2 tablespoons to your daily atta while kneading. The flavour is mild and nutty — practically undetectable in a chapati.', '🌱', NULL, 'Omega Boost', '#27ae60', 1, 0, 28, '2026-05-20 02:30:00');

-- --------------------------------------------------------

--
-- Table structure for table `product_images`
--

CREATE TABLE `product_images` (
  `id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `filename` varchar(255) NOT NULL,
  `alt_text` varchar(200) DEFAULT NULL,
  `is_primary` tinyint(1) DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT NULL,
  `sort_order` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `product_images`
--

INSERT INTO `product_images` (`id`, `product_id`, `filename`, `alt_text`, `is_primary`, `is_active`, `sort_order`, `created_at`) VALUES
(160, 1, '154ac5f3e6e04f8eacfbcbbeb348cfd0.webp', 'Sharbati Gold Chakki Atta', 1, 1, 0, '2026-05-20 17:42:43'),
(161, 2, '0e502d0154fa44c2ade948ada95eebfb.webp', 'Classic MP Whole Wheat Atta', 1, 1, 0, '2026-05-20 17:43:02'),
(162, 104, 'fa26905ceb224407b2a3550b788d6852.webp', 'Premium Chakki Fresh Atta', 1, 1, 0, '2026-05-20 17:43:22'),
(163, 3, 'dda9e8cb395a4e53b23f8ccc63896450.webp', 'Saath Anaaj Multigrain Atta', 1, 1, 0, '2026-05-20 17:43:49'),
(164, 3, '570b7c3c64a144c7b40b68b89fddfed6.webp', 'Saath Anaaj Multigrain Atta', 0, 1, 1, '2026-05-20 17:44:02'),
(165, 3, 'b82f2902a7bb49b98ddbf8712483e968.webp', 'Saath Anaaj Multigrain Atta', 0, 1, 2, '2026-05-20 17:44:02'),
(166, 3, 'b55e55dbaa3a4120946e98daed506496.webp', 'Saath Anaaj Multigrain Atta', 0, 1, 3, '2026-05-20 17:44:02'),
(167, 3, '0d666e7b56c94d1b8246d4a815cdc834.webp', 'Saath Anaaj Multigrain Atta', 0, 1, 4, '2026-05-20 17:44:02'),
(168, 3, 'a3a13a51910b4bf290600af7b626c93a.webp', 'Saath Anaaj Multigrain Atta', 0, 1, 5, '2026-05-20 17:44:02'),
(169, 3, 'ecfab8724da34e1bb9892e9e9a26a21b.webp', 'Saath Anaaj Multigrain Atta', 0, 1, 6, '2026-05-20 17:44:02'),
(170, 4, '5f2fcca435bb44618a46cf546c79b26d.webp', 'Diabetic Care Atta Blend', 1, 1, 0, '2026-05-20 17:44:41'),
(171, 4, '8548af2f50c54266b00358fa82b292d8.webp', 'Diabetic Care Atta Blend', 0, 1, 1, '2026-05-20 17:44:49'),
(172, 4, '15f11b6e99924244b885937aab21f381.webp', 'Diabetic Care Atta Blend', 0, 1, 2, '2026-05-20 17:44:49'),
(173, 4, '962fbd5528c9480cb354c59a0e18ea35.webp', 'Diabetic Care Atta Blend', 0, 1, 3, '2026-05-20 17:44:49'),
(174, 4, '7ac1cc5871d74a47bf46ec5b8bddeb0d.webp', 'Diabetic Care Atta Blend', 0, 1, 4, '2026-05-20 17:44:49'),
(175, 4, '8ca4c1bb571349e382d0876ca1948649.webp', 'Diabetic Care Atta Blend', 0, 1, 5, '2026-05-20 17:44:49'),
(176, 105, 'b319e68262344c68a2a5b5179b1961ca.webp', 'Protein Plus High-Protein Atta', 1, 1, 0, '2026-05-20 17:45:50'),
(177, 105, 'fc600d54f4b843bf9a7309c050b46cb8.webp', 'Protein Plus High-Protein Atta', 0, 1, 1, '2026-05-20 17:45:50'),
(178, 105, '3e66e2ad4d56447caeec6cb958d62008.webp', 'Protein Plus High-Protein Atta', 0, 1, 2, '2026-05-20 17:45:50'),
(179, 105, '350dfb46ce3448ddaada039d24f97ff7.webp', 'Protein Plus High-Protein Atta', 0, 1, 3, '2026-05-20 17:45:50'),
(180, 105, 'c74af2e267fb4c79930693dfee874d7e.webp', 'Protein Plus High-Protein Atta', 0, 1, 4, '2026-05-20 17:45:50'),
(181, 105, 'd7695ba185a04c4dbe4339cb18600ba7.webp', 'Protein Plus High-Protein Atta', 0, 1, 5, '2026-05-20 17:45:50'),
(182, 109, 'aa2ef7c5cb914c608e40f9b4adb58935.webp', 'Pearl Millet Bajra Flour', 1, 1, 0, '2026-05-20 17:46:16'),
(183, 109, '1df8b9720b6a400695e7c07a2b2908a6.webp', 'Pearl Millet Bajra Flour', 0, 1, 1, '2026-05-20 17:46:23'),
(184, 109, 'b0576dfbff754124a90c56c19db5c8b6.webp', 'Pearl Millet Bajra Flour', 0, 1, 2, '2026-05-20 17:46:23'),
(185, 109, 'c435ed3f1f9f4e1ba8e37baba1a7101b.webp', 'Pearl Millet Bajra Flour', 0, 1, 3, '2026-05-20 17:46:23'),
(186, 109, 'c557d6cca73e4a929dec72cdec5d42c5.webp', 'Pearl Millet Bajra Flour', 0, 1, 4, '2026-05-20 17:46:23'),
(187, 109, '8c5b23b408184489b38ee439bd59a0e9.webp', 'Pearl Millet Bajra Flour', 0, 1, 5, '2026-05-20 17:46:23'),
(188, 110, '4bbb0395c0bc42dbb098dd74d2ab663a.webp', 'Finger Millet Ragi Flour', 1, 1, 0, '2026-05-20 17:46:48'),
(189, 110, 'f6e90d20f17649819c9a04fdb11aa1f8.webp', 'Finger Millet Ragi Flour', 0, 1, 1, '2026-05-20 17:46:59'),
(190, 110, '4977c52820844dfba513ff38f9d096a1.webp', 'Finger Millet Ragi Flour', 0, 1, 2, '2026-05-20 17:46:59'),
(191, 110, 'c630c58c56d34a2fbb54f37c6e01b82e.webp', 'Finger Millet Ragi Flour', 0, 1, 3, '2026-05-20 17:46:59'),
(192, 110, 'c084a224d5d8445eb583040bde878e3c.webp', 'Finger Millet Ragi Flour', 0, 1, 4, '2026-05-20 17:46:59'),
(194, 114, '48b0ccf37af24277930afb154ede4e0f.webp', 'Mixed Millet Powerhouse Atta', 1, 1, 0, '2026-05-20 17:47:51'),
(195, 1, 'e5ac3a25f8ef4fa98fd405f9e08df432.webp', 'Sharbati Gold Chakki Atta', 0, 1, 1, '2026-05-20 17:49:04'),
(196, 1, '98110597a7fa4e2298d9f451dabd5255.webp', 'Sharbati Gold Chakki Atta', 0, 1, 2, '2026-05-20 17:49:04'),
(197, 1, 'bdc8f0209b334012a043822cb9e6dcdb.webp', 'Sharbati Gold Chakki Atta', 0, 1, 3, '2026-05-20 17:49:04'),
(198, 1, '45c114a0574048b48c51585728dd971d.webp', 'Sharbati Gold Chakki Atta', 0, 1, 4, '2026-05-20 17:49:04'),
(199, 1, '4b94e9c2d68b480481927183049af7f7.webp', 'Sharbati Gold Chakki Atta', 0, 1, 5, '2026-05-20 17:49:04'),
(200, 2, 'b68418c2f01a49dab646a7c44dc86105.webp', 'Classic MP Whole Wheat Atta', 0, 1, 1, '2026-05-20 17:49:19'),
(201, 2, '9cf922b1dbcd4beeb686398fa6073bbf.webp', 'Classic MP Whole Wheat Atta', 0, 1, 2, '2026-05-20 17:49:19'),
(202, 2, 'a183a8d77a894f59aa3964c4524a97b8.webp', 'Classic MP Whole Wheat Atta', 0, 1, 3, '2026-05-20 17:49:19'),
(203, 104, '53269d74855545cf80d1c47070affe04.webp', 'Premium Chakki Fresh Atta', 0, 1, 1, '2026-05-20 17:49:32'),
(204, 104, 'b930b5b5bb694e8d987bb752a6cb3db9.webp', 'Premium Chakki Fresh Atta', 0, 1, 2, '2026-05-20 17:49:32'),
(205, 104, '3a874851056f4b91ac2b71fc921bd152.webp', 'Premium Chakki Fresh Atta', 0, 1, 3, '2026-05-20 17:49:32'),
(206, 104, '54a97d7827924b049d5671c5100957a9.webp', 'Premium Chakki Fresh Atta', 0, 1, 4, '2026-05-20 17:49:32'),
(207, 114, '4ffcc8ee9ab845b3b7ff7e264db13a30.webp', 'Mixed Millet Powerhouse Atta', 0, 1, 1, '2026-05-20 17:49:59'),
(208, 114, 'e56e236b36284edfa753ac158dda04f6.webp', 'Mixed Millet Powerhouse Atta', 0, 1, 2, '2026-05-20 17:49:59'),
(209, 114, '62a8906185b04a06bc5b1f044811d869.webp', 'Mixed Millet Powerhouse Atta', 0, 1, 3, '2026-05-20 17:49:59'),
(210, 114, '2396b4b66dd14ad2ab5cc606608862ce.webp', 'Mixed Millet Powerhouse Atta', 0, 1, 4, '2026-05-20 17:49:59'),
(211, 115, '5c99be312d994448a7542a38266565f6.webp', 'Premium Besan Chickpea Flour', 1, 1, 0, '2026-05-20 17:50:22'),
(212, 115, '61ec4f63f92a414ba6dd43115aa840e0.webp', 'Premium Besan Chickpea Flour', 0, 1, 1, '2026-05-20 17:50:27'),
(213, 115, '56365badf4d444bda4f815f5ae9e4640.webp', 'Premium Besan Chickpea Flour', 0, 1, 2, '2026-05-20 17:50:27'),
(214, 115, '758b13327da74035bf9f52da2a7d564b.webp', 'Premium Besan Chickpea Flour', 0, 1, 3, '2026-05-20 17:50:27'),
(215, 115, '544bfaafdcb642828c3e075d1fe9c847.webp', 'Premium Besan Chickpea Flour', 0, 1, 4, '2026-05-20 17:50:33'),
(216, 124, '65219a8e2bb945b9bbdb0bed3365ec73.webp', 'Organic Cold-Pressed Flaxseed Meal', 1, 1, 0, '2026-05-20 17:51:16'),
(217, 124, 'bc28d1f1958b4de2beaa604b1dbc27dc.webp', 'Organic Cold-Pressed Flaxseed Meal', 0, 1, 1, '2026-05-20 17:51:16'),
(218, 124, '23f6d13d5e1744a9a678315fab8f7277.webp', 'Organic Cold-Pressed Flaxseed Meal', 0, 1, 2, '2026-05-20 17:51:16'),
(219, 124, '4cbf6c59bf2d49149b8797ac82ce6682.webp', 'Organic Cold-Pressed Flaxseed Meal', 0, 1, 3, '2026-05-20 17:51:16'),
(220, 124, '8e7d3fc4fece427eaeac0805c698b485.webp', 'Organic Cold-Pressed Flaxseed Meal', 0, 1, 4, '2026-05-20 17:51:16'),
(221, 122, '7d1ff5a18d394c76a8e71332cd45be2c.webp', 'Organic Amaranth Rajgira Flour', 1, 1, 0, '2026-05-20 17:51:37'),
(222, 122, 'b5d2a108965345cdb37b6356e66f9e36.webp', 'Organic Amaranth Rajgira Flour', 0, 1, 1, '2026-05-20 17:51:42'),
(223, 122, 'c3e61403b20d42c6a16fb473955d8a2e.webp', 'Organic Amaranth Rajgira Flour', 0, 1, 2, '2026-05-20 17:51:42'),
(224, 122, '9711cb9ef70245cb87a15415cafc46bf.webp', 'Organic Amaranth Rajgira Flour', 0, 1, 3, '2026-05-20 17:51:42'),
(225, 122, '9869ceee8b6342e69c9c6ca7172d59a6.webp', 'Organic Amaranth Rajgira Flour', 0, 1, 4, '2026-05-20 17:51:42'),
(226, 121, '87c19671bac245afbff514bc6e2f43f3.webp', 'Certified Organic Wheat Atta', 1, 1, 0, '2026-05-20 17:52:02'),
(227, 121, '23c9900470c649d1a4aa8e233c701b43.webp', 'Certified Organic Wheat Atta', 0, 1, 1, '2026-05-20 17:52:08'),
(228, 121, '370da15bd4134af4b803bedda399a615.webp', 'Certified Organic Wheat Atta', 0, 1, 2, '2026-05-20 17:52:08'),
(229, 121, 'b14b87901b5742338d761d2675ada818.webp', 'Certified Organic Wheat Atta', 0, 1, 3, '2026-05-20 17:52:08'),
(230, 121, '4ca5012a7202434d93efaba43ee05af7.webp', 'Certified Organic Wheat Atta', 0, 1, 4, '2026-05-20 17:52:08'),
(231, 121, '96c224e7b6a44c83ba6e045b7d366459.webp', 'Certified Organic Wheat Atta', 0, 1, 5, '2026-05-20 17:52:08'),
(232, 121, '72a92c0609d04e928c3e1fe52d902ee0.webp', 'Certified Organic Wheat Atta', 0, 1, 6, '2026-05-20 17:52:08'),
(233, 118, '132522346b5542719211aff03715f40a.webp', 'Gujarati Juvar Flour', 1, 1, 0, '2026-05-20 17:52:40'),
(234, 118, '729a5551f1f4457eaeb34815f832affe.webp', 'Gujarati Juvar Flour', 0, 1, 1, '2026-05-20 17:52:46'),
(235, 118, '9d14e3e18ac44f7999167129981087e9.webp', 'Gujarati Juvar Flour', 0, 1, 2, '2026-05-20 17:52:46'),
(236, 118, 'e101da8fa1c148029744caade53d2b62.webp', 'Gujarati Juvar Flour', 0, 1, 3, '2026-05-20 17:52:46'),
(237, 118, 'd6fb9e1271334738b7c5b45e92a71130.webp', 'Gujarati Juvar Flour', 0, 1, 4, '2026-05-20 17:52:46'),
(238, 115, '5695eddf52264e98bbaa13c5750629e1.webp', 'Premium Besan Chickpea Flour', 0, 1, 5, '2026-05-20 17:52:59'),
(239, 116, 'a65174a4d8bb4396abeb9cb7ec59a38f.webp', 'Traditional Rajasthani Bajre Ki Bari', 1, 1, 0, '2026-05-20 17:53:17'),
(240, 116, '0bab6083b1114858ace426d4d01f7cca.webp', 'Traditional Rajasthani Bajre Ki Bari', 0, 1, 1, '2026-05-20 17:53:22'),
(241, 116, '47f23ea8a9aa4122b6ec057f144c3871.webp', 'Traditional Rajasthani Bajre Ki Bari', 0, 1, 2, '2026-05-20 17:53:22'),
(242, 116, '6a62b314047f4bfb8252090025825bdd.webp', 'Traditional Rajasthani Bajre Ki Bari', 0, 1, 3, '2026-05-20 17:53:22'),
(243, 116, 'd31bbbdb1f034ea29f1d53c81692f6be.webp', 'Traditional Rajasthani Bajre Ki Bari', 0, 1, 4, '2026-05-20 17:53:22');

-- --------------------------------------------------------

--
-- Table structure for table `product_related`
--

CREATE TABLE `product_related` (
  `id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `related_id` int(11) NOT NULL,
  `sort_order` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `product_related`
--

INSERT INTO `product_related` (`id`, `product_id`, `related_id`, `sort_order`) VALUES
(333, 4, 105, 0),
(334, 4, 3, 1),
(335, 3, 4, 0),
(336, 3, 105, 1),
(340, 105, 124, 0),
(341, 105, 3, 1),
(342, 109, 110, 0),
(343, 109, 114, 1),
(344, 109, 116, 2),
(350, 1, 2, 0),
(351, 1, 104, 1),
(359, 114, 110, 0),
(360, 114, 109, 1),
(362, 124, 121, 0),
(363, 124, 105, 1),
(364, 122, 121, 0),
(365, 121, 122, 0),
(366, 121, 124, 1),
(367, 121, 1, 2),
(368, 2, 104, 0),
(369, 2, 3, 1),
(370, 2, 1, 2),
(375, 118, 109, 0),
(377, 116, 114, 0),
(378, 116, 109, 1),
(379, 115, 110, 0),
(380, 110, 114, 0),
(381, 110, 122, 1),
(382, 110, 109, 2),
(383, 104, 2, 0),
(384, 104, 4, 1),
(385, 104, 3, 2),
(386, 104, 1, 3);

-- --------------------------------------------------------

--
-- Table structure for table `product_variants`
--

CREATE TABLE `product_variants` (
  `id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `size_label` varchar(50) NOT NULL,
  `weight_kg` decimal(5,2) DEFAULT NULL,
  `price` decimal(10,2) NOT NULL,
  `mrp` decimal(10,2) DEFAULT NULL,
  `stock_qty` int(11) DEFAULT 100,
  `is_default` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `product_variants`
--

INSERT INTO `product_variants` (`id`, `product_id`, `size_label`, `weight_kg`, `price`, `mrp`, `stock_qty`, `is_default`) VALUES
(1, 1, '5 kg', 5.00, 349.00, 420.00, 200, 1),
(3, 2, '5 kg', 5.00, 249.00, 299.00, 250, 1),
(5, 3, '5 kg', 5.00, 319.00, 389.00, 150, 1),
(7, 4, '5 kg', 5.00, 279.00, 349.00, 100, 1),
(8, 4, '10 kg', 10.00, 529.00, 799.00, 60, 0),
(10, 2, '25 kg', 25.00, 1099.00, 1349.00, 80, 0),
(11, 2, '50 kg', 50.00, 1999.00, 2499.00, 30, 0),
(14, 1, '10 kg', 10.00, 669.00, 810.00, 120, 0),
(15, 1, '25 kg', 25.00, 1549.00, 1899.00, 60, 0),
(16, 2, '10 kg', 10.00, 469.00, 569.00, 150, 0),
(17, 3, '10 kg', 10.00, 599.00, 749.00, 90, 0),
(18, 4, '2 kg', 2.00, 279.00, 349.00, 100, 0),
(207, 104, '5 kg', 5.00, 279.00, 329.00, 300, 1),
(208, 104, '10 kg', 10.00, 529.00, 629.00, 200, 0),
(209, 104, '25 kg', 25.00, 1199.00, 1449.00, 100, 0),
(210, 104, '50 kg', 50.00, 2199.00, 2699.00, 40, 0),
(211, 105, '2 kg', 2.00, 299.00, 369.00, 100, 1),
(212, 105, '5 kg', 5.00, 699.00, 869.00, 60, 0),
(219, 109, '1 kg', 1.00, 99.00, 129.00, 200, 1),
(220, 109, '2 kg', 2.00, 189.00, 239.00, 150, 0),
(221, 109, '5 kg', 5.00, 449.00, 569.00, 80, 0),
(222, 110, '1 kg', 1.00, 119.00, 149.00, 200, 1),
(223, 110, '2 kg', 2.00, 219.00, 279.00, 120, 0),
(232, 114, '2 kg', 2.00, 249.00, 309.00, 120, 1),
(233, 114, '5 kg', 5.00, 569.00, 699.00, 80, 0),
(234, 115, '1 kg', 1.00, 149.00, 189.00, 200, 1),
(235, 115, '2 kg', 2.00, 279.00, 349.00, 120, 0),
(236, 116, '1 kg', 1.00, 119.00, 149.00, 100, 1),
(237, 116, '2 kg', 2.00, 219.00, 279.00, 60, 0),
(241, 118, '1 kg', 1.00, 99.00, 129.00, 150, 1),
(242, 118, '2 kg', 2.00, 189.00, 239.00, 80, 0),
(248, 121, '1 kg', 1.00, 149.00, 189.00, 150, 1),
(249, 121, '2 kg', 2.00, 279.00, 349.00, 100, 0),
(250, 121, '5 kg', 5.00, 649.00, 799.00, 60, 0),
(251, 122, '500 g', 0.50, 149.00, 189.00, 100, 1),
(252, 122, '1 kg', 1.00, 279.00, 349.00, 60, 0),
(255, 124, '250 g', 0.25, 149.00, 189.00, 100, 1),
(256, 124, '500 g', 0.50, 269.00, 339.00, 60, 0);

-- --------------------------------------------------------

--
-- Table structure for table `settings`
--

CREATE TABLE `settings` (
  `id` int(11) NOT NULL,
  `key_name` varchar(100) NOT NULL,
  `value` text DEFAULT NULL,
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `settings`
--

INSERT INTO `settings` (`id`, `key_name`, `value`, `updated_at`) VALUES
(1, 'site_name', 'Chakki Premium', '2026-05-09 14:49:43'),
(2, 'contact_phone', '+91 98765 43210', '2026-05-09 14:49:43'),
(3, 'contact_email', 'hello@chakkipremium.com', '2026-05-09 14:49:43'),
(4, 'contact_address', 'Mill District, Jamnagar, Gujarat 361008', '2026-05-09 14:49:43'),
(5, 'free_delivery_above', '500', '2026-05-09 14:49:43'),
(6, 'delivery_charge', '60', '2026-05-09 14:49:43'),
(7, 'delivery_hours', '24-48', '2026-05-09 14:49:43'),
(8, 'hero_badge', 'Stone-Ground - Chemical-Free - Home Delivery', '2026-05-09 14:49:43'),
(9, 'hero_headline', 'Pure Chakki Atta', '2026-05-09 14:49:43'),
(10, 'hero_headline_italic', 'Straight from the Mill', '2026-05-09 14:49:43'),
(11, 'hero_subtext', 'Traditional stone-ground wheat flour, freshly milled with zero additives.', '2026-05-09 14:49:43'),
(12, 'hero_stat_1_num', '50K+', '2026-05-09 14:49:43'),
(13, 'hero_stat_1_label', 'Happy Families', '2026-05-09 14:49:43'),
(14, 'hero_stat_2_num', '100%', '2026-05-09 14:49:43'),
(15, 'hero_stat_2_label', 'Chemical Free', '2026-05-09 14:49:43'),
(16, 'hero_stat_3_num', '24hr', '2026-05-09 14:49:43'),
(17, 'hero_stat_3_label', 'Fresh Delivery', '2026-05-09 14:49:43'),
(18, 'trust_badges', 'FSSAI Certified,ISO 22000,No Preservatives', '2026-05-09 14:49:43'),
(19, 'why_title', 'The Chakki Difference', '2026-05-09 14:49:43'),
(20, 'why_subtitle', 'We bring back the goodness of traditional stone-ground atta with modern hygiene standards.', '2026-05-09 14:49:43'),
(21, 'process_title', 'Farm to Your Kitchen in 4 Steps', '2026-05-09 14:49:43'),
(22, 'process_subtitle', 'Full transparency — from golden wheat to your table.', '2026-05-09 14:49:43'),
(23, 'sticky_bar_text', 'Fresh batch milled today! Order before 2pm for same-day dispatch.', '2026-05-09 14:49:43'),
(24, 'footer_tagline', 'Pure, freshly milled chakki atta delivered across India.', '2026-05-09 14:49:43'),
(25, 'footer_copyright', '2026 Chakki Premium. All rights reserved.', '2026-05-09 14:49:43'),
(26, 'meta_description', 'Buy fresh stone-ground chakki atta online. Chemical-free, home delivery.', '2026-05-09 14:49:43');

-- --------------------------------------------------------

--
-- Table structure for table `testimonials`
--

CREATE TABLE `testimonials` (
  `id` int(11) NOT NULL,
  `reviewer_name` varchar(100) NOT NULL,
  `reviewer_city` varchar(100) DEFAULT NULL,
  `avatar_initial` varchar(1) DEFAULT NULL,
  `rating` int(11) DEFAULT 5,
  `review_text` text NOT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  `sort_order` int(11) DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `testimonials`
--

INSERT INTO `testimonials` (`id`, `reviewer_name`, `reviewer_city`, `avatar_initial`, `rating`, `review_text`, `is_active`, `sort_order`, `created_at`) VALUES
(1, 'Priya Sharma', 'Mumbai', 'P', 5, 'Best atta I have ever tasted! Rotis stay soft for hours.', 1, 1, '2026-05-09 14:49:43'),
(2, 'Rahul Mehta', 'Delhi', 'R', 5, 'Switched from branded atta - never going back. Pure and fresh!', 1, 2, '2026-05-09 14:49:43'),
(3, 'Anita Patel', 'Ahmedabad', 'A', 5, 'My family loves the multigrain. Healthy and delicious.', 1, 3, '2026-05-09 14:49:43');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `email` varchar(150) NOT NULL,
  `password_hash` varchar(256) NOT NULL,
  `full_name` varchar(150) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `last_login` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `email`, `password_hash`, `full_name`, `phone`, `is_active`, `created_at`, `last_login`) VALUES
(3, 'make@gmail.com', 'pbkdf2:sha256:1000000$o9JO6dDjoX0OYlk8$35b17bbdfa5a309aead458ff20da5476447c7f7b9977116fae08291dc9865692', 'makesome noise', '9913783138', 1, '2026-05-10 09:22:12', '2026-05-10 15:13:35'),
(4, 'a@gmail.com', 'pbkdf2:sha256:1000000$H1gD1ekqFbxQtRLc$4b2dc513d72ff4b476b1c0a8d2d23817d019db97d6314138776484137a9fc485', 'ab', '8998839193', 1, '2026-05-10 10:30:24', '2026-05-22 17:17:50');

-- --------------------------------------------------------

--
-- Table structure for table `user_addresses`
--

CREATE TABLE `user_addresses` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `label` varchar(60) DEFAULT NULL,
  `full_name` varchar(150) NOT NULL,
  `phone` varchar(20) NOT NULL,
  `address_line` text NOT NULL,
  `city` varchar(100) DEFAULT NULL,
  `pincode` varchar(10) DEFAULT NULL,
  `is_default` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `user_addresses`
--

INSERT INTO `user_addresses` (`id`, `user_id`, `label`, `full_name`, `phone`, `address_line`, `city`, `pincode`, `is_default`, `created_at`, `updated_at`) VALUES
(1, 4, 'Home', 'ab', '8998839193', 'bajra road, gayhu gali, juvar park, chokha nagar', 'Kerla', '381830', 0, '2026-05-16 16:48:10', '2026-05-16 16:50:13'),
(2, 4, 'Office', 'ab', '8998839193', 'juhu, Mumbai', 'Mumabai', '318492', 0, '2026-05-16 16:49:03', '2026-05-16 16:50:03'),
(3, 4, 'garden', 'ab', '8998839193', 'Batak N, 727', 'Sarangpu', '492859', 1, '2026-05-16 16:49:59', '2026-05-16 16:50:03');

-- --------------------------------------------------------

--
-- Table structure for table `why_cards`
--

CREATE TABLE `why_cards` (
  `id` int(11) NOT NULL,
  `icon` varchar(10) NOT NULL,
  `title` varchar(100) NOT NULL,
  `description` text DEFAULT NULL,
  `sort_order` int(11) DEFAULT 0,
  `is_active` tinyint(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `why_cards`
--

INSERT INTO `why_cards` (`id`, `icon`, `title`, `description`, `sort_order`, `is_active`) VALUES
(1, '🌾', 'Stone Ground', 'Traditional chakki method preserves natural nutrients and fibre.', 1, 1),
(2, '🚫', 'Zero Chemicals', 'No bleaching agents, preservatives or artificial additives.', 2, 1),
(3, '🏭', 'Milled Fresh Daily', 'Milled every morning and dispatched same day.', 3, 1),
(4, '🚚', 'Free Home Delivery', 'Free delivery on orders above Rs.500 across India.', 4, 1);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `admin_users`
--
ALTER TABLE `admin_users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`);

--
-- Indexes for table `carts`
--
ALTER TABLE `carts`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_cart_user_variant` (`user_id`,`variant_id`),
  ADD KEY `variant_id` (`variant_id`);

--
-- Indexes for table `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `slug` (`slug`);

--
-- Indexes for table `footer_links`
--
ALTER TABLE `footer_links`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `order_number` (`order_number`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `order_items`
--
ALTER TABLE `order_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `order_id` (`order_id`),
  ADD KEY `product_id` (`product_id`),
  ADD KEY `variant_id` (`variant_id`);

--
-- Indexes for table `order_reviews`
--
ALTER TABLE `order_reviews`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `order_id` (`order_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `process_steps`
--
ALTER TABLE `process_steps`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `slug` (`slug`),
  ADD KEY `category_id` (`category_id`);

--
-- Indexes for table `product_images`
--
ALTER TABLE `product_images`
  ADD PRIMARY KEY (`id`),
  ADD KEY `product_id` (`product_id`);

--
-- Indexes for table `product_related`
--
ALTER TABLE `product_related`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_product_related` (`product_id`,`related_id`),
  ADD KEY `fk_pr_product` (`product_id`),
  ADD KEY `fk_pr_related` (`related_id`);

--
-- Indexes for table `product_variants`
--
ALTER TABLE `product_variants`
  ADD PRIMARY KEY (`id`),
  ADD KEY `product_id` (`product_id`);

--
-- Indexes for table `settings`
--
ALTER TABLE `settings`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `key_name` (`key_name`);

--
-- Indexes for table `testimonials`
--
ALTER TABLE `testimonials`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indexes for table `user_addresses`
--
ALTER TABLE `user_addresses`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_user_id` (`user_id`),
  ADD KEY `idx_user_default` (`user_id`,`is_default`);

--
-- Indexes for table `why_cards`
--
ALTER TABLE `why_cards`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `admin_users`
--
ALTER TABLE `admin_users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `carts`
--
ALTER TABLE `carts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=32;

--
-- AUTO_INCREMENT for table `categories`
--
ALTER TABLE `categories`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `footer_links`
--
ALTER TABLE `footer_links`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `orders`
--
ALTER TABLE `orders`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=27;

--
-- AUTO_INCREMENT for table `order_items`
--
ALTER TABLE `order_items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=35;

--
-- AUTO_INCREMENT for table `order_reviews`
--
ALTER TABLE `order_reviews`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `process_steps`
--
ALTER TABLE `process_steps`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `products`
--
ALTER TABLE `products`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=127;

--
-- AUTO_INCREMENT for table `product_images`
--
ALTER TABLE `product_images`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=244;

--
-- AUTO_INCREMENT for table `product_related`
--
ALTER TABLE `product_related`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=387;

--
-- AUTO_INCREMENT for table `product_variants`
--
ALTER TABLE `product_variants`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=261;

--
-- AUTO_INCREMENT for table `settings`
--
ALTER TABLE `settings`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=27;

--
-- AUTO_INCREMENT for table `testimonials`
--
ALTER TABLE `testimonials`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `user_addresses`
--
ALTER TABLE `user_addresses`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `why_cards`
--
ALTER TABLE `why_cards`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `carts`
--
ALTER TABLE `carts`
  ADD CONSTRAINT `carts_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `carts_ibfk_2` FOREIGN KEY (`variant_id`) REFERENCES `product_variants` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `order_items`
--
ALTER TABLE `order_items`
  ADD CONSTRAINT `order_items_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `order_items_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`),
  ADD CONSTRAINT `order_items_ibfk_3` FOREIGN KEY (`variant_id`) REFERENCES `product_variants` (`id`);

--
-- Constraints for table `order_reviews`
--
ALTER TABLE `order_reviews`
  ADD CONSTRAINT `order_reviews_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`),
  ADD CONSTRAINT `order_reviews_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `products`
--
ALTER TABLE `products`
  ADD CONSTRAINT `products_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `product_images`
--
ALTER TABLE `product_images`
  ADD CONSTRAINT `product_images_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `product_related`
--
ALTER TABLE `product_related`
  ADD CONSTRAINT `fk_pr_product` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_pr_related` FOREIGN KEY (`related_id`) REFERENCES `products` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `product_variants`
--
ALTER TABLE `product_variants`
  ADD CONSTRAINT `product_variants_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `user_addresses`
--
ALTER TABLE `user_addresses`
  ADD CONSTRAINT `fk_ua_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
