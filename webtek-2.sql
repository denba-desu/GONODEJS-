-- MySQL dump 10.13  Distrib 5.7.12, for Win64 (x86_64)
--
-- Host: localhost    Database: webtek-2
-- ------------------------------------------------------
-- Server version	5.7.11

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
  `customer_contactno` varchar(11) NOT NULL,
  `customer_gender` enum('M','F') NOT NULL,
  `customer_homeaddress` varchar(45) NOT NULL,
  `isAccepted` enum('T','F') NOT NULL,
  PRIMARY KEY (`customer_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4011 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customer`
--

LOCK TABLES `customer` WRITE;
/*!40000 ALTER TABLE `customer` DISABLE KEYS */;
INSERT INTO `customer` VALUES (4000,'Juan Dela Cruz','jdc@gmail.com','12345','09173462534','M','Bonifacio Street, Baguio City','T'),(4001,'Maria Clara','clara@gmail.com','secret123','09069736231','F','Loakan, Baguio City','T'),(4002,'Zac Efron','zacefron@gmail.com','12341234','09057382234','M','Aurora Hill, Baguio City','T'),(4003,'Brad Pitt','brad123@gmail.com','12345678','09213846247','M','City Camp, Baguio City','T'),(4004,'Angelina Jolie','aj@gmail.com','98765432','09156726333','F','Palma, Baguio City','T'),(4005,'Leonardo DiCaprio','leonardo@gmail.com','password123','09278751237','M','New Lucban, Baguio City','T'),(4006,'Will Smith','smithwill@gmail.com','mypassword','09158071875','M','Irisan, Baguio CIty','T'),(4007,'Beyonce','knowles@gmail.com','star12345','09276125321','F','Brookside, Baguio City','T'),(4008,'Vanessa Hudgens','vh12@gmail.com','password12345','09156823123','F','Bakakeng, Baguio City','T'),(4009,'Coco Martin','cocomartin@gmail.com','coco123','09278231237','M','Engineers Hill, Baguio City','T'),(4010,'Piolo Pascual','pascual@gmai.com','pascual12','09218374323','M','Cabinet Hill, Baguio City','T');
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
  PRIMARY KEY (`specialization_id`),
  KEY `id_sp_idx` (`id_sp`),
  KEY `fkService_idx` (`id_service`),
  CONSTRAINT `fkSPID` FOREIGN KEY (`id_sp`) REFERENCES `service_provider` (`sp_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fkService` FOREIGN KEY (`id_service`) REFERENCES `services` (`service_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=5011 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `provider_specialization`
--

LOCK TABLES `provider_specialization` WRITE;
/*!40000 ALTER TABLE `provider_specialization` DISABLE KEYS */;
INSERT INTO `provider_specialization` VALUES (5000,3004,2003),(5001,3003,2004),(5002,3005,2005),(5003,3006,2002),(5004,3007,2003),(5005,3008,2006),(5006,3009,2007),(5007,3010,2002),(5008,3011,2006),(5009,3012,2004),(5010,3013,2007);
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
  `service_id` int(4) DEFAULT NULL,
  `sp_id` int(4) DEFAULT NULL,
  `customer_id` int(4) NOT NULL,
  `scheduled_time` varchar(45) NOT NULL,
  `scheduled_day` varchar(45) NOT NULL,
  `status` enum('Ongoing','Done','Pending','Accepted') NOT NULL DEFAULT 'Pending',
  `isPaid` enum('T','F') NOT NULL DEFAULT 'F',
  PRIMARY KEY (`request_id`),
  KEY `fk_spID_idx` (`sp_id`),
  KEY `fk_custID_idx` (`customer_id`),
  KEY `fk_serviceID_idx` (`service_id`),
  CONSTRAINT `fk_custID` FOREIGN KEY (`customer_id`) REFERENCES `customer` (`customer_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_serviceID` FOREIGN KEY (`service_id`) REFERENCES `services` (`service_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_spID` FOREIGN KEY (`sp_id`) REFERENCES `service_provider` (`sp_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=6012 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `requests`
--

LOCK TABLES `requests` WRITE;
/*!40000 ALTER TABLE `requests` DISABLE KEYS */;
INSERT INTO `requests` VALUES (6000,2002,NULL,4000,'10:00 - 12:00','MWF','Ongoing','F'),(6001,2003,NULL,4001,'8:00 - 10:00','TTHS','Pending','F'),(6002,2004,NULL,4002,'3:00 - 5:00','MWF','Done','T'),(6003,2005,NULL,4003,'2:00 - 5:00','TTHS','Pending','F'),(6004,2006,NULL,4004,'1:00 - 3:00','MWF','Done','T'),(6005,2007,NULL,4005,'4:00 - 6:00','TTHS','Ongoing','F'),(6006,2002,NULL,4006,'9:00 - 10:00','MWF','Done','T'),(6007,2003,NULL,4007,'1:00 - 3:00','MWF','Ongoing','F'),(6009,2004,NULL,4008,'3:00 - 5:00','TTHS','Ongoing','F'),(6010,2005,NULL,4009,'8:00 - 10:00','TTHS','Done','T'),(6011,2002,NULL,4001,'8:00 - 10:00','MWF','Pending','F');
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
  `sp_contactno` varchar(11) NOT NULL,
  `sp_gender` enum('M','F') NOT NULL,
  `sp_homeaddress` varchar(100) NOT NULL,
  `isAcceptedSP` enum('T','F') NOT NULL DEFAULT 'F',
  PRIMARY KEY (`sp_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3014 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `service_provider`
--

LOCK TABLES `service_provider` WRITE;
/*!40000 ALTER TABLE `service_provider` DISABLE KEYS */;
INSERT INTO `service_provider` VALUES (3001,'Administrator','admin','admin','Administrator','0','M','Local','T'),(3003,'Rusell Bayote','rusellbayote@gmail.com','mypassword','Provides guitar lessons','09164146533','M','Brookside, Baguio City','F'),(3004,'Benedict Suarez','benedictsuarez@gmail.com','secret1234','Provides voice lessons','09064763492','M','Aurora Hill, Baguio City','T'),(3005,'Ryan De Guzman','ryandeguzman@gmail.com','12345secret','Provides violin lessons','09156798762','M','New Lucban, Baguio CIty','F'),(3006,'Sarah Centino','sarahcentino@gmail.com','password12','Provides piano lessons','09056010255','F','Irisan, Baguio City','T'),(3007,'Aerhielle Leonen','aerhielleleonen@gmail.com','chocopie123','Provides voice lessons','09158071873','F','Palma, Baguio City','F'),(3008,'Mark Andawi','markandawi@gmail.com','mypass12','Provides drum lessons','09178037821','M','Loakan, Baguio City','T'),(3009,'Clyde Benitez','clydebenitez@gmail.com','secreet','Provides saxophone lessons','09358067123','M','Caguioa, Baguio City','F'),(3010,'Abigail Macanlalay','abimacanlalay@gmail.com','abi1234','Provides piano lessons','09167091234','F','Engineers Hill, Baguio City','T'),(3011,'Jay Bryan','jaybryan@gmail.com','jay12345','Provides drum lessons','09056021866','M','Cabinet Hill, Baguio City','F'),(3012,'Raoul Kristian','raoulkristian@gmail.com','rkpassword','Provides guitar lessons','09278967129','M','City Camp, Baguio City','T'),(3013,'Denver Culbengan','denverculbengan@gmail.com','pogiako','Provides saxophone lessons','09356719823','M','Bakakeng, Baguio City','F');
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
  PRIMARY KEY (`service_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2008 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `services`
--

LOCK TABLES `services` WRITE;
/*!40000 ALTER TABLE `services` DISABLE KEYS */;
INSERT INTO `services` VALUES (2002,'Piano Lessons'),(2003,'Voice Lessons'),(2004,'Guitar Lessons'),(2005,'Violin Lessons'),(2006,'Drum Lessons'),(2007,'Saxophone Lessons');
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

-- Dump completed on 2017-05-14 22:30:50
