-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: May 19, 2026 at 08:29 AM
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
(1, 'admin', 'pbkdf2:sha256:1000000$BzCDqrINzKLHeyTA$29bde37b58c29b27c2a7a7121b872eec39d94c62a9196397b7fbae186ed45cc2', 'Admin User', 'admin@chakkipremium.com', 1, '2026-05-18 19:29:30', '2026-05-09 14:49:43');

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
(8, 3, 1, 13, '2026-05-10 09:23:53', '2026-05-10 09:23:58'),
(21, 4, 1, 3, '2026-05-16 11:30:32', '2026-05-18 13:58:36'),
(22, 4, 5, 1, '2026-05-16 22:38:36', '2026-05-16 22:38:36');

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
(1, 'Wheat Atta', 'wheat-atta', 'Premium stone-ground wheat flour', 1, 1),
(2, 'Bajra', 'Bajra', 'No Dicription', 5, 1);

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
(2, 1, 'CP260509BVHM44', 'anand', '7336463777', 'anand@gmail.com', 'wwe,reached', 'Jamnagar', '344211', 1495.00, 0.00, 1495.00, 'COD', 'confirmed', NULL, '2026-05-09 09:30:51', '2026-05-09 09:32:56'),
(3, 1, 'CP260509GLQN5R', 'manan', '7336463777', 'anand@gmail.com', 'wwe,reached', 'Jamnagar', '344211', 558.00, 0.00, 558.00, 'COD', 'cancelled', NULL, '2026-05-09 09:31:40', '2026-05-09 09:32:58'),
(4, NULL, 'CP260509FA6QY3', 'manan', '7336463777', 'anand@gmail.com', 'wwe,reached', 'Jamnagar', '344211', 320.00, 60.00, 380.00, 'COD', 'pending', NULL, '2026-05-09 09:35:32', '2026-05-09 09:35:32'),
(5, NULL, 'CP260509897U4D', 'full name', '7336463777', 's@gmail.com', 'wwe,reached', 'Jamnagar', '344211', 320.00, 60.00, 380.00, 'COD', 'delivered', NULL, '2026-05-09 09:37:43', '2026-05-10 09:45:43'),
(6, 2, 'CP26051009CUJ7', 'mike', '8492492833', 'mike@gmail.com', '12121, tuu', 'Jamnagar', '221232', 640.00, 0.00, 640.00, 'COD', 'delivered', 'hrkk, yit', '2026-05-10 09:20:28', '2026-05-10 09:45:50'),
(7, 3, 'CP26051088L478', 'makesome noise', '9913783138', 'make@gmail.com', 'st-12, Jamnapar, Delhi', 'Delhi', '327991', 598.00, 0.00, 598.00, 'COD', 'shipped', NULL, '2026-05-10 09:23:25', '2026-05-10 09:43:12'),
(8, 2, 'CP260510VT9OI1', 'mike', '8492492833', 'mike@gmail.com', '123, flat-03, Piyoal Colony, Guavava Road, Elephant', '', '', 3458.00, 0.00, 3458.00, 'COD', 'pending', NULL, '2026-05-10 09:47:43', '2026-05-10 09:47:43'),
(9, 2, 'CP260510CXMZW7', 'mike', '8492492833', 'mike@gmail.com', '1213,3dd, Po', '', '', 1860.00, 0.00, 1860.00, 'COD', 'pending', NULL, '2026-05-10 09:49:19', '2026-05-10 09:49:19'),
(10, 2, 'CP260510YEMYM9', 'mike', '8492492833', 'mike@gmail.com', '22235,dfgd', '', '', 2900.00, 0.00, 2900.00, 'COD', 'delivered', NULL, '2026-05-10 09:50:16', '2026-05-10 09:51:41'),
(11, 4, 'CP26051050QXSU', 'ab', '8998839193', 'a@gmail.com', 'juhu, Mumbai', 'Mumbai', '381830', 299.00, 60.00, 359.00, 'COD', 'delivered', NULL, '2026-05-10 10:31:00', '2026-05-10 10:31:58'),
(12, 5, 'CP260512SWU2F5', 'mohan', '9313121212', 'm@gmail.com', 'juhu, Mumbai', 'Mumbai', '381830', 13349.00, 0.00, 13349.00, 'COD', 'delivered', 'ss fsdf', '2026-05-12 07:17:20', '2026-05-12 07:18:35'),
(13, 4, 'CP260512ZTAVJ7', 'ab', '8998839193', 'a@gmail.com', 'juhu, Mumbai', 'Kerla', '381830', 249.00, 60.00, 309.00, 'COD', 'delivered', 'like it', '2026-05-12 07:29:51', '2026-05-12 07:33:34'),
(14, 4, 'CP260512M6R84D', 'ab', '8998839193', 'a@gmail.com', 'juhu, Mumbai', 'Mumbai', '381830', 249.00, 60.00, 309.00, 'COD', 'shipped', NULL, '2026-05-12 07:34:15', '2026-05-12 07:34:51'),
(15, 4, 'CP260516DMCQVC', 'badaca', '8998839193', 'a@gmail.com', 'jamnapar, 5792835', 'delhi', '424352', 1316.00, 0.00, 1316.00, 'COD', 'shipped', NULL, '2026-05-16 11:21:25', '2026-05-16 11:29:38'),
(16, 4, 'CP260517EZZD5Y', 'ab', '8998839193', 'a@gmail.com', 'Batak N, 727', 'Sarangpu', '492859', 279.00, 60.00, 339.00, 'COD', 'delivered', NULL, '2026-05-16 22:38:51', '2026-05-16 22:40:24'),
(17, 4, 'CP260518J0MEPY', 'ab', '8998839193', 'a@gmail.com', 'Batak N, 727', 'Sarangpu', '492859', 747.00, 0.00, 747.00, 'COD', 'pending', NULL, '2026-05-18 13:58:45', '2026-05-18 13:58:45');

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
(20, 17, 1, 1, 'Classic Wheat Atta', '5 kg', 3, 249.00, 747.00);

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
(1, 1, 'Classic Wheat Atta', 'classic-wheat-atta', 'Traditional stone-ground whole wheat flour', 'None', 'None', 'None', 'None', 'None', 'None', 'None', 'None', 'None', '🌾', NULL, 'Bestseller', '#ff0feb', 1, 1, 1, '2026-05-09 14:49:43'),
(2, 1, 'Premium Sharbati', 'premium-sharbati', 'Soft rotis from finest Sharbati wheat', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'None', '🌿', NULL, 'Premium', '#C8922A', 1, 1, 2, '2026-05-09 14:49:43'),
(3, 1, 'Multigrain Atta', 'multigrain-atta', '7-grain blend for healthy families', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '🫘', NULL, 'Healthy', '#6B7280', 1, 0, 3, '2026-05-09 14:49:43'),
(4, 2, 'Classic Sharbati Atta', 'classic-sharbati-atta', 'MP Sharbati wheat · Soft rotis · Daily use', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Q', 'OO', NULL, 'Bestseller', '#4A7C59', 1, 1, 8, '2026-05-09 09:33:54'),
(5, NULL, 'Premium Bajra', 'premium-bajra', 'Bajra · rotis · Daily use', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Bajra', '🌾', NULL, 'Premium', '#4A7C59', 1, 0, 1, '2026-05-16 22:44:23');

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
(2, 1, '47a095c6b51e464fb607950172209e8c.jpg', 'Classic Wheat Atta', 1, 1, 2, '2026-05-19 06:25:30'),
(3, 1, '2bca6b2cf97043f9af34251367117ecc.png', 'Classic Wheat Atta', 0, 1, 3, '2026-05-19 06:25:36'),
(4, 1, '0677e63bb8544911a5b8ab3824b2855a.png', 'Classic Wheat Atta', 0, 1, 4, '2026-05-19 06:25:43'),
(5, 1, '65667bf0005041acad35cca6e0a87425.jpg', 'Classic Wheat Atta', 0, 1, 1, '2026-05-19 06:25:47'),
(6, 1, '17e090412c154303917708e2426e0486.jpg', 'Classic Wheat Atta', 0, 1, 5, '2026-05-19 06:25:51'),
(7, 1, '7ea7728bd6e24a7ebb94a8cd4e2c404d.png', 'Classic Wheat Atta', 0, 1, 6, '2026-05-19 06:25:59'),
(8, 1, 'd346506ec9a54f0cb22d456b84418bb5.png', 'Classic Wheat Atta', 0, 1, 7, '2026-05-19 06:26:08'),
(9, 1, 'ac1778712b60428db9bb890033f598eb.png', 'Classic Wheat Atta', 0, 1, 8, '2026-05-19 06:26:13'),
(11, 1, '240b5c10ebcd4189961965e4f90260de.jpg', 'Classic Wheat Atta', 0, 1, 9, '2026-05-19 06:26:58'),
(12, 1, '2e63ee325e1e4b0eb0ea0b2d14284616.png', 'Classic Wheat Atta', 0, 1, 9, '2026-05-19 06:29:02');

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
(17, 1, 4, 0),
(18, 1, 3, 1),
(19, 1, 5, 2),
(20, 1, 2, 3);

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
(1, 1, '5 kg', 5.00, 249.00, 299.00, 100, 1),
(3, 2, '5 kg', 5.00, 299.00, 349.00, 100, 1),
(4, 2, '10 kg', 10.00, 569.00, 679.00, 60, 0),
(5, 3, '5 kg', 5.00, 279.00, 329.00, 100, 1),
(6, 3, '10 kg', 10.00, 529.00, 629.00, 50, 0),
(7, 4, '5 kg', 5.00, 320.00, 380.00, 100, 1),
(8, 4, '10 kg', 10.00, 620.00, 740.00, 100, 0),
(9, 4, '25 kg', 25.00, 1450.00, 1750.00, 100, 0),
(10, 2, '25 kg', 25.00, 1450.00, 1750.00, 100, 0),
(11, 2, '50 kg', 50.00, 2900.00, 3500.00, 100, 0),
(12, 5, '5 kg', 480.00, 120.00, 240.00, 100, 1),
(13, 1, '5 kg', 5.30, 3279.00, 5465.00, 87, 0);

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
(3, 'Anita Patel', 'Ahmedabad', 'A', 5, 'My family loves the multigrain. Healthy and delicious.', 1, 3, '2026-05-09 14:49:43'),
(6, 'Mansi Rao', 'Jaipur', 'M', 5, 'Just A Test !', 1, 4, '2026-05-12 00:10:36');

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
(1, 'anand@gmail.com', 'pbkdf2:sha256:1000000$kbAUgpzOqpKEVciK$7c91f62aaea1abeb69f1d5557f7e826d697e75c88c84b39d6433b2fc45c5374f', 'anand', '7862992929', 1, '2026-05-09 09:20:47', '2026-05-09 15:05:59'),
(2, 'mike@gmail.com', 'pbkdf2:sha256:1000000$VEUFps3w1BdjXpnM$d3f2b142363dc85a2afedef42476aefce6a48e00d9db9975222c26819dd85e42', 'mike', '8492492833', 1, '2026-05-09 09:47:22', '2026-05-10 15:52:57'),
(3, 'make@gmail.com', 'pbkdf2:sha256:1000000$o9JO6dDjoX0OYlk8$35b17bbdfa5a309aead458ff20da5476447c7f7b9977116fae08291dc9865692', 'makesome noise', '9913783138', 1, '2026-05-10 09:22:12', '2026-05-10 15:13:35'),
(4, 'a@gmail.com', 'pbkdf2:sha256:1000000$H1gD1ekqFbxQtRLc$4b2dc513d72ff4b476b1c0a8d2d23817d019db97d6314138776484137a9fc485', 'ab', '8998839193', 1, '2026-05-10 10:30:24', '2026-05-18 19:28:32'),
(5, 'm@gmail.com', 'pbkdf2:sha256:1000000$A7aU5EMSlCgJJWUT$659dc71ab7461b10408cad1bb3329bc7d2328dbbd1866148e4bed8997924999c', 'mohan', '9313121212', 1, '2026-05-12 00:12:02', '2026-05-12 05:42:29');

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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- AUTO_INCREMENT for table `categories`
--
ALTER TABLE `categories`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `footer_links`
--
ALTER TABLE `footer_links`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `orders`
--
ALTER TABLE `orders`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT for table `order_items`
--
ALTER TABLE `order_items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `product_images`
--
ALTER TABLE `product_images`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `product_related`
--
ALTER TABLE `product_related`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `product_variants`
--
ALTER TABLE `product_variants`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

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
