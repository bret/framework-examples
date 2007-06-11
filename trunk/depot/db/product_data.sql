-- MySQL dump 10.9
--
-- Host: localhost    Database: depot_development
-- ------------------------------------------------------
-- Server version	4.1.8-max

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE="NO_AUTO_VALUE_ON_ZERO" */;

--
-- Table structure for table `products`
--

DROP TABLE IF EXISTS `products`;
CREATE TABLE `products` (
  `id` int(11) NOT NULL auto_increment,
  `title` varchar(100) NOT NULL default '',
  `description` text NOT NULL,
  `image_url` varchar(200) NOT NULL default '',
  `price` decimal(10,2) NOT NULL default '0.00',
  `date_available` datetime NOT NULL default '0000-00-00 00:00:00',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM;

--
-- Dumping data for table `products`
--


/*!40000 ALTER TABLE `products` DISABLE KEYS */;
LOCK TABLES `products` WRITE;
INSERT INTO `products` VALUES (4,
'Pragmatic Project Automation',
'<p>\r\n<em>Pragmatic Project Automation</em> shows you how to improve the consistency and repeatability of your project\'s procedures using automation to reduce risk and errors.\r\n</p>\r\n<p>\r\nSimply put, we\'re going to put this thing called a computer to work for you doing the mundane (but important) project stuff. That means you\'ll have more time and energy to do the really exciting---and difficult---stuff, like writing quality code.\r\n</p>',
'/images/sk_auto_small.jpg',
'29.95',
'2005-02-09 14:15:00');
insert into products values(11,
'Pragmatic Unit Testing (C#)','<p>Pragmatic programmers use feedback to drive their development and personal processes. The most valuable feedback you can get while coding comes from unit testing.\r\n</p>\r\n\r\n<p>\r\nWithout good tests in place, coding can become a frustrating game of \"whack-a-mole.\" That\'s the carnival game where the player strikes at a mechanical mole; it retreats and another mole pops up on the opposite side of the field. The moles pop up and down so fast that you end up flailing your mallet helplessly as the moles continue to pop up where you least expect them.\r\n</p>',
'/images/sk_utc_small.jpg',
'29.95',
'2004-06-18 00:00:00');
insert into products values(12,
'Pragmatic Version Control',
'<p>\r\nThis book is a recipe-based approach to using Subversion that will get you up and running quickly---and correctly. All projects need version control: it\'s a foundational piece of any project\'s infrastructure. Yet half of all project teams in the U.S. don\'t use any version control at all. Many others don\'t use it well, and end up experiencing time-consuming problems.\r\n</p>',
'/images/sk_svn_small.jpg',
'29.95',
'2005-01-26 00:16:00');
UNLOCK TABLES;
/*!40000 ALTER TABLE `products` ENABLE KEYS */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

