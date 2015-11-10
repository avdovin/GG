# ************************************************************
# Sequel Pro SQL dump
# Version 4499
#
# http://www.sequelpro.com/
# https://github.com/sequelpro/sequelpro
#
# Host: 127.0.0.1 (MySQL 5.5.44-0ubuntu0.12.04.1)
# Database: gg9
# Generation Time: 2015-11-10 14:28:33 +0000
# ************************************************************


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


# Dump of table anonymous_session
# ------------------------------------------------------------

DROP TABLE IF EXISTS `anonymous_session`;

CREATE TABLE `anonymous_session` (
  `cck` varchar(32) NOT NULL,
  `time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `host` varchar(100) NOT NULL,
  `ip` varchar(100) NOT NULL,
  `data` blob,
  `user_id` int(6) unsigned DEFAULT NULL,
  PRIMARY KEY (`cck`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

LOCK TABLES `anonymous_session` WRITE;
/*!40000 ALTER TABLE `anonymous_session` DISABLE KEYS */;

INSERT INTO `anonymous_session` (`cck`, `time`, `host`, `ip`, `data`, `user_id`)
VALUES
	('ff0b25355fd00a8bb5052f3248e17c6d','2015-11-05 15:38:25','localhost:3000','empty',NULL,0),
	('8d3a73d1c2b594e53f1cc18d9db32d5b','2015-11-05 15:37:10','localhost:3000','empty',NULL,0);

/*!40000 ALTER TABLE `anonymous_session` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table captcha
# ------------------------------------------------------------

DROP TABLE IF EXISTS `captcha`;

CREATE TABLE `captcha` (
  `code` varchar(100) NOT NULL,
  `time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`code`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;



# Dump of table data_banner
# ------------------------------------------------------------

DROP TABLE IF EXISTS `data_banner`;

CREATE TABLE `data_banner` (
  `ID` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(128) NOT NULL DEFAULT '',
  `rating` smallint(5) unsigned NOT NULL DEFAULT '0',
  `docfile` varchar(255) NOT NULL DEFAULT '',
  `titlelink` varchar(64) NOT NULL DEFAULT '',
  `textlink` text NOT NULL,
  `width` smallint(5) unsigned NOT NULL DEFAULT '0',
  `height` smallint(5) unsigned NOT NULL DEFAULT '0',
  `size` int(11) NOT NULL DEFAULT '0',
  `type_file` varchar(8) NOT NULL DEFAULT '',
  `link` varchar(255) NOT NULL DEFAULT '',
  `operator` varchar(64) NOT NULL DEFAULT '',
  `showdatefirst` date NOT NULL DEFAULT '0000-00-00',
  `showdateend` date NOT NULL DEFAULT '0000-00-00',
  `id_advert_block` varchar(100) NOT NULL,
  `week` varchar(16) NOT NULL DEFAULT '',
  `target_url` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `urls` varchar(255) DEFAULT NULL,
  `time` varchar(64) NOT NULL DEFAULT '',
  `view` tinyint(1) NOT NULL DEFAULT '0',
  `langs` varchar(50) DEFAULT NULL,
  `type_show` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `cash` decimal(8,2) unsigned DEFAULT NULL,
  `target` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `list_page` text NOT NULL,
  `code` text NOT NULL,
  `stat` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `id_advert_users` smallint(5) unsigned NOT NULL DEFAULT '0',
  `targetblank` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `updated_at` datetime DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Хранилище рекламы';

LOCK TABLES `data_banner` WRITE;
/*!40000 ALTER TABLE `data_banner` DISABLE KEYS */;

INSERT INTO `data_banner` (`ID`, `name`, `rating`, `docfile`, `titlelink`, `textlink`, `width`, `height`, `size`, `type_file`, `link`, `operator`, `showdatefirst`, `showdateend`, `id_advert_block`, `week`, `target_url`, `urls`, `time`, `view`, `langs`, `type_show`, `cash`, `target`, `list_page`, `code`, `stat`, `id_advert_users`, `targetblank`, `updated_at`, `created_at`)
VALUES
	(2,'Баннер',1,'banner2_650x450.jpg','','',650,450,0,'jpg','http://доступный-отдых.рф','root','0000-00-00','0000-00-00','1','-1',0,NULL,'-1',1,'ru',0,0.00,0,'','',0,0,0,'2014-09-22 18:25:56','2010-09-13 11:23:39'),
	(4,'test',99,'banner_650x450.jpg','','',650,450,0,'jpg','','root','0000-00-00','0000-00-00','1','-1',0,NULL,'-1',1,'ru',0,0.00,0,'','',0,0,0,'2014-09-22 18:26:14','2012-10-24 09:26:28'),
	(5,'banner 3',99,'banner_320x210.jpg','','',320,210,0,'jpg','','root','0000-00-00','0000-00-00','2','-1',0,'','-1',1,'ru',0,0.00,0,'','',0,0,0,'2014-09-22 18:46:53','2014-09-22 14:46:41'),
	(6,'banner 4',99,'banner_320x1.jpg','','',320,210,0,'jpg','','root','0000-00-00','0000-00-00','3','-1',0,NULL,'-1',1,'ru',0,0.00,0,'','',0,0,0,'2014-09-22 18:47:13','2014-09-22 14:47:07');

/*!40000 ALTER TABLE `data_banner` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table data_banner_advert_block
# ------------------------------------------------------------

DROP TABLE IF EXISTS `data_banner_advert_block`;

CREATE TABLE `data_banner_advert_block` (
  `ID` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(128) NOT NULL DEFAULT '',
  `per_click` int(6) NOT NULL DEFAULT '0',
  `per_show` int(6) NOT NULL DEFAULT '0',
  `width` smallint(5) unsigned NOT NULL DEFAULT '0',
  `height` smallint(5) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`ID`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='СПРАВОЧНИК рекламных блоков';

LOCK TABLES `data_banner_advert_block` WRITE;
/*!40000 ALTER TABLE `data_banner_advert_block` DISABLE KEYS */;

INSERT INTO `data_banner_advert_block` (`ID`, `name`, `per_click`, `per_show`, `width`, `height`)
VALUES
	(1,'Главная. Слайдер (980x390)',0,0,980,390);

/*!40000 ALTER TABLE `data_banner_advert_block` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table data_banner_advert_users
# ------------------------------------------------------------

DROP TABLE IF EXISTS `data_banner_advert_users`;

CREATE TABLE `data_banner_advert_users` (
  `ID` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL DEFAULT '',
  `email` varchar(50) NOT NULL DEFAULT '',
  `phone` varchar(100) NOT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `email` (`email`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Список пользователей банерокрут';

LOCK TABLES `data_banner_advert_users` WRITE;
/*!40000 ALTER TABLE `data_banner_advert_users` DISABLE KEYS */;

INSERT INTO `data_banner_advert_users` (`ID`, `name`, `email`, `phone`)
VALUES
	(1,'тестовый','','');

/*!40000 ALTER TABLE `data_banner_advert_users` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table data_catalog_brands
# ------------------------------------------------------------

DROP TABLE IF EXISTS `data_catalog_brands`;

CREATE TABLE `data_catalog_brands` (
  `ID` bigint(7) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `keywords` varchar(255) DEFAULT NULL,
  `description` text,
  `rating` smallint(4) unsigned NOT NULL DEFAULT '0',
  `active` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `text` text NOT NULL,
  `operator` varchar(64) NOT NULL,
  `pict` varchar(255) DEFAULT '',
  `updated_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `pict_logo` varchar(255) DEFAULT NULL,
  `pict_logo_hover` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `rating` (`rating`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

LOCK TABLES `data_catalog_brands` WRITE;
/*!40000 ALTER TABLE `data_catalog_brands` DISABLE KEYS */;

INSERT INTO `data_catalog_brands` (`ID`, `name`, `keywords`, `description`, `rating`, `active`, `text`, `operator`, `pict`, `updated_at`, `created_at`, `pict_logo`, `pict_logo_hover`)
VALUES
	(1,'Бренд 1','','',99,1,'','root','natures-tunnel-hd-wallpaper.jpg','2014-09-19 19:52:37','0000-00-00 00:00:00','brand_122x122_color.png','brand_122x122_wb.png'),
	(2,'Бренд 2','','',99,1,'','root','driving-heaven-road-wallpaper.jpg','2014-09-19 19:56:14','0000-00-00 00:00:00','brand_122x122_color1.png','brand_122x122_wb1.png'),
	(3,'Бренд 3','','',99,1,'','root','banner2_650x450.jpg','2014-09-19 19:56:39','0000-00-00 00:00:00','brand_122x122_color2.png','brand_122x122_wb2.png');

/*!40000 ALTER TABLE `data_catalog_brands` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table data_catalog_categories
# ------------------------------------------------------------

DROP TABLE IF EXISTS `data_catalog_categories`;

CREATE TABLE `data_catalog_categories` (
  `ID` bigint(7) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `title` varchar(255) DEFAULT NULL,
  `keywords` text,
  `description` text,
  `alias` varchar(255) NOT NULL,
  `rating` smallint(4) unsigned NOT NULL DEFAULT '0',
  `active` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `text` text NOT NULL,
  `operator` varchar(64) NOT NULL,
  `pict` varchar(255) DEFAULT '',
  `updated_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `parent_category_id` int(6) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`ID`),
  KEY `rating` (`rating`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

LOCK TABLES `data_catalog_categories` WRITE;
/*!40000 ALTER TABLE `data_catalog_categories` DISABLE KEYS */;

INSERT INTO `data_catalog_categories` (`ID`, `name`, `title`, `keywords`, `description`, `alias`, `rating`, `active`, `text`, `operator`, `pict`, `updated_at`, `created_at`, `parent_category_id`)
VALUES
	(1,'Одежда','Одежда','','ОдеждаОдежда','odezhda',99,1,'','root','','0000-00-00 00:00:00','0000-00-00 00:00:00',0),
	(2,'Обувь','Обувь','','Обувь','obuv',99,1,'','root','','0000-00-00 00:00:00','0000-00-00 00:00:00',0),
	(3,'Аксессуары','Аксессуары','','АксессуарыАксессуары','aksessuary',99,1,'','root','','0000-00-00 00:00:00','0000-00-00 00:00:00',0),
	(4,'Куртки, пальто, пуховики','','','','kurtki-palto-puhoviki',99,1,'','root','','2014-09-18 13:18:31','0000-00-00 00:00:00',1),
	(5,'Толстовки, свитшоты','','','','tolstovki-svitshoty',99,1,'','root','','0000-00-00 00:00:00','2014-09-18 13:25:29',1),
	(6,'Кардиганы, свитеры, жилетки','','','','kardigany-svitery-zhiletki',99,1,'','root','','0000-00-00 00:00:00','2014-09-18 13:25:40',1);

/*!40000 ALTER TABLE `data_catalog_categories` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table data_catalog_items
# ------------------------------------------------------------

DROP TABLE IF EXISTS `data_catalog_items`;

CREATE TABLE `data_catalog_items` (
  `ID` bigint(7) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `title` varchar(255) DEFAULT NULL,
  `keywords` varchar(255) DEFAULT NULL,
  `description` text,
  `color_id` int(6) unsigned NOT NULL DEFAULT '0',
  `alias` varchar(255) NOT NULL,
  `rating` smallint(4) unsigned NOT NULL DEFAULT '0',
  `text` text NOT NULL,
  `images` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `operator` varchar(64) NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `is_new` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `is_sale` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `category_id` int(6) unsigned NOT NULL DEFAULT '0',
  `subcategory_id` int(6) unsigned NOT NULL DEFAULT '0',
  `brand_id` int(6) unsigned NOT NULL DEFAULT '0',
  `sizes` varchar(255) DEFAULT NULL,
  `articul` varchar(100) DEFAULT NULL,
  `sostav` varchar(255) DEFAULT NULL,
  `price` decimal(10,2) unsigned NOT NULL DEFAULT '0.00',
  `gender` smallint(3) unsigned NOT NULL DEFAULT '0',
  `pict` varchar(255) DEFAULT NULL,
  `active` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `recommend` varchar(255) DEFAULT '',
  PRIMARY KEY (`ID`),
  UNIQUE KEY `alias` (`alias`),
  KEY `rating` (`rating`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

LOCK TABLES `data_catalog_items` WRITE;
/*!40000 ALTER TABLE `data_catalog_items` DISABLE KEYS */;

INSERT INTO `data_catalog_items` (`ID`, `name`, `title`, `keywords`, `description`, `color_id`, `alias`, `rating`, `text`, `images`, `operator`, `updated_at`, `created_at`, `is_new`, `is_sale`, `category_id`, `subcategory_id`, `brand_id`, `sizes`, `articul`, `sostav`, `price`, `gender`, `pict`, `active`, `recommend`)
VALUES
	(1,'IRON FIST','','','',5,'iron_fist',99,'<p>Fab Store - крупнейший в Петербурге магазин молодежной обуви и одежды, единственное официальное представительство многих популярных западных брендов. Начинавший свою историю несколько лет назад как магазин английской обуви TUK, сегодня Fab Store увеличил и свои площади, и свой ассортимент в несколько раз. Все начиналось с официального представительства TUK - британской обувной марки узнаваемого дизайна, любимой богемной молодежью (поклонниками марки являются музыканты U2, Green Day, Avril Lavigne и многие другие). Открытие магазина в 2009-м стало событием - стильная молодежь стала съезжаться в TUK Shop  со всех концов города.</p>',0,'root','2014-09-19 18:43:12','2011-11-22 12:27:01',1,1,1,4,2,'42=3,43=2,44=1','12345','хлопок',3122.12,1,'1.jpg',1,'4=5'),
	(4,'Товар 2','','','',3,'tovar_2',2,'<p>Fab Store - крупнейший в Петербурге магазин молодежной обуви и одежды, единственное официальное представительство многих популярных западных брендов. Начинавший свою историю несколько лет назад как магазин английской обуви TUK, сегодня Fab Store увеличил и свои площади, и свой ассортимент в несколько раз. Все начиналось с официального представительства TUK - британской обувной марки узнаваемого дизайна, любимой богемной молодежью (поклонниками марки являются музыканты U2, Green Day, Avril Lavigne и многие другие). Открытие магазина в 2009-м стало событием - стильная молодежь стала съезжаться в TUK Shop  со всех концов города.</p>',0,'root','2014-09-18 19:24:36','0000-00-00 00:00:00',1,0,1,4,1,'','','',1200.00,2,'3.jpg',1,''),
	(5,'Товар 3','','','',2,'tovar-3',99,'<p>Fab Store - крупнейший в Петербурге магазин молодежной обуви и одежды, единственное официальное представительство многих популярных западных брендов. Начинавший свою историю несколько лет назад как магазин английской обуви TUK, сегодня Fab Store увеличил и свои площади, и свой ассортимент в несколько раз. Все начиналось с официального представительства TUK - британской обувной марки узнаваемого дизайна, любимой богемной молодежью (поклонниками марки являются музыканты U2, Green Day, Avril Lavigne и многие другие). Открытие магазина в 2009-м стало событием - стильная молодежь стала съезжаться в TUK Shop  со всех концов города.</p>',0,'root','2014-09-18 20:26:13','2014-09-18 19:25:00',0,1,1,6,1,'40=2,46=3','','',500.00,1,'4.jpg',1,'1=4'),
	(6,'',NULL,NULL,NULL,0,'',0,'',0,'root','2015-04-18 16:35:17','2015-04-18 16:35:15',0,0,0,0,0,NULL,NULL,NULL,0.00,0,NULL,0,'');

/*!40000 ALTER TABLE `data_catalog_items` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table data_catalog_orders
# ------------------------------------------------------------

DROP TABLE IF EXISTS `data_catalog_orders`;

CREATE TABLE `data_catalog_orders` (
  `ID` bigint(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `totalprice` bigint(9) unsigned NOT NULL DEFAULT '0',
  `city` varchar(255) NOT NULL,
  `phone` varchar(255) NOT NULL DEFAULT '',
  `email` varchar(255) NOT NULL,
  `address` text NOT NULL,
  `addressindex` varchar(255) NOT NULL,
  `street` varchar(255) DEFAULT NULL,
  `orderstatus` smallint(3) unsigned NOT NULL DEFAULT '0',
  `question` varchar(255) NOT NULL,
  `ordercomment` text NOT NULL,
  `operatorcomment` varchar(255) NOT NULL,
  `order` tinyint(1) unsigned NOT NULL,
  `house` varchar(255) DEFAULT '',
  `korpus` varchar(255) DEFAULT NULL,
  `apartment` varchar(255) DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `status` (`orderstatus`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

LOCK TABLES `data_catalog_orders` WRITE;
/*!40000 ALTER TABLE `data_catalog_orders` DISABLE KEYS */;

INSERT INTO `data_catalog_orders` (`ID`, `name`, `totalprice`, `city`, `phone`, `email`, `address`, `addressindex`, `street`, `orderstatus`, `question`, `ordercomment`, `operatorcomment`, `order`, `house`, `korpus`, `apartment`, `updated_at`, `created_at`)
VALUES
	(33,'teet',17111,'sfasdf','+7 (123) 213-12-31','test@test.ru','','asd',NULL,0,'','','',0,'123','123','123123','0000-00-00 00:00:00','0000-00-00 00:00:00'),
	(34,'teet',17111,'sfasdf','+7 (123) 213-12-31','test@test.ru','','asd',NULL,0,'','','',0,'123','123','123123','0000-00-00 00:00:00','0000-00-00 00:00:00'),
	(35,'teet',17111,'sfasdf','+7 (123) 213-12-31','test@test.ru','','asd','asdfasdf',0,'','sadfasfsafasfasfasdf','',0,'123','123','123123','0000-00-00 00:00:00','0000-00-00 00:00:00'),
	(36,'teet',17111,'sfasdf','+7 (123) 213-12-31','test@test.ru','','asd','asdfasdf',0,'','sadfasfsafasfasfasdf','',0,'123','123','123123','0000-00-00 00:00:00','0000-00-00 00:00:00'),
	(37,'teet',17111,'sfasdf','+7 (123) 213-12-31','test@test.ru','','asd','asdfasdf',0,'','sadfasfsafasfasfasdf','',0,'123','123','123123','0000-00-00 00:00:00','2014-09-22 16:45:06'),
	(38,'teet',17111,'sfasdf','+7 (123) 213-12-31','test@test.ru','','asd','asdfasdf',0,'','sadfasfsafasfasfasdf','',0,'123','123','123123','0000-00-00 00:00:00','2014-09-22 16:46:23'),
	(39,'teet',17111,'sfasdf','+7 (123) 213-12-31','test@test.ru','','asd','asdfasdf',0,'','sadfasfsafasfasfasdf','',0,'123','123','123123','0000-00-00 00:00:00','2014-09-22 16:46:50'),
	(40,'teet',17111,'sfasdf','+7 (123) 213-12-31','test@test.ru','','asd','asdfasdf',0,'','sadfasfsafasfasfasdf','',0,'123','123','123123','0000-00-00 00:00:00','2014-09-22 16:47:06'),
	(41,'teet',17111,'sfasdf','+7 (123) 213-12-31','test@test.ru','','asd','asdfasdf',0,'','sadfasfsafasfasfasdf','',0,'123','123','123123','0000-00-00 00:00:00','2014-09-22 16:47:19'),
	(42,'teet',17111,'sfasdf','+7 (123) 213-12-31','test@test.ru','','asd','asdfasdf',0,'','sadfasfsafasfasfasdf','',0,'123','123','123123','0000-00-00 00:00:00','2014-09-22 16:48:49'),
	(43,'teet',17111,'sfasdf','+7 (123) 213-12-31','test@test.ru','','asd','asdfasdf',0,'','sadfasfsafasfasfasdf','',0,'123','123','123123','0000-00-00 00:00:00','2014-09-22 16:50:14'),
	(44,'teet',17111,'sfasdf','+7 (123) 213-12-31','test@test.ru','','asd','',0,'','sadfasfsafasfasfasdf','',0,'','123','123123','0000-00-00 00:00:00','2014-09-22 17:05:26'),
	(45,'teet',17111,'sfasdf','+7 (123) 213-12-31','test@test.ru','','asd','',0,'','sadfasfsafasfasfasdf','',0,'','123','123123','0000-00-00 00:00:00','2014-09-22 17:05:44'),
	(46,'',17111,'','','','','','',0,'','','',0,'','','','0000-00-00 00:00:00','2014-09-22 17:10:08'),
	(47,'',17111,'','','','','','',0,'','','',0,'','','','0000-00-00 00:00:00','2014-09-22 17:13:56'),
	(48,'ыфваыфва',17111,'фвыафыв','+7 (123) 123-12-31','dev@ifrog.aas','','ыва','ыфвафыва',0,'','asdfasdfasdfs','',0,'123','фыва','12312','0000-00-00 00:00:00','2014-09-22 17:40:45'),
	(49,'ыфваыфва',17111,'фвыафыв','+7 (123) 123-12-31','dev@ifrog.aas','','ыва','ыфвафыва',0,'','asdfasdfasdfs','',0,'123','фыва','12312','0000-00-00 00:00:00','2014-09-22 17:41:13');

/*!40000 ALTER TABLE `data_catalog_orders` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table data_faq
# ------------------------------------------------------------

DROP TABLE IF EXISTS `data_faq`;

CREATE TABLE `data_faq` (
  `ID` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `author_name` varchar(100) CHARACTER SET utf8 NOT NULL,
  `email` varchar(255) NOT NULL,
  `name` text CHARACTER SET utf8 NOT NULL,
  `answer` text CHARACTER SET utf8 NOT NULL,
  `active` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `operator` varchar(50) NOT NULL DEFAULT '',
  `updated_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=MyISAM DEFAULT CHARSET=cp1251 PACK_KEYS=0 COMMENT='Изображения для фотогалерей';

LOCK TABLES `data_faq` WRITE;
/*!40000 ALTER TABLE `data_faq` DISABLE KEYS */;

INSERT INTO `data_faq` (`ID`, `author_name`, `email`, `name`, `answer`, `active`, `operator`, `updated_at`, `created_at`)
VALUES
	(74,'Александр Петрович, Екатеринбург','test@test.ru','Я потерял свои документы и не могу их восстановить. Мне очень срочно нужна прописка в СПб! Пожалуйста подскажите, как я могу сделать прописку в Санкт-Петербурге?','<p>\n	Вы можете получить консультацию по интересующему вас вопросу по телефону указанному на нашем сайте</p>\n',1,'root','2012-03-11 14:55:14','2010-07-19 18:04:37'),
	(81,'Равшан Джумшудов','ravshan@nachalnika.net','Можно ли работать гражданам СНГ в РФ официально без разрешения на работу?','<p>\n	Уважаемый Равшан! Ваш вопрос интересует многих ваших сограждан, но ответ на него вы сможете получить только если позвоните по контактным телефонам указанным в разделе &quot;Контакты&quot;</p>\n',1,'root','2012-03-11 18:16:17','2012-03-11 18:14:55'),
	(82,'Наташа','natali22@mail.ru','Можно ли прописать иностранного гражданина в рф?','<p>\n	Можно до 3-х месяцев как гостя и на 1 год по разрешению на работу.</p>\n',1,'root','2012-03-19 19:32:08','2012-03-19 19:28:02'),
	(83,'Николай','kolyan-shuxer@mail.ru','Можно ли сделать временную регистрацию с недействительным паспортом ?','<p>\n	Нет. Согласно законам РФ сделать временную регистрацию можно только при наличии действительного паспорта&nbsp;</p>\n',1,'root','2012-03-19 19:31:57','2012-03-19 19:31:06'),
	(84,'Мария','mashka-cheburashka@gmail.com','Добрый день! Подскажите, нужно ли делать регистрацию для родственников из Казахстана, которые приехали на неделю?','<p>\n	Обязательно нужно сделать регистрацию. Без регистрации граждане Казахстана могут находится на территории России не более 3-х дней</p>\n',1,'root','2012-03-19 19:35:23','2012-03-19 19:34:26'),
	(85,'Станислав','stasyan-opasyan@rambler.ru','Нужна ли сейчас временная регистрация для граждан РФ по приезду в другой город?','<p>\n	Да, гражданам РФ, которые проживают в другом регионе нужно делать временную регистрацию. Без регистрации можно находиться в другом регионе только 90 дней</p>\n',1,'root','2012-03-19 19:38:36','2012-03-19 19:37:53');

/*!40000 ALTER TABLE `data_faq` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table data_feedback
# ------------------------------------------------------------

DROP TABLE IF EXISTS `data_feedback`;

CREATE TABLE `data_feedback` (
  `ID` smallint(6) unsigned NOT NULL AUTO_INCREMENT,
  `l_name` varchar(150) NOT NULL,
  `f_name` varchar(255) NOT NULL,
  `phone` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `text` text NOT NULL,
  `created_at` datetime DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

LOCK TABLES `data_feedback` WRITE;
/*!40000 ALTER TABLE `data_feedback` DISABLE KEYS */;

INSERT INTO `data_feedback` (`ID`, `l_name`, `f_name`, `phone`, `email`, `text`, `created_at`)
VALUES
	(1,'','','','test@test.ru','test','2010-10-05 11:42:18'),
	(2,'test','test','test','test@test.ru','test','2010-10-05 11:44:52');

/*!40000 ALTER TABLE `data_feedback` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table data_recall
# ------------------------------------------------------------

DROP TABLE IF EXISTS `data_recall`;

CREATE TABLE `data_recall` (
  `ID` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8 NOT NULL,
  `email` varchar(255) NOT NULL,
  `recall` text CHARACTER SET utf8 NOT NULL,
  `answer_name` varchar(255) NOT NULL,
  `answer` text CHARACTER SET utf8 NOT NULL,
  `active` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `operator` varchar(50) NOT NULL DEFAULT '',
  `tdate` date NOT NULL DEFAULT '0000-00-00',
  `updated_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=MyISAM DEFAULT CHARSET=cp1251 COMMENT='Отзывы';

LOCK TABLES `data_recall` WRITE;
/*!40000 ALTER TABLE `data_recall` DISABLE KEYS */;

INSERT INTO `data_recall` (`ID`, `name`, `email`, `recall`, `answer_name`, `answer`, `active`, `operator`, `tdate`, `updated_at`, `created_at`)
VALUES
	(8,'Тест','rn.dev@ifrog.ru','Тестовый отзыв','Игорь, izTaoBao','<p>Спасибо за тестовый отзыв.</p>',1,'root','2015-04-22','2015-04-03 18:16:08','2015-04-03 18:14:12');

/*!40000 ALTER TABLE `data_recall` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table data_redirects
# ------------------------------------------------------------

DROP TABLE IF EXISTS `data_redirects`;

CREATE TABLE `data_redirects` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `source_url` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `last_url` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `operator` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

LOCK TABLES `data_redirects` WRITE;
/*!40000 ALTER TABLE `data_redirects` DISABLE KEYS */;

INSERT INTO `data_redirects` (`ID`, `source_url`, `last_url`, `updated_at`, `created_at`, `operator`)
VALUES
	(1,'http://yandex.ru','http://google.com',NULL,'2015-04-18 17:08:53','root');

/*!40000 ALTER TABLE `data_redirects` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table data_seo
# ------------------------------------------------------------

DROP TABLE IF EXISTS `data_seo`;

CREATE TABLE `data_seo` (
  `ID` int(6) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(128) NOT NULL DEFAULT '',
  `url` text NOT NULL,
  `keywords` varchar(255) NOT NULL DEFAULT '0',
  `description` text NOT NULL,
  `seo_title` varchar(255) NOT NULL,
  `seo_text` text,
  PRIMARY KEY (`ID`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Мета теги для плагина SEO';



# Dump of table data_subscribe
# ------------------------------------------------------------

DROP TABLE IF EXISTS `data_subscribe`;

CREATE TABLE `data_subscribe` (
  `ID` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL DEFAULT '',
  `subject` varchar(255) NOT NULL DEFAULT '',
  `send` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `stat` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `text` text NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=MyISAM DEFAULT CHARSET=cp1251;

LOCK TABLES `data_subscribe` WRITE;
/*!40000 ALTER TABLE `data_subscribe` DISABLE KEYS */;

INSERT INTO `data_subscribe` (`ID`, `name`, `subject`, `send`, `stat`, `text`)
VALUES
	(25,'тест','тест',0,0,'<p>\n	это тестовая рассылка</p>\n'),
	(26,'тест2','тест2',1,0,'<p>\n	тестовая рассылка</p>\n');

/*!40000 ALTER TABLE `data_subscribe` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table data_subscribe_groups
# ------------------------------------------------------------

DROP TABLE IF EXISTS `data_subscribe_groups`;

CREATE TABLE `data_subscribe_groups` (
  `ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

LOCK TABLES `data_subscribe_groups` WRITE;
/*!40000 ALTER TABLE `data_subscribe_groups` DISABLE KEYS */;

INSERT INTO `data_subscribe_groups` (`ID`, `name`)
VALUES
	(1,'Основная'),
	(2,'Тест');

/*!40000 ALTER TABLE `data_subscribe_groups` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table data_subscribe_stat
# ------------------------------------------------------------

DROP TABLE IF EXISTS `data_subscribe_stat`;

CREATE TABLE `data_subscribe_stat` (
  `ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `id_data_subscribe` int(11) NOT NULL DEFAULT '0',
  `id_user` int(11) NOT NULL DEFAULT '0',
  `send_date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`ID`),
  UNIQUE KEY `id_data_subscribe` (`id_data_subscribe`,`id_user`)
) ENGINE=MyISAM DEFAULT CHARSET=cp1251;

LOCK TABLES `data_subscribe_stat` WRITE;
/*!40000 ALTER TABLE `data_subscribe_stat` DISABLE KEYS */;

INSERT INTO `data_subscribe_stat` (`ID`, `id_data_subscribe`, `id_user`, `send_date`)
VALUES
	(11,29,2,'2014-02-26 20:45:19'),
	(10,28,1,'2014-02-26 20:45:19');

/*!40000 ALTER TABLE `data_subscribe_stat` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table data_subscribe_users
# ------------------------------------------------------------

DROP TABLE IF EXISTS `data_subscribe_users`;

CREATE TABLE `data_subscribe_users` (
  `ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `email` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `id_group` int(10) unsigned NOT NULL DEFAULT '1',
  `cck` bigint(20) unsigned NOT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

LOCK TABLES `data_subscribe_users` WRITE;
/*!40000 ALTER TABLE `data_subscribe_users` DISABLE KEYS */;

INSERT INTO `data_subscribe_users` (`ID`, `email`, `id_group`, `cck`, `active`)
VALUES
	(1,'rnovoselov93@gmail.com',2,0,0),
	(2,'roman_novoselov@mail.ru',1,0,0);

/*!40000 ALTER TABLE `data_subscribe_users` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table data_users
# ------------------------------------------------------------

DROP TABLE IF EXISTS `data_users`;

CREATE TABLE `data_users` (
  `ID` int(6) unsigned NOT NULL AUTO_INCREMENT,
  `cck` varchar(128) NOT NULL,
  `name` varchar(255) NOT NULL,
  `mname` varchar(150) NOT NULL,
  `fname` varchar(150) NOT NULL,
  `post` varchar(150) NOT NULL,
  `company` varchar(255) NOT NULL,
  `phone` varchar(150) NOT NULL,
  `id_manager` int(6) unsigned NOT NULL DEFAULT '0',
  `email` varchar(255) NOT NULL,
  `password_digest` varchar(255) NOT NULL DEFAULT '',
  `vdate` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `operator` varchar(100) NOT NULL,
  `active` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `data` blob NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `email` (`email`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 PACK_KEYS=0 COMMENT='Таблица с паролями';

LOCK TABLES `data_users` WRITE;
/*!40000 ALTER TABLE `data_users` DISABLE KEYS */;

INSERT INTO `data_users` (`ID`, `cck`, `name`, `mname`, `fname`, `post`, `company`, `phone`, `id_manager`, `email`, `password_digest`, `vdate`, `operator`, `active`, `data`, `updated_at`, `created_at`)
VALUES
	(1,'cab9f6fceed5d850404747dfdfca5fa5','adfsaf','','','','','',0,'test@test.ru','123','0000-00-00 00:00:00','',1,'','2013-03-13 17:19:27','2013-03-07 19:06:08'),
	(2,'','adfsaf','','','','','',0,'test2@test.ru','123','0000-00-00 00:00:00','',1,'','0000-00-00 00:00:00','2013-03-07 19:06:28'),
	(3,'','Алексей','','','','','',4,'test3@test.ru','test','0000-00-00 00:00:00','root',1,'','2013-03-13 18:21:07','2013-03-07 19:08:12'),
	(6,'','Александр','','','','','',4,'7902633@mail.ru','unreal','0000-00-00 00:00:00','root',1,'','2013-03-13 18:43:43','2013-03-13 18:32:00'),
	(5,'','Кирилл','','','','','',4,'ktoesline@ya.ru','123','0000-00-00 00:00:00','root',1,'','2013-03-13 18:24:47','2013-03-13 18:12:17');

/*!40000 ALTER TABLE `data_users` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table data_vfe_blocks_ru
# ------------------------------------------------------------

DROP TABLE IF EXISTS `data_vfe_blocks_ru`;

CREATE TABLE `data_vfe_blocks_ru` (
  `ID` int(10) NOT NULL AUTO_INCREMENT,
  `alias` varchar(255) NOT NULL DEFAULT '',
  `text` text NOT NULL,
  `sysuser_id` int(6) unsigned NOT NULL,
  `updated_at` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`ID`),
  UNIQUE KEY `alias` (`alias`),
  FULLTEXT KEY `text` (`text`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Vfe';



# Dump of table data_video
# ------------------------------------------------------------

DROP TABLE IF EXISTS `data_video`;

CREATE TABLE `data_video` (
  `ID` bigint(7) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(150) NOT NULL,
  `youtubelink` varchar(50) DEFAULT '',
  `vimeolink` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  `alias` varchar(255) NOT NULL,
  `_pict` varchar(100) NOT NULL DEFAULT '',
  `rating` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `active` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `operator` varchar(64) NOT NULL,
  `_dir` tinyint(1) unsigned NOT NULL,
  `_id_video` tinyint(1) unsigned NOT NULL,
  `description` text,
  `tdate` date DEFAULT '0000-00-00',
  `has_mainpage` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `id_category` int(10) unsigned NOT NULL,
  `updated_at` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_at` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`ID`),
  KEY `active` (`active`),
  KEY `rating` (`rating`),
  KEY `alias` (`alias`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

LOCK TABLES `data_video` WRITE;
/*!40000 ALTER TABLE `data_video` DISABLE KEYS */;

INSERT INTO `data_video` (`ID`, `name`, `youtubelink`, `vimeolink`, `alias`, `_pict`, `rating`, `active`, `operator`, `_dir`, `_id_video`, `description`, `tdate`, `has_mainpage`, `id_category`, `updated_at`, `created_at`)
VALUES
	(93,'November Rain','8SbUC-UaAxE',NULL,'november-rain','5.jpg',1,1,'root',0,0,'Music video by Guns N» Roses performing November Rain.','2014-05-16',0,0,'2014-05-27 12:56:11','2014-05-20 19:41:19'),
	(96,'“Попробуй мечту на вкус!” – кино о серфинге (HD).','UMYuB_zmfBw',NULL,'poprobuj-mechtu-na-vkus-kino-o-serfinge-hd','',99,1,'root',0,0,'','0000-00-00',0,0,'2014-06-10 17:41:10','2014-06-10 17:04:46'),
	(97,'Surfvan – мокро, но весело))','YXNaIEXvQH8',NULL,'surfvan-mokro-no-veselo','',100,1,'root',0,0,'','0000-00-00',0,0,'2014-06-10 17:41:20','2014-06-10 17:17:01'),
	(98,'SURF and the CITY','an1up8QvED8',NULL,'surf-and-city','',110,1,'root',0,0,'','0000-00-00',0,0,'2014-06-10 17:41:35','2014-06-10 17:18:10'),
	(99,'Vimeo video testing','','97270099','vimeo-video-testing','',99,1,'root',0,0,'','0000-00-00',0,0,'2014-06-10 18:44:59','2014-06-10 18:33:12');

/*!40000 ALTER TABLE `data_video` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table dtbl_banner_stat
# ------------------------------------------------------------

DROP TABLE IF EXISTS `dtbl_banner_stat`;

CREATE TABLE `dtbl_banner_stat` (
  `ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `id_banner` int(10) unsigned NOT NULL DEFAULT '0',
  `tdate` date NOT NULL DEFAULT '0000-00-00',
  `view_count` int(10) unsigned NOT NULL DEFAULT '0',
  `click_count` int(10) unsigned NOT NULL DEFAULT '0',
  `view_pay` decimal(5,2) NOT NULL DEFAULT '0.00',
  `click_pay` decimal(5,2) NOT NULL DEFAULT '0.00',
  `ip_data_click` text NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Статистика показов рекламы';

LOCK TABLES `dtbl_banner_stat` WRITE;
/*!40000 ALTER TABLE `dtbl_banner_stat` DISABLE KEYS */;

INSERT INTO `dtbl_banner_stat` (`ID`, `id_banner`, `tdate`, `view_count`, `click_count`, `view_pay`, `click_pay`, `ip_data_click`)
VALUES
	(1002,2,'0000-00-00',1,3,0.00,0.00,''),
	(1003,2,'0000-00-00',1,3,0.00,0.00,''),
	(1005,2,'0000-00-00',1,3,0.00,0.00,''),
	(1006,2,'0000-00-00',1,3,0.00,0.00,''),
	(1007,2,'0000-00-00',1,3,0.00,0.00,''),
	(1008,2,'0000-00-00',1,3,0.00,0.00,''),
	(1009,2,'0000-00-00',1,3,0.00,0.00,''),
	(1010,2,'0000-00-00',1,3,0.00,0.00,''),
	(1011,2,'0000-00-00',1,3,0.00,0.00,''),
	(1012,2,'0000-00-00',1,3,0.00,0.00,''),
	(1013,2,'0000-00-00',1,3,0.00,0.00,''),
	(1014,2,'0000-00-00',1,3,0.00,0.00,''),
	(1015,2,'0000-00-00',1,3,0.00,0.00,''),
	(1016,2,'0000-00-00',1,3,0.00,0.00,''),
	(1017,2,'0000-00-00',1,3,0.00,0.00,''),
	(1018,2,'0000-00-00',1,3,0.00,0.00,''),
	(1019,2,'0000-00-00',1,3,0.00,0.00,''),
	(1020,2,'0000-00-00',1,3,0.00,0.00,''),
	(1021,2,'0000-00-00',1,3,0.00,0.00,''),
	(1022,2,'0000-00-00',1,3,0.00,0.00,''),
	(1023,2,'0000-00-00',1,3,0.00,0.00,''),
	(1024,2,'0000-00-00',1,3,0.00,0.00,''),
	(1025,2,'0000-00-00',1,3,0.00,0.00,''),
	(1026,2,'0000-00-00',1,3,0.00,0.00,''),
	(1027,2,'0000-00-00',1,3,0.00,0.00,''),
	(1028,2,'0000-00-00',1,3,0.00,0.00,''),
	(1029,2,'0000-00-00',1,3,0.00,0.00,''),
	(1030,2,'0000-00-00',1,3,0.00,0.00,''),
	(1031,2,'0000-00-00',1,3,0.00,0.00,''),
	(1032,2,'0000-00-00',1,3,0.00,0.00,''),
	(1033,2,'0000-00-00',1,3,0.00,0.00,''),
	(1034,2,'0000-00-00',1,3,0.00,0.00,''),
	(1035,2,'0000-00-00',1,3,0.00,0.00,''),
	(1036,2,'0000-00-00',1,3,0.00,0.00,''),
	(1037,2,'0000-00-00',1,3,0.00,0.00,''),
	(1038,2,'0000-00-00',1,3,0.00,0.00,''),
	(1039,2,'0000-00-00',1,3,0.00,0.00,''),
	(1040,2,'0000-00-00',1,3,0.00,0.00,''),
	(1041,2,'0000-00-00',1,3,0.00,0.00,''),
	(1042,2,'0000-00-00',1,3,0.00,0.00,''),
	(1043,2,'0000-00-00',1,3,0.00,0.00,''),
	(1044,2,'0000-00-00',1,3,0.00,0.00,''),
	(1045,2,'0000-00-00',1,3,0.00,0.00,''),
	(1046,2,'0000-00-00',1,3,0.00,0.00,''),
	(1047,2,'0000-00-00',1,3,0.00,0.00,''),
	(1048,2,'0000-00-00',1,3,0.00,0.00,''),
	(1049,2,'0000-00-00',1,3,0.00,0.00,''),
	(1050,2,'0000-00-00',1,3,0.00,0.00,''),
	(1051,2,'0000-00-00',1,3,0.00,0.00,''),
	(1052,2,'0000-00-00',1,3,0.00,0.00,''),
	(1053,2,'0000-00-00',1,3,0.00,0.00,''),
	(1054,2,'0000-00-00',1,3,0.00,0.00,''),
	(1055,2,'0000-00-00',1,3,0.00,0.00,''),
	(1056,2,'0000-00-00',1,3,0.00,0.00,''),
	(1057,2,'0000-00-00',1,3,0.00,0.00,''),
	(1058,2,'0000-00-00',1,3,0.00,0.00,''),
	(1059,2,'0000-00-00',1,3,0.00,0.00,''),
	(1060,2,'0000-00-00',1,3,0.00,0.00,''),
	(1061,2,'0000-00-00',1,3,0.00,0.00,''),
	(1062,2,'0000-00-00',1,3,0.00,0.00,''),
	(1063,2,'0000-00-00',1,3,0.00,0.00,''),
	(1064,2,'0000-00-00',1,3,0.00,0.00,''),
	(1065,2,'0000-00-00',1,3,0.00,0.00,''),
	(1066,2,'0000-00-00',1,3,0.00,0.00,''),
	(1067,2,'0000-00-00',1,3,0.00,0.00,''),
	(1068,2,'0000-00-00',1,3,0.00,0.00,''),
	(1069,2,'0000-00-00',1,3,0.00,0.00,''),
	(1070,2,'0000-00-00',1,3,0.00,0.00,''),
	(1071,2,'0000-00-00',1,3,0.00,0.00,''),
	(1072,2,'0000-00-00',1,3,0.00,0.00,''),
	(1073,2,'0000-00-00',1,3,0.00,0.00,''),
	(1074,2,'0000-00-00',1,3,0.00,0.00,''),
	(1075,2,'0000-00-00',1,3,0.00,0.00,''),
	(1076,2,'0000-00-00',1,3,0.00,0.00,''),
	(1077,2,'0000-00-00',1,3,0.00,0.00,''),
	(1078,2,'0000-00-00',1,3,0.00,0.00,''),
	(1079,2,'0000-00-00',1,3,0.00,0.00,''),
	(1080,2,'0000-00-00',1,3,0.00,0.00,''),
	(1081,2,'0000-00-00',1,3,0.00,0.00,''),
	(1082,2,'0000-00-00',1,3,0.00,0.00,''),
	(1083,2,'0000-00-00',1,3,0.00,0.00,''),
	(1084,2,'0000-00-00',1,3,0.00,0.00,''),
	(1085,2,'0000-00-00',1,3,0.00,0.00,''),
	(1086,2,'0000-00-00',1,3,0.00,0.00,''),
	(1087,2,'0000-00-00',1,3,0.00,0.00,''),
	(1088,2,'0000-00-00',1,3,0.00,0.00,''),
	(1089,2,'0000-00-00',1,3,0.00,0.00,''),
	(1090,2,'0000-00-00',1,3,0.00,0.00,''),
	(1091,2,'0000-00-00',1,3,0.00,0.00,''),
	(1092,2,'0000-00-00',1,3,0.00,0.00,''),
	(1093,2,'0000-00-00',1,3,0.00,0.00,''),
	(1094,2,'0000-00-00',1,3,0.00,0.00,''),
	(1095,2,'0000-00-00',1,3,0.00,0.00,''),
	(1096,2,'0000-00-00',1,3,0.00,0.00,''),
	(1097,2,'0000-00-00',1,3,0.00,0.00,''),
	(1098,2,'0000-00-00',1,3,0.00,0.00,''),
	(1099,2,'0000-00-00',1,3,0.00,0.00,''),
	(1100,2,'0000-00-00',1,3,0.00,0.00,''),
	(1101,2,'0000-00-00',1,3,0.00,0.00,''),
	(1102,2,'0000-00-00',1,3,0.00,0.00,''),
	(1103,2,'0000-00-00',1,3,0.00,0.00,''),
	(1104,2,'0000-00-00',1,3,0.00,0.00,''),
	(1105,2,'0000-00-00',1,3,0.00,0.00,''),
	(1106,2,'0000-00-00',1,3,0.00,0.00,''),
	(1107,2,'0000-00-00',1,3,0.00,0.00,''),
	(1108,2,'0000-00-00',1,3,0.00,0.00,''),
	(1109,2,'0000-00-00',1,3,0.00,0.00,''),
	(1110,2,'0000-00-00',1,3,0.00,0.00,''),
	(1111,2,'0000-00-00',1,3,0.00,0.00,''),
	(1112,2,'0000-00-00',1,3,0.00,0.00,''),
	(1113,2,'0000-00-00',1,3,0.00,0.00,''),
	(1114,2,'0000-00-00',1,3,0.00,0.00,''),
	(1115,2,'0000-00-00',1,3,0.00,0.00,''),
	(1116,2,'0000-00-00',1,3,0.00,0.00,''),
	(1117,2,'0000-00-00',1,3,0.00,0.00,''),
	(1118,2,'0000-00-00',1,3,0.00,0.00,''),
	(1119,2,'0000-00-00',1,3,0.00,0.00,''),
	(1120,2,'0000-00-00',1,3,0.00,0.00,''),
	(1121,2,'0000-00-00',1,3,0.00,0.00,''),
	(1122,2,'0000-00-00',1,3,0.00,0.00,''),
	(1123,2,'0000-00-00',1,3,0.00,0.00,''),
	(1124,2,'0000-00-00',1,3,0.00,0.00,''),
	(1125,2,'0000-00-00',1,3,0.00,0.00,''),
	(1126,2,'0000-00-00',1,3,0.00,0.00,''),
	(1127,2,'0000-00-00',1,3,0.00,0.00,''),
	(1128,2,'0000-00-00',1,3,0.00,0.00,''),
	(1129,2,'0000-00-00',1,3,0.00,0.00,''),
	(1130,2,'0000-00-00',1,3,0.00,0.00,''),
	(1131,2,'0000-00-00',1,3,0.00,0.00,''),
	(1132,2,'0000-00-00',1,3,0.00,0.00,''),
	(1133,2,'0000-00-00',1,3,0.00,0.00,''),
	(1134,2,'0000-00-00',1,3,0.00,0.00,''),
	(1135,2,'0000-00-00',1,3,0.00,0.00,''),
	(1136,2,'0000-00-00',1,3,0.00,0.00,''),
	(1137,2,'0000-00-00',1,3,0.00,0.00,''),
	(1138,2,'0000-00-00',1,3,0.00,0.00,''),
	(1139,2,'0000-00-00',1,3,0.00,0.00,''),
	(1140,2,'0000-00-00',1,3,0.00,0.00,''),
	(1141,2,'0000-00-00',1,3,0.00,0.00,''),
	(1142,2,'0000-00-00',1,3,0.00,0.00,''),
	(1143,2,'0000-00-00',1,3,0.00,0.00,''),
	(1144,2,'0000-00-00',1,3,0.00,0.00,''),
	(1145,2,'0000-00-00',1,3,0.00,0.00,''),
	(1146,2,'0000-00-00',1,3,0.00,0.00,''),
	(1147,2,'0000-00-00',1,3,0.00,0.00,''),
	(1148,2,'0000-00-00',1,3,0.00,0.00,''),
	(1149,2,'0000-00-00',1,3,0.00,0.00,''),
	(1150,2,'0000-00-00',1,3,0.00,0.00,''),
	(1151,2,'0000-00-00',1,3,0.00,0.00,''),
	(1152,2,'0000-00-00',1,3,0.00,0.00,''),
	(1153,2,'0000-00-00',1,3,0.00,0.00,''),
	(1154,2,'0000-00-00',1,3,0.00,0.00,''),
	(1155,2,'0000-00-00',1,3,0.00,0.00,''),
	(1156,2,'0000-00-00',1,3,0.00,0.00,''),
	(1157,2,'0000-00-00',1,3,0.00,0.00,''),
	(1158,2,'0000-00-00',1,3,0.00,0.00,''),
	(1159,2,'0000-00-00',1,3,0.00,0.00,''),
	(1160,2,'0000-00-00',1,3,0.00,0.00,''),
	(1161,2,'0000-00-00',1,3,0.00,0.00,''),
	(1162,2,'0000-00-00',1,3,0.00,0.00,''),
	(1163,2,'0000-00-00',1,3,0.00,0.00,''),
	(1164,2,'0000-00-00',1,3,0.00,0.00,''),
	(1165,2,'0000-00-00',1,3,0.00,0.00,''),
	(1166,2,'0000-00-00',1,3,0.00,0.00,''),
	(1167,2,'0000-00-00',1,3,0.00,0.00,''),
	(1168,2,'0000-00-00',1,3,0.00,0.00,''),
	(1169,2,'0000-00-00',1,3,0.00,0.00,''),
	(1170,2,'0000-00-00',1,3,0.00,0.00,''),
	(1171,2,'0000-00-00',1,3,0.00,0.00,''),
	(1172,2,'0000-00-00',1,3,0.00,0.00,''),
	(1173,2,'0000-00-00',1,3,0.00,0.00,''),
	(1174,2,'0000-00-00',1,3,0.00,0.00,''),
	(1175,2,'0000-00-00',1,3,0.00,0.00,''),
	(1176,2,'0000-00-00',1,3,0.00,0.00,''),
	(1177,2,'0000-00-00',1,3,0.00,0.00,''),
	(1178,2,'0000-00-00',1,3,0.00,0.00,''),
	(1179,2,'0000-00-00',1,3,0.00,0.00,''),
	(1180,2,'0000-00-00',1,3,0.00,0.00,''),
	(1181,2,'0000-00-00',1,3,0.00,0.00,''),
	(1182,2,'0000-00-00',1,3,0.00,0.00,''),
	(1183,2,'0000-00-00',1,3,0.00,0.00,''),
	(1184,2,'0000-00-00',1,3,0.00,0.00,''),
	(1185,2,'0000-00-00',1,3,0.00,0.00,''),
	(1186,2,'0000-00-00',1,3,0.00,0.00,''),
	(1187,2,'0000-00-00',1,3,0.00,0.00,''),
	(1188,2,'0000-00-00',1,3,0.00,0.00,''),
	(1189,2,'0000-00-00',1,3,0.00,0.00,''),
	(1190,2,'0000-00-00',1,3,0.00,0.00,''),
	(1191,2,'0000-00-00',1,3,0.00,0.00,''),
	(1192,2,'0000-00-00',1,3,0.00,0.00,''),
	(1193,2,'0000-00-00',1,3,0.00,0.00,''),
	(1194,2,'0000-00-00',1,3,0.00,0.00,''),
	(1195,2,'0000-00-00',1,3,0.00,0.00,''),
	(1196,2,'0000-00-00',1,3,0.00,0.00,''),
	(1197,2,'0000-00-00',1,3,0.00,0.00,''),
	(1198,2,'0000-00-00',1,3,0.00,0.00,''),
	(1199,2,'0000-00-00',1,3,0.00,0.00,''),
	(1200,2,'0000-00-00',1,3,0.00,0.00,''),
	(1201,2,'0000-00-00',1,3,0.00,0.00,''),
	(1202,2,'0000-00-00',1,3,0.00,0.00,''),
	(1203,2,'0000-00-00',1,3,0.00,0.00,''),
	(1204,2,'0000-00-00',1,3,0.00,0.00,''),
	(1205,2,'0000-00-00',1,3,0.00,0.00,''),
	(1206,2,'0000-00-00',1,3,0.00,0.00,''),
	(1207,2,'0000-00-00',1,3,0.00,0.00,''),
	(1208,2,'0000-00-00',1,3,0.00,0.00,''),
	(1209,2,'0000-00-00',1,3,0.00,0.00,''),
	(1210,2,'0000-00-00',1,3,0.00,0.00,''),
	(1211,2,'0000-00-00',1,3,0.00,0.00,''),
	(1212,2,'0000-00-00',1,3,0.00,0.00,''),
	(1213,2,'0000-00-00',1,3,0.00,0.00,''),
	(1214,2,'0000-00-00',1,3,0.00,0.00,''),
	(1215,2,'0000-00-00',1,3,0.00,0.00,''),
	(1216,2,'0000-00-00',1,3,0.00,0.00,''),
	(1217,2,'0000-00-00',1,3,0.00,0.00,''),
	(1218,2,'0000-00-00',1,3,0.00,0.00,''),
	(1219,2,'0000-00-00',1,3,0.00,0.00,''),
	(1220,2,'0000-00-00',1,3,0.00,0.00,''),
	(1221,2,'0000-00-00',1,3,0.00,0.00,''),
	(1222,2,'0000-00-00',1,3,0.00,0.00,''),
	(1223,2,'0000-00-00',1,3,0.00,0.00,''),
	(1224,2,'0000-00-00',1,3,0.00,0.00,''),
	(1225,2,'0000-00-00',1,3,0.00,0.00,''),
	(1226,2,'0000-00-00',1,3,0.00,0.00,''),
	(1227,2,'0000-00-00',1,3,0.00,0.00,''),
	(1228,2,'0000-00-00',1,3,0.00,0.00,''),
	(1229,2,'0000-00-00',1,3,0.00,0.00,''),
	(1230,2,'0000-00-00',1,3,0.00,0.00,''),
	(1231,2,'0000-00-00',1,3,0.00,0.00,''),
	(1232,2,'0000-00-00',1,3,0.00,0.00,''),
	(1233,2,'0000-00-00',1,3,0.00,0.00,''),
	(1234,2,'0000-00-00',1,3,0.00,0.00,''),
	(1235,2,'0000-00-00',1,3,0.00,0.00,''),
	(1236,2,'0000-00-00',1,3,0.00,0.00,''),
	(1237,2,'0000-00-00',1,3,0.00,0.00,''),
	(1238,2,'0000-00-00',1,3,0.00,0.00,''),
	(1239,2,'0000-00-00',1,3,0.00,0.00,''),
	(1240,2,'0000-00-00',1,3,0.00,0.00,''),
	(1241,2,'0000-00-00',1,3,0.00,0.00,''),
	(1242,2,'0000-00-00',1,3,0.00,0.00,''),
	(1243,2,'0000-00-00',1,3,0.00,0.00,''),
	(1244,2,'0000-00-00',1,3,0.00,0.00,''),
	(1245,2,'0000-00-00',1,3,0.00,0.00,''),
	(1246,2,'0000-00-00',1,3,0.00,0.00,''),
	(1247,2,'0000-00-00',1,3,0.00,0.00,''),
	(1248,2,'0000-00-00',1,3,0.00,0.00,''),
	(1249,2,'0000-00-00',1,3,0.00,0.00,''),
	(1250,2,'0000-00-00',1,3,0.00,0.00,''),
	(1251,2,'0000-00-00',1,3,0.00,0.00,''),
	(1252,2,'0000-00-00',1,3,0.00,0.00,''),
	(1253,2,'0000-00-00',1,3,0.00,0.00,''),
	(1254,2,'0000-00-00',1,3,0.00,0.00,''),
	(1255,2,'0000-00-00',1,3,0.00,0.00,''),
	(1256,2,'0000-00-00',1,3,0.00,0.00,''),
	(1257,2,'0000-00-00',1,3,0.00,0.00,''),
	(1258,2,'0000-00-00',1,3,0.00,0.00,''),
	(1259,2,'0000-00-00',1,3,0.00,0.00,''),
	(1260,2,'0000-00-00',1,3,0.00,0.00,''),
	(1261,2,'0000-00-00',1,3,0.00,0.00,''),
	(1262,2,'0000-00-00',1,3,0.00,0.00,''),
	(1263,2,'0000-00-00',1,3,0.00,0.00,''),
	(1264,2,'0000-00-00',1,3,0.00,0.00,''),
	(1265,2,'0000-00-00',1,3,0.00,0.00,''),
	(1266,2,'0000-00-00',1,3,0.00,0.00,''),
	(1267,2,'0000-00-00',1,3,0.00,0.00,''),
	(1268,2,'0000-00-00',1,3,0.00,0.00,''),
	(1269,2,'0000-00-00',1,3,0.00,0.00,''),
	(1270,2,'0000-00-00',1,3,0.00,0.00,''),
	(1271,2,'0000-00-00',1,3,0.00,0.00,''),
	(1272,2,'0000-00-00',1,3,0.00,0.00,''),
	(1273,2,'0000-00-00',1,3,0.00,0.00,''),
	(1274,2,'0000-00-00',1,3,0.00,0.00,''),
	(1275,2,'0000-00-00',1,3,0.00,0.00,''),
	(1276,2,'0000-00-00',1,3,0.00,0.00,''),
	(1277,2,'0000-00-00',1,3,0.00,0.00,''),
	(1278,2,'0000-00-00',1,3,0.00,0.00,''),
	(1279,2,'0000-00-00',1,3,0.00,0.00,''),
	(1280,2,'0000-00-00',1,3,0.00,0.00,''),
	(1281,2,'0000-00-00',1,3,0.00,0.00,''),
	(1282,2,'0000-00-00',1,3,0.00,0.00,''),
	(1283,2,'0000-00-00',1,3,0.00,0.00,''),
	(1284,2,'0000-00-00',1,3,0.00,0.00,''),
	(1285,2,'0000-00-00',1,3,0.00,0.00,''),
	(1286,2,'0000-00-00',1,3,0.00,0.00,''),
	(1287,2,'0000-00-00',1,3,0.00,0.00,''),
	(1288,2,'0000-00-00',1,3,0.00,0.00,''),
	(1289,2,'0000-00-00',1,3,0.00,0.00,''),
	(1290,2,'0000-00-00',1,3,0.00,0.00,''),
	(1291,2,'0000-00-00',1,3,0.00,0.00,''),
	(1292,2,'0000-00-00',1,3,0.00,0.00,''),
	(1293,2,'0000-00-00',1,3,0.00,0.00,''),
	(1294,2,'0000-00-00',1,3,0.00,0.00,''),
	(1295,2,'0000-00-00',1,3,0.00,0.00,''),
	(1296,2,'0000-00-00',1,3,0.00,0.00,''),
	(1297,2,'0000-00-00',1,3,0.00,0.00,''),
	(1298,2,'0000-00-00',1,3,0.00,0.00,''),
	(1299,2,'0000-00-00',1,3,0.00,0.00,''),
	(1300,2,'0000-00-00',1,3,0.00,0.00,''),
	(1301,2,'0000-00-00',1,3,0.00,0.00,''),
	(1302,2,'0000-00-00',1,3,0.00,0.00,''),
	(1303,2,'0000-00-00',1,3,0.00,0.00,''),
	(1304,2,'0000-00-00',1,3,0.00,0.00,''),
	(1305,2,'0000-00-00',1,3,0.00,0.00,''),
	(1306,2,'0000-00-00',1,3,0.00,0.00,''),
	(1307,2,'0000-00-00',1,3,0.00,0.00,''),
	(1308,2,'0000-00-00',1,3,0.00,0.00,''),
	(1309,2,'0000-00-00',1,3,0.00,0.00,''),
	(1310,2,'0000-00-00',1,3,0.00,0.00,''),
	(1311,2,'0000-00-00',1,3,0.00,0.00,''),
	(1312,2,'0000-00-00',1,3,0.00,0.00,''),
	(1313,2,'0000-00-00',1,3,0.00,0.00,''),
	(1314,2,'0000-00-00',1,3,0.00,0.00,''),
	(1315,2,'0000-00-00',1,3,0.00,0.00,''),
	(1316,2,'0000-00-00',1,3,0.00,0.00,''),
	(1317,2,'0000-00-00',1,3,0.00,0.00,''),
	(1318,2,'0000-00-00',1,3,0.00,0.00,''),
	(1319,2,'0000-00-00',1,3,0.00,0.00,''),
	(1320,2,'0000-00-00',1,3,0.00,0.00,''),
	(1321,2,'0000-00-00',1,3,0.00,0.00,''),
	(1322,2,'0000-00-00',1,3,0.00,0.00,''),
	(1323,2,'0000-00-00',1,3,0.00,0.00,''),
	(1324,2,'0000-00-00',1,3,0.00,0.00,''),
	(1325,2,'0000-00-00',1,3,0.00,0.00,''),
	(1326,2,'0000-00-00',1,3,0.00,0.00,''),
	(1327,2,'0000-00-00',1,3,0.00,0.00,''),
	(1328,2,'0000-00-00',1,3,0.00,0.00,''),
	(1329,2,'0000-00-00',1,3,0.00,0.00,''),
	(1330,2,'0000-00-00',1,3,0.00,0.00,''),
	(1331,2,'0000-00-00',1,3,0.00,0.00,''),
	(1332,2,'0000-00-00',1,3,0.00,0.00,''),
	(1333,2,'0000-00-00',1,3,0.00,0.00,''),
	(1334,2,'0000-00-00',1,3,0.00,0.00,''),
	(1335,2,'0000-00-00',1,3,0.00,0.00,''),
	(1336,2,'0000-00-00',1,3,0.00,0.00,''),
	(1337,2,'0000-00-00',1,3,0.00,0.00,''),
	(1338,2,'0000-00-00',1,3,0.00,0.00,''),
	(1339,2,'0000-00-00',1,3,0.00,0.00,''),
	(1340,2,'0000-00-00',1,3,0.00,0.00,''),
	(1341,2,'0000-00-00',1,3,0.00,0.00,''),
	(1342,2,'0000-00-00',1,3,0.00,0.00,''),
	(1343,2,'0000-00-00',1,3,0.00,0.00,''),
	(1344,2,'0000-00-00',1,3,0.00,0.00,''),
	(1345,2,'0000-00-00',1,3,0.00,0.00,''),
	(1346,2,'0000-00-00',1,3,0.00,0.00,''),
	(1347,2,'0000-00-00',1,3,0.00,0.00,''),
	(1348,2,'0000-00-00',1,3,0.00,0.00,''),
	(1349,2,'0000-00-00',1,3,0.00,0.00,''),
	(1350,2,'0000-00-00',1,3,0.00,0.00,''),
	(1351,2,'0000-00-00',1,3,0.00,0.00,''),
	(1352,2,'0000-00-00',1,3,0.00,0.00,''),
	(1353,2,'0000-00-00',1,3,0.00,0.00,''),
	(1354,2,'0000-00-00',1,3,0.00,0.00,''),
	(1355,2,'0000-00-00',1,3,0.00,0.00,''),
	(1356,2,'0000-00-00',1,3,0.00,0.00,''),
	(1357,2,'0000-00-00',1,3,0.00,0.00,''),
	(1358,2,'0000-00-00',1,3,0.00,0.00,''),
	(1359,2,'0000-00-00',1,3,0.00,0.00,''),
	(1360,2,'0000-00-00',1,3,0.00,0.00,''),
	(1361,2,'0000-00-00',1,3,0.00,0.00,''),
	(1362,2,'0000-00-00',1,3,0.00,0.00,''),
	(1363,2,'0000-00-00',1,3,0.00,0.00,''),
	(1364,2,'0000-00-00',1,3,0.00,0.00,''),
	(1365,2,'0000-00-00',1,3,0.00,0.00,''),
	(1366,2,'0000-00-00',1,3,0.00,0.00,''),
	(1367,2,'0000-00-00',1,3,0.00,0.00,''),
	(1368,2,'0000-00-00',1,3,0.00,0.00,''),
	(1369,2,'0000-00-00',1,3,0.00,0.00,''),
	(1370,2,'0000-00-00',1,3,0.00,0.00,''),
	(1371,2,'0000-00-00',1,3,0.00,0.00,''),
	(1372,2,'0000-00-00',1,3,0.00,0.00,''),
	(1373,2,'0000-00-00',1,3,0.00,0.00,''),
	(1374,2,'0000-00-00',1,3,0.00,0.00,''),
	(1375,2,'0000-00-00',1,3,0.00,0.00,''),
	(1376,2,'0000-00-00',1,3,0.00,0.00,''),
	(1377,2,'0000-00-00',1,3,0.00,0.00,''),
	(1378,2,'0000-00-00',1,3,0.00,0.00,''),
	(1379,2,'0000-00-00',1,3,0.00,0.00,''),
	(1380,2,'0000-00-00',1,3,0.00,0.00,''),
	(1381,2,'0000-00-00',1,3,0.00,0.00,''),
	(1382,2,'0000-00-00',1,3,0.00,0.00,''),
	(1383,2,'0000-00-00',1,3,0.00,0.00,''),
	(1384,2,'0000-00-00',1,3,0.00,0.00,''),
	(1385,2,'0000-00-00',1,3,0.00,0.00,''),
	(1386,2,'0000-00-00',1,3,0.00,0.00,''),
	(1387,2,'0000-00-00',1,3,0.00,0.00,''),
	(1388,2,'0000-00-00',1,3,0.00,0.00,''),
	(1389,2,'0000-00-00',1,3,0.00,0.00,''),
	(1390,2,'0000-00-00',1,3,0.00,0.00,''),
	(1391,2,'0000-00-00',1,3,0.00,0.00,''),
	(1392,2,'0000-00-00',1,3,0.00,0.00,''),
	(1393,2,'0000-00-00',1,3,0.00,0.00,''),
	(1394,2,'0000-00-00',1,3,0.00,0.00,''),
	(1395,2,'0000-00-00',1,3,0.00,0.00,''),
	(1396,2,'0000-00-00',1,3,0.00,0.00,''),
	(1397,2,'0000-00-00',1,3,0.00,0.00,''),
	(1398,2,'0000-00-00',1,3,0.00,0.00,''),
	(1399,2,'0000-00-00',1,3,0.00,0.00,''),
	(1400,2,'0000-00-00',1,3,0.00,0.00,''),
	(1401,2,'0000-00-00',1,3,0.00,0.00,''),
	(1402,2,'0000-00-00',1,3,0.00,0.00,''),
	(1403,2,'0000-00-00',1,3,0.00,0.00,''),
	(1404,2,'0000-00-00',1,3,0.00,0.00,''),
	(1405,2,'0000-00-00',1,3,0.00,0.00,''),
	(1406,2,'0000-00-00',1,3,0.00,0.00,''),
	(1407,2,'0000-00-00',1,3,0.00,0.00,''),
	(1408,2,'0000-00-00',1,3,0.00,0.00,''),
	(1409,2,'0000-00-00',1,3,0.00,0.00,''),
	(1410,2,'0000-00-00',1,3,0.00,0.00,''),
	(1411,2,'0000-00-00',1,3,0.00,0.00,''),
	(1412,2,'0000-00-00',1,3,0.00,0.00,''),
	(1413,2,'0000-00-00',1,3,0.00,0.00,''),
	(1414,2,'0000-00-00',1,3,0.00,0.00,''),
	(1415,2,'0000-00-00',1,3,0.00,0.00,''),
	(1416,2,'0000-00-00',1,3,0.00,0.00,''),
	(1417,2,'0000-00-00',1,3,0.00,0.00,''),
	(1418,2,'0000-00-00',1,3,0.00,0.00,''),
	(1419,2,'0000-00-00',1,3,0.00,0.00,''),
	(1420,2,'0000-00-00',1,3,0.00,0.00,''),
	(1421,2,'0000-00-00',1,3,0.00,0.00,''),
	(1422,2,'0000-00-00',1,3,0.00,0.00,''),
	(1423,2,'0000-00-00',1,3,0.00,0.00,''),
	(1424,2,'0000-00-00',1,3,0.00,0.00,''),
	(1425,2,'0000-00-00',1,3,0.00,0.00,''),
	(1426,2,'0000-00-00',1,3,0.00,0.00,''),
	(1427,2,'0000-00-00',1,3,0.00,0.00,''),
	(1428,2,'0000-00-00',1,3,0.00,0.00,''),
	(1429,2,'0000-00-00',1,3,0.00,0.00,''),
	(1430,2,'0000-00-00',1,3,0.00,0.00,''),
	(1431,2,'0000-00-00',1,3,0.00,0.00,''),
	(1432,2,'0000-00-00',1,3,0.00,0.00,''),
	(1433,2,'0000-00-00',1,3,0.00,0.00,''),
	(1434,2,'0000-00-00',1,3,0.00,0.00,''),
	(1435,2,'0000-00-00',1,3,0.00,0.00,''),
	(1436,2,'0000-00-00',1,3,0.00,0.00,''),
	(1437,2,'0000-00-00',1,3,0.00,0.00,''),
	(1438,2,'0000-00-00',1,3,0.00,0.00,''),
	(1439,2,'0000-00-00',1,3,0.00,0.00,''),
	(1440,2,'0000-00-00',1,3,0.00,0.00,''),
	(1441,2,'0000-00-00',1,3,0.00,0.00,''),
	(1442,2,'0000-00-00',1,3,0.00,0.00,''),
	(1443,2,'0000-00-00',1,3,0.00,0.00,''),
	(1444,2,'0000-00-00',1,3,0.00,0.00,''),
	(1445,2,'0000-00-00',1,3,0.00,0.00,''),
	(1446,2,'0000-00-00',1,3,0.00,0.00,''),
	(1447,2,'0000-00-00',1,3,0.00,0.00,''),
	(1448,2,'0000-00-00',1,3,0.00,0.00,''),
	(1449,2,'0000-00-00',1,3,0.00,0.00,''),
	(1450,2,'0000-00-00',1,3,0.00,0.00,''),
	(1451,2,'0000-00-00',1,3,0.00,0.00,''),
	(1452,2,'0000-00-00',1,3,0.00,0.00,''),
	(1453,2,'0000-00-00',1,3,0.00,0.00,''),
	(1454,2,'0000-00-00',1,3,0.00,0.00,''),
	(1455,2,'0000-00-00',1,3,0.00,0.00,''),
	(1456,2,'0000-00-00',1,3,0.00,0.00,''),
	(1457,2,'0000-00-00',1,3,0.00,0.00,''),
	(1458,2,'0000-00-00',1,3,0.00,0.00,''),
	(1459,2,'0000-00-00',1,3,0.00,0.00,''),
	(1460,2,'0000-00-00',1,3,0.00,0.00,''),
	(1461,2,'0000-00-00',1,3,0.00,0.00,''),
	(1462,2,'0000-00-00',1,3,0.00,0.00,''),
	(1463,2,'0000-00-00',1,3,0.00,0.00,''),
	(1464,2,'0000-00-00',1,3,0.00,0.00,''),
	(1465,2,'0000-00-00',1,3,0.00,0.00,''),
	(1466,2,'0000-00-00',1,3,0.00,0.00,''),
	(1467,2,'0000-00-00',1,3,0.00,0.00,''),
	(1468,2,'0000-00-00',1,3,0.00,0.00,''),
	(1469,2,'0000-00-00',1,3,0.00,0.00,''),
	(1470,2,'0000-00-00',1,3,0.00,0.00,''),
	(1471,2,'0000-00-00',1,3,0.00,0.00,''),
	(1472,2,'0000-00-00',1,3,0.00,0.00,''),
	(1473,2,'0000-00-00',1,3,0.00,0.00,''),
	(1474,2,'0000-00-00',1,3,0.00,0.00,''),
	(1475,2,'0000-00-00',1,3,0.00,0.00,''),
	(1476,2,'0000-00-00',1,3,0.00,0.00,''),
	(1477,2,'0000-00-00',1,3,0.00,0.00,''),
	(1478,2,'0000-00-00',1,3,0.00,0.00,''),
	(1479,2,'0000-00-00',1,3,0.00,0.00,''),
	(1480,2,'0000-00-00',1,3,0.00,0.00,''),
	(1481,2,'0000-00-00',1,3,0.00,0.00,''),
	(1482,2,'0000-00-00',1,3,0.00,0.00,''),
	(1483,2,'0000-00-00',1,3,0.00,0.00,''),
	(1484,2,'0000-00-00',1,3,0.00,0.00,''),
	(1485,2,'0000-00-00',1,3,0.00,0.00,''),
	(1486,2,'0000-00-00',1,3,0.00,0.00,''),
	(1487,2,'0000-00-00',1,3,0.00,0.00,''),
	(1488,2,'0000-00-00',1,3,0.00,0.00,''),
	(1489,2,'0000-00-00',1,3,0.00,0.00,''),
	(1490,2,'0000-00-00',1,3,0.00,0.00,''),
	(1491,2,'0000-00-00',1,3,0.00,0.00,''),
	(1492,2,'0000-00-00',1,3,0.00,0.00,''),
	(1493,2,'0000-00-00',1,3,0.00,0.00,''),
	(1494,2,'0000-00-00',1,3,0.00,0.00,''),
	(1495,2,'0000-00-00',1,3,0.00,0.00,''),
	(1496,2,'0000-00-00',1,3,0.00,0.00,''),
	(1497,2,'0000-00-00',1,3,0.00,0.00,''),
	(1498,2,'0000-00-00',1,3,0.00,0.00,''),
	(1499,2,'0000-00-00',1,3,0.00,0.00,''),
	(1500,2,'0000-00-00',1,3,0.00,0.00,''),
	(1501,2,'0000-00-00',1,3,0.00,0.00,''),
	(1502,2,'0000-00-00',1,3,0.00,0.00,''),
	(1503,2,'0000-00-00',1,3,0.00,0.00,''),
	(1504,2,'0000-00-00',1,3,0.00,0.00,''),
	(1505,2,'0000-00-00',1,3,0.00,0.00,''),
	(1506,2,'0000-00-00',1,3,0.00,0.00,''),
	(1507,2,'0000-00-00',1,3,0.00,0.00,''),
	(1508,2,'0000-00-00',1,3,0.00,0.00,''),
	(1509,2,'0000-00-00',1,3,0.00,0.00,''),
	(1510,2,'0000-00-00',1,3,0.00,0.00,''),
	(1511,2,'0000-00-00',1,3,0.00,0.00,''),
	(1512,2,'0000-00-00',1,3,0.00,0.00,''),
	(1513,2,'0000-00-00',1,3,0.00,0.00,''),
	(1514,2,'0000-00-00',1,3,0.00,0.00,''),
	(1515,2,'0000-00-00',1,3,0.00,0.00,''),
	(1516,2,'0000-00-00',1,3,0.00,0.00,''),
	(1517,2,'0000-00-00',1,3,0.00,0.00,''),
	(1518,2,'0000-00-00',1,3,0.00,0.00,''),
	(1519,2,'0000-00-00',1,3,0.00,0.00,''),
	(1520,2,'0000-00-00',1,3,0.00,0.00,''),
	(1521,2,'0000-00-00',1,3,0.00,0.00,''),
	(1522,2,'0000-00-00',1,3,0.00,0.00,''),
	(1523,2,'0000-00-00',1,3,0.00,0.00,''),
	(1524,2,'0000-00-00',1,3,0.00,0.00,''),
	(1525,2,'0000-00-00',1,3,0.00,0.00,''),
	(1526,2,'0000-00-00',1,3,0.00,0.00,''),
	(1527,2,'0000-00-00',1,3,0.00,0.00,''),
	(1528,2,'0000-00-00',1,3,0.00,0.00,''),
	(1529,2,'0000-00-00',1,3,0.00,0.00,''),
	(1530,2,'0000-00-00',1,3,0.00,0.00,''),
	(1531,2,'0000-00-00',1,3,0.00,0.00,''),
	(1532,2,'0000-00-00',1,3,0.00,0.00,''),
	(1533,2,'0000-00-00',1,3,0.00,0.00,''),
	(1534,2,'0000-00-00',1,3,0.00,0.00,''),
	(1535,2,'0000-00-00',1,3,0.00,0.00,''),
	(1536,2,'0000-00-00',1,3,0.00,0.00,''),
	(1537,2,'0000-00-00',1,3,0.00,0.00,''),
	(1538,2,'0000-00-00',1,3,0.00,0.00,''),
	(1539,2,'0000-00-00',1,3,0.00,0.00,''),
	(1540,2,'0000-00-00',1,3,0.00,0.00,''),
	(1541,2,'0000-00-00',1,3,0.00,0.00,''),
	(1542,2,'0000-00-00',1,3,0.00,0.00,''),
	(1543,2,'0000-00-00',1,3,0.00,0.00,''),
	(1544,2,'0000-00-00',1,3,0.00,0.00,''),
	(1545,2,'0000-00-00',1,3,0.00,0.00,''),
	(1546,2,'0000-00-00',1,3,0.00,0.00,''),
	(1547,2,'0000-00-00',1,3,0.00,0.00,''),
	(1548,2,'0000-00-00',1,3,0.00,0.00,''),
	(1549,2,'0000-00-00',1,3,0.00,0.00,''),
	(1550,2,'0000-00-00',1,3,0.00,0.00,''),
	(1551,2,'0000-00-00',1,3,0.00,0.00,''),
	(1552,2,'0000-00-00',1,3,0.00,0.00,''),
	(1553,2,'0000-00-00',1,3,0.00,0.00,''),
	(1554,2,'0000-00-00',1,3,0.00,0.00,''),
	(1555,2,'0000-00-00',1,3,0.00,0.00,''),
	(1556,2,'0000-00-00',1,3,0.00,0.00,''),
	(1557,2,'0000-00-00',1,3,0.00,0.00,''),
	(1558,2,'0000-00-00',1,3,0.00,0.00,''),
	(1559,2,'0000-00-00',1,3,0.00,0.00,''),
	(1560,2,'0000-00-00',1,3,0.00,0.00,''),
	(1561,2,'0000-00-00',1,3,0.00,0.00,''),
	(1562,2,'0000-00-00',1,3,0.00,0.00,''),
	(1563,2,'0000-00-00',1,3,0.00,0.00,''),
	(1564,2,'0000-00-00',1,3,0.00,0.00,''),
	(1565,2,'0000-00-00',1,3,0.00,0.00,''),
	(1566,2,'0000-00-00',1,3,0.00,0.00,''),
	(1567,2,'0000-00-00',1,3,0.00,0.00,''),
	(1568,2,'0000-00-00',1,3,0.00,0.00,''),
	(1569,2,'0000-00-00',1,3,0.00,0.00,''),
	(1570,2,'0000-00-00',1,3,0.00,0.00,''),
	(1571,2,'0000-00-00',1,3,0.00,0.00,''),
	(1572,2,'0000-00-00',1,3,0.00,0.00,''),
	(1573,2,'0000-00-00',1,3,0.00,0.00,''),
	(1574,2,'0000-00-00',1,3,0.00,0.00,''),
	(1575,2,'0000-00-00',1,3,0.00,0.00,''),
	(1576,2,'0000-00-00',1,3,0.00,0.00,''),
	(1577,2,'0000-00-00',1,3,0.00,0.00,''),
	(1578,2,'0000-00-00',1,3,0.00,0.00,''),
	(1579,2,'0000-00-00',1,3,0.00,0.00,''),
	(1580,2,'0000-00-00',1,3,0.00,0.00,''),
	(1581,2,'0000-00-00',1,3,0.00,0.00,''),
	(1582,2,'0000-00-00',1,3,0.00,0.00,''),
	(1583,2,'0000-00-00',1,3,0.00,0.00,''),
	(1584,2,'0000-00-00',1,3,0.00,0.00,''),
	(1585,2,'0000-00-00',1,3,0.00,0.00,''),
	(1586,2,'0000-00-00',1,3,0.00,0.00,''),
	(1587,2,'0000-00-00',1,3,0.00,0.00,''),
	(1588,2,'0000-00-00',1,3,0.00,0.00,''),
	(1589,2,'0000-00-00',1,3,0.00,0.00,''),
	(1590,2,'0000-00-00',1,3,0.00,0.00,''),
	(1591,2,'0000-00-00',1,3,0.00,0.00,''),
	(1592,2,'0000-00-00',1,3,0.00,0.00,''),
	(1593,2,'0000-00-00',1,3,0.00,0.00,''),
	(1594,2,'0000-00-00',1,3,0.00,0.00,''),
	(1595,2,'0000-00-00',1,3,0.00,0.00,''),
	(1596,2,'0000-00-00',1,3,0.00,0.00,''),
	(1597,2,'0000-00-00',1,3,0.00,0.00,''),
	(1598,2,'0000-00-00',1,3,0.00,0.00,''),
	(1599,2,'0000-00-00',1,3,0.00,0.00,''),
	(1600,2,'0000-00-00',1,3,0.00,0.00,''),
	(1601,2,'0000-00-00',1,3,0.00,0.00,''),
	(1602,2,'0000-00-00',1,3,0.00,0.00,''),
	(1603,2,'0000-00-00',1,3,0.00,0.00,''),
	(1604,2,'0000-00-00',1,3,0.00,0.00,''),
	(1605,2,'0000-00-00',1,3,0.00,0.00,''),
	(1606,2,'0000-00-00',1,3,0.00,0.00,''),
	(1607,2,'0000-00-00',1,3,0.00,0.00,''),
	(1608,2,'0000-00-00',1,3,0.00,0.00,''),
	(1609,2,'0000-00-00',1,3,0.00,0.00,''),
	(1610,2,'0000-00-00',1,3,0.00,0.00,''),
	(1611,2,'0000-00-00',1,3,0.00,0.00,''),
	(1612,2,'0000-00-00',1,3,0.00,0.00,''),
	(1613,2,'0000-00-00',1,3,0.00,0.00,''),
	(1614,2,'0000-00-00',1,3,0.00,0.00,''),
	(1615,2,'0000-00-00',1,3,0.00,0.00,''),
	(1616,2,'0000-00-00',1,3,0.00,0.00,''),
	(1617,2,'0000-00-00',1,3,0.00,0.00,''),
	(1618,2,'0000-00-00',1,3,0.00,0.00,''),
	(1619,2,'0000-00-00',1,3,0.00,0.00,''),
	(1620,2,'0000-00-00',1,3,0.00,0.00,''),
	(1621,2,'0000-00-00',1,3,0.00,0.00,''),
	(1622,2,'0000-00-00',1,3,0.00,0.00,''),
	(1623,2,'0000-00-00',1,3,0.00,0.00,''),
	(1624,2,'0000-00-00',1,3,0.00,0.00,''),
	(1625,2,'0000-00-00',1,3,0.00,0.00,''),
	(1626,2,'0000-00-00',1,3,0.00,0.00,''),
	(1627,2,'0000-00-00',1,3,0.00,0.00,''),
	(1628,2,'0000-00-00',1,3,0.00,0.00,''),
	(1629,2,'0000-00-00',1,3,0.00,0.00,''),
	(1630,2,'0000-00-00',1,3,0.00,0.00,''),
	(1631,2,'0000-00-00',1,3,0.00,0.00,''),
	(1632,2,'0000-00-00',1,3,0.00,0.00,''),
	(1633,2,'0000-00-00',1,3,0.00,0.00,''),
	(1634,2,'0000-00-00',1,3,0.00,0.00,''),
	(1635,2,'0000-00-00',1,3,0.00,0.00,''),
	(1636,2,'0000-00-00',1,3,0.00,0.00,''),
	(1637,2,'0000-00-00',1,3,0.00,0.00,''),
	(1638,2,'0000-00-00',1,3,0.00,0.00,''),
	(1639,2,'0000-00-00',1,3,0.00,0.00,''),
	(1640,2,'0000-00-00',1,3,0.00,0.00,''),
	(1641,2,'0000-00-00',1,3,0.00,0.00,''),
	(1642,2,'0000-00-00',1,3,0.00,0.00,''),
	(1643,2,'0000-00-00',1,3,0.00,0.00,''),
	(1644,2,'0000-00-00',1,3,0.00,0.00,''),
	(1645,2,'0000-00-00',1,3,0.00,0.00,''),
	(1646,2,'0000-00-00',1,3,0.00,0.00,''),
	(1647,2,'0000-00-00',1,3,0.00,0.00,''),
	(1648,2,'0000-00-00',1,3,0.00,0.00,''),
	(1649,2,'0000-00-00',1,3,0.00,0.00,''),
	(1650,2,'0000-00-00',1,3,0.00,0.00,''),
	(1651,2,'0000-00-00',1,3,0.00,0.00,''),
	(1652,2,'0000-00-00',1,3,0.00,0.00,''),
	(1653,2,'0000-00-00',1,3,0.00,0.00,''),
	(1654,2,'0000-00-00',1,3,0.00,0.00,''),
	(1655,2,'0000-00-00',1,3,0.00,0.00,''),
	(1656,2,'0000-00-00',1,3,0.00,0.00,''),
	(1657,2,'0000-00-00',1,3,0.00,0.00,''),
	(1659,2,'0000-00-00',1,3,0.00,0.00,''),
	(1660,2,'0000-00-00',1,3,0.00,0.00,''),
	(1661,2,'0000-00-00',1,3,0.00,0.00,''),
	(1662,2,'0000-00-00',1,3,0.00,0.00,''),
	(1663,2,'0000-00-00',1,3,0.00,0.00,''),
	(1664,2,'0000-00-00',1,3,0.00,0.00,''),
	(1665,2,'0000-00-00',1,3,0.00,0.00,''),
	(1666,2,'0000-00-00',1,3,0.00,0.00,''),
	(1667,2,'0000-00-00',1,3,0.00,0.00,''),
	(1668,2,'0000-00-00',1,3,0.00,0.00,''),
	(1670,2,'0000-00-00',1,3,0.00,0.00,''),
	(1671,2,'0000-00-00',1,3,0.00,0.00,''),
	(1672,2,'0000-00-00',1,3,0.00,0.00,''),
	(1673,2,'0000-00-00',1,3,0.00,0.00,''),
	(1674,2,'0000-00-00',1,3,0.00,0.00,''),
	(1675,2,'0000-00-00',1,3,0.00,0.00,''),
	(1676,2,'0000-00-00',1,3,0.00,0.00,''),
	(1679,2,'0000-00-00',1,3,0.00,0.00,''),
	(1680,2,'0000-00-00',1,3,0.00,0.00,''),
	(1681,2,'0000-00-00',1,3,0.00,0.00,''),
	(1682,2,'0000-00-00',1,3,0.00,0.00,''),
	(1683,2,'0000-00-00',1,3,0.00,0.00,''),
	(1684,2,'0000-00-00',1,3,0.00,0.00,''),
	(1685,2,'0000-00-00',1,3,0.00,0.00,''),
	(1686,2,'0000-00-00',1,3,0.00,0.00,''),
	(1687,2,'0000-00-00',1,3,0.00,0.00,''),
	(1688,2,'0000-00-00',1,3,0.00,0.00,''),
	(1689,2,'0000-00-00',1,3,0.00,0.00,''),
	(1690,2,'0000-00-00',1,3,0.00,0.00,''),
	(1691,2,'0000-00-00',1,3,0.00,0.00,''),
	(1692,2,'0000-00-00',1,3,0.00,0.00,''),
	(1693,2,'0000-00-00',1,3,0.00,0.00,''),
	(1694,2,'0000-00-00',1,3,0.00,0.00,''),
	(1695,2,'0000-00-00',1,3,0.00,0.00,''),
	(1696,2,'0000-00-00',1,3,0.00,0.00,''),
	(1697,2,'0000-00-00',1,3,0.00,0.00,''),
	(1698,2,'0000-00-00',1,3,0.00,0.00,''),
	(1699,2,'0000-00-00',1,3,0.00,0.00,''),
	(1700,2,'0000-00-00',1,3,0.00,0.00,''),
	(1701,2,'0000-00-00',1,3,0.00,0.00,''),
	(1702,2,'0000-00-00',1,3,0.00,0.00,''),
	(1703,2,'0000-00-00',1,3,0.00,0.00,''),
	(1704,2,'0000-00-00',1,3,0.00,0.00,''),
	(1705,2,'0000-00-00',1,3,0.00,0.00,''),
	(1706,2,'0000-00-00',1,3,0.00,0.00,''),
	(1707,2,'0000-00-00',1,3,0.00,0.00,''),
	(1708,2,'0000-00-00',1,3,0.00,0.00,''),
	(1709,2,'0000-00-00',1,3,0.00,0.00,''),
	(1710,2,'0000-00-00',1,3,0.00,0.00,''),
	(1711,2,'0000-00-00',1,3,0.00,0.00,''),
	(1712,2,'0000-00-00',1,3,0.00,0.00,''),
	(1713,2,'0000-00-00',1,3,0.00,0.00,''),
	(1714,2,'0000-00-00',1,3,0.00,0.00,''),
	(1715,2,'0000-00-00',1,3,0.00,0.00,''),
	(1716,2,'0000-00-00',1,3,0.00,0.00,''),
	(1717,2,'0000-00-00',1,3,0.00,0.00,''),
	(1718,2,'0000-00-00',1,3,0.00,0.00,''),
	(1719,2,'0000-00-00',1,3,0.00,0.00,''),
	(1720,2,'0000-00-00',1,3,0.00,0.00,''),
	(1721,2,'0000-00-00',1,3,0.00,0.00,''),
	(1722,2,'0000-00-00',1,3,0.00,0.00,''),
	(1723,2,'0000-00-00',1,3,0.00,0.00,''),
	(1724,2,'0000-00-00',1,3,0.00,0.00,''),
	(1725,2,'0000-00-00',1,3,0.00,0.00,''),
	(1726,2,'0000-00-00',1,3,0.00,0.00,''),
	(1727,2,'0000-00-00',1,3,0.00,0.00,''),
	(1728,2,'0000-00-00',1,3,0.00,0.00,''),
	(1729,2,'0000-00-00',1,3,0.00,0.00,''),
	(1730,2,'0000-00-00',1,3,0.00,0.00,''),
	(1731,2,'0000-00-00',1,3,0.00,0.00,''),
	(1732,2,'0000-00-00',1,3,0.00,0.00,''),
	(1733,2,'0000-00-00',1,3,0.00,0.00,''),
	(1734,2,'0000-00-00',1,3,0.00,0.00,''),
	(1735,2,'0000-00-00',1,3,0.00,0.00,''),
	(1736,2,'0000-00-00',1,3,0.00,0.00,''),
	(1737,2,'0000-00-00',1,3,0.00,0.00,''),
	(1738,2,'0000-00-00',1,3,0.00,0.00,''),
	(1739,2,'0000-00-00',1,3,0.00,0.00,''),
	(1740,2,'0000-00-00',1,3,0.00,0.00,''),
	(1741,2,'0000-00-00',1,3,0.00,0.00,''),
	(1742,2,'0000-00-00',1,3,0.00,0.00,''),
	(1743,2,'0000-00-00',1,3,0.00,0.00,''),
	(1744,2,'0000-00-00',1,3,0.00,0.00,''),
	(1745,2,'0000-00-00',1,3,0.00,0.00,''),
	(1746,2,'0000-00-00',1,3,0.00,0.00,''),
	(1747,2,'0000-00-00',1,3,0.00,0.00,''),
	(1748,2,'0000-00-00',1,3,0.00,0.00,''),
	(1749,2,'0000-00-00',1,3,0.00,0.00,''),
	(1750,2,'0000-00-00',1,3,0.00,0.00,''),
	(1751,2,'0000-00-00',1,3,0.00,0.00,''),
	(1752,2,'0000-00-00',1,3,0.00,0.00,''),
	(1753,2,'0000-00-00',1,3,0.00,0.00,''),
	(1754,2,'0000-00-00',1,3,0.00,0.00,''),
	(1755,2,'0000-00-00',1,3,0.00,0.00,''),
	(1756,2,'0000-00-00',1,3,0.00,0.00,''),
	(1757,2,'0000-00-00',1,3,0.00,0.00,''),
	(1758,2,'0000-00-00',1,3,0.00,0.00,''),
	(1759,2,'0000-00-00',1,3,0.00,0.00,''),
	(1760,2,'0000-00-00',1,3,0.00,0.00,''),
	(1761,2,'0000-00-00',1,3,0.00,0.00,''),
	(1762,2,'0000-00-00',1,3,0.00,0.00,''),
	(1763,2,'0000-00-00',1,3,0.00,0.00,''),
	(1764,2,'0000-00-00',1,3,0.00,0.00,''),
	(1765,2,'0000-00-00',1,3,0.00,0.00,''),
	(1766,2,'0000-00-00',1,3,0.00,0.00,''),
	(1767,2,'0000-00-00',1,3,0.00,0.00,''),
	(1768,2,'0000-00-00',1,3,0.00,0.00,''),
	(1769,2,'0000-00-00',1,3,0.00,0.00,''),
	(1770,2,'0000-00-00',1,3,0.00,0.00,''),
	(1771,2,'0000-00-00',1,3,0.00,0.00,''),
	(1772,2,'0000-00-00',1,3,0.00,0.00,''),
	(1773,2,'0000-00-00',1,3,0.00,0.00,''),
	(1774,2,'0000-00-00',1,3,0.00,0.00,''),
	(1775,2,'0000-00-00',1,3,0.00,0.00,''),
	(1776,2,'0000-00-00',1,3,0.00,0.00,''),
	(1777,2,'0000-00-00',1,3,0.00,0.00,''),
	(1778,2,'0000-00-00',1,3,0.00,0.00,''),
	(1779,2,'0000-00-00',1,3,0.00,0.00,''),
	(1780,2,'0000-00-00',1,3,0.00,0.00,''),
	(1781,2,'0000-00-00',1,3,0.00,0.00,''),
	(1782,2,'0000-00-00',1,3,0.00,0.00,''),
	(1783,2,'0000-00-00',1,3,0.00,0.00,''),
	(1784,2,'0000-00-00',1,3,0.00,0.00,''),
	(1785,2,'0000-00-00',1,3,0.00,0.00,''),
	(1786,2,'0000-00-00',1,3,0.00,0.00,''),
	(1787,2,'0000-00-00',1,3,0.00,0.00,''),
	(1788,2,'0000-00-00',1,3,0.00,0.00,''),
	(1789,2,'0000-00-00',1,3,0.00,0.00,''),
	(1790,2,'0000-00-00',1,3,0.00,0.00,''),
	(1791,2,'0000-00-00',1,3,0.00,0.00,''),
	(1792,2,'0000-00-00',1,3,0.00,0.00,''),
	(1793,2,'0000-00-00',1,3,0.00,0.00,''),
	(1794,2,'0000-00-00',1,3,0.00,0.00,''),
	(1795,2,'0000-00-00',1,3,0.00,0.00,''),
	(1796,2,'0000-00-00',1,3,0.00,0.00,''),
	(1797,2,'0000-00-00',1,3,0.00,0.00,''),
	(1798,2,'0000-00-00',1,3,0.00,0.00,''),
	(1799,2,'0000-00-00',1,3,0.00,0.00,''),
	(1800,2,'0000-00-00',1,3,0.00,0.00,''),
	(1801,2,'0000-00-00',1,3,0.00,0.00,''),
	(1802,2,'0000-00-00',1,3,0.00,0.00,''),
	(1803,2,'0000-00-00',1,3,0.00,0.00,''),
	(1804,2,'0000-00-00',1,3,0.00,0.00,''),
	(1805,2,'0000-00-00',1,3,0.00,0.00,''),
	(1806,2,'0000-00-00',1,3,0.00,0.00,''),
	(1807,2,'0000-00-00',1,3,0.00,0.00,''),
	(1808,2,'0000-00-00',1,3,0.00,0.00,''),
	(1809,2,'0000-00-00',1,3,0.00,0.00,''),
	(1810,2,'0000-00-00',1,3,0.00,0.00,''),
	(1811,2,'0000-00-00',1,3,0.00,0.00,''),
	(1812,2,'0000-00-00',1,3,0.00,0.00,''),
	(1813,2,'0000-00-00',1,3,0.00,0.00,''),
	(1814,2,'0000-00-00',1,3,0.00,0.00,''),
	(1815,2,'0000-00-00',1,3,0.00,0.00,''),
	(1816,2,'0000-00-00',1,3,0.00,0.00,''),
	(1817,2,'0000-00-00',1,3,0.00,0.00,''),
	(1818,2,'0000-00-00',1,3,0.00,0.00,''),
	(1819,2,'0000-00-00',1,3,0.00,0.00,''),
	(1820,2,'0000-00-00',1,3,0.00,0.00,''),
	(1821,2,'0000-00-00',1,3,0.00,0.00,''),
	(1822,2,'0000-00-00',1,3,0.00,0.00,''),
	(1823,2,'0000-00-00',1,3,0.00,0.00,''),
	(1824,2,'0000-00-00',1,3,0.00,0.00,''),
	(1825,2,'0000-00-00',1,3,0.00,0.00,''),
	(1826,2,'0000-00-00',1,3,0.00,0.00,''),
	(1827,2,'0000-00-00',1,3,0.00,0.00,''),
	(1828,2,'0000-00-00',1,3,0.00,0.00,''),
	(1829,2,'0000-00-00',1,3,0.00,0.00,''),
	(1830,2,'0000-00-00',1,3,0.00,0.00,''),
	(1831,2,'0000-00-00',1,3,0.00,0.00,''),
	(1832,2,'0000-00-00',1,3,0.00,0.00,''),
	(1833,2,'0000-00-00',1,3,0.00,0.00,''),
	(1834,2,'0000-00-00',1,3,0.00,0.00,''),
	(1835,2,'0000-00-00',1,3,0.00,0.00,''),
	(1836,2,'0000-00-00',1,3,0.00,0.00,''),
	(1837,2,'0000-00-00',1,3,0.00,0.00,''),
	(1838,2,'0000-00-00',1,3,0.00,0.00,''),
	(1839,2,'0000-00-00',1,3,0.00,0.00,''),
	(1840,2,'0000-00-00',1,3,0.00,0.00,''),
	(1841,2,'0000-00-00',1,3,0.00,0.00,''),
	(1842,2,'0000-00-00',1,3,0.00,0.00,''),
	(1843,2,'0000-00-00',1,3,0.00,0.00,''),
	(1844,2,'0000-00-00',1,3,0.00,0.00,''),
	(1845,2,'0000-00-00',1,3,0.00,0.00,''),
	(1846,2,'0000-00-00',1,3,0.00,0.00,''),
	(1847,2,'0000-00-00',1,3,0.00,0.00,''),
	(1848,2,'0000-00-00',1,3,0.00,0.00,''),
	(1849,2,'0000-00-00',1,3,0.00,0.00,''),
	(1850,2,'0000-00-00',1,3,0.00,0.00,''),
	(1851,2,'0000-00-00',1,3,0.00,0.00,''),
	(1852,2,'0000-00-00',1,3,0.00,0.00,''),
	(1853,2,'0000-00-00',1,3,0.00,0.00,''),
	(1854,2,'0000-00-00',1,3,0.00,0.00,''),
	(1855,2,'0000-00-00',1,3,0.00,0.00,''),
	(1856,2,'0000-00-00',1,3,0.00,0.00,''),
	(1857,2,'0000-00-00',1,3,0.00,0.00,''),
	(1858,2,'0000-00-00',1,3,0.00,0.00,''),
	(1859,2,'0000-00-00',1,3,0.00,0.00,''),
	(1860,2,'0000-00-00',1,3,0.00,0.00,''),
	(1861,2,'0000-00-00',1,3,0.00,0.00,''),
	(1862,2,'0000-00-00',1,3,0.00,0.00,''),
	(1863,2,'0000-00-00',1,3,0.00,0.00,''),
	(1864,2,'0000-00-00',1,3,0.00,0.00,''),
	(1865,2,'0000-00-00',1,3,0.00,0.00,''),
	(1866,2,'0000-00-00',1,3,0.00,0.00,''),
	(1867,2,'0000-00-00',1,3,0.00,0.00,''),
	(1868,2,'0000-00-00',1,3,0.00,0.00,''),
	(1869,2,'0000-00-00',1,3,0.00,0.00,''),
	(1870,2,'0000-00-00',1,3,0.00,0.00,''),
	(1871,2,'0000-00-00',1,3,0.00,0.00,''),
	(1872,2,'0000-00-00',1,3,0.00,0.00,''),
	(1873,2,'0000-00-00',1,3,0.00,0.00,''),
	(1874,2,'0000-00-00',1,3,0.00,0.00,''),
	(1875,2,'0000-00-00',1,3,0.00,0.00,''),
	(1876,2,'0000-00-00',1,3,0.00,0.00,''),
	(1877,2,'0000-00-00',1,3,0.00,0.00,''),
	(1878,2,'0000-00-00',1,3,0.00,0.00,''),
	(1879,2,'0000-00-00',1,3,0.00,0.00,''),
	(1880,2,'0000-00-00',1,3,0.00,0.00,''),
	(1881,2,'0000-00-00',1,3,0.00,0.00,''),
	(1882,2,'0000-00-00',1,3,0.00,0.00,''),
	(1883,2,'0000-00-00',1,3,0.00,0.00,''),
	(1884,2,'0000-00-00',1,3,0.00,0.00,''),
	(1885,2,'0000-00-00',1,3,0.00,0.00,''),
	(1886,2,'0000-00-00',1,3,0.00,0.00,''),
	(1887,2,'0000-00-00',1,3,0.00,0.00,''),
	(1888,2,'0000-00-00',1,3,0.00,0.00,''),
	(1889,2,'0000-00-00',1,3,0.00,0.00,''),
	(1890,2,'0000-00-00',1,3,0.00,0.00,''),
	(1891,2,'0000-00-00',1,3,0.00,0.00,''),
	(1892,2,'0000-00-00',1,3,0.00,0.00,''),
	(1893,2,'0000-00-00',1,3,0.00,0.00,''),
	(1894,2,'0000-00-00',1,3,0.00,0.00,''),
	(1895,2,'0000-00-00',1,3,0.00,0.00,''),
	(1896,2,'0000-00-00',1,3,0.00,0.00,''),
	(1897,2,'0000-00-00',1,3,0.00,0.00,''),
	(1898,2,'0000-00-00',1,3,0.00,0.00,''),
	(1899,2,'0000-00-00',1,3,0.00,0.00,''),
	(1900,2,'0000-00-00',1,3,0.00,0.00,''),
	(1901,2,'0000-00-00',1,3,0.00,0.00,''),
	(1902,2,'0000-00-00',1,3,0.00,0.00,''),
	(1903,2,'0000-00-00',1,3,0.00,0.00,''),
	(1904,2,'0000-00-00',1,3,0.00,0.00,''),
	(1905,2,'0000-00-00',1,3,0.00,0.00,''),
	(1906,2,'0000-00-00',1,3,0.00,0.00,''),
	(1907,2,'0000-00-00',1,3,0.00,0.00,''),
	(1908,2,'0000-00-00',1,3,0.00,0.00,''),
	(1909,2,'0000-00-00',1,3,0.00,0.00,''),
	(1910,2,'0000-00-00',1,3,0.00,0.00,''),
	(1911,2,'0000-00-00',1,3,0.00,0.00,''),
	(1912,2,'0000-00-00',1,3,0.00,0.00,''),
	(1913,2,'0000-00-00',1,3,0.00,0.00,''),
	(1914,2,'0000-00-00',1,3,0.00,0.00,''),
	(1915,2,'0000-00-00',1,3,0.00,0.00,''),
	(1916,2,'0000-00-00',1,3,0.00,0.00,''),
	(1917,2,'0000-00-00',1,3,0.00,0.00,''),
	(1918,2,'0000-00-00',1,3,0.00,0.00,''),
	(1919,2,'0000-00-00',1,3,0.00,0.00,''),
	(1920,2,'0000-00-00',1,3,0.00,0.00,''),
	(1921,2,'0000-00-00',1,3,0.00,0.00,''),
	(1922,2,'0000-00-00',1,3,0.00,0.00,''),
	(1923,2,'0000-00-00',1,3,0.00,0.00,''),
	(1924,2,'0000-00-00',1,3,0.00,0.00,''),
	(1925,2,'0000-00-00',1,3,0.00,0.00,''),
	(1926,2,'0000-00-00',1,3,0.00,0.00,''),
	(1927,2,'0000-00-00',1,3,0.00,0.00,''),
	(1928,2,'0000-00-00',1,3,0.00,0.00,''),
	(1929,2,'0000-00-00',1,3,0.00,0.00,''),
	(1930,2,'0000-00-00',1,3,0.00,0.00,''),
	(1931,2,'0000-00-00',1,3,0.00,0.00,''),
	(1932,2,'0000-00-00',1,3,0.00,0.00,''),
	(1933,2,'0000-00-00',1,3,0.00,0.00,''),
	(1934,2,'0000-00-00',1,3,0.00,0.00,''),
	(1935,2,'0000-00-00',1,3,0.00,0.00,''),
	(1936,2,'0000-00-00',1,3,0.00,0.00,''),
	(1937,2,'0000-00-00',1,3,0.00,0.00,''),
	(1938,2,'0000-00-00',1,3,0.00,0.00,''),
	(1939,2,'0000-00-00',1,3,0.00,0.00,''),
	(1940,2,'0000-00-00',1,3,0.00,0.00,''),
	(1941,2,'0000-00-00',1,3,0.00,0.00,''),
	(1942,2,'0000-00-00',1,3,0.00,0.00,''),
	(1943,2,'0000-00-00',1,3,0.00,0.00,''),
	(1944,2,'0000-00-00',1,3,0.00,0.00,''),
	(1945,2,'0000-00-00',1,3,0.00,0.00,''),
	(1946,2,'0000-00-00',1,3,0.00,0.00,''),
	(1947,2,'0000-00-00',1,3,0.00,0.00,''),
	(1948,2,'0000-00-00',1,3,0.00,0.00,''),
	(1949,2,'0000-00-00',1,3,0.00,0.00,''),
	(1950,2,'0000-00-00',1,3,0.00,0.00,''),
	(1951,2,'0000-00-00',1,3,0.00,0.00,''),
	(1952,2,'0000-00-00',1,3,0.00,0.00,''),
	(1953,2,'0000-00-00',1,3,0.00,0.00,''),
	(1954,2,'0000-00-00',1,3,0.00,0.00,''),
	(1955,2,'0000-00-00',1,3,0.00,0.00,''),
	(1956,2,'0000-00-00',1,3,0.00,0.00,''),
	(1957,2,'0000-00-00',1,3,0.00,0.00,''),
	(1958,2,'0000-00-00',1,3,0.00,0.00,''),
	(1959,2,'0000-00-00',1,3,0.00,0.00,''),
	(1960,2,'0000-00-00',1,3,0.00,0.00,''),
	(1961,2,'0000-00-00',1,3,0.00,0.00,''),
	(1962,2,'0000-00-00',1,3,0.00,0.00,''),
	(1963,2,'0000-00-00',1,3,0.00,0.00,''),
	(1964,2,'0000-00-00',1,3,0.00,0.00,''),
	(1965,2,'0000-00-00',1,3,0.00,0.00,''),
	(1966,2,'0000-00-00',1,3,0.00,0.00,''),
	(1967,2,'0000-00-00',1,3,0.00,0.00,''),
	(1968,2,'0000-00-00',1,3,0.00,0.00,''),
	(1969,2,'0000-00-00',1,3,0.00,0.00,''),
	(1970,2,'0000-00-00',1,3,0.00,0.00,''),
	(1971,2,'0000-00-00',1,3,0.00,0.00,''),
	(1972,2,'0000-00-00',1,3,0.00,0.00,''),
	(1973,2,'0000-00-00',1,3,0.00,0.00,''),
	(1974,2,'0000-00-00',1,3,0.00,0.00,''),
	(1975,2,'0000-00-00',1,3,0.00,0.00,''),
	(1976,2,'0000-00-00',1,3,0.00,0.00,''),
	(1977,2,'0000-00-00',1,3,0.00,0.00,''),
	(1978,2,'0000-00-00',1,3,0.00,0.00,''),
	(1979,2,'0000-00-00',1,3,0.00,0.00,''),
	(1980,2,'0000-00-00',1,3,0.00,0.00,''),
	(1981,2,'0000-00-00',1,3,0.00,0.00,''),
	(1982,2,'0000-00-00',1,3,0.00,0.00,''),
	(1983,2,'0000-00-00',1,3,0.00,0.00,''),
	(1984,2,'0000-00-00',1,3,0.00,0.00,''),
	(1985,2,'0000-00-00',1,3,0.00,0.00,''),
	(1986,2,'0000-00-00',1,3,0.00,0.00,''),
	(1987,2,'0000-00-00',1,3,0.00,0.00,''),
	(1988,2,'0000-00-00',1,3,0.00,0.00,''),
	(1989,2,'0000-00-00',1,3,0.00,0.00,''),
	(1990,2,'0000-00-00',1,3,0.00,0.00,''),
	(1991,2,'0000-00-00',1,3,0.00,0.00,''),
	(1992,2,'0000-00-00',1,3,0.00,0.00,''),
	(1993,2,'0000-00-00',1,3,0.00,0.00,''),
	(1994,2,'0000-00-00',1,3,0.00,0.00,''),
	(1995,2,'0000-00-00',1,3,0.00,0.00,''),
	(1996,2,'0000-00-00',1,3,0.00,0.00,''),
	(1997,2,'0000-00-00',1,3,0.00,0.00,''),
	(1998,2,'0000-00-00',1,3,0.00,0.00,''),
	(1999,2,'0000-00-00',1,3,0.00,0.00,''),
	(2000,2,'0000-00-00',1,3,0.00,0.00,''),
	(2001,2,'0000-00-00',1,3,0.00,0.00,'');

/*!40000 ALTER TABLE `dtbl_banner_stat` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table dtbl_catalog_items_images
# ------------------------------------------------------------

DROP TABLE IF EXISTS `dtbl_catalog_items_images`;

CREATE TABLE `dtbl_catalog_items_images` (
  `ID` bigint(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `pict` varchar(255) NOT NULL,
  `rating` smallint(4) unsigned NOT NULL DEFAULT '0',
  `operator` varchar(64) NOT NULL,
  `id_item` int(6) unsigned NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `id_item` (`id_item`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

LOCK TABLES `dtbl_catalog_items_images` WRITE;
/*!40000 ALTER TABLE `dtbl_catalog_items_images` DISABLE KEYS */;

INSERT INTO `dtbl_catalog_items_images` (`ID`, `name`, `pict`, `rating`, `operator`, `id_item`, `updated_at`, `created_at`)
VALUES
	(14,'Фото 1','',1,'webadmin',1,'2011-11-25 19:46:48','2011-11-22 17:40:06'),
	(7,'Счастливые числа','',1,'',1,'0000-00-00 00:00:00','2011-11-22 16:47:12');

/*!40000 ALTER TABLE `dtbl_catalog_items_images` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table dtbl_search_results
# ------------------------------------------------------------

DROP TABLE IF EXISTS `dtbl_search_results`;

CREATE TABLE `dtbl_search_results` (
  `idx` bigint(11) unsigned NOT NULL DEFAULT '0',
  `qsearch` varchar(255) NOT NULL DEFAULT '',
  `table` varchar(50) NOT NULL DEFAULT '',
  `controller` varchar(50) NOT NULL DEFAULT '',
  `tdate` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `primary_key` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`idx`,`qsearch`)
) ENGINE=MyISAM DEFAULT CHARSET=cp1251 COMMENT='Результаты поиска';



# Dump of table dtbl_subscribe_stat
# ------------------------------------------------------------

DROP TABLE IF EXISTS `dtbl_subscribe_stat`;

CREATE TABLE `dtbl_subscribe_stat` (
  `ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `id_data_subscribe` int(11) NOT NULL DEFAULT '0',
  `id_user` int(11) NOT NULL DEFAULT '0',
  `send_date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`ID`),
  UNIQUE KEY `id_data_subscribe` (`id_data_subscribe`,`id_user`)
) ENGINE=MyISAM DEFAULT CHARSET=cp1251;

LOCK TABLES `dtbl_subscribe_stat` WRITE;
/*!40000 ALTER TABLE `dtbl_subscribe_stat` DISABLE KEYS */;

INSERT INTO `dtbl_subscribe_stat` (`ID`, `id_data_subscribe`, `id_user`, `send_date`)
VALUES
	(1,26,1,'0000-00-00 00:00:00');

/*!40000 ALTER TABLE `dtbl_subscribe_stat` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table dtbl_subscribe_users
# ------------------------------------------------------------

DROP TABLE IF EXISTS `dtbl_subscribe_users`;

CREATE TABLE `dtbl_subscribe_users` (
  `ID` bigint(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `cck` varchar(150) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `dtbl_subscribe_users` WRITE;
/*!40000 ALTER TABLE `dtbl_subscribe_users` DISABLE KEYS */;

INSERT INTO `dtbl_subscribe_users` (`ID`, `name`, `cck`, `created_at`)
VALUES
	(1,'vdovin.a.a@gmail.com','','2012-05-21 17:57:25'),
	(2,'ifrogseo@gmail.com','','2012-12-27 16:19:37');

/*!40000 ALTER TABLE `dtbl_subscribe_users` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table images_gallery
# ------------------------------------------------------------

DROP TABLE IF EXISTS `images_gallery`;

CREATE TABLE `images_gallery` (
  `ID` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL DEFAULT '',
  `title_ru` varchar(255) NOT NULL DEFAULT '',
  `title_en` varchar(255) NOT NULL,
  `alias` varchar(255) NOT NULL,
  `keywords` varchar(255) NOT NULL DEFAULT '',
  `pict` varchar(64) NOT NULL DEFAULT '',
  `folder` varchar(64) NOT NULL DEFAULT '',
  `type_file` varchar(8) NOT NULL DEFAULT '',
  `image_gallery` smallint(5) unsigned NOT NULL DEFAULT '0',
  `tdate` date NOT NULL DEFAULT '0000-00-00',
  `rating` smallint(5) unsigned NOT NULL DEFAULT '0',
  `dir` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `viewimg` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `operator` varchar(50) NOT NULL DEFAULT '',
  `description` text NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `image_gallery` (`image_gallery`),
  KEY `alias` (`alias`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 PACK_KEYS=0 COMMENT='Изображения для фотогалерей';



# Dump of table keys_access
# ------------------------------------------------------------

DROP TABLE IF EXISTS `keys_access`;

CREATE TABLE `keys_access` (
  `ID` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL DEFAULT '',
  `tbl` varchar(64) NOT NULL DEFAULT '',
  `lkey` varchar(64) NOT NULL DEFAULT '',
  `object` varchar(8) NOT NULL DEFAULT '',
  `settings` text NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `tbl` (`tbl`,`lkey`,`object`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Ключи к модулю Access';

LOCK TABLES `keys_access` WRITE;
/*!40000 ALTER TABLE `keys_access` DISABLE KEYS */;

INSERT INTO `keys_access` (`ID`, `name`, `tbl`, `lkey`, `object`, `settings`, `updated_at`)
VALUES
	(1,'Модуль','','modul','lkey','type=tlist\r\nlist=sys_program\r\nrating=1\r\ngroup=2\r\ntable_list=1\r\nfilter=1\r\nqview=1\r\nhelp=Программный модуль, для которого действует данное право\r\n','2010-10-31 19:34:50'),
	(3,'Объект','','objecttype','lkey','type=list\r\nlist=|не определен~modul|Модуль~table|Таблица~lkey|Ключ~button|Кнопка~menu|Пункт главного меню\r\nnotnull=1\r\nlist_type=radio\r\ngroup=1\r\nrating=9\r\nfilter=1\r\nrequired=1\r\ntable_list=2\r\nqview=1\r\nqedit=1\r\nhelp=Тип объекта, для которого действительно данное правило\r\n','2010-10-31 19:34:46'),
	(4,'Группа пользователей','','id_group_user','lkey','type=tlist\nlist=lst_group_user\ntable_list=3\nrating=5\ngroup=3\nqview=1\nfilter=1\nhelp=Группа пользователей, для которых действительно данное правило','2010-10-31 19:38:38'),
	(5,'Управление доступом. Фильтр','','filter','button','type_link=modullink\ntable_list=1\nprogram=/cgi-bin/access_a.cgi\nimageiconmenu=/admin/img/icons/menu/icon_filter.png\naction=filter\ntitle=Настроить фильтр\nwidth=690\nheight=510\nlevel=3\nrating=2\nparams=replaceme','0000-00-00 00:00:00'),
	(6,'Управление доступом. Очистка фильтра','','filter_clear','button','type_link=loadcontent\ntable_list=1\nprogram=/cgi-bin/access_a.cgi\naction=filter_clear\nimageiconmenu=/admin/img/icons/menu/icon_nofilter.png\ntitle=Снять фильтры\nrating=3\nparams=replaceme','0000-00-00 00:00:00'),
	(7,'Названия объектов','','objectname','lkey','type=list\r\nlist=objectname\r\ngroup=3\r\nrating=2\r\nmult=7\r\nnocheck=1\r\ntemplate_w=field_multselect\r\nnotnull=1\r\nhelp=Перечень объектов, на которые распространяется данное правило. Выделите объекты и переведите их в правое окошко.','2010-10-31 19:38:38'),
	(9,'Пользователь','','users','lkey','type=tlist\nlist=sys_users\ngroup=3\ntable_list=4\nrating=10\nqview=1\nfilter=1\nhelp=Пользователь, для которого действительно правило.','2010-10-31 19:38:38'),
	(10,'Права на чтение','','r','lkey','type=chb\nyes=да\nno=нет\ngroup=3\nrating=11\nqview=1\nhelp=Пользователь может видеть выбранные объекты','2010-10-31 19:38:38'),
	(11,'Права на запись','','w','lkey','type=chb\nyes=да\nno=нет\ngroup=3\nrating=12\nqview=1\nhelp=У пользователя есть право редактировать выбранные объекты','2010-10-31 19:38:38'),
	(12,'Права на удаление','','d','lkey','type=chb\nyes=да\nno=нет\ngroup=3\nrating=13\nqview=1\nhelp=Пользователь может удалить выбранные объекты','2010-10-31 19:38:38'),
	(13,'Название','','name','lkey','type=s','2008-04-11 01:17:14'),
	(14,'Таблица объектов','','config_table','lkey','type=s','2008-04-19 10:54:59'),
	(15,'Закончить редактирование','','end_link','button','type_link=loadcontent\nedit_info=1\nprogram=/cgi-bin/access_a.cgi\naction=info\nimageiconmenu=/admin/img/icons/menu/icon_ok.png\ntitle=Закончить редактирование\nrating=1\nparams=replaceme,index\n','0000-00-00 00:00:00'),
	(16,'Список правил','','list_link','button','type_link=loadcontent\nadd_info=1\nprogram=/cgi-bin/access_a.cgi\nimageiconmenu=/admin/img/icons/menu/button.list.png\naction=enter\ntitle=Список правил\nrating=1\nparams=replaceme','0000-00-00 00:00:00'),
	(17,'Редактировать запись','','edit_link','button','type_link=loadcontent\r\nprint_info=1\r\nprogram=/cgi-bin/access_a.cgi\r\ncontroller=access\r\naction=edit\r\nimageiconmenu=/admin/img/icons/menu/icon_edit.png\r\ntitle=Редактировать запись\r\nrating=2\r\nparams=replaceme,index','0000-00-00 00:00:00'),
	(18,'Удалить запись','','del_link','button','type_link=loadcontent\nprogram=/cgi-bin/access_a.cgi\naction=delete\nimageiconmenu=/admin/img/icons/menu/icon_delete.png\nconfirm=Действительно удалить запись?\ntitle=Удалить запись\nprint_info=1\nrating=1\nparams=replaceme,index','0000-00-00 00:00:00'),
	(19,'Добавить запись','','add_link','button','type_link=openpage\nposition=center\nid=newentry\r\ntable_list=1\r\nprint_info=1\r\nprogram=/cgi-bin/access_a.cgi\r\nimageiconmenu=/admin/img/icons/menu/icon_add.png\r\ncontroller=access\r\naction=add\r\ntitle=Добавить запись\r\nrating=1\r\nparams=replaceme','0000-00-00 00:00:00'),
	(24,'Добавить правило доступа','','access_add','menu','type_link=loadcontent\r\naction=add\r\nprogram=/cgi-bin/access_a.cgi\r\nrating=116\r\nparentid=access\r\nreplaceme=replaceme','0000-00-00 00:00:00'),
	(30,'Права доступа','','access','menu','type_link=loadcontent\r\naction=enter\r\nprogram=/cgi-bin/access_a.cgi\r\nrating=16\r\nparentid=setting\r\nreplaceme=replaceme\r\nsubmenuwidth=200\r\n','0000-00-00 00:00:00'),
	(31,'Данные','','data','lkey','type=code\r\nsys=1\r\n','0000-00-00 00:00:00'),
	(32,'Обновить права','','update_access','button','type_link=loadcontent\ntable_list=1\nprint_info=1\nimageiconmenu=/admin/img/icons/menu/icon_change.png\ncontroller=access\naction=update_access\ntitle=Обновить права\nrating=4\nparams=replaceme',NULL);

/*!40000 ALTER TABLE `keys_access` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table keys_banners
# ------------------------------------------------------------

DROP TABLE IF EXISTS `keys_banners`;

CREATE TABLE `keys_banners` (
  `ID` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL DEFAULT '',
  `tbl` varchar(64) NOT NULL DEFAULT '',
  `lkey` varchar(64) NOT NULL DEFAULT '',
  `object` varchar(8) NOT NULL DEFAULT '',
  `settings` text NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `tbl` (`tbl`,`lkey`,`object`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Ключи к модулю Баннерокрутилка';

LOCK TABLES `keys_banners` WRITE;
/*!40000 ALTER TABLE `keys_banners` DISABLE KEYS */;

INSERT INTO `keys_banners` (`ID`, `name`, `tbl`, `lkey`, `object`, `settings`, `updated_at`)
VALUES
	(1,'Добавить запись','','add_link','button','type_link=openpage\nposition=center\nid=newentry\r\ntable_list=1\r\ncontroller=banners\r\nimageiconmenu=/admin/img/icons/menu/icon_add.png\r\naction=add\r\ntitle=Добавить\r\nrating=1\r\nparams=replaceme','0000-00-00 00:00:00'),
	(3,'Удалить запись','','del_link','button','type_link=loadcontent\r\ncontroller=banners\r\naction=delete\r\nconfirm=Действительно удалить запись?\r\nimageiconmenu=/admin/img/icons/menu/icon_delete.png\r\ntitle=Удалить запись\r\nprint_info=1\r\nrating=1\r\nparams=replaceme,index','0000-00-00 00:00:00'),
	(4,'Редактировать запись','','edit_link','button','type_link=loadcontent\r\nprint_info=1\r\ncontroller=banners\r\nimageiconmenu=/admin/img/icons/menu/icon_edit.png\r\naction=edit\r\ntitle=Редактировать запись\r\nrating=2\r\nparams=replaceme,index','0000-00-00 00:00:00'),
	(5,'Закончить редактирование','','end_link','button','type_link=loadcontent\r\nedit_info=1\r\ncontroller=banners\r\nimageiconmenu=/admin/img/icons/menu/icon_ok.png\r\naction=info\r\ntitle=Закончить редактирование\r\nrating=10\r\nparams=replaceme,index','0000-00-00 00:00:00'),
	(6,'Фильтр','','filter','button','type_link=modullink\r\ntable_list=1\r\ntable_list_view=1\r\ncontroller=banners\r\nimageiconmenu=/admin/img/icons/menu/icon_filter.png\r\naction=filter\r\ntitle=Фильтр\r\nwidth=690\r\nheight=510\r\nlevel=3\r\nrating=2\r\nparams=replaceme','0000-00-00 00:00:00'),
	(7,'Очистка фильтра','','filter_clear','button','type_link=loadcontent\r\ntable_list=1\r\ntable_list_view=1\r\ncontroller=banners\r\nimageiconmenu=/admin/img/icons/menu/icon_nofilter.png\r\naction=filter_clear\r\ntitle=Снять фильтры\r\nrating=3\r\nparams=replaceme','0000-00-00 00:00:00'),
	(10,'Название баннера','','name','lkey','type=s\nfilter=1\ntable_list=1\nrequired=1\nqview=1\nqedit=1\ngroup=1\nrating=1\nno_format=1\nhelp=Название баннера предназначено для облегчения его дальнейшей идентификации в системе. Чем четче будет название, тем легче будет найти баннер среди прочих','2010-09-13 15:28:12'),
	(11,'Публиковать рекламу','','view','lkey','type=chb\nrating=110\ngroup=1\nfilter=1\ntable_list=11\ntable_list_name=-\ntable_list_width=48\nyes=Виден\nno=Скрыт\nqview=1\nhelp=Для того, чтобы баннер показывался, необходимо установить данный влажок.','2010-09-13 15:28:12'),
	(12,'Ширина','','width','lkey','type=d\r\ngroup=2\r\nqview=1\r\nfilter=1\r\nrequired=1\r\ntable_list=4\r\ntable_list_name=W\r\ntable_list_width=32\r\nrating=15\r\nhelp=Ширина баннера. По умолчанию задается из размеров выбраного баннерого места\r\n','2010-09-13 15:28:29'),
	(58,'Цена за клик','','per_click','lkey','type=d\r\nprint=1\r\nqview=1\r\nqedit=1\r\nrating=10\r\nfileview=1\r\ntable_list=4\r\ntable_list_width=100\r\n','0000-00-00 00:00:00'),
	(13,'Высота','','height','lkey','type=d\r\ngroup=2\r\nrating=16\r\nrequired=1\r\ntable_list=5\r\ntable_list_name=H\r\ntable_list_width=32\r\nqview=1\r\nfilter=1\r\nhelp=Высота баннера. По умолчанию задается из размеров выбраного баннерого места\r\n','2010-09-13 15:28:29'),
	(14,'Код рекламного блока','','code','lkey','type=code\ngroup=2\nrating=10\nhelp=Если у вас готовый код, то воспользуйтесь данным полем. Все остальные поля заполнять в этом случае не надо.','2010-09-13 15:28:29'),
	(15,'Бюджет','','cash','lkey','type=float\r\ntable_list=6\r\ntable_list_width=72\r\ngroup=1\r\nqedit=1\r\nfilter=1\r\nrating=98\r\nhelp=Доступное количество денег для открутки показов. Снимается сумма, которая прописана в настройках рекламного места и, в зависимости от типа показов, (за клики, за показы). Если выбран тип показа \"без ограничения\", то данное поле можно не заполнять','2010-09-13 15:28:12'),
	(16,'Дата конца показов','','showdateend','lkey','type=date\ngroup=3\nrating=8\nfilter=1\nhelp=Установите дату окончания показов, если показ баннера привязан к конкретному сроку (для коммерческих показов)','2010-09-13 15:28:44'),
	(17,'Дата начала показов','','showdatefirst','lkey','type=date\ngroup=3\nrating=7\nfilter=1\nhelp=Установите дату начала показов, если показ баннера привязан к конкретному сроку (для коммерческих показов)','2010-09-13 15:28:44'),
	(18,'URL-ссылка','','link','lkey','type=site\r\ngroup=1\r\nrating=2\r\nqview=1\r\nhelp=Адрес ссылки, куда ведет баннер.\r\ntable_list=5\r\ntable_list_width=200\r\n','2010-09-13 15:28:12'),
	(20,'Тип показа баннера','','type_show','lkey','type=list\r\nlist=0|без ограничения~1|по показам~2|по переходам\r\nlist_type=radio\r\ngroup=1\r\nrating=99\r\nfilter=1\r\nqview=1\r\nhelp=Опция для коммерческого показа баннеров. В зависимости от выбранного типа расходуется (или не расходуется) рекламный бюджет','2010-09-13 15:28:12'),
	(21,'Рекламодатель','','id_advert_users','lkey','type=tlist\r\nlist=data_banner_advert_users\r\nadd_to_list=1\r\nwin_scroll=0\r\nwin_height=100\r\nrating=100\r\ngroup=1\r\nfilter=1\r\nwidth=650\r\nheight=300\r\nhelp=Если баннерокрутилка используется для коммерческого показа баннеров, то указав рекламодателя, можно сделать ему доступ к статистике показов и переходов данного баннера.','2010-09-13 15:28:12'),
	(22,'Текст ссылки','','textlink','lkey','type=text\ngroup=2\nrating=3\nhelp=Если требуется показывать рекламную ссылку, а не графический баннер, то воспользуйтесь этим полем','2010-09-13 15:28:29'),
	(23,'Размер файла','','size','lkey','type=d\nshablon_w=field_input_read\nrating=20\ngroup=2\n','2009-04-19 00:18:01'),
	(24,'Тип файла','','type_file','lkey','type=slat\ngroup=2\nrating=21\ntable_list=2\ntable_list_name=-\ntable_list_nosort=1\ntable_list_width=16\nshablon_w=field_input_read\n','2009-04-19 00:18:01'),
	(25,'Заголовок ссылки','','titlelink','lkey','type=s\ngroup=2\nrating=2\nhelp=Текстовый баннер может состоять из заголовка и текста. Это поле предназначено для определения заголовка текстового рекламного блока','2010-09-13 15:28:29'),
	(26,'Картинка','','docfile','lkey','type=pict\r\nrating=1\r\ngroup=2\r\ntable_list=3\r\ntable_list_name=-\r\ntable_list_type=pict\r\ntable_list_nosort=1\r\ntemplate_w=field_file\r\ntemplate_r=field_pict_read\r\nfolder=/image/bb/\r\nsizelimit=20000\r\nfile_ext=*.jpg;*.jpeg;*.gif;*.swf;*.png\r\nhelp=Баннер может быть загружен на сервер.','2010-09-13 15:24:47'),
	(27,'Постраничный таргетинг','','target','lkey','type=list\r\nlist=0|на всех страницах~1|только на страницах~2|исключая страницы\r\nlist_type=radio\r\nlist_sort=asc_d\r\ngroup=3\r\nrating=10\r\nhelp=Баннер может показываться на определенных страницах. Для этого выберите режим <b>Только на страницах</b> и в поле <b>Список страниц</b> укажите эти страницы. В режиме <b>Исключая страницы</b> баннер будет показан на всех страницах, за исключением тех, которые указаны в списке.','2010-09-13 15:28:44'),
	(29,'Дни недели','','week','lkey','type=list\r\nlist=-1|Все дни~1|Понедельник~2|Вторник~3|Среда~4|Четверг~5|Пятница~6|Суббота~7|Воскресенье\r\nlist_type=checkbox\r\nlist_sort=asc_d\r\nnotnull=1\r\ngroup=3\r\nrating=4\r\nhelp=Для коммерческого показа рекламы можно использовать таргетинг по дням. Если таргетинг по дням не используется, то установите флажок в положение \"Все дни\", в противном случае баннер показываться не будет','2010-09-13 15:28:44'),
	(32,'Время показов','','time','lkey','type=list\r\nlist=-1|Все время&nbsp;&nbsp;&nbsp;~1|00:00-01:00~2|01:00-02:00~3|02:00-03:00~4|03:00-04:00~5|04:00-05:00~6|05:00-06:00~7|06:00-07:00~8|07:00-08:00~9|08:00-09:00~10|09:00-10:00~11|10:00-11:00~12|11:00-12:00~13|12:00-13:00~14|13:00-14:00~15|14:00-15:00~16|15:00-16:00~17|16:00-17:00~18|17:00-18:00~19|18:00-19:00~20|19:00-20:00~21|20:00-21:00~22|21:00-22:00~23|22:00-23:00~24|23:00-24:00\r\nlist_type=checkbox\r\nlist_sort=asc_d\r\nnotnull=1\r\ngroup=3\r\nrating=5\r\nhelp=Для коммерческого показа рекламы можно использовать таргетинг по времени. Если таргетинг по времени не используется, то установите флажок в положение \"Все время\", в противном случае баннер показываться не будет','2010-09-13 15:28:44'),
	(33,'Место','','id_advert_block','lkey','type=tlist\r\nlist=data_banner_advert_block\r\ngroup=1\r\nrating=6\r\nfilter=1\r\nrequired=1\r\ntable_list=5\r\nqview=1\r\nshablon_w=field_multselect\r\nnotnull=1\r\nhelp=Баннер можно привязать к нескольким местам, которые прописаны в системе и в шаблонах. Желательно соблюдать размерность баннера и места, на которое он размещается, чтобы не портить верстку макета страницы\r\n','2010-09-13 15:28:44'),
	(36,'Статистика','','stat','lkey','type=table\r\ntable=dtbl_banner_stat\r\ngroup=4\r\nrating=15\r\ntemplate_w=field_table\r\ntable_fields=tdate,view_count,view_pay,click_count,click_pay\r\ntable_svf=id_banner\r\ntable_sortfield=tdate\r\ntable_buttons_key_w=delete\r\ntable_groupname=Общая информация\r\ntable_noindex=1\r\nhelp=Статистика показов и переходов за период. При клике по названию поля в таблице происходит сортировка по данному полю. Повторный клик приводит к обратной сортировке ','2009-04-19 00:18:01'),
	(37,'Списано за клики','','click_pay','lkey','type=d\nfloor=1\nrating=31\ngroup=1','2008-08-13 15:48:49'),
	(38,'Кол-во переходов','','click_count','lkey','type=d\ngroup=1\nrating=2','2008-08-13 15:48:49'),
	(39,'Списано за показы','','view_pay','lkey','type=d\nfloor=1\nrating=30\ngroup=1','2008-08-13 15:48:49'),
	(40,'Кол-во просмотров','','view_count','lkey','type=d\ngroup=1\nrating=1','2008-08-13 15:48:49'),
	(41,'Дата','','tdate','lkey','type=date\nrating=7\ngroup=1\nshablon_w=field_input_read','0000-00-00 00:00:00'),
	(42,'Файл','','filename','lkey','type=filename\nrating=2\nsizelimit=20000\nfile_ext=*.*','2010-09-13 15:24:08'),
	(43,'Флаг удаления картинки','','deletepict','lkey','type=chb\nsys=1','2008-10-26 13:53:51'),
	(44,'Список страниц','','list_page','lkey','type=tlist\r\nlist=texts_main_ru\r\nsort=1\r\nrating=22\r\ngroup=3\r\nmult=5\r\nrequest_url=/admin/banners/body\r\nnotdef=1\r\ntemplate_w=field_multselect_input\r\nhelp=Данное поле работает в паре с полем <b>Постраничный таргетинг</b>. Для выбора страниц нажмите на ссылку <b>Расширенный поиск</b>, расположенную слева. Появятся несколько дополнительных полей. В поле <b>поиск</b> введите подстроку, содержащуюся в названии страницы. В поле <b>доступные значения</b> появятся документы, которые содержат данную подстроку. При помощи кнопок со стрелками, расположенными справа, перенесите нужные страницы во второе поле <b>Выбранные значения</b>. Из последнего поля можно удалить документы, воспользовавшись соответствующими кнопками справа.\r\n','2010-09-13 15:28:44'),
	(45,'Флаг показать','','show','lkey','type=s\nsys=1','2009-04-29 17:55:04'),
	(46,'Флаг скрыть','','hide','lkey','type=s\nsys=1','0000-00-00 00:00:00'),
	(47,'ключ','','texts_main_ru','lkey','type=tlist\nlist=texts_main_ru','0000-00-00 00:00:00'),
	(48,'Баннер','','id_banner','lkey','type=tlist\nlist=data_banner\nsort=1\nsys=1','2009-04-17 12:43:22'),
	(50,'Список','','list_link','button','type_link=loadcontent\r\nadd_info=1\r\ncontroller=banners\r\nimageiconmenu=/admin/img/icons/menu/button.list.png\r\naction=enter\r\ntitle=Список\r\nrating=1\r\nparams=replaceme','0000-00-00 00:00:00'),
	(51,'Рейтинг','','rating','lkey','type=d\r\ngroup=1\r\nfilter=1\r\nrating=15\r\ntable_list=9\r\ntable_list_name=Rt\r\ntable_list_width=32\r\nqedit=1\r\nqview=1\r\nshablon_w=field_rating\r\nhelp=При прочих равных условиях, чем меньше рейтинг, тем чаще будет показываться баннер. Используется, если на одно место прописано несколько баннеров','2010-09-13 15:28:12'),
	(52,'Индекс','','index','lkey','type=d\r\nsys=1','2010-10-27 16:37:28'),
	(53,'IP адреса','','ip_data_click','lkey','type=code\r\nprint=1\r\nqview=1\r\nrating=99\r\ngroup=1\r\n','0000-00-00 00:00:00'),
	(54,'Имя рекламодателя','lst_advert_users','name','lkey','type=s\r\nfilter=1\r\ntable_list=1\r\nrequired=1\r\nqview=1\r\nqedit=1\r\ngroup=1\r\nrating=1\r\nno_format=1\r\n','0000-00-00 00:00:00'),
	(55,'E-mail','','email','lkey','type=email\r\nprint=1\r\nqview=1\r\nqedit=1\r\nrating=5\r\ntable_list=4\r\ntable_list_width=100\r\n','0000-00-00 00:00:00'),
	(56,'Телефон','','phone','lkey','type=s\r\nprint=1\r\nqview=1\r\nqedit=1\r\nrating=5\r\ntable_list=3\r\ntable_list_width=100\r\n','0000-00-00 00:00:00'),
	(57,'Открывать в новом окне','','targetblank','lkey','type=chb\r\nprint=1\r\nqview=1\r\nqedit=1\r\nrating=1\r\nfilter=1\r\nqview=1\r\nrating=3\r\ngroup=1\r\nyes=Да\r\nno=Нет\r\nhelp=Если указана URL-ссылка, то она будет открываться в новом окне','0000-00-00 00:00:00'),
	(59,'Цена за показ','','per_show','lkey','type=d\r\nprint=1\r\nqview=1\r\nqedit=1\r\nrating=11\r\nfileview=1\r\ntable_list=5\r\ntable_list_width=100\r\n','0000-00-00 00:00:00'),
	(60,'Языковые версии','','langs','lkey','type=list\nlist_out=lang\n#list=ru|Русский~en|English\nnotnull=1\nlist_type=checkbox\nrating=101\nfilter=1\ntable_list=10\ntable_list_width=100\nfileview=1\nqedit=1\nqview=1\n','0000-00-00 00:00:00'),
	(61,'Копировать запись','','copy','button','type_link=loadcontent\nprint_info=1\nedit_info=1\nloading_msg=1\ncontroller=banners\naction=copy\nimageiconmenu=/admin/img/icons/menu/icon_copy.png\ntitle=Копировать запись\nrating=5\nparams=replaceme,index,list_table','0000-00-00 00:00:00'),
	(62,'Таргетинг по URL','','target_url','lkey','type=list\nlist=0|на всех страницах~1|только на страницах~2|исключая страницы\nlist_type=radio\nlist_sort=asc_d\ngroup=3\nrating=25\nhelp=Баннер может показываться на определенных URL','0000-00-00 00:00:00'),
	(63,'URL страниц','','urls','lkey','type=tlist\nlist=lst_banner_urls\ntemplate_w=field_multselect_input\ngroup=3\nmult=5\nadd_to_list=1\nrating=26\n','2014-08-25 13:33:28');

/*!40000 ALTER TABLE `keys_banners` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table keys_catalog
# ------------------------------------------------------------

DROP TABLE IF EXISTS `keys_catalog`;

CREATE TABLE `keys_catalog` (
  `ID` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL DEFAULT '',
  `tbl` varchar(64) NOT NULL DEFAULT '',
  `lkey` varchar(64) NOT NULL DEFAULT '',
  `object` varchar(8) NOT NULL DEFAULT '',
  `settings` text NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `tbl` (`tbl`,`lkey`,`object`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Ключи к модулю Тексты';

LOCK TABLES `keys_catalog` WRITE;
/*!40000 ALTER TABLE `keys_catalog` DISABLE KEYS */;

INSERT INTO `keys_catalog` (`ID`, `name`, `tbl`, `lkey`, `object`, `settings`, `updated_at`)
VALUES
	(1,'Добавить запись','','add_link','button','type_link=openpage\nposition=center\nid=newentry\r\ntable_list=1\r\nprint_info=1\nedit_info=1\r\ncontroller=catalog\r\naction=add\r\nimageiconmenu=/admin/img/icons/menu/icon_add.png\r\ntitle=Добавить\r\nrating=1\r\nparams=replaceme,list_table','0000-00-00 00:00:00'),
	(2,'Удалить запись','','del_link','button','type_link=loadcontent\r\ncontroller=catalog\r\naction=delete\r\nconfirm=Действительно удалить запись?\r\ntitle=Удалить запись\r\nimageiconmenu=/admin/img/icons/menu/icon_delete.png\r\nprint_info=1\r\nrating=1\r\nparams=replaceme,index,list_table','0000-00-00 00:00:00'),
	(3,'Редактировать запись','','edit_link','button','type_link=loadcontent\r\nprint_info=1\r\ncontroller=catalog\r\naction=edit\r\nimageiconmenu=/admin/img/icons/menu/icon_edit.png\r\ntitle=Редактировать запись\r\nrating=2\r\nparams=replaceme,index,list_table','0000-00-00 00:00:00'),
	(4,'Закончить редактирование','','end_link','button','type_link=loadcontent\r\nedit_info=1\r\ncontroller=catalog\r\naction=info\r\nimageiconmenu=/admin/img/icons/menu/icon_ok.png\r\ntitle=Закончить редактирование\r\nrating=10\r\nparams=replaceme,index,list_table\r\n','0000-00-00 00:00:00'),
	(5,'Фильтр','','filter','button','type_link=modullink\r\ntable_list=1\r\ntable_list_orders=1\r\ncontroller=catalog\r\naction=filter\r\nimageiconmenu=/admin/img/icons/menu/icon_filter.png\r\ntitle=Фильтр\r\nwidth=690\r\nheight=510\r\nlevel=3\r\nrating=2\r\nparams=replaceme,list_table','0000-00-00 00:00:00'),
	(6,'Очистка фильтра','','filter_clear','button','type_link=loadcontent\r\ntable_list=1\r\ntable_list_orders=1\r\ntable_list_dir=1\r\ncontroller=catalog\r\naction=filter_clear\r\nimageiconmenu=/admin/img/icons/menu/icon_nofilter.png\r\ntitle=Снять фильтры\r\nrating=3\r\nparams=replaceme,list_table','0000-00-00 00:00:00'),
	(7,'Название','','name','lkey','type=s\r\nfilter=1\r\ngroup=1\r\nrating=1\r\nrequired=1\r\nqedit=1\r\ntable_list=1\r\nno_format=1\r\nfileview=1\r\n','2010-10-31 11:29:29'),
	(8,'Текст - правый блок','','text','lkey','type=html\r\nprint=1\r\ngroup=2\r\nrating=201\r\n','0000-00-00 00:00:00'),
	(9,'Рейтинг','','rating','lkey','type=d\r\ngroup=1\r\nqview=1\r\nqedit=1\r\ntable_list=10\r\ntable_list_name=Rt\r\ntable_list_width=32\r\nrating=99\r\ntemplate_w=field_rating\r\n','0000-00-00 00:00:00'),
	(10,'Фото','','images','lkey','type=table\r\ntable=dtbl_catalog_items_images\r\ngroup=3\r\nrating=15\r\ntemplate_w=field_table\r\ntable_fields=name,pict,rating\r\ntable_svf=id_item\r\ntable_sortfield=rating\r\ntable_buttons_key_w=delete,edit\r\ntable_groupname=Общая информация\r\ntable_noindex=1\r\ntable_add=1\r\n','0000-00-00 00:00:00'),
	(11,'Картинка','','pict','lkey','type=pict\r\nrating=14\r\ntemplate_w=field_pict\r\ntemplate_r=field_pict_read\r\nsizelimit=20000\r\next=*.jpg;*.jpeg;*.gif;\r\nmini=188x180~crop,250x333~montage,550x733~montage,102x136~crop\nfolder=/image/catalog/items/\r\nfileview=1\r\ntable_list=4\r\ntable_list_type=pict\r\ntable_list_name=-\r\n','0000-00-00 00:00:00'),
	(12,'Картинка','dtbl_catalog_items_images','pict','lkey','type=pict\r\nrating=14\r\nsizelimit=20000\r\next=*.jpg;*.jpeg;*.gif;\r\nmini=102x136~crop,550x733~montage\r\nfolder=/image/catalog/items/dopimgs/\r\nfileview=1\r\ntable_list=4\r\ntable_list_type=pict\r\ntable_list_name=-\n\n\r\n','0000-00-00 00:00:00'),
	(13,'Товар','','id_item','lkey','type=tlist\r\nlist=data_catalog_items\r\nsys=1\r\n','0000-00-00 00:00:00'),
	(14,'Рекомендуемые товары','','recommend','lkey','type=tlist\r\nlist=data_catalog_items\r\ntemplate_w=field_multselect_input\r\nselect_help=1\r\nrating=80\r\ngroup=1\r\nfileview=1\r\n\r\n','0000-00-00 00:00:00'),
	(15,'Алиас','','alias','lkey','type=s\r\nrating=2\r\ntable_list=2\r\ngroup=1\r\nfilter=1\r\nqview=1\r\nqedit=1\r\nrequired=1\r\nhelp=Короткое латинское название, которое учавствует в формирование URL для данной страницы','0000-00-00 00:00:00'),
	(16,'Публиковать на сайте','','active','lkey','type=chb\nprint=1\nqview=1\nqedit=1\nfilter=1\ntable_list=10\ntable_list_name=-\ntable_list_width=48\nyes=Виден\nno=Скрыт\nrating=99\n','0000-00-00 00:00:00'),
	(47,'Родительская категория','data_catalog_categorys','parent_category_id','lkey','type=tlist\nlist=data_catalog_categories\nprint=1\nqview=1\nqedit=1\nfilter=1\ntable_list=4\ntable_list_width=200\nrating=10\nwhere= AND parent_category_id=0\n\n\n','0000-00-00 00:00:00'),
	(18,'Картинка','data_catalog_categorys','pict','lkey','type=pict\r\nrating=14\r\ntemplate_w=field_pict\r\ntemplate_r=field_pict_read\r\nsizelimit=20000\r\next=*.jpg;*.jpeg;*.gif;\r\nmini=317x103~crop\nfolder=/image/catalog/categories/\r\nfileview=1\r\ntable_list=4\r\ntable_list_type=pict\r\ntable_list_name=-\r\n','0000-00-00 00:00:00'),
	(19,'Категория','','category_id','lkey','type=tlist\nlist=data_catalog_categories\nprint=1\nqview=1\nqedit=1\nfilter=1\ntable_list=4\ntable_list_width=200\nrating=9\n\n','0000-00-00 00:00:00'),
	(20,'Цена','','price','lkey','type=float\nprint=1\nqview=1\nqedit=1\nrating=10\ntable_list=7\ntable_list_widht=100\nrating=15\nrequired=1\n\n\n','0000-00-00 00:00:00'),
	(21,'Артикул','','articul','lkey','type=s\nprint=1\nrating=12\nfileview=1\ntable_list=7\ntable_list_width=100\nqedit=1\nqview=1\nprint=1\n','0000-00-00 00:00:00'),
	(52,'Картинка','data_catalog_brands','pict','lkey','type=pict\r\nrating=14\r\nsizelimit=20000\r\next=*.jpg;*.jpeg;*.gif;\r\nmini=122x122~montage,269x269~montage\r\nfolder=/image/catalog/brands/\r\nfileview=1\r\ntable_list=4\r\ntable_list_type=pict\r\ntable_list_name=-\n\n\r\n','0000-00-00 00:00:00'),
	(23,'Ключевые слова','','keywords','lkey','type=s\nrating=3\ngroup=1\nfilter=1\nqedit=1\nhelp=Ключевые слова и выражения, разделенные запятой, которые соответствуют данному тексту. Используется для оптимизации страницы под поисковые системы. Указанные слова в данном поле должны обязательно присутствовать в тексте — в противном случае они не будут учитываться поисковыми машинами.\ndirview=1\nfileview=1','2010-10-29 12:23:39'),
	(24,'Краткое описание страницы','','description','lkey','type=text\r\nrating=3\r\ngroup=1\r\nqview=1\r\nhelp=Краткое описание текста. Используется для поисковых систем. Выводится на странице в meta-теге description. Как правило, пользователь данный текст не видет. Для поисковых систем полезнее для каждой страницы формировать свое описание, наиболее соответствующее данной странице.\r\ndirview=1\r\nfileview=1','2010-10-29 12:23:39'),
	(25,'Заголовок окна','','title','lkey','type=s\nno_format=1\nrating=2\ngroup=1\nqview=1\nqedit=1\nhelp=Заголовок окна браузера. Может отличаться от названия текста. Используется для оптимизации под поисковые системы.\ndirview=1\nfileview=1','2010-10-29 12:23:39'),
	(26,'Копировать запись','','copy','button','type_link=loadcontent\nprint_info=1\nedit_info=1\nloading_msg=1\ncontroller=catalog\naction=copy\nimageiconmenu=/admin/img/icons/menu/icon_copy.png\ntitle=Копировать запись\nrating=5\nparams=replaceme,index,list_table\n','0000-00-00 00:00:00'),
	(27,'Комментарий','','comment','lkey','type=text\nprint=1\nqview=1\nrating=90\nfileview=1\n','0000-00-00 00:00:00'),
	(28,'Комментарий оператора','','operator_comment','lkey','type=text\nprint=1\nqview=1\nrating=95\nfileview=1\n','0000-00-00 00:00:00'),
	(29,'Название','dtbl_catalog_items_images','name','lkey','type=s\r\nfilter=1\r\ngroup=1\r\nrating=1\r\nqedit=1\r\ntable_list=1\r\nno_format=1\r\nfileview=1\r\n','2010-10-31 11:29:29'),
	(30,'Текст - нижний блок','','text_bottom','lkey','type=html\r\nprint=1\r\ngroup=2\r\nrating=202\n\r\n','0000-00-00 00:00:00'),
	(31,'Товары','','order','lkey','type=table\r\ntable=dtbl_orders\r\ngroup=2\r\nrating=201\r\ntable_fields=pict,id_item,articul,name,price,totalprice,count,size,footsize\r\ntable_svf=id_order\r\ntable_sortfield=name\r\ntable_buttons_key_w=delete_select,edit\r\ntable_buttons_key_r=\r\ntable_groupname=Информация по файлу\r\ntable_icontype=1\r\ntable_noindex=1\r\nshablon_w=field_table\r\nshablon_r=field_table','2011-10-27 09:47:47'),
	(62,'ФИО','data_catalog_orders','name','lkey','type=s\r\nfilter=1\r\ngroup=1\r\nrating=1\r\nrequired=1\r\nqedit=1\r\ntable_list=1\r\nno_format=1\r\nfileview=1\r\n','2010-10-31 11:29:29'),
	(33,'Цвет','','color','lkey','type=tlist\r\nlist=lst_catalog_colors\r\ntemplate_w=field_list_read\r\nrating=82\r\ngroup=1\r\nfileview=1\r\n','0000-00-00 00:00:00'),
	(34,'Кол-во','','count','lkey','type=d\nprint=1\nqview=1\nqedit=1\nrating=4\nfileview=1\n','0000-00-00 00:00:00'),
	(35,'Сумма','','totalprice','lkey','type=float\nprint=1\nqview=1\nqedit=1\nrating=11\ntable_list=8\ntable_list_widht=100\nrating=15\nrequired=1\n\n\n','0000-00-00 00:00:00'),
	(36,'Город','','city','lkey','type=s\nprint=1\nqview=1\nqedit=1\ntable_list=5\ntable_list_widht=200\nrating=31\n\n\n\n','0000-00-00 00:00:00'),
	(37,'Телефон','','phone','lkey','type=s\nprint=1\nqview=1\nqedit=1\ntable_list=5\ntable_list_widht=200\nrating=11\n\n\n\n','0000-00-00 00:00:00'),
	(38,'E-mail','','email','lkey','type=s\nprint=1\nqview=1\nqedit=1\ntable_list=6\ntable_list_widht=200\nrating=12\n\n\n\n','0000-00-00 00:00:00'),
	(39,'Статус заказа','','orderstatus','lkey','type=list\nlist=0|Новый~1|Проверен~2|Выполнен~3|Закрыт\nlist_type=radio\ntable_list=7\ntable_list_width=100\nfilter=1\nqedit=1\nqview=1\nprint=1\n','0000-00-00 00:00:00'),
	(40,'Новинка','','is_new','lkey','type=chb\nprint=1\nqview=1\nfilter=1\nrating=90\ntable_list=7\ntable_list_width=70\nyes=да\nno=нет\nqedit=1\n','0000-00-00 00:00:00'),
	(41,'Распродажа','','is_sale','lkey','type=chb\nprint=1\nqview=1\nfilter=1\nrating=91\ntable_list=8\ntable_list_width=70\nyes=да\nno=нет\nqedit=1\n','0000-00-00 00:00:00'),
	(42,'Бренд','','brand_id','lkey','type=tlist\nlist=data_catalog_brands\nprint=1\nqview=1\nqedit=1\nfilter=1\ntable_list=5\ntable_list_width=200\nrating=11\n\n','0000-00-00 00:00:00'),
	(43,'Размеры товара','','sizes','lkey','type=s\nprint=1\nqview=1\nqedit=1\ntable_list=6\ntable_list_width=150\nrating=50\nfileview=1\n','0000-00-00 00:00:00'),
	(44,'Подкатегория','','parent_category_id','lkey','type=tlist\nlist=data_catalog_categories\nprint=1\nqview=1\nqedit=1\nfilter=1\ntable_list=4\ntable_list_width=200\nrating=10\n#where= AND parent_category_id>0\n\n\n','0000-00-00 00:00:00'),
	(45,'Цвет','','color_id','lkey','type=tlist\nlist=lst_catalog_colors\nprint=1\nfilter=1\ntable_list=7\ntable_list_width=100\nqview=1\nqedit=1\nrating=45\nfileview=1\nadd_to_list=1\n','0000-00-00 00:00:00'),
	(46,'Пол','','gender','lkey','type=list\nlist=1|Мужское~2|Женское~3|Детское\nnotnull=1\nrating=10\nfileview=1\nqview=1\nqedit=1\nrating=40\nfilter=1\ntable_list=9\ntable_list_width=70\nlist_type=radio\nrequired=1\n','0000-00-00 00:00:00'),
	(48,'Категория','data_catalog_items','category_id','lkey','type=tlist\nlist=data_catalog_categories\nprint=1\nqview=1\nqedit=1\nfilter=1\ntable_list=4\ntable_list_width=200\nrating=9\nwhere= AND parent_category_id=0\nrules=parent_category_id:data_catalog_categories.parent_category_id=index\nrequired=1\n','0000-00-00 00:00:00'),
	(49,'Подкатегория','data_catalog_items','parent_category_id','lkey','type=tlist\nlist=data_catalog_categories\nprint=1\nqview=1\nqedit=1\nfilter=1\ntable_list=4\ntable_list_width=200\nrating=10\nwhere= AND parent_category_id>0\nrequired=1\n\n\n','0000-00-00 00:00:00'),
	(50,'Состав','','sostav','lkey','type=s\nprint=1\nqview=1\nqedit=1\nrating=55\nfileview=1\n','0000-00-00 00:00:00'),
	(51,'Подкатегория','','subcategory_id','lkey','type=tlist\nlist=data_catalog_categories\nprint=1\nqview=1\nqedit=1\nfilter=1\ntable_list=4\ntable_list_width=200\nrating=10\nwhere= AND parent_category_id>0\nrequired=1\n\n\n','0000-00-00 00:00:00'),
	(53,'Лого','','pict_logo','lkey','type=pict\r\nrating=20\r\nsizelimit=20000\r\next=*.png;\nfolder=/image/catalog/brands/logo/\r\nfileview=1\r\ntable_list=6\r\ntable_list_type=pict\r\ntable_list_name=Лого\norigin=1\n\n\r\n','0000-00-00 00:00:00'),
	(54,'Лого ЧБ','','pict_logo_hover','lkey','type=pict\r\nrating=21\r\nsizelimit=20000\r\next=*.png;\r\nfolder=/image/catalog/brands/logo/\r\nfileview=1\r\ntable_list=7\r\ntable_list_type=pict\r\ntable_list_name=Лого ЧБ\norigin=1\n\n\r\n','0000-00-00 00:00:00'),
	(55,'Индекс','','addressindex','lkey','type=s\nprint=1\nqview=1\nqedit=1\nrating=30','0000-00-00 00:00:00'),
	(56,'Улица','','street','lkey','type=s\nprint=1\nqview=1\nqedit=1\nrating=32','0000-00-00 00:00:00'),
	(57,'Дом','','house','lkey','type=s\nprint=1\nqview=1\nqedit=1\nrating=33','0000-00-00 00:00:00'),
	(58,'Корпус','','korpus','lkey','type=s\nprint=1\nqview=1\nqedit=1\nrating=34','0000-00-00 00:00:00'),
	(59,'Квартира','','apartment','lkey','type=s\nprint=1\nqview=1\nqedit=1\nrating=35','0000-00-00 00:00:00'),
	(60,'Комментарий','','ordercomment','lkey','type=text\nprint=1\nrating=50\nfileview=1\nqview=1\n','0000-00-00 00:00:00'),
	(61,'Комментарий оператора','','operatorcomment','lkey','type=text\nprint=1\nrating=51\nfileview=1\nqview=1\n','0000-00-00 00:00:00');

/*!40000 ALTER TABLE `keys_catalog` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table keys_faq
# ------------------------------------------------------------

DROP TABLE IF EXISTS `keys_faq`;

CREATE TABLE `keys_faq` (
  `ID` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL DEFAULT '',
  `tbl` varchar(64) NOT NULL DEFAULT '',
  `lkey` varchar(64) NOT NULL DEFAULT '',
  `object` varchar(8) NOT NULL DEFAULT '',
  `settings` text NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `tbl` (`tbl`,`lkey`,`object`)
) ENGINE=MyISAM DEFAULT CHARSET=cp1251 COMMENT='Ключи к модулю Тексты';

LOCK TABLES `keys_faq` WRITE;
/*!40000 ALTER TABLE `keys_faq` DISABLE KEYS */;

INSERT INTO `keys_faq` (`ID`, `name`, `tbl`, `lkey`, `object`, `settings`, `updated_at`)
VALUES
	(62,'Добавить запись','','add_link','button','type_link=openpage\nposition=center\nid=newentry\r\ntable_list=1\r\nprint_info=1\r\ncontroller=faq\r\naction=add\r\nimageiconmenu=/admin/img/icons/menu/icon_add.png\r\ntitle=Добавить\r\nrating=1\r\nparams=replaceme','0000-00-00 00:00:00'),
	(61,'Удалить запись','','del_link','button','type_link=loadcontent\r\ncontroller=faq\r\naction=delete\r\nimageiconmenu=/admin/img/icons/menu/icon_delete.png\r\nconfirm=Действительно удалить запись?\r\ntitle=Удалить запись\r\nprint_info=1\r\nrating=1\r\nparams=replaceme,index','0000-00-00 00:00:00'),
	(60,'Редактировать запись','','edit_link','button','type_link=loadcontent\r\nprint_info=1\r\ncontroller=faq\r\naction=edit\r\nimageiconmenu=/admin/img/icons/menu/icon_edit.png\r\ntitle=Редактировать запись\r\nrating=2\r\nparams=replaceme,index','0000-00-00 00:00:00'),
	(59,'Закончить редактирование','','end_link','button','type_link=loadcontent\r\nedit_info=1\r\ncontroller=faq\r\naction=info\r\nimageiconmenu=/admin/img/icons/menu/icon_ok.png\r\ntitle=Закончить редактирование\r\nrating=10\r\nparams=replaceme,index\r\n','0000-00-00 00:00:00'),
	(58,'Фильтр','','filter','button','type_link=modullink\r\ntable_list=1\r\ncontroller=faq\r\naction=filter\r\nimageiconmenu=/admin/img/icons/menu/icon_filter.png\r\ntitle=Фильтр\r\nwidth=690\r\nheight=510\r\nlevel=3\r\nrating=2\r\nparams=replaceme','0000-00-00 00:00:00'),
	(57,'Очистка фильтра','','filter_clear','button','type_link=loadcontent\r\ntable_list=1\r\nprogram=/cgi-bin/faq_a.cgi\r\nimageiconmenu=/admin/img/icons/menu/icon_nofilter.png\r\naction=filter_clear\r\ntitle=Снять фильтры\r\nrating=3\r\nparams=replaceme','0000-00-00 00:00:00'),
	(56,'Список','','list_link','button','type_link=loadcontent\r\nadd_info=1\r\ncontroller=faq\r\naction=enter\r\nimageiconmenu=/admin/img/icons/menu/button.list.png\r\ntitle=Список\r\nrating=1\r\nparams=replaceme','0000-00-00 00:00:00'),
	(44,'Дата вопроса','','quest_date','lkey','type=time\r\nrating=5\r\ntable_list=6\r\ntable_list_name=Дата\r\nshablon_w=field_time_exp\r\ngroup=1\r\nfileview=1\r\ndirview=1','0000-00-00 00:00:00'),
	(18,'Ключевые слова','','keywords','lkey','type=s\r\nrating=10\r\ngroup=1\r\nfilter=1\r\n','2008-10-30 17:15:04'),
	(20,'Публиковать','','active','lkey','type=chb\r\nrating=99\r\ntable_list=5\r\ntable_list_name=-\ntable_list_width=48\nyes=Виден\r\nno=Скрыт\ngroup=1\r\nfilter=1\r\nfileview=1\r\ndirview=1','2011-04-04 15:00:44'),
	(22,'Датировать датой','','tdate','lkey','type=time\r\nrating=7\r\ntable_list=6\r\ntable_list_name=Дата\r\nshablon_w=field_time_exp\r\ngroup=1\r\nfilter=1\r\nfileview=1\r\ndirview=1','2008-10-30 17:15:04'),
	(34,'Флаг показать','','show','lkey','type=s\nsys=1','2011-04-04 15:52:08'),
	(35,'Флаг скрыть','','hide','lkey','type=s\nsys=1','2011-04-04 15:52:05'),
	(36,'День','','day','lkey','type=d','0000-00-00 00:00:00'),
	(37,'Месяц','','month','lkey','type=d','0000-00-00 00:00:00'),
	(38,'Год','','year','lkey','type=d','0000-00-00 00:00:00'),
	(39,'Имя','','author_name','lkey','type=s\r\ntable_list=1\r\nfilter=1\r\ngroup=1\r\nrating=1\r\nno_format=1\r\nrequired=1\r\nqview=1\r\nshablon_reg=field_input\r\nshablon_view=field_input_read\r\neditform=1\r\nsaveform=1\r\nobligatory=1','2011-04-04 15:00:44'),
	(41,'Вопрос','','name','lkey','type=text\r\ngroup=1\r\nrating=6\r\nshablon_reg=field_text\r\nshablon_view=field_text_read\r\neditform=1\r\nsaveform=1\r\nobligatory=1\r\nobligatory_rules=validate[required]\r\ncktoolbar=Basic\r\n\r\n','2011-04-04 15:00:44'),
	(42,'Ответ','','answer','lkey','type=html\r\ngroup=1\r\nrating=90\r\ncktoolbar=Basic\r\n','2010-07-23 14:29:28'),
	(45,'Дата ответа','','answer_date','lkey','type=time\r\nrating=5\r\ntable_list=6\r\ntable_list_name=Дата\r\nshablon_w=field_time_exp\r\ngroup=1\r\n','0000-00-00 00:00:00'),
	(48,'Поле подтверждения по картинке','regform','number','lkey','type=d\r\nrating=90\r\ngroup=1\r\nobligatory=1\r\n#regform=1\r\n#editform=1\r\nshablon_reg=field_imgconfirm','0000-00-00 00:00:00'),
	(49,'Код на картинке','','code','lkey','type=d\r\nsys=1','0000-00-00 00:00:00'),
	(71,'Автор ответа','','answer_name','lkey','type=s\r\nfilter=1\r\ngroup=1\r\nrating=2\r\nno_format=1\r\nqview=1','2010-07-23 14:29:20'),
	(76,'E-mail','','email','lkey','type=s\r\ntable_list=1\r\nfilter=1\r\ngroup=1\r\nrating=3\r\nno_format=1\r\nrequired=1\r\nqview=1\r\neditform=1\r\nsaveform=1\r\nobligatory=1\r\n','2011-04-04 15:00:44'),
	(77,'Тема вопроса','','quest_anons','lkey','type=s\r\nprint=1\r\nqview=1\r\nrating=5\r\nqview=1\r\ntable_list=5\r\ntable_list_width=100\r\nrequired=1\r\nnext_td=1\r\n\r\n\r\n','2011-04-04 15:00:44'),
	(80,'Телефон','','phone','lkey','type=s\r\ntable_list=1\r\nfilter=1\r\ngroup=1\r\nrating=3\r\nno_format=1\r\nqview=1\r\nsaveform=1\r\n','0000-00-00 00:00:00'),
	(81,'Копировать запись','','copy','button','type_link=loadcontent\nprint_info=1\nedit_info=1\ncontroller=faq\naction=copy\nloading_msg=1\nimageiconmenu=/admin/img/icons/menu/icon_copy.png\ntitle=Копировать запись\nrating=5\nparams=replaceme,index,list_table','0000-00-00 00:00:00');

/*!40000 ALTER TABLE `keys_faq` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table keys_feedback
# ------------------------------------------------------------

DROP TABLE IF EXISTS `keys_feedback`;

CREATE TABLE `keys_feedback` (
  `ID` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL DEFAULT '',
  `tbl` varchar(64) NOT NULL DEFAULT '',
  `lkey` varchar(64) NOT NULL DEFAULT '',
  `object` varchar(8) NOT NULL DEFAULT '',
  `settings` text NOT NULL,
  `edate` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`ID`),
  UNIQUE KEY `tbl` (`tbl`,`lkey`,`object`)
) ENGINE=MyISAM DEFAULT CHARSET=cp1251 COMMENT='Ключи к модулю Тексты';

LOCK TABLES `keys_feedback` WRITE;
/*!40000 ALTER TABLE `keys_feedback` DISABLE KEYS */;

INSERT INTO `keys_feedback` (`ID`, `name`, `tbl`, `lkey`, `object`, `settings`, `edate`)
VALUES
	(1,'Поле подтверждения по картинке','','number','lkey','type=d\r\nrating=90\r\ngroup=1\r\nobligatory=1\r\nregform=1\r\neditform=1\r\nshablon_reg=field_imgconfirm\r\n','0000-00-00 00:00:00'),
	(8,'Индекс','','index','lkey','sys=1','0000-00-00 00:00:00'),
	(3,'ФИО','','name','lkey','type=s\r\nrating=1\r\nkeys_read=1\r\nshablon_reg=field_input\r\nshablon_view=field_input_read\r\neditform=1\r\nsaveform=1\r\nobligatory=1\r\nobligatory_rules=validate[required,custom[noSpecialCaracters],length[0,255]]','0000-00-00 00:00:00'),
	(5,'Код на картинке','','code','lkey','type=d\r\nsys=1','0000-00-00 00:00:00'),
	(6,'Язык сайта','','lang','lkey','type=list\r\nlist=lang\r\nrating=20','0000-00-00 00:00:00'),
	(7,'Ваше сообщение','','ftext','lkey','type=text\r\nrating=5\r\nkeys_read=1\r\nshablon_reg=field_text\r\nshablon_view=field_input_read\r\nvacancy=1\r\neditform=1\r\nsaveform=1\r\nobligatory=1\r\nobligatory_rules=validate[required]','0000-00-00 00:00:00'),
	(11,'флаг отсылки','','send','lkey','type=d\r\nsys=1','0000-00-00 00:00:00'),
	(14,'E-mail','','email','lkey','type=email\r\nrating=4\r\nkeys_read=1\r\nshablon_reg=field_input\r\nshablon_view=field_input_read\r\neditform=1\r\nsaveform=1\r\nobligatory=1\r\nobligatory_rules=validate[required,custom[email]]','0000-00-00 00:00:00'),
	(15,'Тема сообщения','','subject','lkey','type=s\r\nrating=5\r\nkeys_read=1\r\nshablon_reg=field_input\r\nshablon_view=field_input_read\r\n#editform=1\r\n#saveform=1\r\nobligatory_rules=validate[optional]','0000-00-00 00:00:00'),
	(16,'Телефон','','phone','lkey','type=s\nrating=3\nkeys_read=1\nshablon_reg=field_input\nshablon_view=field_input_read\neditform=1\nsaveform=1\n','0000-00-00 00:00:00');

/*!40000 ALTER TABLE `keys_feedback` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table keys_filemanager
# ------------------------------------------------------------

DROP TABLE IF EXISTS `keys_filemanager`;

CREATE TABLE `keys_filemanager` (
  `ID` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL DEFAULT '',
  `tbl` varchar(64) NOT NULL DEFAULT '',
  `lkey` varchar(64) NOT NULL DEFAULT '',
  `object` varchar(8) NOT NULL DEFAULT '',
  `settings` text NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `tbl` (`tbl`,`lkey`,`object`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Ключи к модулю Тексты';



# Dump of table keys_global
# ------------------------------------------------------------

DROP TABLE IF EXISTS `keys_global`;

CREATE TABLE `keys_global` (
  `ID` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL DEFAULT '',
  `tbl` varchar(64) NOT NULL DEFAULT '',
  `lkey` varchar(64) NOT NULL DEFAULT '',
  `object` varchar(8) NOT NULL DEFAULT '',
  `settings` text NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `tbl` (`tbl`,`lkey`,`object`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Глобальные ключи';

LOCK TABLES `keys_global` WRITE;
/*!40000 ALTER TABLE `keys_global` DISABLE KEYS */;

INSERT INTO `keys_global` (`ID`, `name`, `tbl`, `lkey`, `object`, `settings`, `updated_at`)
VALUES
	(1,'Ключ функции','','action','lkey','type=slat','2008-01-17 03:42:23'),
	(2,'Индекс','','index','lkey','type=d','2008-01-12 20:31:32'),
	(3,'Дата создания','','rdate','lkey','type=datetime\r\ntemplate_w=field_input_read\ngroup=1\nrating=200','2009-02-05 02:01:30'),
	(4,'Дата редактирования','','edate','lkey','type=datetime\ntemplate_w=field_input_read\ngroup=1\nrating=199','0000-00-00 00:00:00'),
	(5,'Случайная переменная','','rndval','lkey','type=d\r\nsys=1','2008-01-17 03:42:23'),
	(6,'Поле сортировки','','sfield','lkey','type=s','2008-01-12 20:31:32'),
	(7,'Страница','','page','lkey','type=d','2008-01-12 20:31:32'),
	(8,'Порядок сортировки','','asc','lkey','type=slat','2008-01-12 20:31:32'),
	(9,'Количество записей на страницу','','pcol','lkey','type=d','2008-01-12 20:31:32'),
	(10,'Язык сайта','','lang','lkey','type=list\r\nlist=ru|Русский\r\nnotnull=1\r\n','2008-02-15 13:31:34'),
	(12,'Программный модуль','','id_program','lkey','type=tlist\r\nlist=sys_program\r\nsort=1\r\nrating=2\r\nfilter=1\r\nqview=1','2007-12-06 21:23:35'),
	(13,'Ключ','','envkey','lkey','type=slat\r\nrating=3\r\nqview=1','2007-12-06 21:23:35'),
	(14,'Значение переменной','','envvalue','lkey','type=text\r\nrating=4\r\nqview=1','2007-12-06 21:23:35'),
	(15,'Подсказка','','help','lkey','type=s\r\nrating=4','2007-12-06 21:23:35'),
	(16,'Тип поля','','types','lkey','type=list\r\nlist=s|Строка~slat|Строка-латиница~list|Список(выпадающий)~chb|Чебокс(да/нет)~list_chb|Список(множественный выбор)~list_radio|Список(единичный выбор)~email|e-mail~d|Число~code|Программный код~text|Текст~html|HTML текст~pict|Картинка~file|Файл\r\nrating=3\r\nlist_sort=asc_d','2007-12-06 21:23:35'),
	(18,'Значение по умолчнию','','set_def','lkey','type=text\r\nrating=7','2007-12-06 21:23:35'),
	(19,'Список индексов','','listindex','lkey','type=s\r\nsys=1','2007-05-08 20:40:34'),
	(20,'Ключ','','lkey','lkey','type=slat','2007-06-05 03:42:33'),
	(21,'Таблица','','tbl','lkey','type=slat','2007-06-05 03:42:33'),
	(22,'Программа (модуль)','','modul','lkey','type=slat','2007-06-05 03:42:33'),
	(23,'Логин','','login','lkey','type=login\r\nrating=4','2008-02-29 03:03:10'),
	(24,'Пароль','','pwd','lkey','type=slat','2008-02-29 03:03:10'),
	(25,'Включать левую панель','','leftwin_hidden','lkey','type=chb\r\nyes=включать\r\nне включать\r\nsys=1','0000-00-00 00:00:00'),
	(26,'Включать правую панель','','rightwin_hidden','lkey','type=chb\r\nyes=включать\r\nне включать\r\nsys=1','0000-00-00 00:00:00'),
	(34,'Флаг удаления','','delete','lkey','type=d','2008-03-13 22:08:22'),
	(35,'Контейнер для вставки информации','','replaceme','lkey','type=s\r\nsys=1','2008-03-16 04:07:49'),
	(33,'Строка быстрого поиска','','qsearch','lkey','type=s','2008-03-12 15:30:36'),
	(36,'Группа','','group','lkey','type=d\r\nsys=1','2008-03-17 01:14:18'),
	(37,'Индекс родительского объекта','','pid','lkey','type=d','2008-01-12 20:31:32'),
	(38,'Флаг первого открытия','','first_flag','lkey','type=d\r\nsys=1','0000-00-00 00:00:00'),
	(39,'Ключ программы','','key_program','lkey','type=s\nsys=1','0000-00-00 00:00:00'),
	(40,'Подстрока поиска','','keystring','lkey','type=s\nsys=1','0000-00-00 00:00:00'),
	(41,'Поле','','listfields','lkey','type=s\r\nsys=1','0000-00-00 00:00:00'),
	(42,'Правила связки полей','','rules','lkey','type=s\nsys=1','0000-00-00 00:00:00'),
	(43,'Флаг открытия в модальном окне','','flag_win','lkey','type=chb\nsys=1\nyes=да\nno=нет','0000-00-00 00:00:00'),
	(44,'Поле','','lfield','lkey','type=s\nsys=1','0000-00-00 00:00:00'),
	(45,'Дополнительная таблица','','dop_table','lkey','type=s\nsys=1','0000-00-00 00:00:00'),
	(46,'Доступ','','access_flag','lkey','type=s\nsys=1','0000-00-00 00:00:00'),
	(47,'Ключ сессии','','cck','lkey','type=s\nsys=1','0000-00-00 00:00:00'),
	(48,'Файл','','Upload','lkey','type=file\nsys=1','0000-00-00 00:00:00'),
	(49,'Имя файла','','Filename','lkey','type=filename\nsys=1','0000-00-00 00:00:00'),
	(50,'Имя файла','','upfilefilename','lkey','type=file\nsys=1','0000-00-00 00:00:00'),
	(51,'Имя файла','','filenamefilename','lkey','type=filename\nsys=1','0000-00-00 00:00:00'),
	(52,'Оператор','','operator','lkey','type=s\nsys=1','0000-00-00 00:00:00'),
	(53,'Директория с файлами','','folder','lkey','type=s\nsys=1','0000-00-00 00:00:00'),
	(54,'Размер файла','','size','lkey','type=d\r\nsys=1\r\n\r\n','0000-00-00 00:00:00'),
	(55,'Тип файла','','type_file','lkey','type=s\r\nsys=1\r\n','0000-00-00 00:00:00'),
	(57,'Имя файла','','upfilepict','lkey','type=file\nsys=1','0000-00-00 00:00:00'),
	(58,'Имя файла','','filenamepict','lkey','type=s\r\nsys=1','0000-00-00 00:00:00'),
	(59,'Имя файла','','upfile','lkey','type=file\nsys=1','0000-00-00 00:00:00'),
	(60,'Индекс','','ID','lkey','type=d\nsys=1','0000-00-00 00:00:00'),
	(61,'Дополнительная таблица','','list_table','lkey','type=s\nsys=1','0000-00-00 00:00:00'),
	(62,'Запоминать при входе','','auth_rem','lkey','type=chb\r\nyes=запоминать\r\nне запоминать\r\nsys=1','0000-00-00 00:00:00'),
	(63,'Ключ раздела','','key_razdel','lkey','type=s\nsys=1','0000-00-00 00:00:00'),
	(64,'Флаг не перегружать меню кнопок','','menu_button_no','lkey','type=d\nsys=1','0000-00-00 00:00:00'),
	(65,'Имя файла','','Filedata','lkey','type=file\r\nsys=1','0000-00-00 00:00:00'),
	(66,'Разделы меню основной страницы ПУ','','panel_razdel','lkey','type=list\r\nlist=1|Основные модули~2|Каталог, интернет-магазин~3|Дополнительные модули~4|Настройки','2008-03-06 19:53:50'),
	(67,'Панель управления','','admin','button','type_link=loadcontent\r\nmenu_button=1\r\nmenu_settings=1\r\nmenu_banner=1\r\nmenu_center=1\r\nmenu_subscribe=1\r\nmenu_catalog=1\r\nmenu_usercommon=1\r\nmainrazdel_button=1\r\nreplaceme=replaceme\r\ncontroller=main\r\naction=mainpage\r\nimageiconmenu=/admin/img/icons/menu/icon_home.png\r\ntitle=Панель управления\r\nrating=1\r\n','2009-02-04 22:29:30'),
	(68,'Выйти','','logout','button','type_link=javascript\r\nfunction=loadfile(\"/admin/logout\");\r\nmenu_button=1\r\nmenu_subscribe=1\r\nmenu_center=1\r\nmenu_catalog=1\r\nmenu_settings=1\r\nmenu_banner=1\r\nmenu_usercommon=1\r\nmainrazdel_button=1\r\nimageiconmenu=/admin/img/icons/menu/icon_exit.png\r\ntitle=Выйти\r\nrating=200','2009-02-04 22:30:40'),
	(70,'Ключи','','keys','button','type_link=loadcontent\r\nmenu_settings=1\r\nreplaceme=replaceme\r\ncontroller=keys\r\naction=mainpage\r\nimageiconmenu=/admin/img/icons/menu/icon_objects.png\r\ntitle=Объекты\r\nrating=3','2008-03-15 21:51:53'),
	(71,'Права доступа','','access','button','type_link=loadcontent\r\nmenu_settings=1\r\nreplaceme=replaceme\r\ncontroller=access\r\naction=enter\r\nimageiconmenu=/admin/img/icons/menu/icon_access.png\r\ntitle=Политика безопасности\r\nrating=7','2009-02-05 02:00:03'),
	(72,'Шаблоны','','templates','button','type_link=loadcontent\r\nmenu_settings=1\r\nreplaceme=replaceme\r\ncontroller=templates\r\naction=mainpage\r\nimageiconmenu=/admin/img/icons/menu/icon_templates.png\r\ntitle=Шаблоны\r\nrating=14\nsettings_topmenu=1\n','2009-02-05 02:00:11'),
	(73,'Стили','','styles','button','type_link=loadcontent\r\nmenu_settings=1\r\nreplaceme=replaceme\r\ncontroller=styles\r\naction=mainpage\r\nimageiconmenu=/admin/img/icons/menu/icon_styles.png\r\ntitle=Стили\r\nrating=4\nsettings_topmenu=1\n','2009-02-05 02:00:58'),
	(74,'Глобальные переменные','','vars','button','type_link=loadcontent\r\nmenu_settings=1\r\nreplaceme=replaceme\r\ncontroller=vars\r\naction=enter\r\nimageiconmenu=/admin/img/icons/menu/icon_settings.png\r\ntitle=Глобальные переменные\r\nrating=5\nsettings_topmenu=1\n','2009-02-05 02:00:50'),
	(75,'Учетные записи','','sysusers','button','type_link=loadcontent\r\nmenu_settings=1\r\nreplaceme=replaceme\r\ncontroller=sysusers\r\naction=enter\r\nimageiconmenu=/admin/img/icons/menu/icon_users.png\r\ntitle=Учетные записи\r\nrating=6\nsettings_topmenu=1\n','2009-02-05 01:59:53'),
	(76,'Справочники','','lists','button','type_link=loadcontent\r\nmenu_settings=1\r\nreplaceme=replaceme\r\ncontroller=lists\r\naction=mainpage\r\nprogram=/cgi-bin/lists_a.cgi\r\nimageiconmenu=/admin/img/icons/menu/icon_lists.png\r\ntitle=Справочники\r\nrating=2\nsettings_topmenu=1\n','2009-02-05 02:00:25'),
	(77,'Объекты','','object','menu','type_link=loadcontent\r\naction=enter\r\nprogram=/cgi-bin/object_a.cgi\r\nrating=18\r\nparentid=setting\r\nreplaceme=replaceme\r\nsubmenuwidth=200','0000-00-00 00:00:00'),
	(78,'Флаг загрузки таблицы','','table_flag','lkey','type=d\r\nsys=1','2009-02-06 02:26:28'),
	(79,' Временная переменная','','amp','lkey','type=s\nsys=1\n','2009-02-07 14:10:19'),
	(80,'Новые данные сохранения QEdit','','textEditValue','lkey','type=s\r\nsys=1','2009-02-08 19:35:58'),
	(81,'ID элемента для QEdit','','textEditElementId','lkey','type=s\r\nsys=1','2009-02-08 19:35:58'),
	(84,'Флаг работы QEdit','','saveTextEdit','lkey','type=d\r\nsys=1','2009-02-14 13:59:54'),
	(85,'Тексты','','texts','button','type_link=loadcontent\r\nmainrazdel_button=1\r\ntexts_topmenu=1\r\nreplaceme=replaceme\r\ncontroller=texts\r\naction=enter\r\nimageiconmenu=/admin/img/icons/menu/button.text.png\r\ntitle=Тексты\r\nrating=2','2009-03-17 17:09:40'),
	(86,'Изображения','','images','button','type_link=loadcontent\r\n#mainrazdel_button=1\r\nimages_topmenu=1\r\nreplaceme=replaceme\r\ncontroller=images\r\naction=enter\r\nimageiconmenu=/admin/img/icons/menu/button.image.png\r\ntitle=Изображения\r\nrating=5','2009-04-09 16:41:55'),
	(87,'Рекламные места','','advplace','button','type_link=loadcontent\r\nmenu_banner=1\r\nbanners_topmenu=1\r\nreplaceme=replaceme\r\ncontroller=banners\r\ndo=list_container&list_table=data_banner_advert_block\r\nimageiconmenu=/admin/img/icons/menu/button.advplace.png\r\ntitle=Рекламные места\r\nrating=3\r\n','2009-04-16 16:58:36'),
	(88,'Рекламодатели','','advuser','button','type_link=loadcontent\r\nmenu_banner=1\r\nbanners_topmenu=1\r\nreplaceme=replaceme\r\ncontroller=banners\r\ndo=list_container&list_table=data_banner_advert_users\r\nimageiconmenu=/admin/img/icons/menu/button.users.png\r\ntitle=Рекламодатели\r\nrating=4\r\n','2009-04-16 16:59:00'),
	(89,'Баннеры','','banners','button','type_link=loadcontent\r\nmenu_banner=1\r\nbanners_topmenu=1\r\nreplaceme=replaceme\r\ncontroller=banners\r\ndo=enter\r\nimageiconmenu=/admin/img/icons/menu/button.banner.png\r\ntitle=Баннеры\r\nrating=2','2009-04-16 16:59:18'),
	(90,'ключ поля заменить на описание','','eexcel_key','lkey','type=chb\nsys=1\nyes=да\nno=нет','2009-04-19 20:41:32'),
	(91,'индексы заменять на описание','','eexcel_field','lkey','type=chb\nsys=1\nyes=да\nno=нет','2009-04-19 20:42:10'),
	(100,'Каталог','','catalog','button','type_link=loadcontent\r\nmenu_center=1\r\ncatalog_topmenu=1\r\nreplaceme=replaceme\r\ncontroller=catalog\r\ndo=enter\r\nimageiconmenu=/admin/img/icons/program/catalog2.png\r\nrating=5\r\ntitle=Каталог','2009-10-21 14:50:12'),
	(99,'Датировать датой. Фильтр','','tdatepref','lkey','type=s\r\nsys=1','2009-10-20 17:27:07'),
	(101,'Подписчики','','subscribeusers','button','type_link=loadcontent\r\n#menu_center=1\r\nreplaceme=replaceme\r\ncontroller=subscribe\r\ndo=list_container&list_table=dtbl_subscribe_users\r\nimageiconmenu=/admin/img/icons/menu/button.users.png\r\nrating=11\r\ntitle=Подписчики','2010-01-14 15:51:20'),
	(102,'Группы подписчиков','','status','button','type_link=loadcontent\r\nmenu_subscribe=1\r\nprogram=/cgi-bin/lists_a.cgi\r\naction=list&list_table=lst_status&menu_button_no=1\r\nimageiconmenu=/admin/img/icons/menu/button.advplace.png\r\nrating=3\r\ntitle=Группы подписчиков\r\nreplaceme=replaceme\r\nreplaceme=listslst_status\r\nid=listslst_status','2010-01-14 15:58:27'),
	(107,'Внешние пользователи','','users','button','type_link=loadcontent\r\nmenu_center=1\r\nusers_topmenu=1\r\nreplaceme=replaceme\r\ncontroller=users\r\naction=enter\r\nimageiconmenu=/admin/img/icons/program/users.gif\r\nrating=10\r\ntitle=Внешние пользователи','2010-03-31 21:25:01'),
	(115,'Вопрос-Ответ','','faq','button','type_link=loadcontent\r\nmenu_center=1\r\nfaq_topmenu=1\r\nreplaceme=replaceme\r\ncontroller=faq\r\ndo=enter\r\nimageiconmenu=/admin/img/icons/program/faq.png\r\nrating=11\r\ntitle=Вопрос-Ответ','2010-07-12 18:46:24'),
	(123,'Ключ функции','','do','lkey','type=slat\r\n','2012-10-11 16:38:24'),
	(119,'Кол-во записей на страницу (доп таблица)','','pcol_doptable','lkey','type=d\r\n','2011-11-05 16:22:01'),
	(120,'Страница (доптаблица)','','page_doptable','lkey','type=d\r\n','2011-11-05 17:55:32'),
	(121,'Алиас','','alias','lkey','type=s\r\nrating=2\r\ntable_list=2\r\ngroup=1\r\nfilter=1\r\nqview=1\r\nqedit=1\r\nrequired=1\r\nhelp=Короткое латинское название, которое учавствует в формирование URL для данной страницы','2012-01-21 18:18:21'),
	(122,'Рассылка','','subscribe','button','type_link=loadcontent\r\n#menu_center=1\r\nreplaceme=replaceme\r\ncontroller=subscribe\r\ndo=enter\r\nimageiconmenu=/admin/img/icons/menu/button.subscribe.png\r\nrating=10\r\ntitle=Рассылка','2012-05-21 21:09:02'),
	(124,'Каталог. Категории','','cataloggroups','button','type_link=loadcontent\r\nmenu_center=1\r\ncatalog_topmenu=1\r\nreplaceme=replaceme\r\ncontroller=catalog\r\ndo=list_container&list_table=data_catalog_categorys\r\nimageiconmenu=/admin/img/icons/program/category.png\r\ntitle=Каталог. Категории\r\nrating=6\r\n','2009-04-16 16:58:36'),
	(125,'Каталог. Бренды','','catalogbrands','button','type_link=loadcontent\r\nmenu_center=1\r\ncatalog_topmenu=1\r\nreplaceme=replaceme\r\ncontroller=catalog\r\ndo=list_container&list_table=data_catalog_brands\r\nimageiconmenu=/admin/img/icons/program/brands.png\r\ntitle=Каталог. Бренды\r\nrating=7\r\n','2009-04-16 16:58:36'),
	(127,'Каталог. Заказы','','catalogorders','button','type_link=loadcontent\nmenu_center=1\ncatalog_topmenu=1\nreplaceme=replaceme\ncontroller=catalog\ndo=enter&list_table=data_catalog_orders\nimageiconmenu=/admin/img/icons/program/order.png\nrating=9\ntitle=Каталог. Заказы','2009-04-16 16:58:36'),
	(128,'Системный журнал','','syslogs','button','type_link=loadcontent\r\nmenu_settings=1\r\nreplaceme=replaceme\r\ncontroller=syslogs\r\naction=enter\r\nimageiconmenu=/admin/img/icons/program/syslogs.png\r\ntitle=Системный журнал\nrating=15\nsettings_topmenu=1\n','2009-02-05 01:59:53'),
	(129,'SEO','','seo','button','type_link=loadcontent\nmenu_settings=1\nreplaceme=replaceme\ncontroller=seo\naction=enter\nimageiconmenu=/admin/img/icons/program/seo.png\ntitle=SEO\nrating=9\nsettings_topmenu=1\n','2013-07-04 21:06:27'),
	(130,'Файлменеджер','','filemanager','button','type_link=loadcontent\r\nmainrazdel_button=1\r\nreplaceme=replaceme\r\ncontroller=filemanager\r\naction=mainpage\r\nimageiconmenu=/admin/img/icons/program/filemanager.png\ntitle=Файлменеджер\r\nrating=99\nfilemanager_topmenu=1\n','2009-02-05 02:00:58'),
	(131,'Дата редактирования','','updated_at','lkey','type=datetime\ntemplate_w=field_input_read\ngroup=1\nrating=199','0000-00-00 00:00:00'),
	(132,'Дата создания','','created_at','lkey','type=datetime\r\ntemplate_w=field_input_read\ngroup=1\nrating=200','2009-02-05 02:01:30'),
	(133,'301 Redirect','','redirects','button','type_link=loadcontent\nmenu_settings=1\nreplaceme=replaceme\ncontroller=redirects\naction=enter\nimageiconmenu=/admin/img/icons/program/redirects.png\ntitle=301 Redirects\nrating=10\nsettings_topmenu=1\n','2013-07-04 21:06:27'),
	(134,'Отзывы','','recall','button','type_link=loadcontent\nmenu_center=1\nrecall_topmenu=1\nreplaceme=replaceme\ncontroller=recall\ndo=enter\nimageiconmenu=/admin/img/icons/program/links.png\nrating=15\ntitle=Отзывы',NULL);

/*!40000 ALTER TABLE `keys_global` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table keys_images
# ------------------------------------------------------------

DROP TABLE IF EXISTS `keys_images`;

CREATE TABLE `keys_images` (
  `ID` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL DEFAULT '',
  `tbl` varchar(64) NOT NULL DEFAULT '',
  `lkey` varchar(64) NOT NULL DEFAULT '',
  `object` varchar(8) NOT NULL DEFAULT '',
  `settings` text NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `tbl` (`tbl`,`lkey`,`object`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Ключи к модулю Изображения';

LOCK TABLES `keys_images` WRITE;
/*!40000 ALTER TABLE `keys_images` DISABLE KEYS */;

INSERT INTO `keys_images` (`ID`, `name`, `tbl`, `lkey`, `object`, `settings`, `updated_at`)
VALUES
	(1,'Добавить запись','','add_link','button','type_link=openpage\nposition=center\nid=newentry\r\ntable_list=1\r\nprint_info=1\r\ntable_list_dir=1\r\ncontroller=images\r\nimageiconmenu=/admin/img/icons/menu/icon_add.png\r\naction=add\r\ntitle=Добавить\r\nrating=1\r\nparams=replaceme','0000-00-00 00:00:00'),
	(2,'Тексты. Добавить папку','','add_link_dir','button','type_link=loadcontent\r\ntable_list_dir=1\r\ncontroller=images\r\nimageiconmenu=/admin/img/icons/menu/icon_dir_add.png\r\naction=add_dir\r\ntitle=Создать папку\r\nparams=replaceme\r\nrating=1','0000-00-00 00:00:00'),
	(5,'Удалить запись','','del_link','button','type_link=loadcontent\r\ncontroller=images\r\naction=delete\r\nconfirm=Действительно удалить запись?\r\ntitle=Удалить запись\r\nimageiconmenu=/admin/img/icons/menu/icon_delete.png\r\nprint_info=1\r\nrating=1\r\nparams=replaceme,index,list_table','0000-00-00 00:00:00'),
	(6,'Редактировать запись','','edit_link','button','type_link=loadcontent\r\nprint_info=1\r\ncontroller=images\r\nimageiconmenu=/admin/img/icons/menu/icon_edit.png\r\naction=edit\r\ntitle=Редактировать запись\r\nrating=2\r\nparams=replaceme,index,list_table','0000-00-00 00:00:00'),
	(7,'Закончить редактирование','','end_link','button','type_link=loadcontent\r\nedit_info=1\r\ncontroller=images\r\nimageiconmenu=/admin/img/icons/menu/icon_ok.png\r\naction=info\r\ntitle=Закончить редактирование\r\nrating=10\r\nparams=replaceme,index,list_table','0000-00-00 00:00:00'),
	(8,'Фильтр','','filter','button','type_link=modullink\r\ntable_list=1\r\ntable_list_dir=1\r\ncontroller=images\r\nimageiconmenu=/admin/img/icons/menu/icon_filter.png\r\naction=filter\r\ntitle=Фильтр\r\nwidth=690\r\nheight=510\r\nlevel=3\r\nrating=4\r\nparams=replaceme','0000-00-00 00:00:00'),
	(9,'Очистка фильтра','','filter_clear','button','type_link=loadcontent\r\ntable_list=1\r\ntable_list_dir=1\r\ncontroller=images\r\nimageiconmenu=/admin/img/icons/menu/icon_nofilter.png\r\naction=filter_clear\r\ntitle=Снять фильтры\r\nrating=5\r\nparams=replaceme','0000-00-00 00:00:00'),
	(11,'Список','','list_link','button','type_link=loadcontent\r\nadd_info=1\r\ncontroller=images\r\nimageiconmenu=/admin/img/icons/menu/button.list.png\r\naction=enter\r\ntitle=Список\r\nrating=1\r\nparams=replaceme','0000-00-00 00:00:00'),
	(15,'Раздел','','razdel','lkey','type=tlist\nlist=lst_images\nnotnull=1','2010-10-27 13:03:54'),
	(16,'Название','','name','lkey','type=s\nfilter=1\ntable_list=1\ngroup=1\nrequired=1\nqview=1\nqedit=1\nrating=1\ndirview=1\nfileview=1\nhelp=Название изображения для дальнейшей его идентификации в базе. На страницах сайта с клиентской стороны не используется.','2010-10-27 13:03:54'),
	(17,'Заголовок (en)','','title_en','lkey','type=s\nrating=5\ngroup=1\nqview=1\nqedit=1\ndirview=1\nfileview=1\ntable_list=3\ntable_list_widht=150\nhelp=Описание изображения для клиентской части. Используется в фотогалерее для подписи изображения\n\n\n','2008-10-20 11:22:12'),
	(18,'Краткое описание','','description','lkey','type=html\r\nrating=11\r\ngroup=2\r\ndirview=1\r\nfileview=1\r\nqview=1','2010-10-19 15:39:29'),
	(19,'Заголовок (ru)','','title_ru','lkey','type=s\r\nrating=4\r\ngroup=1\r\nqview=1\r\nqedit=1\r\nfilter=1\r\ndirview=1\r\nfileview=1\r\ntable_list=2\r\ntable_list_width=150\r\nhelp=Описание изображения для клиентской части. Используется в фотогалерее для подписи изображения\r\n','2010-10-27 13:03:54'),
	(20,'Картинка','','pict','lkey','type=pict\r\nrating=24\r\ntable_list=8\r\ntable_list_name=-\r\ntable_list_type=pict\r\nfolder=/images/gallery/\r\ntable_list_nosort=1\r\nshablon_w=field_pict\r\nshablon_r=field_pict_read\r\nsizelimit=20000\r\nmini=214x124~crop,1000\r\next=*.jpg;*.jpeg;*.tif\r\nfileview=1\ndirview=1\r\nhelp=Загрузите изображение на сервер','2010-10-27 13:03:54'),
	(21,'Папка/файл','','dir','lkey','type=chb\ngroup=1\nrating=6\ntable_list=1\ntable_list_name=-\ntable_list_nosort=1\ntable_list_width=16\nyes=<img src=\"/admin/img/dtree/folder.gif\">\nno=<img src=\"/admin/img/dtree/doc.gif\">\nfilter=1\ntemplate_w=field_checkbox_read\n\n','2010-10-27 13:03:54'),
	(22,'Ключевые слова','','keywords','lkey','type=s\r\nrating=6\r\ngroup=1\r\ndirview=1\r\nfileview=1\r\nhelp=Ключевые слова. Используются в фотогалерее при генерации страницы с данной фотографией или группой фотографий (для папок)\r\n','2010-10-27 13:03:54'),
	(23,'Рейтинг','','rating','lkey','type=d\r\ngroup=1\r\nrating=99\r\ntable_list=10\r\ntable_list_name=Rt\r\ntable_list_width=32\r\nqedit=1\r\ndirview=1\r\nfileview=1\r\nshablon_w=field_rating\r\nhelp=Рейтинг служит для выстраивания фотографий и галерей друг относительно друга. Чем меньше значение, тем выше изображение (галерея) в иерархии','2010-10-27 13:03:54'),
	(24,'Ширина','','width','lkey','type=d\r\ngroup=1\r\nrating=21\r\nshablon_w=field_input_read\r\nhelp=реальная ширина изображения. информация из файла\r\nfileview=1\r\nqview=1\r\n','2010-05-31 16:13:29'),
	(25,'Высота','','height','lkey','type=d\r\ngroup=1\r\nrating=21\r\nshablon_w=field_input_read\r\nhelp=Высота изображения. Информация из файла\r\nfileview=1\r\nqview=1\r\n','2010-05-31 16:13:29'),
	(26,'Размер файла','','size','lkey','type=d\nshablon_w=field_input_read\nrating=20\ngroup=1\nfilter=1\nqview=1\ntable_list=5\ntable_list_name=byte','2010-05-31 16:13:29'),
	(27,'Вложена в папку','','image_gallery','lkey','type=tlist\r\nlist=images_gallery\r\nsort=1\r\nqview=1\r\nrating=7\r\nshablon_w=field_select_dir\r\nshablon_f=field_select_dir_filter\r\nwhere=AND `dir`=1 AND `image_gallery`=0\r\ngroup=1\r\ntable_list=4\r\ntable_list_width=200\r\nfilter=1\r\ndirview=1\r\nfileview=1\r\nhelp=Папка (галерея) для изображения','2010-10-27 13:03:54'),
	(28,'Публикация','','viewimg','lkey','type=chb\r\nrating=101\r\ngroup=1\r\nqedit=1\r\ntable_list=11\ntable_list_name=-\r\ntable_list_width=48\r\nyes=Виден\r\nno=Скрыт\nqview=1\r\nfilter=1\r\ndirview=1\r\nfileview=1\r\nhelp=Данная опция предназначена для отключения отображения картинки в фотогалерее. Если вы используете изображение в тексте, то включение опции на отображение в тексте не влияет.','2010-10-27 13:03:54'),
	(30,'Миниатюрная копия','','mini','lkey','type=list\nlist=mini\ngroup=1\nrating=15\nfileview=1\nhelp=При выборе соответствующего пункта будет создано миниатюрное изображение. Кадрировать - копия горизонтальная в 3:4, происходит вырезка кадра из базового изображения. Пропорционально - уменьшение до системного размера пропорционально. В квадрат - вписывается в квадрат. фон белый.\n','2009-12-21 13:38:54'),
	(31,'Используется','','use','lkey','type=d\r\ngroup=1\r\nrating=55\r\nfileview=1\r\nshablon_w=field_use\r\nshablon_r=field_use_read\r\nhelp=Если указаны документы, то в них используется данное изображение. Чтобы удалить его из базы необходимо вначале убрать изображение из документов. ','2008-10-30 17:10:45'),
	(32,'Флаг удаления картинки','','deletepict','lkey','type=chb\nsys=1','2008-10-30 18:03:51'),
	(33,'Файл','','filename','lkey','type=filename\nrating=2\nsizelimit=20000\nfile_ext=*.*','2010-10-27 13:03:51'),
	(34,'Тип файла','','type_file','lkey','type=slat\r\ngroup=2\r\nrating=21\r\nshablon_w=field_input_read\r\n','2008-10-30 17:10:45'),
	(35,'Флаг скрыть','','hide','lkey','type=s\r\nsys=1','2009-06-04 18:16:14'),
	(36,'Флаг показать','','show','lkey','type=s\r\nsys=1','2010-08-21 19:28:17'),
	(37,'Координата X','','x','lkey','type=d\r\nsys=1','2009-04-09 23:35:06'),
	(38,'Координата Y','','y','lkey','type=d\r\nsys=1','2009-04-09 23:35:06'),
	(39,'Процент','','percent_size','lkey','type=s\r\nsys=1','2009-04-09 23:35:06'),
	(40,'Высота кадрирования','','height_crop','lkey','type=d\r\nsys=1','2009-04-09 23:35:06'),
	(41,'Ширина кадрирования','','width_crop','lkey','type=d\r\nsys=1','2009-04-09 23:35:06'),
	(42,'Загрузка архива','','import','button','type_link=modullink\r\ntable_list=1\r\ntable_list_dir=1\r\ncontroller=images\r\nimageiconmenu=/admin/img/icons/menu/button.zipload.png\r\naction=zipimport\r\ntitle=Загрузка архива\r\nwidth=690\r\nheight=710\r\nlevel=3\r\nrating=2\r\nparams=replaceme','0000-00-00 00:00:00'),
	(43,'Архив','','zip','lkey','type=file\r\nrating=14\r\ntemplate_w=field_file\r\ntemplate_r=field_file_read\r\nsizelimit=20000\r\next=*.zip\r\nfileview=1\r\ntable_list=2\r\nhelp=ZIP архив\r\nsave_msg=Нажмите «Начать загрузку»','2010-08-21 19:26:56'),
	(44,'Flash','','swf','lkey','type=filename\r\nrating=24\r\nshablon_w=field_pict\r\nshablon_r=field_pict_read\r\nsizelimit=20000\r\nfile_ext=*.swf\r\n','2009-04-27 13:16:38'),
	(45,'День','','day','lkey','type=d','0000-00-00 00:00:00'),
	(46,'Месяц','','month','lkey','type=d','0000-00-00 00:00:00'),
	(47,'Год','','year','lkey','type=d','0000-00-00 00:00:00'),
	(52,'Варианты миниатюры','','mini','list','list=|не создавать~1|Кадрировать~2|Пропорционально~3|В квадрат\ntype=radio','0000-00-00 00:00:00'),
	(53,'Ширина (параметр для фильтра)','','widthpref','lkey','type=s\nsys=1','2010-05-31 16:13:29'),
	(54,'Высота (параметр для фильтра)','','heightpref','lkey','type=s\nsys=1','2010-05-31 16:13:29'),
	(55,'Размер (параметр для фильтра)','','sizepref','lkey','type=s\nsys=1','2010-05-31 16:13:29'),
	(56,'Папка','','image_catalog','lkey','type=tlist\r\nlist=images_catalog\r\nsort=1\r\nrating=7\r\nshablon_w=field_select_dir\r\nshablon_f=field_select_dir_filter\r\nwhere=AND `dir`=1 AND `image_catalog`=0\r\ngroup=1\r\nfilter=1\r\ndirview=1\r\nfileview=1\r\nhelp=Папка (галерея) для каталога объектов','2009-06-15 14:17:42'),
	(65,'Датировать датой','','tdate','lkey','type=date\r\nrating=10\r\ngroup=1\r\nqview=1\r\nfilter=1\r\nfileview=1\r\ntable_list=5\r\ntable_list_width=70\r\ntemplate_f=field_date_filter','0000-00-00 00:00:00'),
	(66,'Алиас','','alias','lkey','type=s\r\nrating=5\r\ntable_list=2\r\ngroup=1\r\nfilter=1\r\nqview=1\r\nqedit=1\r\nrequired=1\ndirview=1\nhelp=Короткое латинское название, которое учавствует в формирование URL для данной страницы\n','0000-00-00 00:00:00'),
	(188,'Копировать запись','','copy','button','type_link=loadcontent\nprint_info=1\nedit_info=1\ncontroller=images\naction=copy\nloading_msg=1\nimageiconmenu=/admin/img/icons/menu/icon_copy.png\ntitle=Копировать запись\nrating=5\nparams=replaceme,index,list_table','0000-00-00 00:00:00');

/*!40000 ALTER TABLE `keys_images` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table keys_keys
# ------------------------------------------------------------

DROP TABLE IF EXISTS `keys_keys`;

CREATE TABLE `keys_keys` (
  `ID` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL DEFAULT '',
  `tbl` varchar(64) NOT NULL DEFAULT '',
  `lkey` varchar(64) NOT NULL DEFAULT '',
  `object` varchar(8) NOT NULL DEFAULT '',
  `settings` text NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `tbl` (`tbl`,`lkey`,`object`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Ключи к модулю Object';

LOCK TABLES `keys_keys` WRITE;
/*!40000 ALTER TABLE `keys_keys` DISABLE KEYS */;

INSERT INTO `keys_keys` (`ID`, `name`, `tbl`, `lkey`, `object`, `settings`, `updated_at`)
VALUES
	(4,'Таблица объектов','','config_table','lkey','type=slat\r\nsys=1','2010-09-13 19:48:27'),
	(5,'Таблица','','tbl','lkey','type=slat\nrating=4\ntable_list=4\nfilter=1\nhelp=Каждый ключ уникален для определенной таблицы. Чтобы разделить похожие объекты укажите таблицу, для которой действительны данные параметры ','2010-09-10 21:49:59'),
	(6,'Объект','','object','lkey','type=list\r\nlist=lkey|Ключ~button|Кнопка~pane|Определение вкладки\r\nnotnull=1\r\nlist_type=radio\r\nrating=9\r\nfilter=1\r\ntable_list=2\r\nqview=1\r\nqedit=1\r\nhelp=В системе определено несколько типов объектов. Выберите, какой объект вы создаете\r\n','2010-09-10 21:49:59'),
	(8,'Настройки','','settings','lkey','type=code\r\nrating=10\r\ngroup=1\r\ntemplate_r=field_settings_read\r\ntemplate_w=field_settings\r\nqview=1\r\nhelp=Дополнительные параметры объекта. Каждая строка описывает один параметр. Формат: КЛЮЧ=ЗНАЧЕНИЕ\r\n','2010-09-10 21:49:59'),
	(9,'Наименование','','name','lkey','type=s\nrating=1\nfilter=1\ntable_list=1\nhelp=Название объекта\nrequired=1\nqview=1\nqedit=1\n','2010-09-10 21:49:59'),
	(11,'Ключ','','lkey','lkey','type=slat\nrating=4\ntable_list=3\nrequired=1\nqview=1\nqedit=1\nfilter=1\nhelp=Ключ, по которому можно обратиться к объекту','2010-09-10 21:49:59'),
	(12,'Добавить запись','','add_link','button','type_link=openpage\nposition=center\nid=newentry\r\ntable_list=1\r\nprint_info=1\r\ncontroller=keys\r\naction=add\r\ntitle=Добавить запись\r\nimageiconmenu=/admin/img/icons/menu/icon_add.png\r\nrating=1\r\nparams=list_table,replaceme\r\n','2008-03-15 21:51:53'),
	(13,'Копировать запись','','copy_link','button','type_link=loadcontent\r\ncontroller=keys\r\ndo=copy\r\nimageiconmenu=/admin/img/icons/menu/icon_copy.png\r\ntitle=Копировать объект\r\nrating=3\r\nparams=list_table,replaceme,index\r\n#print_info=1\r\n#edit_info=1\r\n','0000-00-00 00:00:00'),
	(14,'Удалить запись','','delete','button','type_link=loadcontent\r\ncontroller=keys\r\naction=delete\r\nimageiconmenu=/admin/img/icons/menu/icon_delete.png\r\nconfirm=Действительно удалить запись?\r\ntitle=Удалить объект\r\nrating=3\r\nparams=list_table,replaceme,index\r\nprint_info=1\r\n','0000-00-00 00:00:00'),
	(15,'Редактировать запись','','edit_link','button','type_link=loadcontent\r\nprint_info=1\r\ncontroller=keys\r\naction=edit\r\nimageiconmenu=/admin/img/icons/menu/icon_edit.png\r\ntitle=Редактировать запись\r\nrating=2\r\nparams=list_table,replaceme,index','2008-03-17 02:22:20'),
	(16,'Объекты. Фильтр','','filter','button','type_link=modullink\r\ntable_list=1\r\ncontroller=keys\r\naction=filter\r\nimageiconmenu=/admin/img/icons/menu/icon_filter.png\r\ntitle=Настроить фильтр\r\nwidth=690\r\nheight=510\r\nlevel=3\r\nrating=2\r\nparams=list_table,replaceme','2008-03-15 21:51:53'),
	(17,'Объекты. Очистка фильтра','','filter_clear','button','type_link=loadcontent\r\ntable_list=1\r\ncontroller=keys\r\naction=filter_clear\r\ntitle=Снять фильтры\r\nimageiconmenu=/admin/img/icons/menu/icon_nofilter.png\r\nrating=3\r\nparams=list_table,replaceme','2008-03-15 21:51:53'),
	(18,'Список объектов','','list_link','button','type_link=loadcontent\r\nadd_info=1\r\ncontroller=keys\r\nimageiconmenu=/admin/img/icons/menu/button.list.png\r\naction=list\r\ntitle=Список объектов\r\nrating=1\r\nparams=list_table,replaceme','2008-03-15 21:51:53'),
	(19,'Закончить редактирование','','end_link','button','type_link=loadcontent\r\nedit_info=1\r\ncontroller=keys\r\naction=info\r\nimageiconmenu=/admin/img/icons/menu/icon_ok.png\r\ntitle=Закончить редактирование\r\nrating=10\r\nparams=list_table,replaceme,index','2008-03-15 21:51:53'),
	(29,'Объекты','','listtable','button','type_link=loadcontent\r\nadd_object=1\r\ncontroller=keys\r\nimageiconmenu=/admin/img/icons/menu/button.list.png\r\naction=enter\r\ntitle=Объекты\r\nrating=1\r\nparams=replaceme','0000-00-00 00:00:00'),
	(37,'Копировать запись','','copy','button','type_link=loadcontent\nprint_info=1\nedit_info=1\ncontroller=keys\naction=copy\nloading_msg=1\nimageiconmenu=/admin/img/icons/menu/icon_copy.png\ntitle=Копировать запись\nrating=5\nparams=replaceme,index,list_table','0000-00-00 00:00:00');

/*!40000 ALTER TABLE `keys_keys` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table keys_lists
# ------------------------------------------------------------

DROP TABLE IF EXISTS `keys_lists`;

CREATE TABLE `keys_lists` (
  `ID` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL DEFAULT '',
  `tbl` varchar(64) NOT NULL DEFAULT '',
  `lkey` varchar(64) NOT NULL DEFAULT '',
  `object` varchar(8) NOT NULL DEFAULT '',
  `settings` text NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `tbl` (`tbl`,`lkey`,`object`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Ключи к модулю Lists';

LOCK TABLES `keys_lists` WRITE;
/*!40000 ALTER TABLE `keys_lists` DISABLE KEYS */;

INSERT INTO `keys_lists` (`ID`, `name`, `tbl`, `lkey`, `object`, `settings`, `updated_at`)
VALUES
	(44,'Закончить редактирование','','end_link','button','type_link=loadcontent\r\nedit_info=1\r\ncontroller=lists\r\naction=info\r\nimageiconmenu=/admin/img/icons/menu/icon_ok.png\r\ntitle=Закончить редактирование\r\nrating=10\r\nparams=list_table,replaceme,index','0000-00-00 00:00:00'),
	(10,'Название','','name','lkey','type=s\r\nrating=1\r\nrequired=1\r\nqview=1\r\nqedit=1\r\ntable_list=2\r\n','2010-10-04 16:44:07'),
	(11,'Таблица-справочник','','list_table','lkey','type=s\nsys=1','2010-10-27 14:06:24'),
	(12,'Страна','','id_countries','lkey','type=tlist\nlist=lst_countries\nrating=2\nfilter=1\nqview=1\nshablon_w=field_select_input\nshablon_f=field_select_input_filter\nrules=id_region:lst_region.id_countries=index\nadd_to_list=1\nwidth=450\nheight=250','2008-07-16 18:35:18'),
	(13,'Регион','','id_region','lkey','type=tlist\nlist=lst_region\nrating=3\nfilter=1\nqview=1\nshablon_w=field_select_input\nshablon_f=field_select_input_filter\nrules=id_countries:lst_region.index=id_countries','2008-07-16 18:35:17'),
	(15,'Список справочников','','list_link','button','type_link=loadcontent\r\nadd_info=1\r\ncontroller=lists\r\nimageiconmenu=/admin/img/icons/menu/button.list.png\r\naction=list\r\ntitle=Список справочников\r\nrating=1\r\nparams=list_table,replaceme','0000-00-00 00:00:00'),
	(16,'Справочники. Очистка фильтра','','filter_clear','button','type_link=loadcontent\r\ntable_list=1\r\ncontroller=lists\r\nimageiconmenu=/admin/img/icons/menu/icon_nofilter.png\r\naction=filter_clear\r\ntitle=Снять фильтры\r\nrating=3\r\nparams=list_table,replaceme','0000-00-00 00:00:00'),
	(17,'Справочники. Фильтр','','filter','button','type_link=modullink\r\ntable_list=1\r\ncontroller=lists\r\naction=filter\r\nimageiconmenu=/admin/img/icons/menu/icon_filter.png\r\ntitle=Настроить фильтр\r\nwidth=690\r\nheight=510\r\nlevel=3\r\nrating=2\r\nparams=list_table,replaceme','0000-00-00 00:00:00'),
	(18,'Добавить запись','','add_link','button','type_link=openpage\nposition=center\nid=newentry\r\ntable_list=1\r\nprint_info=1\r\ncontroller=lists\r\nimageiconmenu=/admin/img/icons/menu/icon_add.png\r\naction=add\r\ntitle=Добавить запись\r\nrating=1\r\nparams=list_table,replaceme','0000-00-00 00:00:00'),
	(20,'Город','','id_city','lkey','type=tlist\r\nlist=lst_citys\r\nrating=3\r\nfilter=1\r\ngroup=1\r\nqview=1\r\nrequired=1\r\n','2010-05-24 15:51:53'),
	(22,'Населенный пункт','','id_vilage','lkey','type=tlist\nlist=lst_vilage\nrating=34\nfilter=1\ngroup=2\nkey_program=lists\nshablon_w=field_select_input\nshablon_f=field_select_input_filter\nrules=id_city:lst_vilage.index=id_city','2008-07-16 18:35:19'),
	(23,'Справочники','','lists','menu','type_link=loadcontent\r\naction=enter\r\nprogram=/cgi-bin/lists_a.cgi\r\nrating=21\r\nparentid=setting\r\nreplaceme=replaceme\r\nsubmenuwidth=200','0000-00-00 00:00:00'),
	(25,'Ключ раздела','','key_razdel','lkey','type=s\r\nrating=2\r\nrequired=1','2009-11-19 17:03:46'),
	(26,'Группа пользователей','','id_group_user','lkey','type=tlist\r\nlist=lst_group_user\r\nrating=5\r\nqview=1\r\nmult=7\r\nshablon_w=field_multselect','2008-09-16 23:35:30'),
	(27,'Пользователь','','users','lkey','type=tlist\r\nlist=sys_users\r\nrating=10\r\nqview=1\r\nmult=7\r\nshablon_w=field_multselect','2008-09-16 23:35:30'),
	(28,'Список ключей для редактирования','','listf','lkey','type=s\r\nrating=3','2008-09-16 23:35:30'),
	(32,'Ширина','lst_advert_block','width','lkey','type=d\ngroup=1\nrating=15\ntable_list_name=W\ntable_list_width=32\nqview=1\nqedit=1','2009-08-25 18:46:00'),
	(33,'Высота','lst_advert_block','height','lkey','type=d\ngroup=1\nrating=16\ntable_list_name=H\ntable_list_width=32\nqview=1\nqedit=1','2009-08-25 18:46:00'),
	(34,'Цена за клик','','per_click','lkey','type=d\r\nfileview=1\r\ntable_list=4\r\ntable_list_name=$/click\r\ntable_list_width=100\r\nrating=10\r\ngroup=1\r\nqview=1\r\nqedit=1\r\n','2009-08-25 18:46:00'),
	(35,'Цена за показ','','per_show','lkey','type=d\r\nrating=11\r\ngroup=1\r\nqview=1\r\nqedit=1\r\nfileview=1\r\ntable_list=5\r\ntable_list_width=100\r\ntable_list_name=$/показ','2009-08-25 18:46:00'),
	(45,'Пароль','lst_advert_users','password','lkey','type=password\nrequired=1\nrating=3','2009-04-16 15:56:33'),
	(46,'E-mail','lst_advert_users','email','lkey','type=email\nrating=5','2009-04-16 15:56:33'),
	(47,'Логин','lst_advert_users','login','lkey','type=slat\nrequired=1\nrating=2','2009-04-16 15:56:33'),
	(48,'Фото 1','','foto1','lkey','type=tlist\r\nlist=images_fond\r\nrating=20\r\ngroup=1\r\nkey_program=lists\r\nshablon_w=field_select_input\r\nshablon_f=field_select_input_filter\r\nhelp=Введите несколько символов фото из базы изображений и потом выберите его из списка\r\nwhere= `dir`=0','0000-00-00 00:00:00'),
	(49,'Фото 2','','foto2','lkey','type=tlist\r\nlist=images_fond\r\nrating=21\r\ngroup=1\r\nkey_program=lists\r\nshablon_w=field_select_input\r\nshablon_f=field_select_input_filter\r\nhelp=Введите несколько символов фото из базы изображений и потом выберите его из списка\r\nwhere= `dir`=0','0000-00-00 00:00:00'),
	(50,'Фото 3','','foto3','lkey','type=tlist\r\nlist=images_fond\r\nrating=22\r\ngroup=1\r\nkey_program=lists\r\nshablon_w=field_select_input\r\nshablon_f=field_select_input_filter\r\nhelp=Введите несколько символов фото из базы изображений и потом выберите его из списка\r\nwhere= `dir`=0','0000-00-00 00:00:00'),
	(51,'Фотографии','','id_images','lkey','type=tlist\r\nlist=images_projects\r\nsort=1\r\nrating=10\r\ngroup=1\r\nwhere= AND `image_projects`=\'0\' AND `dir`=1\r\nfilter=1\r\nshablon_w=field_select_input\r\nshablon_f=field_select_input_filter','0000-00-00 00:00:00'),
	(52,'Текст','','text','lkey','type=html\r\ngroup=1\r\nrating=4\r\nshablon=field_html_full\r\nfileview=1\r\n','2009-12-17 12:07:25'),
	(53,'Фотографии','','id_equipimg','lkey','type=tlist\r\nlist=images_equipment\r\nsort=1\r\nrating=8\r\ngroup=1\r\nwhere= AND `image_equipment`=\'0\' AND `dir`=1\r\nfilter=1\r\nshablon_w=field_select_input\r\nshablon_f=field_select_input_filter','0000-00-00 00:00:00'),
	(54,'Проект','','id_project','lkey','type=tlist\r\nlist=texts_projects_ru\r\nsort=1\r\nrating=10\r\ngroup=1\r\nfilter=1\r\nshablon_w=field_select_input\r\nshablon_f=field_select_input_filter','0000-00-00 00:00:00'),
	(55,'Прикрепить отзыв','','id_recall','lkey','type=tlist\r\nlist=data_recall\r\nsort=1\r\nrating=40\r\ngroup=1\r\nfilter=1\r\nshablon_w=field_select_input\r\nshablon_f=field_select_input_filter\r\n','0000-00-00 00:00:00'),
	(56,'Рубрика','','id_docfiles_rubrics','lkey','type=tlist\r\nlist=lst_docfiles_rubrics\r\nsort=1\r\nrating=3\r\ngroup=1\r\nfilter=1\r\nshablon_w=field_select_input\r\nshablon_f=field_select_input_filter\r\nhelp=Выберите тематическую рубрику\r\nfileview=1\r\nadd_to_list=1\r\nwidth=400\r\nheight=250\r\nrules_all=1\r\n','0000-00-00 00:00:00'),
	(57,'Подрубрика','','id_docfiles_subrubrics','lkey','type=tlist\r\nlist=lst_docfiles_rubrics\r\nsort=1\r\nrating=9\r\ngroup=1\r\nfilter=1\r\nshablon_w=field_select_input\r\nshablon_f=field_select_input_filter\r\nrules=id_docfiles_rubrics:lst_docfiles_rubrics.ID=tmp|texts_docfiles:texts_docfiles_ru.id_docfiles_subrubrics=index\r\nrules_where= AND `dir`=\'1\'\r\nwhere= AND `id_rubrics`>\'0\'\r\nhelp=Выберите тематическую подрубрику\r\nfileview=1\r\nadd_to_list=1\r\nwidth=400\r\nheight=250\r\nrules_all=1\r\n','0000-00-00 00:00:00'),
	(58,'Родительская рубрика','','id_rubrics','lkey','type=tlist\r\nlist=lst_docfiles_rubrics\r\nsort=1\r\nrating=2\r\nprint=1\r\nfileview=1\r\nwhere= AND `id_rubrics`=\'0\'\r\n','2010-01-15 12:14:22'),
	(59,'Рейтинг','','rating','lkey','type=d\r\ngroup=1\r\nqview=1\r\nqedit=1\r\ntable_list=6\r\ntable_list_name=Rt\r\ntable_list_width=32\r\nrating=99\r\ntemplate_w=field_rating','2010-09-30 14:33:40'),
	(60,'Отображать на сайте','','active','lkey','type=chb\r\nprint=1\r\nrating=99\r\nfileview=1\r\nfilter=1\r\ntable_list=10\r\ntable_list_width=48\ntable_list_name=-\r\nyes=Виден\r\nno=Скрыт\n\r\n','2010-10-04 16:44:07'),
	(71,'Верхняя цена диапозона','','max','lkey','type=d\r\nprint=1\r\nqview=1\r\nrating=4\r\nqedit=1\r\nshablon_w=field_rating\r\n','2010-05-27 14:47:05'),
	(63,'Флаг получения инф.','','get','lkey','type=d\r\nsys=1','0000-00-00 00:00:00'),
	(70,'Нижняя цена диапозона','','min','lkey','type=d\r\nprint=1\r\nqview=1\r\nrating=3\r\nqedit=1\r\nshablon_w=field_rating\r\n','2010-05-27 14:47:05'),
	(72,'CSS class списка','','ulclass','lkey','type=s\r\nprint=1\r\nrating=30\r\n','0000-00-00 00:00:00'),
	(73,'CSS class контейнера','','divclass','lkey','type=s\r\nsys=1\r\n','0000-00-00 00:00:00'),
	(74,'Вес','','weight','lkey','type=d\r\nprint=1\r\nqview=1\r\ntable_list=3\r\ntable_list_width=70\r\nfilter=1\r\nshablon_w=field_rating\r\nrating=4\r\n\r\n','2010-10-04 16:44:07'),
	(75,'Ссылка','','link','lkey','type=s\r\nprint=1\r\nqview=1\r\nrating=3\r\ntable_list=2\r\ntable_list_width=100\r\n','2010-10-04 16:44:07'),
	(76,'Материал ID','','material_id','lkey','type=s\r\nprint=1\r\nsys=1\r\n\r\n','0000-00-00 00:00:00'),
	(77,'Рост, см','lst_catalog_sizes','name','lkey','type=d\r\nrating=1\r\nrequired=1\r\nqview=1\r\nqedit=1\r\ntable_list=2\r\n','0000-00-00 00:00:00'),
	(78,'Возраст','','age','lkey','type=s\r\nrating=3\r\nqview=1\r\nqedit=1\r\ntable_list=3\r\n','0000-00-00 00:00:00'),
	(79,'Короткий код','','code','lkey','type=s\r\nrating=5\r\nrequired=1\r\nqview=1\r\nqedit=1\r\ntable_list=3\r\n','0000-00-00 00:00:00'),
	(80,'Редактировать запись','','edit_link','button','type_link=loadcontent\r\nprint_info=1\r\ncontroller=lists\r\naction=edit\r\nimageiconmenu=/admin/img/icons/menu/icon_edit.png\r\ntitle=Редактировать запись\r\nrating=2\r\nparams=replaceme,index,list_table','0000-00-00 00:00:00'),
	(81,'Название шаблона','','layout','lkey','type=s\r\nprint=1\r\nqview=1\r\nrating=10\r\ntable_list=3\r\ntable_list_width=100\r\nsys=1\r\n\r\n','0000-00-00 00:00:00'),
	(82,'Копировать запись','','copy','button','type_link=loadcontent\nprint_info=1\nedit_info=1\ncontroller=lists\naction=copy\nloading_msg=1\nimageiconmenu=/admin/img/icons/menu/icon_copy.png\ntitle=Копировать запись\nrating=5\nparams=replaceme,index,list_table','0000-00-00 00:00:00');

/*!40000 ALTER TABLE `keys_lists` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table keys_mainconfig
# ------------------------------------------------------------

DROP TABLE IF EXISTS `keys_mainconfig`;

CREATE TABLE `keys_mainconfig` (
  `ID` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL DEFAULT '',
  `tbl` varchar(64) NOT NULL DEFAULT '',
  `lkey` varchar(64) NOT NULL DEFAULT '',
  `object` varchar(8) NOT NULL DEFAULT '',
  `settings` text NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `tbl` (`tbl`,`lkey`,`object`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Ключи к модулю MainConfig';

LOCK TABLES `keys_mainconfig` WRITE;
/*!40000 ALTER TABLE `keys_mainconfig` DISABLE KEYS */;

INSERT INTO `keys_mainconfig` (`ID`, `name`, `tbl`, `lkey`, `object`, `settings`, `updated_at`)
VALUES
	(10,'Строка запроса','','qstring','lkey','type=s\nsys=1','0000-00-00 00:00:00'),
	(6,' Выход','','exit','menu','type_link=javascript\nfunction=loadfile(\"/cgi-bin/auth.cgi?action=logout\");\n#type_link=openurl\ntitle=Выход\nimageiconmenu=/admin/img/icons/menu/icon_exit_min.gif\nurl=/cgi-bin/auth.cgi?action=logout\nrating=25\nparentid=file','2008-03-09 15:23:23'),
	(8,'Лог ключей','','keys_log','menu','type_link=openpage\naction=keys_log\nprogram=/cgi-bin/admin.cgi\ntitle=Лог ключей\ntabtitle=Лог ключей\nrating=5\nparentid=instrument\nposition=east\nid=keys_log','2008-03-09 15:23:23'),
	(9,'Лог ошибок mysql','','log_mysql','menu','type_link=openpage\naction=log_mysql\nprogram=/cgi-bin/admin.cgi\ntitle=Лог ошибок MySQL\ntabtitle=log_mysql\nrating=6\nparentid=instrument\nposition=east\nid=log_mysql','2008-03-09 15:23:23'),
	(12,'Инструменты','','instrument','menu','type_link=nothing\r\ntitle=Инструменты\r\nrating=5\r\nsubmenuwidth=200','0000-00-00 00:00:00'),
	(13,'Настройки','','setting','menu','type_link=nothing\ntitle=Настройки\nrating=15\nsubmenuwidth=200\n','0000-00-00 00:00:00'),
	(14,'Правка','','edit','menu','type_link=nothing\ntitle=Правка\nrating=2\nsubmenuwidth=200\n','0000-00-00 00:00:00'),
	(15,'Справка','','help','menu','type_link=openurl\ntitle=Справка\nurl=http://office/admin\nrating=25','0000-00-00 00:00:00'),
	(16,'Файл','','file','menu','type_link=nothing\ntitle=Файл\nrating=1\nsubmenuwidth=200\n','0000-00-00 00:00:00');

/*!40000 ALTER TABLE `keys_mainconfig` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table keys_recall
# ------------------------------------------------------------

DROP TABLE IF EXISTS `keys_recall`;

CREATE TABLE `keys_recall` (
  `ID` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL DEFAULT '',
  `tbl` varchar(64) NOT NULL DEFAULT '',
  `lkey` varchar(64) NOT NULL DEFAULT '',
  `object` varchar(8) NOT NULL DEFAULT '',
  `settings` text NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `tbl` (`tbl`,`lkey`,`object`)
) ENGINE=MyISAM DEFAULT CHARSET=cp1251 COMMENT='Ключи к модулю Отзывы';

LOCK TABLES `keys_recall` WRITE;
/*!40000 ALTER TABLE `keys_recall` DISABLE KEYS */;

INSERT INTO `keys_recall` (`ID`, `name`, `tbl`, `lkey`, `object`, `settings`, `updated_at`)
VALUES
	(62,'Добавить запись','','add_link','button','type_link=openpage\nposition=center\nid=newentry\r\ntable_list=1\r\nprint_info=1\r\ncontroller=recall\r\naction=add\r\nimageiconmenu=/admin/img/icons/menu/icon_add.png\r\ntitle=Добавить\r\nrating=1\r\nparams=replaceme','0000-00-00 00:00:00'),
	(61,'Удалить запись','','del_link','button','type_link=loadcontent\r\ncontroller=recall\r\naction=delete\r\nimageiconmenu=/admin/img/icons/menu/icon_delete.png\r\nconfirm=Действительно удалить запись?\r\ntitle=Удалить запись\r\nprint_info=1\r\nrating=1\r\nparams=replaceme,index','0000-00-00 00:00:00'),
	(60,'Редактировать запись','','edit_link','button','type_link=loadcontent\r\nprint_info=1\r\ncontroller=recall\r\naction=edit\r\nimageiconmenu=/admin/img/icons/menu/icon_edit.png\r\ntitle=Редактировать запись\r\nrating=2\r\nparams=replaceme,index','0000-00-00 00:00:00'),
	(59,'Закончить редактирование','','end_link','button','type_link=loadcontent\r\nedit_info=1\r\ncontroller=recall\r\naction=info\r\nimageiconmenu=/admin/img/icons/menu/icon_ok.png\r\ntitle=Закончить редактирование\r\nrating=10\r\nparams=replaceme,index\r\n','0000-00-00 00:00:00'),
	(58,'Фильтр','','filter','button','type_link=modullink\r\ntable_list=1\r\ncontroller=recall\r\naction=filter\r\nimageiconmenu=/admin/img/icons/menu/icon_filter.png\r\ntitle=Фильтр\r\nwidth=690\r\nheight=510\r\nlevel=3\r\nrating=2\r\nparams=replaceme','0000-00-00 00:00:00'),
	(57,'Очистка фильтра','','filter_clear','button','type_link=loadcontent\r\ntable_list=1\r\nprogram=/cgi-bin/recall_a.cgi\r\nimageiconmenu=/admin/img/icons/menu/icon_nofilter.png\r\naction=filter_clear\r\ntitle=Снять фильтры\r\nrating=3\r\nparams=replaceme','0000-00-00 00:00:00'),
	(56,'Список','','list_link','button','type_link=loadcontent\r\nadd_info=1\r\ncontroller=recall\r\naction=enter\r\nimageiconmenu=/admin/img/icons/menu/button.list.png\r\ntitle=Список\r\nrating=1\r\nparams=replaceme','0000-00-00 00:00:00'),
	(44,'Дата вопроса','','quest_date','lkey','type=time\r\nrating=5\r\ntable_list=6\r\ntable_list_name=Дата\r\nshablon_w=field_time_exp\r\ngroup=1\r\nfileview=1\r\ndirview=1','0000-00-00 00:00:00'),
	(18,'Ключевые слова','','keywords','lkey','type=s\r\nrating=10\r\ngroup=1\r\nfilter=1\r\n','2008-10-30 17:15:04'),
	(20,'Публиковать','','active','lkey','type=chb\r\nrating=99\r\ntable_list=5\r\ntable_list_name=-\ntable_list_width=48\nyes=Виден\r\nno=Скрыт\ngroup=1\r\nfilter=1\r\nfileview=1\r\ndirview=1','2011-04-04 15:00:44'),
	(22,'Датировать датой','','tdate','lkey','type=date\nrating=10\ngroup=1\nqview=1\nfilter=1\nfileview=1\ntable_list=8\ntable_list_width=70\ntemplate_f=field_date_filter\nhelp=Укажите какой датой датировать эту запись','2015-04-03 18:15:57'),
	(34,'Флаг показать','','show','lkey','type=s\nsys=1','2011-04-04 15:52:08'),
	(35,'Флаг скрыть','','hide','lkey','type=s\nsys=1','2011-04-04 15:52:05'),
	(36,'День','','day','lkey','type=d','0000-00-00 00:00:00'),
	(37,'Месяц','','month','lkey','type=d','0000-00-00 00:00:00'),
	(38,'Год','','year','lkey','type=d','0000-00-00 00:00:00'),
	(39,'Отзыв','','recall','lkey','type=text\ntable_list=3\nfilter=1\ngroup=1\nrating=5\nno_format=1\nrequired=1\nqview=1\neditform=1\nsaveform=1\nobligatory=1','2015-04-03 18:13:22'),
	(41,'Имя автора','','name','lkey','type=s\ngroup=1\nrating=1\nqview=1\nqedit=1\ntable_list=1\neditform=1\nsaveform=1\nobligatory=1\nobligatory_rules=validate[required]\ncktoolbar=Basic','2015-04-03 17:06:58'),
	(42,'Ответ','','answer','lkey','type=html\ngroup=1\nrating=8\nrating=90\ncktoolbar=Basic','2015-04-03 17:04:28'),
	(48,'Поле подтверждения по картинке','regform','number','lkey','type=d\r\nrating=90\r\ngroup=1\r\nobligatory=1\r\n#regform=1\r\n#editform=1\r\nshablon_reg=field_imgconfirm','0000-00-00 00:00:00'),
	(49,'Код на картинке','','code','lkey','type=d\r\nsys=1','0000-00-00 00:00:00'),
	(71,'Автор ответа','','answer_name','lkey','type=s\nfilter=1\ngroup=1\nrating=7\nno_format=1\nqview=1','2015-04-03 17:04:16'),
	(76,'E-mail','','email','lkey','type=s\ntable_list=2\nfilter=1\ngroup=1\nrating=4\nno_format=1\nrequired=1\nqview=1\neditform=1\nsaveform=1\nobligatory=1','2015-04-03 17:06:01'),
	(77,'Тема вопроса','','quest_anons','lkey','type=s\r\nprint=1\r\nqview=1\r\nrating=5\r\nqview=1\r\ntable_list=5\r\ntable_list_width=100\r\nrequired=1\r\nnext_td=1\r\n\r\n\r\n','2011-04-04 15:00:44'),
	(80,'Телефон','','phone','lkey','type=s\r\ntable_list=1\r\nfilter=1\r\ngroup=1\r\nrating=3\r\nno_format=1\r\nqview=1\r\nsaveform=1\r\n','0000-00-00 00:00:00'),
	(81,'Копировать запись','','copy','button','type_link=loadcontent\nprint_info=1\nedit_info=1\ncontroller=recall\naction=copy\nloading_msg=1\nimageiconmenu=/admin/img/icons/menu/icon_copy.png\ntitle=Копировать запись\nrating=5\nparams=replaceme,index,list_table','0000-00-00 00:00:00');

/*!40000 ALTER TABLE `keys_recall` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table keys_redirects
# ------------------------------------------------------------

DROP TABLE IF EXISTS `keys_redirects`;

CREATE TABLE `keys_redirects` (
  `ID` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL DEFAULT '',
  `tbl` varchar(64) NOT NULL DEFAULT '',
  `lkey` varchar(64) NOT NULL DEFAULT '',
  `object` varchar(8) NOT NULL DEFAULT '',
  `settings` text NOT NULL,
  `edate` datetime DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `tbl` (`tbl`,`lkey`,`object`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Ключи к модулю Тексты';

LOCK TABLES `keys_redirects` WRITE;
/*!40000 ALTER TABLE `keys_redirects` DISABLE KEYS */;

INSERT INTO `keys_redirects` (`ID`, `name`, `tbl`, `lkey`, `object`, `settings`, `edate`)
VALUES
	(1,'Добавить запись','','add_link','button','type_link=loadcontent\ntable_list=1\nprint_info=1\ncontroller=redirects\naction=add\nimageiconmenu=/admin/img/icons/menu/icon_add.png\ntitle=Добавить\nrating=1\nparams=replaceme,list_table','2014-06-30 18:32:10'),
	(2,'Удалить запись','','del_link','button','type_link=loadcontent\ncontroller=redirects\naction=delete\nconfirm=Действительно удалить запись?\ntitle=Удалить запись\nimageiconmenu=/admin/img/icons/menu/icon_delete.png\nprint_info=1\nrating=1\nparams=replaceme,index,list_table','2014-06-30 18:32:20'),
	(3,'Редактировать запись','','edit_link','button','type_link=loadcontent\nprint_info=1\ncontroller=redirects\naction=edit\nimageiconmenu=/admin/img/icons/menu/icon_edit.png\ntitle=Редактировать запись\nrating=2\nparams=replaceme,index,list_table','2014-06-30 18:32:28'),
	(4,'Закончить редактирование','','end_link','button','type_link=loadcontent\nedit_info=1\ncontroller=redirects\naction=info\nimageiconmenu=/admin/img/icons/menu/icon_ok.png\ntitle=Закончить редактирование\nrating=1\nparams=replaceme,index,list_table','2014-06-30 18:32:36'),
	(5,'Фильтр','','filter','button','type_link=modullink\ntable_list=1\ntable_list_orders=1\ncontroller=redirects\naction=filter\nimageiconmenu=/admin/img/icons/menu/icon_filter.png\ntitle=Фильтр\nwidth=690\nheight=510\nlevel=3\nrating=2\nparams=replaceme,list_table','2014-06-30 18:32:43'),
	(6,'Очистка фильтра','','filter_clear','button','type_link=loadcontent\ntable_list=1\ntable_list_orders=1\ntable_list_dir=1\ncontroller=redirects\naction=filter_clear\nimageiconmenu=/admin/img/icons/menu/icon_nofilter.png\ntitle=Снять фильтры\nrating=3\nparams=replaceme,list_table','2014-06-30 18:32:51'),
	(39,'Исходная ссылка','','source_url','lkey','type=site\ngroup=1\nqview=1\nqedit=1\ntable_list=3\nrequired=1\nrating=3\n','2014-06-30 19:10:18'),
	(49,'Ссылка назначения','','last_url','lkey','type=site\ngroup=1\nqview=1\nqedit=1\ntable_list=4\nrequired=1\ntable_list_width=500\nrating=4','2014-06-30 19:10:26');

/*!40000 ALTER TABLE `keys_redirects` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table keys_seo
# ------------------------------------------------------------

DROP TABLE IF EXISTS `keys_seo`;

CREATE TABLE `keys_seo` (
  `ID` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL DEFAULT '',
  `tbl` varchar(64) NOT NULL DEFAULT '',
  `lkey` varchar(64) NOT NULL DEFAULT '',
  `object` varchar(8) NOT NULL DEFAULT '',
  `settings` text NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `tbl` (`tbl`,`lkey`,`object`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Ключи к модулю Тексты';

LOCK TABLES `keys_seo` WRITE;
/*!40000 ALTER TABLE `keys_seo` DISABLE KEYS */;

INSERT INTO `keys_seo` (`ID`, `name`, `tbl`, `lkey`, `object`, `settings`, `updated_at`)
VALUES
	(1,'Добавить запись','','add_link','button','type_link=openpage\nposition=center\nid=newentry\r\ntable_list=1\r\nprint_info=1\r\ncontroller=seo\r\naction=add\r\nimageiconmenu=/admin/img/icons/menu/icon_add.png\r\ntitle=Добавить\r\nrating=1\r\nparams=replaceme,list_table','0000-00-00 00:00:00'),
	(2,'Удалить запись','','del_link','button','type_link=loadcontent\r\ncontroller=seo\r\naction=delete\r\nconfirm=Действительно удалить запись?\r\ntitle=Удалить запись\r\nimageiconmenu=/admin/img/icons/menu/icon_delete.png\r\nprint_info=1\r\nrating=1\r\nparams=replaceme,index,list_table','0000-00-00 00:00:00'),
	(3,'Редактировать запись','','edit_link','button','type_link=loadcontent\r\nprint_info=1\r\ncontroller=seo\r\naction=edit\r\nimageiconmenu=/admin/img/icons/menu/icon_edit.png\r\ntitle=Редактировать запись\r\nrating=2\r\nparams=replaceme,index,list_table','0000-00-00 00:00:00'),
	(4,'Закончить редактирование','','end_link','button','type_link=loadcontent\r\nedit_info=1\r\ncontroller=seo\r\naction=info\r\nimageiconmenu=/admin/img/icons/menu/icon_ok.png\r\ntitle=Закончить редактирование\r\nrating=10\r\nparams=replaceme,index,list_table\r\n','0000-00-00 00:00:00'),
	(5,'Фильтр','','filter','button','type_link=modullink\r\ntable_list=1\r\ntable_list_orders=1\r\ncontroller=seo\r\naction=filter\r\nimageiconmenu=/admin/img/icons/menu/icon_filter.png\r\ntitle=Фильтр\r\nwidth=690\r\nheight=510\r\nlevel=3\r\nrating=2\r\nparams=replaceme,list_table','0000-00-00 00:00:00'),
	(6,'Очистка фильтра','','filter_clear','button','type_link=loadcontent\r\ntable_list=1\r\ntable_list_orders=1\r\ntable_list_dir=1\r\ncontroller=seo\r\naction=filter_clear\r\nimageiconmenu=/admin/img/icons/menu/icon_nofilter.png\r\ntitle=Снять фильтры\r\nrating=3\r\nparams=replaceme,list_table','0000-00-00 00:00:00'),
	(7,'Заголовок (title)','','name','lkey','type=s\r\nfilter=1\r\ngroup=1\r\nrating=1\r\nrequired=1\r\nqedit=1\r\ntable_list=1\r\nno_format=1\r\nfileview=1\r\nhelp=Заголовок окна браузера. Может отличаться от названия текста. Используется для оптимизации под поисковые ','2010-10-31 11:29:29'),
	(39,'Ссылка','','url','lkey','type=site\r\ngroup=1\r\nqview=1\r\nqedit=1\r\ntable_list=3\r\ntable_list_width=200\r\nrating=3\r\n','0000-00-00 00:00:00'),
	(38,'Ключевые слова (keywords)','','keywords','lkey','type=s\r\nprint=1\r\ngroup=1\r\nrating=10\nqview=1\nqedit=1\nhelp=Ключевые слова и выражения, разделенные запятой, которые соответствуют данному тексту. Используется для оптимизации страницы под поисковые системы. Указанные слова в данном поле должны обязательно присутствовать в тексте — в противном случае они не будут учитываться поисковыми машинами.\n\r\n','0000-00-00 00:00:00'),
	(48,'Краткое описание страницы (description)','','description','lkey','type=text\r\nprint=1\r\ngroup=1\r\nrating=11\nqview=1\nqedit=1\nhelp=Краткое описание текста. Используется для поисковых систем. Выводится на странице в meta-теге description. Как правило, пользователь данный текст не видет. Для поисковых систем полезнее для каждой страницы формировать свое описание, наиболее соответствующее данной странице.\n\r\n','0000-00-00 00:00:00'),
	(49,'Копировать запись','','copy','button','type_link=loadcontent\nprint_info=1\nedit_info=1\ncontroller=seo\naction=copy\nloading_msg=1\nimageiconmenu=/admin/img/icons/menu/icon_copy.png\ntitle=Копировать запись\nrating=5\nparams=replaceme,index,list_table','0000-00-00 00:00:00'),
	(50,'SEO заголовок','','seo_title','lkey','type=s\nrating=5\ngroup=1\nqview=1\nqedit=1\nfilter=1\ntable_list=0\ntable_list_width=0\nfileview=1\nrequired=0','2015-04-17 17:29:41'),
	(51,'SEO текст','','seo_text','lkey','type=html\nrating=6\ngroup=1\nqview=1\nqedit=1\nfilter=1\ntable_list=0\ntable_list_width=0\nfileview=1\nrequired=0','2015-04-17 17:29:48');

/*!40000 ALTER TABLE `keys_seo` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table keys_styles
# ------------------------------------------------------------

DROP TABLE IF EXISTS `keys_styles`;

CREATE TABLE `keys_styles` (
  `ID` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL DEFAULT '',
  `tbl` varchar(64) NOT NULL DEFAULT '',
  `lkey` varchar(64) NOT NULL DEFAULT '',
  `object` varchar(8) NOT NULL DEFAULT '',
  `settings` text NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `tbl` (`tbl`,`lkey`,`object`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Ключи к модулю Object';

LOCK TABLES `keys_styles` WRITE;
/*!40000 ALTER TABLE `keys_styles` DISABLE KEYS */;

INSERT INTO `keys_styles` (`ID`, `name`, `tbl`, `lkey`, `object`, `settings`, `updated_at`)
VALUES
	(7,'Код','','code','lkey','type=code\r\nrating=4\r\nshablon_w=field_css\r\nshablon_r=field_code_read\r\n','2010-10-27 14:12:45'),
	(15,'Папка','','dir','lkey','type=s\r\nrating=2\r\nhelp=Путь к файлу\r\nrequired=1\r\ntemplate_w=field_input_read\r\nqview=1\r\nqedit=1\r\n','0000-00-00 00:00:00'),
	(16,'Файл','','name','lkey','type=s\r\nrating=1\r\nfilter=1\r\ntable_list=1\r\nhelp=Название шаблона\r\nrequired=1\r\ntemplate_w=field_input_read\r\nqview=1\r\nqedit=1\r\n','0000-00-00 00:00:00');

/*!40000 ALTER TABLE `keys_styles` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table keys_subscribe
# ------------------------------------------------------------

DROP TABLE IF EXISTS `keys_subscribe`;

CREATE TABLE `keys_subscribe` (
  `ID` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL DEFAULT '',
  `tbl` varchar(64) NOT NULL DEFAULT '',
  `lkey` varchar(64) NOT NULL DEFAULT '',
  `object` varchar(8) NOT NULL DEFAULT '',
  `settings` text NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `tbl` (`tbl`,`lkey`,`object`)
) ENGINE=MyISAM DEFAULT CHARSET=cp1251 COMMENT='Ключи к модулю Рассылка';

LOCK TABLES `keys_subscribe` WRITE;
/*!40000 ALTER TABLE `keys_subscribe` DISABLE KEYS */;

INSERT INTO `keys_subscribe` (`ID`, `name`, `tbl`, `lkey`, `object`, `settings`, `updated_at`)
VALUES
	(1,'Рассылка','','id_status','lkey','type=tlist\r\nlist=lst_status\r\nrating=5\r\nclass=required\r\nrequired=1\r\nfilter=1\r\ntable_list=3\r\n','2010-02-12 17:13:56'),
	(2,'E-mail','dtbl_subscribe_users','name','lkey','type=email\r\nfilter=1\r\ngroup=1\r\nrating=1\r\ntable_list=1\r\nno_format=1\r\nrequired=1\r\nobligatory=1','2010-02-16 23:31:20'),
	(3,'Код на картинке','','code','lkey','type=d\r\nsys=1','0000-00-00 00:00:00'),
	(4,'Поле подтверждения по картинке','','number','lkey','type=d\r\nrating=90\r\ngroup=1\r\nshablon_reg=field_imgconfirm\r\n','0000-00-00 00:00:00'),
	(5,'Email','','email','lkey','type=email\r\ngroup=1\r\nrating=3\r\ntable_list=2\r\nrequired=1\r\nobligatory=1\r\nfileview=1\r\n','2010-02-16 23:31:20'),
	(6,'Активация','','active','lkey','type=chb\r\nrating=11\r\ntable_list=5\r\ntable_list_name= \r\ngroup=1\r\nyes=активен\r\nno=не активен\r\nfilter=1\r\n','2010-02-16 23:31:20'),
	(7,'Добавить запись','','add_link','button','type_link=openpage\nposition=center\nid=newentry\r\ntable_list=1\r\ncontroller=subscribe\r\naction=add\r\nimageiconmenu=/admin/img/icons/menu/icon_add.png\r\ntitle=Добавить\r\nrating=1\r\nparams=replaceme,users_flag,list_table','0000-00-00 00:00:00'),
	(10,'Удалить запись','','del_link','button','type_link=loadcontent\r\ncontroller=subscribe\r\naction=delete\r\nconfirm=Действительно удалить запись?\r\nimageiconmenu=/admin/img/icons/menu/icon_delete.png\r\ntitle=Удалить запись\r\nprint_info=1\r\nrating=1\r\nparams=replaceme,index,users_flag','0000-00-00 00:00:00'),
	(11,'Редактировать запись','','edit_link','button','type_link=loadcontent\r\nprint_info=1\r\ncontroller=subscribe\r\nimageiconmenu=/admin/img/icons/menu/icon_edit.png\r\naction=edit\r\ntitle=Редактировать запись\r\nrating=2\r\nparams=replaceme,index,list_table','0000-00-00 00:00:00'),
	(12,'Закончить редактирование','','end_link','button','type_link=loadcontent\r\nedit_info=1\r\ncontroller=subscribe\r\naction=info\r\nimageiconmenu=/admin/img/icons/menu/icon_ok.png\r\ntitle=Закончить редактирование\r\nrating=1\r\nparams=replaceme,index,list_table','0000-00-00 00:00:00'),
	(13,'Фильтр','','filter','button','type_link=modullink\r\ntable_list=1\r\ncontroller=subscribe\r\naction=filter\r\nimageiconmenu=/admin/img/icons/menu/icon_filter.png\r\ntitle=Фильтр\r\nwidth=690\r\nheight=510\r\nlevel=3\r\nrating=2\r\nparams=replaceme,users_flag','0000-00-00 00:00:00'),
	(14,'Очистка фильтра','','filter_clear','button','type_link=loadcontent\r\ntable_list=1\r\ncontroller=subscribe\r\nimageiconmenu=/admin/img/icons/menu/icon_nofilter.png\r\naction=filter_clear\r\ntitle=Снять фильтры\r\nrating=3\r\nparams=replaceme,users_flag','0000-00-00 00:00:00'),
	(16,'Группы подписчиков','','status','button','type_link=openpage\r\nmenu_button=1\r\nprogram=/cgi-bin/lists_a.cgi\r\naction=list&list_table=lst_status&menu_button_no=1\r\nimageiconmenu=/admin/img/icons/menu/button.advplace.png\r\ntitle=Группы подписчиков\r\nrating=3\r\nreplaceme=listslst_status\r\nid=listslst_status\r\n','0000-00-00 00:00:00'),
	(29,'Адреса','','emails','lkey','type=table\r\ntable=dtbl_subscribe_emails\r\ngroup=2\r\nrating=15\r\nshablon_w=field_table\r\ntable_fields=id_user,email\r\ntable_svf=id_user\r\ntable_sortfield=email\r\ntable_buttons_key_w=delete,edit\r\ntable_groupname=Общая информация\r\ntable_noindex=1','0000-00-00 00:00:00'),
	(18,'Флаг для таблицы пользователей','','users_flag','lkey','type=d\r\nsys=1','2010-02-16 23:43:17'),
	(19,'Название рассылки','data_subscribe','name','lkey','type=s\r\nfilter=1\r\ngroup=1\r\nrating=1\r\ntable_list=1\r\nno_format=1\r\nrequired=1\r\nobligatory=1','0000-00-00 00:00:00'),
	(20,'Название','','name','lkey','type=s\r\nfilter=1\r\ngroup=1\r\nrating=1\r\ntable_list=1\r\nno_format=1\r\nrequired=1\r\nobligatory=1','2010-02-12 17:13:56'),
	(21,'Тема письма рассылки','','subject','lkey','type=s\r\nrating=2\r\ngroup=1\r\nrequired=1','2010-02-12 17:13:56'),
	(22,'Список','','list_link','button','type_link=loadcontent\r\nadd_info=1\r\ncontroller=subscribe\r\naction=enter\r\ntitle=Список\r\nrating=1\r\nparams=replaceme,users_flag','0000-00-00 00:00:00'),
	(23,'Текст рассылки','','text','lkey','type=html\r\ngroup=2\r\nrating=1','2010-02-11 18:01:58'),
	(24,'Статистика','','stat','lkey','type=table\r\ntable=dtbl_subscribe_stat\r\ngroup=3\r\nrating=15\r\nshablon_w=field_table\r\ntable_fields=id_user,send_date\r\ntable_svf=id_data_subscribe\r\ntable_sortfield=send_date\r\ntable_buttons_key_w=delete,edit\r\ntable_groupname=Общая информация\r\ntable_noindex=1','0000-00-00 00:00:00'),
	(25,'Пользователь','','id_user','lkey','type=tlist\r\nlist=dtbl_subscribe_users\r\nrating=2','2010-01-14 13:13:37'),
	(26,'Дата отправки','','send_date','lkey','type=time\r\n','0000-00-00 00:00:00'),
	(27,'Разослать письмо','','send_link','button','type_link=loadcontent\r\nprint_info=1\r\ncontroller=subscribe\r\nimageiconmenu=/admin/img/icons/menu/icon_subscribesend.png\r\naction=send\r\ntitle=Разослать письмо\r\nrating=1\r\nparams=replaceme,index','0000-00-00 00:00:00'),
	(28,'Разослано','','send','lkey','type=chb\r\nrating=11\r\ntable_list=5\r\ntable_list_name= \r\ngroup=1\r\nyes=да\r\nno=нет\r\nfilter=1\r\n','2010-02-12 17:13:56'),
	(31,'ФИО','regform','name','lkey','type=s\r\nrating=1\r\nkeys_read=1\r\nshablon_reg=field_input\r\nshablon_view=field_input_read\r\nobligatory=1\r\neditform=1\r\nsaveform=1\r\nobligatory_rules=validate[required]','0000-00-00 00:00:00'),
	(32,'Индекс','','index','lkey','type=d\r\nsys=1\r\n','2010-03-12 17:03:16'),
	(33,'Поле подтверждения по картинке','regform','number','lkey','type=d\r\nrating=90\r\ngroup=1\r\nobligatory=1\r\nregform=1\r\neditform=1\r\nshablon_reg=field_imgconfirm\r\n','0000-00-00 00:00:00'),
	(34,'Email','regform','email','lkey','type=email\r\ngroup=1\r\nrating=4\r\ntable_list=2\r\nshablon_reg=field_input_dopemail\r\nshablon_view=field_input_read','0000-00-00 00:00:00'),
	(35,'Рассылки','regform','status','lkey','type=tlist\r\nlist=lst_status\r\nrating=20\r\nclass=validate[required]\r\nrequired=1\r\nfilter=1\r\ntable_list=3\r\nshablon_reg=field_checkbox\r\neditform=1\r\nsaveform=1\r\nnotnull=1','0000-00-00 00:00:00'),
	(36,'Рассылки','','status','lkey','type=tlist\r\nlist=lst_status\r\nrating=5\r\nclass=required\r\nrequired=1\r\nfilter=1\r\ntable_list=3\r\nshablon_w=field_multselect_input\r\nhelp=Рассылки, на которые подписан пользователь','2010-02-16 23:31:20');

/*!40000 ALTER TABLE `keys_subscribe` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table keys_syslogs
# ------------------------------------------------------------

DROP TABLE IF EXISTS `keys_syslogs`;

CREATE TABLE `keys_syslogs` (
  `ID` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL DEFAULT '',
  `tbl` varchar(64) NOT NULL DEFAULT '',
  `lkey` varchar(64) NOT NULL DEFAULT '',
  `object` varchar(8) NOT NULL DEFAULT '',
  `settings` text NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `tbl` (`tbl`,`lkey`,`object`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Ключи к модулю Sysusers';

LOCK TABLES `keys_syslogs` WRITE;
/*!40000 ALTER TABLE `keys_syslogs` DISABLE KEYS */;

INSERT INTO `keys_syslogs` (`ID`, `name`, `tbl`, `lkey`, `object`, `settings`, `updated_at`)
VALUES
	(1,'Действие','','name','lkey','type=s\nrating=1\ntable_list=1\nrequired=1\nqview=1\nqedit=1\ntemplate_w=field_input_read\n','2010-03-11 14:34:30'),
	(7,'Управление доступом. Фильтр','','filter','button','type_link=modullink\r\ntable_list=1\r\ncontroller=syslogs\r\naction=filter\r\nimageiconmenu=/admin/img/icons/menu/icon_filter.png\r\ntitle=Настроить фильтр\r\nwidth=690\r\nheight=510\r\nlevel=3\r\nrating=2\r\nparams=replaceme','0000-00-00 00:00:00'),
	(8,'Управление доступом. Очистка фильтра','','filter_clear','button','type_link=loadcontent\r\ntable_list=1\r\ncontroller=syslogs\r\nimageiconmenu=/admin/img/icons/menu/icon_nofilter.png\r\naction=filter_clear\r\ntitle=Снять фильтры\r\nrating=3\r\nparams=replaceme','0000-00-00 00:00:00'),
	(9,'Удалить запись','','del_link','button','type_link=loadcontent\r\ncontroller=syslogs\r\naction=delete\r\nimageiconmenu=/admin/img/icons/menu/icon_delete.png\r\nconfirm=Действительно удалить запись?\r\ntitle=Удалить запись\r\nprint_info=1\r\nrating=1\r\nparams=replaceme,index','0000-00-00 00:00:00'),
	(10,'Список пользователей','','list_link','button','type_link=loadcontent\r\nadd_info=1\r\ncontroller=syslogs\r\nimageiconmenu=/admin/img/icons/menu/button.list.png\r\naction=enter\r\ntitle=Список пользователей\r\nrating=1\r\nparams=replaceme','0000-00-00 00:00:00'),
	(45,'Дата создания','','created_at','lkey','type=datetime\r\nrating=100\r\ngroup=1\r\nqview=1\r\nfilter=1\r\nfileview=1\r\ntable_list=11\r\ntable_list_width=70\r\ntemplate_f=field_date_filter','2014-02-20 10:12:54'),
	(41,'Комментарий','','comment','lkey','type=text\nprint=1\nqview=1\nrating=90\nfileview=1\ntemplate_w=field_input_read\n\n','0000-00-00 00:00:00'),
	(42,'IP','','ip','lkey','type=s\nprint=1\nqview=1\nqedit=1\nfilter=1\nrating=15\ntable_list=9\ntable_list_width=70\ntemplate_w=field_input_read\n','0000-00-00 00:00:00'),
	(40,'Модуль','','id_program','lkey','type=tlist\nlist=sys_program\nrating=6\nprint=1\nqview=1\nfilter=1\ntable_list=2\ntable_list_width=150\ntemplate_w=field_list_read\n','0000-00-00 00:00:00'),
	(44,'Тип события','','eventtype','lkey','type=list\nlist=1|Добавление~2|Удаление~3|Редактирование~4|Восстановление~5|Авторизация~6|Ошибка\nlist_type=radio\nfilter=1\nrating=30\nfileview=1\ntable_list=8\ntable_list_width=70\nqview=1\nprint=1\ntemplate_w=field_list_read\n','0000-00-00 00:00:00'),
	(43,'Группа','','id_sysusergroup','lkey','type=tlist\nlist=lst_group_user\nrating=6\nprint=1\nqview=1\nfilter=1\ntable_list=6\ntable_list_width=150\ntemplate_w=field_list_read\n','0000-00-00 00:00:00'),
	(39,'Пользователь','','id_sysuser','lkey','type=tlist\nlist=sys_users\nrating=5\nprint=1\nqview=1\nfilter=1\ntable_list=5\ntable_list_width=150\ntemplate_w=field_list_read\n','2014-04-04 12:53:36');

/*!40000 ALTER TABLE `keys_syslogs` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table keys_sysusers
# ------------------------------------------------------------

DROP TABLE IF EXISTS `keys_sysusers`;

CREATE TABLE `keys_sysusers` (
  `ID` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL DEFAULT '',
  `tbl` varchar(64) NOT NULL DEFAULT '',
  `lkey` varchar(64) NOT NULL DEFAULT '',
  `object` varchar(8) NOT NULL DEFAULT '',
  `settings` text NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `tbl` (`tbl`,`lkey`,`object`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Ключи к модулю Sysusers';

LOCK TABLES `keys_sysusers` WRITE;
/*!40000 ALTER TABLE `keys_sysusers` DISABLE KEYS */;

INSERT INTO `keys_sysusers` (`ID`, `name`, `tbl`, `lkey`, `object`, `settings`, `updated_at`)
VALUES
	(1,'Имя пользователя','','name','lkey','type=s\nrating=1\ntable_list=1\nrequired=1\nqview=1\nqedit=1','2010-03-11 11:34:30'),
	(2,'Логин','','login','lkey','type=s\r\nrating=1\r\nrequired=1\r\nqview=1\r\nqedit=1\r\ntable_list=2\r\n','2010-03-11 11:34:30'),
	(3,'E-mail','','email','lkey','type=email\r\nrating=3\r\nmask=email\r\n','2010-03-11 11:34:30'),
	(4,'Пароль','','password_digest','lkey','type=password\r\nrating=5\r\nrequired=1','2010-03-11 11:34:30'),
	(5,'Группа пользователей','','id_group_user','lkey','type=tlist\nlist=lst_group_user\ntable_list=3\nrating=5\nrequired=1\nqview=1\nfilter=1\nmult=7\nshablon_w=field_multselect\nnotnull=1','2010-03-11 11:34:30'),
	(6,'Дата последней авторизации','','vdate','lkey','type=datetime\r\nrating=10\r\n','2010-03-10 20:25:26'),
	(7,'Управление доступом. Фильтр','','filter','button','type_link=modullink\r\ntable_list=1\r\ncontroller=sysusers\r\naction=filter\r\nimageiconmenu=/admin/img/icons/menu/icon_filter.png\r\ntitle=Настроить фильтр\r\nwidth=690\r\nheight=510\r\nlevel=3\r\nrating=2\r\nparams=replaceme','0000-00-00 00:00:00'),
	(8,'Управление доступом. Очистка фильтра','','filter_clear','button','type_link=loadcontent\r\ntable_list=1\r\ncontroller=sysusers\r\nimageiconmenu=/admin/img/icons/menu/icon_nofilter.png\r\naction=filter_clear\r\ntitle=Снять фильтры\r\nrating=3\r\nparams=replaceme','0000-00-00 00:00:00'),
	(9,'Удалить запись','','del_link','button','type_link=loadcontent\r\ncontroller=sysusers\r\naction=delete\r\nimageiconmenu=/admin/img/icons/menu/icon_delete.png\r\nconfirm=Действительно удалить запись?\r\ntitle=Удалить запись\r\nprint_info=1\r\nrating=1\r\nparams=replaceme,index','0000-00-00 00:00:00'),
	(10,'Список пользователей','','list_link','button','type_link=loadcontent\r\nadd_info=1\r\ncontroller=sysusers\r\nimageiconmenu=/admin/img/icons/menu/button.list.png\r\naction=enter\r\ntitle=Список пользователей\r\nrating=1\r\nparams=replaceme','0000-00-00 00:00:00'),
	(11,'Редактировать запись','','edit_link','button','type_link=loadcontent\r\nprint_info=1\r\ncontroller=sysusers\r\nimageiconmenu=/admin/img/icons/menu/icon_edit.png\r\naction=edit\r\ntitle=Редактировать запись\r\nrating=2\r\nparams=replaceme,index','0000-00-00 00:00:00'),
	(14,'Закончить редактирование','','end_link','button','type_link=loadcontent\r\nedit_info=1\r\ncontroller=sysusers\r\nimageiconmenu=/admin/img/icons/menu/icon_ok.png\r\naction=info\r\ntitle=Закончить редактирование\r\nrating=10\r\nparams=replaceme,index','0000-00-00 00:00:00'),
	(15,'Добавить запись','','add_link','button','type_link=openpage\nposition=center\nid=newentry\r\ntable_list=1\r\ncontroller=sysusers\r\nimageiconmenu=/admin/img/icons/menu/icon_add.png\r\naction=add\r\ntitle=Добавить запись\r\nrating=1\r\nparams=replaceme','0000-00-00 00:00:00'),
	(19,'Заблокирован до','','btime','lkey','type=datetime\r\nrating=21','2010-03-10 20:25:26'),
	(20,'Количество попыток авторизации','','count','lkey','type=d\r\nrating=22','2010-03-10 20:25:26'),
	(21,'Настройки','','settings','lkey','type=code\r\ntemplate_w=field_settings_read\r\nrating=30\r\nfilter=1\r\nshablon_r=field_settings_read\r\n','2010-03-10 20:25:26'),
	(22,'Последний заход с IP','','ip','lkey','type=s\r\ntemplate_w=field_input_read\r\nrating=22','2010-03-10 20:25:26'),
	(23,'Заблокирован IP','','bip','lkey','type=s\r\ntemplate_w=field_input_read\r\nrating=23','2010-03-10 20:25:26'),
	(29,'Доступно для пользователей','','users_list','lkey','type=tlist\r\nlist=sys_users\r\ngroup=1\r\nrating=128\r\nmult=5\r\nshablon_w=field_multselect\r\nnotnull=1','2010-03-11 11:34:30'),
	(30,'Учетные записи','','users','menu','type_link=loadcontent\r\naction=enter\r\nprogram=/cgi-bin/users_a.cgi\r\nrating=23\r\nparentid=setting\r\nreplaceme=replaceme\r\nsubmenuwidth=200','0000-00-00 00:00:00'),
	(31,'Добавить пользователя','','users_add','menu','type_link=loadcontent\r\naction=add\r\nprogram=/cgi-bin/users_a.cgi\r\nrating=123\r\nparentid=users\r\nreplaceme=replaceme','0000-00-00 00:00:00'),
	(34,'Супер пользователь','','sys','lkey','type=chb\r\ngroup=1\r\nrating=130\r\nyes=Супер пользователь\r\nno=Пользователь','2010-03-10 20:25:26'),
	(35,'Доступно для групп','','groups_list','lkey','type=tlist\r\nlist=lst_group_user\r\ngroup=1\r\nrating=129\r\ndefault=6\r\nshablon_w=field_multselect\r\nnotnull=1','0000-00-00 00:00:00'),
	(37,'Права доступа','','access','lkey','type=code\r\nsys=1\r\n','0000-00-00 00:00:00'),
	(38,'Visual Front-end Editor','','vfe','lkey','type=chb\r\ngroup=1\r\nrating=131\r\nyes=Включен\r\nno=Выключен','0000-00-00 00:00:00'),
	(39,'Копировать запись','','copy','button','type_link=loadcontent\nprint_info=1\nedit_info=1\ncontroller=sysusers\naction=copy\nloading_msg=1\nimageiconmenu=/admin/img/icons/menu/icon_copy.png\ntitle=Копировать запись\nrating=5\nparams=replaceme,index,list_table','0000-00-00 00:00:00');

/*!40000 ALTER TABLE `keys_sysusers` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table keys_templates
# ------------------------------------------------------------

DROP TABLE IF EXISTS `keys_templates`;

CREATE TABLE `keys_templates` (
  `ID` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL DEFAULT '',
  `tbl` varchar(64) NOT NULL DEFAULT '',
  `lkey` varchar(64) NOT NULL DEFAULT '',
  `object` varchar(8) NOT NULL DEFAULT '',
  `settings` text NOT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `tbl` (`tbl`,`lkey`,`object`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Ключи к модулю Шаблоны';

LOCK TABLES `keys_templates` WRITE;
/*!40000 ALTER TABLE `keys_templates` DISABLE KEYS */;

INSERT INTO `keys_templates` (`ID`, `name`, `tbl`, `lkey`, `object`, `settings`, `updated_at`)
VALUES
	(2,'Название','','name','lkey','type=s\r\nrating=1\r\nfilter=1\r\ntable_list=1\r\nhelp=Название шаблона\r\nrequired=1\r\ntemplate_w=field_input_read\r\nqview=1\r\nqedit=1\r\n','2010-10-28 17:55:00'),
	(30,'Дата редактирования','','modifytime','lkey','type=s\r\nrating=3\r\nhelp=Дата редактирования файла\r\nrequired=1\r\ntemplate_w=field_input_read\r\n\r\n\r\n','2011-10-20 02:37:05'),
	(31,'Путь к шаблону','','dir','lkey','type=s\r\nrating=2\r\nhelp=Путь к файлу\r\nrequired=1\r\ntemplate_w=field_input_read\r\nqview=1\r\nqedit=1\r\n','2011-10-20 02:43:12'),
	(6,'Дата редактирования','','edate','lkey','type=time\ntable_list=5\ngroup=1\nrating=7\nsys=1\nqview=1','0000-00-00 00:00:00'),
	(8,'Таблицы шаблонов','','list_shablon_table','list','list=0|-----','0000-00-00 00:00:00'),
	(12,'Удалить запись','','del_link','button','type_link=loadcontent\r\ncontroller=templates\r\naction=delete\r\nimageiconmenu=/admin/img/icons/menu/icon_delete.png\r\nconfirm=Действительно удалить запись?\r\ntitle=Удалить шаблон\r\nrating=3\r\nparams=shablon_table,replaceme,index\r\nprint_info=1','0000-00-00 00:00:00'),
	(20,'Закончить редактирование','','end_link','button','type_link=loadcontent\r\n#edit_info=1\r\ncontroller=templates\r\naction=mainpage\r\nimageiconmenu=/admin/img/icons/menu/icon_ok.png\r\ntitle=Закончить редактирование\r\nrating=1\r\nparams=dir,replaceme,index','0000-00-00 00:00:00'),
	(21,'Добавить шаблон','','add_link','button','type_link=openPage\r\n#templates_list=1\r\ncontroller=templates\r\naction=add\r\ntitle=Добавить шаблон\r\nimageiconmenu=/admin/img/icons/menu/icon_add.png\r\nrating=1\r\nparams=replaceme,dir\r\n','0000-00-00 00:00:00'),
	(32,'Код','','code','lkey','type=code\r\nrating=4\r\ntemplate_w=field_template\r\ntemplate_r=field_code_read\r\nfileview=1\r\ndirview=1\r\n','2011-11-16 21:10:05');

/*!40000 ALTER TABLE `keys_templates` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table keys_texts
# ------------------------------------------------------------

DROP TABLE IF EXISTS `keys_texts`;

CREATE TABLE `keys_texts` (
  `ID` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL DEFAULT '',
  `tbl` varchar(64) NOT NULL DEFAULT '',
  `lkey` varchar(64) NOT NULL DEFAULT '',
  `object` varchar(8) NOT NULL DEFAULT '',
  `settings` text NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `tbl` (`tbl`,`lkey`,`object`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Ключи к модулю Тексты';

LOCK TABLES `keys_texts` WRITE;
/*!40000 ALTER TABLE `keys_texts` DISABLE KEYS */;

INSERT INTO `keys_texts` (`ID`, `name`, `tbl`, `lkey`, `object`, `settings`, `updated_at`)
VALUES
	(1,'Добавить запись','','add_link','button','type_link=openpage\nposition=center\nid=newentry\ntable_list=1\r\nprint_info_text=1\r\nprint_info=1\r\ntable_list_dir=1\r\ncontroller=texts\r\nimageiconmenu=/admin/img/icons/menu/icon_add.png\r\naction=add\r\ntitle=Добавить\r\nrating=1\r\nparams=replaceme','0000-00-00 00:00:00'),
	(3,'Удалить запись','','del_link','button','type_link=loadcontent\r\nprint_info=1\r\nprint_info_text=1\r\ncontroller=texts\r\naction=delete\r\nconfirm=Действительно удалить запись?\r\ntitle=Удалить запись\r\nimageiconmenu=/admin/img/icons/menu/icon_delete.png\r\nrating=1\r\nparams=replaceme,index,list_table','0000-00-00 00:00:00'),
	(4,'Редактировать запись','','edit_link','button','type_link=loadcontent\r\nprint_info=1\r\nprint_info_text=1\r\ncontroller=texts\r\nimageiconmenu=/admin/img/icons/menu/icon_edit.png\r\naction=edit\r\ntitle=Редактировать запись\r\nrating=2\r\nparams=replaceme,index,list_table','0000-00-00 00:00:00'),
	(5,'Закончить редактирование','','end_link','button','type_link=loadcontent\r\nedit_info=1\r\ncontroller=texts\r\naction=info\r\nimageiconmenu=/admin/img/icons/menu/icon_ok.png\r\ntitle=Закончить редактирование\r\nrating=10\r\nparams=replaceme,index,list_table','0000-00-00 00:00:00'),
	(7,'Фильтр','','filter','button','type_link=modullink\r\ntable_list=1\r\ntable_list_dir=1\r\ncontroller=texts\r\nimageiconmenu=/admin/img/icons/menu/icon_filter.png\r\naction=filter\r\ntitle=Фильтр\r\nwidth=690\r\nheight=510\r\nlevel=3\r\nrating=2\r\nparams=replaceme','0000-00-00 00:00:00'),
	(8,'Очистка фильтра','','filter_clear','button','type_link=loadcontent\r\ntable_list=1\r\ntable_list_dir=1\r\ncontroller=texts\r\nimageiconmenu=/admin/img/icons/menu/icon_nofilter.png\r\naction=filter_clear\r\ntitle=Снять фильтры\r\nrating=3\r\nparams=replaceme','0000-00-00 00:00:00'),
	(9,'Список','','list_link','button','type_link=loadcontent\r\nadd_info=1\r\ncontroller=texts\r\nimageiconmenu=/admin/img/icons/menu/button.list.png\r\naction=enter\r\ntitle=Список\r\nrating=1\r\nparams=replaceme','0000-00-00 00:00:00'),
	(11,'Алиас','','alias','lkey','type=s\r\nrating=5\r\ntable_list=2\r\ngroup=1\r\nfilter=1\r\nqview=1\r\nqedit=1\r\nrequired=1\r\nhelp=Короткое латинское название, которое учавствует в формирование URL для данной страницы','2010-10-29 12:23:39'),
	(12,'Текст','','text','lkey','type=html\r\ngroup=2\r\nrating=1\r\nfileview=1','2010-10-29 15:22:54'),
	(13,'Название','','name','lkey','type=s\r\nfilter=1\r\ngroup=1\r\nrating=1\r\nrequired=1\r\nqedit=1\r\nqview=1\r\ntable_list=1\r\nno_format=1\r\ndirview=1\r\nfileview=1\r\nhelp=Название страницы. Используется при генерации меню, автоматических ссылок, заголовков h1','2010-10-29 12:23:39'),
	(14,'Раздел','','razdel','lkey','type=tlist\r\nlist=lst_texts\nlist_sort=asc_d\r\nwhere= AND `<%= $self->sysuser->settings->{lang} %>`=\'1\' \r\nnotnull=1','2010-10-29 15:22:54'),
	(15,'Заголовок окна','','title','lkey','type=s\nno_format=1\nrating=2\ngroup=1\nqview=1\nqedit=1\nhelp=Заголовок окна браузера. Может отличаться от названия текста. Используется для оптимизации под поисковые системы.\ndirview=1\nfileview=1','2010-10-29 12:23:39'),
	(16,'Ключевые слова','','keywords','lkey','type=s\nrating=3\ngroup=1\nfilter=1\nqedit=1\nhelp=Ключевые слова и выражения, разделенные запятой, которые соответствуют данному тексту. Используется для оптимизации страницы под поисковые системы. Указанные слова в данном поле должны обязательно присутствовать в тексте — в противном случае они не будут учитываться поисковыми машинами.\ndirview=1\nfileview=1','2010-10-29 12:23:39'),
	(17,'Краткое описание страницы','','description','lkey','type=text\r\nrating=3\r\ngroup=1\r\nqview=1\r\nhelp=Краткое описание текста. Используется для поисковых систем. Выводится на странице в meta-теге description. Как правило, пользователь данный текст не видет. Для поисковых систем полезнее для каждой страницы формировать свое описание, наиболее соответствующее данной странице.\r\ndirview=1\r\nfileview=1','2010-10-29 12:23:39'),
	(18,'Рейтинг','','rating','lkey','type=d\r\ngroup=1\r\nqview=1\r\nqedit=1\r\ntable_list=4\r\ntable_list_name=Rt\r\ntable_list_width=32\r\nrating=6\r\ntemplate_w=field_rating\r\nhelp=Рейтинг служит для выстраивания текстов друг относительно друга. Чем меньше значение, тем выше текст в иерархии','2010-10-29 12:23:39'),
	(19,'Включать в меню','','menu','lkey','type=chb\r\nrating=10\r\ngroup=1\r\nqedit=1\r\nfilter=1\r\ntable_list=7\r\ntable_list_name=Меню\r\ntable_list_width=64\r\nyes=да\r\nno=нет\r\nhelp=При установке флажка данный текст будет участвовать в формировании меню основного сайта.','2010-10-29 12:23:39'),
	(21,'Публикация','','viewtext','lkey','type=chb\r\nrating=99\r\ngroup=1\r\nqview=1\r\ntable_list=10\r\ntable_list_name=-\r\ntable_list_width=48\r\nyes=Виден\nno=Скрыт\r\nfilter=1\r\ndirview=1\r\nqedit=1\r\nfileview=1\r\nhelp=Публиковать страницу на сайте','2010-10-29 12:23:39'),
	(186,'Редактировать текст','','edit_link_text','button','type_link=loadcontent\r\nprint_info_text=1\r\ncontroller=texts\r\nimageiconmenu=/admin/img/icons/menu/button.text.gif\r\naction=edit&group=2\r\ntitle=Редактировать текст\r\nrating=3\r\nparams=replaceme,index,list_table','0000-00-00 00:00:00'),
	(22,'Неудаляем','','delnot','lkey','type=chb\nrating=12\ngroup=1\ntable_list=4\ntable_list_name=-\ntable_list_nosort=1\ntable_list_width=16\nyes=<img src=\"/admin/img/icons/ico_lock.gif\">\nno=<img src=\"/admin/img/icons/ico_unlock.gif\">\ndirview=1\nfileview=1\nhelp=Данная опция защищает текст от случайного удаления.','2010-10-29 12:23:39'),
	(23,'URL-ссылка на страницу в Internet','','link','lkey','type=s\r\ngroup=1\r\nrating=4\r\nhelp=Используется при построении основного меню. Происходит подмена алиаса на указанную в данном поле ссылку. ','2010-10-29 12:23:39'),
	(24,'Шаблон страницы','','layout','lkey','type=s\r\ntemplate_w=field_layout\r\ngroup=1\r\nrating=20\r\nhelp=Если для страницы требуется установить какой-то особенный шаблон, то выберите его из выпадающего списка. По умолчанию используется шаблон default','2010-10-29 12:23:39'),
	(25,'Модуль','','url_for','lkey','type=code\r\ntemplate_w=field_url_for\r\ngroup=1\r\nrating=21\r\nhelp=Выберите модуль, который будет показан на данной странице\r\n#help=XML-директива, которая будет выполняться при загрузке страницы и выводить результаты выполнения в контентной области, вместо вывода текста. Открывающая и закрывающая угловые скобки в данном поле опускаются. Вводится только код.','2010-10-29 12:23:39'),
	(185,'Текст','texts_floating_ru','text','lkey','type=html\r\ngroup=1\r\nrating=90\r\nfileview=1\r\ncktoolbar=Basic\r\n','0000-00-00 00:00:00'),
	(27,'Верхний уровень','','texts_main_ru','lkey','type=tlist\r\nlist=texts_main_ru\r\nsort=1\r\nrating=7\r\ntemplate_w=field_select_dir\r\ntemplate_f=field_select_dir_filter\r\ngroup=1\r\nfilter=1\r\nhelp=Для построения вложенных меню выберите текст верхнего уровня из иерархического дерева текстов раздела. Для того, чтобы вернуть текст в главный уровень выберите самый главный уровень дерева texts_main_ru.\r\n','2010-10-29 12:23:39'),
	(29,'Группа','','texts_news','lkey','type=tlist\nlist=texts_news_ru\ntable_list=5\nsort=1\nrating=7\ngroup=1\nfilter=1\nwhere=AND `texts_news`=0 AND `dir` = 1\nhelp=Тематическая группа, к которой принадлежит данная новость. Выберите из списка.\nfileview=1\n','2010-08-21 19:28:46'),
	(31,'Включать в RSS','','rss','lkey','type=chb\nrating=12\ngroup=1\nyes=включать в RSS\nno=не включать в RSS\nfileview=1','2008-10-23 12:58:40'),
	(32,'Папка','','dir','lkey','type=chb\ngroup=1\nrating=6\ntable_list=7\ntable_list_name=-\ntable_list_nosort=1\ntable_list_width=16\nyes=<img src=\"/admin/img/dtree/folder.gif\">\nno=<img src=\"/admin/img/dtree/doc.gif\">\nfilter=1\nhelp=Если установить данный флажок, то данная запись будет считаться папкой\ntemplate_w=field_checkbox_read\n','2010-08-28 19:20:08'),
	(33,'Рейтинг','texts_news_ru','rating','lkey','type=d\r\ngroup=1\r\nrating=16\r\nnoview=1\r\ndirview=1\r\ntemplate_w=field_rating\r\n','0000-00-00 00:00:00'),
	(34,'Картинка','','pict','lkey','type=pict\r\nrating=14\r\ntemplate_w=field_pict\r\ntemplate_r=field_pict_read\r\nsizelimit=20000\r\next=*.jpg;*.jpeg;*.tif\r\nmini=209x161~montage\r\nfolder=/image/texts/\r\nfileview=1\r\ntable_list=7\r\ntable_list_type=pict\r\ntable_list_name=-\r\nhelp=Картинка для анонса новости','2010-10-27 16:23:52'),
	(35,'Файл','','filename','lkey','type=filename\nrating=2\nsizelimit=20000\nfile_ext=*.*','2010-10-29 12:20:44'),
	(36,'Флаг удаления картинки','','deletepict','lkey','type=chb\nsys=1','2008-10-30 17:42:45'),
	(37,'Фото галерея','','image_gallery','lkey','type=tlist\nlist=images_gallery\nrating=15\ngroup=1\nwhere=AND `dir`=1\nshablon_w=field_select_input\nfileview=1\n','2010-08-21 19:28:46'),
	(38,'Новости','','id_news','lkey','type=tlist\nlist=texts_news_ru\nrating=17\ngroup=1\nwhere=AND `dir` = 0\nshablon_w=field_multselect_input\nfileview=1\nnotnull=1','2010-08-28 19:20:08'),
	(40,'Дата','','tdate','lkey','type=date\r\nrating=10\r\ngroup=1\r\nqview=1\r\nfilter=1\r\nfileview=1\r\ntable_list=8\r\ntable_list_width=70\r\ntemplate_f=field_date_filter\nhelp=Укажите какой датой датировать эту запись\n','2010-10-27 11:04:12'),
	(44,'Тексты. Добавить папку','','add_link_dir','button','type_link=loadcontent\r\ntable_list_dir=1\r\ncontroller=texts\r\nimageiconmenu=/admin/img/icons/menu/icon_dir_add.png\r\naction=add_dir\r\ntitle=Создать папку\r\nparams=replaceme\r\nrating=1','0000-00-00 00:00:00'),
	(45,'Флаг скрыть','','hide','lkey','type=s\nsys=1','2010-10-28 15:33:25'),
	(46,'Флаг показать','','show','lkey','type=s\nsys=1','2010-10-28 15:33:36'),
	(59,'Год','','year','lkey','type=d','2010-05-07 13:59:22'),
	(60,'Месяц','','month','lkey','type=d','2010-05-07 13:59:22'),
	(61,'День','','day','lkey','type=d','2010-05-07 13:59:22'),
	(86,'Тексты','','texts','menu','type_link=loadcontent\naction=enter\nprogram=/cgi-bin/text_a.cgi\nrating=11\nparentid=edit\nreplaceme=replaceme\nsubmenuwidth=200\n','0000-00-00 00:00:00'),
	(66,'Группа','','texts_articles','lkey','type=tlist\r\nlist=texts_articles_ru\r\nsort=1\r\nrating=7\r\ngroup=1\r\nfilter=1\r\nwhere=AND `dir`=1\r\nhelp=Тематическая группа, к которой принадлежит данная статья. Выберите из списка.\r\nfileview=1\r\n','2010-07-06 16:01:54'),
	(67,'Автор','','author','lkey','type=s\r\nfilter=1\r\ngroup=1\r\nrating=25\r\nno_format=1\r\nhelp=Введите автора или ссылку на первоисточник','2010-07-12 14:12:49'),
	(83,'Документ','','docfile','lkey','type=file\r\nrating=14\r\ntemplate_w=field_file\r\ntemplate_r=field_file_read\r\nsizelimit=20000\r\next=*.*\r\nfolder=/docfiles/\r\nfileview=1\r\ntable_list=2\r\nhelp=Название документа\r\n','2010-10-25 15:11:09'),
	(84,'Размер файла','','docfile_size','lkey','type=filesize\ntemplate_w=field_input_read\ntable_list=5\ntable_list_name=Размер\ntable_list_width=70\n\n','2009-03-24 17:50:05'),
	(78,'Дата','','adate','lkey','type=date\r\nrating=10\r\ngroup=1\r\nfilter=1\r\nfileview=1\nhelp=Укажите какой датой датировать эту запись\r\n','2010-07-06 16:01:54'),
	(82,'Тип файла','','type_file','lkey','type=s\nshablon_w=field_input_read\nhelp=Тип файла картинки анонса\n','2009-05-26 16:21:19'),
	(88,'Флаг отсылки','','send','lkey','type=d\r\nsys=1','0000-00-00 00:00:00'),
	(127,'Анонс','','anons','lkey','type=html\r\nrating=5\r\ngroup=1\r\nprint=1\r\nshablon_w=field_text\r\n','2009-12-18 15:37:15'),
	(157,'Группа товаров или услуг','','texts_docfiles','lkey','type=tlist\r\nlist=texts_docfiles_ru\r\nsort=1\r\nrating=10\r\ngroup=1\r\nfilter=1\r\nwhere= AND `texts_docfiles`>0\r\nhelp=Выбирите группу товаров или услуг к которой относится данный документ ( предварительно необходимо выбрать подрубрику, после чего будет подгружен список )\r\nfileview=1\r\n','2010-01-15 14:38:53'),
	(169,'Директория с файлами документов','','docfolder','lkey','type=s\r\nsys=1','0000-00-00 00:00:00'),
	(182,'Цена','','price','lkey','type=d\r\nprint=1\r\nqview=1\r\nqedit=1\r\ntable_list=4\r\ntable_list_width=70\r\nfileview=1\r\nrating=5\r\n','0000-00-00 00:00:00'),
	(184,'Звездность','','stars','lkey','type=list\r\nlist=1|1~2|2~3|3~4|4~5|5\r\nlist_type=radio\r\nfilter=1\r\ntable_list=6\r\ntable_list_width=70\r\nrating=10\r\nfileview=1\r\nqedit=1\r\nnotnull=1\r\n\r\n','0000-00-00 00:00:00'),
	(187,'Заголовок h1','','h1','lkey','type=s\r\ngroup=1\r\nrating=2\r\nqedit=1\r\nqview=1\r\ntable_list=3\ntable_list_width=200\nno_format=1\r\nfileview=1\r\nhelp=Заголовок страницы h1. Если он не заполнен, то используется заголовок из названия страницы','2010-10-29 12:23:39'),
	(188,'Копировать запись','','copy','button','type_link=loadcontent\nprint_info=1\nedit_info=1\ncontroller=texts\naction=copy\nloading_msg=1\nimageiconmenu=/admin/img/icons/menu/icon_copy.png\ntitle=Копировать запись\nrating=5\nparams=replaceme,index,list_table','0000-00-00 00:00:00'),
	(189,'Карта','','map','lkey','type=map\nrating=99\ngroup=1\nrequired=0',NULL);

/*!40000 ALTER TABLE `keys_texts` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table keys_users
# ------------------------------------------------------------

DROP TABLE IF EXISTS `keys_users`;

CREATE TABLE `keys_users` (
  `ID` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL DEFAULT '',
  `tbl` varchar(64) NOT NULL DEFAULT '',
  `lkey` varchar(64) NOT NULL DEFAULT '',
  `object` varchar(8) NOT NULL DEFAULT '',
  `settings` text NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `tbl` (`tbl`,`lkey`,`object`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Ключи к модулю Тексты';

LOCK TABLES `keys_users` WRITE;
/*!40000 ALTER TABLE `keys_users` DISABLE KEYS */;

INSERT INTO `keys_users` (`ID`, `name`, `tbl`, `lkey`, `object`, `settings`, `updated_at`)
VALUES
	(1,'Добавить запись','','add_link','button','type_link=openpage\nposition=center\nid=newentry\r\ntable_list=1\r\nprint_info=1\r\ncontroller=users\r\naction=add\r\nimageiconmenu=/admin/img/icons/menu/icon_add.png\r\ntitle=Добавить\r\nrating=1\r\nparams=replaceme,list_table','0000-00-00 00:00:00'),
	(2,'Удалить запись','','del_link','button','type_link=loadcontent\r\ncontroller=users\r\naction=delete\r\nconfirm=Действительно удалить запись?\r\ntitle=Удалить запись\r\nimageiconmenu=/admin/img/icons/menu/icon_delete.png\r\nprint_info=1\r\nrating=1\r\nparams=replaceme,index,list_table','0000-00-00 00:00:00'),
	(3,'Редактировать запись','','edit_link','button','type_link=loadcontent\r\nprint_info=1\r\ncontroller=users\r\naction=edit\r\nimageiconmenu=/admin/img/icons/menu/icon_edit.png\r\ntitle=Редактировать запись\r\nrating=2\r\nparams=replaceme,index,list_table','0000-00-00 00:00:00'),
	(4,'Закончить редактирование','','end_link','button','type_link=loadcontent\r\nedit_info=1\r\ncontroller=users\r\naction=info\r\nimageiconmenu=/admin/img/icons/menu/icon_ok.png\r\ntitle=Закончить редактирование\r\nrating=10\r\nparams=replaceme,index,list_table\r\n','0000-00-00 00:00:00'),
	(5,'Фильтр','','filter','button','type_link=modullink\r\ntable_list=1\r\ntable_list_orders=1\r\ncontroller=users\r\naction=filter\r\nimageiconmenu=/admin/img/icons/menu/icon_filter.png\r\ntitle=Фильтр\r\nwidth=690\r\nheight=510\r\nlevel=3\r\nrating=2\r\nparams=replaceme,list_table','0000-00-00 00:00:00'),
	(6,'Очистка фильтра','','filter_clear','button','type_link=loadcontent\r\ntable_list=1\r\ntable_list_orders=1\r\ntable_list_dir=1\r\ncontroller=users\r\naction=filter_clear\r\nimageiconmenu=/admin/img/icons/menu/icon_nofilter.png\r\ntitle=Снять фильтры\r\nrating=3\r\nparams=replaceme,list_table','0000-00-00 00:00:00'),
	(7,'Фамилия','','name','lkey','type=s\r\nfilter=1\r\ngroup=1\r\nrating=1\r\nrequired=1\r\nqedit=1\r\ntable_list=1\r\nno_format=1\r\nfileview=1\r\nregister=1\r\nobligatory=1\r\n','2010-10-31 11:29:29'),
	(52,'Состояние учетной записи','','active','lkey','type=chb\r\nprint=1\r\nqview=1\r\nqedit=1\r\nfilter=1\r\ntable_list=8\r\ntable_list_width=70\r\nyes=Активна\r\nno=Заблокирована\r\n','0000-00-00 00:00:00'),
	(53,'Ключ сессии','','cck','lkey','type=s\r\nsys=1','0000-00-00 00:00:00'),
	(41,'Картинка','','pict','lkey','type=pict\r\nrating=14\r\ntemplate_w=field_pict\r\ntemplate_r=field_pict_read\r\nsizelimit=20000\r\next=*.jpg;*.jpeg;*.gif;\r\nmini=117x77~montage,574x289~montage\r\nfolder=/image/catalog/\r\nfileview=1\r\ntable_list=4\r\ntable_list_type=pict\r\ntable_list_name=-\r\n','0000-00-00 00:00:00'),
	(49,'Адрес','','addr','lkey','type=s\r\nprint=1\r\nqview=1\r\nqedit=1\r\nrating=11\r\n\r\n','0000-00-00 00:00:00'),
	(50,'Телефон','','phone','lkey','type=s\r\nprint=1\r\nqview=1\r\nqedit=1\r\nrating=13\r\ntable_list=4\r\ntable_list_width=100\r\nregister=1\r\n','0000-00-00 00:00:00'),
	(51,'Настройки','','data','lkey','type=code\r\nsys=1\r\n','0000-00-00 00:00:00'),
	(39,'Рейтинг','','rating','lkey','type=d\r\ngroup=1\r\nqview=1\r\nqedit=1\r\ntable_list=4\r\ntable_list_name=Rt\r\ntable_list_width=32\r\nrating=6\r\nshablon_w=field_rating\r\n','0000-00-00 00:00:00'),
	(16,'Действие','','do','lkey','type=s\r\nsys=1\r\n','0000-00-00 00:00:00'),
	(54,'Дата последней авторизации','','vdate','lkey','type=time\r\nprint=1\r\ntable_list=9\r\ntable_list_width=100\r\nshablon_w=field_input_read\r\n','0000-00-00 00:00:00'),
	(55,'Пароль','','password','lkey','type=s\r\nprint=1\r\nrating=10\r\nregister=1\r\nobligatory=1\r\n\r\n','0000-00-00 00:00:00'),
	(56,'E-mail','','email','lkey','type=email\r\nprint=1\r\nqview=1\r\nrating=15\r\ntable_list=6\r\ntable_list_width=100\r\nregister=1\r\nobligatory=1\r\n','0000-00-00 00:00:00'),
	(58,'Компания','','company','lkey','type=s\r\nprint=1\r\nqview=1\r\nqedit=1\r\nrating=16\r\nfileview=1\r\n','0000-00-00 00:00:00'),
	(60,'Менеджер','','id_manager','lkey','type=tlist\r\nlist=data_projects_managers\r\nprint=1\r\nqview=1\r\nqedit=1\r\nfileview=1\r\ntable_list=5\r\ntable_list_width=150\r\nrating=20\r\nfilter=1\r\n','0000-00-00 00:00:00'),
	(61,'Должность','','post','lkey','type=s\r\nprint=1\r\nqview=1\r\nqedit=1\r\nrating=15\r\nfileview=1\r\n','0000-00-00 00:00:00'),
	(62,'Имя','','fname','lkey','type=s\r\nprint=1\r\nqview=1\r\nqedit=1\r\nrating=3\r\nfileview=1\r\ntable_list=3\r\ntable_list_width=100\r\n\r\n','0000-00-00 00:00:00'),
	(63,'Отчество','','mname','lkey','type=s\r\nprint=1\r\nqview=1\r\nqedit=1\r\nrating=4\r\nfileview=1\r\ntable_list=4\r\ntable_list_width=100\r\n\r\n','0000-00-00 00:00:00'),
	(64,'Копировать запись','','copy','button','type_link=loadcontent\nprint_info=1\nedit_info=1\ncontroller=users\naction=copy\nloading_msg=1\nimageiconmenu=/admin/img/icons/menu/icon_copy.png\ntitle=Копировать запись\nrating=5\nparams=replaceme,index,list_table','0000-00-00 00:00:00');

/*!40000 ALTER TABLE `keys_users` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table keys_vars
# ------------------------------------------------------------

DROP TABLE IF EXISTS `keys_vars`;

CREATE TABLE `keys_vars` (
  `ID` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL DEFAULT '',
  `tbl` varchar(64) NOT NULL DEFAULT '',
  `lkey` varchar(64) NOT NULL DEFAULT '',
  `object` varchar(8) NOT NULL DEFAULT '',
  `settings` text NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `tbl` (`tbl`,`lkey`,`object`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Ключи к модулю Vars';

LOCK TABLES `keys_vars` WRITE;
/*!40000 ALTER TABLE `keys_vars` DISABLE KEYS */;

INSERT INTO `keys_vars` (`ID`, `name`, `tbl`, `lkey`, `object`, `settings`, `updated_at`)
VALUES
	(3,'Список переменных','','list_link','button','type_link=loadcontent\r\nadd_info=1\r\ncontroller=vars\r\nimageiconmenu=/admin/img/icons/menu/button.list.png\r\naction=enter\r\ntitle=Список переменных\r\nrating=1\r\nparams=replaceme','0000-00-00 00:00:00'),
	(4,'Глобальные переменные. Очистка фильтра','','filter_clear','button','type_link=loadcontent\r\ntable_list=1\r\ncontroller=vars\r\naction=filter_clear\r\nimageiconmenu=/admin/img/icons/menu/icon_nofilter.png\r\ntitle=Снять фильтры\r\nrating=3\r\nparams=replaceme','0000-00-00 00:00:00'),
	(5,'Глобальные переменные. Фильтр','','filter','button','type_link=modullink\r\ntable_list=1\r\ncontroller=vars\r\naction=filter\r\nimageiconmenu=/admin/img/icons/menu/icon_filter.png\r\ntitle=Настроить фильтр\r\nwidth=690\r\nheight=510\r\nlevel=3\r\nrating=2\r\nparams=replaceme','0000-00-00 00:00:00'),
	(6,'Закончить редактирование','','end_link','button','type_link=loadcontent\r\nedit_info=1\r\ncontroller=vars\r\nimageiconmenu=/admin/img/icons/menu/icon_ok.png\r\naction=info\r\ntitle=Закончить редактирование\r\nrating=10\r\nparams=replaceme,index','0000-00-00 00:00:00'),
	(7,'Редактировать запись','','edit_link','button','type_link=loadcontent\r\nprint_info=1\r\ncontroller=vars\r\naction=edit\r\nimageiconmenu=/admin/img/icons/menu/icon_edit.png\r\ntitle=Редактировать запись\r\nrating=2\r\nparams=replaceme,index','0000-00-00 00:00:00'),
	(8,'Удалить запись','','del_link','button','type_link=loadcontent\r\ncontroller=vars\r\naction=delete\r\nimageiconmenu=/admin/img/icons/menu/icon_delete.png\r\nconfirm=Действительно удалить запись?\r\ntitle=Удалить запись\r\nprint_info=1\r\nrating=1\r\nparams=replaceme,index','0000-00-00 00:00:00'),
	(10,'Добавить запись','','add_link','button','type_link=openpage\nposition=center\nid=newentry\r\ntable_list=1\r\ncontroller=vars\r\nimageiconmenu=/admin/img/icons/menu/icon_add.png\r\naction=add\r\ntitle=Добавить запись\r\nrating=1\r\nparams=replaceme','0000-00-00 00:00:00'),
	(11,'Название','','name','lkey','type=s\nrating=1\ntable_list=1\nrequired=1\nqedit=1\nqview=1\nhelp=Название переменной для удобства поиска','2010-10-27 17:54:27'),
	(12,'Программа (модуль)','','id_program','lkey','type=tlist\nlist=sys_program\nrating=2\ntable_list=2\nqedit=1\nqview=1\nfilter=1\nhelp=Программный модуль, для которого действует данная переменная. Если программа не указана, то переменная является глобальной','2010-10-27 17:54:27'),
	(13,'Ключ переменной','','envkey','lkey','type=s\nrating=3\ntable_list=3\nrequired=1\nqedit=1\nqview=1\nhelp=Ключ переменной, по которому можно вызвать данную переменную в шаблоне или программе.','2010-10-27 17:54:27'),
	(14,'Значение','','envvalue','lkey','type=code\r\nrating=5\r\nmax=99999\r\n','2010-10-27 17:54:27'),
	(17,'Комментарий','','comment','lkey','type=code\r\nrating=10\r\n','2010-10-27 17:54:27'),
	(18,'Доступно для групп','','groups_list','lkey','type=tlist\r\nlist=lst_group_user\r\ngroup=1\r\nrating=129\r\ndefault=6\r\nshablon_w=field_multselect\r\nnotnull=1\r\nhelp=Группы пользователей, которые могут изменять данную переменную','2010-10-27 17:54:27'),
	(25,'Глобальные переменные','','vars','menu','type_link=loadcontent\r\naction=enter\r\nprogram=/cgi-bin/vars_a.cgi\r\nrating=22\r\nparentid=setting\r\nreplaceme=replaceme\r\nsubmenuwidth=200','0000-00-00 00:00:00'),
	(26,'Доступно для пользователей','','users_list','lkey','type=tlist\r\nlist=sys_users\r\ngroup=1\r\nrating=128\r\nmult=5\r\nshablon_w=field_multselect\r\nnotnull=1\r\nhelp=Пользователи, которые могут изменять данную переменную','0000-00-00 00:00:00'),
	(27,'Параметры поля','','settings','lkey','type=code\r\nrating=4\r\n\r\n','0000-00-00 00:00:00'),
	(28,'Копировать запись','','copy','button','type_link=loadcontent\nprint_info=1\nedit_info=1\ncontroller=vars\naction=copy\nloading_msg=1\nimageiconmenu=/admin/img/icons/menu/icon_copy.png\ntitle=Копировать запись\nrating=5\nparams=replaceme,index,list_table','0000-00-00 00:00:00');

/*!40000 ALTER TABLE `keys_vars` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table keys_video
# ------------------------------------------------------------

DROP TABLE IF EXISTS `keys_video`;

CREATE TABLE `keys_video` (
  `ID` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL DEFAULT '',
  `tbl` varchar(64) NOT NULL DEFAULT '',
  `lkey` varchar(64) NOT NULL DEFAULT '',
  `object` varchar(8) NOT NULL DEFAULT '',
  `settings` text NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `tbl` (`tbl`,`lkey`,`object`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Ключи к модулю Видео';

LOCK TABLES `keys_video` WRITE;
/*!40000 ALTER TABLE `keys_video` DISABLE KEYS */;

INSERT INTO `keys_video` (`ID`, `name`, `tbl`, `lkey`, `object`, `settings`, `updated_at`)
VALUES
	(1,'Добавить запись','','add_link','button','type_link=loadcontent\r\ntable_list=1\r\nprint_info=1\r\ntable_list_dir=1\r\nprogram=/cgi-bin/portfolio_a.cgi\r\nimageiconmenu=/admin/img/icons/menu/icon_add.png\r\naction=add\r\ntitle=Добавить\r\nrating=1\r\nparams=replaceme,list_table','0000-00-00 00:00:00'),
	(2,'Удалить запись','','del_link','button','type_link=loadcontent\r\nprogram=/cgi-bin/portfolio_a.cgi\r\naction=delete\r\nconfirm=Действительно удалить запись?\r\ntitle=Удалить запись\r\nimageiconmenu=/admin/img/icons/menu/icon_delete.png\r\nprint_info=1\r\nrating=1\r\nparams=replaceme,index,list_table','0000-00-00 00:00:00'),
	(3,'Редактировать запись','','edit_link','button','type_link=loadcontent\r\nprint_info=1\r\nprogram=/cgi-bin/portfolio_a.cgi\r\nimageiconmenu=/admin/img/icons/menu/icon_edit.png\r\naction=edit\r\ntitle=Редактировать запись\r\nrating=2\r\nparams=replaceme,index,list_table','0000-00-00 00:00:00'),
	(4,'Закончить редактирование','','end_link','button','type_link=loadcontent\r\nedit_info=1\r\nprogram=/cgi-bin/portfolio_a.cgi\r\naction=info\r\nimageiconmenu=/admin/img/icons/menu/icon_ok.png\r\ntitle=Закончить редактирование\r\nrating=1\r\nparams=replaceme,index,list_table\r\n','0000-00-00 00:00:00'),
	(5,'Фильтр','','filter','button','type_link=modullink\r\ntable_list=1\r\ntable_list_orders=1\r\ntable_list_dir=1\r\nprogram=/cgi-bin/portfolio_a.cgi\r\nimageiconmenu=/admin/img/icons/menu/icon_filter.png\r\naction=filter\r\ntitle=Фильтр\r\nwidth=690\r\nheight=510\r\nlevel=3\r\nrating=2\r\nparams=replaceme,list_table','0000-00-00 00:00:00'),
	(6,'Очистка фильтра','','filter_clear','button','type_link=loadcontent\r\ntable_list=1\r\ntable_list_orders=1\r\ntable_list_dir=1\r\nprogram=/cgi-bin/portfolio_a.cgi\r\nimageiconmenu=/admin/img/icons/menu/icon_nofilter.png\r\naction=filter_clear\r\ntitle=Снять фильтры\r\nrating=3\r\nparams=replaceme,list_table','0000-00-00 00:00:00'),
	(7,'Наименование','','name','lkey','type=s\nfilter=1\ngroup=1\nrating=1\nrequired=1\nqedit=1\ntable_list=1\nno_format=1\nfileview=1\ndirview=1','2011-12-07 14:34:14'),
	(8,'Артикул','','articul','lkey','type=s\r\nfilter=1\r\nrating=3\r\nprint=1\r\nqview=1\r\nqedit=1\r\nfileview=1\r\ngroup=1\r\ntable_list=5\r\n\r\n','2011-09-28 18:45:41'),
	(19,'Показывать на сайте','','active','lkey','type=chb\r\nrating=99\r\ngroup=1\r\ntable_list=12\r\ntable_list_name=-\r\ntable_list_width=48\r\nyes=виден\r\nno=скрыт\r\nfilter=1\r\ndirview=1\r\nfileview=1\r\nhelp=Если видео требуется временно скрыть, просто установите данный флажок.','2011-12-07 14:34:14'),
	(97,'Модель','data_catalog_items','name','lkey','type=s\r\nfilter=1\r\ngroup=1\r\nrating=1\r\nrequired=1\r\nqedit=1\r\ntable_list=1\r\nno_format=1\r\nfileview=1\r\n','2011-10-24 16:41:25'),
	(21,'Рейтинг','','rating','lkey','type=d\nrating=90\nprint=1\nfileview=1\ngroup=1\ntable_list=7\nqedit=1\ntable_list_name=Rt\ntable_list_width=32\nshablon_w=field_rating\ndirview=1','2011-12-07 14:34:14'),
	(22,'Фото','','pict','lkey','type=pict\nrating=24\ntable_list=10\ntable_list_name=-\ntable_list_type=pict\nfolder=/images/video/\ntable_list_nosort=1\nshablon_w=field_pict\nshablon_r=field_pict_read\nsizelimit=20000\nmini=547x294~crop,297x168~crop\next=*.jpg;*.jpeg;*.gif;*.tif\nfileview=1\nhelp=Загрузите изображение на сервер','2014-05-20 19:38:52'),
	(23,'Файл','','filename','lkey','type=filename\r\nrating=3\r\nsizelimit=200000\r\nfile_ext=*.*\r\nhelp=Для загрузки файла нажмите на кнопку <b>Выбрать</b>','2011-12-07 14:34:13'),
	(24,'Тип файла','','type_file','lkey','type=slat\r\nsys=1','2011-04-08 01:12:56'),
	(109,'Видео','','videofile','lkey','type=filename\r\nrating=14\r\nshablon_w=field_file\r\nshablon_r=field_file_link\r\nsizelimit=20000\r\nfile_ext=*.*\r\nfileview=1\r\ntable_list=2\r\n','2011-12-05 19:19:18'),
	(26,'Фото','','images','lkey','type=table\r\ntable=dtbl_images\r\ngroup=3\r\nrating=301\r\ntable_fields=type_file,name,folder,pict,rating,rdate\r\ntable_svf=id_data_catalog\r\ntable_sortfield=name\r\ntable_buttons_key_w=delete_select,edit\r\ntable_buttons_key_r=upload\r\ntable_groupname=Информация по файлу\r\ntable_upload=1\r\ntable_icontype=1\r\ntable_noindex=1\r\nshablon_w=field_table\r\nshablon_r=field_table','2011-04-08 01:12:56'),
	(29,'Описание','','text','lkey','type=html\r\nrating=90\r\ngroup=1\r\ncktoolbar=Basic\r\n','2011-08-05 15:17:31'),
	(33,'Дата','','rdate','lkey','type=time\r\nrating=6\r\nprint=1\r\nqview=1\r\nsys=1\r\n\r\n','2011-04-08 01:12:56'),
	(101,'Алиас','','alias','lkey','type=s\nrating=3\ntable_list=2\ntable_list_width=70\ngroup=1\nqview=1\nqedit=1\nhelp=Короткое латинское название, используется для формирование url на эту страницу\ndirview=1\nrequired=1\n','2011-12-07 14:34:14'),
	(42,'Цена','','price','lkey','type=s\r\nprint=1\r\ngroup=1\r\nrating=17\r\ntable_list=4\r\ntable_list_width=70\r\nqview=1\r\nqedit=1\r\n\r\n','2011-12-05 18:13:01'),
	(54,'Показывать на сайте','','active','list','list=0|Нет~1|Да\r\ntype=radio\r\n','0000-00-00 00:00:00'),
	(61,'Список','','list_link','button','type_link=loadcontent\r\n#add_info=1\r\n#print_info=1\r\nprogram=/cgi-bin/portfolio_a.cgi\r\nimageiconmenu=/admin/img/icons/menu/button.list.png\r\naction=enter\r\ntitle=Список\r\nrating=1\r\nparams=replaceme,list_table','0000-00-00 00:00:00'),
	(103,'Группа','','id_group','lkey','type=tlist\r\nlist=data_portfolio_groups\r\nprint=1\r\nqview=1\r\nfilter=1\r\nrating=3\r\ntable_list=4\r\ntable_list_width=100\r\nrequired=1\r\n','2011-12-07 14:34:14'),
	(110,'Ссылка на видео YouTube','','youtubelink','lkey','type=s\r\nprint=1\r\nqview=1\r\nqedit=1\r\nrating=10\r\ntable_list=4\r\ntable_list_width=100\r\nfileview=1\nhelp=Укажите ID или полную ссылку на видео\r\n','2011-12-07 14:34:14'),
	(111,'Вложена в папку','','id_video','lkey','type=tlist\nlist=data_video\nprint=1\nqview=1\nqedit=1\nfileview=1\nfilter=1\nwhere= AND `dir`=\'1\'  AND `id_video`=0 \nrating=10\ntable_list=3\ntable_list_width=200\n','0000-00-00 00:00:00'),
	(112,'Папка','','dir','lkey','type=chb\ngroup=1\nrating=6\ntable_list=1\ntable_list_name=-\ntable_list_nosort=1\ntable_list_width=16\nyes=<img src=\"/admin/img/dtree/folder.gif\">\nno=<img src=\"/admin/img/dtree/doc.gif\">\nfilter=1\ndirview=1\nfileview=1','0000-00-00 00:00:00'),
	(113,'Видео. Добавить папку','','add_link_dir','button','type_link=loadcontent\r\ntable_list=1\r\ncontroller=video\r\nimageiconmenu=/admin/img/icons/menu/icon_dir_add.png\r\naction=add_dir\r\ntitle=Создать папку\r\nparams=replaceme\r\nrating=1\n','0000-00-00 00:00:00'),
	(114,'Описание','','description','lkey','type=text\r\nrating=90\r\ngroup=1\r\ndirview=1\nfileview=1\nqview=1\nqedit=1\n','0000-00-00 00:00:00'),
	(115,'Датировать датой','','tdate','lkey','type=date\r\nrating=50\r\ngroup=1\r\nqview=1\r\nfilter=1\r\ndirview=1\r\ntable_list=8\r\ntable_list_width=70\r\ntemplate_f=field_date_filter','2010-10-27 11:04:12'),
	(116,'Показывать на главной странице','','has_mainpage','lkey','type=chb\nprint=1\nqview=1\nqedit=1\nfilter=1\nrating=99\ntable_list=10\ntable_list_width=70\nyes=да\nno=нет\ndirview=1\n','0000-00-00 00:00:00'),
	(117,'Категория','','id_category','lkey','type=tlist\nlist=lst_media_groups\nprint=1\nqview=1\nfilter=1\nadd_to_list=1\nwin_scroll=0\nwin_height=100\nrating=5\n','2014-05-20 20:40:16'),
	(118,'Ссылка на видео Vimeo','','vimeolink','lkey','type=s\r\nprint=1\r\nqview=1\r\nqedit=1\r\nrating=11\r\ntable_list=5\r\ntable_list_width=100\r\nfileview=1\nhelp=Укажите ID или полную ссылку на видео\r\n','2011-12-07 14:34:14');

/*!40000 ALTER TABLE `keys_video` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table lst_banner_urls
# ------------------------------------------------------------

DROP TABLE IF EXISTS `lst_banner_urls`;

CREATE TABLE `lst_banner_urls` (
  `ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table lst_catalog_list
# ------------------------------------------------------------

DROP TABLE IF EXISTS `lst_catalog_list`;

CREATE TABLE `lst_catalog_list` (
  `ID` int(6) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

LOCK TABLES `lst_catalog_list` WRITE;
/*!40000 ALTER TABLE `lst_catalog_list` DISABLE KEYS */;

INSERT INTO `lst_catalog_list` (`ID`, `name`)
VALUES
	(1,'вавыа'),
	(2,'вавыа'),
	(3,'ропо'),
	(4,'пропропро');

/*!40000 ALTER TABLE `lst_catalog_list` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table lst_group_user
# ------------------------------------------------------------

DROP TABLE IF EXISTS `lst_group_user`;

CREATE TABLE `lst_group_user` (
  `ID` tinyint(3) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(32) NOT NULL DEFAULT '',
  PRIMARY KEY (`ID`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Группы пользователей';

LOCK TABLES `lst_group_user` WRITE;
/*!40000 ALTER TABLE `lst_group_user` DISABLE KEYS */;

INSERT INTO `lst_group_user` (`ID`, `name`)
VALUES
	(1,'Заблокированные'),
	(3,'Администраторы'),
	(6,'Системные администраторы');

/*!40000 ALTER TABLE `lst_group_user` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table lst_images
# ------------------------------------------------------------

DROP TABLE IF EXISTS `lst_images`;

CREATE TABLE `lst_images` (
  `ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL DEFAULT '',
  `key_razdel` varchar(32) NOT NULL DEFAULT '',
  `groups_list` varchar(255) NOT NULL DEFAULT '',
  `users_list` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`ID`),
  UNIQUE KEY `key_razdel` (`key_razdel`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Разделы базы изображений';

LOCK TABLES `lst_images` WRITE;
/*!40000 ALTER TABLE `lst_images` DISABLE KEYS */;

INSERT INTO `lst_images` (`ID`, `name`, `key_razdel`, `groups_list`, `users_list`)
VALUES
	(1,'Галерея','gallery','3=6','');

/*!40000 ALTER TABLE `lst_images` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table lst_layouts
# ------------------------------------------------------------

DROP TABLE IF EXISTS `lst_layouts`;

CREATE TABLE `lst_layouts` (
  `ID` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `layout` varchar(255) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `lst_layouts` WRITE;
/*!40000 ALTER TABLE `lst_layouts` DISABLE KEYS */;

INSERT INTO `lst_layouts` (`ID`, `name`, `layout`)
VALUES
	(1,'Основной шаблон страницы','default'),
	(2,'Основной шаблон главной страницы','main');

/*!40000 ALTER TABLE `lst_layouts` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table lst_texts
# ------------------------------------------------------------

DROP TABLE IF EXISTS `lst_texts`;

CREATE TABLE `lst_texts` (
  `ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL DEFAULT '',
  `key_razdel` varchar(32) NOT NULL DEFAULT '',
  `listf` varchar(255) NOT NULL DEFAULT '',
  `ru` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `en` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `groups_list` varchar(255) NOT NULL DEFAULT '',
  `users_list` varchar(255) NOT NULL DEFAULT '',
  `rating` smallint(5) unsigned NOT NULL DEFAULT '99',
  PRIMARY KEY (`ID`),
  UNIQUE KEY `key_razdel` (`key_razdel`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Разделы текстовой базы';

LOCK TABLES `lst_texts` WRITE;
/*!40000 ALTER TABLE `lst_texts` DISABLE KEYS */;

INSERT INTO `lst_texts` (`ID`, `name`, `key_razdel`, `listf`, `ru`, `en`, `groups_list`, `users_list`, `rating`)
VALUES
	(1,'Основные тексты','main','ID,name,alias,rating,edate,rdate',1,0,'3=6','',1),
	(8,'Новости','news','ID,name,tdate,rdate',1,0,'3=6','',2);

/*!40000 ALTER TABLE `lst_texts` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table sys_access
# ------------------------------------------------------------

DROP TABLE IF EXISTS `sys_access`;

CREATE TABLE `sys_access` (
  `ID` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `modul` int(6) unsigned NOT NULL DEFAULT '0',
  `objecttype` varchar(32) NOT NULL DEFAULT '',
  `objectname` text NOT NULL,
  `id_group_user` smallint(5) unsigned NOT NULL DEFAULT '0',
  `users` varchar(32) NOT NULL DEFAULT '',
  `r` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `w` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `d` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `cck` varchar(255) NOT NULL DEFAULT '',
  `updated_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `id_group_user` (`id_group_user`),
  KEY `users` (`users`),
  KEY `object_type` (`objecttype`),
  KEY `modul` (`modul`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Правила политики безопасности';

LOCK TABLES `sys_access` WRITE;
/*!40000 ALTER TABLE `sys_access` DISABLE KEYS */;

INSERT INTO `sys_access` (`ID`, `modul`, `objecttype`, `objectname`, `id_group_user`, `users`, `r`, `w`, `d`, `cck`, `updated_at`, `created_at`)
VALUES
	(1,0,'table','data_banner=data_catalog_items=data_faq=data_feedback=data_seo_meta=data_subscribe=data_users=dtbl_banner_stat=dtbl_catalog_items_images=dtbl_subscribe_stat=dtbl_subscribe_users=images_gallery=lst_catalog_list=texts_main_ru=texts_news_ru',6,'',1,1,1,'11eahKQhgdxuE','2014-02-26 23:49:24','2011-10-29 20:24:44'),
	(2,0,'table','lst_group_user=lst_images=lst_texts',6,'',1,0,0,'01dgKPEiFI6/2','2012-11-16 15:13:07','2011-10-29 20:26:15'),
	(6,61,'lkey','link=author=alias=anons=texts_main=id_data_video=rss=year=texts_articles=texts_news=texts_docfiles=tdate=adate=day=docfile=title=stars=pict=keywords=description=month=url_for=name=id_news=viewtext=dir=razdel=size=rating=place=text=type_file=filename=image_gallery=price=page_shablon=menu=nomap',6,'',1,1,1,'11GmsOurPH43E','2012-07-13 16:03:10','2011-10-29 21:15:12'),
	(19,61,'lkey','delnot',6,'',1,0,0,'01P0T8Mc0zYlY','2012-07-13 16:03:33','2012-07-13 20:03:17'),
	(20,61,'button','add_link=end_link=filter_clear=edit_link=list_link=add_link_dir=del_link=filter',6,'',1,0,0,'01LhT0dObGc5Q','2012-09-18 12:30:26','2012-07-13 20:03:37'),
	(4,0,'modul','68=62=4=60=32=12=67=3=61=69',6,'',1,1,1,'11s2YJBHWDjEE','2014-02-26 23:49:52','2011-10-29 20:28:46'),
	(5,32,'menu','object',6,'',1,0,0,'01Ge2NaUJAgWw','2014-03-01 13:40:43','2011-10-29 20:31:26'),
	(8,32,'button','seo=logout=vars=catalog=admin=syslogs=lists=texts=sysusers=filemanager',6,'',1,0,0,'01GXuIo7CPjF2','2014-02-26 23:50:17','2011-10-29 23:02:02'),
	(9,3,'button','add_link=end_link=list_link=filter_clear=filter',6,'0',1,0,0,'00PHiAWCKowyo','2011-11-28 12:34:30','2011-11-28 16:34:19'),
	(10,3,'lkey','ulclass=email=max=weight=height=id_city=id_group_user=key_razdel=login=name=id_vilage=min=active=password=id_docfiles_subrubrics=users=id_recall=id_project=id_region=rating=id_rubrics=id_docfiles_rubrics=listf=link=per_click=per_show=id_countries=text=foto1=foto2=foto3=id_equipimg=id_images=width',6,'0',1,1,1,'10CSi38DZVS8Q','2011-11-28 12:34:43','2011-11-28 16:34:35'),
	(11,62,'button','add_link=end_link=filter_clear=edit_link=list_link=del_link=filter',6,'0',1,0,0,'00OrpeYwtHQqw','2011-11-28 12:35:19','2011-11-28 16:35:08'),
	(12,62,'lkey','ip_data_click=link=cash=time=height=tdate=showdateend=showdatefirst=week=titlelink=docfile=code=click_count=view_count=id_advert_block=name=view=target=size=rating=id_advert_users=click_pay=view_pay=list_page=stat=textlink=type_show=type_file=filename=width=texts_main_ru',6,'0',1,1,1,'10b/ML8RsME06','2011-11-28 12:35:28','2011-11-28 16:35:23'),
	(13,4,'button','filter_clear=filter=end_link=edit_link=list_link',6,'0',1,0,0,'00JoMr.WsBzOk','2011-11-28 12:35:51','2011-11-28 16:35:35'),
	(14,4,'lkey','envvalue',6,'0',1,1,1,'10L5lVbsabVEw','2011-11-28 12:36:44','2011-11-28 16:35:54'),
	(15,4,'lkey','groups_list=users_list=set_def=name=help=id_program',6,'0',1,0,0,'00E1Cs1WHkPlk','2011-11-28 12:37:12','2011-11-28 16:36:47'),
	(16,12,'button','add_link=end_link=edit_link=list_link=del_link=filter_clear=filter',6,'0',1,0,0,'00hg4dUwyLVF6','2011-11-28 12:52:25','2011-11-28 16:52:13'),
	(17,12,'lkey','email=groups_list=users_list=bip=name=login=password=ip',6,'',1,1,1,'11aFreujZ8rDE','2012-10-08 18:34:33','2011-11-28 16:52:28'),
	(18,12,'lkey','id_group_user=vdate=bip=btime=count=ip',6,'',1,0,0,'01ojkmyuN8xjE','2012-10-08 18:34:46','2011-11-28 16:53:34'),
	(21,32,'lkey','alias=index=do',6,'',1,1,1,'11XApzbNH3SWc','2013-06-24 15:17:31','2013-06-24 19:16:58'),
	(22,68,'lkey','name=keywords=description=url',6,'',1,1,1,'11NiQehBWD2/s','2014-02-26 23:48:07','2014-02-26 23:47:58'),
	(23,68,'button','add_link=end_link=filter_clear=edit_link=del_link=filter',6,'',1,0,0,'01R/7Kl.SZGUs','2014-02-26 23:48:17','2014-02-26 23:48:11'),
	(24,69,'lkey','',6,'',1,1,1,'11rxcFz2cFY.s','2014-02-26 23:48:35','2014-02-26 23:48:23'),
	(25,67,'lkey','ip=id_sysusergroup=rdate=name=comment=id_program=id_sysuser=eventtype',6,'',1,1,1,'11r/RMyKgBSi6','2014-02-26 23:48:53','2014-02-26 23:48:44'),
	(26,67,'button','list_link=del_link=filter_clear=filter',6,'',1,0,0,'019dlmqGQs2Co','2014-02-26 23:49:04','2014-02-26 23:48:57');

/*!40000 ALTER TABLE `sys_access` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table sys_blockip
# ------------------------------------------------------------

DROP TABLE IF EXISTS `sys_blockip`;

CREATE TABLE `sys_blockip` (
  `ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `ip` varchar(15) NOT NULL DEFAULT '',
  `block` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `ip` (`ip`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Заблокированные IP';



# Dump of table sys_changes
# ------------------------------------------------------------

DROP TABLE IF EXISTS `sys_changes`;

CREATE TABLE `sys_changes` (
  `ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `list_table` varchar(255) DEFAULT '0',
  `item_id` int(10) unsigned NOT NULL,
  `lkey` varchar(255) DEFAULT '0',
  `value` text,
  `operator` varchar(255) DEFAULT '',
  `created_at` datetime DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='История изменений';

LOCK TABLES `sys_changes` WRITE;
/*!40000 ALTER TABLE `sys_changes` DISABLE KEYS */;

INSERT INTO `sys_changes` (`ID`, `list_table`, `item_id`, `lkey`, `value`, `operator`, `created_at`)
VALUES
	(1,'texts_main_ru',1,'delnot','1','root','2015-04-18 16:49:30'),
	(2,'texts_main_ru',1,'name','Главная страница12','root','2015-04-18 16:49:30'),
	(3,'texts_main_ru',1,'viewtext','1','root','2015-04-18 16:49:30'),
	(4,'texts_main_ru',1,'delnot','1','root','2015-04-18 16:49:31'),
	(5,'texts_main_ru',1,'viewtext','1','root','2015-04-18 16:49:31'),
	(6,'texts_main_ru',1,'map','30.70371840173565,59.80653669458297','root','2015-10-23 22:11:32'),
	(7,'texts_main_ru',1,'map','30.306511450195295,59.962397229791','root','2015-10-23 22:28:44'),
	(8,'texts_main_ru',1,'map','32.54400038728299,60.30253823600127','root','2015-10-23 22:34:40'),
	(9,'texts_main_ru',1,'map','30.91391450596179,59.99440099201628','root','2015-10-26 14:05:27'),
	(10,'texts_main_ru',1,'map','30.311444948013513,59.89919223879135','root','2015-10-26 14:07:33');

/*!40000 ALTER TABLE `sys_changes` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table sys_datalogs
# ------------------------------------------------------------

DROP TABLE IF EXISTS `sys_datalogs`;

CREATE TABLE `sys_datalogs` (
  `ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL DEFAULT '',
  `id_sysuser` int(6) unsigned DEFAULT NULL,
  `id_program` smallint(5) unsigned DEFAULT NULL,
  `id_sysusergroup` int(6) unsigned DEFAULT NULL,
  `ip` varchar(15) NOT NULL DEFAULT '',
  `comment` varchar(255) NOT NULL DEFAULT '',
  `eventtype` smallint(5) unsigned NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`),
  KEY `program` (`id_program`),
  KEY `login` (`id_sysuser`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Логи работы с панелью';

LOCK TABLES `sys_datalogs` WRITE;
/*!40000 ALTER TABLE `sys_datalogs` DISABLE KEYS */;

INSERT INTO `sys_datalogs` (`ID`, `name`, `id_sysuser`, `id_program`, `id_sysusergroup`, `ip`, `comment`, `eventtype`, `created_at`)
VALUES
	(31,'Обновление запись в Основные тексты » Тексты',1,61,6,'127.0.0.1','Обновление запись [1] «Главная страница123». Основные тексты » Тексты [texts_main_ru]',3,'2015-10-23 22:28:44'),
	(30,'Авторизация прошла успешно',1,61,6,'127.0.0.1','',5,'2015-10-23 22:18:54'),
	(29,'Обновление запись в Основные тексты » Тексты',1,61,6,'127.0.0.1','Обновление запись [1] «Главная страница123». Основные тексты » Тексты [texts_main_ru]',3,'2015-10-23 22:11:32'),
	(28,'Обновление запись в Основные тексты » Тексты',1,61,6,'127.0.0.1','Обновление запись [1] «Главная страница123». Основные тексты » Тексты [texts_main_ru]',3,'2015-10-23 22:01:33'),
	(25,'Авторизация прошла успешно',1,0,6,'127.0.0.1','',5,'2015-10-23 21:10:26'),
	(26,'Авторизация прошла успешно',1,0,6,'127.0.0.1','',5,'2015-10-23 21:13:54'),
	(27,'Авторизация прошла успешно',1,61,6,'127.0.0.1','',5,'2015-10-23 21:57:19'),
	(24,'Авторизация прошла успешно',1,0,6,'127.0.0.1','',5,'2015-10-23 20:47:45'),
	(21,'Авторизация прошла успешно',1,0,6,'127.0.0.1','',5,'2015-10-23 20:35:20'),
	(22,'Авторизация прошла успешно',1,0,6,'127.0.0.1','',5,'2015-10-23 20:36:07'),
	(23,'Авторизация прошла успешно',1,0,6,'127.0.0.1','',5,'2015-10-23 20:38:27'),
	(19,'Авторизация прошла успешно',1,0,6,'127.0.0.1','',5,'2015-10-23 19:55:37'),
	(20,'Авторизация прошла успешно',1,0,6,'127.0.0.1','',5,'2015-10-23 20:29:15'),
	(17,'Авторизация прошла успешно',1,0,6,'127.0.0.1','',5,'2015-10-23 19:46:18'),
	(18,'Авторизация прошла успешно',1,0,6,'127.0.0.1','',5,'2015-10-23 19:46:54'),
	(16,'Добавление запись в Ключи',1,6,6,'127.0.0.1','Добавление запись [189] «Карта». Ключи [keys_texts]',1,'2015-10-23 19:45:01'),
	(14,'Авторизация прошла успешно',1,0,6,'127.0.0.1','',5,'2015-10-23 19:37:45'),
	(15,'Авторизация прошла успешно',1,0,6,'127.0.0.1','',5,'2015-10-23 19:41:28'),
	(32,'Обновление запись в Основные тексты » Тексты',1,61,6,'127.0.0.1','Обновление запись [1] «Главная страница123». Основные тексты » Тексты [texts_main_ru]',3,'2015-10-23 22:34:41'),
	(33,'Авторизация прошла успешно',1,0,6,'127.0.0.1','',5,'2015-10-26 12:51:06'),
	(34,'Авторизация прошла успешно',1,61,6,'127.0.0.1','',5,'2015-10-26 13:41:35'),
	(35,'Авторизация прошла успешно',1,0,6,'127.0.0.1','',5,'2015-10-26 13:46:39'),
	(36,'Авторизация прошла успешно',1,0,6,'127.0.0.1','',5,'2015-10-26 13:59:03'),
	(37,'Обновление запись в Основные тексты » Тексты',1,61,6,'127.0.0.1','Обновление запись [1] «Главная страница123». Основные тексты » Тексты [texts_main_ru]',3,'2015-10-26 14:05:27'),
	(38,'Авторизация прошла успешно',1,0,6,'127.0.0.1','',5,'2015-10-26 14:06:06'),
	(39,'Обновление запись в Основные тексты » Тексты',1,61,6,'127.0.0.1','Обновление запись [1] «Главная страница123». Основные тексты » Тексты [texts_main_ru]',3,'2015-10-26 14:07:33'),
	(40,'Авторизация прошла успешно',1,0,6,'127.0.0.1','',5,'2015-10-26 15:39:15'),
	(41,'Авторизация прошла успешно',1,0,6,'127.0.0.1','',5,'2015-10-26 18:26:07'),
	(42,'Авторизация прошла успешно',1,0,6,'127.0.0.1','',5,'2015-11-05 15:38:26');

/*!40000 ALTER TABLE `sys_datalogs` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table sys_filemanager_cache
# ------------------------------------------------------------

DROP TABLE IF EXISTS `sys_filemanager_cache`;

CREATE TABLE `sys_filemanager_cache` (
  `hash` varchar(100) NOT NULL DEFAULT '',
  `info` blob,
  `updated` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`hash`),
  KEY `updated` (`updated`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `sys_filemanager_cache` WRITE;
/*!40000 ALTER TABLE `sys_filemanager_cache` DISABLE KEYS */;

INSERT INTO `sys_filemanager_cache` (`hash`, `info`, `updated`)
VALUES
	('gg_L0ltYWdlcy56aXA',X'65794A776147467A61434936496D646E58307833496977695A4746305A534936496B3176626942475A5749674D6A51674D5455364E4451364E446B674D6A41784E434973496E527A496A6F784D7A6B7A4D6A51794D6A67354C434A755957316C496A6F69535731685A32567A4C6E707063434973496E4E70656D55694F6A55784D44497A4D444D73496D6868633267694F694A6E5A31394D4D4778305756646B62474E354E545A68574545694C434A795A57466B496A6F784C434A33636D6C305A5349364D53776962576C745A534936496D4677634778705932463061573975584339366158416966512D2D','2014-06-11 08:36:34'),
	('gg_L2FwYTQuanBn',X'65794A30625749694F694A68634745304C6D70775A794973496E426F59584E6F496A6F695A326466544863694C434A6B5958526C496A6F695457397549455A6C596941794E4341784E546F304E446F304F5341794D4445304969776964484D694F6A457A4F544D794E4449794F446B73496D3568625755694F694A68634745304C6D70775A794973496E4E70656D55694F6A51774D4449794C434A6F59584E6F496A6F695A32646654444A4764316C5555585668626B4A7549697769636D56685A4349364D5377695A476C74496A6F694E44557765444D774D434973496E64796158526C496A6F784C434A746157316C496A6F69615731685A3256634C3270775A57636966512D2D','2014-06-11 08:36:34'),
	('gg_L2JvY2NhbGkyLmpwZw',X'65794A30625749694F694A6962324E6A595778704D693571634763694C434A776147467A61434936496D646E58307833496977695A4746305A534936496B3176626942475A5749674D6A51674D5455364E4451364E446B674D6A41784E434973496E527A496A6F784D7A6B7A4D6A51794D6A67354C434A755957316C496A6F69596D396A5932467361544975616E426E4969776963326C365A5349364F4455774E444573496D6868633267694F694A6E5A31394D4D6B703257544A4F61474A4861336C4D62584233576E63694C434A795A57466B496A6F784C434A6B615730694F6949344D4442344E6A41774969776964334A70644755694F6A4573496D3170625755694F694A706257466E5A567776616E426C5A794A39','2014-06-11 08:36:34'),
	('gg_L2ZvbGRlcg',X'65794A755957316C496A6F695A6D39735A475679496977695A476C79637949364D53776964484D694F6A45304D6A6B7A4E446B794D7A6773496E4E70656D55694F6A4173496E426F59584E6F496A6F695A326466544863694C434A746157316C496A6F695A476C795A574E3062334A35496977695A4746305A534936496C4E6864434242634849674D5467674D544D364D6A63364D5467674D6A41784E534973496E64796158526C496A6F784C434A795A57466B496A6F784C434A6F59584E6F496A6F695A32646654444A61646D4A48556D786A5A794A39','2015-04-18 12:34:25'),
	('gg_L2ZvbGRlci81NTU',X'65794A755957316C496A6F694E5455314969776964484D694F6A45304D6A6B7A4E446B794D546373496D5270636E4D694F6A4173496E426F59584E6F496A6F695A32646654444A61646D4A48556D786A5A794973496E4E70656D55694F6A4173496D3170625755694F694A6B61584A6C59335276636E6B694C434A6B5958526C496A6F695532463049454677636941784F4341784D7A6F794E6A6F314E7941794D4445314969776964334A70644755694F6A4573496D6868633267694F694A6E5A31394D4D6C7032596B645362474E704F44464F564655694C434A795A57466B496A6F7866512D2D','2015-04-18 12:34:27'),
	('gg_L2ZvbGRlci8xLjEx',X'65794A33636D6C305A5349364D537769636D56685A4349364D5377696147467A61434936496D646E58307779576E5A6952314A7359326B3465457871525867694C434A7A6158706C496A6F774C434A776147467A61434936496D646E58307779576E5A6952314A73593263694C434A6B5958526C496A6F695532463049454677636941784F4341784D7A6F784D546F794E6941794D4445314969776962576C745A534936496D5270636D566A6447397965534973496D5270636E4D694F6A4173496E527A496A6F784E4449354D7A51344D6A67324C434A755957316C496A6F694D5334784D534A39','2015-04-18 12:34:27'),
	('gg_L2ZvbGRlci8xMjMxMi4xMjMxMjM',X'65794A33636D6C305A5349364D537769636D56685A4349364D5377696147467A61434936496D646E58307779576E5A6952314A7359326B34654531715458684E615452345457704E6545317154534973496E4E70656D55694F6A4173496E426F59584E6F496A6F695A32646654444A61646D4A48556D786A5A794973496D5268644755694F694A545958516751584279494445344944457A4F6A41304F6A4978494449774D5455694C434A746157316C496A6F695A476C795A574E3062334A35496977695A476C79637949364D43776964484D694F6A45304D6A6B7A4E4463344E6A4573496D3568625755694F6949784D6A4D784D6934784D6A4D784D6A4D6966512D2D','2015-04-18 12:34:27'),
	('gg_L2ZvbGRlci8xMS5qcGc',X'65794A6F59584E6F496A6F695A32646654444A61646D4A48556D786A6154683454564D3163574E4859794973496E4A6C595751694F6A4573496E64796158526C496A6F784C434A6B5958526C496A6F69545739754945526C597941794D6941774D546F784E546F304F4341794D4445304969776962576C745A534936496D6C745957646C584339716347566E4969776963476868633267694F694A6E5A31394D4D6C7032596B645362474E6E4969776963326C365A5349364E5459324E6A59334C434A30625749694F6949784D533571634763694C434A30637949364D5451784F5445354E6A55304F4377695A476C74496A6F694D546B794D4867784D6A417749697769626D46745A534936496A45784C6D70775A794A39','2015-04-18 12:34:27'),
	('gg_L2ZvbGRlci8xMTEuMTExMQ',X'65794A755957316C496A6F694D5445784C6A45784D5445694C434A6B61584A7A496A6F774C434A30637949364D5451794F544D304F444D344D5377695A4746305A534936496C4E6864434242634849674D5467674D544D364D544D364D4445674D6A41784E534973496D3170625755694F694A6B61584A6C59335276636E6B694C434A7A6158706C496A6F774C434A776147467A61434936496D646E58307779576E5A6952314A73593263694C434A795A57466B496A6F784C434A6F59584E6F496A6F695A32646654444A61646D4A48556D786A6154683454565246645531555258684E55534973496E64796158526C496A6F7866512D2D','2015-04-18 12:34:27'),
	('gg_L2ZvbGRlci8y',X'65794A755957316C496A6F694D694973496D5270636E4D694F6A4173496E527A496A6F784E4449354D7A51334E7A6B7A4C434A7A6158706C496A6F774C434A776147467A61434936496D646E58307779576E5A6952314A73593263694C434A746157316C496A6F695A476C795A574E3062334A35496977695A4746305A534936496C4E6864434242634849674D5467674D544D364D444D364D544D674D6A41784E534973496E64796158526C496A6F784C434A795A57466B496A6F784C434A6F59584E6F496A6F695A32646654444A61646D4A48556D786A61546835496E302D','2015-04-18 12:34:27'),
	('gg_L2ZvbGRlci8yL0FyY2hpdmUxLnppcA',X'65794A776147467A61434936496D646E58307779576E5A6952314A7359326B3465534973496D5268644755694F694A4E62323467526D566949444533494449794F6A457A4F6A4D32494449774D5451694C434A30637949364D544D354D6A59324D4467784E697769626D46745A534936496B467959326870646D55784C6E707063434973496E4E70656D55694F6A51784E7A51324C434A6F59584E6F496A6F695A32646654444A61646D4A48556D786A615468355444424765566B796148426B625656345447357763474E4249697769636D56685A4349364D53776964334A70644755694F6A4573496D3170625755694F694A686348427361574E6864476C76626C7776656D6C77496E302D','2014-04-19 10:26:48'),
	('gg_L2ZvbGRlci8yL0FyY2hpdmUyLnppcA',X'65794A776147467A61434936496D646E58307779576E5A6952314A7359326B3465534973496D5268644755694F694A4E62323467526D566949444533494449794F6A457A4F6A4D32494449774D5451694C434A30637949364D544D354D6A59324D4467784E697769626D46745A534936496B467959326870646D55794C6E707063434973496E4E70656D55694F6A49314F5445784C434A6F59584E6F496A6F695A32646654444A61646D4A48556D786A615468355444424765566B796148426B625656355447357763474E4249697769636D56685A4349364D53776964334A70644755694F6A4573496D3170625755694F694A686348427361574E6864476C76626C7776656D6C77496E302D','2014-04-19 10:26:48'),
	('gg_L2ZvbGRlci8yL2FwYTcuanBn',X'65794A30625749694F694A68634745334C6D70775A794973496E426F59584E6F496A6F695A32646654444A61646D4A48556D786A61546835496977695A4746305A534936496B3176626942475A5749674D5463674D6A49364D544D364D7A59674D6A41784E434973496E527A496A6F784D7A6B794E6A59774F4445324C434A755957316C496A6F69595842684E793571634763694C434A7A6158706C496A6F7A4E7A4D794D7977696147467A61434936496D646E58307779576E5A6952314A7359326B3465557779526E645A56474E315957354362694973496E4A6C595751694F6A4573496D527062534936496A51314D48677A4D4441694C434A33636D6C305A5349364D53776962576C745A534936496D6C745957646C584339716347566E496E302D','2014-04-19 10:26:48'),
	('gg_L2ZvbGRlci8yL2FwYTguanBn',X'65794A30625749694F694A68634745344C6D70775A794973496E426F59584E6F496A6F695A32646654444A61646D4A48556D786A61546835496977695A4746305A534936496B3176626942475A5749674D5463674D6A49364D544D364D7A59674D6A41784E434973496E527A496A6F784D7A6B794E6A59774F4445324C434A755957316C496A6F69595842684F433571634763694C434A7A6158706C496A6F7A4F54417A4D6977696147467A61434936496D646E58307779576E5A6952314A7359326B3465557779526E645A564764315957354362694973496E4A6C595751694F6A4573496D527062534936496A51314D48677A4D4441694C434A33636D6C305A5349364D53776962576C745A534936496D6C745957646C584339716347566E496E302D','2014-04-19 10:26:48'),
	('gg_L2ZvbGRlci8yL2FwYTIuanBn',X'65794A30625749694F694A68634745794C6D70775A794973496E426F59584E6F496A6F695A32646654444A61646D4A48556D786A61546835496977695A4746305A534936496B3176626942475A5749674D5463674D6A49364D544D364D7A59674D6A41784E434973496E527A496A6F784D7A6B794E6A59774F4445324C434A755957316C496A6F69595842684D693571634763694C434A7A6158706C496A6F7A4F5455784E5377696147467A61434936496D646E58307779576E5A6952314A7359326B3465557779526E645A56456C315957354362694973496E4A6C595751694F6A4573496D527062534936496A51314D48677A4D4441694C434A33636D6C305A5349364D53776962576C745A534936496D6C745957646C584339716347566E496E302D','2014-04-19 10:26:48'),
	('gg_L2ZvbGRlci8yL2FwYTkuanBn',X'65794A30625749694F694A68634745354C6D70775A794973496E426F59584E6F496A6F695A32646654444A61646D4A48556D786A61546835496977695A4746305A534936496B3176626942475A5749674D5463674D6A49364D544D364D7A59674D6A41784E434973496E527A496A6F784D7A6B794E6A59774F4445324C434A755957316C496A6F69595842684F533571634763694C434A7A6158706C496A6F304D5441304F4377696147467A61434936496D646E58307779576E5A6952314A7359326B3465557779526E645A564774315957354362694973496E4A6C595751694F6A4573496D527062534936496A51314D48677A4D4441694C434A33636D6C305A5349364D53776962576C745A534936496D6C745957646C584339716347566E496E302D','2014-04-19 10:26:48'),
	('gg_L2ZvbGRlci8yL2FwYTMuanBn',X'65794A30625749694F694A686347457A4C6D70775A794973496E426F59584E6F496A6F695A32646654444A61646D4A48556D786A61546835496977695A4746305A534936496B3176626942475A5749674D5463674D6A49364D544D364D7A59674D6A41784E434973496E527A496A6F784D7A6B794E6A59774F4445324C434A755957316C496A6F69595842684D793571634763694C434A7A6158706C496A6F7A4D4459304D7977696147467A61434936496D646E58307779576E5A6952314A7359326B3465557779526E645A564531315957354362694973496E4A6C595751694F6A4573496D527062534936496A51314D48677A4D4441694C434A33636D6C305A5349364D53776962576C745A534936496D6C745957646C584339716347566E496E302D','2014-04-19 10:26:48'),
	('gg_L2ZvbGRlci8yL2FwYTQuanBn',X'65794A30625749694F694A68634745304C6D70775A794973496E426F59584E6F496A6F695A32646654444A61646D4A48556D786A61546835496977695A4746305A534936496B3176626942475A5749674D5463674D6A49364D544D364D7A59674D6A41784E434973496E527A496A6F784D7A6B794E6A59774F4445324C434A755957316C496A6F69595842684E433571634763694C434A7A6158706C496A6F304D4441794D6977696147467A61434936496D646E58307779576E5A6952314A7359326B3465557779526E645A564646315957354362694973496E4A6C595751694F6A4573496D527062534936496A51314D48677A4D4441694C434A33636D6C305A5349364D53776962576C745A534936496D6C745957646C584339716347566E496E302D','2014-04-19 10:26:48'),
	('gg_L2ZvbGRlci8yL2FwYTUuanBn',X'65794A30625749694F694A68634745314C6D70775A794973496E426F59584E6F496A6F695A32646654444A61646D4A48556D786A61546835496977695A4746305A534936496B3176626942475A5749674D5463674D6A49364D544D364D7A59674D6A41784E434973496E527A496A6F784D7A6B794E6A59774F4445324C434A755957316C496A6F69595842684E533571634763694C434A7A6158706C496A6F7A4D6A4D354F5377696147467A61434936496D646E58307779576E5A6952314A7359326B3465557779526E645A564656315957354362694973496E4A6C595751694F6A4573496D527062534936496A51314D48677A4D4441694C434A33636D6C305A5349364D53776962576C745A534936496D6C745957646C584339716347566E496E302D','2014-04-19 10:26:48'),
	('gg_L2ZvbGRlci8yL2FwYTYuanBn',X'65794A30625749694F694A68634745324C6D70775A794973496E426F59584E6F496A6F695A32646654444A61646D4A48556D786A61546835496977695A4746305A534936496B3176626942475A5749674D5463674D6A49364D544D364D7A59674D6A41784E434973496E527A496A6F784D7A6B794E6A59774F4445324C434A755957316C496A6F69595842684E693571634763694C434A7A6158706C496A6F7A4D7A59354D6977696147467A61434936496D646E58307779576E5A6952314A7359326B3465557779526E645A56466C315957354362694973496E4A6C595751694F6A4573496D527062534936496A51314D48677A4D4441694C434A33636D6C305A5349364D53776962576C745A534936496D6C745957646C584339716347566E496E302D','2014-04-19 10:26:48'),
	('gg_L2ZvbGRlci8yL2FzazEuanBn',X'65794A30625749694F694A68633273784C6D70775A794973496E426F59584E6F496A6F695A32646654444A61646D4A48556D786A61546835496977695A4746305A534936496B3176626942475A5749674D5463674D6A49364D544D364D7A59674D6A41784E434973496E527A496A6F784D7A6B794E6A59774F4445324C434A755957316C496A6F6959584E724D533571634763694C434A7A6158706C496A6F794E546B7A4E4377696147467A61434936496D646E58307779576E5A6952314A7359326B3465557779526E7068656B56315957354362694973496E4A6C595751694F6A4573496D527062534936496A51314D48677A4D7A67694C434A33636D6C305A5349364D53776962576C745A534936496D6C745957646C584339716347566E496E302D','2014-04-19 10:26:48'),
	('gg_L2ZvbGRlci8yL2FzazIuanBn',X'65794A30625749694F694A68633273794C6D70775A794973496E426F59584E6F496A6F695A32646654444A61646D4A48556D786A61546835496977695A4746305A534936496B3176626942475A5749674D5463674D6A49364D544D364D7A59674D6A41784E434973496E527A496A6F784D7A6B794E6A59774F4445324C434A755957316C496A6F6959584E724D693571634763694C434A7A6158706C496A6F794E6A4D784E6977696147467A61434936496D646E58307779576E5A6952314A7359326B3465557779526E7068656B6C315957354362694973496E4A6C595751694F6A4573496D527062534936496A51314D48677A4D7A67694C434A33636D6C305A5349364D53776962576C745A534936496D6C745957646C584339716347566E496E302D','2014-04-19 10:26:48'),
	('gg_L2ZvbGRlci8yL2FzazMuanBn',X'65794A30625749694F694A686332737A4C6D70775A794973496E426F59584E6F496A6F695A32646654444A61646D4A48556D786A61546835496977695A4746305A534936496B3176626942475A5749674D5463674D6A49364D544D364D7A59674D6A41784E434973496E527A496A6F784D7A6B794E6A59774F4445324C434A755957316C496A6F6959584E724D793571634763694C434A7A6158706C496A6F784E5451304D7977696147467A61434936496D646E58307779576E5A6952314A7359326B3465557779526E7068656B31315957354362694973496E4A6C595751694F6A4573496D527062534936496A51314D48677A4D7A67694C434A33636D6C305A5349364D53776962576C745A534936496D6C745957646C584339716347566E496E302D','2014-04-19 10:26:48'),
	('gg_L2ZvbGRlci8yL2FzazQuanBn',X'65794A30625749694F694A68633273304C6D70775A794973496E426F59584E6F496A6F695A32646654444A61646D4A48556D786A61546835496977695A4746305A534936496B3176626942475A5749674D5463674D6A49364D544D364D7A59674D6A41784E434973496E527A496A6F784D7A6B794E6A59774F4445324C434A755957316C496A6F6959584E724E433571634763694C434A7A6158706C496A6F784F446B344E4377696147467A61434936496D646E58307779576E5A6952314A7359326B3465557779526E7068656C46315957354362694973496E4A6C595751694F6A4573496D527062534936496A51314D48677A4D7A67694C434A33636D6C305A5349364D53776962576C745A534936496D6C745957646C584339716347566E496E302D','2014-04-19 10:26:48'),
	('gg_L2ZvbGRlci8yL2FzazUuanBn',X'65794A30625749694F694A68633273314C6D70775A794973496E426F59584E6F496A6F695A32646654444A61646D4A48556D786A61546835496977695A4746305A534936496B3176626942475A5749674D5463674D6A49364D544D364D7A59674D6A41784E434973496E527A496A6F784D7A6B794E6A59774F4445324C434A755957316C496A6F6959584E724E533571634763694C434A7A6158706C496A6F794F546B344E7977696147467A61434936496D646E58307779576E5A6952314A7359326B3465557779526E7068656C56315957354362694973496E4A6C595751694F6A4573496D527062534936496A51314D48677A4D7A67694C434A33636D6C305A5349364D53776962576C745A534936496D6C745957646C584339716347566E496E302D','2014-04-19 10:26:48'),
	('gg_L2ZvbGRlci8yL2FzazYuanBn',X'65794A30625749694F694A68633273324C6D70775A794973496E426F59584E6F496A6F695A32646654444A61646D4A48556D786A61546835496977695A4746305A534936496B3176626942475A5749674D5463674D6A49364D544D364D7A59674D6A41784E434973496E527A496A6F784D7A6B794E6A59774F4445324C434A755957316C496A6F6959584E724E693571634763694C434A7A6158706C496A6F7A4D6A51354E5377696147467A61434936496D646E58307779576E5A6952314A7359326B3465557779526E7068656C6C315957354362694973496E4A6C595751694F6A4573496D527062534936496A51314D48677A4D7A67694C434A33636D6C305A5349364D53776962576C745A534936496D6C745957646C584339716347566E496E302D','2014-04-19 10:26:48'),
	('gg_L2ZvbGRlci8yL2JhemlzMi5qcGc',X'65794A30625749694F694A6959587070637A4975616E426E4969776963476868633267694F694A6E5A31394D4D6C7032596B645362474E704F486B694C434A6B5958526C496A6F695457397549455A6C596941784E7941794D6A6F784D7A6F7A4E6941794D4445304969776964484D694F6A457A4F5449324E6A41344D545973496D3568625755694F694A6959587070637A4975616E426E4969776963326C365A5349364E4449304D6A4173496D6868633267694F694A6E5A31394D4D6C7032596B645362474E704F486C4D4D6B706F5A573173656B31704E58466A52324D694C434A795A57466B496A6F784C434A6B615730694F6949304E5442344D7A4D344969776964334A70644755694F6A4573496D3170625755694F694A706257466E5A567776616E426C5A794A39','2014-04-19 10:26:48'),
	('gg_L2ZvbGRlci8yL2JhemlzMS5qcGc',X'65794A30625749694F694A6959587070637A4575616E426E4969776963476868633267694F694A6E5A31394D4D6C7032596B645362474E704F486B694C434A6B5958526C496A6F695457397549455A6C596941784E7941794D6A6F784D7A6F7A4E6941794D4445304969776964484D694F6A457A4F5449324E6A41344D545973496D3568625755694F694A6959587070637A4575616E426E4969776963326C365A5349364D7A637A4E7A5173496D6868633267694F694A6E5A31394D4D6C7032596B645362474E704F486C4D4D6B706F5A573173656B31544E58466A52324D694C434A795A57466B496A6F784C434A6B615730694F6949304E5442344D7A4D344969776964334A70644755694F6A4573496D3170625755694F694A706257466E5A567776616E426C5A794A39','2014-04-19 10:26:48'),
	('gg_L2ZvbGRlci8yL2JhemlzMy5qcGc',X'65794A30625749694F694A6959587070637A4D75616E426E4969776963476868633267694F694A6E5A31394D4D6C7032596B645362474E704F486B694C434A6B5958526C496A6F695457397549455A6C596941784E7941794D6A6F784D7A6F7A4E6941794D4445304969776964484D694F6A457A4F5449324E6A41344D545973496D3568625755694F694A6959587070637A4D75616E426E4969776963326C365A5349364D7A55344E7A5173496D6868633267694F694A6E5A31394D4D6C7032596B645362474E704F486C4D4D6B706F5A573173656B31354E58466A52324D694C434A795A57466B496A6F784C434A6B615730694F6949304E5442344D7A4D344969776964334A70644755694F6A4573496D3170625755694F694A706257466E5A567776616E426C5A794A39','2014-04-19 10:26:48'),
	('gg_L2ZvbGRlci8yL2JhemlzNC5qcGc',X'65794A30625749694F694A6959587070637A5175616E426E4969776963476868633267694F694A6E5A31394D4D6C7032596B645362474E704F486B694C434A6B5958526C496A6F695457397549455A6C596941784E7941794D6A6F784D7A6F7A4E6941794D4445304969776964484D694F6A457A4F5449324E6A41344D545973496D3568625755694F694A6959587070637A5175616E426E4969776963326C365A5349364D5445314E4467334C434A6F59584E6F496A6F695A32646654444A61646D4A48556D786A6154683554444A4B614756746248704F517A56785930646A49697769636D56685A4349364D5377695A476C74496A6F694E44557765444D7A4F434973496E64796158526C496A6F784C434A746157316C496A6F69615731685A3256634C3270775A57636966512D2D','2014-04-19 10:26:48'),
	('gg_L2ZvbGRlci8yL2JhemlzNi5qcGc',X'65794A30625749694F694A6959587070637A5975616E426E4969776963476868633267694F694A6E5A31394D4D6C7032596B645362474E704F486B694C434A6B5958526C496A6F695457397549455A6C596941784E7941794D6A6F784D7A6F7A4E6941794D4445304969776964484D694F6A457A4F5449324E6A41344D545973496D3568625755694F694A6959587070637A5975616E426E4969776963326C365A5349364E7A67344E7977696147467A61434936496D646E58307779576E5A6952314A7359326B3465557779536D686C62577836546D6B3163574E4859794973496E4A6C595751694F6A4573496D527062534936496A51314D48677A4D7A67694C434A33636D6C305A5349364D53776962576C745A534936496D6C745957646C584339716347566E496E302D','2014-04-19 10:26:48'),
	('gg_L2ZvbGRlci8yL2JhemlzNS5qcGc',X'65794A30625749694F694A6959587070637A5575616E426E4969776963476868633267694F694A6E5A31394D4D6C7032596B645362474E704F486B694C434A6B5958526C496A6F695457397549455A6C596941784E7941794D6A6F784D7A6F7A4E6941794D4445304969776964484D694F6A457A4F5449324E6A41344D545973496D3568625755694F694A6959587070637A5575616E426E4969776963326C365A5349364F4467334F4377696147467A61434936496D646E58307779576E5A6952314A7359326B3465557779536D686C62577836546C4D3163574E4859794973496E4A6C595751694F6A4573496D527062534936496A51314D48677A4D7A67694C434A33636D6C305A5349364D53776962576C745A534936496D6C745957646C584339716347566E496E302D','2014-04-19 10:26:48'),
	('gg_L2ZvbGRlci8yL2JvcjcuanBn',X'65794A30625749694F694A69623349334C6D70775A794973496E426F59584E6F496A6F695A32646654444A61646D4A48556D786A61546835496977695A4746305A534936496B3176626942475A5749674D5463674D6A49364D544D364D7A59674D6A41784E434973496E527A496A6F784D7A6B794E6A59774F4445324C434A755957316C496A6F69596D39794E793571634763694C434A7A6158706C496A6F324D544D314D6977696147467A61434936496D646E58307779576E5A6952314A7359326B3465557779536E5A6A616D4E315957354362694973496E4A6C595751694F6A4573496D527062534936496A59774D4867304E5441694C434A33636D6C305A5349364D53776962576C745A534936496D6C745957646C584339716347566E496E302D','2014-04-19 10:26:48'),
	('gg_L2ZvbGRlci8yL2JvcjE0LmpwZw',X'65794A30625749694F694A69623349784E433571634763694C434A776147467A61434936496D646E58307779576E5A6952314A7359326B3465534973496D5268644755694F694A4E62323467526D566949444533494449794F6A457A4F6A4D32494449774D5451694C434A30637949364D544D354D6A59324D4467784E697769626D46745A534936496D4A76636A45304C6D70775A794973496E4E70656D55694F6A59794D4459314C434A6F59584E6F496A6F695A32646654444A61646D4A48556D786A6154683554444A4B646D4E715254424D62584233576E63694C434A795A57466B496A6F784C434A6B615730694F6949324D4442344E4455774969776964334A70644755694F6A4573496D3170625755694F694A706257466E5A567776616E426C5A794A39','2014-04-19 10:26:48'),
	('gg_L2ZvbGRlci8yL2JvcjE1LmpwZw',X'65794A30625749694F694A69623349784E533571634763694C434A776147467A61434936496D646E58307779576E5A6952314A7359326B3465534973496D5268644755694F694A4E62323467526D566949444533494449794F6A457A4F6A4D32494449774D5451694C434A30637949364D544D354D6A59324D4467784E697769626D46745A534936496D4A76636A45314C6D70775A794973496E4E70656D55694F6A59344D4455774C434A6F59584E6F496A6F695A32646654444A61646D4A48556D786A6154683554444A4B646D4E715254464D62584233576E63694C434A795A57466B496A6F784C434A6B615730694F6949324D4442344E4455774969776964334A70644755694F6A4573496D3170625755694F694A706257466E5A567776616E426C5A794A39','2014-04-19 10:26:48'),
	('gg_L2ZvbGRlci8yL2JvcjE2LmpwZw',X'65794A30625749694F694A69623349784E693571634763694C434A776147467A61434936496D646E58307779576E5A6952314A7359326B3465534973496D5268644755694F694A4E62323467526D566949444533494449794F6A457A4F6A4D32494449774D5451694C434A30637949364D544D354D6A59324D4467784E697769626D46745A534936496D4A76636A45324C6D70775A794973496E4E70656D55694F6A59354D6A6B304C434A6F59584E6F496A6F695A32646654444A61646D4A48556D786A6154683554444A4B646D4E7152544A4D62584233576E63694C434A795A57466B496A6F784C434A6B615730694F6949324D4442344E4455774969776964334A70644755694F6A4573496D3170625755694F694A706257466E5A567776616E426C5A794A39','2014-04-19 10:26:48'),
	('gg_L2ZvbGRlci8yL2JvcjE3LmpwZw',X'65794A30625749694F694A69623349784E793571634763694C434A776147467A61434936496D646E58307779576E5A6952314A7359326B3465534973496D5268644755694F694A4E62323467526D566949444533494449794F6A457A4F6A4D32494449774D5451694C434A30637949364D544D354D6A59324D4467784E697769626D46745A534936496D4A76636A45334C6D70775A794973496E4E70656D55694F6A4D324E5455344C434A6F59584E6F496A6F695A32646654444A61646D4A48556D786A6154683554444A4B646D4E7152544E4D62584233576E63694C434A795A57466B496A6F784C434A6B615730694F6949304E5442344D7A41774969776964334A70644755694F6A4573496D3170625755694F694A706257466E5A567776616E426C5A794A39','2014-04-19 10:26:48'),
	('gg_L2ZvbGRlci8yL2JvcjE4LmpwZw',X'65794A30625749694F694A69623349784F433571634763694C434A776147467A61434936496D646E58307779576E5A6952314A7359326B3465534973496D5268644755694F694A4E62323467526D566949444533494449794F6A457A4F6A4D32494449774D5451694C434A30637949364D544D354D6A59324D4467784E697769626D46745A534936496D4A76636A45344C6D70775A794973496E4E70656D55694F6A4D784E4467304C434A6F59584E6F496A6F695A32646654444A61646D4A48556D786A6154683554444A4B646D4E715254524D62584233576E63694C434A795A57466B496A6F784C434A6B615730694F6949304E5442344D7A41774969776964334A70644755694F6A4573496D3170625755694F694A706257466E5A567776616E426C5A794A39','2014-04-19 10:26:48'),
	('gg_L2ZvbGRlci8yL2JvcjE5LmpwZw',X'65794A30625749694F694A69623349784F533571634763694C434A776147467A61434936496D646E58307779576E5A6952314A7359326B3465534973496D5268644755694F694A4E62323467526D566949444533494449794F6A457A4F6A4D32494449774D5451694C434A30637949364D544D354D6A59324D4467784E697769626D46745A534936496D4A76636A45354C6D70775A794973496E4E70656D55694F6A4D794D4441304C434A6F59584E6F496A6F695A32646654444A61646D4A48556D786A6154683554444A4B646D4E715254564D62584233576E63694C434A795A57466B496A6F784C434A6B615730694F6949304E5442344D7A41774969776964334A70644755694F6A4573496D3170625755694F694A706257466E5A567776616E426C5A794A39','2014-04-19 10:26:48'),
	('gg_L2ZvbGRlci8yL2JvcjEuanBn',X'65794A30625749694F694A69623349784C6D70775A794973496E426F59584E6F496A6F695A32646654444A61646D4A48556D786A61546835496977695A4746305A534936496B3176626942475A5749674D5463674D6A49364D544D364D7A59674D6A41784E434973496E527A496A6F784D7A6B794E6A59774F4445324C434A755957316C496A6F69596D39794D533571634763694C434A7A6158706C496A6F324E6A677A4F5377696147467A61434936496D646E58307779576E5A6952314A7359326B3465557779536E5A6A616B56315957354362694973496E4A6C595751694F6A4573496D527062534936496A59774D4867304E5441694C434A33636D6C305A5349364D53776962576C745A534936496D6C745957646C584339716347566E496E302D','2014-04-19 10:26:48'),
	('gg_L2ZvbGRlci8yL2JvcjEwLmpwZw',X'65794A30625749694F694A69623349784D433571634763694C434A776147467A61434936496D646E58307779576E5A6952314A7359326B3465534973496D5268644755694F694A4E62323467526D566949444533494449794F6A457A4F6A4D32494449774D5451694C434A30637949364D544D354D6A59324D4467784E697769626D46745A534936496D4A76636A45774C6D70775A794973496E4E70656D55694F6A55344F5445784C434A6F59584E6F496A6F695A32646654444A61646D4A48556D786A6154683554444A4B646D4E715258644D62584233576E63694C434A795A57466B496A6F784C434A6B615730694F6949324D4442344E4455774969776964334A70644755694F6A4573496D3170625755694F694A706257466E5A567776616E426C5A794A39','2014-04-19 10:26:48'),
	('gg_L2ZvbGRlci8yL2JvcjExLmpwZw',X'65794A30625749694F694A69623349784D533571634763694C434A776147467A61434936496D646E58307779576E5A6952314A7359326B3465534973496D5268644755694F694A4E62323467526D566949444533494449794F6A457A4F6A4D32494449774D5451694C434A30637949364D544D354D6A59324D4467784E697769626D46745A534936496D4A76636A45784C6D70775A794973496E4E70656D55694F6A55324E546B344C434A6F59584E6F496A6F695A32646654444A61646D4A48556D786A6154683554444A4B646D4E715258684D62584233576E63694C434A795A57466B496A6F784C434A6B615730694F6949324D4442344E4455774969776964334A70644755694F6A4573496D3170625755694F694A706257466E5A567776616E426C5A794A39','2014-04-19 10:26:48'),
	('gg_L2ZvbGRlci8yL2JvcjEyLmpwZw',X'65794A30625749694F694A69623349784D693571634763694C434A776147467A61434936496D646E58307779576E5A6952314A7359326B3465534973496D5268644755694F694A4E62323467526D566949444533494449794F6A457A4F6A4D32494449774D5451694C434A30637949364D544D354D6A59324D4467784E697769626D46745A534936496D4A76636A45794C6D70775A794973496E4E70656D55694F6A59344D6A45304C434A6F59584E6F496A6F695A32646654444A61646D4A48556D786A6154683554444A4B646D4E7152586C4D62584233576E63694C434A795A57466B496A6F784C434A6B615730694F6949324D4442344E4455774969776964334A70644755694F6A4573496D3170625755694F694A706257466E5A567776616E426C5A794A39','2014-04-19 10:26:48'),
	('gg_L2ZvbGRlci8yL2JvcjguanBn',X'65794A30625749694F694A69623349344C6D70775A794973496E426F59584E6F496A6F695A32646654444A61646D4A48556D786A61546835496977695A4746305A534936496B3176626942475A5749674D5463674D6A49364D544D364D7A59674D6A41784E434973496E527A496A6F784D7A6B794E6A59774F4445324C434A755957316C496A6F69596D39794F433571634763694C434A7A6158706C496A6F324F446B334D6977696147467A61434936496D646E58307779576E5A6952314A7359326B3465557779536E5A6A616D64315957354362694973496E4A6C595751694F6A4573496D527062534936496A59774D4867304E5441694C434A33636D6C305A5349364D53776962576C745A534936496D6C745957646C584339716347566E496E302D','2014-04-19 10:26:48'),
	('gg_L2ZvbGRlci8yL2JvcjIuanBn',X'65794A30625749694F694A69623349794C6D70775A794973496E426F59584E6F496A6F695A32646654444A61646D4A48556D786A61546835496977695A4746305A534936496B3176626942475A5749674D5463674D6A49364D544D364D7A59674D6A41784E434973496E527A496A6F784D7A6B794E6A59774F4445324C434A755957316C496A6F69596D39794D693571634763694C434A7A6158706C496A6F324D6A55774E5377696147467A61434936496D646E58307779576E5A6952314A7359326B3465557779536E5A6A616B6C315957354362694973496E4A6C595751694F6A4573496D527062534936496A59774D4867304E5441694C434A33636D6C305A5349364D53776962576C745A534936496D6C745957646C584339716347566E496E302D','2014-04-19 10:26:48'),
	('gg_L2ZvbGRlci8yL2JvcjIwLmpwZw',X'65794A30625749694F694A69623349794D433571634763694C434A776147467A61434936496D646E58307779576E5A6952314A7359326B3465534973496D5268644755694F694A4E62323467526D566949444533494449794F6A457A4F6A4D32494449774D5451694C434A30637949364D544D354D6A59324D4467784E697769626D46745A534936496D4A76636A49774C6D70775A794973496E4E70656D55694F6A4D774E7A41324C434A6F59584E6F496A6F695A32646654444A61646D4A48556D786A6154683554444A4B646D4E715358644D62584233576E63694C434A795A57466B496A6F784C434A6B615730694F6949304E5442344D7A41774969776964334A70644755694F6A4573496D3170625755694F694A706257466E5A567776616E426C5A794A39','2014-04-19 10:26:48'),
	('gg_L2ZvbGRlci8yL2JvcjIxLmpwZw',X'65794A30625749694F694A69623349794D533571634763694C434A776147467A61434936496D646E58307779576E5A6952314A7359326B3465534973496D5268644755694F694A4E62323467526D566949444533494449794F6A457A4F6A4D32494449774D5451694C434A30637949364D544D354D6A59324D4467784E697769626D46745A534936496D4A76636A49784C6D70775A794973496E4E70656D55694F6A49774F4441334C434A6F59584E6F496A6F695A32646654444A61646D4A48556D786A6154683554444A4B646D4E715358684D62584233576E63694C434A795A57466B496A6F784C434A6B615730694F6949304E5442344D7A41774969776964334A70644755694F6A4573496D3170625755694F694A706257466E5A567776616E426C5A794A39','2014-04-19 10:26:48'),
	('gg_L2ZvbGRlci8yL2JvcjMuanBn',X'65794A30625749694F694A696233497A4C6D70775A794973496E426F59584E6F496A6F695A32646654444A61646D4A48556D786A61546835496977695A4746305A534936496B3176626942475A5749674D5463674D6A49364D544D364D7A59674D6A41784E434973496E527A496A6F784D7A6B794E6A59774F4445324C434A755957316C496A6F69596D39794D793571634763694C434A7A6158706C496A6F314F5467354D5377696147467A61434936496D646E58307779576E5A6952314A7359326B3465557779536E5A6A616B31315957354362694973496E4A6C595751694F6A4573496D527062534936496A59774D4867304E5441694C434A33636D6C305A5349364D53776962576C745A534936496D6C745957646C584339716347566E496E302D','2014-04-19 10:26:48'),
	('gg_L2ZvbGRlci8yL2JvcjQuanBn',X'65794A30625749694F694A69623349304C6D70775A794973496E426F59584E6F496A6F695A32646654444A61646D4A48556D786A61546835496977695A4746305A534936496B3176626942475A5749674D5463674D6A49364D544D364D7A59674D6A41784E434973496E527A496A6F784D7A6B794E6A59774F4445324C434A755957316C496A6F69596D39794E433571634763694C434A7A6158706C496A6F304D7A45774E6977696147467A61434936496D646E58307779576E5A6952314A7359326B3465557779536E5A6A616C46315957354362694973496E4A6C595751694F6A4573496D527062534936496A59774D4867304E5441694C434A33636D6C305A5349364D53776962576C745A534936496D6C745957646C584339716347566E496E302D','2014-04-19 10:26:48'),
	('gg_L2ZvbGRlci8yL2JvcjUuanBn',X'65794A30625749694F694A69623349314C6D70775A794973496E426F59584E6F496A6F695A32646654444A61646D4A48556D786A61546835496977695A4746305A534936496B3176626942475A5749674D5463674D6A49364D544D364D7A59674D6A41784E434973496E527A496A6F784D7A6B794E6A59774F4445324C434A755957316C496A6F69596D39794E533571634763694C434A7A6158706C496A6F344D5451784D4377696147467A61434936496D646E58307779576E5A6952314A7359326B3465557779536E5A6A616C56315957354362694973496E4A6C595751694F6A4573496D527062534936496A59774D4867304E5441694C434A33636D6C305A5349364D53776962576C745A534936496D6C745957646C584339716347566E496E302D','2014-04-19 10:26:48'),
	('gg_L2ZvbGRlci8yL3ZldHRvbl9ydV8tMTkyMHgxMTUwLTE5MjB4MTIwMC5qcGc',X'65794A30625749694F694A325A58523062323566636E56664C5445354D6A42344D5445314D4330784F544977654445794D444175616E426E4969776963476868633267694F694A6E5A31394D4D6C7032596B645362474E704F486B694C434A6B5958526C496A6F695457397549455A6C596941784E7941794D6A6F784D7A6F7A4E6941794D4445304969776964484D694F6A457A4F5449324E6A41344D545973496D3568625755694F694A325A58523062323566636E56664C5445354D6A42344D5445314D4330784F544977654445794D444175616E426E4969776963326C365A5349364E5455774E5463794C434A6F59584E6F496A6F695A32646654444A61646D4A48556D786A6154683554444E6162475249556E5A6962446C355A4659346445315561336C4E5347643454565256643078555254564E616B49305456524A643031444E58466A52324D694C434A795A57466B496A6F784C434A6B615730694F6949784D444177654459794E534973496E64796158526C496A6F784C434A746157316C496A6F69615731685A3256634C3270775A57636966512D2D','2014-04-19 10:26:48'),
	('gg_L2ZvbGRlci8yL3ZldHRvbl9ydV8yemgtLTI1NjB4MTYwMC5qcGc',X'65794A30625749694F694A325A58523062323566636E56664D6E706F4C5330794E545977654445324D444175616E426E4969776963476868633267694F694A6E5A31394D4D6C7032596B645362474E704F486B694C434A6B5958526C496A6F695457397549455A6C596941784E7941794D6A6F784D7A6F7A4E6941794D4445304969776964484D694F6A457A4F5449324E6A41344D545973496D3568625755694F694A325A58523062323566636E56664D6E706F4C5330794E545977654445324D444175616E426E4969776963326C365A5349364E546B324D5459334C434A6F59584E6F496A6F695A32646654444A61646D4A48556D786A6154683554444E6162475249556E5A6962446C355A465934655756745A33524D56456B78546D70434E4531555758644E517A56785930646A49697769636D56685A4349364D5377695A476C74496A6F694D5441774D4867324D6A55694C434A33636D6C305A5349364D53776962576C745A534936496D6C745957646C584339716347566E496E302D','2014-04-19 10:26:48'),
	('gg_L2ZvbGRlci8yL3ZldHRvbl9ydV95by0tMjU2MHgxNjAwLmpwZw',X'65794A30625749694F694A325A58523062323566636E5666655738744C5449314E6A42344D5459774D433571634763694C434A776147467A61434936496D646E58307779576E5A6952314A7359326B3465534973496D5268644755694F694A4E62323467526D566949444533494449794F6A457A4F6A4D32494449774D5451694C434A30637949364D544D354D6A59324D4467784E697769626D46745A534936496E5A6C64485276626C397964563935627930744D6A55324D4867784E6A41774C6D70775A794973496E4E70656D55694F6A4D314E5467314D7977696147467A61434936496D646E58307779576E5A6952314A7359326B346555777A576D786B53464A32596D7735655752574F54566965544230545770564D6B31495A33684F616B4633544731776431703349697769636D56685A4349364D5377695A476C74496A6F694F446B35654455324D694973496E64796158526C496A6F784C434A746157316C496A6F69615731685A3256634C3270775A57636966512D2D','2014-04-19 10:26:48'),
	('gg_L2ZvbGRlci8yL3ZldHRvbl9ydV95YS0xOTIweDEwODAtMTkyMHgxMjAwLmpwZw',X'65794A30625749694F694A325A58523062323566636E5666655745744D546B794D4867784D4467774C5445354D6A42344D5449774D433571634763694C434A776147467A61434936496D646E58307779576E5A6952314A7359326B3465534973496D5268644755694F694A4E62323467526D566949444533494449794F6A457A4F6A4D32494449774D5451694C434A30637949364D544D354D6A59324D4467784E697769626D46745A534936496E5A6C64485276626C397964563935595330784F544977654445774F4441744D546B794D4867784D6A41774C6D70775A794973496E4E70656D55694F6A55304F4463354D6977696147467A61434936496D646E58307779576E5A6952314A7359326B346555777A576D786B53464A32596D7735655752574F54565A557A42345431524A64325645525864505245463054565272655531495A33684E616B4633544731776431703349697769636D56685A4349364D5377695A476C74496A6F694D5441774D4867324D6A55694C434A33636D6C305A5349364D53776962576C745A534936496D6C745957646C584339716347566E496E302D','2014-04-19 10:26:48'),
	('gg_L2ZvbGRlci8yL3ZldHRvbl9ydV95YXpoLS0xOTIweDEyMDAuanBn',X'65794A30625749694F694A325A58523062323566636E566665574636614330744D546B794D4867784D6A41774C6D70775A794973496E426F59584E6F496A6F695A32646654444A61646D4A48556D786A61546835496977695A4746305A534936496B5A79615342475A5749674D6A67674D4441364D5449364D5467674D6A41784E434973496E527A496A6F784D7A6B7A4E544D784F544D344C434A755957316C496A6F69646D56306447397558334A3158336C68656D67744C5445354D6A42344D5449774D433571634763694C434A7A6158706C496A6F794E5449334F444D73496D6868633267694F694A6E5A31394D4D6C7032596B645362474E704F486C4D4D3170735A456853646D4A734F586C6B566A6B3157566877623078544D48685056456C335A5552466555314551585668626B4A7549697769636D56685A4349364D5377695A476C74496A6F694D546B794D4867784D6A41774969776964334A70644755694F6A4573496D3170625755694F694A706257466E5A567776616E426C5A794A39','2014-04-19 10:26:48'),
	('gg_L2ZvbGRlci8yLzIyLmpwZw',X'65794A30625749694F6949794D693571634763694C434A776147467A61434936496D646E58307779576E5A6952314A7359326B3465534973496D5268644755694F694A4E62323467526D566949444533494449794F6A457A4F6A4D32494449774D5451694C434A30637949364D544D354D6A59324D4467784E697769626D46745A534936496A49794C6D70775A794973496E4E70656D55694F6A51334D4459774D5377696147467A61434936496D646E58307779576E5A6952314A7359326B346555783653586C4D62584233576E63694C434A795A57466B496A6F784C434A6B615730694F6949784D444177654459794E534973496D3170625755694F694A706257466E5A567776616E426C5A794973496E64796158526C496A6F7866512D2D','2014-04-19 10:26:48'),
	('gg_L2ZvbGRlci8yMi4yMjI',X'65794A755957316C496A6F694D6A49754D6A4979496977695A476C79637949364D43776964484D694F6A45304D6A6B7A4E446B774F544D73496E4E70656D55694F6A4173496E426F59584E6F496A6F695A32646654444A61646D4A48556D786A5A794973496D3170625755694F694A6B61584A6C59335276636E6B694C434A6B5958526C496A6F695532463049454677636941784F4341784D7A6F794E446F314D7941794D4445314969776964334A70644755694F6A4573496E4A6C595751694F6A4573496D6868633267694F694A6E5A31394D4D6C7032596B645362474E704F486C4E615452355457704A496E302D','2015-04-18 12:34:27'),
	('gg_L2ZvbGRlci8zMy4zMzM',X'65794A6F59584E6F496A6F695A32646654444A61646D4A48556D786A6154683654586B30656B313654534973496E4A6C595751694F6A4573496E64796158526C496A6F784C434A746157316C496A6F695A476C795A574E3062334A35496977695A4746305A534936496C4E6864434242634849674D5467674D544D364D6A55364D5455674D6A41784E534973496E426F59584E6F496A6F695A32646654444A61646D4A48556D786A5A794973496E4E70656D55694F6A4173496E527A496A6F784E4449354D7A51354D5445314C434A6B61584A7A496A6F774C434A755957316C496A6F694D7A4D754D7A4D7A496E302D','2015-04-18 12:34:27'),
	('gg_L2ZvbGRlci8zMzM',X'65794A795A57466B496A6F784C434A6F59584E6F496A6F695A32646654444A61646D4A48556D786A615468365458704E4969776964334A70644755694F6A4573496D3170625755694F694A6B61584A6C59335276636E6B694C434A6B5958526C496A6F695532463049454677636941784F4341784D7A6F794E6A6F304F4341794D4445314969776963326C365A5349364D43776963476868633267694F694A6E5A31394D4D6C7032596B645362474E6E496977695A476C79637949364D43776964484D694F6A45304D6A6B7A4E446B794D446773496D3568625755694F69497A4D7A4D6966512D2D','2015-04-18 12:34:27'),
	('gg_L2ZvbGRlci90ZXN0X3Jvc2hheGE',X'65794A7A6158706C496A6F774C434A776147467A61434936496D646E58307779576E5A6952314A73593263694C434A746157316C496A6F695A476C795A574E3062334A35496977695A4746305A534936496C4E6864434242634849674D5467674D544D364D6A63364D5467674D6A41784E534973496E64796158526C496A6F784C434A795A57466B496A6F784C434A6F59584E6F496A6F695A32646654444A61646D4A48556D786A61546B77576C684F4D46677A536E5A6A4D6D686F5A55644649697769626D46745A534936496E526C63335266636D397A6147463459534973496D5270636E4D694F6A4173496E527A496A6F784E4449354D7A51354D6A4D3466512D2D','2015-04-18 12:34:27'),
	('gg_L2ZvbGRlci91bnRpdGxlZF9mb2xkZS51bnRpdGxlZCBmb2xkZXI',X'65794A755957316C496A6F6964573530615852735A5752665A6D39735A47557564573530615852735A5751675A6D39735A4756794969776964484D694F6A45304D6A6B7A4E4463344E7A6373496D5270636E4D694F6A4173496D5268644755694F694A545958516751584279494445344944457A4F6A41304F6A4D33494449774D5455694C434A746157316C496A6F695A476C795A574E3062334A354969776963476868633267694F694A6E5A31394D4D6C7032596B645362474E6E4969776963326C365A5349364D4377696147467A61434936496D646E58307779576E5A6952314A7359326B354D574A75556E426B52336873576B59356257497965477461557A5578596D3553634752486547786151304A74596A4A346131705953534973496E4A6C595751694F6A4573496E64796158526C496A6F7866512D2D','2015-04-18 12:34:27'),
	('gg_L2ZvbGRlci92ZXR0b25fcnVfemh5YXlhY2gtMTkyMHgxMDgwLTE5MjB4MTIwMC5qcGc',X'65794A6B615730694F6949784F544977654445794D4441694C434A755957316C496A6F69646D56306447397558334A315833706F6557463559574E6F4C5445354D6A42344D5441344D4330784F544977654445794D444175616E426E4969776964473169496A6F69646D56306447397558334A315833706F6557463559574E6F4C5445354D6A42344D5441344D4330784F544977654445794D444175616E426E4969776964484D694F6A45304D546B784F5459314E446773496D3170625755694F694A706257466E5A567776616E426C5A794973496D5268644755694F694A4E623234675247566A49444979494441784F6A45314F6A5134494449774D5451694C434A776147467A61434936496D646E58307779576E5A6952314A73593263694C434A7A6158706C496A6F304D44517A4F444973496D6868633267694F694A6E5A31394D4D6C7032596B645362474E704F544A6157464977596A49315A6D4E75566D5A6C625767315756687361466B795A33524E564774355455686E654531455A33644D56455531545770434E4531555358644E517A56785930646A49697769636D56685A4349364D53776964334A70644755694F6A4639','2015-04-18 12:34:27'),
	('gg_L2ZvbGRlci92ZXR0b25fcnVfeW8tLTI1NjB4MTYwMC5qcGc',X'65794A755957316C496A6F69646D56306447397558334A3158336C764C5330794E545977654445324D444175616E426E496977695A476C74496A6F694D6A55324D4867784E6A41774969776964484D694F6A45304D546B784F5459314E446773496E527459694936496E5A6C64485276626C397964563935627930744D6A55324D4867784E6A41774C6D70775A794973496E426F59584E6F496A6F695A32646654444A61646D4A48556D786A5A794973496E4E70656D55694F6A63794D7A41784D5377695A4746305A534936496B3176626942455A574D674D6A49674D4445364D5455364E4467674D6A41784E434973496D3170625755694F694A706257466E5A567776616E426C5A794973496E64796158526C496A6F784C434A6F59584E6F496A6F695A32646654444A61646D4A48556D786A61546B79576C68534D4749794E575A6A626C5A6D5A566334644578555354464F616B49305456525A643031444E58466A52324D694C434A795A57466B496A6F7866512D2D','2015-04-18 12:34:27'),
	('gg_L2ZvbGRlci92ZXR0b25fcnVfeWEtMTkyMHgxMDgwLTE5MjB4MTIwMC5qcGc',X'65794A33636D6C305A5349364D537769636D56685A4349364D5377696147467A61434936496D646E58307779576E5A6952314A7359326B354D6C7059556A42694D6A566D593235575A6D56585258524E564774355455686E654531455A33644D56455531545770434E4531555358644E517A56785930646A4969776963326C365A5349364E544D784E7A51774C434A776147467A61434936496D646E58307779576E5A6952314A73593263694C434A746157316C496A6F69615731685A3256634C3270775A5763694C434A6B5958526C496A6F69545739754945526C597941794D6941774D546F784E546F304F4341794D4445304969776964484D694F6A45304D546B784F5459314E446773496E527459694936496E5A6C64485276626C397964563935595330784F544977654445774F4441744D546B794D4867784D6A41774C6D70775A794973496D3568625755694F694A325A58523062323566636E5666655745744D546B794D4867784D4467774C5445354D6A42344D5449774D433571634763694C434A6B615730694F6949784F544977654445794D44416966512D2D','2015-04-18 12:34:27'),
	('gg_L2ZvbGRlci92ZXR0b25fcnVfeWF6aC0tMTkyMHgxMjAwLmpwZw',X'65794A6B5958526C496A6F69545739754945526C597941794D6941774D546F784E546F304F4341794D4445304969776962576C745A534936496D6C745957646C584339716347566E4969776963476868633267694F694A6E5A31394D4D6C7032596B645362474E6E4969776963326C365A5349364D6A55794E7A677A4C434A6F59584E6F496A6F695A32646654444A61646D4A48556D786A61546B79576C68534D4749794E575A6A626C5A6D5A5664474E6D46444D48524E564774355455686E654531715158644D62584233576E63694C434A795A57466B496A6F784C434A33636D6C305A5349364D5377695A476C74496A6F694D546B794D4867784D6A417749697769626D46745A534936496E5A6C64485276626C3979645639355958706F4C5330784F544977654445794D444175616E426E4969776964473169496A6F69646D56306447397558334A3158336C68656D67744C5445354D6A42344D5449774D433571634763694C434A30637949364D5451784F5445354E6A55304F48302D','2015-04-18 12:34:27'),
	('gg_L2ZvbGRlci92ZXR0b25fcnVfLTE5MjB4MTE1MC0xOTIweDEyMDAuanBn',X'65794A6B615730694F6949784F544977654445794D4441694C434A755957316C496A6F69646D56306447397558334A31587930784F544977654445784E5441744D546B794D4867784D6A41774C6D70775A794973496E527459694936496E5A6C64485276626C3979645638744D546B794D4867784D5455774C5445354D6A42344D5449774D433571634763694C434A30637949364D5451784F5445354E6A55304F43776962576C745A534936496D6C745957646C584339716347566E496977695A4746305A534936496B3176626942455A574D674D6A49674D4445364D5455364E4467674D6A41784E434973496E426F59584E6F496A6F695A32646654444A61646D4A48556D786A5A794973496E4E70656D55694F6A55324E6A59324E7977696147467A61434936496D646E58307779576E5A6952314A7359326B354D6C7059556A42694D6A566D593235575A6B78555254564E616B4930545652464D5531444D48685056456C335A5552466555314551585668626B4A7549697769636D56685A4349364D53776964334A70644755694F6A4639','2015-04-18 12:34:27'),
	('gg_L2ZvbGRlci92ZXR0b25fcnVfM3lhLS0xOTIweDEyMDAuanBn',X'65794A33636D6C305A5349364D537769636D56685A4349364D5377696147467A61434936496D646E58307779576E5A6952314A7359326B354D6C7059556A42694D6A566D593235575A6B307A6247684D557A42345431524A6432564552586C4E524546315957354362694973496E4E70656D55694F6A55344D6A67794D43776963476868633267694F694A6E5A31394D4D6C7032596B645362474E6E496977695A4746305A534936496B3176626942455A574D674D6A49674D4445364D5455364E4467674D6A41784E434973496D3170625755694F694A706257466E5A567776616E426C5A794973496E527A496A6F784E4445354D546B324E5451344C434A30625749694F694A325A58523062323566636E56664D336C684C5330784F544977654445794D444175616E426E49697769626D46745A534936496E5A6C64485276626C39796456387A655745744C5445354D6A42344D5449774D433571634763694C434A6B615730694F6949784F544977654445794D44416966512D2D','2015-04-18 12:34:27'),
	('gg_L2ZvbGRlci92ZXR0b25fcnVfMnpoLS0yNTYweDE2MDAuanBn',X'65794A30625749694F694A325A58523062323566636E56664D6E706F4C5330794E545977654445324D444175616E426E4969776964484D694F6A45304D546B784F5459314E446773496D527062534936496A49314E6A42344D5459774D434973496D3568625755694F694A325A58523062323566636E56664D6E706F4C5330794E545977654445324D444175616E426E496977696147467A61434936496D646E58307779576E5A6952314A7359326B354D6C7059556A42694D6A566D593235575A6B31756347394D557A4235546C525A6432564552544A4E524546315957354362694973496E4A6C595751694F6A4573496E64796158526C496A6F784C434A6B5958526C496A6F69545739754945526C597941794D6941774D546F784E546F304F4341794D4445304969776962576C745A534936496D6C745957646C584339716347566E4969776963476868633267694F694A6E5A31394D4D6C7032596B645362474E6E4969776963326C365A5349364D5445314D7A49354E48302D','2015-04-18 12:34:27'),
	('gg_L2ZvbGRlci9hc2sxLmpwZw',X'65794A30637949364D5451784F5445354E6A55304F43776964473169496A6F6959584E724D533571634763694C434A755957316C496A6F6959584E724D533571634763694C434A6B615730694F6949304E5442344D7A4D344969776964334A70644755694F6A4573496E4A6C595751694F6A4573496D6868633267694F694A6E5A31394D4D6C7032596B645362474E704F57686A4D6E4E3454473177643170334969776963326C365A5349364D6A55354D7A5173496E426F59584E6F496A6F695A32646654444A61646D4A48556D786A5A794973496D3170625755694F694A706257466E5A567776616E426C5A794973496D5268644755694F694A4E623234675247566A49444979494441784F6A45314F6A5134494449774D54516966512D2D','2015-04-18 12:34:27'),
	('gg_L2ZvbGRlci9hc2syLmpwZw',X'65794A6F59584E6F496A6F695A32646654444A61646D4A48556D786A61546C6F597A4A7A655578746348646164794973496E4A6C595751694F6A4573496E64796158526C496A6F784C434A6B5958526C496A6F69545739754945526C597941794D6941774D546F784E546F304F4341794D4445304969776962576C745A534936496D6C745957646C584339716347566E4969776963476868633267694F694A6E5A31394D4D6C7032596B645362474E6E4969776963326C365A5349364D6A597A4D545973496E527459694936496D467A617A4975616E426E4969776964484D694F6A45304D546B784F5459314E446773496D527062534936496A51314D48677A4D7A67694C434A755957316C496A6F6959584E724D6935716347636966512D2D','2015-04-18 12:34:27'),
	('gg_L2ZvbGRlci9hc2szLmpwZw',X'65794A755957316C496A6F6959584E724D793571634763694C434A6B615730694F6949304E5442344D7A4D344969776964484D694F6A45304D546B784F5459314E446773496E527459694936496D467A617A4D75616E426E4969776963476868633267694F694A6E5A31394D4D6C7032596B645362474E6E4969776963326C365A5349364D5455304E444D73496D3170625755694F694A706257466E5A567776616E426C5A794973496D5268644755694F694A4E623234675247566A49444979494441784F6A45314F6A5134494449774D5451694C434A33636D6C305A5349364D5377696147467A61434936496D646E58307779576E5A6952314A7359326B3561474D796333704D62584233576E63694C434A795A57466B496A6F7866512D2D','2015-04-18 12:34:27'),
	('gg_L2ZvbGRlci9hcGE1LmpwZw',X'65794A7A6158706C496A6F7A4D6A4D354F53776963476868633267694F694A6E5A31394D4D6C7032596B645362474E6E496977695A4746305A534936496B3176626942455A574D674D6A49674D4445364D5455364E4467674D6A41784E434973496D3170625755694F694A706257466E5A567776616E426C5A794973496E64796158526C496A6F784C434A795A57466B496A6F784C434A6F59584E6F496A6F695A32646654444A61646D4A48556D786A61546C6F593064464D5578746348646164794973496D3568625755694F694A68634745314C6D70775A794973496D527062534936496A51314D48677A4D4441694C434A30637949364D5451784F5445354E6A55304F43776964473169496A6F69595842684E5335716347636966512D2D','2015-04-18 12:34:27'),
	('gg_L2ZvbGRlci9hcGE4LmpwZw',X'65794A746157316C496A6F69615731685A3256634C3270775A5763694C434A6B5958526C496A6F69545739754945526C597941794D6941774D546F784E546F304F4341794D4445304969776963326C365A5349364D7A6B774D7A4973496E426F59584E6F496A6F695A32646654444A61646D4A48556D786A5A794973496E4A6C595751694F6A4573496D6868633267694F694A6E5A31394D4D6C7032596B645362474E704F57686A5230553054473177643170334969776964334A70644755694F6A4573496D527062534936496A51314D48677A4D4441694C434A755957316C496A6F69595842684F433571634763694C434A30625749694F694A68634745344C6D70775A794973496E527A496A6F784E4445354D546B324E54513466512D2D','2015-04-18 12:34:27'),
	('gg_L2ZvbGRlci9hcy5hc2Q',X'65794A755957316C496A6F6959584D7559584E6B4969776964484D694F6A45304D6A6B7A4E4463344E6A6773496D5270636E4D694F6A4173496D5268644755694F694A545958516751584279494445344944457A4F6A41304F6A4934494449774D5455694C434A746157316C496A6F695A476C795A574E3062334A354969776963476868633267694F694A6E5A31394D4D6C7032596B645362474E6E4969776963326C365A5349364D4377696147467A61434936496D646E58307779576E5A6952314A7359326B3561474E354E57686A4D6C45694C434A795A57466B496A6F784C434A33636D6C305A5349364D58302D','2015-04-18 12:34:27'),
	('gg_L2ZvbGRlci9hYQ',X'65794A755957316C496A6F69595745694C434A6B61584A7A496A6F774C434A30637949364D5451784F5445354E6A55304F4377695A4746305A534936496B3176626942455A574D674D6A49674D4445364D5455364E4467674D6A41784E434973496D3170625755694F694A6B61584A6C59335276636E6B694C434A7A6158706C496A6F774C434A776147467A61434936496D646E58307779576E5A6952314A73593263694C434A795A57466B496A6F784C434A6F59584E6F496A6F695A32646654444A61646D4A48556D786A61546C6F575645694C434A33636D6C305A5349364D58302D','2015-04-18 12:34:27'),
	('gg_L2ZvbGRlci9hYS5hYQ',X'65794A6B61584A7A496A6F774C434A30637949364D5451794F544D304F4459304E697769626D46745A534936496D46684C6D466849697769636D56685A4349364D5377696147467A61434936496D646E58307779576E5A6952314A7359326B3561466C544E57685A55534973496E64796158526C496A6F784C434A746157316C496A6F695A476C795A574E3062334A35496977695A4746305A534936496C4E6864434242634849674D5467674D544D364D5463364D6A59674D6A41784E534973496E4E70656D55694F6A4173496E426F59584E6F496A6F695A32646654444A61646D4A48556D786A5A794A39','2015-04-18 12:34:27'),
	('gg_L2ZvbGRlci9hYS92ZXR0b25fcnVfeW8tLTI1NjB4MTYwMC5qcGc',X'65794A30625749694F694A325A58523062323566636E5666655738744C5449314E6A42344D5459774D433571634763694C434A776147467A61434936496D646E58307779576E5A6952314A7359326B3561466C52496977695A4746305A534936496B3176626942475A5749674D5463674D6A49364D544D364D7A59674D6A41784E434973496E527A496A6F784D7A6B794E6A59774F4445324C434A755957316C496A6F69646D56306447397558334A3158336C764C5330794E545977654445324D444175616E426E4969776963326C365A5349364E7A497A4D4445784C434A6F59584E6F496A6F695A32646654444A61646D4A48556D786A61546C6F57564D354D6C7059556A42694D6A566D593235575A6D56584F48524D56456B78546D70434E4531555758644E517A56785930646A49697769636D56685A4349364D5377695A476C74496A6F694D6A55324D4867784E6A41774969776964334A70644755694F6A4573496D3170625755694F694A706257466E5A567776616E426C5A794A39','2014-03-01 17:11:48'),
	('gg_L2ZvbGRlci9hYS92ZXR0b25fcnVfeWEtMTkyMHgxMDgwLTE5MjB4MTIwMC5qcGc',X'65794A30625749694F694A325A58523062323566636E5666655745744D546B794D4867784D4467774C5445354D6A42344D5449774D433571634763694C434A776147467A61434936496D646E58307779576E5A6952314A7359326B3561466C52496977695A4746305A534936496B3176626942475A5749674D5463674D6A49364D544D364D7A59674D6A41784E434973496E527A496A6F784D7A6B794E6A59774F4445324C434A755957316C496A6F69646D56306447397558334A3158336C684C5445354D6A42344D5441344D4330784F544977654445794D444175616E426E4969776963326C365A5349364E544D784E7A51774C434A6F59584E6F496A6F695A32646654444A61646D4A48556D786A61546C6F57564D354D6C7059556A42694D6A566D593235575A6D56585258524E564774355455686E654531455A33644D56455531545770434E4531555358644E517A56785930646A49697769636D56685A4349364D5377695A476C74496A6F694D546B794D4867784D6A41774969776964334A70644755694F6A4573496D3170625755694F694A706257466E5A567776616E426C5A794A39','2014-03-01 17:11:48'),
	('gg_L2ZvbGRlci9hYS92ZXR0b25fcnVfeWF6aC0tMTkyMHgxMjAwLmpwZw',X'65794A30625749694F694A325A58523062323566636E566665574636614330744D546B794D4867784D6A41774C6D70775A794973496E426F59584E6F496A6F695A32646654444A61646D4A48556D786A61546C6F575645694C434A6B5958526C496A6F695457397549455A6C596941784E7941794D6A6F784D7A6F7A4E6941794D4445304969776964484D694F6A457A4F5449324E6A41344D545973496D3568625755694F694A325A58523062323566636E566665574636614330744D546B794D4867784D6A41774C6D70775A794973496E4E70656D55694F6A49314D6A63344D7977696147467A61434936496D646E58307779576E5A6952314A7359326B3561466C544F544A6157464977596A49315A6D4E75566D5A6C5630593259554D776445315561336C4E5347643454577042643078746348646164794973496E4A6C595751694F6A4573496D527062534936496A45354D6A42344D5449774D434973496E64796158526C496A6F784C434A746157316C496A6F69615731685A3256634C3270775A57636966512D2D','2014-03-01 17:11:48'),
	('gg_L2ZvbGRlci9hYS92ZXR0b25fcnVfLTE5MjB4MTE1MC0xOTIweDEyMDAuanBn',X'65794A30625749694F694A325A58523062323566636E56664C5445354D6A42344D5445314D4330784F544977654445794D444175616E426E4969776963476868633267694F694A6E5A31394D4D6C7032596B645362474E704F57685A55534973496D5268644755694F694A4E62323467526D566949444533494449794F6A457A4F6A4D32494449774D5451694C434A30637949364D544D354D6A59324D4467784E697769626D46745A534936496E5A6C64485276626C3979645638744D546B794D4867784D5455774C5445354D6A42344D5449774D433571634763694C434A7A6158706C496A6F314E6A59324E6A6373496D6868633267694F694A6E5A31394D4D6C7032596B645362474E704F57685A557A6B79576C68534D4749794E575A6A626C5A6D544652464E553171516A524E5645557854554D77654539555358646C524556355455524264574675516D34694C434A795A57466B496A6F784C434A6B615730694F6949784F544977654445794D4441694C434A33636D6C305A5349364D53776962576C745A534936496D6C745957646C584339716347566E496E302D','2014-03-01 17:11:48'),
	('gg_L2ZvbGRlci9hYS92ZXR0b25fcnVfM3lhLS0xOTIweDEyMDAuanBn',X'65794A30625749694F694A325A58523062323566636E56664D336C684C5330784F544977654445794D444175616E426E4969776963476868633267694F694A6E5A31394D4D6C7032596B645362474E704F57685A55534973496D5268644755694F694A47636D6B67526D566949444934494441774F6A45794F6A4D30494449774D5451694C434A30637949364D544D354D7A557A4D546B314E437769626D46745A534936496E5A6C64485276626C39796456387A655745744C5445354D6A42344D5449774D433571634763694C434A7A6158706C496A6F314F4449344D6A4173496D6868633267694F694A6E5A31394D4D6C7032596B645362474E704F57685A557A6B79576C68534D4749794E575A6A626C5A6D54544E73614578544D48685056456C335A5552466555314551585668626B4A7549697769636D56685A4349364D5377695A476C74496A6F694D546B794D4867784D6A41774969776964334A70644755694F6A4573496D3170625755694F694A706257466E5A567776616E426C5A794A39','2014-03-01 17:11:48'),
	('gg_L2ZvbGRlci9hYS92ZXR0b25fcnVfMnpoLS0yNTYweDE2MDAuanBn',X'65794A30625749694F694A325A58523062323566636E56664D6E706F4C5330794E545977654445324D444175616E426E4969776963476868633267694F694A6E5A31394D4D6C7032596B645362474E704F57685A55534973496D5268644755694F694A4E62323467526D566949444533494449794F6A457A4F6A4D32494449774D5451694C434A30637949364D544D354D6A59324D4467784E697769626D46745A534936496E5A6C64485276626C397964563879656D67744C5449314E6A42344D5459774D433571634763694C434A7A6158706C496A6F784D54557A4D6A6B304C434A6F59584E6F496A6F695A32646654444A61646D4A48556D786A61546C6F57564D354D6C7059556A42694D6A566D593235575A6B31756347394D557A4235546C525A6432564552544A4E524546315957354362694973496E4A6C595751694F6A4573496D527062534936496A49314E6A42344D5459774D434973496E64796158526C496A6F784C434A746157316C496A6F69615731685A3256634C3270775A57636966512D2D','2014-03-01 17:11:48'),
	('gg_L2ZvbGRlci9hYS9ib2NjYWxpMi5qcGc',X'65794A30625749694F694A6962324E6A595778704D693571634763694C434A776147467A61434936496D646E58307779576E5A6952314A7359326B3561466C52496977695A4746305A534936496B3176626942475A5749674D5463674D6A49364D544D364D7A59674D6A41784E434973496E527A496A6F784D7A6B794E6A59774F4445324C434A755957316C496A6F69596D396A5932467361544975616E426E4969776963326C365A5349364F4455774E444573496D6868633267694F694A6E5A31394D4D6C7032596B645362474E704F57685A557A6C70596A4A4F616C6C586548424E615456785930646A49697769636D56685A4349364D5377695A476C74496A6F694F444177654459774D434973496D3170625755694F694A706257466E5A567776616E426C5A794973496E64796158526C496A6F7866512D2D','2014-03-01 17:11:48'),
	('gg_L2ZvbGRlci9hYS9ydXNza29lIG5henZhbmllICB1IGZvdGtpIDE2MDB4MTIwMC0xOTIweDEyMDAuanBn',X'65794A30625749694F694A7964584E7A6132396C49473568656E5A68626D6C6C4943423149475A7664477470494445324D4442344D5449774D4330784F544977654445794D444175616E426E4969776963476868633267694F694A6E5A31394D4D6C7032596B645362474E704F57685A55534973496D5268644755694F694A4E62323467526D566949444533494449794F6A457A4F6A4D32494449774D5451694C434A30637949364D544D354D6A59324D4467784E697769626D46745A534936496E4A3163334E7262325567626D4636646D467561575567494855675A6D393061326B674D5459774D4867784D6A41774C5445354D6A42344D5449774D433571634763694C434A7A6158706C496A6F7A4E6A51344D544573496D6868633267694F694A6E5A31394D4D6C7032596B645362474E704F57685A557A6C355A46684F656D45794F57784A527A566F5A57356161474A746247784A5130497853556461646D52486448424A52455579545552434E4531555358644E517A42345431524A6432564552586C4E524546315957354362694973496E4A6C595751694F6A4573496D527062534936496A45354D6A42344D5449774D434973496E64796158526C496A6F784C434A746157316C496A6F69615731685A3256634C3270775A57636966512D2D','2014-03-01 17:11:48'),
	('gg_L2ZvbGRlci9hYV9kZHNfYS5hYSBkZHMgYWE',X'65794A755957316C496A6F69595746665A47527A58324575595745675A47527A49474668496977695A476C79637949364D43776964484D694F6A45304D6A6B7A4E4467334E445973496E4E70656D55694F6A4173496E426F59584E6F496A6F695A32646654444A61646D4A48556D786A5A794973496D3170625755694F694A6B61584A6C59335276636E6B694C434A6B5958526C496A6F695532463049454677636941784F4341784D7A6F784F546F774E6941794D4445314969776964334A70644755694F6A4573496E4A6C595751694F6A4573496D6868633267694F694A6E5A31394D4D6C7032596B645362474E704F57685A566A6C72576B684F5A6C6C544E57685A55304A72576B684E5A316C5852534A39','2015-04-18 12:34:27'),
	('gg_L2ZvbGRlci9hYV9zLmFhIHNz',X'65794A33636D6C305A5349364D5377696147467A61434936496D646E58307779576E5A6952314A7359326B3561466C574F58704D62555A6F5355684F65694973496E4A6C595751694F6A4573496E426F59584E6F496A6F695A32646654444A61646D4A48556D786A5A794973496E4E70656D55694F6A4173496D5268644755694F694A545958516751584279494445344944457A4F6A45344F6A5578494449774D5455694C434A746157316C496A6F695A476C795A574E3062334A354969776964484D694F6A45304D6A6B7A4E4467334D7A4573496D5270636E4D694F6A4173496D3568625755694F694A685956397A4C6D466849484E7A496E302D','2015-04-18 12:34:27'),
	('gg_L2ZvbGRlci9ib2NjYWxpMi5qcGc',X'65794A30637949364D5451784F5445354E6A55304F43776964473169496A6F69596D396A5932467361544975616E426E49697769626D46745A534936496D4A7659324E6862476B794C6D70775A794973496D527062534936496A67774D4867324D4441694C434A33636D6C305A5349364D5377696147467A61434936496D646E58307779576E5A6952314A7359326B3561574979546D705A5633687754576B3163574E4859794973496E4A6C595751694F6A4573496E426F59584E6F496A6F695A32646654444A61646D4A48556D786A5A794973496E4E70656D55694F6A67314D4451784C434A746157316C496A6F69615731685A3256634C3270775A5763694C434A6B5958526C496A6F69545739754945526C597941794D6941774D546F784E546F304F4341794D444530496E302D','2015-04-18 12:34:27'),
	('gg_L2ZvbGRlci9iYW5uZXItNi5qcGc',X'65794A6B615730694F6949324E6A68344D7A457749697769626D46745A534936496D4A68626D356C636930324C6D70775A794973496E527459694936496D4A68626D356C636930324C6D70775A794973496E527A496A6F784E4445354D546B324E5451344C434A746157316C496A6F69615731685A3256634C3270775A5763694C434A6B5958526C496A6F69545739754945526C597941794D6941774D546F784E546F304F4341794D4445304969776963476868633267694F694A6E5A31394D4D6C7032596B645362474E6E4969776963326C365A5349364E7A6B7A4D7A4973496D6868633267694F694A6E5A31394D4D6C7032596B645362474E704F576C5A567A5631576C684A644535704E58466A52324D694C434A795A57466B496A6F784C434A33636D6C305A5349364D58302D','2015-04-18 12:34:27'),
	('gg_L2ZvbGRlci9JbWFnZXMuemlw',X'65794A755957316C496A6F69535731685A32567A4C6E707063434973496E527A496A6F784E4445354D546B324E5451344C434A746157316C496A6F695958427762476C6A59585270623235634C33707063434973496D5268644755694F694A4E623234675247566A49444979494441784F6A45314F6A5134494449774D5451694C434A776147467A61434936496D646E58307779576E5A6952314A73593263694C434A7A6158706C496A6F314D5441794D7A417A4C434A6F59584E6F496A6F695A32646654444A61646D4A48556D786A61546C4B596C6447626C70595458566C6257783349697769636D56685A4349364D53776964334A70644755694F6A4639','2015-04-18 12:34:27'),
	('gg_L2ZvbGRlci9kZC5kZGQ',X'65794A7A6158706C496A6F774C434A776147467A61434936496D646E58307779576E5A6952314A73593263694C434A746157316C496A6F695A476C795A574E3062334A35496977695A4746305A534936496C4E6864434242634849674D5467674D544D364D5449364E5455674D6A41784E534973496E64796158526C496A6F784C434A795A57466B496A6F784C434A6F59584E6F496A6F695A32646654444A61646D4A48556D786A61546C72576B4D316131704855534973496D3568625755694F694A6B5A43356B5A4751694C434A6B61584A7A496A6F774C434A30637949364D5451794F544D304F444D334E58302D','2015-04-18 12:34:27'),
	('gg_L2ZvbGRlci9mZi5mZmY',X'65794A755957316C496A6F695A6D59755A6D5A6D4969776964484D694F6A45304D6A6B7A4E4463354F444173496D5270636E4D694F6A4173496D5268644755694F694A545958516751584279494445344944457A4F6A41324F6A4977494449774D5455694C434A746157316C496A6F695A476C795A574E3062334A354969776963476868633267694F694A6E5A31394D4D6C7032596B645362474E6E4969776963326C365A5349364D4377696147467A61434936496D646E58307779576E5A6952314A7359326B35625670704E57316162566B694C434A795A57466B496A6F784C434A33636D6C305A5349364D58302D','2015-04-18 12:34:27'),
	('gg_L2ZvbGRlci9ub3ZheWE',X'65794A6B5958526C496A6F69545739754945526C597941794D6941774D546F784E546F304F4341794D4445304969776962576C745A534936496D5270636D566A6447397965534973496E4E70656D55694F6A4173496E426F59584E6F496A6F695A32646654444A61646D4A48556D786A5A794973496E4A6C595751694F6A4573496D6868633267694F694A6E5A31394D4D6C7032596B645362474E704F5856694D31706F5A5664464969776964334A70644755694F6A4573496D3568625755694F694A7562335A68655745694C434A6B61584A7A496A6F774C434A30637949364D5451784F5445354E6A55304F48302D','2015-04-18 12:34:27'),
	('gg_L2ZvbGRlci9ub3ZheWEvdmV0dG9uX3J1X3lhemgtLTE5MjB4MTIwMC5qcGc',X'65794A30625749694F694A325A58523062323566636E566665574636614330744D546B794D4867784D6A41774C6D70775A794973496E426F59584E6F496A6F695A32646654444A61646D4A48556D786A61546C31596A4E616147565852534973496D5268644755694F694A54595851675457467949434178494445324F6A45794F6A5577494449774D5451694C434A30637949364D544D354D7A59334E546B334D437769626D46745A534936496E5A6C64485276626C3979645639355958706F4C5330784F544977654445794D444175616E426E4969776963326C365A5349364D6A55794E7A677A4C434A6F59584E6F496A6F695A32646654444A61646D4A48556D786A61546C31596A4E616147565852585A6B625659775A4563356456677A536A46594D32786F5A57316E644578555254564E616B49305456524A643031444E58466A52324D694C434A795A57466B496A6F784C434A6B615730694F6949784F544977654445794D4441694C434A33636D6C305A5349364D53776962576C745A534936496D6C745957646C584339716347566E496E302D','2014-03-01 17:11:49'),
	('gg_L2ZvbGRlci9ub3ZheWFfcGFway7DkMK9w5DCvsOQwrLDkMKww5HCjyDDkMK_w5DCsMOQwr_DkMK6w5DCsA',X'65794A33636D6C305A5349364D537769636D56685A4349364D5377696147467A61434936496D646E58307779576E5A6952314A7359326B356457497A576D686C56305A6D59306447643246354E30527254557335647A564551335A7A54314633636B78456130314C6433633153454E71655552456130314C5833633152454E7A5455395264334A665247744E537A5A334E555244633045694C434A7A6158706C496A6F774C434A776147467A61434936496D646E58307779576E5A6952314A73593263694C434A6B5958526C496A6F695532463049454677636941784F4341784D7A6F784E6A6F304E7941794D4445314969776962576C745A534936496D5270636D566A6447397965534973496D5270636E4D694F6A4173496E527A496A6F784E4449354D7A51344E6A41334C434A755957316C496A6F69626D393259586C685833426863477375304C335176744379304C44526A79445176394377304C2F5175744377496E302D','2015-04-18 12:34:27'),
	('gg_L2ZvbGRlci9wcm92ZXJrYQ',X'65794A795A57466B496A6F784C434A6F59584E6F496A6F695A32646654444A61646D4A48556D786A61546C33593230354D6C7059536E4A5A55534973496E64796158526C496A6F784C434A746157316C496A6F695A476C795A574E3062334A35496977695A4746305A534936496C4E6864434242634849674D5467674D544D364D6A63364D5445674D6A41784E534973496E4E70656D55694F6A4173496E426F59584E6F496A6F695A32646654444A61646D4A48556D786A5A794973496D5270636E4D694F6A4173496E527A496A6F784E4449354D7A51354D6A4D784C434A755957316C496A6F6963484A76646D56796132456966512D2D','2015-04-18 12:34:27'),
	('gg_L2ZvbGRlci9xcXFxLnFxcXFx',X'65794A755957316C496A6F6963584678635335786358467863534973496D5270636E4D694F6A4173496E527A496A6F784E4449354D7A51334F546B344C434A6B5958526C496A6F695532463049454677636941784F4341784D7A6F774E6A6F7A4F4341794D4445314969776962576C745A534936496D5270636D566A6447397965534973496E4E70656D55694F6A4173496E426F59584E6F496A6F695A32646654444A61646D4A48556D786A5A794973496E4A6C595751694F6A4573496D6868633267694F694A6E5A31394D4D6C7032596B645362474E704F58686A57455A345447354765474E59526E67694C434A33636D6C305A5349364D58302D','2015-04-18 12:34:27'),
	('gg_L2ZvbGRlci9xLnFx',X'65794A755957316C496A6F696353357863534973496E527A496A6F784E4449354D7A51344D4441324C434A6B61584A7A496A6F774C434A776147467A61434936496D646E58307779576E5A6952314A73593263694C434A7A6158706C496A6F774C434A746157316C496A6F695A476C795A574E3062334A35496977695A4746305A534936496C4E6864434242634849674D5467674D544D364D4459364E4459674D6A41784E534973496E64796158526C496A6F784C434A6F59584E6F496A6F695A32646654444A61646D4A48556D786A61546C345447354765434973496E4A6C595751694F6A4639','2015-04-18 12:34:27'),
	('gg_L2ZvbGRlci9ydXNza29lIG5henZhbmllICB1IGZvdGtpIDE2MDB4MTIwMC0xOTIweDEyMDAuanBn',X'65794A33636D6C305A5349364D537769636D56685A4349364D5377696147467A61434936496D646E58307779576E5A6952314A7359326B3565575259546E70684D6A6C735355633161475675576D68696257787353554E434D556C48576E5A6B52335277535552464D6B3145516A524E56456C3354554D77654539555358646C524556355455524264574675516D34694C434A7A6158706C496A6F7A4E6A51344D544573496E426F59584E6F496A6F695A32646654444A61646D4A48556D786A5A794973496D5268644755694F694A4E623234675247566A49444979494441784F6A45314F6A5134494449774D5451694C434A746157316C496A6F69615731685A3256634C3270775A5763694C434A30637949364D5451784F5445354E6A55304F43776964473169496A6F69636E567A633274765A53427559587032595735705A5341676453426D62335272615341784E6A4177654445794D4441744D546B794D4867784D6A41774C6D70775A794973496D3568625755694F694A7964584E7A6132396C49473568656E5A68626D6C6C4943423149475A7664477470494445324D4442344D5449774D4330784F544977654445794D444175616E426E496977695A476C74496A6F694D546B794D4867784D6A4177496E302D','2015-04-18 12:34:27'),
	('gg_L2ZvbGRlci9ydXNza29lX25henZhbmllX191X2ZvdGtpXzE2MDB4MTIwMC0xOTIweDEyMDAuanBn',X'65794A30625749694F694A7964584E7A6132396C58323568656E5A68626D6C6C5831393158325A7664477470587A45324D4442344D5449774D4330784F544977654445794D444175616E426E4969776964484D694F6A45304D546B784F5459314E446773496D527062534936496A51784D6E67324D6A55694C434A755957316C496A6F69636E567A633274765A56397559587032595735705A5639666456396D62335272615638784E6A4177654445794D4441744D546B794D4867784D6A41774C6D70775A794973496D6868633267694F694A6E5A31394D4D6C7032596B645362474E704F586C6B5745353659544935624667794E57686C626C706F596D3173624667784F5446594D6C70325A4564306346683652544A4E524549305456524A643031444D48685056456C335A5552466555314551585668626B4A7549697769636D56685A4349364D53776964334A70644755694F6A4573496D3170625755694F694A706257466E5A567776616E426C5A794973496D5268644755694F694A4E623234675247566A49444979494441784F6A45314F6A5134494449774D5451694C434A776147467A61434936496D646E58307779576E5A6952314A73593263694C434A7A6158706C496A6F784F544D794E6A5A39','2015-04-18 12:34:27'),
	('gg_L2ZvbGRlci9zcy5zcw',X'65794A30637949364D5451794F544D304F4459314E6977695A476C79637949364D437769626D46745A534936496E4E7A4C6E4E7A4969776964334A70644755694F6A4573496D6868633267694F694A6E5A31394D4D6C7032596B645362474E704F58706A65545636593363694C434A795A57466B496A6F784C434A776147467A61434936496D646E58307779576E5A6952314A73593263694C434A7A6158706C496A6F774C434A6B5958526C496A6F695532463049454677636941784F4341784D7A6F784E7A6F7A4E6941794D4445314969776962576C745A534936496D5270636D566A6447397965534A39','2015-04-18 12:34:27'),
	('gg_L2ZvbGRlci9zYWQuc2FkZg',X'65794A755957316C496A6F696332466B4C6E4E685A4759694C434A30637949364D5451794F544D304E7A6B314D5377695A476C79637949364D4377695A4746305A534936496C4E6864434242634849674D5467674D544D364D4455364E5445674D6A41784E534973496D3170625755694F694A6B61584A6C59335276636E6B694C434A776147467A61434936496D646E58307779576E5A6952314A73593263694C434A7A6158706C496A6F774C434A6F59584E6F496A6F695A32646654444A61646D4A48556D786A61546C365756645264574D79526D74615A794973496E4A6C595751694F6A4573496E64796158526C496A6F7866512D2D','2015-04-18 12:34:27'),
	('gg_L3Rlc3QudHh0',X'65794A776147467A61434936496D646E58307833496977695A4746305A534936496B3176626942475A5749674D6A51674D5455364E4451364E5441674D6A41784E434973496E527A496A6F784D7A6B7A4D6A51794D6A6B774C434A755957316C496A6F696447567A64433530654851694C434A7A6158706C496A6F794E5377696147467A61434936496D646E5830777A556D786A4D3146315A45686F4D434973496E4A6C595751694F6A4573496E64796158526C496A6F784C434A746157316C496A6F696447563464467776634778686157343759326868636E4E6C64443156564559744F434A39','2014-06-11 08:36:34'),
	('gg_L3ZldHRvbl9ydV8yemgtLTI1NjB4MTYwMC5qcGc',X'65794A30625749694F694A325A58523062323566636E56664D6E706F4C5330794E545977654445324D444175616E426E4969776963476868633267694F694A6E5A31394D64794973496D5268644755694F694A4E62323467526D566949444930494445314F6A51304F6A5577494449774D5451694C434A30637949364D544D354D7A49304D6A49354D437769626D46745A534936496E5A6C64485276626C397964563879656D67744C5449314E6A42344D5459774D433571634763694C434A7A6158706C496A6F784D54557A4D6A6B304C434A6F59584E6F496A6F695A32646654444E6162475249556E5A6962446C355A465934655756745A33524D56456B78546D70434E4531555758644E517A56785930646A49697769636D56685A4349364D5377695A476C74496A6F694D6A55324D4867784E6A41774969776964334A70644755694F6A4573496D3170625755694F694A706257466E5A567776616E426C5A794A39','2014-06-11 08:36:35'),
	('gg_L3ZldHRvbl9ydV95YXpoLS0xOTIweDEyMDAuanBn',X'65794A30625749694F694A325A58523062323566636E566665574636614330744D546B794D4867784D6A41774C6D70775A794973496E426F59584E6F496A6F695A326466544863694C434A6B5958526C496A6F695457397549455A6C596941794E4341784E546F304E446F314D4341794D4445304969776964484D694F6A457A4F544D794E4449794F544173496D3568625755694F694A325A58523062323566636E566665574636614330744D546B794D4867784D6A41774C6D70775A794973496E4E70656D55694F6A67354E6A45324C434A6F59584E6F496A6F695A32646654444E6162475249556E5A6962446C355A4659354E566C596347394D557A42345431524A6432564552586C4E524546315957354362694973496E4A6C595751694F6A4573496D527062534936496A457A4E6A64344D5449784D694973496E64796158526C496A6F784C434A746157316C496A6F69615731685A3256634C3270775A57636966512D2D','2014-06-11 08:36:36'),
	('gg_Lw',X'65794A6F59584E6F496A6F695A326466544863694C434A795A57466B496A6F784C434A33636D6C305A5349364D53776962576C745A534936496D5270636D566A6447397965534973496D5268644755694F694A55645755675247566A4944497A494449794F6A45314F6A5132494449774D5451694C434A7A6158706C496A6F774C434A7362324E725A5751694F6A4573496E527A496A6F784E4445354D7A55344E5451324C434A6B61584A7A496A6F784C434A755957316C496A6F6964584E6C636D5A706247567A496E302D','2015-04-18 12:34:25'),
	('gg_LzE5LjEwLnBuZw',X'65794A30625749694F6949784F5334784D433577626D63694C434A776147467A61434936496D646E58307833496977695A4746305A534936496B3176626942475A5749674D6A51674D5455364E4451364E446B674D6A41784E434973496E527A496A6F784D7A6B7A4D6A51794D6A67354C434A755957316C496A6F694D546B754D5441756347356E4969776963326C365A5349364D5451774E4463344C434A6F59584E6F496A6F695A326466544870464E5578715258644D626B4A31576E63694C434A795A57466B496A6F784C434A6B615730694F6949784D7A4934654467314E534973496E64796158526C496A6F784C434A746157316C496A6F69615731685A3256634C3342755A794A39','2014-06-11 08:36:34'),
	('gg_LzEyMy5qcGc',X'65794A30625749694F6949784D6A4D75616E426E4969776963476868633267694F694A6E5A31394D64794973496D5268644755694F694A4E62323467526D566949444930494445314F6A51304F6A5135494449774D5451694C434A30637949364D544D354D7A49304D6A49344F537769626D46745A534936496A45794D793571634763694C434A7A6158706C496A6F784E6A557A4E6A4D73496D6868633267694F694A6E5A31394D656B563554586B3163574E4859794973496E4A6C595751694F6A4573496D527062534936496A45784D6A5A344D5445324D794973496E64796158526C496A6F784C434A746157316C496A6F69615731685A3256634C3270775A57636966512D2D','2014-06-11 08:36:34');

/*!40000 ALTER TABLE `sys_filemanager_cache` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table sys_history
# ------------------------------------------------------------

DROP TABLE IF EXISTS `sys_history`;

CREATE TABLE `sys_history` (
  `id_user` int(11) NOT NULL DEFAULT '0',
  `link` text NOT NULL,
  `title` varchar(255) DEFAULT NULL,
  `replaceme` varchar(128) NOT NULL DEFAULT '',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY `id_user` (`id_user`,`replaceme`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Таблица с историей загрузки доку';

LOCK TABLES `sys_history` WRITE;
/*!40000 ALTER TABLE `sys_history` DISABLE KEYS */;

INSERT INTO `sys_history` (`id_user`, `link`, `title`, `replaceme`, `created_at`)
VALUES
	(1,'<a href=\'#\' title=\'Карта\' onClick=\"openPage(\'center\', \'keys_keys_texts0\', \'/admin/keys/body?do=info&index=189&replaceme=keys_keys_texts0&list_table=keys_texts\', \'Документ\', \'Документ\')\"><img width=\'21\' height=\'21\' alt=\'Карта\' src=\'/admin/img/icons/program/object.png\' align=\'absmiddle\'> Карта » Ключи</a>','Карта','keys_keys_texts0','2015-10-23 19:45:01'),
	(1,'<a href=\'#\' title=\'Главная страница123\' onClick=\"openPage(\'center\', \'texts_texts_main_ru1\', \'/admin/texts/body?do=info&index=1&replaceme=texts_texts_main_ru1&list_table=texts_main_ru\', \'Документ\', \'Документ\')\"><img width=\'21\' height=\'21\' alt=\'Главная страница123\' src=\'/admin/img/icons/program/text.png\' align=\'absmiddle\'> Главная страница123 » Основные тексты » Тексты</a>','Главная страница123','texts_texts_main_ru1','2015-10-26 17:43:58'),
	(1,'<a href=\'#\' title=\'teet\' onClick=\"openPage(\'center\', \'catalog_data_catalog_orders33\', \'/admin/catalog/body?do=info&index=33&list_table=data_catalog_orders&replaceme=catalog_data_catalog_orders33\', \'Документ\', \'Документ\')\"><img width=\'21\' height=\'21\' alt=\'teet\' src=\'/admin/img/icons/program/catalog2.png\' align=\'absmiddle\'> teet » Заказы » Каталог</a>','teet','catalog_data_catalog_orders33','2015-10-23 20:04:42'),
	(1,'<a href=\'#\' title=\'Модуль\' onClick=\"openPage(\'center\', \'keys_keys_access1\', \'/admin/keys/body?do=info&index=1&replaceme=keys_keys_access1&list_table=keys_access\', \'Документ\', \'Документ\')\"><img width=\'21\' height=\'21\' alt=\'Модуль\' src=\'/admin/img/icons/program/object.png\' align=\'absmiddle\'> Модуль » Ключи</a>','Модуль','keys_keys_access1','2015-10-26 16:23:22'),
	(1,'<a href=\'#\' title=\'Тип показа баннера\' onClick=\"openPage(\'center\', \'keys_keys_banners20\', \'/admin/keys/body?do=info&index=20&list_table=keys_banners&replaceme=keys_keys_banners20\', \'Документ\', \'Документ\')\"><img width=\'21\' height=\'21\' alt=\'Тип показа баннера\' src=\'/admin/img/icons/program/object.png\' align=\'absmiddle\'> Тип показа баннера » Ключи</a>','Тип показа баннера','keys_keys_banners20','2015-10-26 17:25:48'),
	(1,'<a href=\'#\' title=\'Текст\' onClick=\"openPage(\'center\', \'keys_keys_texts12\', \'/admin/keys/body?do=info&index=12&list_table=keys_texts&replaceme=keys_keys_texts12\', \'Документ\', \'Документ\')\"><img width=\'21\' height=\'21\' alt=\'Текст\' src=\'/admin/img/icons/program/object.png\' align=\'absmiddle\'> Текст » Ключи</a>','Текст','keys_keys_texts12','2015-10-26 16:59:44'),
	(1,'<a href=\'#\' title=\'Картинка\' onClick=\"openPage(\'center\', \'keys_keys_catalog11\', \'/admin/keys/body?do=info&index=11&replaceme=keys_keys_catalog11&list_table=keys_catalog\', \'Документ\', \'Документ\')\"><img width=\'21\' height=\'21\' alt=\'Картинка\' src=\'/admin/img/icons/program/object.png\' align=\'absmiddle\'> Картинка » Ключи</a>','Картинка','keys_keys_catalog11','2015-10-26 18:25:31'),
	(1,'<a href=\'#\' title=\'Картинка\' onClick=\"openPage(\'center\', \'keys_keys_banners26\', \'/admin/keys/body?do=info&index=26&list_table=keys_banners&replaceme=keys_keys_banners26\', \'Документ\', \'Документ\')\"><img width=\'21\' height=\'21\' alt=\'Картинка\' src=\'/admin/img/icons/program/object.png\' align=\'absmiddle\'> Картинка » Ключи</a>','Картинка','keys_keys_banners26','2015-10-26 17:12:58'),
	(1,'<a href=\'#\' title=\'Файл\' onClick=\"openPage(\'center\', \'keys_keys_banners42\', \'/admin/keys/body?do=info&index=42&replaceme=keys_keys_banners42&list_table=keys_banners\', \'Документ\', \'Документ\')\"><img width=\'21\' height=\'21\' alt=\'Файл\' src=\'/admin/img/icons/program/object.png\' align=\'absmiddle\'> Файл » Ключи</a>','Файл','keys_keys_banners42','2015-10-26 17:12:54'),
	(1,'<a href=\'#\' title=\'Удалить запись\' onClick=\"openPage(\'center\', \'keys_keys_redirects2\', \'/admin/keys/body?do=info&index=2&replaceme=keys_keys_redirects2&list_table=keys_redirects\', \'Документ\', \'Документ\')\"><img width=\'21\' height=\'21\' alt=\'Удалить запись\' src=\'/admin/img/icons/program/object.png\' align=\'absmiddle\'> Удалить запись » Ключи</a>','Удалить запись','keys_keys_redirects2','2015-10-26 18:26:18');

/*!40000 ALTER TABLE `sys_history` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table sys_lists
# ------------------------------------------------------------

DROP TABLE IF EXISTS `sys_lists`;

CREATE TABLE `sys_lists` (
  `ID` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(128) NOT NULL DEFAULT '',
  `lkey` varchar(32) NOT NULL DEFAULT '',
  `listf` varchar(255) NOT NULL DEFAULT '',
  `editlist` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `width` smallint(5) unsigned NOT NULL DEFAULT '0',
  `height` smallint(5) unsigned NOT NULL DEFAULT '0',
  `scroll` tinyint(1) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`ID`),
  UNIQUE KEY `lkey` (`lkey`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 PACK_KEYS=0 COMMENT='Справочники';

LOCK TABLES `sys_lists` WRITE;
/*!40000 ALTER TABLE `sys_lists` DISABLE KEYS */;

INSERT INTO `sys_lists` (`ID`, `name`, `lkey`, `listf`, `editlist`, `width`, `height`, `scroll`)
VALUES
	(1,'Список программных модулей','sys_program','ID,name,key_razdel',0,0,0,0),
	(2,'Группы пользователей','lst_group_user','ID,name',1,0,0,0),
	(3,'Пользователи','sys_users','ID,name',0,0,0,0),
	(10,'Шаблоны страниц','lst_layouts','ID,name,layout',0,0,0,0),
	(12,'Баннерокрутилка. URL страниц','lst_banner_urls','ID,name',1,0,0,0);

/*!40000 ALTER TABLE `sys_lists` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table sys_lkeys_log
# ------------------------------------------------------------

DROP TABLE IF EXISTS `sys_lkeys_log`;

CREATE TABLE `sys_lkeys_log` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `keys_tbl` varchar(32) NOT NULL DEFAULT '',
  `qstring` text NOT NULL,
  `keys_send` longtext NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Лог переданных параметров';



# Dump of table sys_mysql_error
# ------------------------------------------------------------

DROP TABLE IF EXISTS `sys_mysql_error`;

CREATE TABLE `sys_mysql_error` (
  `sql` text NOT NULL,
  `error` text NOT NULL,
  `qstring` varchar(255) NOT NULL DEFAULT '',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Ошибки MySQL';

LOCK TABLES `sys_mysql_error` WRITE;
/*!40000 ALTER TABLE `sys_mysql_error` DISABLE KEYS */;

INSERT INTO `sys_mysql_error` (`sql`, `error`, `qstring`, `created_at`)
VALUES
	('UPDATE texts_floating_ru SET edate=$v,name=$v,operator=$v,sss=$v,text=$v,viewtext=$v WHERE `ID`=\'19\'','Died at ../extlib/GG/Dbi.pm line 149.\n','','2012-09-05 17:12:58'),
	('UPDATE texts_floating_ru SET edate=$v,name=$v,operator=$v,sss=$v,text=$v,viewtext=$v WHERE `ID`=\'19\'','Died at ../extlib/GG/Dbi.pm line 150.\n','','2012-09-05 17:15:17'),
	('UPDATE `texts_floating_ru` SET edate=2012-09-05 13:16:33,name=adfasdf,operator=root,sss=1,text=,viewtext=1 WHERE `ID`=\'19\'','Died at ../extlib/GG/Dbi.pm line 150.\n','','2012-09-05 17:16:33'),
	('UPDATE `texts_floating_ru` SET edate=\"2012-09-05 13:17:00\",name=\"adfasdf\",operator=\"root\",sss=\"1\",text=\"\",viewtext=\"1\" WHERE `ID`=\'19\'','Died at ../extlib/GG/Dbi.pm line 150.\n','','2012-09-05 17:17:00'),
	('INSERT INTO sys_datalogs (`comment`,`ip`,`login`,`name`,`program`,`rdate`) VALUES (\"Логин: roort, Пароль: g\",\"127.0.0.1\",\"\",\"Превышено кол-во попыток авторизации, повторите попытку позже\",\"auth\",\"2012-09-05 18:34:51\")','Column \'login\' cannot be null at ../extlib/GG/Dbi.pm line 115.\n','','2012-09-05 22:34:51'),
	('INSERT INTO sys_vars (`comment`,`envkey`,`envvalue`,`groups_list`,`id_program`,`name`,`settings`,`types`,`users_list`) VALUES (\"\",\"mode\",\"\",\"\",\"\",\"Режим отладки\",\"type=list\nlist=development|да~production|нет\",\"list_radio\",\"\")','Column \'envvalue\' cannot be null at ../extlib/GG/Dbi.pm line 95.\n','','2012-11-15 18:41:31'),
	('INSERT INTO sys_vars (`comment`,`envkey`,`envvalue`,`groups_list`,`id_program`,`name`,`settings`,`types`,`users_list`) VALUES (\"\",\"mode\",\"\",\"\",\"\",\"Режим отладки\",\"type=list\nlist=development|Да~production|Нет\n\",\"list_radio\",\"\")','Column \'envvalue\' cannot be null at ../extlib/GG/Dbi.pm line 95.\n','','2012-11-15 18:42:20'),
	('INSERT INTO sys_vars (`comment`,`envkey`,`envvalue`,`groups_list`,`id_program`,`name`,`settings`,`types`,`users_list`) VALUES (\"\",\"mode\",\"\",\"\",\"\",\"Режим отладки\",\"type=list\nlist=development|Да~production|Нет\n\",\"list_radio\",\"\")','Column \'envvalue\' cannot be null at ../extlib/GG/Dbi.pm line 95.\n','','2012-11-15 18:42:23'),
	('INSERT INTO sys_datalogs (`comment`,`ip`,`login`,`name`,`program`,`rdate`) VALUES (\"Логин: user, Пароль: 100800\",\"127.0.0.1\",\"\",\"Пожалуйста, введите верные логин и пароль #1\",\"auth\",\"2012-11-16 14:32:18\")','Column \'login\' cannot be null at ../extlib/GG/Dbi.pm line 95.\n','','2012-11-16 18:32:18'),
	('INSERT INTO sys_datalogs (`comment`,`ip`,`login`,`name`,`program`,`rdate`) VALUES (\"Логин: user, Пароль: 100800\",\"127.0.0.1\",\"\",\"Пожалуйста, введите верные логин и пароль #1\",\"auth\",\"2012-11-16 15:16:44\")','Column \'login\' cannot be null at ../extlib/GG/Dbi.pm line 95.\n','','2012-11-16 19:16:44'),
	('UPDATE `keys_auth` SET `edate`=\"2013-03-26 14:25:43\",`lkey`=\"login\",`modul`=\"\",`name`=\"Логин\",`object`=\"lkey\",`settings`=\"type=s\nrating=101\nobligatory=1\nkeys_reg=1\nkeys_read=1\",`tbl`=\"\" WHERE `ID`=\'1\'','Unknown column \'modul\' in \'field list\' at /www/gg9.local/cgi-bin/script/../extlib/GG/Dbi.pm line 154.\n','','2013-03-26 18:25:43'),
	('INSERT INTO sys_datalogs (`comment`,`eventtype`,`id_program`,`id_sysuser`,`id_sysusergroup`,`ip`,`name`,`rdate`) VALUES (\"Логин: root, Пароль: q\",\"0\",\"0\",\"\",\"1\",\"127.0.0.1\",\"Пожалуйста, введите верные логин и пароль #2. Попытка (1 из 10)\",\"2013-11-22 19:46:53\")','Column \'id_sysuser\' cannot be null at /Users/aleksey/www/ggtest.local/cgi-bin/script/../extlib/GG/Dbi.pm line 95.\n','','2013-11-22 19:46:53'),
	('UPDATE `texts_main_ru` SET `alias`=\"about\",`edate`=\"2013-11-22 19:48:36\",`operator`=\"root\" WHERE `ID`=\'20\'','Duplicate entry \'about\' for key \'alias\' at /Users/aleksey/www/ggtest.local/cgi-bin/script/../extlib/GG/Dbi.pm line 154.\n','','2013-11-22 19:48:36'),
	('INSERT INTO sys_datalogs (`comment`,`eventtype`,`id_program`,`id_sysuser`,`id_sysusergroup`,`ip`,`name`,`rdate`) VALUES (\"Логин: root, Пароль: fraogfr\",\"0\",\"0\",\"\",\"1\",\"10.0.2.2\",\"Пожалуйста, введите верные логин и пароль #2. Попытка (1 из 10)\",\"2014-01-27 23:23:59\")','Column \'id_sysuser\' cannot be null at /vagrant/ggtest.dev/cgi-bin/script/../extlib/GG/Dbi.pm line 95.\n','','2014-01-27 19:23:59'),
	('INSERT INTO sys_datalogs (`comment`,`eventtype`,`id_program`,`id_sysuser`,`id_sysusergroup`,`ip`,`name`,`rdate`) VALUES (\"Логин: root, Пароль: q\",\"0\",\"0\",\"\",\"1\",\"10.0.2.2\",\"Пожалуйста, введите верные логин и пароль #2. Попытка (1 из 10)\",\"2014-02-20 14:10:56\")','Column \'id_sysuser\' cannot be null at /vagrant/ggtest.dev/cgi-bin/script/../extlib/GG/Dbi.pm line 95.\n','','2014-02-20 10:10:56'),
	('INSERT INTO sys_datalogs (`comment`,`eventtype`,`id_program`,`id_sysuser`,`id_sysusergroup`,`ip`,`name`,`rdate`) VALUES (\"Логин: root, Пароль: q\",\"0\",\"0\",\"\",\"1\",\"10.0.2.2\",\"Пожалуйста, введите верные логин и пароль #2. Попытка (1 из 10)\",\"2014-02-26 22:05:04\")','Column \'id_sysuser\' cannot be null at /vagrant/ggtest.dev/httpdocs/cgi-bin/script/../extlib/GG/Dbi.pm line 95.\n','','2014-02-26 18:05:04'),
	('INSERT INTO sys_datalogs (`comment`,`eventtype`,`id_program`,`id_sysuser`,`id_sysusergroup`,`ip`,`name`,`rdate`) VALUES (\"Логин: root, Пароль: q\",\"0\",\"0\",\"\",\"1\",\"10.0.2.2\",\"Пожалуйста, введите верные логин и пароль #2. Попытка (2 из 10)\",\"2014-02-26 22:06:15\")','Column \'id_sysuser\' cannot be null at /vagrant/ggtest.dev/httpdocs/cgi-bin/script/../extlib/GG/Dbi.pm line 95.\n','','2014-02-26 18:06:15'),
	('INSERT INTO sys_datalogs (`comment`,`eventtype`,`id_program`,`id_sysuser`,`id_sysusergroup`,`ip`,`name`,`rdate`) VALUES (\"Логин: root, Пароль: q\",\"0\",\"61\",\"\",\"1\",\"10.0.2.2\",\"Пожалуйста, введите верные логин и пароль #2. Попытка (1 из 10)\",\"2014-03-01 13:27:22\")','Column \'id_sysuser\' cannot be null at /vagrant/gg.dev/cgi-bin/script/../extlib/GG/Dbi.pm line 95.\n','','2014-03-01 09:27:22'),
	('INSERT INTO sys_datalogs (`comment`,`eventtype`,`id_program`,`id_sysuser`,`id_sysusergroup`,`ip`,`name`,`rdate`) VALUES (\"Логин: root, Пароль: q\",\"0\",\"0\",\"\",\"1\",\"10.0.2.2\",\"Пожалуйста, введите верные логин и пароль #2. Попытка (1 из 10)\",\"2014-03-01 21:04:51\")','Column \'id_sysuser\' cannot be null at /vagrant/gg.dev/cgi-bin/script/../extlib/GG/Dbi.pm line 95.\n','','2014-03-01 17:04:51'),
	('INSERT INTO sys_datalogs (`comment`,`eventtype`,`id_program`,`id_sysuser`,`id_sysusergroup`,`ip`,`name`,`rdate`) VALUES (\"Логин: root, Пароль: q\",\"0\",\"0\",\"\",\"1\",\"10.0.2.2\",\"Пожалуйста, введите верные логин и пароль #2. Попытка (1 из 10)\",\"2014-06-11 12:32:46\")','Column \'id_sysuser\' cannot be null at /vagrant/swiss.dev/cgi-bin/script/../extlib/GG/Dbi.pm line 112.\n','','2014-06-11 08:32:46'),
	('INSERT INTO sys_datalogs (`comment`,`created_at`,`eventtype`,`id_program`,`id_sysuser`,`id_sysusergroup`,`ip`,`name`) VALUES (\"Логин: root, Пароль: q\",\"2014-12-21 20:24:24\",\"0\",\"0\",\"\",\"1\",\"10.0.2.2\",\"Пожалуйста, введите верные логин и пароль #2. Попытка (1 из 10)\")','Column \'id_sysuser\' cannot be null at /vagrant/gg.dev/cgi-bin/script/../extlib/GG/Dbi.pm line 203.\n','','2014-12-21 16:24:24'),
	('INSERT INTO sys_datalogs (`comment`,`created_at`,`eventtype`,`id_program`,`id_sysuser`,`id_sysusergroup`,`ip`,`name`) VALUES (\"Логин: root, Пароль: qqq\",\"2014-12-21 20:26:54\",\"0\",\"0\",\"\",\"1\",\"10.0.2.2\",\"Пожалуйста, введите верные логин и пароль #2. Попытка (1 из 10)\")','Column \'id_sysuser\' cannot be null at /vagrant/gg.dev/cgi-bin/script/../extlib/GG/Dbi.pm line 203.\n','','2014-12-21 16:26:54'),
	('INSERT INTO sys_datalogs (`comment`,`created_at`,`eventtype`,`id_program`,`id_sysuser`,`id_sysusergroup`,`ip`,`name`) VALUES (\"Логин: root, Пароль: 22\",\"2014-12-21 20:26:57\",\"0\",\"0\",\"\",\"1\",\"10.0.2.2\",\"Пожалуйста, введите верные логин и пароль #2. Попытка (2 из 10)\")','Column \'id_sysuser\' cannot be null at /vagrant/gg.dev/cgi-bin/script/../extlib/GG/Dbi.pm line 203.\n','','2014-12-21 16:26:57'),
	('INSERT INTO sys_datalogs (`comment`,`created_at`,`eventtype`,`id_program`,`id_sysuser`,`id_sysusergroup`,`ip`,`name`) VALUES (\"Логин: user, Пароль: 1000800\",\"2014-12-21 20:27:05\",\"0\",\"0\",\"\",\"1\",\"10.0.2.2\",\"Пожалуйста, введите верные логин и пароль #2. Попытка (1 из 10)\")','Column \'id_sysuser\' cannot be null at /vagrant/gg.dev/cgi-bin/script/../extlib/GG/Dbi.pm line 203.\n','','2014-12-21 16:27:05');

/*!40000 ALTER TABLE `sys_mysql_error` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table sys_program
# ------------------------------------------------------------

DROP TABLE IF EXISTS `sys_program`;

CREATE TABLE `sys_program` (
  `ID` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL DEFAULT '',
  `default_table` varchar(255) DEFAULT NULL,
  `keys_table` varchar(100) NOT NULL DEFAULT '',
  `key_razdel` varchar(32) NOT NULL DEFAULT '',
  `menu_btn_key` varchar(100) NOT NULL,
  `pict` varchar(64) NOT NULL DEFAULT '',
  `help` text NOT NULL,
  `prgroup` tinyint(3) NOT NULL DEFAULT '0',
  `ru` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `en` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `settings` text NOT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `key_razdel` (`key_razdel`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 PACK_KEYS=0 COMMENT='Список программ';

LOCK TABLES `sys_program` WRITE;
/*!40000 ALTER TABLE `sys_program` DISABLE KEYS */;

INSERT INTO `sys_program` (`ID`, `name`, `default_table`, `keys_table`, `key_razdel`, `menu_btn_key`, `pict`, `help`, `prgroup`, `ru`, `en`, `settings`)
VALUES
	(3,'Справочники',NULL,'keys_lists','lists','menu_settings','/admin/img/icons/program/lists.png','Модуль для работы со справочниками и списками.',4,1,0,'groupname=Общая информация\r\nqsearch=1\r\nqedit=1\r\nqview=1\r\ntree=1'),
	(4,'Глобальные переменные','sys_vars','keys_vars','vars','menu_settings','/admin/img/icons/program/settings.png','Модуль для настройки глобальных переменных.',4,1,0,'groupname=Общая информация\r\nqsearch=1\r\nqedit=1\r\nqview=1\r\ntree=1\r\n'),
	(1,'Настройки',NULL,'keys_mainconfig','admin','menu_settings','/admin/img/icons/menu/icon_home.gif','Главная страница панели управления',4,0,0,'groupname='),
	(6,'Ключи',NULL,'keys_keys','keys','menu_settings','/admin/img/icons/program/object.png','Модуль для работы с ключами: ключами, кнопками, списками.',4,1,0,'groupname=Ключ\r\nqsearch=1\r\nqedit=1\r\nqview=1\r\ntree=1\r\n\r\n'),
	(9,'Стили',NULL,'keys_styles','styles','menu_settings','/admin/img/icons/program/styles.png','Модуль для редактирования таблиц стилей.',4,1,0,'groupname=Общая информация\r\nqsearch=1'),
	(11,'Права доступа','sys_access','keys_access','access','menu_settings','/admin/img/icons/program/access.png','Модуль для определение доступа к модулям, таблицам, полям.',4,1,0,'groupname=Тип объекта|Модуль|Настрока прав доступа\r\nqsearch=1\r\nqedit=1\r\nqview=1\r\ntree=1\r\n'),
	(12,'Пользователи','sys_users','keys_sysusers','sysusers','menu_settings','/admin/img/icons/program/users.png','Модуль для управления учетными записями пользователей.',4,1,0,'groupname=Общая информация\r\nqsearch=1\r\nqedit=1\r\nqview=1\r\ntree=1\r\n'),
	(5,'Шаблоны',NULL,'keys_templates','templates','menu_settings','/admin/img/icons/program/templates.png','Модуль для работы с шаблонами.',4,1,0,'groupname=Шаблон\r\nqsearch=1\r\nqedit=1\r\nqview=1\r\ntree=0\r\n'),
	(32,'Панель управления',NULL,'keys_global','global','menu_button','/admin/img/icons/menu/icon_home.gif','Главная страница панели управления',4,0,0,'groupname='),
	(60,'Каталог','data_catalog_items','keys_catalog','catalog','menu_center','/admin/img/icons/program/catalog2.png','Модуль работы с каталогом',3,1,0,'groupname=Общие данные|Фото\r\ngroupname_categorys=Общие данные\ngroupname_brands=Общие данные\r\ngroupname_set=Общие данные\r\nqsearch=1\r\nqedit=1\r\nqview=1\r\ndefcol=1\r\ntable_indexes=1\nfollow_changes=1\n\r\n'),
	(61,'Тексты','texts_main_ru','keys_texts','texts','mainrazdel_button','/admin/img/icons/program/text.png','Модуль для работы с текстами: добавление, редактирование, удаление, построение спискови и меню.',1,1,1,'groupname=Общая информация|Текст\r\ngroupname_docfiles=Общая информация\r\ngroupname_soffers=Общая информация\r\ngroupname_floating=Общая информация\r\nqsearch=1\r\nrazdels=1\r\nchange_lang=1\r\nqedit=1\r\nqview=1\r\ntree=1\r\nfollow_changes=1\n'),
	(62,'Баннерокрутилка','data_banner','keys_banners','banners','menu_banner','/admin/img/icons/program/banner.png','Модуль для управления показами рекламных баннеров на сайте.',3,1,0,'groupname=Общие данные|Рекламный блок|Настройки таргетинга|Статистика\r\ndefcol=1\r\nqsearch=1\r\nqedit=1\r\nqview=1\r\nexcel=1\r\ntree=1'),
	(63,'Изображения','images_gallery','keys_images','images','mainrazdel_button','/admin/img/icons/program/image.png','Модуль для работы с изображениями: добавление, редактирование, удаление.',1,0,0,'groupname=Общая информация\r\ngroupname_catalog=Общая информация\r\nqsearch=1\r\nrazdels=1\r\nqedit=1\r\nqview=1\r\ntree=1\r\n'),
	(64,'Вопрос-ответ','data_faq','keys_faq','faq','menu_center','/admin/img/icons/program/faq.png','Модуль для работы с вопрос-ответ: редактирование, удаление.',3,1,0,'groupname=Общая информация\r\nqsearch=1\r\n#qedit=1\r\nqview=1'),
	(66,'Внешние пользователи','data_users','keys_users','users','menu_center','/admin/img/icons/program/users.gif','Модуль для управления учетными записями внешних пользователей.',3,1,0,'groupname=Общая информация\r\nqsearch=1\r\nqedit=1\r\nqview=1\r\n'),
	(67,'Системный журнал','sys_datalogs','keys_syslogs','syslogs','menu_settings','/admin/img/icons/program/syslogs.png','Модуль для просмотра системных логов пользователей',4,1,0,'groupname=Общая информация\r\nqsearch=1\r\nqview=1\r\n'),
	(68,'SEO','data_seo_meta','keys_seo','seo','menu_settings','/admin/img/icons/program/seo.png','Модуль для работы с meta тегами страниц',4,1,0,'groupname=Общая информация\r\nqsearch=1\r\nqview=1\r\n'),
	(69,'Файлменеджер',NULL,'keys_filemanager','filemanager','mainrazdel_button','/admin/img/icons/program/filemanager.png','Модуль для работы с файлами',1,1,1,'groupname=Общая информация\r\n'),
	(70,'301 Redirect','data_redirects','keys_redirects','redirects','menu_settings','/admin/img/icons/program/redirects.png','Модуль для создания редиректов страницу',4,1,0,'groupname=Общая информация\nqsearch=1\nqview=1\n'),
	(71,'Отзывы','data_recall','keys_recall','recall','menu_center','/admin/img/icons/program/links.png','Модуль для работы с отзывами: редактирование, удаление.',3,1,0,'groupname=Общая информация\nqsearch=1\nqedit=1\nfollow_changes=1\nqview=1');

/*!40000 ALTER TABLE `sys_program` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table sys_program_tables
# ------------------------------------------------------------

DROP TABLE IF EXISTS `sys_program_tables`;

CREATE TABLE `sys_program_tables` (
  `ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `table` varchar(50) NOT NULL,
  `program_id` smallint(5) unsigned DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `table` (`table`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `sys_program_tables` WRITE;
/*!40000 ALTER TABLE `sys_program_tables` DISABLE KEYS */;

INSERT INTO `sys_program_tables` (`ID`, `name`, `table`, `program_id`)
VALUES
	(1,'Товары','data_catalog_items',60),
	(2,'Категории','data_catalog_categories',60),
	(3,'Бренды','data_catalog_brands',60),
	(4,'Заказы','data_catalog_orders',60),
	(5,'Баннеры','data_banner',62),
	(6,'Рекламные места','data_banner_advert_block',62),
	(7,'Рекламодатели','data_banner_advert_users',62);

/*!40000 ALTER TABLE `sys_program_tables` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table sys_related
# ------------------------------------------------------------

DROP TABLE IF EXISTS `sys_related`;

CREATE TABLE `sys_related` (
  `ID` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `tbl_main` varchar(64) NOT NULL DEFAULT '',
  `tbl_main_title` varchar(255) NOT NULL,
  `tbl_dep` varchar(64) NOT NULL DEFAULT '',
  `tbl_dep_title` varchar(255) NOT NULL,
  `field` varchar(64) NOT NULL DEFAULT '',
  `mult` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `delete` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`ID`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

LOCK TABLES `sys_related` WRITE;
/*!40000 ALTER TABLE `sys_related` DISABLE KEYS */;

INSERT INTO `sys_related` (`ID`, `tbl_main`, `tbl_main_title`, `tbl_dep`, `tbl_dep_title`, `field`, `mult`, `delete`)
VALUES
	(1,'lst_advert_block','','data_banner','','id_advert_block',1,0),
	(2,'data_catalog_orders','заказы','dtbl_orders','заказы.товары','id_order',0,1);

/*!40000 ALTER TABLE `sys_related` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table sys_users
# ------------------------------------------------------------

DROP TABLE IF EXISTS `sys_users`;

CREATE TABLE `sys_users` (
  `ID` smallint(6) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL DEFAULT '',
  `login` varchar(32) NOT NULL DEFAULT '',
  `password_digest` varchar(255) NOT NULL DEFAULT '',
  `email` varchar(128) NOT NULL DEFAULT '',
  `id_group_user` varchar(255) NOT NULL DEFAULT '1',
  `vdate` datetime DEFAULT NULL,
  `count` tinyint(3) unsigned DEFAULT NULL,
  `btime` datetime DEFAULT NULL,
  `bip` varchar(15) NOT NULL DEFAULT '',
  `settings` text,
  `users_list` text NOT NULL,
  `groups_list` varchar(30) NOT NULL,
  `sys` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `access` blob,
  `vfe` tinyint(1) NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `login` (`login`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 PACK_KEYS=0 COMMENT='Таблица пользователей';

LOCK TABLES `sys_users` WRITE;
/*!40000 ALTER TABLE `sys_users` DISABLE KEYS */;

INSERT INTO `sys_users` (`ID`, `name`, `login`, `password_digest`, `email`, `id_group_user`, `vdate`, `count`, `btime`, `bip`, `settings`, `users_list`, `groups_list`, `sys`, `access`, `vfe`, `updated_at`, `created_at`)
VALUES
	(1,'Системный администратор','root','$2a$06$LUDXRF/MXxDLKRXNcUqzKOiX106yfsAExsnieDocZo8mJaPeuzaDu','dev@ifrog.ru,rn.dev@ifrog.ru','6',NULL,0,NULL,'10.0.2.2','catalog_data_catalog_categorys_page=1\nkeys_keys_catalog_page=1\nsysusers_sys_users_pcol=25\nimages_page_doptable=1\nlists_lst_group_user_page=1\ntexts_texts_floating_ru_page=1\nbanners_qedit=1\nstat_page_doptable=3\nlang=ru\ncatalog_data_catalog_items_asc=asc\ncatalog_data_catalog_items_page=1\ntexts_texts_main_ru_pcol=25\nvars_sys_vars_pcol=50\nbanners_data_banner_page=1\nfaq_data_faq_page=1\nusers_data_users_page=1\ntexts_sfield=ID\nstat_pcol_doptable=25\nsyslogs_sys_datalogs_page=1\nimages_sfield=ID\nkeys_keys_texts_page=1\nkeys_keys_keys_page=1\nredirects_data_redirects_page=1\ntexts_texts_news_ru_page=1\n_texts_floating_ru_sfield=ID\naccess_sys_access_page=1\ncatalog_data_catalog_items_sfield=name\nkeys_keys_catalog_filter_take=1\nkeys_keys_styles_page=1\ntexts_pcol=25\nkeys_keys_faq_page=1\ntexts_razdel=1\n_page=1\nkeys_keys_vars_page=1\nrightwin_hidden=1\nlists_lst_advert_users_page=1\nvars_sys_vars_page=1\nimages_images_gallery_page=1\ntexts_filter_tdatepref=>\nsyslogs_sys_datalogs_pcol=25\nimages_page=1\nsyslogs_sys_datalogs_filter_rdate=2014-02-20 00:00:00\nredirects_data_redirects_pcol=25\nkeys_keys_auth_page=1\nsubscribe_dtbl_subscribe_users_page=1\nimages_images_gallery_pcol=25\nsyslogs_sys_datalogs_filter_rdatepref=>\ntexts_texts_main_ru_sfield=ID\ntexts_texts_floating_ru_sfield=ID\nlists_lst_advert_block_page=1\n_sfield=ID\nkeys_keys_mainconfig_pcol=25\nbanners_data_banner_advert_block_page=1\nkeys_keys_lists_page=1\ntexts_qedit=1\ntexts_texts_news_ru_sfield=ID\nseo_data_seo_meta_page=1\ntexts_texts_main_ru_page=1\ncatalog_qedit=1\ncatalog_data_catalog_brands_page=1\n_texts_floating_ru_page=1\nimages_razdel=1\ntexts_page=1\nsubscribe_data_subscribe_page=1\nbanners_data_banner_advert_users_page=1\nsysusers_sys_users_page=1\nkeys_keys_access_page=1\ncatalog_data_catalog_items_pcol=25\nkeys_keys_banners_page=1\nkeys_keys_mainconfig_page=1','1','0',1,X'65794A746232523162434936657949324F4349364D5377694E6A59694F6A4573496A55694F6A4573496A5978496A6F784C4349324E7949364D5377694E6A4D694F6A4573496A5930496A6F784C434935496A6F784C4349784D6949364D5377694D5349364D5377694D5445694F6A4573496A5977496A6F784C4349324F5349364D5377694D7A49694F6A4573496A6378496A6F784C43497A496A6F784C434932496A6F784C4349334D4349364D5377694E4349364D5377694E6A49694F6A463966512D3D',1,'2011-11-16 22:28:16','2009-01-31 16:23:35'),
	(3,'Администратор','user','$2a$06$Jy7yYkrAQ1bPLB/qOSH/Yu8wuhLzpJt9BlAPk1OyOUcwpWu.qg4Su','ifrogseo@gmail.com','6',NULL,0,NULL,'10.0.2.2','lang=ru\ntexts_sfield=ID\ntexts_pcol=25\ncatalog_data_catalog_items_page=1\ntexts_razdel=1\nvars_sys_vars_page=1\ntexts_page=1\nlists_lst_group_user_page=1\n_sfield=ID','3','',0,X'65794A746232523162434936657949784D6949364D5377694E4349364D5377694E6A6B694F6A4573496A5978496A6F784C43497A4D6949364D5377694E6A63694F6A4573496A5934496A6F784C4349324D4349364D5377694D7949364D5377694E6A49694F6A463966512D3D',1,'0000-00-00 00:00:00','2011-05-07 19:14:35');

/*!40000 ALTER TABLE `sys_users` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table sys_users_session
# ------------------------------------------------------------

DROP TABLE IF EXISTS `sys_users_session`;

CREATE TABLE `sys_users_session` (
  `cck` varchar(32) NOT NULL,
  `time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `host` varchar(100) NOT NULL,
  `ip` varchar(100) NOT NULL,
  `id_user` int(6) unsigned NOT NULL,
  `data` blob,
  PRIMARY KEY (`id_user`,`cck`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

LOCK TABLES `sys_users_session` WRITE;
/*!40000 ALTER TABLE `sys_users_session` DISABLE KEYS */;

INSERT INTO `sys_users_session` (`cck`, `time`, `host`, `ip`, `id_user`, `data`)
VALUES
	('369b276919f70dbd6a559f3e3f62cfdc','2015-11-05 15:38:57','localhost:3000','127.0.0.1',1,NULL);

/*!40000 ALTER TABLE `sys_users_session` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table sys_vars
# ------------------------------------------------------------

DROP TABLE IF EXISTS `sys_vars`;

CREATE TABLE `sys_vars` (
  `ID` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL DEFAULT '',
  `id_program` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `users_list` varchar(100) NOT NULL,
  `groups_list` varchar(100) NOT NULL DEFAULT '',
  `envkey` varchar(32) NOT NULL DEFAULT '',
  `envvalue` text NOT NULL,
  `settings` varchar(255) NOT NULL,
  `types` varchar(32) NOT NULL DEFAULT '',
  `comment` text NOT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `operator` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `id_program` (`id_program`,`envkey`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 PACK_KEYS=0 COMMENT='Глобальные переменные';

LOCK TABLES `sys_vars` WRITE;
/*!40000 ALTER TABLE `sys_vars` DISABLE KEYS */;

INSERT INTO `sys_vars` (`ID`, `name`, `id_program`, `users_list`, `groups_list`, `envkey`, `envvalue`, `settings`, `types`, `comment`, `updated_at`, `operator`)
VALUES
	(1,'Название сайта',0,'','3=6','site_name','GG v9','','s','',NULL,NULL),
	(4,'Сохранять лог операций дней',0,'','6','time_log','60','','d','60',NULL,NULL),
	(5,'E-mail администратора сайта',0,'','3=6','email_admin','vdovin.a.a@gmail.com\r\n','','email','',NULL,NULL),
	(6,'Максимальный размер картинок в файлменеджере',0,'1=3','3=6','filemanager_max_image_size','1000','','d','1000',NULL,NULL),
	(10,'Тестовая список',0,'1','6','test','1=2=3','list=1|Параметр 1~2|Параметр 2~3|Параметр 3\n','list_chb','',NULL,NULL),
	(11,'Uploadcare ключ',0,'','6','UPLOADCARE_PUBLIC_KEY','2d0e67e1e5f8a8d96345','','s','Введите ключ для сервиса Uploadcare. После добавления ключа требуется перезагрузка административной панели ( Ctrl+F5 )',NULL,NULL);

/*!40000 ALTER TABLE `sys_vars` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table texts_main_ru
# ------------------------------------------------------------

DROP TABLE IF EXISTS `texts_main_ru`;

CREATE TABLE `texts_main_ru` (
  `ID` int(10) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL DEFAULT '',
  `h1` varchar(255) NOT NULL,
  `alias` varchar(128) NOT NULL DEFAULT '',
  `title` varchar(255) NOT NULL DEFAULT '',
  `map` varchar(255) NOT NULL DEFAULT '',
  `keywords` text NOT NULL,
  `description` text NOT NULL,
  `rating` smallint(5) unsigned NOT NULL DEFAULT '0',
  `texts_main_ru` int(10) unsigned NOT NULL DEFAULT '0',
  `operator` varchar(64) CHARACTER SET cp1251 NOT NULL DEFAULT '',
  `menu` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `viewtext` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `delnot` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `link` varchar(50) NOT NULL DEFAULT '',
  `layout` varchar(50) NOT NULL DEFAULT '',
  `url_for` varchar(150) NOT NULL,
  `text` text,
  `updated_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `alias` (`alias`),
  KEY `rating` (`rating`,`menu`,`viewtext`),
  FULLTEXT KEY `text` (`text`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 PACK_KEYS=0;

LOCK TABLES `texts_main_ru` WRITE;
/*!40000 ALTER TABLE `texts_main_ru` DISABLE KEYS */;

INSERT INTO `texts_main_ru` (`ID`, `name`, `h1`, `alias`, `title`, `map`, `keywords`, `description`, `rating`, `texts_main_ru`, `operator`, `menu`, `viewtext`, `delnot`, `link`, `layout`, `url_for`, `text`, `updated_at`, `created_at`)
VALUES
	(1,'Главная страница123','','glavnaya_stranica1','Главная страница22','30.437101075943225,59.94228319196769','Главная страница','Главная страница',1,0,'root',0,1,1,'','default','','<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat. Ut wisi enim ad minim veniam, quis nostrud exerci tation ullamcorper suscipit lobortis nisl ut aliquip ex ea commodo consequat. Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi.</p>\n\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat vol</p>','2015-10-26 14:07:33','2012-03-05 13:28:44'),
	(21,'О студии','','about','О студии','','О студии','О студии',3,0,'root',1,1,1,'','default','','','2014-02-20 14:20:27','2012-10-19 12:43:19'),
	(23,'Портфолио','','portfolio','Портфолио','','Портфолио','Портфолио',5,0,'root',1,1,1,'','default','','','2014-02-20 14:20:27','2012-10-19 12:43:56'),
	(24,'Контакты','','contacts','Контакты','','Контакты','Контакты',6,0,'root',1,1,1,'','default','feedback','','2014-02-20 14:20:27','2012-10-19 12:44:19');

/*!40000 ALTER TABLE `texts_main_ru` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table texts_news_ru
# ------------------------------------------------------------

DROP TABLE IF EXISTS `texts_news_ru`;

CREATE TABLE `texts_news_ru` (
  `ID` int(10) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL DEFAULT '',
  `alias` varchar(255) NOT NULL,
  `title` varchar(255) NOT NULL DEFAULT '',
  `description` varchar(255) NOT NULL DEFAULT '',
  `keywords` varchar(255) NOT NULL DEFAULT '',
  `tdate` date NOT NULL DEFAULT '0000-00-00',
  `viewtext` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `operator` varchar(50) NOT NULL DEFAULT '',
  `text` text NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  PRIMARY KEY (`ID`),
  FULLTEXT KEY `text` (`text`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Новостная лента';

LOCK TABLES `texts_news_ru` WRITE;
/*!40000 ALTER TABLE `texts_news_ru` DISABLE KEYS */;

INSERT INTO `texts_news_ru` (`ID`, `name`, `alias`, `title`, `description`, `keywords`, `tdate`, `viewtext`, `operator`, `text`, `updated_at`, `created_at`)
VALUES
	(1,'Sed scelerisque magnis augue, lectus nisi porttitor dolor, aliquet adipiscing et vel','Sed scelerisque magnis augue, lectus nisi porttitor dolor, aliquet adipiscing et vel','Sed scelerisque magnis augue, lectus nisi porttitor dolor, aliquet adipiscing et vel','Sed scelerisque magnis augue, lectus nisi porttitor dolor, aliquet adipiscing et vel','Sed scelerisque magnis augue, lectus nisi porttitor dolor, aliquet adipiscing et vel','2012-03-11',1,'root','<p>Velit nunc tempor mattis pulvinar mattis. Et enim mus, etiam! Ridiculus a dolor! Adipiscing scelerisque velit? Ultricies turpis, amet tristique, sed. Dapibus scelerisque magna. Placerat, nec cum parturient porttitor tincidunt, adipiscing, scelerisque aliquam pid purus turpis sed vut in sagittis! Habitasse tempor sed parturient? Eros! Augue pellentesque magnis, in a tempor cursus. Ultricies sit sed scelerisque lundium, nascetur pellentesque nunc aenean ridiculus magna? Ac egestas. Rhoncus! Penatibus sed, aenean ac mattis nec, platea enim! Et, aliquam scelerisque mid cum est, facilisis augue turpis hac. Magnis est sit. Rhoncus, a! Integer, et. Nisi amet facilisis, aliquet sed! Sed dolor turpis, urna. Mauris mauris vel nisi augue cras scelerisque rhoncus, non sed ultricies etiam, cum lorem ut eros, cum phasellus, dignissim. Augue.</p>\n\n<p>\nEst lectus in quis, integer lorem integer dis sed nec a, ac adipiscing turpis, ridiculus nunc elit elit placerat natoque ac vut nec? Pulvinar quis platea pulvinar, tempor purus et, proin? Porta, mattis amet rhoncus dolor magna hac cursus? Scelerisque urna ultricies, augue, porttitor odio. Nec nunc, dapibus, amet odio duis! Dis amet rhoncus phasellus, elementum adipiscing, massa platea risus pulvinar. Vel eros arcu mauris porttitor? Ac, lacus. Sit purus aenean in augue non nisi diam turpis. Elementum in dapibus augue purus dis! Lundium urna in! Quis! Elementum enim nascetur eu sed aenean dapibus enim porta! Rhoncus adipiscing magnis scelerisque mid vel in sociis ac porttitor mus elementum amet sit. A hac adipiscing adipiscing in urna nec, rhoncus dapibus.</p>\n\n<p>\nIn mauris. Duis, rhoncus adipiscing elit! Eros elementum a habitasse est, mid tempor lundium turpis mauris mid. Nisi. Amet, cursus purus enim in dictumst? Odio adipiscing magnis et hac magna rhoncus, sed, nunc tortor risus? Rhoncus cursus! Ac et, tortor cum placerat nisi rhoncus dictumst porttitor dignissim lectus lorem dictumst, magna, cum elementum adipiscing, montes sit phasellus egestas odio odio dapibus. Adipiscing tincidunt nisi vut, augue hac, ac in turpis aliquam! Scelerisque porta porttitor nisi in dapibus etiam vel? Nascetur magna turpis placerat, vel nec pulvinar enim! Hac auctor enim pulvinar porttitor? Tortor, cum tristique sed phasellus ultrices enim integer cum eros, sed elit! Sit duis porttitor et risus lorem magnis, dictumst in. Cras integer nisi habitasse facilisis, sed.</p>\n<p>\nQuis et est platea nec sagittis tristique, nec amet? Vel lacus, facilisis, et, adipiscing scelerisque ac, platea, cursus magnis odio diam platea risus? Augue? Integer nec aliquet egestas vut elementum nunc lundium a, nascetur augue. Sit urna massa, quis ultrices dapibus? Integer scelerisque, adipiscing enim. Montes mattis tincidunt montes placerat tincidunt penatibus tincidunt vel rhoncus? Etiam sit in nunc, ut. Scelerisque amet velit mauris tincidunt augue lacus natoque, penatibus platea ac! Auctor lacus, vut. Sed, eros odio? Lundium nascetur, cursus platea! Cum ac? Sit sit risus non? Ac montes? Sed adipiscing sed facilisis hac, pellentesque in vel cum urna montes quis sed, urna habitasse vut risus mid, amet natoque placerat massa, dignissim in facilisis, dictumst, sed turpis sed magna.</p>','2012-10-11 12:42:39','2011-03-29 11:17:43'),
	(2,'Mid mus eu duis ut! Nascetur scelerisque adipiscing, magnis, ut tortor penatibus pulvinar est pulvinar','Mid mus eu duis ut! Nascetur scelerisque adipiscing, magnis, ut tortor penatibus pulvinar est pulvinar','Mid mus eu duis ut! Nascetur scelerisque adipiscing, magnis, ut tortor penatibus pulvinar est pulvinar','Mid mus eu duis ut! Nascetur scelerisque adipiscing, magnis, ut tortor penatibus pulvinar est pulvinar','Mid mus eu duis ut! Nascetur scelerisque adipiscing, magnis, ut tortor penatibus pulvinar est pulvinar','2012-03-10',1,'root','<p>Velit nunc tempor mattis pulvinar mattis. Et enim mus, etiam! Ridiculus a dolor! Adipiscing scelerisque velit? Ultricies turpis, amet tristique, sed. Dapibus scelerisque magna. Placerat, nec cum parturient porttitor tincidunt, adipiscing, scelerisque aliquam pid purus turpis sed vut in sagittis! Habitasse tempor sed parturient? Eros! Augue pellentesque magnis, in a tempor cursus. Ultricies sit sed scelerisque lundium, nascetur pellentesque nunc aenean ridiculus magna? Ac egestas. Rhoncus! Penatibus sed, aenean ac mattis nec, platea enim! Et, aliquam scelerisque mid cum est, facilisis augue turpis hac. Magnis est sit. Rhoncus, a! Integer, et. Nisi amet facilisis, aliquet sed! Sed dolor turpis, urna. Mauris mauris vel nisi augue cras scelerisque rhoncus, non sed ultricies etiam, cum lorem ut eros, cum phasellus, dignissim. Augue.</p>\n\n<p>\nEst lectus in quis, integer lorem integer dis sed nec a, ac adipiscing turpis, ridiculus nunc elit elit placerat natoque ac vut nec? Pulvinar quis platea pulvinar, tempor purus et, proin? Porta, mattis amet rhoncus dolor magna hac cursus? Scelerisque urna ultricies, augue, porttitor odio. Nec nunc, dapibus, amet odio duis! Dis amet rhoncus phasellus, elementum adipiscing, massa platea risus pulvinar. Vel eros arcu mauris porttitor? Ac, lacus. Sit purus aenean in augue non nisi diam turpis. Elementum in dapibus augue purus dis! Lundium urna in! Quis! Elementum enim nascetur eu sed aenean dapibus enim porta! Rhoncus adipiscing magnis scelerisque mid vel in sociis ac porttitor mus elementum amet sit. A hac adipiscing adipiscing in urna nec, rhoncus dapibus.</p>\n\n<p>\nIn mauris. Duis, rhoncus adipiscing elit! Eros elementum a habitasse est, mid tempor lundium turpis mauris mid. Nisi. Amet, cursus purus enim in dictumst? Odio adipiscing magnis et hac magna rhoncus, sed, nunc tortor risus? Rhoncus cursus! Ac et, tortor cum placerat nisi rhoncus dictumst porttitor dignissim lectus lorem dictumst, magna, cum elementum adipiscing, montes sit phasellus egestas odio odio dapibus. Adipiscing tincidunt nisi vut, augue hac, ac in turpis aliquam! Scelerisque porta porttitor nisi in dapibus etiam vel? Nascetur magna turpis placerat, vel nec pulvinar enim! Hac auctor enim pulvinar porttitor? Tortor, cum tristique sed phasellus ultrices enim integer cum eros, sed elit! Sit duis porttitor et risus lorem magnis, dictumst in. Cras integer nisi habitasse facilisis, sed.</p>\n<p>\nQuis et est platea nec sagittis tristique, nec amet? Vel lacus, facilisis, et, adipiscing scelerisque ac, platea, cursus magnis odio diam platea risus? Augue? Integer nec aliquet egestas vut elementum nunc lundium a, nascetur augue. Sit urna massa, quis ultrices dapibus? Integer scelerisque, adipiscing enim. Montes mattis tincidunt montes placerat tincidunt penatibus tincidunt vel rhoncus? Etiam sit in nunc, ut. Scelerisque amet velit mauris tincidunt augue lacus natoque, penatibus platea ac! Auctor lacus, vut. Sed, eros odio? Lundium nascetur, cursus platea! Cum ac? Sit sit risus non? Ac montes? Sed adipiscing sed facilisis hac, pellentesque in vel cum urna montes quis sed, urna habitasse vut risus mid, amet natoque placerat massa, dignissim in facilisis, dictumst, sed turpis sed magna.</p>','2012-03-11 14:52:41','0000-00-00 11:18:15'),
	(3,'Dis pellentesque placerat amet quis nascetur sociis sed a, dictumst ','Dis pellentesque placerat amet quis nascetur sociis sed a, dictumst ','Dis pellentesque placerat amet quis nascetur sociis sed a, dictumst ','Dis pellentesque placerat amet quis nascetur sociis sed a, dictumst ','Dis pellentesque placerat amet quis nascetur sociis sed a, dictumst ','2011-06-03',1,'','<p>Velit nunc tempor mattis pulvinar mattis. Et enim mus, etiam! Ridiculus a dolor! Adipiscing scelerisque velit? Ultricies turpis, amet tristique, sed. Dapibus scelerisque magna. Placerat, nec cum parturient porttitor tincidunt, adipiscing, scelerisque aliquam pid purus turpis sed vut in sagittis! Habitasse tempor sed parturient? Eros! Augue pellentesque magnis, in a tempor cursus. Ultricies sit sed scelerisque lundium, nascetur pellentesque nunc aenean ridiculus magna? Ac egestas. Rhoncus! Penatibus sed, aenean ac mattis nec, platea enim! Et, aliquam scelerisque mid cum est, facilisis augue turpis hac. Magnis est sit. Rhoncus, a! Integer, et. Nisi amet facilisis, aliquet sed! Sed dolor turpis, urna. Mauris mauris vel nisi augue cras scelerisque rhoncus, non sed ultricies etiam, cum lorem ut eros, cum phasellus, dignissim. Augue.</p>\n\n<p>\nEst lectus in quis, integer lorem integer dis sed nec a, ac adipiscing turpis, ridiculus nunc elit elit placerat natoque ac vut nec? Pulvinar quis platea pulvinar, tempor purus et, proin? Porta, mattis amet rhoncus dolor magna hac cursus? Scelerisque urna ultricies, augue, porttitor odio. Nec nunc, dapibus, amet odio duis! Dis amet rhoncus phasellus, elementum adipiscing, massa platea risus pulvinar. Vel eros arcu mauris porttitor? Ac, lacus. Sit purus aenean in augue non nisi diam turpis. Elementum in dapibus augue purus dis! Lundium urna in! Quis! Elementum enim nascetur eu sed aenean dapibus enim porta! Rhoncus adipiscing magnis scelerisque mid vel in sociis ac porttitor mus elementum amet sit. A hac adipiscing adipiscing in urna nec, rhoncus dapibus.</p>\n\n<p>\nIn mauris. Duis, rhoncus adipiscing elit! Eros elementum a habitasse est, mid tempor lundium turpis mauris mid. Nisi. Amet, cursus purus enim in dictumst? Odio adipiscing magnis et hac magna rhoncus, sed, nunc tortor risus? Rhoncus cursus! Ac et, tortor cum placerat nisi rhoncus dictumst porttitor dignissim lectus lorem dictumst, magna, cum elementum adipiscing, montes sit phasellus egestas odio odio dapibus. Adipiscing tincidunt nisi vut, augue hac, ac in turpis aliquam! Scelerisque porta porttitor nisi in dapibus etiam vel? Nascetur magna turpis placerat, vel nec pulvinar enim! Hac auctor enim pulvinar porttitor? Tortor, cum tristique sed phasellus ultrices enim integer cum eros, sed elit! Sit duis porttitor et risus lorem magnis, dictumst in. Cras integer nisi habitasse facilisis, sed.</p>\n<p>\nQuis et est platea nec sagittis tristique, nec amet? Vel lacus, facilisis, et, adipiscing scelerisque ac, platea, cursus magnis odio diam platea risus? Augue? Integer nec aliquet egestas vut elementum nunc lundium a, nascetur augue. Sit urna massa, quis ultrices dapibus? Integer scelerisque, adipiscing enim. Montes mattis tincidunt montes placerat tincidunt penatibus tincidunt vel rhoncus? Etiam sit in nunc, ut. Scelerisque amet velit mauris tincidunt augue lacus natoque, penatibus platea ac! Auctor lacus, vut. Sed, eros odio? Lundium nascetur, cursus platea! Cum ac? Sit sit risus non? Ac montes? Sed adipiscing sed facilisis hac, pellentesque in vel cum urna montes quis sed, urna habitasse vut risus mid, amet natoque placerat massa, dignissim in facilisis, dictumst, sed turpis sed magna.</p>','0000-00-00 00:00:00','0000-00-00 00:00:00'),
	(4,'Habitasse tempor elementum parturient scelerisque elementum ','Habitasse tempor elementum parturient scelerisque elementum ','Habitasse tempor elementum parturient scelerisque elementum ','Habitasse tempor elementum parturient scelerisque elementum ','Habitasse tempor elementum parturient scelerisque elementum ','2009-04-12',1,'','<p>Velit nunc tempor mattis pulvinar mattis. Et enim mus, etiam! Ridiculus a dolor! Adipiscing scelerisque velit? Ultricies turpis, amet tristique, sed. Dapibus scelerisque magna. Placerat, nec cum parturient porttitor tincidunt, adipiscing, scelerisque aliquam pid purus turpis sed vut in sagittis! Habitasse tempor sed parturient? Eros! Augue pellentesque magnis, in a tempor cursus. Ultricies sit sed scelerisque lundium, nascetur pellentesque nunc aenean ridiculus magna? Ac egestas. Rhoncus! Penatibus sed, aenean ac mattis nec, platea enim! Et, aliquam scelerisque mid cum est, facilisis augue turpis hac. Magnis est sit. Rhoncus, a! Integer, et. Nisi amet facilisis, aliquet sed! Sed dolor turpis, urna. Mauris mauris vel nisi augue cras scelerisque rhoncus, non sed ultricies etiam, cum lorem ut eros, cum phasellus, dignissim. Augue.</p>\n\n<p>\nEst lectus in quis, integer lorem integer dis sed nec a, ac adipiscing turpis, ridiculus nunc elit elit placerat natoque ac vut nec? Pulvinar quis platea pulvinar, tempor purus et, proin? Porta, mattis amet rhoncus dolor magna hac cursus? Scelerisque urna ultricies, augue, porttitor odio. Nec nunc, dapibus, amet odio duis! Dis amet rhoncus phasellus, elementum adipiscing, massa platea risus pulvinar. Vel eros arcu mauris porttitor? Ac, lacus. Sit purus aenean in augue non nisi diam turpis. Elementum in dapibus augue purus dis! Lundium urna in! Quis! Elementum enim nascetur eu sed aenean dapibus enim porta! Rhoncus adipiscing magnis scelerisque mid vel in sociis ac porttitor mus elementum amet sit. A hac adipiscing adipiscing in urna nec, rhoncus dapibus.</p>\n\n<p>\nIn mauris. Duis, rhoncus adipiscing elit! Eros elementum a habitasse est, mid tempor lundium turpis mauris mid. Nisi. Amet, cursus purus enim in dictumst? Odio adipiscing magnis et hac magna rhoncus, sed, nunc tortor risus? Rhoncus cursus! Ac et, tortor cum placerat nisi rhoncus dictumst porttitor dignissim lectus lorem dictumst, magna, cum elementum adipiscing, montes sit phasellus egestas odio odio dapibus. Adipiscing tincidunt nisi vut, augue hac, ac in turpis aliquam! Scelerisque porta porttitor nisi in dapibus etiam vel? Nascetur magna turpis placerat, vel nec pulvinar enim! Hac auctor enim pulvinar porttitor? Tortor, cum tristique sed phasellus ultrices enim integer cum eros, sed elit! Sit duis porttitor et risus lorem magnis, dictumst in. Cras integer nisi habitasse facilisis, sed.</p>\n<p>\nQuis et est platea nec sagittis tristique, nec amet? Vel lacus, facilisis, et, adipiscing scelerisque ac, platea, cursus magnis odio diam platea risus? Augue? Integer nec aliquet egestas vut elementum nunc lundium a, nascetur augue. Sit urna massa, quis ultrices dapibus? Integer scelerisque, adipiscing enim. Montes mattis tincidunt montes placerat tincidunt penatibus tincidunt vel rhoncus? Etiam sit in nunc, ut. Scelerisque amet velit mauris tincidunt augue lacus natoque, penatibus platea ac! Auctor lacus, vut. Sed, eros odio? Lundium nascetur, cursus platea! Cum ac? Sit sit risus non? Ac montes? Sed adipiscing sed facilisis hac, pellentesque in vel cum urna montes quis sed, urna habitasse vut risus mid, amet natoque placerat massa, dignissim in facilisis, dictumst, sed turpis sed magna.</p>','0000-00-00 00:00:00','0000-00-00 00:00:00'),
	(5,'Platea magnis! Aliquam! Aliquam, turpis sit velit sociis pulvinar','Platea magnis_Aliquam_Aliquam, turpis sit velit sociis pulvinar','Platea magnis! Aliquam! Aliquam, turpis sit velit sociis pulvinar','Platea magnis! Aliquam! Aliquam, turpis sit velit sociis pulvinar','Platea magnis! Aliquam! Aliquam, turpis sit velit sociis pulvinar','2004-11-21',1,'','<p>Velit nunc tempor mattis pulvinar mattis. Et enim mus, etiam! Ridiculus a dolor! Adipiscing scelerisque velit? Ultricies turpis, amet tristique, sed. Dapibus scelerisque magna. Placerat, nec cum parturient porttitor tincidunt, adipiscing, scelerisque aliquam pid purus turpis sed vut in sagittis! Habitasse tempor sed parturient? Eros! Augue pellentesque magnis, in a tempor cursus. Ultricies sit sed scelerisque lundium, nascetur pellentesque nunc aenean ridiculus magna? Ac egestas. Rhoncus! Penatibus sed, aenean ac mattis nec, platea enim! Et, aliquam scelerisque mid cum est, facilisis augue turpis hac. Magnis est sit. Rhoncus, a! Integer, et. Nisi amet facilisis, aliquet sed! Sed dolor turpis, urna. Mauris mauris vel nisi augue cras scelerisque rhoncus, non sed ultricies etiam, cum lorem ut eros, cum phasellus, dignissim. Augue.</p>\n\n<p>\nEst lectus in quis, integer lorem integer dis sed nec a, ac adipiscing turpis, ridiculus nunc elit elit placerat natoque ac vut nec? Pulvinar quis platea pulvinar, tempor purus et, proin? Porta, mattis amet rhoncus dolor magna hac cursus? Scelerisque urna ultricies, augue, porttitor odio. Nec nunc, dapibus, amet odio duis! Dis amet rhoncus phasellus, elementum adipiscing, massa platea risus pulvinar. Vel eros arcu mauris porttitor? Ac, lacus. Sit purus aenean in augue non nisi diam turpis. Elementum in dapibus augue purus dis! Lundium urna in! Quis! Elementum enim nascetur eu sed aenean dapibus enim porta! Rhoncus adipiscing magnis scelerisque mid vel in sociis ac porttitor mus elementum amet sit. A hac adipiscing adipiscing in urna nec, rhoncus dapibus.</p>\n\n<p>\nIn mauris. Duis, rhoncus adipiscing elit! Eros elementum a habitasse est, mid tempor lundium turpis mauris mid. Nisi. Amet, cursus purus enim in dictumst? Odio adipiscing magnis et hac magna rhoncus, sed, nunc tortor risus? Rhoncus cursus! Ac et, tortor cum placerat nisi rhoncus dictumst porttitor dignissim lectus lorem dictumst, magna, cum elementum adipiscing, montes sit phasellus egestas odio odio dapibus. Adipiscing tincidunt nisi vut, augue hac, ac in turpis aliquam! Scelerisque porta porttitor nisi in dapibus etiam vel? Nascetur magna turpis placerat, vel nec pulvinar enim! Hac auctor enim pulvinar porttitor? Tortor, cum tristique sed phasellus ultrices enim integer cum eros, sed elit! Sit duis porttitor et risus lorem magnis, dictumst in. Cras integer nisi habitasse facilisis, sed.</p>\n<p>\nQuis et est platea nec sagittis tristique, nec amet? Vel lacus, facilisis, et, adipiscing scelerisque ac, platea, cursus magnis odio diam platea risus? Augue? Integer nec aliquet egestas vut elementum nunc lundium a, nascetur augue. Sit urna massa, quis ultrices dapibus? Integer scelerisque, adipiscing enim. Montes mattis tincidunt montes placerat tincidunt penatibus tincidunt vel rhoncus? Etiam sit in nunc, ut. Scelerisque amet velit mauris tincidunt augue lacus natoque, penatibus platea ac! Auctor lacus, vut. Sed, eros odio? Lundium nascetur, cursus platea! Cum ac? Sit sit risus non? Ac montes? Sed adipiscing sed facilisis hac, pellentesque in vel cum urna montes quis sed, urna habitasse vut risus mid, amet natoque placerat massa, dignissim in facilisis, dictumst, sed turpis sed magna.</p>','0000-00-00 00:00:00','0000-00-00 00:00:00');

/*!40000 ALTER TABLE `texts_news_ru` ENABLE KEYS */;
UNLOCK TABLES;



/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
