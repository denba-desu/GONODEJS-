-- MySQL dump 10.13  Distrib 5.7.12, for Win64 (x86_64)
--
-- Host: localhost    Database: webtek-2
-- ------------------------------------------------------
-- Server version	5.7.14

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `category`
--

DROP TABLE IF EXISTS `category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `category` (
  `category_id` int(4) NOT NULL AUTO_INCREMENT,
  `category_name` varchar(45) NOT NULL,
  PRIMARY KEY (`category_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1004 DEFAULT CHARSET=euckr;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `category`
--

LOCK TABLES `category` WRITE;
/*!40000 ALTER TABLE `category` DISABLE KEYS */;
INSERT INTO `category` VALUES (1003,'Tutorial Services');
/*!40000 ALTER TABLE `category` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customer`
--

DROP TABLE IF EXISTS `customer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `customer` (
  `customer_id` int(4) NOT NULL AUTO_INCREMENT,
  `customer_name` varchar(45) NOT NULL,
  `customer_email` varchar(45) NOT NULL,
  `customer_password` varchar(100) NOT NULL,
  `customer_age` int(2) NOT NULL,
  `customer_contactno` varchar(11) NOT NULL,
  `customer_gender` enum('M','F') NOT NULL,
  `customer_homeaddress` varchar(45) NOT NULL,
  PRIMARY KEY (`customer_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4004 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customer`
--

LOCK TABLES `customer` WRITE;
/*!40000 ALTER TABLE `customer` DISABLE KEYS */;
INSERT INTO `customer` VALUES (4000,'Ryan Christian','rc@gmail.com','12345',19,'09090909090','M','Bonifacio Street, Baguio City'),(4001,'Aerhielle Leonen','aerhielle@gmail.com','secret123',19,'09090909009','F','Baguio City'),(4002,'Sarah Centino','sarahcentino@gmail.com','12314234',20,'09090909090','F','Baguio City'),(4003,'Denver Culbengan','denverculbengan@gmail.com','12345678',20,'09090909099','M','Baguio City');
/*!40000 ALTER TABLE `customer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `provider_specialization`
--

DROP TABLE IF EXISTS `provider_specialization`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `provider_specialization` (
  `specialization_id` int(4) NOT NULL AUTO_INCREMENT,
  `id_sp` int(4) NOT NULL,
  `id_service` int(4) NOT NULL,
  `id_category` int(4) NOT NULL,
  PRIMARY KEY (`specialization_id`),
  KEY `id_sp_idx` (`id_sp`),
  KEY `fkService_idx` (`id_service`),
  KEY `fkCategory_idx` (`id_category`),
  CONSTRAINT `fkCateg` FOREIGN KEY (`id_category`) REFERENCES `category` (`category_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fkSPID` FOREIGN KEY (`id_sp`) REFERENCES `service_provider` (`sp_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fkService` FOREIGN KEY (`id_service`) REFERENCES `services` (`service_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=5002 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `provider_specialization`
--

LOCK TABLES `provider_specialization` WRITE;
/*!40000 ALTER TABLE `provider_specialization` DISABLE KEYS */;
INSERT INTO `provider_specialization` VALUES (5000,3004,2002,1003),(5001,3003,2002,1003);
/*!40000 ALTER TABLE `provider_specialization` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `requests`
--

DROP TABLE IF EXISTS `requests`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `requests` (
  `request_id` int(4) NOT NULL AUTO_INCREMENT,
  `id_specialization` int(4) NOT NULL,
  `id_customer` int(4) NOT NULL,
  `scheduled_time` varchar(45) NOT NULL,
  `scheduled_day` varchar(45) NOT NULL,
  `isAcceptedRequest` enum('T','F') NOT NULL DEFAULT 'F',
  `status` enum('Ongoing','Done') NOT NULL DEFAULT 'Ongoing',
  `isPaid` enum('T','F') NOT NULL DEFAULT 'F',
  PRIMARY KEY (`request_id`),
  KEY `id_sp_idx` (`request_id`,`id_customer`),
  KEY `fkSpecialization_idx` (`id_specialization`),
  KEY `fkCustomer_idx` (`id_customer`),
  CONSTRAINT `fkCustomer` FOREIGN KEY (`id_customer`) REFERENCES `customer` (`customer_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fkSpecialization` FOREIGN KEY (`id_specialization`) REFERENCES `provider_specialization` (`specialization_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=6004 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `requests`
--

LOCK TABLES `requests` WRITE;
/*!40000 ALTER TABLE `requests` DISABLE KEYS */;
INSERT INTO `requests` VALUES (6000,5000,4000,'10:00 - 12:00','MWF','F','Ongoing','F'),(6001,5001,4001,'8:00 - 10:00','TTHS','T','Ongoing','F'),(6002,5000,4002,'3:00 - 5:00','MWF','T','Done','T'),(6003,5000,4003,'2:00 - 5:00','TTHS','F','Ongoing','F');
/*!40000 ALTER TABLE `requests` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `service_provider`
--

DROP TABLE IF EXISTS `service_provider`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `service_provider` (
  `sp_id` int(4) NOT NULL AUTO_INCREMENT,
  `sp_name` varchar(45) NOT NULL,
  `sp_email` varchar(45) NOT NULL,
  `sp_password` varchar(45) NOT NULL,
  `sp_desc` varchar(200) NOT NULL,
  `sp_age` int(2) NOT NULL,
  `sp_contactno` varchar(11) NOT NULL,
  `sp_gender` enum('M','F') NOT NULL,
  `sp_homeaddress` varchar(100) NOT NULL,
  `isAcceptedSP` enum('T','F') NOT NULL DEFAULT 'F',
  PRIMARY KEY (`sp_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3005 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `service_provider`
--

LOCK TABLES `service_provider` WRITE;
/*!40000 ALTER TABLE `service_provider` DISABLE KEYS */;
INSERT INTO `service_provider` VALUES (3001,'Administrator','admin','admin','Administrator',0,'0','M','Local','T'),(3003,'Rusell Bayote','rusellbayote@gmail.com','mypassword','im a handy man',18,'09164146533','M','Baguio City','F'),(3004,'Benedict Suarez','benedictsuarez@gmail.com','secret1234','I can do this and do that',19,'09064763492','M','Aurora Hill, Baguio City','T');
/*!40000 ALTER TABLE `service_provider` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `services`
--

DROP TABLE IF EXISTS `services`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `services` (
  `service_id` int(4) NOT NULL AUTO_INCREMENT,
  `service_name` varchar(45) NOT NULL,
  `id_category` int(4) NOT NULL,
  PRIMARY KEY (`service_id`),
  KEY `fkCategory_idx` (`id_category`),
  CONSTRAINT `fkCategory` FOREIGN KEY (`id_category`) REFERENCES `category` (`category_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=2003 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `services`
--

LOCK TABLES `services` WRITE;
/*!40000 ALTER TABLE `services` DISABLE KEYS */;
INSERT INTO `services` VALUES (2002,'Piano Tutorial',1003);
/*!40000 ALTER TABLE `services` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2017-05-12 13:07:43
