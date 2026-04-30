-- MariaDB dump 10.19  Distrib 10.4.32-MariaDB, for Win64 (AMD64)
--
-- Host: localhost    Database: market_db
-- ------------------------------------------------------
-- Server version	10.4.32-MariaDB

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `auth_group`
--

DROP TABLE IF EXISTS `auth_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auth_group` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(150) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_group`
--

LOCK TABLES `auth_group` WRITE;
/*!40000 ALTER TABLE `auth_group` DISABLE KEYS */;
INSERT INTO `auth_group` VALUES (3,'Hesap Güvenliği & Erişim Sorumlusu (accounts)'),(4,'Satış Mantığı & Finans Sorumlusu (sales)'),(2,'Ürün Yönetimi (products)');
/*!40000 ALTER TABLE `auth_group` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_group_permissions`
--

DROP TABLE IF EXISTS `auth_group_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auth_group_permissions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `group_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_group_permissions_group_id_permission_id_0cd325b0_uniq` (`group_id`,`permission_id`),
  KEY `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` (`permission_id`),
  CONSTRAINT `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `auth_group_permissions_group_id_b120cbf9_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_group_permissions`
--

LOCK TABLES `auth_group_permissions` WRITE;
/*!40000 ALTER TABLE `auth_group_permissions` DISABLE KEYS */;
INSERT INTO `auth_group_permissions` VALUES (5,2,25),(6,2,26),(7,2,27),(8,2,28),(9,2,29),(10,2,30),(11,2,31),(4,2,32),(12,3,9),(13,3,10),(14,3,11),(15,3,12),(16,3,16),(17,3,24),(18,4,33),(19,4,34),(20,4,36),(21,4,37),(22,4,40),(23,4,41);
/*!40000 ALTER TABLE `auth_group_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_permission`
--

DROP TABLE IF EXISTS `auth_permission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auth_permission` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `content_type_id` int(11) NOT NULL,
  `codename` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_permission_content_type_id_codename_01ab375a_uniq` (`content_type_id`,`codename`),
  CONSTRAINT `auth_permission_content_type_id_2f476e4b_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=49 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_permission`
--

LOCK TABLES `auth_permission` WRITE;
/*!40000 ALTER TABLE `auth_permission` DISABLE KEYS */;
INSERT INTO `auth_permission` VALUES (1,'Can add log entry',1,'add_logentry'),(2,'Can change log entry',1,'change_logentry'),(3,'Can delete log entry',1,'delete_logentry'),(4,'Can view log entry',1,'view_logentry'),(5,'Can add permission',2,'add_permission'),(6,'Can change permission',2,'change_permission'),(7,'Can delete permission',2,'delete_permission'),(8,'Can view permission',2,'view_permission'),(9,'Can add group',3,'add_group'),(10,'Can change group',3,'change_group'),(11,'Can delete group',3,'delete_group'),(12,'Can view group',3,'view_group'),(13,'Can add user',4,'add_user'),(14,'Can change user',4,'change_user'),(15,'Can delete user',4,'delete_user'),(16,'Can view user',4,'view_user'),(17,'Can add content type',5,'add_contenttype'),(18,'Can change content type',5,'change_contenttype'),(19,'Can delete content type',5,'delete_contenttype'),(20,'Can view content type',5,'view_contenttype'),(21,'Can add session',6,'add_session'),(22,'Can change session',6,'change_session'),(23,'Can delete session',6,'delete_session'),(24,'Can view session',6,'view_session'),(25,'Can add category',7,'add_category'),(26,'Can change category',7,'change_category'),(27,'Can delete category',7,'delete_category'),(28,'Can view category',7,'view_category'),(29,'Can add product',8,'add_product'),(30,'Can change product',8,'change_product'),(31,'Can delete product',8,'delete_product'),(32,'Can view product',8,'view_product'),(33,'Can add Satış',9,'add_sale'),(34,'Can change Satış',9,'change_sale'),(35,'Can delete Satış',9,'delete_sale'),(36,'Can view Satış',9,'view_sale'),(37,'Can add sale detail',10,'add_saledetail'),(38,'Can change sale detail',10,'change_saledetail'),(39,'Can delete sale detail',10,'delete_saledetail'),(40,'Can view sale detail',10,'view_saledetail'),(41,'Can add category',11,'add_category'),(42,'Can change category',11,'change_category'),(43,'Can delete category',11,'delete_category'),(44,'Can view category',11,'view_category'),(45,'Can add product',12,'add_product'),(46,'Can change product',12,'change_product'),(47,'Can delete product',12,'delete_product'),(48,'Can view product',12,'view_product');
/*!40000 ALTER TABLE `auth_permission` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_user`
--

DROP TABLE IF EXISTS `auth_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auth_user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `password` varchar(128) NOT NULL,
  `last_login` datetime(6) DEFAULT NULL,
  `is_superuser` tinyint(1) NOT NULL,
  `username` varchar(150) NOT NULL,
  `first_name` varchar(150) NOT NULL,
  `last_name` varchar(150) NOT NULL,
  `email` varchar(254) NOT NULL,
  `is_staff` tinyint(1) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `date_joined` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_user`
--

LOCK TABLES `auth_user` WRITE;
/*!40000 ALTER TABLE `auth_user` DISABLE KEYS */;
INSERT INTO `auth_user` VALUES (1,'pbkdf2_sha256$600000$oDRTttt3Uq9INmaJQmVI9y$GTwvmaZ2dh3awRCeQafVyaw87oJGZglupdtGfrxK+xs=','2026-04-30 12:25:40.510028',1,'admin','','','market.erp@gmail.com',1,1,'2026-03-12 10:02:02.222103'),(2,'pbkdf2_sha256$600000$UNmn6G3rkQwJa7mIIRYy9t$dkoiElErByOdH0KaOg/jNw9swN39YGUzZ8zXsxpIgQ8=','2026-04-30 12:39:48.497302',1,'Heriberto','Heriberto','Fernandez Chale','',0,1,'2026-03-12 14:12:00.000000'),(3,'pbkdf2_sha256$600000$cXdTAfjhjjVpfTOCWGQnF2$UrWMYiHEd3oNjWqOO853MPDpcov3frPoJ9AT3ifPrj8=','2026-03-20 15:50:10.296264',0,'marketerp','','','',0,1,'2026-03-20 15:45:36.037941'),(4,'pbkdf2_sha256$600000$dAM1AUNihXRkZW3vuoNora$1+wWbebaPWJ4FI2SHNhRiRQi8Cw/E3ZfQ/Kj1OBuB0s=','2026-04-30 13:39:35.107955',0,'Mario','Mario Enrique','Motede Dasilva','',1,1,'2026-04-01 20:26:35.000000'),(5,'pbkdf2_sha256$600000$8RJ2D2Bp7lCNCsNPw7YisS$B66KeS/ddMxkoq41xX6lvwgk17pZ8YDPTvE8KBVgNuE=','2026-04-01 23:44:48.233612',0,'Matias','Matias','Fernando Ndong Owono Obiang','',1,1,'2026-04-01 20:28:23.000000'),(6,'pbkdf2_sha256$600000$PPY3KMwJDewy9qwd3qG9P5$x7k1CauxRzrkUV1HnVqZWTnnZfX9ueXWtz0Ep6Lp+XM=','2026-04-02 22:09:16.977488',0,'Rodolfo','Rodolfo','Mba Ndong Mebaha','',1,1,'2026-04-01 20:29:42.000000');
/*!40000 ALTER TABLE `auth_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_user_groups`
--

DROP TABLE IF EXISTS `auth_user_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auth_user_groups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `group_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_user_groups_user_id_group_id_94350c0c_uniq` (`user_id`,`group_id`),
  KEY `auth_user_groups_group_id_97559544_fk_auth_group_id` (`group_id`),
  CONSTRAINT `auth_user_groups_group_id_97559544_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`),
  CONSTRAINT `auth_user_groups_user_id_6a12ed8b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_user_groups`
--

LOCK TABLES `auth_user_groups` WRITE;
/*!40000 ALTER TABLE `auth_user_groups` DISABLE KEYS */;
INSERT INTO `auth_user_groups` VALUES (1,4,2),(2,5,3),(3,6,4);
/*!40000 ALTER TABLE `auth_user_groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_user_user_permissions`
--

DROP TABLE IF EXISTS `auth_user_user_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auth_user_user_permissions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_user_user_permissions_user_id_permission_id_14a6b632_uniq` (`user_id`,`permission_id`),
  KEY `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm` (`permission_id`),
  CONSTRAINT `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_user_user_permissions`
--

LOCK TABLES `auth_user_user_permissions` WRITE;
/*!40000 ALTER TABLE `auth_user_user_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_user_user_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_admin_log`
--

DROP TABLE IF EXISTS `django_admin_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `django_admin_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `action_time` datetime(6) NOT NULL,
  `object_id` longtext DEFAULT NULL,
  `object_repr` varchar(200) NOT NULL,
  `action_flag` smallint(5) unsigned NOT NULL CHECK (`action_flag` >= 0),
  `change_message` longtext NOT NULL,
  `content_type_id` int(11) DEFAULT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `django_admin_log_content_type_id_c4bce8eb_fk_django_co` (`content_type_id`),
  KEY `django_admin_log_user_id_c564eba6_fk_auth_user_id` (`user_id`),
  CONSTRAINT `django_admin_log_content_type_id_c4bce8eb_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`),
  CONSTRAINT `django_admin_log_user_id_c564eba6_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=72 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_admin_log`
--

LOCK TABLES `django_admin_log` WRITE;
/*!40000 ALTER TABLE `django_admin_log` DISABLE KEYS */;
INSERT INTO `django_admin_log` VALUES (1,'2026-03-15 17:13:14.424545','1','Inventory_Management',1,'[{\"added\": {}}]',3,1),(2,'2026-03-15 19:31:17.132692','1','Prueba',1,'[{\"added\": {}}]',8,1),(3,'2026-03-15 19:35:41.842980','2','Prueba 2',1,'[{\"added\": {}}]',8,1),(4,'2026-03-15 19:56:23.368586','1','Prueba',3,'',8,1),(5,'2026-03-15 19:56:36.383217','2','Prueba 2',3,'',8,1),(6,'2026-03-15 21:22:58.394077','3','Zeytinyağı 1L',1,'[{\"added\": {}}]',8,1),(7,'2026-03-15 21:23:43.901910','4','Beyaz Peynir 500g',1,'[{\"added\": {}}]',8,1),(8,'2026-03-15 21:24:34.021254','5','Türk Kahvesi 100g',1,'[{\"added\": {}}]',8,1),(9,'2026-03-15 21:25:30.385164','6','Domates Salçası',1,'[{\"added\": {}}]',8,1),(10,'2026-03-15 21:26:10.437334','7','Mercimek 1kg',1,'[{\"added\": {}}]',8,1),(11,'2026-03-15 21:27:31.323878','8','Siyah Çay 500g',1,'[{\"added\": {}}]',8,1),(12,'2026-03-15 23:02:36.423922','1','Category object (1)',1,'[{\"added\": {}}]',7,1),(13,'2026-03-15 23:02:44.671189','2','Category object (2)',1,'[{\"added\": {}}]',7,1),(14,'2026-03-15 23:02:52.967118','3','Category object (3)',1,'[{\"added\": {}}]',7,1),(15,'2026-03-15 23:03:01.540992','4','Category object (4)',1,'[{\"added\": {}}]',7,1),(16,'2026-03-15 23:03:13.279165','5','Category object (5)',1,'[{\"added\": {}}]',7,1),(17,'2026-03-15 23:09:35.318575','6','Domates Salçası',3,'',8,1),(18,'2026-03-15 23:34:28.040207','1','Category object (1)',1,'[{\"added\": {}}]',7,1),(19,'2026-03-15 23:35:39.240981','1','56',1,'[{\"added\": {}}]',8,1),(20,'2026-03-15 23:35:54.176656','1','56',3,'',8,1),(21,'2026-03-17 14:46:33.829014','1','Kahvaltılık',1,'[{\"added\": {}}]',11,1),(22,'2026-03-17 14:46:43.611817','2','İçecek',1,'[{\"added\": {}}]',11,1),(23,'2026-03-17 14:46:51.392272','3','Konserve',1,'[{\"added\": {}}]',11,1),(24,'2026-03-17 14:47:00.683857','4','Bakliyat',1,'[{\"added\": {}}]',11,1),(25,'2026-03-17 14:56:26.336034','2','Kahvaltılık',1,'[{\"added\": {}}]',7,1),(26,'2026-03-17 14:56:32.912496','3','İçecek',1,'[{\"added\": {}}]',7,1),(27,'2026-03-17 14:56:40.306996','4','Konserve',1,'[{\"added\": {}}]',7,1),(28,'2026-03-17 14:56:46.486415','5','Bakliyat',1,'[{\"added\": {}}]',7,1),(29,'2026-03-17 14:57:21.327222','2','Mercimek 1kg',1,'[{\"added\": {}}]',8,1),(30,'2026-03-17 14:57:49.019131','3','Zeytinyağı 1L',1,'[{\"added\": {}}]',8,1),(31,'2026-03-17 14:58:15.194592','4','Beyaz Peynir 500g',1,'[{\"added\": {}}]',8,1),(32,'2026-03-17 14:58:38.022141','5','Domates Salçası',1,'[{\"added\": {}}]',8,1),(33,'2026-04-01 10:29:28.701422','1','Inventory_Management',3,'',3,1),(34,'2026-04-01 11:06:16.026534','2','Ürün Yönetimi',1,'[{\"added\": {}}]',3,1),(35,'2026-04-01 11:06:32.787050','3','Hesap Güvenliği & Erişim Sorumlusu',1,'[{\"added\": {}}]',3,1),(36,'2026-04-01 11:06:57.115626','4','Satış Mantığı & Finans Sorumlusu',1,'[{\"added\": {}}]',3,1),(37,'2026-04-01 20:10:21.132853','3','Hesap Güvenliği & Erişim Sorumlusu (products)',2,'[{\"changed\": {\"fields\": [\"Name\"]}}]',3,1),(38,'2026-04-01 20:11:01.522252','3','Hesap Güvenliği & Erişim Sorumlusu (accounts)',2,'[{\"changed\": {\"fields\": [\"Name\"]}}]',3,1),(39,'2026-04-01 20:11:12.395299','4','Satış Mantığı & Finans Sorumlusu (sales)',2,'[{\"changed\": {\"fields\": [\"Name\"]}}]',3,1),(40,'2026-04-01 20:11:20.329398','2','Ürün Yönetimi (products)',2,'[{\"changed\": {\"fields\": [\"Name\"]}}]',3,1),(41,'2026-04-01 20:17:40.593236','2','Ürün Yönetimi (products)',2,'[{\"changed\": {\"fields\": [\"Permissions\"]}}]',3,1),(42,'2026-04-01 20:19:11.919426','3','Hesap Güvenliği & Erişim Sorumlusu (accounts)',2,'[{\"changed\": {\"fields\": [\"Permissions\"]}}]',3,1),(43,'2026-04-01 20:20:24.201845','4','Satış Mantığı & Finans Sorumlusu (sales)',2,'[{\"changed\": {\"fields\": [\"Permissions\"]}}]',3,1),(44,'2026-04-01 20:26:35.951824','4','Mario',1,'[{\"added\": {}}]',4,1),(45,'2026-04-01 20:28:23.676426','5','Matias',1,'[{\"added\": {}}]',4,1),(46,'2026-04-01 20:29:42.622897','6','Rodolfo',1,'[{\"added\": {}}]',4,1),(47,'2026-04-01 20:35:44.089947','4','Mario',2,'[{\"changed\": {\"fields\": [\"First name\", \"Last name\", \"Staff status\", \"Groups\"]}}]',4,1),(48,'2026-04-01 20:36:16.378151','5','Matias',2,'[{\"changed\": {\"fields\": [\"First name\", \"Last name\", \"Staff status\", \"Groups\"]}}]',4,1),(49,'2026-04-01 20:36:48.810737','6','Rodolfo',2,'[{\"changed\": {\"fields\": [\"First name\", \"Last name\", \"Staff status\", \"Groups\"]}}]',4,1),(50,'2026-04-01 20:37:14.313914','2','Heri',2,'[{\"changed\": {\"fields\": [\"First name\", \"Last name\", \"Superuser status\"]}}]',4,1),(51,'2026-04-01 20:38:10.815554','2','Heriberto',2,'[{\"changed\": {\"fields\": [\"Username\"]}}]',4,1),(52,'2026-04-01 21:32:06.959545','4','Mario',2,'[{\"changed\": {\"fields\": [\"Staff status\", \"Superuser status\"]}}]',4,1),(53,'2026-04-01 21:33:23.598186','4','Mario',2,'[{\"changed\": {\"fields\": [\"Staff status\", \"Superuser status\"]}}]',4,1),(54,'2026-04-01 22:17:56.999327','6','Meyve',1,'[{\"added\": {}}]',7,1),(55,'2026-04-01 22:18:06.479641','7','Sebze',1,'[{\"added\": {}}]',7,1),(56,'2026-04-01 22:18:31.716004','8','Donmuş Gıda',1,'[{\"added\": {}}]',7,1),(57,'2026-04-01 22:18:50.869283','9','Süt ve Süt Ürünleri',1,'[{\"added\": {}}]',7,1),(58,'2026-04-01 22:18:59.081420','10','Et ve Tavuk',1,'[{\"added\": {}}]',7,1),(59,'2026-04-01 22:19:08.416968','11','Atıştırmalık',1,'[{\"added\": {}}]',7,1),(60,'2026-04-01 22:19:20.656304','12','Fırın ve Pastane',1,'[{\"added\": {}}]',7,1),(61,'2026-04-01 22:19:42.756779','13','Baharat ve Soslar',1,'[{\"added\": {}}]',7,1),(62,'2026-04-01 22:19:50.990711','14','Temel Gıda',1,'[{\"added\": {}}]',7,1),(63,'2026-04-01 22:19:57.982629','15','Temizlik Ürünleri',1,'[{\"added\": {}}]',7,1),(64,'2026-04-01 22:20:05.061036','16','Kişisel Bakım',1,'[{\"added\": {}}]',7,1),(65,'2026-04-01 22:20:13.889258','17','Kağıt Ürünleri',1,'[{\"added\": {}}]',7,1),(66,'2026-04-01 22:20:26.812600','18','Ev ve Yaşam',1,'[{\"added\": {}}]',7,1),(67,'2026-04-02 21:38:39.919158','6','Pilavlık Pirinç 1kg',2,'[{\"changed\": {\"fields\": [\"Son Kullanma Tarihi\"]}}]',8,4),(68,'2026-04-02 21:41:14.318221','4','Beyaz Peynir 500g',2,'[{\"changed\": {\"fields\": [\"Stock\", \"Son Kullanma Tarihi\"]}}]',8,4),(69,'2026-04-02 22:02:25.007517','5','Domates Salçası',2,'[{\"changed\": {\"fields\": [\"Son Kullanma Tarihi\"]}}]',8,4),(70,'2026-04-02 22:02:43.262566','2','Mercimek 1kg',2,'[{\"changed\": {\"fields\": [\"Son Kullanma Tarihi\"]}}]',8,4),(71,'2026-04-02 22:03:00.917131','3','Zeytinyağı 1L',2,'[{\"changed\": {\"fields\": [\"Son Kullanma Tarihi\"]}}]',8,4);
/*!40000 ALTER TABLE `django_admin_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_content_type`
--

DROP TABLE IF EXISTS `django_content_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `django_content_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `app_label` varchar(100) NOT NULL,
  `model` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `django_content_type_app_label_model_76bd3d3b_uniq` (`app_label`,`model`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_content_type`
--

LOCK TABLES `django_content_type` WRITE;
/*!40000 ALTER TABLE `django_content_type` DISABLE KEYS */;
INSERT INTO `django_content_type` VALUES (1,'admin','logentry'),(3,'auth','group'),(2,'auth','permission'),(4,'auth','user'),(5,'contenttypes','contenttype'),(7,'products','category'),(8,'products','product'),(11,'sales','category'),(12,'sales','product'),(9,'sales','sale'),(10,'sales','saledetail'),(6,'sessions','session');
/*!40000 ALTER TABLE `django_content_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_migrations`
--

DROP TABLE IF EXISTS `django_migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `django_migrations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `app` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `applied` datetime(6) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_migrations`
--

LOCK TABLES `django_migrations` WRITE;
/*!40000 ALTER TABLE `django_migrations` DISABLE KEYS */;
INSERT INTO `django_migrations` VALUES (1,'contenttypes','0001_initial','2026-03-12 09:59:46.103124'),(2,'auth','0001_initial','2026-03-12 09:59:46.590817'),(3,'admin','0001_initial','2026-03-12 09:59:46.702919'),(4,'admin','0002_logentry_remove_auto_add','2026-03-12 09:59:46.709643'),(5,'admin','0003_logentry_add_action_flag_choices','2026-03-12 09:59:46.718086'),(6,'contenttypes','0002_remove_content_type_name','2026-03-12 09:59:46.776059'),(7,'auth','0002_alter_permission_name_max_length','2026-03-12 09:59:46.830249'),(8,'auth','0003_alter_user_email_max_length','2026-03-12 09:59:46.843658'),(9,'auth','0004_alter_user_username_opts','2026-03-12 09:59:46.850881'),(10,'auth','0005_alter_user_last_login_null','2026-03-12 09:59:46.900611'),(11,'auth','0006_require_contenttypes_0002','2026-03-12 09:59:46.904413'),(12,'auth','0007_alter_validators_add_error_messages','2026-03-12 09:59:46.910559'),(13,'auth','0008_alter_user_username_max_length','2026-03-12 09:59:46.925319'),(14,'auth','0009_alter_user_last_name_max_length','2026-03-12 09:59:46.939414'),(15,'auth','0010_alter_group_name_max_length','2026-03-12 09:59:46.954501'),(16,'auth','0011_update_proxy_permissions','2026-03-12 09:59:46.961562'),(17,'auth','0012_alter_user_first_name_max_length','2026-03-12 09:59:46.974898'),(20,'sessions','0001_initial','2026-03-12 09:59:47.183052'),(28,'products','0001_initial','2026-03-15 23:30:02.341504'),(29,'sales','0001_initial','2026-03-15 23:32:50.425369'),(30,'products','0002_remove_product_barcode_alter_product_category_and_more','2026-03-17 14:27:39.840387'),(31,'sales','0002_alter_saledetail_product','2026-03-17 14:27:40.259266'),(32,'sales','0003_alter_sale_payment_method_alter_saledetail_product','2026-03-18 12:08:35.904736'),(33,'products','0003_product_expiration_date','2026-03-28 12:24:58.481582'),(34,'sales','0004_sale_is_cancelled','2026-03-28 14:50:09.616401'),(35,'products','0004_alter_category_options_alter_product_options','2026-04-01 22:28:45.110085'),(36,'sales','0005_sale_user','2026-04-30 14:01:15.554573');
/*!40000 ALTER TABLE `django_migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_session`
--

DROP TABLE IF EXISTS `django_session`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `django_session` (
  `session_key` varchar(40) NOT NULL,
  `session_data` longtext NOT NULL,
  `expire_date` datetime(6) NOT NULL,
  PRIMARY KEY (`session_key`),
  KEY `django_session_expire_date_a5c62663` (`expire_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_session`
--

LOCK TABLES `django_session` WRITE;
/*!40000 ALTER TABLE `django_session` DISABLE KEYS */;
INSERT INTO `django_session` VALUES ('28juy59ukerf47y3ei5k3kyoucczh7zo','.eJxVjDsOwjAQBe_iGln-xN6Ykj5nsNbrDQ4gR4qTCnF3EikFtG9m3ltE3NYSt8ZLnLK4CiMuv1tCenI9QH5gvc-S5rouU5KHIk_a5DBnft1O9--gYCt7TcDogrZKhQwdsLbQWTJggs7MinvvAUertNP9bpgxpwDglXWQiMmJzxfBmzcl:1wIQgG:kXrwMXr3xxzdj8rxY0odmU2jyrkC31pOmvDirfaxsyE','2026-05-14 12:39:48.500861'),('29voi7fl15c1re17b4wpqsph9777pxxt','.eJxVjDsOwjAQRO_iGll27NgbSvqcIdpdr3EAOVI-FeLuJFIK0HTz3sxbDbitZdgWmYcxqavy6vLbEfJT6gHSA-t90jzVdR5JH4o-6aL7Kcnrdrp_BwWXsq9ZKJMxYDDwHoIWJUGTGSIkQ-IkiBjMZH1wXfSAzmNrreOGo-tAfb4TlThi:1w8PeT:RlcqkjQwp36Lg2I5VH0_xhAuGMRa6T11TgNHoXgMA8s','2026-04-16 21:32:33.723379'),('39sj9ihmfm2m5fn2sydmg05bp091um8e','.eJxVjDsOwjAQBe_iGln-xN6Ykj5nsNbrDQ4gR4qTCnF3EikFtG9m3ltE3NYSt8ZLnLK4CiMuv1tCenI9QH5gvc-S5rouU5KHIk_a5DBnft1O9--gYCt7TcDogrZKhQwdsLbQWTJggs7MinvvAUertNP9bpgxpwDglXWQiMmJzxfBmzcl:1w2WjT:eVqho9iWY2ATMwr-teaAdwv-6uGGX8eq0o_7Eroq_4Y','2026-03-31 15:53:23.229428'),('41yvzkzgakhtl79e0m3s90zjm5exiueb','.eJxVjDsOwyAQBe9CHSGzLBhSpvcZEMsnOIlAMnYV5e4RkoukfTPz3sz5Yy_u6Glza2RXJtjldyMfnqkOEB--3hsPre7bSnwo_KSdLy2m1-10_w6K72XUASEaAx4NYA5J-SizRLJCRWsmMpRBkxJzmoWWE6IWMliQigggWM0-X-DSN0I:1wIQSa:QnciBJbH84aqfASMpAA8OwWjTF5TunzPGghtvzPXb6s','2026-05-14 12:25:40.512869'),('4pw9f40f36x9lqv7bltbsdrd7m1zoi9q','.eJxVjDsOwjAQRO_iGll27NgbSvqcIdpdr3EAOVI-FeLuJFIK0HTz3sxbDbitZdgWmYcxqavy6vLbEfJT6gHSA-t90jzVdR5JH4o-6aL7Kcnrdrp_BwWXsq9ZKJMxYDDwHoIWJUGTGSIkQ-IkiBjMZH1wXfSAzmNrreOGo-tAfb4TlThi:1wIRc7:hAtapQAfPSOONfLLCYMDAxr6C48ssIiqYFipJEmfa3I','2026-05-14 13:39:35.110945'),('8deulloe872l8g9ev88qgp2ce9wqvhui','.eJxVjDsOwyAQBe9CHSGzLBhSpvcZEMsnOIlAMnYV5e4RkoukfTPz3sz5Yy_u6Glza2RXJtjldyMfnqkOEB--3hsPre7bSnwo_KSdLy2m1-10_w6K72XUASEaAx4NYA5J-SizRLJCRWsmMpRBkxJzmoWWE6IWMliQigggWM0-X-DSN0I:1w1qac:MgwadpWpmonFEP8bv3W0sHXmlBEthwqoyR7PmIfu6w4','2026-03-29 18:53:26.195220'),('9dfw9oiw0tcit5lyn89j50lt33yi0ndq','.eJxVjDsOwyAQBe9CHSGzLBhSpvcZEMsnOIlAMnYV5e4RkoukfTPz3sz5Yy_u6Glza2RXJtjldyMfnqkOEB--3hsPre7bSnwo_KSdLy2m1-10_w6K72XUASEaAx4NYA5J-SizRLJCRWsmMpRBkxJzmoWWE6IWMliQigggWM0-X-DSN0I:1w2rV7:_qiqrNxoaNI7dvnGcgBo1soD1q3leDSuYmDEVOu0k8Y','2026-04-01 14:03:57.760027'),('gnkwmzuqw0y78w0m23p9g1gfszngz0bp','.eJxVjDsOwjAQBe_iGln-xN6Ykj5nsNbrDQ4gR4qTCnF3EikFtG9m3ltE3NYSt8ZLnLK4CiMuv1tCenI9QH5gvc-S5rouU5KHIk_a5DBnft1O9--gYCt7TcDogrZKhQwdsLbQWTJggs7MinvvAUertNP9bpgxpwDglXWQiMmJzxfBmzcl:1w2m7w:K4IgHmL7l_ik0W51OS065Q0DxWOk18QDT9Tn3ptnqJo','2026-04-01 08:19:40.215596'),('x7q7x2r56zikpx8f016eudlksknkzq13','.eJxVjDsOwjAQBe_iGln-xN6Ykj5nsNbrDQ4gR4qTCnF3EikFtG9m3ltE3NYSt8ZLnLK4CiMuv1tCenI9QH5gvc-S5rouU5KHIk_a5DBnft1O9--gYCt7TcDogrZKhQwdsLbQWTJggs7MinvvAUertNP9bpgxpwDglXWQiMmJzxfBmzcl:1w8QlU:MvmwK_JEr_0FGj3afIMd5aoipCCwSib25CTzpN8Ir4E','2026-04-16 22:43:52.077611');
/*!40000 ALTER TABLE `django_session` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `products_category`
--

DROP TABLE IF EXISTS `products_category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `products_category` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `products_category`
--

LOCK TABLES `products_category` WRITE;
/*!40000 ALTER TABLE `products_category` DISABLE KEYS */;
INSERT INTO `products_category` VALUES (1,'Gıda'),(2,'Kahvaltılık'),(3,'İçecek'),(4,'Konserve'),(5,'Bakliyat'),(6,'Meyve'),(7,'Sebze'),(8,'Donmuş Gıda'),(9,'Süt ve Süt Ürünleri'),(10,'Et ve Tavuk'),(11,'Atıştırmalık'),(12,'Fırın ve Pastane'),(13,'Baharat ve Soslar'),(14,'Temel Gıda'),(15,'Temizlik Ürünleri'),(16,'Kişisel Bakım'),(17,'Kağıt Ürünleri'),(18,'Ev ve Yaşam');
/*!40000 ALTER TABLE `products_category` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `products_product`
--

DROP TABLE IF EXISTS `products_product`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `products_product` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `category_id` bigint(20) NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `stock` int(11) NOT NULL,
  `expiration_date` date DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `products_product_category_id_9b594869` (`category_id`),
  CONSTRAINT `products_product_category_id_9b594869_fk_products_category_id` FOREIGN KEY (`category_id`) REFERENCES `products_category` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `products_product`
--

LOCK TABLES `products_product` WRITE;
/*!40000 ALTER TABLE `products_product` DISABLE KEYS */;
INSERT INTO `products_product` VALUES (2,'Mercimek 1kg',5,38.25,0,'2026-05-23'),(3,'Zeytinyağı 1L',1,250.00,25,'2026-06-28'),(4,'Beyaz Peynir 500g',2,125.50,23,'2026-06-15'),(5,'Domates Salçası',4,65.00,0,'2026-05-01'),(6,'Pilavlık Pirinç 1kg',14,45.00,50,'2027-05-12'),(7,'Kırmızı Mercimek 1kg',14,32.50,40,'2026-08-20'),(8,'Sızma Zeytinyağı 1L',14,280.00,3,'2026-10-10'),(9,'Toz Şeker 5kg',14,145.00,20,'2028-12-05'),(10,'Siyah Zeytin 400g',2,85.00,30,'2026-11-22'),(11,'Süzme Çiçek Balı 450g',2,160.00,11,'2027-12-30'),(12,'Dana Sucuk 250g',2,195.00,2,'2026-07-01'),(13,'Taze Kaşar Peyniri',2,210.00,17,'2026-08-10'),(14,'Çaykur Rize Çayı 500g',3,95.00,44,'2028-03-14'),(15,'Türk Kahvesi 100g',3,35.00,60,'2027-02-05'),(16,'Coca-Cola 2.5L',3,45.00,79,'2026-12-12'),(17,'Doğal Maden Suyu 6\'lı',3,38.00,33,'2027-10-20'),(18,'Portakal Suyu 1L',3,45.00,50,'2026-09-01'),(19,'Çamaşır Deterjanı 5kg',15,185.00,14,'2029-01-01'),(20,'Bulaşık Deterjanı 750ml',15,42.00,39,'2028-05-15'),(21,'Yüzey Temizleyici 1L',15,42.50,4,'2028-10-10'),(22,'Sıvı Sabun 500ml',15,28.50,3,'2029-02-20'),(23,'Kağıt Havlu 6\'lı Rulo',15,75.00,19,'2028-01-01'),(24,'Sütlü Çikolata 80g',11,22.50,119,'2026-12-10'),(25,'Tuzlu Yer Fıstığı 200g',11,45.00,39,'2026-11-15'),(26,'Bisküvi Çeşitleri',11,12.50,150,'2027-05-20'),(27,'Meyveli Sakız',11,5.00,200,'2028-01-01'),(28,'Patates Cipsi (Large)',11,35.50,62,'2026-08-14');
/*!40000 ALTER TABLE `products_product` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sales_category`
--

DROP TABLE IF EXISTS `sales_category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sales_category` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sales_category`
--

LOCK TABLES `sales_category` WRITE;
/*!40000 ALTER TABLE `sales_category` DISABLE KEYS */;
INSERT INTO `sales_category` VALUES (1,'Kahvaltılık'),(2,'İçecek'),(3,'Konserve'),(4,'Bakliyat');
/*!40000 ALTER TABLE `sales_category` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sales_product`
--

DROP TABLE IF EXISTS `sales_product`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sales_product` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(200) NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `stock` int(11) NOT NULL,
  `barcode` varchar(13) DEFAULT NULL,
  `category_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `sales_product_category_id_f04ee977_fk_sales_category_id` (`category_id`),
  CONSTRAINT `sales_product_category_id_f04ee977_fk_sales_category_id` FOREIGN KEY (`category_id`) REFERENCES `sales_category` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sales_product`
--

LOCK TABLES `sales_product` WRITE;
/*!40000 ALTER TABLE `sales_product` DISABLE KEYS */;
/*!40000 ALTER TABLE `sales_product` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sales_sale`
--

DROP TABLE IF EXISTS `sales_sale`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sales_sale` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `date` datetime(6) NOT NULL,
  `total_amount` decimal(12,2) NOT NULL,
  `payment_method` varchar(20) NOT NULL,
  `is_cancelled` tinyint(1) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `sales_sale_user_id_c0f47f66_fk_auth_user_id` (`user_id`),
  CONSTRAINT `sales_sale_user_id_c0f47f66_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sales_sale`
--

LOCK TABLES `sales_sale` WRITE;
/*!40000 ALTER TABLE `sales_sale` DISABLE KEYS */;
INSERT INTO `sales_sale` VALUES (1,'2026-03-18 12:09:17.838209',250.00,'Nakit',0,NULL),(2,'2026-03-18 12:09:26.645947',125.50,'Nakit',0,NULL),(3,'2026-03-20 21:41:42.891868',250.00,'Nakit',0,NULL),(4,'2026-04-02 22:03:49.686891',125.50,'Nakit',0,NULL),(5,'2026-04-02 22:03:52.952258',42.00,'Nakit',0,NULL),(6,'2026-04-02 22:03:55.925112',95.00,'Nakit',0,NULL),(7,'2026-04-02 22:03:58.241003',45.00,'Nakit',0,NULL),(8,'2026-04-02 22:04:00.913959',38.00,'Nakit',0,NULL),(9,'2026-04-02 22:04:03.594477',75.00,'Nakit',0,NULL),(10,'2026-04-02 22:04:06.526022',35.50,'Nakit',0,NULL),(11,'2026-04-02 22:04:09.524712',250.00,'Nakit',0,NULL),(12,'2026-04-02 22:04:11.894197',42.50,'Nakit',0,NULL),(13,'2026-04-02 22:04:14.998579',45.00,'Nakit',0,NULL),(14,'2026-04-02 22:04:18.746794',210.00,'Nakit',0,NULL),(15,'2026-04-02 22:04:21.691564',22.50,'Nakit',0,NULL),(16,'2026-04-02 22:04:25.650491',28.50,'Nakit',0,NULL),(17,'2026-04-02 22:04:30.482818',38.00,'Nakit',0,NULL),(18,'2026-04-30 14:15:34.018168',35.50,'Nakit',0,2),(19,'2026-04-30 14:15:37.207240',28.50,'Nakit',0,2),(20,'2026-04-30 14:15:39.943339',185.00,'Nakit',0,2),(21,'2026-04-30 14:15:42.807022',125.50,'Nakit',0,2),(22,'2026-04-30 14:15:45.806092',250.00,'Nakit',0,2),(23,'2026-04-30 14:38:54.465696',160.00,'Nakit',0,2),(24,'2026-04-30 17:08:12.208381',35.50,'Nakit',0,2),(25,'2026-04-30 17:08:14.133470',65.00,'Nakit',0,2);
/*!40000 ALTER TABLE `sales_sale` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sales_saledetail`
--

DROP TABLE IF EXISTS `sales_saledetail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sales_saledetail` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `quantity` int(10) unsigned NOT NULL CHECK (`quantity` >= 0),
  `unit_price` decimal(10,2) NOT NULL,
  `subtotal` decimal(12,2) NOT NULL,
  `product_id` int(11) NOT NULL,
  `sale_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `sales_saledetail_sale_id_953256a3_fk_sales_sale_id` (`sale_id`),
  KEY `sales_saledetail_product_id_c296b029_fk_sales_product_id` (`product_id`),
  CONSTRAINT `sales_saledetail_product_id_c296b029_fk_sales_product_id` FOREIGN KEY (`product_id`) REFERENCES `sales_product` (`id`),
  CONSTRAINT `sales_saledetail_sale_id_953256a3_fk_sales_sale_id` FOREIGN KEY (`sale_id`) REFERENCES `sales_sale` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sales_saledetail`
--

LOCK TABLES `sales_saledetail` WRITE;
/*!40000 ALTER TABLE `sales_saledetail` DISABLE KEYS */;
/*!40000 ALTER TABLE `sales_saledetail` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-04-30 20:48:22
