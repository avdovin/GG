-- --------------------------------------------------------
-- Хост:                         servant.local
-- Версия сервера:               5.5.46-0ubuntu0.14.04.2 - (Ubuntu)
-- ОС Сервера:                   debian-linux-gnu
-- HeidiSQL Версия:              9.1.0.4867
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;

-- Дамп структуры для таблица dev_fabprint.anonymous_session
CREATE TABLE IF NOT EXISTS `anonymous_session` (
  `cck` varchar(32) NOT NULL,
  `time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `host` varchar(100) NOT NULL,
  `ip` varchar(100) NOT NULL,
  `data` blob NOT NULL,
  `user_id` int(6) unsigned DEFAULT NULL,
  PRIMARY KEY (`cck`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- Дамп данных таблицы dev_fabprint.anonymous_session: 0 rows
/*!40000 ALTER TABLE `anonymous_session` DISABLE KEYS */;
/*!40000 ALTER TABLE `anonymous_session` ENABLE KEYS */;


-- Дамп структуры для таблица dev_fabprint.captcha
CREATE TABLE IF NOT EXISTS `captcha` (
  `code` varchar(100) NOT NULL,
  `time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`code`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- Дамп данных таблицы dev_fabprint.captcha: 0 rows
/*!40000 ALTER TABLE `captcha` DISABLE KEYS */;
/*!40000 ALTER TABLE `captcha` ENABLE KEYS */;


-- Дамп структуры для таблица dev_fabprint.data_banner
CREATE TABLE IF NOT EXISTS `data_banner` (
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
) ENGINE=MyISAM AUTO_INCREMENT=7 DEFAULT CHARSET=utf8 COMMENT='Хранилище рекламы';

-- Дамп данных таблицы dev_fabprint.data_banner: 0 rows
/*!40000 ALTER TABLE `data_banner` DISABLE KEYS */;
/*!40000 ALTER TABLE `data_banner` ENABLE KEYS */;


-- Дамп структуры для таблица dev_fabprint.data_banner_advert_block
CREATE TABLE IF NOT EXISTS `data_banner_advert_block` (
  `ID` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(128) NOT NULL DEFAULT '',
  `per_click` int(6) NOT NULL DEFAULT '0',
  `per_show` int(6) NOT NULL DEFAULT '0',
  `width` smallint(5) unsigned NOT NULL DEFAULT '0',
  `height` smallint(5) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`ID`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COMMENT='СПРАВОЧНИК рекламных блоков';

-- Дамп данных таблицы dev_fabprint.data_banner_advert_block: 0 rows
/*!40000 ALTER TABLE `data_banner_advert_block` DISABLE KEYS */;
/*!40000 ALTER TABLE `data_banner_advert_block` ENABLE KEYS */;


-- Дамп структуры для таблица dev_fabprint.data_banner_advert_users
CREATE TABLE IF NOT EXISTS `data_banner_advert_users` (
  `ID` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL DEFAULT '',
  `email` varchar(50) NOT NULL DEFAULT '',
  `phone` varchar(100) NOT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `email` (`email`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COMMENT='Список пользователей банерокрут';

-- Дамп данных таблицы dev_fabprint.data_banner_advert_users: 0 rows
/*!40000 ALTER TABLE `data_banner_advert_users` DISABLE KEYS */;
/*!40000 ALTER TABLE `data_banner_advert_users` ENABLE KEYS */;


-- Дамп структуры для таблица dev_fabprint.data_catalog_brands
CREATE TABLE IF NOT EXISTS `data_catalog_brands` (
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
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

-- Дамп данных таблицы dev_fabprint.data_catalog_brands: 0 rows
/*!40000 ALTER TABLE `data_catalog_brands` DISABLE KEYS */;
/*!40000 ALTER TABLE `data_catalog_brands` ENABLE KEYS */;


-- Дамп структуры для таблица dev_fabprint.data_catalog_categories
CREATE TABLE IF NOT EXISTS `data_catalog_categories` (
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
  `parent_category_id` int(6) unsigned NOT NULL DEFAULT '0',
  `pict` varchar(255) DEFAULT '',
  `updated_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `rating` (`rating`)
) ENGINE=MyISAM AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;

-- Дамп данных таблицы dev_fabprint.data_catalog_categories: 0 rows
/*!40000 ALTER TABLE `data_catalog_categories` DISABLE KEYS */;
/*!40000 ALTER TABLE `data_catalog_categories` ENABLE KEYS */;


-- Дамп структуры для таблица dev_fabprint.data_catalog_items
CREATE TABLE IF NOT EXISTS `data_catalog_items` (
  `ID` bigint(7) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `title` varchar(255) DEFAULT NULL,
  `keywords` varchar(255) DEFAULT NULL,
  `description` text,
  `alias` varchar(255) NOT NULL,
  `rating` smallint(4) unsigned NOT NULL DEFAULT '0',
  `text` text NOT NULL,
  `images` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `operator` varchar(64) NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `category_id` int(6) unsigned NOT NULL DEFAULT '0',
  `subcategory_id` int(6) unsigned NOT NULL DEFAULT '0',
  `brand_id` int(6) unsigned NOT NULL DEFAULT '0',
  `sizes` varchar(255) DEFAULT NULL,
  `articul` varchar(100) DEFAULT NULL,
  `price` decimal(10,2) unsigned NOT NULL DEFAULT '0.00',
  `gender` smallint(3) unsigned NOT NULL DEFAULT '0',
  `pict` varchar(255) DEFAULT NULL,
  `active` tinyint(1) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`ID`),
  UNIQUE KEY `alias` (`alias`),
  KEY `rating` (`rating`)
) ENGINE=MyISAM AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;

-- Дамп данных таблицы dev_fabprint.data_catalog_items: 0 rows
/*!40000 ALTER TABLE `data_catalog_items` DISABLE KEYS */;
/*!40000 ALTER TABLE `data_catalog_items` ENABLE KEYS */;


-- Дамп структуры для таблица dev_fabprint.data_catalog_orders
CREATE TABLE IF NOT EXISTS `data_catalog_orders` (
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
) ENGINE=MyISAM AUTO_INCREMENT=50 DEFAULT CHARSET=utf8;

-- Дамп данных таблицы dev_fabprint.data_catalog_orders: 0 rows
/*!40000 ALTER TABLE `data_catalog_orders` DISABLE KEYS */;
/*!40000 ALTER TABLE `data_catalog_orders` ENABLE KEYS */;


-- Дамп структуры для таблица dev_fabprint.data_faq
CREATE TABLE IF NOT EXISTS `data_faq` (
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
) ENGINE=MyISAM AUTO_INCREMENT=86 DEFAULT CHARSET=cp1251 PACK_KEYS=0 COMMENT='Изображения для фотогалерей';

-- Дамп данных таблицы dev_fabprint.data_faq: 0 rows
/*!40000 ALTER TABLE `data_faq` DISABLE KEYS */;
/*!40000 ALTER TABLE `data_faq` ENABLE KEYS */;


-- Дамп структуры для таблица dev_fabprint.data_recall
CREATE TABLE IF NOT EXISTS `data_recall` (
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
) ENGINE=MyISAM AUTO_INCREMENT=9 DEFAULT CHARSET=cp1251 COMMENT='Отзывы';

-- Дамп данных таблицы dev_fabprint.data_recall: 0 rows
/*!40000 ALTER TABLE `data_recall` DISABLE KEYS */;
/*!40000 ALTER TABLE `data_recall` ENABLE KEYS */;


-- Дамп структуры для таблица dev_fabprint.data_redirects
CREATE TABLE IF NOT EXISTS `data_redirects` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `source_url` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `last_url` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `operator` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- Дамп данных таблицы dev_fabprint.data_redirects: ~1 rows (приблизительно)
/*!40000 ALTER TABLE `data_redirects` DISABLE KEYS */;
INSERT INTO `data_redirects` (`ID`, `source_url`, `last_url`, `updated_at`, `created_at`, `operator`) VALUES
	(1, 'http://yandex.ru', 'http://google.com', NULL, '2015-04-18 17:08:53', 'root');
/*!40000 ALTER TABLE `data_redirects` ENABLE KEYS */;


-- Дамп структуры для таблица dev_fabprint.data_seo
CREATE TABLE IF NOT EXISTS `data_seo` (
  `ID` int(6) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(128) NOT NULL DEFAULT '',
  `url` text NOT NULL,
  `keywords` varchar(255) NOT NULL DEFAULT '0',
  `description` text NOT NULL,
  `seo_title` varchar(255) NOT NULL,
  `seo_text` text,
  PRIMARY KEY (`ID`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Мета теги для плагина SEO';

-- Дамп данных таблицы dev_fabprint.data_seo: 0 rows
/*!40000 ALTER TABLE `data_seo` DISABLE KEYS */;
/*!40000 ALTER TABLE `data_seo` ENABLE KEYS */;


-- Дамп структуры для таблица dev_fabprint.data_subscribe
CREATE TABLE IF NOT EXISTS `data_subscribe` (
  `ID` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL DEFAULT '',
  `subject` varchar(255) NOT NULL DEFAULT '',
  `send` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `stat` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `text` text NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=MyISAM AUTO_INCREMENT=27 DEFAULT CHARSET=cp1251;

-- Дамп данных таблицы dev_fabprint.data_subscribe: 0 rows
/*!40000 ALTER TABLE `data_subscribe` DISABLE KEYS */;
/*!40000 ALTER TABLE `data_subscribe` ENABLE KEYS */;


-- Дамп структуры для таблица dev_fabprint.data_subscribe_groups
CREATE TABLE IF NOT EXISTS `data_subscribe_groups` (
  `ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- Дамп данных таблицы dev_fabprint.data_subscribe_groups: ~2 rows (приблизительно)
/*!40000 ALTER TABLE `data_subscribe_groups` DISABLE KEYS */;
INSERT INTO `data_subscribe_groups` (`ID`, `name`) VALUES
	(1, 'Основная'),
	(2, 'Тестовая');
/*!40000 ALTER TABLE `data_subscribe_groups` ENABLE KEYS */;


-- Дамп структуры для таблица dev_fabprint.data_subscribe_users
CREATE TABLE IF NOT EXISTS `data_subscribe_users` (
  `ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `group_id` int(10) unsigned NOT NULL DEFAULT '1',
  `cck` bigint(20) unsigned NOT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- Дамп данных таблицы dev_fabprint.data_subscribe_users: ~0 rows (приблизительно)
/*!40000 ALTER TABLE `data_subscribe_users` DISABLE KEYS */;
/*!40000 ALTER TABLE `data_subscribe_users` ENABLE KEYS */;


-- Дамп структуры для таблица dev_fabprint.data_users
CREATE TABLE IF NOT EXISTS `data_users` (
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
) ENGINE=MyISAM AUTO_INCREMENT=7 DEFAULT CHARSET=utf8 PACK_KEYS=0 COMMENT='Таблица с паролями';

-- Дамп данных таблицы dev_fabprint.data_users: 0 rows
/*!40000 ALTER TABLE `data_users` DISABLE KEYS */;
/*!40000 ALTER TABLE `data_users` ENABLE KEYS */;


-- Дамп структуры для таблица dev_fabprint.data_vfe_blocks_ru
CREATE TABLE IF NOT EXISTS `data_vfe_blocks_ru` (
  `ID` int(10) NOT NULL AUTO_INCREMENT,
  `alias` varchar(255) NOT NULL DEFAULT '',
  `text` text NOT NULL,
  `sysuser_id` int(6) unsigned NOT NULL,
  `updated_at` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`ID`),
  UNIQUE KEY `alias` (`alias`),
  FULLTEXT KEY `text` (`text`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Vfe';

-- Дамп данных таблицы dev_fabprint.data_vfe_blocks_ru: 0 rows
/*!40000 ALTER TABLE `data_vfe_blocks_ru` DISABLE KEYS */;
/*!40000 ALTER TABLE `data_vfe_blocks_ru` ENABLE KEYS */;


-- Дамп структуры для таблица dev_fabprint.data_video
CREATE TABLE IF NOT EXISTS `data_video` (
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
) ENGINE=MyISAM AUTO_INCREMENT=100 DEFAULT CHARSET=utf8;

-- Дамп данных таблицы dev_fabprint.data_video: 0 rows
/*!40000 ALTER TABLE `data_video` DISABLE KEYS */;
/*!40000 ALTER TABLE `data_video` ENABLE KEYS */;


-- Дамп структуры для таблица dev_fabprint.dtbl_banner_stat
CREATE TABLE IF NOT EXISTS `dtbl_banner_stat` (
  `ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `id_banner` int(10) unsigned NOT NULL DEFAULT '0',
  `tdate` date NOT NULL DEFAULT '0000-00-00',
  `view_count` int(10) unsigned NOT NULL DEFAULT '0',
  `click_count` int(10) unsigned NOT NULL DEFAULT '0',
  `view_pay` decimal(5,2) NOT NULL DEFAULT '0.00',
  `click_pay` decimal(5,2) NOT NULL DEFAULT '0.00',
  `ip_data_click` text NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=MyISAM AUTO_INCREMENT=2002 DEFAULT CHARSET=utf8 COMMENT='Статистика показов рекламы';

-- Дамп данных таблицы dev_fabprint.dtbl_banner_stat: 0 rows
/*!40000 ALTER TABLE `dtbl_banner_stat` DISABLE KEYS */;
/*!40000 ALTER TABLE `dtbl_banner_stat` ENABLE KEYS */;


-- Дамп структуры для таблица dev_fabprint.dtbl_catalog_items_images
CREATE TABLE IF NOT EXISTS `dtbl_catalog_items_images` (
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
) ENGINE=MyISAM AUTO_INCREMENT=15 DEFAULT CHARSET=utf8;

-- Дамп данных таблицы dev_fabprint.dtbl_catalog_items_images: 0 rows
/*!40000 ALTER TABLE `dtbl_catalog_items_images` DISABLE KEYS */;
/*!40000 ALTER TABLE `dtbl_catalog_items_images` ENABLE KEYS */;


-- Дамп структуры для таблица dev_fabprint.dtbl_search_results
CREATE TABLE IF NOT EXISTS `dtbl_search_results` (
  `idx` bigint(11) unsigned NOT NULL DEFAULT '0',
  `qsearch` varchar(255) NOT NULL DEFAULT '',
  `table` varchar(50) NOT NULL DEFAULT '',
  `controller` varchar(50) NOT NULL DEFAULT '',
  `tdate` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `primary_key` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`idx`,`qsearch`)
) ENGINE=MyISAM DEFAULT CHARSET=cp1251 COMMENT='Результаты поиска';

-- Дамп данных таблицы dev_fabprint.dtbl_search_results: 0 rows
/*!40000 ALTER TABLE `dtbl_search_results` DISABLE KEYS */;
/*!40000 ALTER TABLE `dtbl_search_results` ENABLE KEYS */;


-- Дамп структуры для таблица dev_fabprint.dtbl_subscribe_stat
CREATE TABLE IF NOT EXISTS `dtbl_subscribe_stat` (
  `ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `subscribe_id` int(11) NOT NULL DEFAULT '0',
  `user_id` int(11) NOT NULL DEFAULT '0',
  `send_at` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`ID`),
  UNIQUE KEY `id_data_subscribe` (`subscribe_id`,`user_id`)
) ENGINE=MyISAM AUTO_INCREMENT=12 DEFAULT CHARSET=cp1251;

-- Дамп данных таблицы dev_fabprint.dtbl_subscribe_stat: 0 rows
/*!40000 ALTER TABLE `dtbl_subscribe_stat` DISABLE KEYS */;
/*!40000 ALTER TABLE `dtbl_subscribe_stat` ENABLE KEYS */;


-- Дамп структуры для таблица dev_fabprint.images_gallery
CREATE TABLE IF NOT EXISTS `images_gallery` (
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

-- Дамп данных таблицы dev_fabprint.images_gallery: 0 rows
/*!40000 ALTER TABLE `images_gallery` DISABLE KEYS */;
/*!40000 ALTER TABLE `images_gallery` ENABLE KEYS */;


-- Дамп структуры для таблица dev_fabprint.keys_access
CREATE TABLE IF NOT EXISTS `keys_access` (
  `ID` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL DEFAULT '',
  `tbl` varchar(64) NOT NULL DEFAULT '',
  `lkey` varchar(64) NOT NULL DEFAULT '',
  `object` varchar(8) NOT NULL DEFAULT '',
  `settings` text NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `tbl` (`tbl`,`lkey`,`object`)
) ENGINE=MyISAM AUTO_INCREMENT=33 DEFAULT CHARSET=utf8 COMMENT='Ключи к модулю Access';

-- Дамп данных таблицы dev_fabprint.keys_access: 21 rows
/*!40000 ALTER TABLE `keys_access` DISABLE KEYS */;
INSERT INTO `keys_access` (`ID`, `name`, `tbl`, `lkey`, `object`, `settings`, `updated_at`) VALUES
	(1, 'Модуль', '', 'modul', 'lkey', 'type=tlist\r\nlist=sys_program\r\nrating=1\r\ngroup=2\r\ntable_list=1\r\nfilter=1\r\nqview=1\r\nhelp=Программный модуль, для которого действует данное право\r\n', '2010-10-31 19:34:50'),
	(3, 'Объект', '', 'objecttype', 'lkey', 'type=list\r\nlist=|не определен~modul|Модуль~table|Таблица~lkey|Ключ~button|Кнопка~menu|Пункт главного меню\r\nnotnull=1\r\nlist_type=radio\r\ngroup=1\r\nrating=9\r\nfilter=1\r\nrequired=1\r\ntable_list=2\r\nqview=1\r\nqedit=1\r\nhelp=Тип объекта, для которого действительно данное правило\r\n', '2010-10-31 19:34:46'),
	(4, 'Группа пользователей', '', 'id_group_user', 'lkey', 'type=tlist\nlist=lst_group_user\ntable_list=3\nrating=5\ngroup=3\nqview=1\nfilter=1\nhelp=Группа пользователей, для которых действительно данное правило', '2010-10-31 19:38:38'),
	(5, 'Управление доступом. Фильтр', '', 'filter', 'button', 'type_link=modullink\ntable_list=1\nprogram=/cgi-bin/access_a.cgi\nimageiconmenu=/admin/img/icons/menu/icon_filter.png\naction=filter\ntitle=Настроить фильтр\nwidth=690\nheight=510\nlevel=3\nrating=2\nparams=replaceme', '0000-00-00 00:00:00'),
	(6, 'Управление доступом. Очистка фильтра', '', 'filter_clear', 'button', 'type_link=loadcontent\ntable_list=1\nprogram=/cgi-bin/access_a.cgi\naction=filter_clear\nimageiconmenu=/admin/img/icons/menu/icon_nofilter.png\ntitle=Снять фильтры\nrating=3\nparams=replaceme', '0000-00-00 00:00:00'),
	(7, 'Названия объектов', '', 'objectname', 'lkey', 'type=list\r\nlist=objectname\r\ngroup=3\r\nrating=2\r\nmult=7\r\nnocheck=1\r\ntemplate_w=field_multselect\r\nnotnull=1\r\nhelp=Перечень объектов, на которые распространяется данное правило. Выделите объекты и переведите их в правое окошко.', '2010-10-31 19:38:38'),
	(9, 'Пользователь', '', 'users', 'lkey', 'type=tlist\nlist=sys_users\ngroup=3\ntable_list=4\nrating=10\nqview=1\nfilter=1\nhelp=Пользователь, для которого действительно правило.', '2010-10-31 19:38:38'),
	(10, 'Права на чтение', '', 'r', 'lkey', 'type=chb\nyes=да\nno=нет\ngroup=3\nrating=11\nqview=1\nhelp=Пользователь может видеть выбранные объекты', '2010-10-31 19:38:38'),
	(11, 'Права на запись', '', 'w', 'lkey', 'type=chb\nyes=да\nno=нет\ngroup=3\nrating=12\nqview=1\nhelp=У пользователя есть право редактировать выбранные объекты', '2010-10-31 19:38:38'),
	(12, 'Права на удаление', '', 'd', 'lkey', 'type=chb\nyes=да\nno=нет\ngroup=3\nrating=13\nqview=1\nhelp=Пользователь может удалить выбранные объекты', '2010-10-31 19:38:38'),
	(13, 'Название', '', 'name', 'lkey', 'type=s', '2008-04-11 01:17:14'),
	(14, 'Таблица объектов', '', 'config_table', 'lkey', 'type=s', '2008-04-19 10:54:59'),
	(15, 'Закончить редактирование', '', 'end_link', 'button', 'type_link=loadcontent\nedit_info=1\nprogram=/cgi-bin/access_a.cgi\naction=info\nimageiconmenu=/admin/img/icons/menu/icon_ok.png\ntitle=Закончить редактирование\nrating=1\nparams=replaceme,index\n', '0000-00-00 00:00:00'),
	(16, 'Список правил', '', 'list_link', 'button', 'type_link=loadcontent\nadd_info=1\nprogram=/cgi-bin/access_a.cgi\nimageiconmenu=/admin/img/icons/menu/button.list.png\naction=enter\ntitle=Список правил\nrating=1\nparams=replaceme', '0000-00-00 00:00:00'),
	(17, 'Редактировать запись', '', 'edit_link', 'button', 'type_link=loadcontent\r\nprint_info=1\r\nprogram=/cgi-bin/access_a.cgi\r\ncontroller=access\r\naction=edit\r\nimageiconmenu=/admin/img/icons/menu/icon_edit.png\r\ntitle=Редактировать запись\r\nrating=2\r\nparams=replaceme,index', '0000-00-00 00:00:00'),
	(18, 'Удалить запись', '', 'del_link', 'button', 'type_link=loadcontent\nprogram=/cgi-bin/access_a.cgi\naction=delete\nimageiconmenu=/admin/img/icons/menu/icon_delete.png\nconfirm=Действительно удалить запись?\ntitle=Удалить запись\nprint_info=1\nrating=1\nparams=replaceme,index', '0000-00-00 00:00:00'),
	(19, 'Добавить запись', '', 'add_link', 'button', 'type_link=openpage\nposition=center\nid=newentry\r\ntable_list=1\r\nprint_info=1\r\nprogram=/cgi-bin/access_a.cgi\r\nimageiconmenu=/admin/img/icons/menu/icon_add.png\r\ncontroller=access\r\naction=add\r\ntitle=Добавить запись\r\nrating=1\r\nparams=replaceme', '0000-00-00 00:00:00'),
	(24, 'Добавить правило доступа', '', 'access_add', 'menu', 'type_link=loadcontent\r\naction=add\r\nprogram=/cgi-bin/access_a.cgi\r\nrating=116\r\nparentid=access\r\nreplaceme=replaceme', '0000-00-00 00:00:00'),
	(30, 'Права доступа', '', 'access', 'menu', 'type_link=loadcontent\r\naction=enter\r\nprogram=/cgi-bin/access_a.cgi\r\nrating=16\r\nparentid=setting\r\nreplaceme=replaceme\r\nsubmenuwidth=200\r\n', '0000-00-00 00:00:00'),
	(31, 'Данные', '', 'data', 'lkey', 'type=code\r\nsys=1\r\n', '0000-00-00 00:00:00'),
	(32, 'Обновить права', '', 'update_access', 'button', 'type_link=loadcontent\ntable_list=1\nprint_info=1\nimageiconmenu=/admin/img/icons/menu/icon_change.png\ncontroller=access\naction=update_access\ntitle=Обновить права\nrating=4\nparams=replaceme', NULL);
/*!40000 ALTER TABLE `keys_access` ENABLE KEYS */;


-- Дамп структуры для таблица dev_fabprint.keys_banners
CREATE TABLE IF NOT EXISTS `keys_banners` (
  `ID` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL DEFAULT '',
  `tbl` varchar(64) NOT NULL DEFAULT '',
  `lkey` varchar(64) NOT NULL DEFAULT '',
  `object` varchar(8) NOT NULL DEFAULT '',
  `settings` text NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `tbl` (`tbl`,`lkey`,`object`)
) ENGINE=MyISAM AUTO_INCREMENT=64 DEFAULT CHARSET=utf8 COMMENT='Ключи к модулю Баннерокрутилка';

-- Дамп данных таблицы dev_fabprint.keys_banners: 53 rows
/*!40000 ALTER TABLE `keys_banners` DISABLE KEYS */;
INSERT INTO `keys_banners` (`ID`, `name`, `tbl`, `lkey`, `object`, `settings`, `updated_at`) VALUES
	(1, 'Добавить запись', '', 'add_link', 'button', 'type_link=openpage\nposition=center\nid=newentry\r\ntable_list=1\r\ncontroller=banners\r\nimageiconmenu=/admin/img/icons/menu/icon_add.png\r\naction=add\r\ntitle=Добавить\r\nrating=1\r\nparams=replaceme', '0000-00-00 00:00:00'),
	(3, 'Удалить запись', '', 'del_link', 'button', 'type_link=loadcontent\r\ncontroller=banners\r\naction=delete\r\nconfirm=Действительно удалить запись?\r\nimageiconmenu=/admin/img/icons/menu/icon_delete.png\r\ntitle=Удалить запись\r\nprint_info=1\r\nrating=1\r\nparams=replaceme,index', '0000-00-00 00:00:00'),
	(4, 'Редактировать запись', '', 'edit_link', 'button', 'type_link=loadcontent\r\nprint_info=1\r\ncontroller=banners\r\nimageiconmenu=/admin/img/icons/menu/icon_edit.png\r\naction=edit\r\ntitle=Редактировать запись\r\nrating=2\r\nparams=replaceme,index', '0000-00-00 00:00:00'),
	(5, 'Закончить редактирование', '', 'end_link', 'button', 'type_link=loadcontent\r\nedit_info=1\r\ncontroller=banners\r\nimageiconmenu=/admin/img/icons/menu/icon_ok.png\r\naction=info\r\ntitle=Закончить редактирование\r\nrating=10\r\nparams=replaceme,index', '0000-00-00 00:00:00'),
	(6, 'Фильтр', '', 'filter', 'button', 'type_link=modullink\r\ntable_list=1\r\ntable_list_view=1\r\ncontroller=banners\r\nimageiconmenu=/admin/img/icons/menu/icon_filter.png\r\naction=filter\r\ntitle=Фильтр\r\nwidth=690\r\nheight=510\r\nlevel=3\r\nrating=2\r\nparams=replaceme', '0000-00-00 00:00:00'),
	(7, 'Очистка фильтра', '', 'filter_clear', 'button', 'type_link=loadcontent\r\ntable_list=1\r\ntable_list_view=1\r\ncontroller=banners\r\nimageiconmenu=/admin/img/icons/menu/icon_nofilter.png\r\naction=filter_clear\r\ntitle=Снять фильтры\r\nrating=3\r\nparams=replaceme', '0000-00-00 00:00:00'),
	(10, 'Название баннера', '', 'name', 'lkey', 'type=s\nfilter=1\ntable_list=1\nrequired=1\nqview=1\nqedit=1\ngroup=1\nrating=1\nno_format=1\nhelp=Название баннера предназначено для облегчения его дальнейшей идентификации в системе. Чем четче будет название, тем легче будет найти баннер среди прочих', '2010-09-13 15:28:12'),
	(11, 'Публиковать рекламу', '', 'view', 'lkey', 'type=chb\nrating=110\ngroup=1\nfilter=1\ntable_list=11\ntable_list_name=-\ntable_list_width=48\nyes=Виден\nno=Скрыт\nqview=1\nhelp=Для того, чтобы баннер показывался, необходимо установить данный влажок.', '2010-09-13 15:28:12'),
	(12, 'Ширина', '', 'width', 'lkey', 'type=d\r\ngroup=2\r\nqview=1\r\nfilter=1\r\nrequired=1\r\ntable_list=4\r\ntable_list_name=W\r\ntable_list_width=32\r\nrating=15\r\nhelp=Ширина баннера. По умолчанию задается из размеров выбраного баннерого места\r\n', '2010-09-13 15:28:29'),
	(58, 'Цена за клик', '', 'per_click', 'lkey', 'type=d\r\nprint=1\r\nqview=1\r\nqedit=1\r\nrating=10\r\nfileview=1\r\ntable_list=4\r\ntable_list_width=100\r\n', '0000-00-00 00:00:00'),
	(13, 'Высота', '', 'height', 'lkey', 'type=d\r\ngroup=2\r\nrating=16\r\nrequired=1\r\ntable_list=5\r\ntable_list_name=H\r\ntable_list_width=32\r\nqview=1\r\nfilter=1\r\nhelp=Высота баннера. По умолчанию задается из размеров выбраного баннерого места\r\n', '2010-09-13 15:28:29'),
	(14, 'Код рекламного блока', '', 'code', 'lkey', 'type=code\ngroup=2\nrating=10\nhelp=Если у вас готовый код, то воспользуйтесь данным полем. Все остальные поля заполнять в этом случае не надо.', '2010-09-13 15:28:29'),
	(15, 'Бюджет', '', 'cash', 'lkey', 'type=float\r\ntable_list=6\r\ntable_list_width=72\r\ngroup=1\r\nqedit=1\r\nfilter=1\r\nrating=98\r\nhelp=Доступное количество денег для открутки показов. Снимается сумма, которая прописана в настройках рекламного места и, в зависимости от типа показов, (за клики, за показы). Если выбран тип показа "без ограничения", то данное поле можно не заполнять', '2010-09-13 15:28:12'),
	(16, 'Дата конца показов', '', 'showdateend', 'lkey', 'type=date\ngroup=3\nrating=8\nfilter=1\nhelp=Установите дату окончания показов, если показ баннера привязан к конкретному сроку (для коммерческих показов)', '2010-09-13 15:28:44'),
	(17, 'Дата начала показов', '', 'showdatefirst', 'lkey', 'type=date\ngroup=3\nrating=7\nfilter=1\nhelp=Установите дату начала показов, если показ баннера привязан к конкретному сроку (для коммерческих показов)', '2010-09-13 15:28:44'),
	(18, 'URL-ссылка', '', 'link', 'lkey', 'type=site\r\ngroup=1\r\nrating=2\r\nqview=1\r\nhelp=Адрес ссылки, куда ведет баннер.\r\ntable_list=5\r\ntable_list_width=200\r\n', '2010-09-13 15:28:12'),
	(20, 'Тип показа баннера', '', 'type_show', 'lkey', 'type=list\r\nlist=0|без ограничения~1|по показам~2|по переходам\r\nlist_type=radio\r\ngroup=1\r\nrating=99\r\nfilter=1\r\nqview=1\r\nhelp=Опция для коммерческого показа баннеров. В зависимости от выбранного типа расходуется (или не расходуется) рекламный бюджет', '2010-09-13 15:28:12'),
	(21, 'Рекламодатель', '', 'id_advert_users', 'lkey', 'type=tlist\r\nlist=data_banner_advert_users\r\nadd_to_list=1\r\nwin_scroll=0\r\nwin_height=100\r\nrating=100\r\ngroup=1\r\nfilter=1\r\nwidth=650\r\nheight=300\r\nhelp=Если баннерокрутилка используется для коммерческого показа баннеров, то указав рекламодателя, можно сделать ему доступ к статистике показов и переходов данного баннера.', '2010-09-13 15:28:12'),
	(22, 'Текст ссылки', '', 'textlink', 'lkey', 'type=text\ngroup=2\nrating=3\nhelp=Если требуется показывать рекламную ссылку, а не графический баннер, то воспользуйтесь этим полем', '2010-09-13 15:28:29'),
	(23, 'Размер файла', '', 'size', 'lkey', 'type=d\nshablon_w=field_input_read\nrating=20\ngroup=2\n', '2009-04-19 00:18:01'),
	(24, 'Тип файла', '', 'type_file', 'lkey', 'type=slat\ngroup=2\nrating=21\ntable_list=2\ntable_list_name=-\ntable_list_nosort=1\ntable_list_width=16\nshablon_w=field_input_read\n', '2009-04-19 00:18:01'),
	(25, 'Заголовок ссылки', '', 'titlelink', 'lkey', 'type=s\ngroup=2\nrating=2\nhelp=Текстовый баннер может состоять из заголовка и текста. Это поле предназначено для определения заголовка текстового рекламного блока', '2010-09-13 15:28:29'),
	(26, 'Картинка', '', 'docfile', 'lkey', 'type=pict\r\nrating=1\r\ngroup=2\r\ntable_list=3\r\ntable_list_name=-\r\ntable_list_type=pict\r\ntable_list_nosort=1\r\ntemplate_w=field_file\r\ntemplate_r=field_pict_read\r\nfolder=/image/bb/\r\nsizelimit=20000\r\nfile_ext=*.jpg;*.jpeg;*.gif;*.swf;*.png\r\nhelp=Баннер может быть загружен на сервер.', '2010-09-13 15:24:47'),
	(27, 'Постраничный таргетинг', '', 'target', 'lkey', 'type=list\r\nlist=0|на всех страницах~1|только на страницах~2|исключая страницы\r\nlist_type=radio\r\nlist_sort=asc_d\r\ngroup=3\r\nrating=10\r\nhelp=Баннер может показываться на определенных страницах. Для этого выберите режим <b>Только на страницах</b> и в поле <b>Список страниц</b> укажите эти страницы. В режиме <b>Исключая страницы</b> баннер будет показан на всех страницах, за исключением тех, которые указаны в списке.', '2010-09-13 15:28:44'),
	(29, 'Дни недели', '', 'week', 'lkey', 'type=list\r\nlist=-1|Все дни~1|Понедельник~2|Вторник~3|Среда~4|Четверг~5|Пятница~6|Суббота~7|Воскресенье\r\nlist_type=checkbox\r\nlist_sort=asc_d\r\nnotnull=1\r\ngroup=3\r\nrating=4\r\nhelp=Для коммерческого показа рекламы можно использовать таргетинг по дням. Если таргетинг по дням не используется, то установите флажок в положение "Все дни", в противном случае баннер показываться не будет', '2010-09-13 15:28:44'),
	(32, 'Время показов', '', 'time', 'lkey', 'type=list\r\nlist=-1|Все время&nbsp;&nbsp;&nbsp;~1|00:00-01:00~2|01:00-02:00~3|02:00-03:00~4|03:00-04:00~5|04:00-05:00~6|05:00-06:00~7|06:00-07:00~8|07:00-08:00~9|08:00-09:00~10|09:00-10:00~11|10:00-11:00~12|11:00-12:00~13|12:00-13:00~14|13:00-14:00~15|14:00-15:00~16|15:00-16:00~17|16:00-17:00~18|17:00-18:00~19|18:00-19:00~20|19:00-20:00~21|20:00-21:00~22|21:00-22:00~23|22:00-23:00~24|23:00-24:00\r\nlist_type=checkbox\r\nlist_sort=asc_d\r\nnotnull=1\r\ngroup=3\r\nrating=5\r\nhelp=Для коммерческого показа рекламы можно использовать таргетинг по времени. Если таргетинг по времени не используется, то установите флажок в положение "Все время", в противном случае баннер показываться не будет', '2010-09-13 15:28:44'),
	(33, 'Место', '', 'id_advert_block', 'lkey', 'type=tlist\r\nlist=data_banner_advert_block\r\ngroup=1\r\nrating=6\r\nfilter=1\r\nrequired=1\r\ntable_list=5\r\nqview=1\r\nshablon_w=field_multselect\r\nnotnull=1\r\nhelp=Баннер можно привязать к нескольким местам, которые прописаны в системе и в шаблонах. Желательно соблюдать размерность баннера и места, на которое он размещается, чтобы не портить верстку макета страницы\r\n', '2010-09-13 15:28:44'),
	(36, 'Статистика', '', 'stat', 'lkey', 'type=table\r\ntable=dtbl_banner_stat\r\ngroup=4\r\nrating=15\r\ntemplate_w=field_table\r\ntable_fields=tdate,view_count,view_pay,click_count,click_pay\r\ntable_svf=id_banner\r\ntable_sortfield=tdate\r\ntable_buttons_key_w=delete\r\ntable_groupname=Общая информация\r\ntable_noindex=1\r\nhelp=Статистика показов и переходов за период. При клике по названию поля в таблице происходит сортировка по данному полю. Повторный клик приводит к обратной сортировке ', '2009-04-19 00:18:01'),
	(37, 'Списано за клики', '', 'click_pay', 'lkey', 'type=d\nfloor=1\nrating=31\ngroup=1', '2008-08-13 15:48:49'),
	(38, 'Кол-во переходов', '', 'click_count', 'lkey', 'type=d\ngroup=1\nrating=2', '2008-08-13 15:48:49'),
	(39, 'Списано за показы', '', 'view_pay', 'lkey', 'type=d\nfloor=1\nrating=30\ngroup=1', '2008-08-13 15:48:49'),
	(40, 'Кол-во просмотров', '', 'view_count', 'lkey', 'type=d\ngroup=1\nrating=1', '2008-08-13 15:48:49'),
	(41, 'Дата', '', 'tdate', 'lkey', 'type=date\nrating=7\ngroup=1\nshablon_w=field_input_read', '0000-00-00 00:00:00'),
	(42, 'Файл', '', 'filename', 'lkey', 'type=filename\nrating=2\nsizelimit=20000\nfile_ext=*.*', '2010-09-13 15:24:08'),
	(43, 'Флаг удаления картинки', '', 'deletepict', 'lkey', 'type=chb\nsys=1', '2008-10-26 13:53:51'),
	(44, 'Список страниц', '', 'list_page', 'lkey', 'type=tlist\r\nlist=texts_main_ru\r\nsort=1\r\nrating=22\r\ngroup=3\r\nmult=5\r\nrequest_url=/admin/banners/body\r\nnotdef=1\r\ntemplate_w=field_multselect_input\r\nhelp=Данное поле работает в паре с полем <b>Постраничный таргетинг</b>. Для выбора страниц нажмите на ссылку <b>Расширенный поиск</b>, расположенную слева. Появятся несколько дополнительных полей. В поле <b>поиск</b> введите подстроку, содержащуюся в названии страницы. В поле <b>доступные значения</b> появятся документы, которые содержат данную подстроку. При помощи кнопок со стрелками, расположенными справа, перенесите нужные страницы во второе поле <b>Выбранные значения</b>. Из последнего поля можно удалить документы, воспользовавшись соответствующими кнопками справа.\r\n', '2010-09-13 15:28:44'),
	(45, 'Флаг показать', '', 'show', 'lkey', 'type=s\nsys=1', '2009-04-29 17:55:04'),
	(46, 'Флаг скрыть', '', 'hide', 'lkey', 'type=s\nsys=1', '0000-00-00 00:00:00'),
	(47, 'ключ', '', 'texts_main_ru', 'lkey', 'type=tlist\nlist=texts_main_ru', '0000-00-00 00:00:00'),
	(48, 'Баннер', '', 'id_banner', 'lkey', 'type=tlist\nlist=data_banner\nsort=1\nsys=1', '2009-04-17 12:43:22'),
	(50, 'Список', '', 'list_link', 'button', 'type_link=loadcontent\r\nadd_info=1\r\ncontroller=banners\r\nimageiconmenu=/admin/img/icons/menu/button.list.png\r\naction=enter\r\ntitle=Список\r\nrating=1\r\nparams=replaceme', '0000-00-00 00:00:00'),
	(51, 'Рейтинг', '', 'rating', 'lkey', 'type=d\r\ngroup=1\r\nfilter=1\r\nrating=15\r\ntable_list=9\r\ntable_list_name=Rt\r\ntable_list_width=32\r\nqedit=1\r\nqview=1\r\nshablon_w=field_rating\r\nhelp=При прочих равных условиях, чем меньше рейтинг, тем чаще будет показываться баннер. Используется, если на одно место прописано несколько баннеров', '2010-09-13 15:28:12'),
	(52, 'Индекс', '', 'index', 'lkey', 'type=d\r\nsys=1', '2010-10-27 16:37:28'),
	(53, 'IP адреса', '', 'ip_data_click', 'lkey', 'type=code\r\nprint=1\r\nqview=1\r\nrating=99\r\ngroup=1\r\n', '0000-00-00 00:00:00'),
	(54, 'Имя рекламодателя', 'lst_advert_users', 'name', 'lkey', 'type=s\r\nfilter=1\r\ntable_list=1\r\nrequired=1\r\nqview=1\r\nqedit=1\r\ngroup=1\r\nrating=1\r\nno_format=1\r\n', '0000-00-00 00:00:00'),
	(55, 'E-mail', '', 'email', 'lkey', 'type=email\r\nprint=1\r\nqview=1\r\nqedit=1\r\nrating=5\r\ntable_list=4\r\ntable_list_width=100\r\n', '0000-00-00 00:00:00'),
	(56, 'Телефон', '', 'phone', 'lkey', 'type=s\r\nprint=1\r\nqview=1\r\nqedit=1\r\nrating=5\r\ntable_list=3\r\ntable_list_width=100\r\n', '0000-00-00 00:00:00'),
	(57, 'Открывать в новом окне', '', 'targetblank', 'lkey', 'type=chb\r\nprint=1\r\nqview=1\r\nqedit=1\r\nrating=1\r\nfilter=1\r\nqview=1\r\nrating=3\r\ngroup=1\r\nyes=Да\r\nno=Нет\r\nhelp=Если указана URL-ссылка, то она будет открываться в новом окне', '0000-00-00 00:00:00'),
	(59, 'Цена за показ', '', 'per_show', 'lkey', 'type=d\r\nprint=1\r\nqview=1\r\nqedit=1\r\nrating=11\r\nfileview=1\r\ntable_list=5\r\ntable_list_width=100\r\n', '0000-00-00 00:00:00'),
	(60, 'Языковые версии', '', 'langs', 'lkey', 'type=list\nlist_out=lang\n#list=ru|Русский~en|English\nnotnull=1\nlist_type=checkbox\nrating=101\nfilter=1\ntable_list=10\ntable_list_width=100\nfileview=1\nqedit=1\nqview=1\n', '0000-00-00 00:00:00'),
	(61, 'Копировать запись', '', 'copy', 'button', 'type_link=loadcontent\nprint_info=1\nedit_info=1\nloading_msg=1\ncontroller=banners\naction=copy\nimageiconmenu=/admin/img/icons/menu/icon_copy.png\ntitle=Копировать запись\nrating=5\nparams=replaceme,index,list_table', '0000-00-00 00:00:00'),
	(62, 'Таргетинг по URL', '', 'target_url', 'lkey', 'type=list\nlist=0|на всех страницах~1|только на страницах~2|исключая страницы\nlist_type=radio\nlist_sort=asc_d\ngroup=3\nrating=25\nhelp=Баннер может показываться на определенных URL', '0000-00-00 00:00:00'),
	(63, 'URL страниц', '', 'urls', 'lkey', 'type=tlist\nlist=lst_banner_urls\ntemplate_w=field_multselect_input\ngroup=3\nmult=5\nadd_to_list=1\nrating=26\n', '2014-08-25 13:33:28');
/*!40000 ALTER TABLE `keys_banners` ENABLE KEYS */;


-- Дамп структуры для таблица dev_fabprint.keys_catalog
CREATE TABLE IF NOT EXISTS `keys_catalog` (
  `ID` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL DEFAULT '',
  `tbl` varchar(64) NOT NULL DEFAULT '',
  `lkey` varchar(64) NOT NULL DEFAULT '',
  `object` varchar(8) NOT NULL DEFAULT '',
  `settings` text NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `tbl` (`tbl`,`lkey`,`object`)
) ENGINE=MyISAM AUTO_INCREMENT=63 DEFAULT CHARSET=utf8 COMMENT='Ключи к модулю Тексты';

-- Дамп данных таблицы dev_fabprint.keys_catalog: 59 rows
/*!40000 ALTER TABLE `keys_catalog` DISABLE KEYS */;
INSERT INTO `keys_catalog` (`ID`, `name`, `tbl`, `lkey`, `object`, `settings`, `updated_at`) VALUES
	(1, 'Добавить запись', '', 'add_link', 'button', 'type_link=openpage\nposition=center\nid=newentry\r\ntable_list=1\r\nprint_info=1\nedit_info=1\r\ncontroller=catalog\r\naction=add\r\nimageiconmenu=/admin/img/icons/menu/icon_add.png\r\ntitle=Добавить\r\nrating=1\r\nparams=replaceme,list_table', '0000-00-00 00:00:00'),
	(2, 'Удалить запись', '', 'del_link', 'button', 'type_link=loadcontent\r\ncontroller=catalog\r\naction=delete\r\nconfirm=Действительно удалить запись?\r\ntitle=Удалить запись\r\nimageiconmenu=/admin/img/icons/menu/icon_delete.png\r\nprint_info=1\r\nrating=1\r\nparams=replaceme,index,list_table', '0000-00-00 00:00:00'),
	(3, 'Редактировать запись', '', 'edit_link', 'button', 'type_link=loadcontent\r\nprint_info=1\r\ncontroller=catalog\r\naction=edit\r\nimageiconmenu=/admin/img/icons/menu/icon_edit.png\r\ntitle=Редактировать запись\r\nrating=2\r\nparams=replaceme,index,list_table', '0000-00-00 00:00:00'),
	(4, 'Закончить редактирование', '', 'end_link', 'button', 'type_link=loadcontent\r\nedit_info=1\r\ncontroller=catalog\r\naction=info\r\nimageiconmenu=/admin/img/icons/menu/icon_ok.png\r\ntitle=Закончить редактирование\r\nrating=10\r\nparams=replaceme,index,list_table\r\n', '0000-00-00 00:00:00'),
	(5, 'Фильтр', '', 'filter', 'button', 'type_link=modullink\r\ntable_list=1\r\ntable_list_orders=1\r\ncontroller=catalog\r\naction=filter\r\nimageiconmenu=/admin/img/icons/menu/icon_filter.png\r\ntitle=Фильтр\r\nwidth=690\r\nheight=510\r\nlevel=3\r\nrating=2\r\nparams=replaceme,list_table', '0000-00-00 00:00:00'),
	(6, 'Очистка фильтра', '', 'filter_clear', 'button', 'type_link=loadcontent\r\ntable_list=1\r\ntable_list_orders=1\r\ntable_list_dir=1\r\ncontroller=catalog\r\naction=filter_clear\r\nimageiconmenu=/admin/img/icons/menu/icon_nofilter.png\r\ntitle=Снять фильтры\r\nrating=3\r\nparams=replaceme,list_table', '0000-00-00 00:00:00'),
	(7, 'Название', '', 'name', 'lkey', 'type=s\r\nfilter=1\r\ngroup=1\r\nrating=1\r\nrequired=1\r\nqedit=1\r\ntable_list=1\r\nno_format=1\r\nfileview=1\r\n', '2010-10-31 11:29:29'),
	(8, 'Текст - правый блок', '', 'text', 'lkey', 'type=html\r\nprint=1\r\ngroup=2\r\nrating=201\r\n', '0000-00-00 00:00:00'),
	(9, 'Рейтинг', '', 'rating', 'lkey', 'type=d\r\ngroup=1\r\nqview=1\r\nqedit=1\r\ntable_list=10\r\ntable_list_name=Rt\r\ntable_list_width=32\r\nrating=99\r\ntemplate_w=field_rating\r\n', '0000-00-00 00:00:00'),
	(10, 'Фото', '', 'images', 'lkey', 'type=table\r\ntable=dtbl_catalog_items_images\r\ngroup=3\r\nrating=15\r\ntemplate_w=field_table\r\ntable_fields=name,pict,rating\r\ntable_svf=id_item\r\ntable_sortfield=rating\r\ntable_buttons_key_w=delete,edit\r\ntable_groupname=Общая информация\r\ntable_noindex=1\r\ntable_add=1\r\n', '0000-00-00 00:00:00'),
	(11, 'Картинка', '', 'pict', 'lkey', 'type=pict\r\nrating=14\r\ntemplate_w=field_pict\r\ntemplate_r=field_pict_read\r\nsizelimit=20000\r\next=*.jpg;*.jpeg;*.gif;\r\nmini=188x180~crop,250x333~montage,550x733~montage,102x136~crop\nfolder=/image/catalog/items/\r\nfileview=1\r\ntable_list=4\r\ntable_list_type=pict\r\ntable_list_name=-\r\n', '0000-00-00 00:00:00'),
	(12, 'Картинка', 'dtbl_catalog_items_images', 'pict', 'lkey', 'type=pict\r\nrating=14\r\nsizelimit=20000\r\next=*.jpg;*.jpeg;*.gif;\r\nmini=102x136~crop,550x733~montage\r\nfolder=/image/catalog/items/dopimgs/\r\nfileview=1\r\ntable_list=4\r\ntable_list_type=pict\r\ntable_list_name=-\n\n\r\n', '0000-00-00 00:00:00'),
	(13, 'Товар', '', 'id_item', 'lkey', 'type=tlist\r\nlist=data_catalog_items\r\nsys=1\r\n', '0000-00-00 00:00:00'),
	(14, 'Рекомендуемые товары', '', 'recommend', 'lkey', 'type=tlist\r\nlist=data_catalog_items\r\ntemplate_w=field_multselect_input\r\nselect_help=1\r\nrating=80\r\ngroup=1\r\nfileview=1\r\n\r\n', '0000-00-00 00:00:00'),
	(15, 'Алиас', '', 'alias', 'lkey', 'type=s\r\nrating=2\r\ntable_list=2\r\ngroup=1\r\nfilter=1\r\nqview=1\r\nqedit=1\r\nrequired=1\r\nhelp=Короткое латинское название, которое учавствует в формирование URL для данной страницы', '0000-00-00 00:00:00'),
	(16, 'Публиковать на сайте', '', 'active', 'lkey', 'type=chb\nprint=1\nqview=1\nqedit=1\nfilter=1\ntable_list=10\ntable_list_name=-\ntable_list_width=48\nyes=Виден\nno=Скрыт\nrating=99\n', '0000-00-00 00:00:00'),
	(47, 'Родительская категория', 'data_catalog_categorys', 'parent_category_id', 'lkey', 'type=tlist\nlist=data_catalog_categories\nprint=1\nqview=1\nqedit=1\nfilter=1\ntable_list=4\ntable_list_width=200\nrating=10\nwhere= AND parent_category_id=0\n\n\n', '0000-00-00 00:00:00'),
	(18, 'Картинка', 'data_catalog_categorys', 'pict', 'lkey', 'type=pict\r\nrating=14\r\ntemplate_w=field_pict\r\ntemplate_r=field_pict_read\r\nsizelimit=20000\r\next=*.jpg;*.jpeg;*.gif;\r\nmini=317x103~crop\nfolder=/image/catalog/categories/\r\nfileview=1\r\ntable_list=4\r\ntable_list_type=pict\r\ntable_list_name=-\r\n', '0000-00-00 00:00:00'),
	(19, 'Категория', '', 'category_id', 'lkey', 'type=tlist\nlist=data_catalog_categories\nprint=1\nqview=1\nqedit=1\nfilter=1\ntable_list=4\ntable_list_width=200\nrating=9\n\n', '0000-00-00 00:00:00'),
	(20, 'Цена', '', 'price', 'lkey', 'type=float\nprint=1\nqview=1\nqedit=1\nrating=10\ntable_list=7\ntable_list_widht=100\nrating=15\nrequired=1\n\n\n', '0000-00-00 00:00:00'),
	(21, 'Артикул', '', 'articul', 'lkey', 'type=s\nprint=1\nrating=12\nfileview=1\ntable_list=7\ntable_list_width=100\nqedit=1\nqview=1\nprint=1\n', '0000-00-00 00:00:00'),
	(52, 'Картинка', 'data_catalog_brands', 'pict', 'lkey', 'type=pict\r\nrating=14\r\nsizelimit=20000\r\next=*.jpg;*.jpeg;*.gif;\r\nmini=122x122~montage,269x269~montage\r\nfolder=/image/catalog/brands/\r\nfileview=1\r\ntable_list=4\r\ntable_list_type=pict\r\ntable_list_name=-\n\n\r\n', '0000-00-00 00:00:00'),
	(23, 'Ключевые слова', '', 'keywords', 'lkey', 'type=s\nrating=3\ngroup=1\nfilter=1\nqedit=1\nhelp=Ключевые слова и выражения, разделенные запятой, которые соответствуют данному тексту. Используется для оптимизации страницы под поисковые системы. Указанные слова в данном поле должны обязательно присутствовать в тексте — в противном случае они не будут учитываться поисковыми машинами.\ndirview=1\nfileview=1', '2010-10-29 12:23:39'),
	(24, 'Краткое описание страницы', '', 'description', 'lkey', 'type=text\r\nrating=3\r\ngroup=1\r\nqview=1\r\nhelp=Краткое описание текста. Используется для поисковых систем. Выводится на странице в meta-теге description. Как правило, пользователь данный текст не видет. Для поисковых систем полезнее для каждой страницы формировать свое описание, наиболее соответствующее данной странице.\r\ndirview=1\r\nfileview=1', '2010-10-29 12:23:39'),
	(25, 'Заголовок окна', '', 'title', 'lkey', 'type=s\nno_format=1\nrating=2\ngroup=1\nqview=1\nqedit=1\nhelp=Заголовок окна браузера. Может отличаться от названия текста. Используется для оптимизации под поисковые системы.\ndirview=1\nfileview=1', '2010-10-29 12:23:39'),
	(26, 'Копировать запись', '', 'copy', 'button', 'type_link=loadcontent\nprint_info=1\nedit_info=1\nloading_msg=1\ncontroller=catalog\naction=copy\nimageiconmenu=/admin/img/icons/menu/icon_copy.png\ntitle=Копировать запись\nrating=5\nparams=replaceme,index,list_table\n', '0000-00-00 00:00:00'),
	(27, 'Комментарий', '', 'comment', 'lkey', 'type=text\nprint=1\nqview=1\nrating=90\nfileview=1\n', '0000-00-00 00:00:00'),
	(28, 'Комментарий оператора', '', 'operator_comment', 'lkey', 'type=text\nprint=1\nqview=1\nrating=95\nfileview=1\n', '0000-00-00 00:00:00'),
	(29, 'Название', 'dtbl_catalog_items_images', 'name', 'lkey', 'type=s\r\nfilter=1\r\ngroup=1\r\nrating=1\r\nqedit=1\r\ntable_list=1\r\nno_format=1\r\nfileview=1\r\n', '2010-10-31 11:29:29'),
	(30, 'Текст - нижний блок', '', 'text_bottom', 'lkey', 'type=html\r\nprint=1\r\ngroup=2\r\nrating=202\n\r\n', '0000-00-00 00:00:00'),
	(31, 'Товары', '', 'order', 'lkey', 'type=table\r\ntable=dtbl_orders\r\ngroup=2\r\nrating=201\r\ntable_fields=pict,id_item,articul,name,price,totalprice,count,size,footsize\r\ntable_svf=id_order\r\ntable_sortfield=name\r\ntable_buttons_key_w=delete_select,edit\r\ntable_buttons_key_r=\r\ntable_groupname=Информация по файлу\r\ntable_icontype=1\r\ntable_noindex=1\r\nshablon_w=field_table\r\nshablon_r=field_table', '2011-10-27 09:47:47'),
	(62, 'ФИО', 'data_catalog_orders', 'name', 'lkey', 'type=s\r\nfilter=1\r\ngroup=1\r\nrating=1\r\nrequired=1\r\nqedit=1\r\ntable_list=1\r\nno_format=1\r\nfileview=1\r\n', '2010-10-31 11:29:29'),
	(33, 'Цвет', '', 'color', 'lkey', 'type=tlist\r\nlist=lst_catalog_colors\r\ntemplate_w=field_list_read\r\nrating=82\r\ngroup=1\r\nfileview=1\r\n', '0000-00-00 00:00:00'),
	(34, 'Кол-во', '', 'count', 'lkey', 'type=d\nprint=1\nqview=1\nqedit=1\nrating=4\nfileview=1\n', '0000-00-00 00:00:00'),
	(35, 'Сумма', '', 'totalprice', 'lkey', 'type=float\nprint=1\nqview=1\nqedit=1\nrating=11\ntable_list=8\ntable_list_widht=100\nrating=15\nrequired=1\n\n\n', '0000-00-00 00:00:00'),
	(36, 'Город', '', 'city', 'lkey', 'type=s\nprint=1\nqview=1\nqedit=1\ntable_list=5\ntable_list_widht=200\nrating=31\n\n\n\n', '0000-00-00 00:00:00'),
	(37, 'Телефон', '', 'phone', 'lkey', 'type=s\nprint=1\nqview=1\nqedit=1\ntable_list=5\ntable_list_widht=200\nrating=11\n\n\n\n', '0000-00-00 00:00:00'),
	(38, 'E-mail', '', 'email', 'lkey', 'type=s\nprint=1\nqview=1\nqedit=1\ntable_list=6\ntable_list_widht=200\nrating=12\n\n\n\n', '0000-00-00 00:00:00'),
	(39, 'Статус заказа', '', 'orderstatus', 'lkey', 'type=list\nlist=0|Новый~1|Проверен~2|Выполнен~3|Закрыт\nlist_type=radio\ntable_list=7\ntable_list_width=100\nfilter=1\nqedit=1\nqview=1\nprint=1\n', '0000-00-00 00:00:00'),
	(40, 'Новинка', '', 'is_new', 'lkey', 'type=chb\nprint=1\nqview=1\nfilter=1\nrating=90\ntable_list=7\ntable_list_width=70\nyes=да\nno=нет\nqedit=1\n', '0000-00-00 00:00:00'),
	(41, 'Распродажа', '', 'is_sale', 'lkey', 'type=chb\nprint=1\nqview=1\nfilter=1\nrating=91\ntable_list=8\ntable_list_width=70\nyes=да\nno=нет\nqedit=1\n', '0000-00-00 00:00:00'),
	(42, 'Бренд', '', 'brand_id', 'lkey', 'type=tlist\nlist=data_catalog_brands\nprint=1\nqview=1\nqedit=1\nfilter=1\ntable_list=5\ntable_list_width=200\nrating=11\n\n', '0000-00-00 00:00:00'),
	(43, 'Размеры товара', '', 'sizes', 'lkey', 'type=s\nprint=1\nqview=1\nqedit=1\ntable_list=6\ntable_list_width=150\nrating=50\nfileview=1\n', '0000-00-00 00:00:00'),
	(44, 'Подкатегория', '', 'parent_category_id', 'lkey', 'type=tlist\nlist=data_catalog_categories\nprint=1\nqview=1\nqedit=1\nfilter=1\ntable_list=4\ntable_list_width=200\nrating=10\n#where= AND parent_category_id>0\n\n\n', '0000-00-00 00:00:00'),
	(45, 'Цвет', '', 'color_id', 'lkey', 'type=tlist\nlist=lst_catalog_colors\nprint=1\nfilter=1\ntable_list=7\ntable_list_width=100\nqview=1\nqedit=1\nrating=45\nfileview=1\nadd_to_list=1\n', '0000-00-00 00:00:00'),
	(46, 'Пол', '', 'gender', 'lkey', 'type=list\nlist=1|Мужское~2|Женское~3|Детское\nnotnull=1\nrating=10\nfileview=1\nqview=1\nqedit=1\nrating=40\nfilter=1\ntable_list=9\ntable_list_width=70\nlist_type=radio\nrequired=1\n', '0000-00-00 00:00:00'),
	(48, 'Категория', 'data_catalog_items', 'category_id', 'lkey', 'type=tlist\nlist=data_catalog_categories\nprint=1\nqview=1\nqedit=1\nfilter=1\ntable_list=4\ntable_list_width=200\nrating=9\nwhere= AND parent_category_id=0\nrules=parent_category_id:data_catalog_categories.parent_category_id=index\nrequired=1\n', '0000-00-00 00:00:00'),
	(49, 'Подкатегория', 'data_catalog_items', 'parent_category_id', 'lkey', 'type=tlist\nlist=data_catalog_categories\nprint=1\nqview=1\nqedit=1\nfilter=1\ntable_list=4\ntable_list_width=200\nrating=10\nwhere= AND parent_category_id>0\nrequired=1\n\n\n', '0000-00-00 00:00:00'),
	(50, 'Состав', '', 'sostav', 'lkey', 'type=s\nprint=1\nqview=1\nqedit=1\nrating=55\nfileview=1\n', '0000-00-00 00:00:00'),
	(51, 'Подкатегория', '', 'subcategory_id', 'lkey', 'type=tlist\nlist=data_catalog_categories\nprint=1\nqview=1\nqedit=1\nfilter=1\ntable_list=4\ntable_list_width=200\nrating=10\nwhere= AND parent_category_id>0\nrequired=1\n\n\n', '0000-00-00 00:00:00'),
	(53, 'Лого', '', 'pict_logo', 'lkey', 'type=pict\r\nrating=20\r\nsizelimit=20000\r\next=*.png;\nfolder=/image/catalog/brands/logo/\r\nfileview=1\r\ntable_list=6\r\ntable_list_type=pict\r\ntable_list_name=Лого\norigin=1\n\n\r\n', '0000-00-00 00:00:00'),
	(54, 'Лого ЧБ', '', 'pict_logo_hover', 'lkey', 'type=pict\r\nrating=21\r\nsizelimit=20000\r\next=*.png;\r\nfolder=/image/catalog/brands/logo/\r\nfileview=1\r\ntable_list=7\r\ntable_list_type=pict\r\ntable_list_name=Лого ЧБ\norigin=1\n\n\r\n', '0000-00-00 00:00:00'),
	(55, 'Индекс', '', 'addressindex', 'lkey', 'type=s\nprint=1\nqview=1\nqedit=1\nrating=30', '0000-00-00 00:00:00'),
	(56, 'Улица', '', 'street', 'lkey', 'type=s\nprint=1\nqview=1\nqedit=1\nrating=32', '0000-00-00 00:00:00'),
	(57, 'Дом', '', 'house', 'lkey', 'type=s\nprint=1\nqview=1\nqedit=1\nrating=33', '0000-00-00 00:00:00'),
	(58, 'Корпус', '', 'korpus', 'lkey', 'type=s\nprint=1\nqview=1\nqedit=1\nrating=34', '0000-00-00 00:00:00'),
	(59, 'Квартира', '', 'apartment', 'lkey', 'type=s\nprint=1\nqview=1\nqedit=1\nrating=35', '0000-00-00 00:00:00'),
	(60, 'Комментарий', '', 'ordercomment', 'lkey', 'type=text\nprint=1\nrating=50\nfileview=1\nqview=1\n', '0000-00-00 00:00:00'),
	(61, 'Комментарий оператора', '', 'operatorcomment', 'lkey', 'type=text\nprint=1\nrating=51\nfileview=1\nqview=1\n', '0000-00-00 00:00:00');
/*!40000 ALTER TABLE `keys_catalog` ENABLE KEYS */;


-- Дамп структуры для таблица dev_fabprint.keys_faq
CREATE TABLE IF NOT EXISTS `keys_faq` (
  `ID` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL DEFAULT '',
  `tbl` varchar(64) NOT NULL DEFAULT '',
  `lkey` varchar(64) NOT NULL DEFAULT '',
  `object` varchar(8) NOT NULL DEFAULT '',
  `settings` text NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `tbl` (`tbl`,`lkey`,`object`)
) ENGINE=MyISAM AUTO_INCREMENT=82 DEFAULT CHARSET=cp1251 COMMENT='Ключи к модулю Тексты';

-- Дамп данных таблицы dev_fabprint.keys_faq: 27 rows
/*!40000 ALTER TABLE `keys_faq` DISABLE KEYS */;
INSERT INTO `keys_faq` (`ID`, `name`, `tbl`, `lkey`, `object`, `settings`, `updated_at`) VALUES
	(62, 'Добавить запись', '', 'add_link', 'button', 'type_link=openpage\nposition=center\nid=newentry\r\ntable_list=1\r\nprint_info=1\r\ncontroller=faq\r\naction=add\r\nimageiconmenu=/admin/img/icons/menu/icon_add.png\r\ntitle=Добавить\r\nrating=1\r\nparams=replaceme', '0000-00-00 00:00:00'),
	(61, 'Удалить запись', '', 'del_link', 'button', 'type_link=loadcontent\r\ncontroller=faq\r\naction=delete\r\nimageiconmenu=/admin/img/icons/menu/icon_delete.png\r\nconfirm=Действительно удалить запись?\r\ntitle=Удалить запись\r\nprint_info=1\r\nrating=1\r\nparams=replaceme,index', '0000-00-00 00:00:00'),
	(60, 'Редактировать запись', '', 'edit_link', 'button', 'type_link=loadcontent\r\nprint_info=1\r\ncontroller=faq\r\naction=edit\r\nimageiconmenu=/admin/img/icons/menu/icon_edit.png\r\ntitle=Редактировать запись\r\nrating=2\r\nparams=replaceme,index', '0000-00-00 00:00:00'),
	(59, 'Закончить редактирование', '', 'end_link', 'button', 'type_link=loadcontent\r\nedit_info=1\r\ncontroller=faq\r\naction=info\r\nimageiconmenu=/admin/img/icons/menu/icon_ok.png\r\ntitle=Закончить редактирование\r\nrating=10\r\nparams=replaceme,index\r\n', '0000-00-00 00:00:00'),
	(58, 'Фильтр', '', 'filter', 'button', 'type_link=modullink\r\ntable_list=1\r\ncontroller=faq\r\naction=filter\r\nimageiconmenu=/admin/img/icons/menu/icon_filter.png\r\ntitle=Фильтр\r\nwidth=690\r\nheight=510\r\nlevel=3\r\nrating=2\r\nparams=replaceme', '0000-00-00 00:00:00'),
	(57, 'Очистка фильтра', '', 'filter_clear', 'button', 'type_link=loadcontent\r\ntable_list=1\r\nprogram=/cgi-bin/faq_a.cgi\r\nimageiconmenu=/admin/img/icons/menu/icon_nofilter.png\r\naction=filter_clear\r\ntitle=Снять фильтры\r\nrating=3\r\nparams=replaceme', '0000-00-00 00:00:00'),
	(56, 'Список', '', 'list_link', 'button', 'type_link=loadcontent\r\nadd_info=1\r\ncontroller=faq\r\naction=enter\r\nimageiconmenu=/admin/img/icons/menu/button.list.png\r\ntitle=Список\r\nrating=1\r\nparams=replaceme', '0000-00-00 00:00:00'),
	(44, 'Дата вопроса', '', 'quest_date', 'lkey', 'type=time\r\nrating=5\r\ntable_list=6\r\ntable_list_name=Дата\r\nshablon_w=field_time_exp\r\ngroup=1\r\nfileview=1\r\ndirview=1', '0000-00-00 00:00:00'),
	(18, 'Ключевые слова', '', 'keywords', 'lkey', 'type=s\r\nrating=10\r\ngroup=1\r\nfilter=1\r\n', '2008-10-30 17:15:04'),
	(20, 'Публиковать', '', 'active', 'lkey', 'type=chb\r\nrating=99\r\ntable_list=5\r\ntable_list_name=-\ntable_list_width=48\nyes=Виден\r\nno=Скрыт\ngroup=1\r\nfilter=1\r\nfileview=1\r\ndirview=1', '2011-04-04 15:00:44'),
	(22, 'Датировать датой', '', 'tdate', 'lkey', 'type=time\r\nrating=7\r\ntable_list=6\r\ntable_list_name=Дата\r\nshablon_w=field_time_exp\r\ngroup=1\r\nfilter=1\r\nfileview=1\r\ndirview=1', '2008-10-30 17:15:04'),
	(34, 'Флаг показать', '', 'show', 'lkey', 'type=s\nsys=1', '2011-04-04 15:52:08'),
	(35, 'Флаг скрыть', '', 'hide', 'lkey', 'type=s\nsys=1', '2011-04-04 15:52:05'),
	(36, 'День', '', 'day', 'lkey', 'type=d', '0000-00-00 00:00:00'),
	(37, 'Месяц', '', 'month', 'lkey', 'type=d', '0000-00-00 00:00:00'),
	(38, 'Год', '', 'year', 'lkey', 'type=d', '0000-00-00 00:00:00'),
	(39, 'Имя', '', 'author_name', 'lkey', 'type=s\r\ntable_list=1\r\nfilter=1\r\ngroup=1\r\nrating=1\r\nno_format=1\r\nrequired=1\r\nqview=1\r\nshablon_reg=field_input\r\nshablon_view=field_input_read\r\neditform=1\r\nsaveform=1\r\nobligatory=1', '2011-04-04 15:00:44'),
	(41, 'Вопрос', '', 'name', 'lkey', 'type=text\r\ngroup=1\r\nrating=6\r\nshablon_reg=field_text\r\nshablon_view=field_text_read\r\neditform=1\r\nsaveform=1\r\nobligatory=1\r\nobligatory_rules=validate[required]\r\ncktoolbar=Basic\r\n\r\n', '2011-04-04 15:00:44'),
	(42, 'Ответ', '', 'answer', 'lkey', 'type=html\r\ngroup=1\r\nrating=90\r\ncktoolbar=Basic\r\n', '2010-07-23 14:29:28'),
	(45, 'Дата ответа', '', 'answer_date', 'lkey', 'type=time\r\nrating=5\r\ntable_list=6\r\ntable_list_name=Дата\r\nshablon_w=field_time_exp\r\ngroup=1\r\n', '0000-00-00 00:00:00'),
	(48, 'Поле подтверждения по картинке', 'regform', 'number', 'lkey', 'type=d\r\nrating=90\r\ngroup=1\r\nobligatory=1\r\n#regform=1\r\n#editform=1\r\nshablon_reg=field_imgconfirm', '0000-00-00 00:00:00'),
	(49, 'Код на картинке', '', 'code', 'lkey', 'type=d\r\nsys=1', '0000-00-00 00:00:00'),
	(71, 'Автор ответа', '', 'answer_name', 'lkey', 'type=s\r\nfilter=1\r\ngroup=1\r\nrating=2\r\nno_format=1\r\nqview=1', '2010-07-23 14:29:20'),
	(76, 'E-mail', '', 'email', 'lkey', 'type=s\r\ntable_list=1\r\nfilter=1\r\ngroup=1\r\nrating=3\r\nno_format=1\r\nrequired=1\r\nqview=1\r\neditform=1\r\nsaveform=1\r\nobligatory=1\r\n', '2011-04-04 15:00:44'),
	(77, 'Тема вопроса', '', 'quest_anons', 'lkey', 'type=s\r\nprint=1\r\nqview=1\r\nrating=5\r\nqview=1\r\ntable_list=5\r\ntable_list_width=100\r\nrequired=1\r\nnext_td=1\r\n\r\n\r\n', '2011-04-04 15:00:44'),
	(80, 'Телефон', '', 'phone', 'lkey', 'type=s\r\ntable_list=1\r\nfilter=1\r\ngroup=1\r\nrating=3\r\nno_format=1\r\nqview=1\r\nsaveform=1\r\n', '0000-00-00 00:00:00'),
	(81, 'Копировать запись', '', 'copy', 'button', 'type_link=loadcontent\nprint_info=1\nedit_info=1\ncontroller=faq\naction=copy\nloading_msg=1\nimageiconmenu=/admin/img/icons/menu/icon_copy.png\ntitle=Копировать запись\nrating=5\nparams=replaceme,index,list_table', '0000-00-00 00:00:00');
/*!40000 ALTER TABLE `keys_faq` ENABLE KEYS */;


-- Дамп структуры для таблица dev_fabprint.keys_feedback
CREATE TABLE IF NOT EXISTS `keys_feedback` (
  `ID` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL DEFAULT '',
  `tbl` varchar(64) NOT NULL DEFAULT '',
  `lkey` varchar(64) NOT NULL DEFAULT '',
  `object` varchar(8) NOT NULL DEFAULT '',
  `settings` text NOT NULL,
  `edate` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`ID`),
  UNIQUE KEY `tbl` (`tbl`,`lkey`,`object`)
) ENGINE=MyISAM AUTO_INCREMENT=17 DEFAULT CHARSET=cp1251 COMMENT='Ключи к модулю Тексты';

-- Дамп данных таблицы dev_fabprint.keys_feedback: 10 rows
/*!40000 ALTER TABLE `keys_feedback` DISABLE KEYS */;
INSERT INTO `keys_feedback` (`ID`, `name`, `tbl`, `lkey`, `object`, `settings`, `edate`) VALUES
	(1, 'Поле подтверждения по картинке', '', 'number', 'lkey', 'type=d\r\nrating=90\r\ngroup=1\r\nobligatory=1\r\nregform=1\r\neditform=1\r\nshablon_reg=field_imgconfirm\r\n', '0000-00-00 00:00:00'),
	(8, 'Индекс', '', 'index', 'lkey', 'sys=1', '0000-00-00 00:00:00'),
	(3, 'ФИО', '', 'name', 'lkey', 'type=s\r\nrating=1\r\nkeys_read=1\r\nshablon_reg=field_input\r\nshablon_view=field_input_read\r\neditform=1\r\nsaveform=1\r\nobligatory=1\r\nobligatory_rules=validate[required,custom[noSpecialCaracters],length[0,255]]', '0000-00-00 00:00:00'),
	(5, 'Код на картинке', '', 'code', 'lkey', 'type=d\r\nsys=1', '0000-00-00 00:00:00'),
	(6, 'Язык сайта', '', 'lang', 'lkey', 'type=list\r\nlist=lang\r\nrating=20', '0000-00-00 00:00:00'),
	(7, 'Ваше сообщение', '', 'ftext', 'lkey', 'type=text\r\nrating=5\r\nkeys_read=1\r\nshablon_reg=field_text\r\nshablon_view=field_input_read\r\nvacancy=1\r\neditform=1\r\nsaveform=1\r\nobligatory=1\r\nobligatory_rules=validate[required]', '0000-00-00 00:00:00'),
	(11, 'флаг отсылки', '', 'send', 'lkey', 'type=d\r\nsys=1', '0000-00-00 00:00:00'),
	(14, 'E-mail', '', 'email', 'lkey', 'type=email\r\nrating=4\r\nkeys_read=1\r\nshablon_reg=field_input\r\nshablon_view=field_input_read\r\neditform=1\r\nsaveform=1\r\nobligatory=1\r\nobligatory_rules=validate[required,custom[email]]', '0000-00-00 00:00:00'),
	(15, 'Тема сообщения', '', 'subject', 'lkey', 'type=s\r\nrating=5\r\nkeys_read=1\r\nshablon_reg=field_input\r\nshablon_view=field_input_read\r\n#editform=1\r\n#saveform=1\r\nobligatory_rules=validate[optional]', '0000-00-00 00:00:00'),
	(16, 'Телефон', '', 'phone', 'lkey', 'type=s\nrating=3\nkeys_read=1\nshablon_reg=field_input\nshablon_view=field_input_read\neditform=1\nsaveform=1\n', '0000-00-00 00:00:00');
/*!40000 ALTER TABLE `keys_feedback` ENABLE KEYS */;


-- Дамп структуры для таблица dev_fabprint.keys_filemanager
CREATE TABLE IF NOT EXISTS `keys_filemanager` (
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

-- Дамп данных таблицы dev_fabprint.keys_filemanager: 0 rows
/*!40000 ALTER TABLE `keys_filemanager` DISABLE KEYS */;
/*!40000 ALTER TABLE `keys_filemanager` ENABLE KEYS */;


-- Дамп структуры для таблица dev_fabprint.keys_global
CREATE TABLE IF NOT EXISTS `keys_global` (
  `ID` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL DEFAULT '',
  `tbl` varchar(64) NOT NULL DEFAULT '',
  `lkey` varchar(64) NOT NULL DEFAULT '',
  `object` varchar(8) NOT NULL DEFAULT '',
  `settings` text NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `tbl` (`tbl`,`lkey`,`object`)
) ENGINE=MyISAM AUTO_INCREMENT=135 DEFAULT CHARSET=utf8 COMMENT='Глобальные ключи';

-- Дамп данных таблицы dev_fabprint.keys_global: 100 rows
/*!40000 ALTER TABLE `keys_global` DISABLE KEYS */;
INSERT INTO `keys_global` (`ID`, `name`, `tbl`, `lkey`, `object`, `settings`, `updated_at`) VALUES
	(1, 'Ключ функции', '', 'action', 'lkey', 'type=slat', '2008-01-17 03:42:23'),
	(2, 'Индекс', '', 'index', 'lkey', 'type=d', '2008-01-12 20:31:32'),
	(3, 'Дата создания', '', 'rdate', 'lkey', 'type=datetime\r\ntemplate_w=field_input_read\ngroup=1\nrating=200', '2009-02-05 02:01:30'),
	(4, 'Дата редактирования', '', 'edate', 'lkey', 'type=datetime\ntemplate_w=field_input_read\ngroup=1\nrating=199', '0000-00-00 00:00:00'),
	(5, 'Случайная переменная', '', 'rndval', 'lkey', 'type=d\r\nsys=1', '2008-01-17 03:42:23'),
	(6, 'Поле сортировки', '', 'sfield', 'lkey', 'type=s', '2008-01-12 20:31:32'),
	(7, 'Страница', '', 'page', 'lkey', 'type=d', '2008-01-12 20:31:32'),
	(8, 'Порядок сортировки', '', 'asc', 'lkey', 'type=slat', '2008-01-12 20:31:32'),
	(9, 'Количество записей на страницу', '', 'pcol', 'lkey', 'type=d', '2008-01-12 20:31:32'),
	(10, 'Язык сайта', '', 'lang', 'lkey', 'type=list\r\nlist=ru|Русский\r\nnotnull=1\r\n', '2008-02-15 13:31:34'),
	(12, 'Программный модуль', '', 'id_program', 'lkey', 'type=tlist\r\nlist=sys_program\r\nsort=1\r\nrating=2\r\nfilter=1\r\nqview=1', '2007-12-06 21:23:35'),
	(13, 'Ключ', '', 'envkey', 'lkey', 'type=slat\r\nrating=3\r\nqview=1', '2007-12-06 21:23:35'),
	(14, 'Значение переменной', '', 'envvalue', 'lkey', 'type=text\r\nrating=4\r\nqview=1', '2007-12-06 21:23:35'),
	(15, 'Подсказка', '', 'help', 'lkey', 'type=s\r\nrating=4', '2007-12-06 21:23:35'),
	(16, 'Тип поля', '', 'types', 'lkey', 'type=list\r\nlist=s|Строка~slat|Строка-латиница~list|Список(выпадающий)~chb|Чебокс(да/нет)~list_chb|Список(множественный выбор)~list_radio|Список(единичный выбор)~email|e-mail~d|Число~code|Программный код~text|Текст~html|HTML текст~pict|Картинка~file|Файл\r\nrating=3\r\nlist_sort=asc_d', '2007-12-06 21:23:35'),
	(18, 'Значение по умолчнию', '', 'set_def', 'lkey', 'type=text\r\nrating=7', '2007-12-06 21:23:35'),
	(19, 'Список индексов', '', 'listindex', 'lkey', 'type=s\r\nsys=1', '2007-05-08 20:40:34'),
	(20, 'Ключ', '', 'lkey', 'lkey', 'type=slat', '2007-06-05 03:42:33'),
	(21, 'Таблица', '', 'tbl', 'lkey', 'type=slat', '2007-06-05 03:42:33'),
	(22, 'Программа (модуль)', '', 'modul', 'lkey', 'type=slat', '2007-06-05 03:42:33'),
	(23, 'Логин', '', 'login', 'lkey', 'type=login\r\nrating=4', '2008-02-29 03:03:10'),
	(24, 'Пароль', '', 'pwd', 'lkey', 'type=slat', '2008-02-29 03:03:10'),
	(25, 'Включать левую панель', '', 'leftwin_hidden', 'lkey', 'type=chb\r\nyes=включать\r\nне включать\r\nsys=1', '0000-00-00 00:00:00'),
	(26, 'Включать правую панель', '', 'rightwin_hidden', 'lkey', 'type=chb\r\nyes=включать\r\nне включать\r\nsys=1', '0000-00-00 00:00:00'),
	(34, 'Флаг удаления', '', 'delete', 'lkey', 'type=d', '2008-03-13 22:08:22'),
	(35, 'Контейнер для вставки информации', '', 'replaceme', 'lkey', 'type=s\r\nsys=1', '2008-03-16 04:07:49'),
	(33, 'Строка быстрого поиска', '', 'qsearch', 'lkey', 'type=s', '2008-03-12 15:30:36'),
	(36, 'Группа', '', 'group', 'lkey', 'type=d\r\nsys=1', '2008-03-17 01:14:18'),
	(37, 'Индекс родительского объекта', '', 'pid', 'lkey', 'type=d', '2008-01-12 20:31:32'),
	(38, 'Флаг первого открытия', '', 'first_flag', 'lkey', 'type=d\r\nsys=1', '0000-00-00 00:00:00'),
	(39, 'Ключ программы', '', 'key_program', 'lkey', 'type=s\nsys=1', '0000-00-00 00:00:00'),
	(40, 'Подстрока поиска', '', 'keystring', 'lkey', 'type=s\nsys=1', '0000-00-00 00:00:00'),
	(41, 'Поле', '', 'listfields', 'lkey', 'type=s\r\nsys=1', '0000-00-00 00:00:00'),
	(42, 'Правила связки полей', '', 'rules', 'lkey', 'type=s\nsys=1', '0000-00-00 00:00:00'),
	(43, 'Флаг открытия в модальном окне', '', 'flag_win', 'lkey', 'type=chb\nsys=1\nyes=да\nno=нет', '0000-00-00 00:00:00'),
	(44, 'Поле', '', 'lfield', 'lkey', 'type=s\nsys=1', '0000-00-00 00:00:00'),
	(45, 'Дополнительная таблица', '', 'dop_table', 'lkey', 'type=s\nsys=1', '0000-00-00 00:00:00'),
	(46, 'Доступ', '', 'access_flag', 'lkey', 'type=s\nsys=1', '0000-00-00 00:00:00'),
	(47, 'Ключ сессии', '', 'cck', 'lkey', 'type=s\nsys=1', '0000-00-00 00:00:00'),
	(48, 'Файл', '', 'Upload', 'lkey', 'type=file\nsys=1', '0000-00-00 00:00:00'),
	(49, 'Имя файла', '', 'Filename', 'lkey', 'type=filename\nsys=1', '0000-00-00 00:00:00'),
	(50, 'Имя файла', '', 'upfilefilename', 'lkey', 'type=file\nsys=1', '0000-00-00 00:00:00'),
	(51, 'Имя файла', '', 'filenamefilename', 'lkey', 'type=filename\nsys=1', '0000-00-00 00:00:00'),
	(52, 'Оператор', '', 'operator', 'lkey', 'type=s\nsys=1', '0000-00-00 00:00:00'),
	(53, 'Директория с файлами', '', 'folder', 'lkey', 'type=s\nsys=1', '0000-00-00 00:00:00'),
	(54, 'Размер файла', '', 'size', 'lkey', 'type=d\r\nsys=1\r\n\r\n', '0000-00-00 00:00:00'),
	(55, 'Тип файла', '', 'type_file', 'lkey', 'type=s\r\nsys=1\r\n', '0000-00-00 00:00:00'),
	(57, 'Имя файла', '', 'upfilepict', 'lkey', 'type=file\nsys=1', '0000-00-00 00:00:00'),
	(58, 'Имя файла', '', 'filenamepict', 'lkey', 'type=s\r\nsys=1', '0000-00-00 00:00:00'),
	(59, 'Имя файла', '', 'upfile', 'lkey', 'type=file\nsys=1', '0000-00-00 00:00:00'),
	(60, 'Индекс', '', 'ID', 'lkey', 'type=d\nsys=1', '0000-00-00 00:00:00'),
	(61, 'Дополнительная таблица', '', 'list_table', 'lkey', 'type=s\nsys=1', '0000-00-00 00:00:00'),
	(62, 'Запоминать при входе', '', 'auth_rem', 'lkey', 'type=chb\r\nyes=запоминать\r\nне запоминать\r\nsys=1', '0000-00-00 00:00:00'),
	(63, 'Ключ раздела', '', 'key_razdel', 'lkey', 'type=s\nsys=1', '0000-00-00 00:00:00'),
	(64, 'Флаг не перегружать меню кнопок', '', 'menu_button_no', 'lkey', 'type=d\nsys=1', '0000-00-00 00:00:00'),
	(65, 'Имя файла', '', 'Filedata', 'lkey', 'type=file\r\nsys=1', '0000-00-00 00:00:00'),
	(66, 'Разделы меню основной страницы ПУ', '', 'panel_razdel', 'lkey', 'type=list\r\nlist=1|Основные модули~2|Каталог, интернет-магазин~3|Дополнительные модули~4|Настройки', '2008-03-06 19:53:50'),
	(67, 'Панель управления', '', 'admin', 'button', 'type_link=loadcontent\r\nmenu_button=1\r\nmenu_settings=1\r\nmenu_banner=1\r\nmenu_center=1\r\nmenu_subscribe=1\r\nmenu_catalog=1\r\nmenu_users=1\r\nmenu_recall=1\r\nmenu_faq=1\r\nmainrazdel_button=1\r\nreplaceme=replaceme\r\ncontroller=main\r\naction=mainpage\r\nimageiconmenu=/admin/img/icons/menu/icon_home.png\r\ntitle=Панель управления\r\nrating=1\r\n', '2009-02-04 22:29:30'),
	(68, 'Выйти', '', 'logout', 'button', 'type_link=javascript\r\nfunction=loadfile("/admin/logout");\r\nmenu_button=1\r\nmenu_subscribe=1\r\nmenu_faq=1\r\nmenu_recall=1\r\nmenu_center=1\r\nmenu_catalog=1\r\nmenu_settings=1\r\nmenu_banner=1\r\nmenu_users=1\r\nmainrazdel_button=1\r\nimageiconmenu=/admin/img/icons/menu/icon_exit.png\r\ntitle=Выйти\r\nrating=200', '2009-02-04 22:30:40'),
	(70, 'Ключи', '', 'keys', 'button', 'type_link=loadcontent\r\nmenu_settings=1\r\nreplaceme=replaceme\r\ncontroller=keys\r\naction=mainpage\r\nimageiconmenu=/admin/img/icons/menu/icon_objects.png\r\ntitle=Объекты\r\nrating=3', '2008-03-15 21:51:53'),
	(71, 'Права доступа', '', 'access', 'button', 'type_link=loadcontent\r\nmenu_settings=1\r\nreplaceme=replaceme\r\ncontroller=access\r\naction=enter\r\nimageiconmenu=/admin/img/icons/menu/icon_access.png\r\ntitle=Политика безопасности\r\nrating=7', '2009-02-05 02:00:03'),
	(72, 'Шаблоны', '', 'templates', 'button', 'type_link=loadcontent\r\nmenu_settings=1\r\nreplaceme=replaceme\r\ncontroller=templates\r\naction=mainpage\r\nimageiconmenu=/admin/img/icons/menu/icon_templates.png\r\ntitle=Шаблоны\r\nrating=14\nsettings_topmenu=1\n', '2009-02-05 02:00:11'),
	(73, 'Стили', '', 'styles', 'button', 'type_link=loadcontent\r\nmenu_settings=1\r\nreplaceme=replaceme\r\ncontroller=styles\r\naction=mainpage\r\nimageiconmenu=/admin/img/icons/menu/icon_styles.png\r\ntitle=Стили\r\nrating=4\nsettings_topmenu=1\n', '2009-02-05 02:00:58'),
	(74, 'Глобальные переменные', '', 'vars', 'button', 'type_link=loadcontent\r\nmenu_settings=1\r\nreplaceme=replaceme\r\ncontroller=vars\r\naction=enter\r\nimageiconmenu=/admin/img/icons/menu/icon_settings.png\r\ntitle=Глобальные переменные\r\nrating=5\nsettings_topmenu=1\n', '2009-02-05 02:00:50'),
	(75, 'Учетные записи', '', 'sysusers', 'button', 'type_link=loadcontent\r\nmenu_settings=1\r\nreplaceme=replaceme\r\ncontroller=sysusers\r\naction=enter\r\nimageiconmenu=/admin/img/icons/menu/icon_users.png\r\ntitle=Учетные записи\r\nrating=6\nsettings_topmenu=1\n', '2009-02-05 01:59:53'),
	(76, 'Справочники', '', 'lists', 'button', 'type_link=loadcontent\r\nmenu_settings=1\r\nreplaceme=replaceme\r\ncontroller=lists\r\naction=mainpage\r\nprogram=/cgi-bin/lists_a.cgi\r\nimageiconmenu=/admin/img/icons/menu/icon_lists.png\r\ntitle=Справочники\r\nrating=2\nsettings_topmenu=1\n', '2009-02-05 02:00:25'),
	(77, 'Объекты', '', 'object', 'menu', 'type_link=loadcontent\r\naction=enter\r\nprogram=/cgi-bin/object_a.cgi\r\nrating=18\r\nparentid=setting\r\nreplaceme=replaceme\r\nsubmenuwidth=200', '0000-00-00 00:00:00'),
	(78, 'Флаг загрузки таблицы', '', 'table_flag', 'lkey', 'type=d\r\nsys=1', '2009-02-06 02:26:28'),
	(79, ' Временная переменная', '', 'amp', 'lkey', 'type=s\nsys=1\n', '2009-02-07 14:10:19'),
	(80, 'Новые данные сохранения QEdit', '', 'textEditValue', 'lkey', 'type=s\r\nsys=1', '2009-02-08 19:35:58'),
	(81, 'ID элемента для QEdit', '', 'textEditElementId', 'lkey', 'type=s\r\nsys=1', '2009-02-08 19:35:58'),
	(84, 'Флаг работы QEdit', '', 'saveTextEdit', 'lkey', 'type=d\r\nsys=1', '2009-02-14 13:59:54'),
	(85, 'Тексты', '', 'texts', 'button', 'type_link=loadcontent\r\nmainrazdel_button=1\r\ntexts_topmenu=1\r\nreplaceme=replaceme\r\ncontroller=texts\r\naction=enter\r\nimageiconmenu=/admin/img/icons/menu/button.text.png\r\ntitle=Тексты\r\nrating=2', '2009-03-17 17:09:40'),
	(86, 'Изображения', '', 'images', 'button', 'type_link=loadcontent\r\n#mainrazdel_button=1\r\nimages_topmenu=1\r\nreplaceme=replaceme\r\ncontroller=images\r\naction=enter\r\nimageiconmenu=/admin/img/icons/menu/button.image.png\r\ntitle=Изображения\r\nrating=5', '2009-04-09 16:41:55'),
	(87, 'Рекламные места', '', 'advplace', 'button', 'type_link=loadcontent\r\nmenu_banner=1\r\nbanners_topmenu=1\r\nreplaceme=replaceme\r\ncontroller=banners\r\ndo=list_container&list_table=data_banner_advert_block\r\nimageiconmenu=/admin/img/icons/menu/button.advplace.png\r\ntitle=Рекламные места\r\nrating=3\r\n', '2009-04-16 16:58:36'),
	(88, 'Рекламодатели', '', 'advuser', 'button', 'type_link=loadcontent\r\nmenu_banner=1\r\nbanners_topmenu=1\r\nreplaceme=replaceme\r\ncontroller=banners\r\ndo=list_container&list_table=data_banner_advert_users\r\nimageiconmenu=/admin/img/icons/menu/button.users.png\r\ntitle=Рекламодатели\r\nrating=4\r\n', '2009-04-16 16:59:00'),
	(89, 'Баннеры', '', 'banners', 'button', 'type_link=loadcontent\r\nmenu_banner=1\r\nbanners_topmenu=1\r\nreplaceme=replaceme\r\ncontroller=banners\r\ndo=enter\r\nimageiconmenu=/admin/img/icons/menu/button.banner.png\r\ntitle=Баннеры\r\nrating=2', '2009-04-16 16:59:18'),
	(90, 'ключ поля заменить на описание', '', 'eexcel_key', 'lkey', 'type=chb\nsys=1\nyes=да\nno=нет', '2009-04-19 20:41:32'),
	(91, 'индексы заменять на описание', '', 'eexcel_field', 'lkey', 'type=chb\nsys=1\nyes=да\nno=нет', '2009-04-19 20:42:10'),
	(100, 'Каталог', '', 'catalog', 'button', 'type_link=loadcontent\r\nmenu_catalog=1\r\ncatalog_topmenu=1\r\nreplaceme=replaceme\r\ncontroller=catalog\r\ndo=enter\r\nimageiconmenu=/admin/img/icons/program/catalog2.png\r\nrating=5\r\ntitle=Каталог', '2009-10-21 14:50:12'),
	(99, 'Датировать датой. Фильтр', '', 'tdatepref', 'lkey', 'type=s\r\nsys=1', '2009-10-20 17:27:07'),
	(101, 'Подписчики', '', 'subscribeusers', 'button', 'type_link=loadcontent\r\nmenu_subscribe=1\r\nreplaceme=replaceme\r\ncontroller=subscribe\r\ndo=list_container&list_table=data_subscribe_users\r\nimageiconmenu=/admin/img/icons/menu/button.users.png\r\nrating=11\r\ntitle=Подписчики', '2010-01-14 15:51:20'),
	(102, 'Группы подписчиков', '', 'subscribegroups', 'button', 'type_link=loadcontent\r\nmenu_subscribe=1\r\naction=list_items&list_table=data_subscribe_groups&menu_button_no=1\r\nimageiconmenu=/admin/img/icons/menu/button.advplace.png\r\nrating=3\r\ntitle=Группы подписчиков\r\nreplaceme=replaceme', '2010-01-14 15:58:27'),
	(107, 'Внешние пользователи', '', 'users', 'button', 'type_link=loadcontent\r\nmenu_users=1\r\nusers_topmenu=1\r\nreplaceme=replaceme\r\ncontroller=users\r\naction=enter\r\nimageiconmenu=/admin/img/icons/program/users.gif\r\nrating=10\r\ntitle=Внешние пользователи', '2010-03-31 21:25:01'),
	(115, 'Вопрос-Ответ', '', 'faq', 'button', 'type_link=loadcontent\r\nmenu_faq=1\r\nfaq_topmenu=1\r\nreplaceme=replaceme\r\ncontroller=faq\r\ndo=enter\r\nimageiconmenu=/admin/img/icons/program/faq.png\r\nrating=11\r\ntitle=Вопрос-Ответ', '2010-07-12 18:46:24'),
	(123, 'Ключ функции', '', 'do', 'lkey', 'type=slat\r\n', '2012-10-11 16:38:24'),
	(119, 'Кол-во записей на страницу (доп таблица)', '', 'pcol_doptable', 'lkey', 'type=d\r\n', '2011-11-05 16:22:01'),
	(120, 'Страница (доптаблица)', '', 'page_doptable', 'lkey', 'type=d\r\n', '2011-11-05 17:55:32'),
	(121, 'Алиас', '', 'alias', 'lkey', 'type=s\r\nrating=2\r\ntable_list=2\r\ngroup=1\r\nfilter=1\r\nqview=1\r\nqedit=1\r\nrequired=1\r\nhelp=Короткое латинское название, которое учавствует в формирование URL для данной страницы', '2012-01-21 18:18:21'),
	(122, 'Рассылка', '', 'subscribe', 'button', 'type_link=loadcontent\r\nmenu_subscribe=1\r\nreplaceme=replaceme\r\ncontroller=subscribe\r\ndo=enter\r\nimageiconmenu=/admin/img/icons/menu/button.subscribe.png\r\nrating=10\r\ntitle=Рассылка', '2012-05-21 21:09:02'),
	(124, 'Каталог. Категории', '', 'cataloggroups', 'button', 'type_link=loadcontent\r\nmenu_catalog=1\r\ncatalog_topmenu=1\r\nreplaceme=replaceme\r\ncontroller=catalog\r\ndo=list_container&list_table=data_catalog_categories\r\nimageiconmenu=/admin/img/icons/program/category.png\r\ntitle=Каталог. Категории\r\nrating=6\r\n', '2009-04-16 16:58:36'),
	(125, 'Каталог. Бренды', '', 'catalogbrands', 'button', 'type_link=loadcontent\r\nmenu_catalog=1\r\ncatalog_topmenu=1\r\nreplaceme=replaceme\r\ncontroller=catalog\r\ndo=list_container&list_table=data_catalog_brands\r\nimageiconmenu=/admin/img/icons/program/brands.png\r\ntitle=Каталог. Бренды\r\nrating=7\r\n', '2009-04-16 16:58:36'),
	(127, 'Каталог. Заказы', '', 'catalogorders', 'button', 'type_link=loadcontent\nmenu_catalog=1\ncatalog_topmenu=1\nreplaceme=replaceme\ncontroller=catalog\ndo=enter&list_table=data_catalog_orders\nimageiconmenu=/admin/img/icons/program/order.png\nrating=9\ntitle=Каталог. Заказы', '2009-04-16 16:58:36'),
	(128, 'Системный журнал', '', 'syslogs', 'button', 'type_link=loadcontent\r\nmenu_settings=1\r\nreplaceme=replaceme\r\ncontroller=syslogs\r\naction=enter\r\nimageiconmenu=/admin/img/icons/program/syslogs.png\r\ntitle=Системный журнал\nrating=15\nsettings_topmenu=1\n', '2009-02-05 01:59:53'),
	(129, 'SEO', '', 'seo', 'button', 'type_link=loadcontent\nmenu_settings=1\nreplaceme=replaceme\ncontroller=seo\naction=enter\nimageiconmenu=/admin/img/icons/program/seo.png\ntitle=SEO\nrating=9\nsettings_topmenu=1\n', '2013-07-04 21:06:27'),
	(130, 'Файлменеджер', '', 'filemanager', 'button', 'type_link=loadcontent\r\nmainrazdel_button=1\r\nreplaceme=replaceme\r\ncontroller=filemanager\r\naction=mainpage\r\nimageiconmenu=/admin/img/icons/program/filemanager.png\ntitle=Файлменеджер\r\nrating=99\nfilemanager_topmenu=1\n', '2009-02-05 02:00:58'),
	(131, 'Дата редактирования', '', 'updated_at', 'lkey', 'type=datetime\ntemplate_w=field_input_read\ngroup=1\nrating=199', '0000-00-00 00:00:00'),
	(132, 'Дата создания', '', 'created_at', 'lkey', 'type=datetime\r\ntemplate_w=field_input_read\ngroup=1\nrating=200', '2009-02-05 02:01:30'),
	(133, '301 Redirect', '', 'redirects', 'button', 'type_link=loadcontent\nmenu_settings=1\nreplaceme=replaceme\ncontroller=redirects\naction=enter\nimageiconmenu=/admin/img/icons/program/redirects.png\ntitle=301 Redirects\nrating=10\nsettings_topmenu=1\n', '2013-07-04 21:06:27'),
	(134, 'Отзывы', '', 'recall', 'button', 'type_link=loadcontent\nrecall_topmenu=1\nmenu_recall=1\nreplaceme=replaceme\ncontroller=recall\ndo=enter\nimageiconmenu=/admin/img/icons/program/links.png\nrating=15\ntitle=Отзывы', NULL);
/*!40000 ALTER TABLE `keys_global` ENABLE KEYS */;


-- Дамп структуры для таблица dev_fabprint.keys_images
CREATE TABLE IF NOT EXISTS `keys_images` (
  `ID` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL DEFAULT '',
  `tbl` varchar(64) NOT NULL DEFAULT '',
  `lkey` varchar(64) NOT NULL DEFAULT '',
  `object` varchar(8) NOT NULL DEFAULT '',
  `settings` text NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `tbl` (`tbl`,`lkey`,`object`)
) ENGINE=MyISAM AUTO_INCREMENT=189 DEFAULT CHARSET=utf8 COMMENT='Ключи к модулю Изображения';

-- Дамп данных таблицы dev_fabprint.keys_images: 48 rows
/*!40000 ALTER TABLE `keys_images` DISABLE KEYS */;
INSERT INTO `keys_images` (`ID`, `name`, `tbl`, `lkey`, `object`, `settings`, `updated_at`) VALUES
	(1, 'Добавить запись', '', 'add_link', 'button', 'type_link=openpage\nposition=center\nid=newentry\r\ntable_list=1\r\nprint_info=1\r\ntable_list_dir=1\r\ncontroller=images\r\nimageiconmenu=/admin/img/icons/menu/icon_add.png\r\naction=add\r\ntitle=Добавить\r\nrating=1\r\nparams=replaceme', '0000-00-00 00:00:00'),
	(2, 'Тексты. Добавить папку', '', 'add_link_dir', 'button', 'type_link=loadcontent\r\ntable_list_dir=1\r\ncontroller=images\r\nimageiconmenu=/admin/img/icons/menu/icon_dir_add.png\r\naction=add_dir\r\ntitle=Создать папку\r\nparams=replaceme\r\nrating=1', '0000-00-00 00:00:00'),
	(5, 'Удалить запись', '', 'del_link', 'button', 'type_link=loadcontent\r\ncontroller=images\r\naction=delete\r\nconfirm=Действительно удалить запись?\r\ntitle=Удалить запись\r\nimageiconmenu=/admin/img/icons/menu/icon_delete.png\r\nprint_info=1\r\nrating=1\r\nparams=replaceme,index,list_table', '0000-00-00 00:00:00'),
	(6, 'Редактировать запись', '', 'edit_link', 'button', 'type_link=loadcontent\r\nprint_info=1\r\ncontroller=images\r\nimageiconmenu=/admin/img/icons/menu/icon_edit.png\r\naction=edit\r\ntitle=Редактировать запись\r\nrating=2\r\nparams=replaceme,index,list_table', '0000-00-00 00:00:00'),
	(7, 'Закончить редактирование', '', 'end_link', 'button', 'type_link=loadcontent\r\nedit_info=1\r\ncontroller=images\r\nimageiconmenu=/admin/img/icons/menu/icon_ok.png\r\naction=info\r\ntitle=Закончить редактирование\r\nrating=10\r\nparams=replaceme,index,list_table', '0000-00-00 00:00:00'),
	(8, 'Фильтр', '', 'filter', 'button', 'type_link=modullink\r\ntable_list=1\r\ntable_list_dir=1\r\ncontroller=images\r\nimageiconmenu=/admin/img/icons/menu/icon_filter.png\r\naction=filter\r\ntitle=Фильтр\r\nwidth=690\r\nheight=510\r\nlevel=3\r\nrating=4\r\nparams=replaceme', '0000-00-00 00:00:00'),
	(9, 'Очистка фильтра', '', 'filter_clear', 'button', 'type_link=loadcontent\r\ntable_list=1\r\ntable_list_dir=1\r\ncontroller=images\r\nimageiconmenu=/admin/img/icons/menu/icon_nofilter.png\r\naction=filter_clear\r\ntitle=Снять фильтры\r\nrating=5\r\nparams=replaceme', '0000-00-00 00:00:00'),
	(11, 'Список', '', 'list_link', 'button', 'type_link=loadcontent\r\nadd_info=1\r\ncontroller=images\r\nimageiconmenu=/admin/img/icons/menu/button.list.png\r\naction=enter\r\ntitle=Список\r\nrating=1\r\nparams=replaceme', '0000-00-00 00:00:00'),
	(15, 'Раздел', '', 'razdel', 'lkey', 'type=tlist\nlist=lst_images\nnotnull=1', '2010-10-27 13:03:54'),
	(16, 'Название', '', 'name', 'lkey', 'type=s\nfilter=1\ntable_list=1\ngroup=1\nrequired=1\nqview=1\nqedit=1\nrating=1\ndirview=1\nfileview=1\nhelp=Название изображения для дальнейшей его идентификации в базе. На страницах сайта с клиентской стороны не используется.', '2010-10-27 13:03:54'),
	(17, 'Заголовок (en)', '', 'title_en', 'lkey', 'type=s\nrating=5\ngroup=1\nqview=1\nqedit=1\ndirview=1\nfileview=1\ntable_list=3\ntable_list_widht=150\nhelp=Описание изображения для клиентской части. Используется в фотогалерее для подписи изображения\n\n\n', '2008-10-20 11:22:12'),
	(18, 'Краткое описание', '', 'description', 'lkey', 'type=html\r\nrating=11\r\ngroup=2\r\ndirview=1\r\nfileview=1\r\nqview=1', '2010-10-19 15:39:29'),
	(19, 'Заголовок (ru)', '', 'title_ru', 'lkey', 'type=s\r\nrating=4\r\ngroup=1\r\nqview=1\r\nqedit=1\r\nfilter=1\r\ndirview=1\r\nfileview=1\r\ntable_list=2\r\ntable_list_width=150\r\nhelp=Описание изображения для клиентской части. Используется в фотогалерее для подписи изображения\r\n', '2010-10-27 13:03:54'),
	(20, 'Картинка', '', 'pict', 'lkey', 'type=pict\r\nrating=24\r\ntable_list=8\r\ntable_list_name=-\r\ntable_list_type=pict\r\nfolder=/images/gallery/\r\ntable_list_nosort=1\r\nshablon_w=field_pict\r\nshablon_r=field_pict_read\r\nsizelimit=20000\r\nmini=214x124~crop,1000\r\next=*.jpg;*.jpeg;*.tif\r\nfileview=1\ndirview=1\r\nhelp=Загрузите изображение на сервер', '2010-10-27 13:03:54'),
	(21, 'Папка/файл', '', 'dir', 'lkey', 'type=chb\ngroup=1\nrating=6\ntable_list=1\ntable_list_name=-\ntable_list_nosort=1\ntable_list_width=16\nyes=<img src="/admin/img/dtree/folder.gif">\nno=<img src="/admin/img/dtree/doc.gif">\nfilter=1\ntemplate_w=field_checkbox_read\n\n', '2010-10-27 13:03:54'),
	(22, 'Ключевые слова', '', 'keywords', 'lkey', 'type=s\r\nrating=6\r\ngroup=1\r\ndirview=1\r\nfileview=1\r\nhelp=Ключевые слова. Используются в фотогалерее при генерации страницы с данной фотографией или группой фотографий (для папок)\r\n', '2010-10-27 13:03:54'),
	(23, 'Рейтинг', '', 'rating', 'lkey', 'type=d\r\ngroup=1\r\nrating=99\r\ntable_list=10\r\ntable_list_name=Rt\r\ntable_list_width=32\r\nqedit=1\r\ndirview=1\r\nfileview=1\r\nshablon_w=field_rating\r\nhelp=Рейтинг служит для выстраивания фотографий и галерей друг относительно друга. Чем меньше значение, тем выше изображение (галерея) в иерархии', '2010-10-27 13:03:54'),
	(24, 'Ширина', '', 'width', 'lkey', 'type=d\r\ngroup=1\r\nrating=21\r\nshablon_w=field_input_read\r\nhelp=реальная ширина изображения. информация из файла\r\nfileview=1\r\nqview=1\r\n', '2010-05-31 16:13:29'),
	(25, 'Высота', '', 'height', 'lkey', 'type=d\r\ngroup=1\r\nrating=21\r\nshablon_w=field_input_read\r\nhelp=Высота изображения. Информация из файла\r\nfileview=1\r\nqview=1\r\n', '2010-05-31 16:13:29'),
	(26, 'Размер файла', '', 'size', 'lkey', 'type=d\nshablon_w=field_input_read\nrating=20\ngroup=1\nfilter=1\nqview=1\ntable_list=5\ntable_list_name=byte', '2010-05-31 16:13:29'),
	(27, 'Вложена в папку', '', 'image_gallery', 'lkey', 'type=tlist\r\nlist=images_gallery\r\nsort=1\r\nqview=1\r\nrating=7\r\nshablon_w=field_select_dir\r\nshablon_f=field_select_dir_filter\r\nwhere=AND `dir`=1 AND `image_gallery`=0\r\ngroup=1\r\ntable_list=4\r\ntable_list_width=200\r\nfilter=1\r\ndirview=1\r\nfileview=1\r\nhelp=Папка (галерея) для изображения', '2010-10-27 13:03:54'),
	(28, 'Публикация', '', 'viewimg', 'lkey', 'type=chb\r\nrating=101\r\ngroup=1\r\nqedit=1\r\ntable_list=11\ntable_list_name=-\r\ntable_list_width=48\r\nyes=Виден\r\nno=Скрыт\nqview=1\r\nfilter=1\r\ndirview=1\r\nfileview=1\r\nhelp=Данная опция предназначена для отключения отображения картинки в фотогалерее. Если вы используете изображение в тексте, то включение опции на отображение в тексте не влияет.', '2010-10-27 13:03:54'),
	(30, 'Миниатюрная копия', '', 'mini', 'lkey', 'type=list\nlist=mini\ngroup=1\nrating=15\nfileview=1\nhelp=При выборе соответствующего пункта будет создано миниатюрное изображение. Кадрировать - копия горизонтальная в 3:4, происходит вырезка кадра из базового изображения. Пропорционально - уменьшение до системного размера пропорционально. В квадрат - вписывается в квадрат. фон белый.\n', '2009-12-21 13:38:54'),
	(31, 'Используется', '', 'use', 'lkey', 'type=d\r\ngroup=1\r\nrating=55\r\nfileview=1\r\nshablon_w=field_use\r\nshablon_r=field_use_read\r\nhelp=Если указаны документы, то в них используется данное изображение. Чтобы удалить его из базы необходимо вначале убрать изображение из документов. ', '2008-10-30 17:10:45'),
	(32, 'Флаг удаления картинки', '', 'deletepict', 'lkey', 'type=chb\nsys=1', '2008-10-30 18:03:51'),
	(33, 'Файл', '', 'filename', 'lkey', 'type=filename\nrating=2\nsizelimit=20000\nfile_ext=*.*', '2010-10-27 13:03:51'),
	(34, 'Тип файла', '', 'type_file', 'lkey', 'type=slat\r\ngroup=2\r\nrating=21\r\nshablon_w=field_input_read\r\n', '2008-10-30 17:10:45'),
	(35, 'Флаг скрыть', '', 'hide', 'lkey', 'type=s\r\nsys=1', '2009-06-04 18:16:14'),
	(36, 'Флаг показать', '', 'show', 'lkey', 'type=s\r\nsys=1', '2010-08-21 19:28:17'),
	(37, 'Координата X', '', 'x', 'lkey', 'type=d\r\nsys=1', '2009-04-09 23:35:06'),
	(38, 'Координата Y', '', 'y', 'lkey', 'type=d\r\nsys=1', '2009-04-09 23:35:06'),
	(39, 'Процент', '', 'percent_size', 'lkey', 'type=s\r\nsys=1', '2009-04-09 23:35:06'),
	(40, 'Высота кадрирования', '', 'height_crop', 'lkey', 'type=d\r\nsys=1', '2009-04-09 23:35:06'),
	(41, 'Ширина кадрирования', '', 'width_crop', 'lkey', 'type=d\r\nsys=1', '2009-04-09 23:35:06'),
	(42, 'Загрузка архива', '', 'import', 'button', 'type_link=modullink\r\ntable_list=1\r\ntable_list_dir=1\r\ncontroller=images\r\nimageiconmenu=/admin/img/icons/menu/button.zipload.png\r\naction=zipimport\r\ntitle=Загрузка архива\r\nwidth=690\r\nheight=710\r\nlevel=3\r\nrating=2\r\nparams=replaceme', '0000-00-00 00:00:00'),
	(43, 'Архив', '', 'zip', 'lkey', 'type=file\r\nrating=14\r\ntemplate_w=field_file\r\ntemplate_r=field_file_read\r\nsizelimit=20000\r\next=*.zip\r\nfileview=1\r\ntable_list=2\r\nhelp=ZIP архив\r\nsave_msg=Нажмите «Начать загрузку»', '2010-08-21 19:26:56'),
	(44, 'Flash', '', 'swf', 'lkey', 'type=filename\r\nrating=24\r\nshablon_w=field_pict\r\nshablon_r=field_pict_read\r\nsizelimit=20000\r\nfile_ext=*.swf\r\n', '2009-04-27 13:16:38'),
	(45, 'День', '', 'day', 'lkey', 'type=d', '0000-00-00 00:00:00'),
	(46, 'Месяц', '', 'month', 'lkey', 'type=d', '0000-00-00 00:00:00'),
	(47, 'Год', '', 'year', 'lkey', 'type=d', '0000-00-00 00:00:00'),
	(52, 'Варианты миниатюры', '', 'mini', 'list', 'list=|не создавать~1|Кадрировать~2|Пропорционально~3|В квадрат\ntype=radio', '0000-00-00 00:00:00'),
	(53, 'Ширина (параметр для фильтра)', '', 'widthpref', 'lkey', 'type=s\nsys=1', '2010-05-31 16:13:29'),
	(54, 'Высота (параметр для фильтра)', '', 'heightpref', 'lkey', 'type=s\nsys=1', '2010-05-31 16:13:29'),
	(55, 'Размер (параметр для фильтра)', '', 'sizepref', 'lkey', 'type=s\nsys=1', '2010-05-31 16:13:29'),
	(56, 'Папка', '', 'image_catalog', 'lkey', 'type=tlist\r\nlist=images_catalog\r\nsort=1\r\nrating=7\r\nshablon_w=field_select_dir\r\nshablon_f=field_select_dir_filter\r\nwhere=AND `dir`=1 AND `image_catalog`=0\r\ngroup=1\r\nfilter=1\r\ndirview=1\r\nfileview=1\r\nhelp=Папка (галерея) для каталога объектов', '2009-06-15 14:17:42'),
	(65, 'Датировать датой', '', 'tdate', 'lkey', 'type=date\r\nrating=10\r\ngroup=1\r\nqview=1\r\nfilter=1\r\nfileview=1\r\ntable_list=5\r\ntable_list_width=70\r\ntemplate_f=field_date_filter', '0000-00-00 00:00:00'),
	(66, 'Алиас', '', 'alias', 'lkey', 'type=s\r\nrating=5\r\ntable_list=2\r\ngroup=1\r\nfilter=1\r\nqview=1\r\nqedit=1\r\nrequired=1\ndirview=1\nhelp=Короткое латинское название, которое учавствует в формирование URL для данной страницы\n', '0000-00-00 00:00:00'),
	(188, 'Копировать запись', '', 'copy', 'button', 'type_link=loadcontent\nprint_info=1\nedit_info=1\ncontroller=images\naction=copy\nloading_msg=1\nimageiconmenu=/admin/img/icons/menu/icon_copy.png\ntitle=Копировать запись\nrating=5\nparams=replaceme,index,list_table', '0000-00-00 00:00:00');
/*!40000 ALTER TABLE `keys_images` ENABLE KEYS */;


-- Дамп структуры для таблица dev_fabprint.keys_keys
CREATE TABLE IF NOT EXISTS `keys_keys` (
  `ID` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL DEFAULT '',
  `tbl` varchar(64) NOT NULL DEFAULT '',
  `lkey` varchar(64) NOT NULL DEFAULT '',
  `object` varchar(8) NOT NULL DEFAULT '',
  `settings` text NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `tbl` (`tbl`,`lkey`,`object`)
) ENGINE=MyISAM AUTO_INCREMENT=38 DEFAULT CHARSET=utf8 COMMENT='Ключи к модулю Object';

-- Дамп данных таблицы dev_fabprint.keys_keys: 16 rows
/*!40000 ALTER TABLE `keys_keys` DISABLE KEYS */;
INSERT INTO `keys_keys` (`ID`, `name`, `tbl`, `lkey`, `object`, `settings`, `updated_at`) VALUES
	(4, 'Таблица объектов', '', 'config_table', 'lkey', 'type=slat\r\nsys=1', '2010-09-13 19:48:27'),
	(5, 'Таблица', '', 'tbl', 'lkey', 'type=slat\nrating=4\ntable_list=4\nfilter=1\nhelp=Каждый ключ уникален для определенной таблицы. Чтобы разделить похожие объекты укажите таблицу, для которой действительны данные параметры ', '2010-09-10 21:49:59'),
	(6, 'Объект', '', 'object', 'lkey', 'type=list\r\nlist=lkey|Ключ~button|Кнопка~pane|Определение вкладки\r\nnotnull=1\r\nlist_type=radio\r\nrating=9\r\nfilter=1\r\ntable_list=2\r\nqview=1\r\nqedit=1\r\nhelp=В системе определено несколько типов объектов. Выберите, какой объект вы создаете\r\n', '2010-09-10 21:49:59'),
	(8, 'Настройки', '', 'settings', 'lkey', 'type=code\r\nrating=10\r\ngroup=1\r\ntemplate_r=field_settings_read\r\ntemplate_w=field_settings\r\nqview=1\r\nhelp=Дополнительные параметры объекта. Каждая строка описывает один параметр. Формат: КЛЮЧ=ЗНАЧЕНИЕ\r\n', '2010-09-10 21:49:59'),
	(9, 'Наименование', '', 'name', 'lkey', 'type=s\nrating=1\nfilter=1\ntable_list=1\nhelp=Название объекта\nrequired=1\nqview=1\nqedit=1\n', '2010-09-10 21:49:59'),
	(11, 'Ключ', '', 'lkey', 'lkey', 'type=slat\nrating=4\ntable_list=3\nrequired=1\nqview=1\nqedit=1\nfilter=1\nhelp=Ключ, по которому можно обратиться к объекту', '2010-09-10 21:49:59'),
	(12, 'Добавить запись', '', 'add_link', 'button', 'type_link=openpage\nposition=center\nid=newentry\r\ntable_list=1\r\nprint_info=1\r\ncontroller=keys\r\naction=add\r\ntitle=Добавить запись\r\nimageiconmenu=/admin/img/icons/menu/icon_add.png\r\nrating=1\r\nparams=list_table,replaceme\r\n', '2008-03-15 21:51:53'),
	(13, 'Копировать запись', '', 'copy_link', 'button', 'type_link=loadcontent\r\ncontroller=keys\r\ndo=copy\r\nimageiconmenu=/admin/img/icons/menu/icon_copy.png\r\ntitle=Копировать объект\r\nrating=3\r\nparams=list_table,replaceme,index\r\n#print_info=1\r\n#edit_info=1\r\n', '0000-00-00 00:00:00'),
	(14, 'Удалить запись', '', 'delete', 'button', 'type_link=loadcontent\r\ncontroller=keys\r\naction=delete\r\nimageiconmenu=/admin/img/icons/menu/icon_delete.png\r\nconfirm=Действительно удалить запись?\r\ntitle=Удалить объект\r\nrating=3\r\nparams=list_table,replaceme,index\r\nprint_info=1\r\n', '0000-00-00 00:00:00'),
	(15, 'Редактировать запись', '', 'edit_link', 'button', 'type_link=loadcontent\r\nprint_info=1\r\ncontroller=keys\r\naction=edit\r\nimageiconmenu=/admin/img/icons/menu/icon_edit.png\r\ntitle=Редактировать запись\r\nrating=2\r\nparams=list_table,replaceme,index', '2008-03-17 02:22:20'),
	(16, 'Объекты. Фильтр', '', 'filter', 'button', 'type_link=modullink\r\ntable_list=1\r\ncontroller=keys\r\naction=filter\r\nimageiconmenu=/admin/img/icons/menu/icon_filter.png\r\ntitle=Настроить фильтр\r\nwidth=690\r\nheight=510\r\nlevel=3\r\nrating=2\r\nparams=list_table,replaceme', '2008-03-15 21:51:53'),
	(17, 'Объекты. Очистка фильтра', '', 'filter_clear', 'button', 'type_link=loadcontent\r\ntable_list=1\r\ncontroller=keys\r\naction=filter_clear\r\ntitle=Снять фильтры\r\nimageiconmenu=/admin/img/icons/menu/icon_nofilter.png\r\nrating=3\r\nparams=list_table,replaceme', '2008-03-15 21:51:53'),
	(18, 'Список объектов', '', 'list_link', 'button', 'type_link=loadcontent\r\nadd_info=1\r\ncontroller=keys\r\nimageiconmenu=/admin/img/icons/menu/button.list.png\r\naction=list\r\ntitle=Список объектов\r\nrating=1\r\nparams=list_table,replaceme', '2008-03-15 21:51:53'),
	(19, 'Закончить редактирование', '', 'end_link', 'button', 'type_link=loadcontent\r\nedit_info=1\r\ncontroller=keys\r\naction=info\r\nimageiconmenu=/admin/img/icons/menu/icon_ok.png\r\ntitle=Закончить редактирование\r\nrating=10\r\nparams=list_table,replaceme,index', '2008-03-15 21:51:53'),
	(29, 'Объекты', '', 'listtable', 'button', 'type_link=loadcontent\r\nadd_object=1\r\ncontroller=keys\r\nimageiconmenu=/admin/img/icons/menu/button.list.png\r\naction=enter\r\ntitle=Объекты\r\nrating=1\r\nparams=replaceme', '0000-00-00 00:00:00'),
	(37, 'Копировать запись', '', 'copy', 'button', 'type_link=loadcontent\nprint_info=1\nedit_info=1\ncontroller=keys\naction=copy\nloading_msg=1\nimageiconmenu=/admin/img/icons/menu/icon_copy.png\ntitle=Копировать запись\nrating=5\nparams=replaceme,index,list_table', '0000-00-00 00:00:00');
/*!40000 ALTER TABLE `keys_keys` ENABLE KEYS */;


-- Дамп структуры для таблица dev_fabprint.keys_lists
CREATE TABLE IF NOT EXISTS `keys_lists` (
  `ID` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL DEFAULT '',
  `tbl` varchar(64) NOT NULL DEFAULT '',
  `lkey` varchar(64) NOT NULL DEFAULT '',
  `object` varchar(8) NOT NULL DEFAULT '',
  `settings` text NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `tbl` (`tbl`,`lkey`,`object`)
) ENGINE=MyISAM AUTO_INCREMENT=83 DEFAULT CHARSET=utf8 COMMENT='Ключи к модулю Lists';

-- Дамп данных таблицы dev_fabprint.keys_lists: 50 rows
/*!40000 ALTER TABLE `keys_lists` DISABLE KEYS */;
INSERT INTO `keys_lists` (`ID`, `name`, `tbl`, `lkey`, `object`, `settings`, `updated_at`) VALUES
	(44, 'Закончить редактирование', '', 'end_link', 'button', 'type_link=loadcontent\r\nedit_info=1\r\ncontroller=lists\r\naction=info\r\nimageiconmenu=/admin/img/icons/menu/icon_ok.png\r\ntitle=Закончить редактирование\r\nrating=10\r\nparams=list_table,replaceme,index', '0000-00-00 00:00:00'),
	(10, 'Название', '', 'name', 'lkey', 'type=s\r\nrating=1\r\nrequired=1\r\nqview=1\r\nqedit=1\r\ntable_list=2\r\n', '2010-10-04 16:44:07'),
	(11, 'Таблица-справочник', '', 'list_table', 'lkey', 'type=s\nsys=1', '2010-10-27 14:06:24'),
	(12, 'Страна', '', 'id_countries', 'lkey', 'type=tlist\nlist=lst_countries\nrating=2\nfilter=1\nqview=1\nshablon_w=field_select_input\nshablon_f=field_select_input_filter\nrules=id_region:lst_region.id_countries=index\nadd_to_list=1\nwidth=450\nheight=250', '2008-07-16 18:35:18'),
	(13, 'Регион', '', 'id_region', 'lkey', 'type=tlist\nlist=lst_region\nrating=3\nfilter=1\nqview=1\nshablon_w=field_select_input\nshablon_f=field_select_input_filter\nrules=id_countries:lst_region.index=id_countries', '2008-07-16 18:35:17'),
	(15, 'Список справочников', '', 'list_link', 'button', 'type_link=loadcontent\r\nadd_info=1\r\ncontroller=lists\r\nimageiconmenu=/admin/img/icons/menu/button.list.png\r\naction=list\r\ntitle=Список справочников\r\nrating=1\r\nparams=list_table,replaceme', '0000-00-00 00:00:00'),
	(16, 'Справочники. Очистка фильтра', '', 'filter_clear', 'button', 'type_link=loadcontent\r\ntable_list=1\r\ncontroller=lists\r\nimageiconmenu=/admin/img/icons/menu/icon_nofilter.png\r\naction=filter_clear\r\ntitle=Снять фильтры\r\nrating=3\r\nparams=list_table,replaceme', '0000-00-00 00:00:00'),
	(17, 'Справочники. Фильтр', '', 'filter', 'button', 'type_link=modullink\r\ntable_list=1\r\ncontroller=lists\r\naction=filter\r\nimageiconmenu=/admin/img/icons/menu/icon_filter.png\r\ntitle=Настроить фильтр\r\nwidth=690\r\nheight=510\r\nlevel=3\r\nrating=2\r\nparams=list_table,replaceme', '0000-00-00 00:00:00'),
	(18, 'Добавить запись', '', 'add_link', 'button', 'type_link=openpage\nposition=center\nid=newentry\r\ntable_list=1\r\nprint_info=1\r\ncontroller=lists\r\nimageiconmenu=/admin/img/icons/menu/icon_add.png\r\naction=add\r\ntitle=Добавить запись\r\nrating=1\r\nparams=list_table,replaceme', '0000-00-00 00:00:00'),
	(20, 'Город', '', 'id_city', 'lkey', 'type=tlist\r\nlist=lst_citys\r\nrating=3\r\nfilter=1\r\ngroup=1\r\nqview=1\r\nrequired=1\r\n', '2010-05-24 15:51:53'),
	(22, 'Населенный пункт', '', 'id_vilage', 'lkey', 'type=tlist\nlist=lst_vilage\nrating=34\nfilter=1\ngroup=2\nkey_program=lists\nshablon_w=field_select_input\nshablon_f=field_select_input_filter\nrules=id_city:lst_vilage.index=id_city', '2008-07-16 18:35:19'),
	(23, 'Справочники', '', 'lists', 'menu', 'type_link=loadcontent\r\naction=enter\r\nprogram=/cgi-bin/lists_a.cgi\r\nrating=21\r\nparentid=setting\r\nreplaceme=replaceme\r\nsubmenuwidth=200', '0000-00-00 00:00:00'),
	(25, 'Ключ раздела', '', 'key_razdel', 'lkey', 'type=s\r\nrating=2\r\nrequired=1', '2009-11-19 17:03:46'),
	(26, 'Группа пользователей', '', 'id_group_user', 'lkey', 'type=tlist\r\nlist=lst_group_user\r\nrating=5\r\nqview=1\r\nmult=7\r\nshablon_w=field_multselect', '2008-09-16 23:35:30'),
	(27, 'Пользователь', '', 'users', 'lkey', 'type=tlist\r\nlist=sys_users\r\nrating=10\r\nqview=1\r\nmult=7\r\nshablon_w=field_multselect', '2008-09-16 23:35:30'),
	(28, 'Список ключей для редактирования', '', 'listf', 'lkey', 'type=s\r\nrating=3', '2008-09-16 23:35:30'),
	(32, 'Ширина', 'lst_advert_block', 'width', 'lkey', 'type=d\ngroup=1\nrating=15\ntable_list_name=W\ntable_list_width=32\nqview=1\nqedit=1', '2009-08-25 18:46:00'),
	(33, 'Высота', 'lst_advert_block', 'height', 'lkey', 'type=d\ngroup=1\nrating=16\ntable_list_name=H\ntable_list_width=32\nqview=1\nqedit=1', '2009-08-25 18:46:00'),
	(34, 'Цена за клик', '', 'per_click', 'lkey', 'type=d\r\nfileview=1\r\ntable_list=4\r\ntable_list_name=$/click\r\ntable_list_width=100\r\nrating=10\r\ngroup=1\r\nqview=1\r\nqedit=1\r\n', '2009-08-25 18:46:00'),
	(35, 'Цена за показ', '', 'per_show', 'lkey', 'type=d\r\nrating=11\r\ngroup=1\r\nqview=1\r\nqedit=1\r\nfileview=1\r\ntable_list=5\r\ntable_list_width=100\r\ntable_list_name=$/показ', '2009-08-25 18:46:00'),
	(45, 'Пароль', 'lst_advert_users', 'password', 'lkey', 'type=password\nrequired=1\nrating=3', '2009-04-16 15:56:33'),
	(46, 'E-mail', 'lst_advert_users', 'email', 'lkey', 'type=email\nrating=5', '2009-04-16 15:56:33'),
	(47, 'Логин', 'lst_advert_users', 'login', 'lkey', 'type=slat\nrequired=1\nrating=2', '2009-04-16 15:56:33'),
	(48, 'Фото 1', '', 'foto1', 'lkey', 'type=tlist\r\nlist=images_fond\r\nrating=20\r\ngroup=1\r\nkey_program=lists\r\nshablon_w=field_select_input\r\nshablon_f=field_select_input_filter\r\nhelp=Введите несколько символов фото из базы изображений и потом выберите его из списка\r\nwhere= `dir`=0', '0000-00-00 00:00:00'),
	(49, 'Фото 2', '', 'foto2', 'lkey', 'type=tlist\r\nlist=images_fond\r\nrating=21\r\ngroup=1\r\nkey_program=lists\r\nshablon_w=field_select_input\r\nshablon_f=field_select_input_filter\r\nhelp=Введите несколько символов фото из базы изображений и потом выберите его из списка\r\nwhere= `dir`=0', '0000-00-00 00:00:00'),
	(50, 'Фото 3', '', 'foto3', 'lkey', 'type=tlist\r\nlist=images_fond\r\nrating=22\r\ngroup=1\r\nkey_program=lists\r\nshablon_w=field_select_input\r\nshablon_f=field_select_input_filter\r\nhelp=Введите несколько символов фото из базы изображений и потом выберите его из списка\r\nwhere= `dir`=0', '0000-00-00 00:00:00'),
	(51, 'Фотографии', '', 'id_images', 'lkey', 'type=tlist\r\nlist=images_projects\r\nsort=1\r\nrating=10\r\ngroup=1\r\nwhere= AND `image_projects`=\'0\' AND `dir`=1\r\nfilter=1\r\nshablon_w=field_select_input\r\nshablon_f=field_select_input_filter', '0000-00-00 00:00:00'),
	(52, 'Текст', '', 'text', 'lkey', 'type=html\r\ngroup=1\r\nrating=4\r\nshablon=field_html_full\r\nfileview=1\r\n', '2009-12-17 12:07:25'),
	(53, 'Фотографии', '', 'id_equipimg', 'lkey', 'type=tlist\r\nlist=images_equipment\r\nsort=1\r\nrating=8\r\ngroup=1\r\nwhere= AND `image_equipment`=\'0\' AND `dir`=1\r\nfilter=1\r\nshablon_w=field_select_input\r\nshablon_f=field_select_input_filter', '0000-00-00 00:00:00'),
	(54, 'Проект', '', 'id_project', 'lkey', 'type=tlist\r\nlist=texts_projects_ru\r\nsort=1\r\nrating=10\r\ngroup=1\r\nfilter=1\r\nshablon_w=field_select_input\r\nshablon_f=field_select_input_filter', '0000-00-00 00:00:00'),
	(55, 'Прикрепить отзыв', '', 'id_recall', 'lkey', 'type=tlist\r\nlist=data_recall\r\nsort=1\r\nrating=40\r\ngroup=1\r\nfilter=1\r\nshablon_w=field_select_input\r\nshablon_f=field_select_input_filter\r\n', '0000-00-00 00:00:00'),
	(56, 'Рубрика', '', 'id_docfiles_rubrics', 'lkey', 'type=tlist\r\nlist=lst_docfiles_rubrics\r\nsort=1\r\nrating=3\r\ngroup=1\r\nfilter=1\r\nshablon_w=field_select_input\r\nshablon_f=field_select_input_filter\r\nhelp=Выберите тематическую рубрику\r\nfileview=1\r\nadd_to_list=1\r\nwidth=400\r\nheight=250\r\nrules_all=1\r\n', '0000-00-00 00:00:00'),
	(57, 'Подрубрика', '', 'id_docfiles_subrubrics', 'lkey', 'type=tlist\r\nlist=lst_docfiles_rubrics\r\nsort=1\r\nrating=9\r\ngroup=1\r\nfilter=1\r\nshablon_w=field_select_input\r\nshablon_f=field_select_input_filter\r\nrules=id_docfiles_rubrics:lst_docfiles_rubrics.ID=tmp|texts_docfiles:texts_docfiles_ru.id_docfiles_subrubrics=index\r\nrules_where= AND `dir`=\'1\'\r\nwhere= AND `id_rubrics`>\'0\'\r\nhelp=Выберите тематическую подрубрику\r\nfileview=1\r\nadd_to_list=1\r\nwidth=400\r\nheight=250\r\nrules_all=1\r\n', '0000-00-00 00:00:00'),
	(58, 'Родительская рубрика', '', 'id_rubrics', 'lkey', 'type=tlist\r\nlist=lst_docfiles_rubrics\r\nsort=1\r\nrating=2\r\nprint=1\r\nfileview=1\r\nwhere= AND `id_rubrics`=\'0\'\r\n', '2010-01-15 12:14:22'),
	(59, 'Рейтинг', '', 'rating', 'lkey', 'type=d\r\ngroup=1\r\nqview=1\r\nqedit=1\r\ntable_list=6\r\ntable_list_name=Rt\r\ntable_list_width=32\r\nrating=99\r\ntemplate_w=field_rating', '2010-09-30 14:33:40'),
	(60, 'Отображать на сайте', '', 'active', 'lkey', 'type=chb\r\nprint=1\r\nrating=99\r\nfileview=1\r\nfilter=1\r\ntable_list=10\r\ntable_list_width=48\ntable_list_name=-\r\nyes=Виден\r\nno=Скрыт\n\r\n', '2010-10-04 16:44:07'),
	(71, 'Верхняя цена диапозона', '', 'max', 'lkey', 'type=d\r\nprint=1\r\nqview=1\r\nrating=4\r\nqedit=1\r\nshablon_w=field_rating\r\n', '2010-05-27 14:47:05'),
	(63, 'Флаг получения инф.', '', 'get', 'lkey', 'type=d\r\nsys=1', '0000-00-00 00:00:00'),
	(70, 'Нижняя цена диапозона', '', 'min', 'lkey', 'type=d\r\nprint=1\r\nqview=1\r\nrating=3\r\nqedit=1\r\nshablon_w=field_rating\r\n', '2010-05-27 14:47:05'),
	(72, 'CSS class списка', '', 'ulclass', 'lkey', 'type=s\r\nprint=1\r\nrating=30\r\n', '0000-00-00 00:00:00'),
	(73, 'CSS class контейнера', '', 'divclass', 'lkey', 'type=s\r\nsys=1\r\n', '0000-00-00 00:00:00'),
	(74, 'Вес', '', 'weight', 'lkey', 'type=d\r\nprint=1\r\nqview=1\r\ntable_list=3\r\ntable_list_width=70\r\nfilter=1\r\nshablon_w=field_rating\r\nrating=4\r\n\r\n', '2010-10-04 16:44:07'),
	(75, 'Ссылка', '', 'link', 'lkey', 'type=s\r\nprint=1\r\nqview=1\r\nrating=3\r\ntable_list=2\r\ntable_list_width=100\r\n', '2010-10-04 16:44:07'),
	(76, 'Материал ID', '', 'material_id', 'lkey', 'type=s\r\nprint=1\r\nsys=1\r\n\r\n', '0000-00-00 00:00:00'),
	(77, 'Рост, см', 'lst_catalog_sizes', 'name', 'lkey', 'type=d\r\nrating=1\r\nrequired=1\r\nqview=1\r\nqedit=1\r\ntable_list=2\r\n', '0000-00-00 00:00:00'),
	(78, 'Возраст', '', 'age', 'lkey', 'type=s\r\nrating=3\r\nqview=1\r\nqedit=1\r\ntable_list=3\r\n', '0000-00-00 00:00:00'),
	(79, 'Короткий код', '', 'code', 'lkey', 'type=s\r\nrating=5\r\nrequired=1\r\nqview=1\r\nqedit=1\r\ntable_list=3\r\n', '0000-00-00 00:00:00'),
	(80, 'Редактировать запись', '', 'edit_link', 'button', 'type_link=loadcontent\r\nprint_info=1\r\ncontroller=lists\r\naction=edit\r\nimageiconmenu=/admin/img/icons/menu/icon_edit.png\r\ntitle=Редактировать запись\r\nrating=2\r\nparams=replaceme,index,list_table', '0000-00-00 00:00:00'),
	(81, 'Название шаблона', '', 'layout', 'lkey', 'type=s\r\nprint=1\r\nqview=1\r\nrating=10\r\ntable_list=3\r\ntable_list_width=100\r\nsys=1\r\n\r\n', '0000-00-00 00:00:00'),
	(82, 'Копировать запись', '', 'copy', 'button', 'type_link=loadcontent\nprint_info=1\nedit_info=1\ncontroller=lists\naction=copy\nloading_msg=1\nimageiconmenu=/admin/img/icons/menu/icon_copy.png\ntitle=Копировать запись\nrating=5\nparams=replaceme,index,list_table', '0000-00-00 00:00:00');
/*!40000 ALTER TABLE `keys_lists` ENABLE KEYS */;


-- Дамп структуры для таблица dev_fabprint.keys_mainconfig
CREATE TABLE IF NOT EXISTS `keys_mainconfig` (
  `ID` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL DEFAULT '',
  `tbl` varchar(64) NOT NULL DEFAULT '',
  `lkey` varchar(64) NOT NULL DEFAULT '',
  `object` varchar(8) NOT NULL DEFAULT '',
  `settings` text NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `tbl` (`tbl`,`lkey`,`object`)
) ENGINE=MyISAM AUTO_INCREMENT=17 DEFAULT CHARSET=utf8 COMMENT='Ключи к модулю MainConfig';

-- Дамп данных таблицы dev_fabprint.keys_mainconfig: 9 rows
/*!40000 ALTER TABLE `keys_mainconfig` DISABLE KEYS */;
INSERT INTO `keys_mainconfig` (`ID`, `name`, `tbl`, `lkey`, `object`, `settings`, `updated_at`) VALUES
	(10, 'Строка запроса', '', 'qstring', 'lkey', 'type=s\nsys=1', '0000-00-00 00:00:00'),
	(6, ' Выход', '', 'exit', 'menu', 'type_link=javascript\nfunction=loadfile("/cgi-bin/auth.cgi?action=logout");\n#type_link=openurl\ntitle=Выход\nimageiconmenu=/admin/img/icons/menu/icon_exit_min.gif\nurl=/cgi-bin/auth.cgi?action=logout\nrating=25\nparentid=file', '2008-03-09 15:23:23'),
	(8, 'Лог ключей', '', 'keys_log', 'menu', 'type_link=openpage\naction=keys_log\nprogram=/cgi-bin/admin.cgi\ntitle=Лог ключей\ntabtitle=Лог ключей\nrating=5\nparentid=instrument\nposition=east\nid=keys_log', '2008-03-09 15:23:23'),
	(9, 'Лог ошибок mysql', '', 'log_mysql', 'menu', 'type_link=openpage\naction=log_mysql\nprogram=/cgi-bin/admin.cgi\ntitle=Лог ошибок MySQL\ntabtitle=log_mysql\nrating=6\nparentid=instrument\nposition=east\nid=log_mysql', '2008-03-09 15:23:23'),
	(12, 'Инструменты', '', 'instrument', 'menu', 'type_link=nothing\r\ntitle=Инструменты\r\nrating=5\r\nsubmenuwidth=200', '0000-00-00 00:00:00'),
	(13, 'Настройки', '', 'setting', 'menu', 'type_link=nothing\ntitle=Настройки\nrating=15\nsubmenuwidth=200\n', '0000-00-00 00:00:00'),
	(14, 'Правка', '', 'edit', 'menu', 'type_link=nothing\ntitle=Правка\nrating=2\nsubmenuwidth=200\n', '0000-00-00 00:00:00'),
	(15, 'Справка', '', 'help', 'menu', 'type_link=openurl\ntitle=Справка\nurl=http://office/admin\nrating=25', '0000-00-00 00:00:00'),
	(16, 'Файл', '', 'file', 'menu', 'type_link=nothing\ntitle=Файл\nrating=1\nsubmenuwidth=200\n', '0000-00-00 00:00:00');
/*!40000 ALTER TABLE `keys_mainconfig` ENABLE KEYS */;


-- Дамп структуры для таблица dev_fabprint.keys_recall
CREATE TABLE IF NOT EXISTS `keys_recall` (
  `ID` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL DEFAULT '',
  `tbl` varchar(64) NOT NULL DEFAULT '',
  `lkey` varchar(64) NOT NULL DEFAULT '',
  `object` varchar(8) NOT NULL DEFAULT '',
  `settings` text NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `tbl` (`tbl`,`lkey`,`object`)
) ENGINE=MyISAM AUTO_INCREMENT=82 DEFAULT CHARSET=cp1251 COMMENT='Ключи к модулю Отзывы';

-- Дамп данных таблицы dev_fabprint.keys_recall: 26 rows
/*!40000 ALTER TABLE `keys_recall` DISABLE KEYS */;
INSERT INTO `keys_recall` (`ID`, `name`, `tbl`, `lkey`, `object`, `settings`, `updated_at`) VALUES
	(62, 'Добавить запись', '', 'add_link', 'button', 'type_link=openpage\nposition=center\nid=newentry\r\ntable_list=1\r\nprint_info=1\r\ncontroller=recall\r\naction=add\r\nimageiconmenu=/admin/img/icons/menu/icon_add.png\r\ntitle=Добавить\r\nrating=1\r\nparams=replaceme', '0000-00-00 00:00:00'),
	(61, 'Удалить запись', '', 'del_link', 'button', 'type_link=loadcontent\r\ncontroller=recall\r\naction=delete\r\nimageiconmenu=/admin/img/icons/menu/icon_delete.png\r\nconfirm=Действительно удалить запись?\r\ntitle=Удалить запись\r\nprint_info=1\r\nrating=1\r\nparams=replaceme,index', '0000-00-00 00:00:00'),
	(60, 'Редактировать запись', '', 'edit_link', 'button', 'type_link=loadcontent\r\nprint_info=1\r\ncontroller=recall\r\naction=edit\r\nimageiconmenu=/admin/img/icons/menu/icon_edit.png\r\ntitle=Редактировать запись\r\nrating=2\r\nparams=replaceme,index', '0000-00-00 00:00:00'),
	(59, 'Закончить редактирование', '', 'end_link', 'button', 'type_link=loadcontent\r\nedit_info=1\r\ncontroller=recall\r\naction=info\r\nimageiconmenu=/admin/img/icons/menu/icon_ok.png\r\ntitle=Закончить редактирование\r\nrating=10\r\nparams=replaceme,index\r\n', '0000-00-00 00:00:00'),
	(58, 'Фильтр', '', 'filter', 'button', 'type_link=modullink\r\ntable_list=1\r\ncontroller=recall\r\naction=filter\r\nimageiconmenu=/admin/img/icons/menu/icon_filter.png\r\ntitle=Фильтр\r\nwidth=690\r\nheight=510\r\nlevel=3\r\nrating=2\r\nparams=replaceme', '0000-00-00 00:00:00'),
	(57, 'Очистка фильтра', '', 'filter_clear', 'button', 'type_link=loadcontent\r\ntable_list=1\r\nprogram=/cgi-bin/recall_a.cgi\r\nimageiconmenu=/admin/img/icons/menu/icon_nofilter.png\r\naction=filter_clear\r\ntitle=Снять фильтры\r\nrating=3\r\nparams=replaceme', '0000-00-00 00:00:00'),
	(56, 'Список', '', 'list_link', 'button', 'type_link=loadcontent\r\nadd_info=1\r\ncontroller=recall\r\naction=enter\r\nimageiconmenu=/admin/img/icons/menu/button.list.png\r\ntitle=Список\r\nrating=1\r\nparams=replaceme', '0000-00-00 00:00:00'),
	(44, 'Дата вопроса', '', 'quest_date', 'lkey', 'type=time\r\nrating=5\r\ntable_list=6\r\ntable_list_name=Дата\r\nshablon_w=field_time_exp\r\ngroup=1\r\nfileview=1\r\ndirview=1', '0000-00-00 00:00:00'),
	(18, 'Ключевые слова', '', 'keywords', 'lkey', 'type=s\r\nrating=10\r\ngroup=1\r\nfilter=1\r\n', '2008-10-30 17:15:04'),
	(20, 'Публиковать', '', 'active', 'lkey', 'type=chb\r\nrating=99\r\ntable_list=5\r\ntable_list_name=-\ntable_list_width=48\nyes=Виден\r\nno=Скрыт\ngroup=1\r\nfilter=1\r\nfileview=1\r\ndirview=1', '2011-04-04 15:00:44'),
	(22, 'Датировать датой', '', 'tdate', 'lkey', 'type=date\nrating=10\ngroup=1\nqview=1\nfilter=1\nfileview=1\ntable_list=8\ntable_list_width=70\ntemplate_f=field_date_filter\nhelp=Укажите какой датой датировать эту запись', '2015-04-03 18:15:57'),
	(34, 'Флаг показать', '', 'show', 'lkey', 'type=s\nsys=1', '2011-04-04 15:52:08'),
	(35, 'Флаг скрыть', '', 'hide', 'lkey', 'type=s\nsys=1', '2011-04-04 15:52:05'),
	(36, 'День', '', 'day', 'lkey', 'type=d', '0000-00-00 00:00:00'),
	(37, 'Месяц', '', 'month', 'lkey', 'type=d', '0000-00-00 00:00:00'),
	(38, 'Год', '', 'year', 'lkey', 'type=d', '0000-00-00 00:00:00'),
	(39, 'Отзыв', '', 'recall', 'lkey', 'type=text\ntable_list=3\nfilter=1\ngroup=1\nrating=5\nno_format=1\nrequired=1\nqview=1\neditform=1\nsaveform=1\nobligatory=1', '2015-04-03 18:13:22'),
	(41, 'Имя автора', '', 'name', 'lkey', 'type=s\ngroup=1\nrating=1\nqview=1\nqedit=1\ntable_list=1\neditform=1\nsaveform=1\nobligatory=1\nobligatory_rules=validate[required]\ncktoolbar=Basic', '2015-04-03 17:06:58'),
	(42, 'Ответ', '', 'answer', 'lkey', 'type=html\ngroup=1\nrating=8\nrating=90\ncktoolbar=Basic', '2015-04-03 17:04:28'),
	(48, 'Поле подтверждения по картинке', 'regform', 'number', 'lkey', 'type=d\r\nrating=90\r\ngroup=1\r\nobligatory=1\r\n#regform=1\r\n#editform=1\r\nshablon_reg=field_imgconfirm', '0000-00-00 00:00:00'),
	(49, 'Код на картинке', '', 'code', 'lkey', 'type=d\r\nsys=1', '0000-00-00 00:00:00'),
	(71, 'Автор ответа', '', 'answer_name', 'lkey', 'type=s\nfilter=1\ngroup=1\nrating=7\nno_format=1\nqview=1', '2015-04-03 17:04:16'),
	(76, 'E-mail', '', 'email', 'lkey', 'type=s\ntable_list=2\nfilter=1\ngroup=1\nrating=4\nno_format=1\nrequired=1\nqview=1\neditform=1\nsaveform=1\nobligatory=1', '2015-04-03 17:06:01'),
	(77, 'Тема вопроса', '', 'quest_anons', 'lkey', 'type=s\r\nprint=1\r\nqview=1\r\nrating=5\r\nqview=1\r\ntable_list=5\r\ntable_list_width=100\r\nrequired=1\r\nnext_td=1\r\n\r\n\r\n', '2011-04-04 15:00:44'),
	(80, 'Телефон', '', 'phone', 'lkey', 'type=s\r\ntable_list=1\r\nfilter=1\r\ngroup=1\r\nrating=3\r\nno_format=1\r\nqview=1\r\nsaveform=1\r\n', '0000-00-00 00:00:00'),
	(81, 'Копировать запись', '', 'copy', 'button', 'type_link=loadcontent\nprint_info=1\nedit_info=1\ncontroller=recall\naction=copy\nloading_msg=1\nimageiconmenu=/admin/img/icons/menu/icon_copy.png\ntitle=Копировать запись\nrating=5\nparams=replaceme,index,list_table', '0000-00-00 00:00:00');
/*!40000 ALTER TABLE `keys_recall` ENABLE KEYS */;


-- Дамп структуры для таблица dev_fabprint.keys_redirects
CREATE TABLE IF NOT EXISTS `keys_redirects` (
  `ID` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL DEFAULT '',
  `tbl` varchar(64) NOT NULL DEFAULT '',
  `lkey` varchar(64) NOT NULL DEFAULT '',
  `object` varchar(8) NOT NULL DEFAULT '',
  `settings` text NOT NULL,
  `edate` datetime DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `tbl` (`tbl`,`lkey`,`object`)
) ENGINE=MyISAM AUTO_INCREMENT=50 DEFAULT CHARSET=utf8 COMMENT='Ключи к модулю Тексты';

-- Дамп данных таблицы dev_fabprint.keys_redirects: 8 rows
/*!40000 ALTER TABLE `keys_redirects` DISABLE KEYS */;
INSERT INTO `keys_redirects` (`ID`, `name`, `tbl`, `lkey`, `object`, `settings`, `edate`) VALUES
	(1, 'Добавить запись', '', 'add_link', 'button', 'type_link=loadcontent\ntable_list=1\nprint_info=1\ncontroller=redirects\naction=add\nimageiconmenu=/admin/img/icons/menu/icon_add.png\ntitle=Добавить\nrating=1\nparams=replaceme,list_table', '2014-06-30 18:32:10'),
	(2, 'Удалить запись', '', 'del_link', 'button', 'type_link=loadcontent\ncontroller=redirects\naction=delete\nconfirm=Действительно удалить запись?\ntitle=Удалить запись\nimageiconmenu=/admin/img/icons/menu/icon_delete.png\nprint_info=1\nrating=1\nparams=replaceme,index,list_table', '2014-06-30 18:32:20'),
	(3, 'Редактировать запись', '', 'edit_link', 'button', 'type_link=loadcontent\nprint_info=1\ncontroller=redirects\naction=edit\nimageiconmenu=/admin/img/icons/menu/icon_edit.png\ntitle=Редактировать запись\nrating=2\nparams=replaceme,index,list_table', '2014-06-30 18:32:28'),
	(4, 'Закончить редактирование', '', 'end_link', 'button', 'type_link=loadcontent\nedit_info=1\ncontroller=redirects\naction=info\nimageiconmenu=/admin/img/icons/menu/icon_ok.png\ntitle=Закончить редактирование\nrating=1\nparams=replaceme,index,list_table', '2014-06-30 18:32:36'),
	(5, 'Фильтр', '', 'filter', 'button', 'type_link=modullink\ntable_list=1\ntable_list_orders=1\ncontroller=redirects\naction=filter\nimageiconmenu=/admin/img/icons/menu/icon_filter.png\ntitle=Фильтр\nwidth=690\nheight=510\nlevel=3\nrating=2\nparams=replaceme,list_table', '2014-06-30 18:32:43'),
	(6, 'Очистка фильтра', '', 'filter_clear', 'button', 'type_link=loadcontent\ntable_list=1\ntable_list_orders=1\ntable_list_dir=1\ncontroller=redirects\naction=filter_clear\nimageiconmenu=/admin/img/icons/menu/icon_nofilter.png\ntitle=Снять фильтры\nrating=3\nparams=replaceme,list_table', '2014-06-30 18:32:51'),
	(39, 'Исходная ссылка', '', 'source_url', 'lkey', 'type=site\ngroup=1\nqview=1\nqedit=1\ntable_list=3\nrequired=1\nrating=3\n', '2014-06-30 19:10:18'),
	(49, 'Ссылка назначения', '', 'last_url', 'lkey', 'type=site\ngroup=1\nqview=1\nqedit=1\ntable_list=4\nrequired=1\ntable_list_width=500\nrating=4', '2014-06-30 19:10:26');
/*!40000 ALTER TABLE `keys_redirects` ENABLE KEYS */;


-- Дамп структуры для таблица dev_fabprint.keys_seo
CREATE TABLE IF NOT EXISTS `keys_seo` (
  `ID` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL DEFAULT '',
  `tbl` varchar(64) NOT NULL DEFAULT '',
  `lkey` varchar(64) NOT NULL DEFAULT '',
  `object` varchar(8) NOT NULL DEFAULT '',
  `settings` text NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `tbl` (`tbl`,`lkey`,`object`)
) ENGINE=MyISAM AUTO_INCREMENT=52 DEFAULT CHARSET=utf8 COMMENT='Ключи к модулю Тексты';

-- Дамп данных таблицы dev_fabprint.keys_seo: 13 rows
/*!40000 ALTER TABLE `keys_seo` DISABLE KEYS */;
INSERT INTO `keys_seo` (`ID`, `name`, `tbl`, `lkey`, `object`, `settings`, `updated_at`) VALUES
	(1, 'Добавить запись', '', 'add_link', 'button', 'type_link=openpage\nposition=center\nid=newentry\r\ntable_list=1\r\nprint_info=1\r\ncontroller=seo\r\naction=add\r\nimageiconmenu=/admin/img/icons/menu/icon_add.png\r\ntitle=Добавить\r\nrating=1\r\nparams=replaceme,list_table', '0000-00-00 00:00:00'),
	(2, 'Удалить запись', '', 'del_link', 'button', 'type_link=loadcontent\r\ncontroller=seo\r\naction=delete\r\nconfirm=Действительно удалить запись?\r\ntitle=Удалить запись\r\nimageiconmenu=/admin/img/icons/menu/icon_delete.png\r\nprint_info=1\r\nrating=1\r\nparams=replaceme,index,list_table', '0000-00-00 00:00:00'),
	(3, 'Редактировать запись', '', 'edit_link', 'button', 'type_link=loadcontent\r\nprint_info=1\r\ncontroller=seo\r\naction=edit\r\nimageiconmenu=/admin/img/icons/menu/icon_edit.png\r\ntitle=Редактировать запись\r\nrating=2\r\nparams=replaceme,index,list_table', '0000-00-00 00:00:00'),
	(4, 'Закончить редактирование', '', 'end_link', 'button', 'type_link=loadcontent\r\nedit_info=1\r\ncontroller=seo\r\naction=info\r\nimageiconmenu=/admin/img/icons/menu/icon_ok.png\r\ntitle=Закончить редактирование\r\nrating=10\r\nparams=replaceme,index,list_table\r\n', '0000-00-00 00:00:00'),
	(5, 'Фильтр', '', 'filter', 'button', 'type_link=modullink\r\ntable_list=1\r\ntable_list_orders=1\r\ncontroller=seo\r\naction=filter\r\nimageiconmenu=/admin/img/icons/menu/icon_filter.png\r\ntitle=Фильтр\r\nwidth=690\r\nheight=510\r\nlevel=3\r\nrating=2\r\nparams=replaceme,list_table', '0000-00-00 00:00:00'),
	(6, 'Очистка фильтра', '', 'filter_clear', 'button', 'type_link=loadcontent\r\ntable_list=1\r\ntable_list_orders=1\r\ntable_list_dir=1\r\ncontroller=seo\r\naction=filter_clear\r\nimageiconmenu=/admin/img/icons/menu/icon_nofilter.png\r\ntitle=Снять фильтры\r\nrating=3\r\nparams=replaceme,list_table', '0000-00-00 00:00:00'),
	(7, 'Заголовок (title)', '', 'name', 'lkey', 'type=s\r\nfilter=1\r\ngroup=1\r\nrating=1\r\nrequired=1\r\nqedit=1\r\ntable_list=1\r\nno_format=1\r\nfileview=1\r\nhelp=Заголовок окна браузера. Может отличаться от названия текста. Используется для оптимизации под поисковые ', '2010-10-31 11:29:29'),
	(39, 'Ссылка', '', 'url', 'lkey', 'type=site\r\ngroup=1\r\nqview=1\r\nqedit=1\r\ntable_list=3\r\ntable_list_width=200\r\nrating=3\r\n', '0000-00-00 00:00:00'),
	(38, 'Ключевые слова (keywords)', '', 'keywords', 'lkey', 'type=s\r\nprint=1\r\ngroup=1\r\nrating=10\nqview=1\nqedit=1\nhelp=Ключевые слова и выражения, разделенные запятой, которые соответствуют данному тексту. Используется для оптимизации страницы под поисковые системы. Указанные слова в данном поле должны обязательно присутствовать в тексте — в противном случае они не будут учитываться поисковыми машинами.\n\r\n', '0000-00-00 00:00:00'),
	(48, 'Краткое описание страницы (description)', '', 'description', 'lkey', 'type=text\r\nprint=1\r\ngroup=1\r\nrating=11\nqview=1\nqedit=1\nhelp=Краткое описание текста. Используется для поисковых систем. Выводится на странице в meta-теге description. Как правило, пользователь данный текст не видет. Для поисковых систем полезнее для каждой страницы формировать свое описание, наиболее соответствующее данной странице.\n\r\n', '0000-00-00 00:00:00'),
	(49, 'Копировать запись', '', 'copy', 'button', 'type_link=loadcontent\nprint_info=1\nedit_info=1\ncontroller=seo\naction=copy\nloading_msg=1\nimageiconmenu=/admin/img/icons/menu/icon_copy.png\ntitle=Копировать запись\nrating=5\nparams=replaceme,index,list_table', '0000-00-00 00:00:00'),
	(50, 'SEO заголовок', '', 'seo_title', 'lkey', 'type=s\nrating=5\ngroup=1\nqview=1\nqedit=1\nfilter=1\ntable_list=0\ntable_list_width=0\nfileview=1\nrequired=0', '2015-04-17 17:29:41'),
	(51, 'SEO текст', '', 'seo_text', 'lkey', 'type=html\nrating=6\ngroup=1\nqview=1\nqedit=1\nfilter=1\ntable_list=0\ntable_list_width=0\nfileview=1\nrequired=0', '2015-04-17 17:29:48');
/*!40000 ALTER TABLE `keys_seo` ENABLE KEYS */;


-- Дамп структуры для таблица dev_fabprint.keys_styles
CREATE TABLE IF NOT EXISTS `keys_styles` (
  `ID` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL DEFAULT '',
  `tbl` varchar(64) NOT NULL DEFAULT '',
  `lkey` varchar(64) NOT NULL DEFAULT '',
  `object` varchar(8) NOT NULL DEFAULT '',
  `settings` text NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `tbl` (`tbl`,`lkey`,`object`)
) ENGINE=MyISAM AUTO_INCREMENT=17 DEFAULT CHARSET=utf8 COMMENT='Ключи к модулю Object';

-- Дамп данных таблицы dev_fabprint.keys_styles: 3 rows
/*!40000 ALTER TABLE `keys_styles` DISABLE KEYS */;
INSERT INTO `keys_styles` (`ID`, `name`, `tbl`, `lkey`, `object`, `settings`, `updated_at`) VALUES
	(7, 'Код', '', 'code', 'lkey', 'type=code\r\nrating=4\r\nshablon_w=field_css\r\nshablon_r=field_code_read\r\n', '2010-10-27 14:12:45'),
	(15, 'Папка', '', 'dir', 'lkey', 'type=s\r\nrating=2\r\nhelp=Путь к файлу\r\nrequired=1\r\ntemplate_w=field_input_read\r\nqview=1\r\nqedit=1\r\n', '0000-00-00 00:00:00'),
	(16, 'Файл', '', 'name', 'lkey', 'type=s\r\nrating=1\r\nfilter=1\r\ntable_list=1\r\nhelp=Название шаблона\r\nrequired=1\r\ntemplate_w=field_input_read\r\nqview=1\r\nqedit=1\r\n', '0000-00-00 00:00:00');
/*!40000 ALTER TABLE `keys_styles` ENABLE KEYS */;


-- Дамп структуры для таблица dev_fabprint.keys_subscribe
CREATE TABLE IF NOT EXISTS `keys_subscribe` (
  `ID` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL DEFAULT '',
  `tbl` varchar(64) NOT NULL DEFAULT '',
  `lkey` varchar(64) NOT NULL DEFAULT '',
  `object` varchar(8) NOT NULL DEFAULT '',
  `settings` text NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `tbl` (`tbl`,`lkey`,`object`)
) ENGINE=MyISAM AUTO_INCREMENT=38 DEFAULT CHARSET=cp1251 COMMENT='Ключи к модулю Рассылка';

-- Дамп данных таблицы dev_fabprint.keys_subscribe: 21 rows
/*!40000 ALTER TABLE `keys_subscribe` DISABLE KEYS */;
INSERT INTO `keys_subscribe` (`ID`, `name`, `tbl`, `lkey`, `object`, `settings`, `updated_at`) VALUES
	(5, 'E-mail', '', 'email', 'lkey', 'type=email\r\ngroup=1\r\nrating=3\r\ntable_list=2\r\nrequired=1\r\nobligatory=1\r\nfileview=1\r\n', '2010-02-16 23:31:20'),
	(6, 'Активация', '', 'active', 'lkey', 'type=chb\r\nrating=11\r\ntable_list=5\r\ntable_list_name= \r\ngroup=1\r\nyes=активен\r\nno=не активен\r\nfilter=1\r\n', '2010-02-16 23:31:20'),
	(7, 'Добавить запись', '', 'add_link', 'button', 'type_link=openpage\nposition=center\nid=newentry\r\ntable_list=1\r\ncontroller=subscribe\r\naction=add\r\nimageiconmenu=/admin/img/icons/menu/icon_add.png\r\ntitle=Добавить\r\nrating=1\r\nparams=replaceme,users_flag,list_table', '0000-00-00 00:00:00'),
	(10, 'Удалить запись', '', 'del_link', 'button', 'type_link=loadcontent\r\ncontroller=subscribe\r\naction=delete\r\nconfirm=Действительно удалить запись?\r\nimageiconmenu=/admin/img/icons/menu/icon_delete.png\r\ntitle=Удалить запись\r\nprint_info=1\r\nrating=1\r\nparams=replaceme,index,users_flag', '0000-00-00 00:00:00'),
	(11, 'Редактировать запись', '', 'edit_link', 'button', 'type_link=loadcontent\r\nprint_info=1\r\ncontroller=subscribe\r\nimageiconmenu=/admin/img/icons/menu/icon_edit.png\r\naction=edit\r\ntitle=Редактировать запись\r\nrating=2\r\nparams=replaceme,index,list_table', '0000-00-00 00:00:00'),
	(12, 'Закончить редактирование', '', 'end_link', 'button', 'type_link=loadcontent\r\nedit_info=1\r\ncontroller=subscribe\r\naction=info\r\nimageiconmenu=/admin/img/icons/menu/icon_ok.png\r\ntitle=Закончить редактирование\r\nrating=1\r\nparams=replaceme,index,list_table', '0000-00-00 00:00:00'),
	(13, 'Фильтр', '', 'filter', 'button', 'type_link=modullink\r\ntable_list=1\r\ncontroller=subscribe\r\naction=filter\r\nimageiconmenu=/admin/img/icons/menu/icon_filter.png\r\ntitle=Фильтр\r\nwidth=690\r\nheight=510\r\nlevel=3\r\nrating=2\r\nparams=replaceme,users_flag', '0000-00-00 00:00:00'),
	(14, 'Очистка фильтра', '', 'filter_clear', 'button', 'type_link=loadcontent\r\ntable_list=1\r\ncontroller=subscribe\r\nimageiconmenu=/admin/img/icons/menu/icon_nofilter.png\r\naction=filter_clear\r\ntitle=Снять фильтры\r\nrating=3\r\nparams=replaceme,users_flag', '0000-00-00 00:00:00'),
	(16, 'Группы подписчиков', '', 'status', 'button', 'type_link=openpage\r\nmenu_button=1\r\nprogram=/cgi-bin/lists_a.cgi\r\naction=list&list_table=lst_status&menu_button_no=1\r\nimageiconmenu=/admin/img/icons/menu/button.advplace.png\r\ntitle=Группы подписчиков\r\nrating=3\r\nreplaceme=listslst_status\r\nid=listslst_status\r\n', '0000-00-00 00:00:00'),
	(19, 'Название рассылки', 'data_subscribe', 'name', 'lkey', 'type=s\r\nfilter=1\r\ngroup=1\r\nrating=1\r\ntable_list=1\r\nno_format=1\r\nrequired=1\r\nobligatory=1', '0000-00-00 00:00:00'),
	(20, 'Название', '', 'name', 'lkey', 'type=s\r\nfilter=1\r\ngroup=1\r\nrating=1\r\ntable_list=1\r\nno_format=1\r\nrequired=1\r\nobligatory=1', '2010-02-12 17:13:56'),
	(21, 'Тема письма', '', 'subject', 'lkey', 'type=s\r\nrating=2\r\ngroup=1\r\nrequired=1', '2010-02-12 17:13:56'),
	(22, 'Список', '', 'list_link', 'button', 'type_link=loadcontent\r\nadd_info=1\r\ncontroller=subscribe\r\naction=enter\r\ntitle=Список\r\nrating=1\r\nparams=replaceme,users_flag', '0000-00-00 00:00:00'),
	(23, 'Текст рассылки', '', 'text', 'lkey', 'type=html\r\ngroup=2\r\nrating=1', '2010-02-11 18:01:58'),
	(24, 'Статистика', '', 'stat', 'lkey', 'type=table\r\ntable=dtbl_subscribe_stat\r\ngroup=3\r\nrating=15\r\nshablon_w=field_table\r\ntable_fields=user_id,send_at\r\ntable_svf=subscribe_id\r\ntable_sortfield=send_at\r\ntable_buttons_key_w=delete,edit\r\ntable_groupname=Общая информация\r\ntable_noindex=1', '0000-00-00 00:00:00'),
	(25, 'Пользователь', '', 'user_id', 'lkey', 'type=tlist\r\nlist=data_subscribe_users\r\nrating=2', '2010-01-14 13:13:37'),
	(26, 'Дата отправки', '', 'send_date', 'lkey', 'type=datetime\r\n', '0000-00-00 00:00:00'),
	(27, 'Разослать письмо', '', 'send_link', 'button', 'type_link=loadcontent\r\nprint_info=1\r\ncontroller=subscribe\r\nimageiconmenu=/admin/img/icons/menu/icon_subscribesend.png\r\naction=send\r\ntitle=Разослать письмо\r\nrating=1\r\nparams=replaceme,index', '0000-00-00 00:00:00'),
	(28, 'Разослано', '', 'send', 'lkey', 'type=chb\r\nrating=3\r\ntable_list=3\r\ntable_list_name=Разослано\r\ngroup=1\r\nyes=да\r\nno=нет\r\nfilter=1\r\n', '2010-02-12 17:13:56'),
	(37, 'Группа рассылки', '', 'group_id', 'lkey', 'type=tlist\r\nlist=data_subscribe_groups\r\nrating=2\r\ntable_list=2\r\ntable_list_name=Группа', NULL),
	(32, 'Индекс', '', 'index', 'lkey', 'type=d\r\nsys=1\r\n', '2010-03-12 17:03:16');
/*!40000 ALTER TABLE `keys_subscribe` ENABLE KEYS */;


-- Дамп структуры для таблица dev_fabprint.keys_syslogs
CREATE TABLE IF NOT EXISTS `keys_syslogs` (
  `ID` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL DEFAULT '',
  `tbl` varchar(64) NOT NULL DEFAULT '',
  `lkey` varchar(64) NOT NULL DEFAULT '',
  `object` varchar(8) NOT NULL DEFAULT '',
  `settings` text NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `tbl` (`tbl`,`lkey`,`object`)
) ENGINE=MyISAM AUTO_INCREMENT=46 DEFAULT CHARSET=utf8 COMMENT='Ключи к модулю Sysusers';

-- Дамп данных таблицы dev_fabprint.keys_syslogs: 12 rows
/*!40000 ALTER TABLE `keys_syslogs` DISABLE KEYS */;
INSERT INTO `keys_syslogs` (`ID`, `name`, `tbl`, `lkey`, `object`, `settings`, `updated_at`) VALUES
	(1, 'Действие', '', 'name', 'lkey', 'type=s\nrating=1\ntable_list=1\nrequired=1\nqview=1\nqedit=1\ntemplate_w=field_input_read\n', '2010-03-11 14:34:30'),
	(7, 'Управление доступом. Фильтр', '', 'filter', 'button', 'type_link=modullink\r\ntable_list=1\r\ncontroller=syslogs\r\naction=filter\r\nimageiconmenu=/admin/img/icons/menu/icon_filter.png\r\ntitle=Настроить фильтр\r\nwidth=690\r\nheight=510\r\nlevel=3\r\nrating=2\r\nparams=replaceme', '0000-00-00 00:00:00'),
	(8, 'Управление доступом. Очистка фильтра', '', 'filter_clear', 'button', 'type_link=loadcontent\r\ntable_list=1\r\ncontroller=syslogs\r\nimageiconmenu=/admin/img/icons/menu/icon_nofilter.png\r\naction=filter_clear\r\ntitle=Снять фильтры\r\nrating=3\r\nparams=replaceme', '0000-00-00 00:00:00'),
	(9, 'Удалить запись', '', 'del_link', 'button', 'type_link=loadcontent\r\ncontroller=syslogs\r\naction=delete\r\nimageiconmenu=/admin/img/icons/menu/icon_delete.png\r\nconfirm=Действительно удалить запись?\r\ntitle=Удалить запись\r\nprint_info=1\r\nrating=1\r\nparams=replaceme,index', '0000-00-00 00:00:00'),
	(10, 'Список пользователей', '', 'list_link', 'button', 'type_link=loadcontent\r\nadd_info=1\r\ncontroller=syslogs\r\nimageiconmenu=/admin/img/icons/menu/button.list.png\r\naction=enter\r\ntitle=Список пользователей\r\nrating=1\r\nparams=replaceme', '0000-00-00 00:00:00'),
	(45, 'Дата создания', '', 'created_at', 'lkey', 'type=datetime\r\nrating=100\r\ngroup=1\r\nqview=1\r\nfilter=1\r\nfileview=1\r\ntable_list=11\r\ntable_list_width=70\r\ntemplate_f=field_date_filter', '2014-02-20 10:12:54'),
	(41, 'Комментарий', '', 'comment', 'lkey', 'type=text\nprint=1\nqview=1\nrating=90\nfileview=1\ntemplate_w=field_input_read\n\n', '0000-00-00 00:00:00'),
	(42, 'IP', '', 'ip', 'lkey', 'type=s\nprint=1\nqview=1\nqedit=1\nfilter=1\nrating=15\ntable_list=9\ntable_list_width=70\ntemplate_w=field_input_read\n', '0000-00-00 00:00:00'),
	(40, 'Модуль', '', 'id_program', 'lkey', 'type=tlist\nlist=sys_program\nrating=6\nprint=1\nqview=1\nfilter=1\ntable_list=2\ntable_list_width=150\ntemplate_w=field_list_read\n', '0000-00-00 00:00:00'),
	(44, 'Тип события', '', 'eventtype', 'lkey', 'type=list\nlist=1|Добавление~2|Удаление~3|Редактирование~4|Восстановление~5|Авторизация~6|Ошибка\nlist_type=radio\nfilter=1\nrating=30\nfileview=1\ntable_list=8\ntable_list_width=70\nqview=1\nprint=1\ntemplate_w=field_list_read\n', '0000-00-00 00:00:00'),
	(43, 'Группа', '', 'id_sysusergroup', 'lkey', 'type=tlist\nlist=lst_group_user\nrating=6\nprint=1\nqview=1\nfilter=1\ntable_list=6\ntable_list_width=150\ntemplate_w=field_list_read\n', '0000-00-00 00:00:00'),
	(39, 'Пользователь', '', 'id_sysuser', 'lkey', 'type=tlist\nlist=sys_users\nrating=5\nprint=1\nqview=1\nfilter=1\ntable_list=5\ntable_list_width=150\ntemplate_w=field_list_read\n', '2014-04-04 12:53:36');
/*!40000 ALTER TABLE `keys_syslogs` ENABLE KEYS */;


-- Дамп структуры для таблица dev_fabprint.keys_sysusers
CREATE TABLE IF NOT EXISTS `keys_sysusers` (
  `ID` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL DEFAULT '',
  `tbl` varchar(64) NOT NULL DEFAULT '',
  `lkey` varchar(64) NOT NULL DEFAULT '',
  `object` varchar(8) NOT NULL DEFAULT '',
  `settings` text NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `tbl` (`tbl`,`lkey`,`object`)
) ENGINE=MyISAM AUTO_INCREMENT=40 DEFAULT CHARSET=utf8 COMMENT='Ключи к модулю Sysusers';

-- Дамп данных таблицы dev_fabprint.keys_sysusers: 26 rows
/*!40000 ALTER TABLE `keys_sysusers` DISABLE KEYS */;
INSERT INTO `keys_sysusers` (`ID`, `name`, `tbl`, `lkey`, `object`, `settings`, `updated_at`) VALUES
	(1, 'Имя пользователя', '', 'name', 'lkey', 'type=s\nrating=1\ntable_list=1\nrequired=1\nqview=1\nqedit=1', '2010-03-11 11:34:30'),
	(2, 'Логин', '', 'login', 'lkey', 'type=s\r\nrating=1\r\nrequired=1\r\nqview=1\r\nqedit=1\r\ntable_list=2\r\n', '2010-03-11 11:34:30'),
	(3, 'E-mail', '', 'email', 'lkey', 'type=email\r\nrating=3\r\nmask=email\r\n', '2010-03-11 11:34:30'),
	(4, 'Пароль', '', 'password_digest', 'lkey', 'type=password\r\nrating=5\r\nrequired=1', '2010-03-11 11:34:30'),
	(5, 'Группа пользователей', '', 'id_group_user', 'lkey', 'type=tlist\nlist=lst_group_user\ntable_list=3\nrating=5\nrequired=1\nqview=1\nfilter=1\nmult=7\nshablon_w=field_multselect\nnotnull=1', '2010-03-11 11:34:30'),
	(6, 'Дата последней авторизации', '', 'vdate', 'lkey', 'type=datetime\r\nrating=10\r\n', '2010-03-10 20:25:26'),
	(7, 'Управление доступом. Фильтр', '', 'filter', 'button', 'type_link=modullink\r\ntable_list=1\r\ncontroller=sysusers\r\naction=filter\r\nimageiconmenu=/admin/img/icons/menu/icon_filter.png\r\ntitle=Настроить фильтр\r\nwidth=690\r\nheight=510\r\nlevel=3\r\nrating=2\r\nparams=replaceme', '0000-00-00 00:00:00'),
	(8, 'Управление доступом. Очистка фильтра', '', 'filter_clear', 'button', 'type_link=loadcontent\r\ntable_list=1\r\ncontroller=sysusers\r\nimageiconmenu=/admin/img/icons/menu/icon_nofilter.png\r\naction=filter_clear\r\ntitle=Снять фильтры\r\nrating=3\r\nparams=replaceme', '0000-00-00 00:00:00'),
	(9, 'Удалить запись', '', 'del_link', 'button', 'type_link=loadcontent\r\ncontroller=sysusers\r\naction=delete\r\nimageiconmenu=/admin/img/icons/menu/icon_delete.png\r\nconfirm=Действительно удалить запись?\r\ntitle=Удалить запись\r\nprint_info=1\r\nrating=1\r\nparams=replaceme,index', '0000-00-00 00:00:00'),
	(10, 'Список пользователей', '', 'list_link', 'button', 'type_link=loadcontent\r\nadd_info=1\r\ncontroller=sysusers\r\nimageiconmenu=/admin/img/icons/menu/button.list.png\r\naction=enter\r\ntitle=Список пользователей\r\nrating=1\r\nparams=replaceme', '0000-00-00 00:00:00'),
	(11, 'Редактировать запись', '', 'edit_link', 'button', 'type_link=loadcontent\r\nprint_info=1\r\ncontroller=sysusers\r\nimageiconmenu=/admin/img/icons/menu/icon_edit.png\r\naction=edit\r\ntitle=Редактировать запись\r\nrating=2\r\nparams=replaceme,index', '0000-00-00 00:00:00'),
	(14, 'Закончить редактирование', '', 'end_link', 'button', 'type_link=loadcontent\r\nedit_info=1\r\ncontroller=sysusers\r\nimageiconmenu=/admin/img/icons/menu/icon_ok.png\r\naction=info\r\ntitle=Закончить редактирование\r\nrating=10\r\nparams=replaceme,index', '0000-00-00 00:00:00'),
	(15, 'Добавить запись', '', 'add_link', 'button', 'type_link=openpage\nposition=center\nid=newentry\r\ntable_list=1\r\ncontroller=sysusers\r\nimageiconmenu=/admin/img/icons/menu/icon_add.png\r\naction=add\r\ntitle=Добавить запись\r\nrating=1\r\nparams=replaceme', '0000-00-00 00:00:00'),
	(19, 'Заблокирован до', '', 'btime', 'lkey', 'type=datetime\r\nrating=21', '2010-03-10 20:25:26'),
	(20, 'Количество попыток авторизации', '', 'count', 'lkey', 'type=d\r\nrating=22', '2010-03-10 20:25:26'),
	(21, 'Настройки', '', 'settings', 'lkey', 'type=code\r\ntemplate_w=field_settings_read\r\nrating=30\r\nfilter=1\r\nshablon_r=field_settings_read\r\n', '2010-03-10 20:25:26'),
	(22, 'Последний заход с IP', '', 'ip', 'lkey', 'type=s\r\ntemplate_w=field_input_read\r\nrating=22', '2010-03-10 20:25:26'),
	(23, 'Заблокирован IP', '', 'bip', 'lkey', 'type=s\r\ntemplate_w=field_input_read\r\nrating=23', '2010-03-10 20:25:26'),
	(29, 'Доступно для пользователей', '', 'users_list', 'lkey', 'type=tlist\r\nlist=sys_users\r\ngroup=1\r\nrating=128\r\nmult=5\r\nshablon_w=field_multselect\r\nnotnull=1', '2010-03-11 11:34:30'),
	(30, 'Учетные записи', '', 'users', 'menu', 'type_link=loadcontent\r\naction=enter\r\nprogram=/cgi-bin/users_a.cgi\r\nrating=23\r\nparentid=setting\r\nreplaceme=replaceme\r\nsubmenuwidth=200', '0000-00-00 00:00:00'),
	(31, 'Добавить пользователя', '', 'users_add', 'menu', 'type_link=loadcontent\r\naction=add\r\nprogram=/cgi-bin/users_a.cgi\r\nrating=123\r\nparentid=users\r\nreplaceme=replaceme', '0000-00-00 00:00:00'),
	(34, 'Супер пользователь', '', 'sys', 'lkey', 'type=chb\r\ngroup=1\r\nrating=130\r\nyes=Супер пользователь\r\nno=Пользователь', '2010-03-10 20:25:26'),
	(35, 'Доступно для групп', '', 'groups_list', 'lkey', 'type=tlist\r\nlist=lst_group_user\r\ngroup=1\r\nrating=129\r\ndefault=6\r\nshablon_w=field_multselect\r\nnotnull=1', '0000-00-00 00:00:00'),
	(37, 'Права доступа', '', 'access', 'lkey', 'type=code\r\nsys=1\r\n', '0000-00-00 00:00:00'),
	(38, 'Visual Front-end Editor', '', 'vfe', 'lkey', 'type=chb\r\ngroup=1\r\nrating=131\r\nyes=Включен\r\nno=Выключен', '0000-00-00 00:00:00'),
	(39, 'Копировать запись', '', 'copy', 'button', 'type_link=loadcontent\nprint_info=1\nedit_info=1\ncontroller=sysusers\naction=copy\nloading_msg=1\nimageiconmenu=/admin/img/icons/menu/icon_copy.png\ntitle=Копировать запись\nrating=5\nparams=replaceme,index,list_table', '0000-00-00 00:00:00');
/*!40000 ALTER TABLE `keys_sysusers` ENABLE KEYS */;


-- Дамп структуры для таблица dev_fabprint.keys_templates
CREATE TABLE IF NOT EXISTS `keys_templates` (
  `ID` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL DEFAULT '',
  `tbl` varchar(64) NOT NULL DEFAULT '',
  `lkey` varchar(64) NOT NULL DEFAULT '',
  `object` varchar(8) NOT NULL DEFAULT '',
  `settings` text NOT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `tbl` (`tbl`,`lkey`,`object`)
) ENGINE=MyISAM AUTO_INCREMENT=33 DEFAULT CHARSET=utf8 COMMENT='Ключи к модулю Шаблоны';

-- Дамп данных таблицы dev_fabprint.keys_templates: 9 rows
/*!40000 ALTER TABLE `keys_templates` DISABLE KEYS */;
INSERT INTO `keys_templates` (`ID`, `name`, `tbl`, `lkey`, `object`, `settings`, `updated_at`) VALUES
	(2, 'Название', '', 'name', 'lkey', 'type=s\r\nrating=1\r\nfilter=1\r\ntable_list=1\r\nhelp=Название шаблона\r\nrequired=1\r\ntemplate_w=field_input_read\r\nqview=1\r\nqedit=1\r\n', '2010-10-28 17:55:00'),
	(30, 'Дата редактирования', '', 'modifytime', 'lkey', 'type=s\r\nrating=3\r\nhelp=Дата редактирования файла\r\nrequired=1\r\ntemplate_w=field_input_read\r\n\r\n\r\n', '2011-10-20 02:37:05'),
	(31, 'Путь к шаблону', '', 'dir', 'lkey', 'type=s\r\nrating=2\r\nhelp=Путь к файлу\r\nrequired=1\r\ntemplate_w=field_input_read\r\nqview=1\r\nqedit=1\r\n', '2011-10-20 02:43:12'),
	(6, 'Дата редактирования', '', 'edate', 'lkey', 'type=time\ntable_list=5\ngroup=1\nrating=7\nsys=1\nqview=1', '0000-00-00 00:00:00'),
	(8, 'Таблицы шаблонов', '', 'list_shablon_table', 'list', 'list=0|-----', '0000-00-00 00:00:00'),
	(12, 'Удалить запись', '', 'del_link', 'button', 'type_link=loadcontent\r\ncontroller=templates\r\naction=delete\r\nimageiconmenu=/admin/img/icons/menu/icon_delete.png\r\nconfirm=Действительно удалить запись?\r\ntitle=Удалить шаблон\r\nrating=3\r\nparams=shablon_table,replaceme,index\r\nprint_info=1', '0000-00-00 00:00:00'),
	(20, 'Закончить редактирование', '', 'end_link', 'button', 'type_link=loadcontent\r\n#edit_info=1\r\ncontroller=templates\r\naction=mainpage\r\nimageiconmenu=/admin/img/icons/menu/icon_ok.png\r\ntitle=Закончить редактирование\r\nrating=1\r\nparams=dir,replaceme,index', '0000-00-00 00:00:00'),
	(21, 'Добавить шаблон', '', 'add_link', 'button', 'type_link=openPage\r\n#templates_list=1\r\ncontroller=templates\r\naction=add\r\ntitle=Добавить шаблон\r\nimageiconmenu=/admin/img/icons/menu/icon_add.png\r\nrating=1\r\nparams=replaceme,dir\r\n', '0000-00-00 00:00:00'),
	(32, 'Код', '', 'code', 'lkey', 'type=code\r\nrating=4\r\ntemplate_w=field_template\r\ntemplate_r=field_code_read\r\nfileview=1\r\ndirview=1\r\n', '2011-11-16 21:10:05');
/*!40000 ALTER TABLE `keys_templates` ENABLE KEYS */;


-- Дамп структуры для таблица dev_fabprint.keys_texts
CREATE TABLE IF NOT EXISTS `keys_texts` (
  `ID` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL DEFAULT '',
  `tbl` varchar(64) NOT NULL DEFAULT '',
  `lkey` varchar(64) NOT NULL DEFAULT '',
  `object` varchar(8) NOT NULL DEFAULT '',
  `settings` text NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `tbl` (`tbl`,`lkey`,`object`)
) ENGINE=MyISAM AUTO_INCREMENT=189 DEFAULT CHARSET=utf8 COMMENT='Ключи к модулю Тексты';

-- Дамп данных таблицы dev_fabprint.keys_texts: 55 rows
/*!40000 ALTER TABLE `keys_texts` DISABLE KEYS */;
INSERT INTO `keys_texts` (`ID`, `name`, `tbl`, `lkey`, `object`, `settings`, `updated_at`) VALUES
	(1, 'Добавить запись', '', 'add_link', 'button', 'type_link=openpage\nposition=center\nid=newentry\ntable_list=1\r\nprint_info_text=1\r\nprint_info=1\r\ntable_list_dir=1\r\ncontroller=texts\r\nimageiconmenu=/admin/img/icons/menu/icon_add.png\r\naction=add\r\ntitle=Добавить\r\nrating=1\r\nparams=replaceme', '0000-00-00 00:00:00'),
	(3, 'Удалить запись', '', 'del_link', 'button', 'type_link=loadcontent\r\nprint_info=1\r\nprint_info_text=1\r\ncontroller=texts\r\naction=delete\r\nconfirm=Действительно удалить запись?\r\ntitle=Удалить запись\r\nimageiconmenu=/admin/img/icons/menu/icon_delete.png\r\nrating=1\r\nparams=replaceme,index,list_table', '0000-00-00 00:00:00'),
	(4, 'Редактировать запись', '', 'edit_link', 'button', 'type_link=loadcontent\r\nprint_info=1\r\nprint_info_text=1\r\ncontroller=texts\r\nimageiconmenu=/admin/img/icons/menu/icon_edit.png\r\naction=edit\r\ntitle=Редактировать запись\r\nrating=2\r\nparams=replaceme,index,list_table', '0000-00-00 00:00:00'),
	(5, 'Закончить редактирование', '', 'end_link', 'button', 'type_link=loadcontent\r\nedit_info=1\r\ncontroller=texts\r\naction=info\r\nimageiconmenu=/admin/img/icons/menu/icon_ok.png\r\ntitle=Закончить редактирование\r\nrating=10\r\nparams=replaceme,index,list_table', '0000-00-00 00:00:00'),
	(7, 'Фильтр', '', 'filter', 'button', 'type_link=modullink\r\ntable_list=1\r\ntable_list_dir=1\r\ncontroller=texts\r\nimageiconmenu=/admin/img/icons/menu/icon_filter.png\r\naction=filter\r\ntitle=Фильтр\r\nwidth=690\r\nheight=510\r\nlevel=3\r\nrating=2\r\nparams=replaceme', '0000-00-00 00:00:00'),
	(8, 'Очистка фильтра', '', 'filter_clear', 'button', 'type_link=loadcontent\r\ntable_list=1\r\ntable_list_dir=1\r\ncontroller=texts\r\nimageiconmenu=/admin/img/icons/menu/icon_nofilter.png\r\naction=filter_clear\r\ntitle=Снять фильтры\r\nrating=3\r\nparams=replaceme', '0000-00-00 00:00:00'),
	(9, 'Список', '', 'list_link', 'button', 'type_link=loadcontent\r\nadd_info=1\r\ncontroller=texts\r\nimageiconmenu=/admin/img/icons/menu/button.list.png\r\naction=enter\r\ntitle=Список\r\nrating=1\r\nparams=replaceme', '0000-00-00 00:00:00'),
	(11, 'Алиас', '', 'alias', 'lkey', 'type=s\r\nrating=5\r\ntable_list=2\r\ngroup=1\r\nfilter=1\r\nqview=1\r\nqedit=1\r\nrequired=1\r\nhelp=Короткое латинское название, которое учавствует в формирование URL для данной страницы', '2010-10-29 12:23:39'),
	(12, 'Текст', '', 'text', 'lkey', 'type=html\r\ngroup=2\r\nrating=1\r\nfileview=1', '2010-10-29 15:22:54'),
	(13, 'Название', '', 'name', 'lkey', 'type=s\r\nfilter=1\r\ngroup=1\r\nrating=1\r\nrequired=1\r\nqedit=1\r\nqview=1\r\ntable_list=1\r\nno_format=1\r\ndirview=1\r\nfileview=1\r\nhelp=Название страницы. Используется при генерации меню, автоматических ссылок, заголовков h1', '2010-10-29 12:23:39'),
	(14, 'Раздел', '', 'razdel', 'lkey', 'type=tlist\r\nlist=lst_texts\nlist_sort=asc_d\r\nwhere= AND `<%= $self->sysuser->settings->{lang} %>`=\'1\' \r\nnotnull=1', '2010-10-29 15:22:54'),
	(15, 'Заголовок окна', '', 'title', 'lkey', 'type=s\nno_format=1\nrating=2\ngroup=1\nqview=1\nqedit=1\nhelp=Заголовок окна браузера. Может отличаться от названия текста. Используется для оптимизации под поисковые системы.\ndirview=1\nfileview=1', '2010-10-29 12:23:39'),
	(16, 'Ключевые слова', '', 'keywords', 'lkey', 'type=s\nrating=3\ngroup=1\nfilter=1\nqedit=1\nhelp=Ключевые слова и выражения, разделенные запятой, которые соответствуют данному тексту. Используется для оптимизации страницы под поисковые системы. Указанные слова в данном поле должны обязательно присутствовать в тексте — в противном случае они не будут учитываться поисковыми машинами.\ndirview=1\nfileview=1', '2010-10-29 12:23:39'),
	(17, 'Краткое описание страницы', '', 'description', 'lkey', 'type=text\r\nrating=3\r\ngroup=1\r\nqview=1\r\nhelp=Краткое описание текста. Используется для поисковых систем. Выводится на странице в meta-теге description. Как правило, пользователь данный текст не видет. Для поисковых систем полезнее для каждой страницы формировать свое описание, наиболее соответствующее данной странице.\r\ndirview=1\r\nfileview=1', '2010-10-29 12:23:39'),
	(18, 'Рейтинг', '', 'rating', 'lkey', 'type=d\r\ngroup=1\r\nqview=1\r\nqedit=1\r\ntable_list=4\r\ntable_list_name=Rt\r\ntable_list_width=32\r\nrating=6\r\ntemplate_w=field_rating\r\nhelp=Рейтинг служит для выстраивания текстов друг относительно друга. Чем меньше значение, тем выше текст в иерархии', '2010-10-29 12:23:39'),
	(19, 'Включать в меню', '', 'menu', 'lkey', 'type=chb\r\nrating=10\r\ngroup=1\r\nqedit=1\r\nfilter=1\r\ntable_list=7\r\ntable_list_name=Меню\r\ntable_list_width=64\r\nyes=да\r\nno=нет\r\nhelp=При установке флажка данный текст будет участвовать в формировании меню основного сайта.', '2010-10-29 12:23:39'),
	(21, 'Публикация', '', 'viewtext', 'lkey', 'type=chb\r\nrating=99\r\ngroup=1\r\nqview=1\r\ntable_list=10\r\ntable_list_name=-\r\ntable_list_width=48\r\nyes=Виден\nno=Скрыт\r\nfilter=1\r\ndirview=1\r\nqedit=1\r\nfileview=1\r\nhelp=Публиковать страницу на сайте', '2010-10-29 12:23:39'),
	(186, 'Редактировать текст', '', 'edit_link_text', 'button', 'type_link=loadcontent\r\nprint_info_text=1\r\ncontroller=texts\r\nimageiconmenu=/admin/img/icons/menu/button.text.gif\r\naction=edit&group=2\r\ntitle=Редактировать текст\r\nrating=3\r\nparams=replaceme,index,list_table', '0000-00-00 00:00:00'),
	(22, 'Неудаляем', '', 'delnot', 'lkey', 'type=chb\nrating=12\ngroup=1\ntable_list=4\ntable_list_name=-\ntable_list_nosort=1\ntable_list_width=16\nyes=<img src="/admin/img/icons/ico_lock.gif">\nno=<img src="/admin/img/icons/ico_unlock.gif">\ndirview=1\nfileview=1\nhelp=Данная опция защищает текст от случайного удаления.', '2010-10-29 12:23:39'),
	(23, 'URL-ссылка на страницу в Internet', '', 'link', 'lkey', 'type=s\r\ngroup=1\r\nrating=4\r\nhelp=Используется при построении основного меню. Происходит подмена алиаса на указанную в данном поле ссылку. ', '2010-10-29 12:23:39'),
	(24, 'Шаблон страницы', '', 'layout', 'lkey', 'type=s\r\ntemplate_w=field_layout\r\ngroup=1\r\nrating=20\r\nhelp=Если для страницы требуется установить какой-то особенный шаблон, то выберите его из выпадающего списка. По умолчанию используется шаблон default', '2010-10-29 12:23:39'),
	(25, 'Модуль', '', 'url_for', 'lkey', 'type=code\r\ntemplate_w=field_url_for\r\ngroup=1\r\nrating=21\r\nhelp=Выберите модуль, который будет показан на данной странице\r\n#help=XML-директива, которая будет выполняться при загрузке страницы и выводить результаты выполнения в контентной области, вместо вывода текста. Открывающая и закрывающая угловые скобки в данном поле опускаются. Вводится только код.', '2010-10-29 12:23:39'),
	(185, 'Текст', 'texts_floating_ru', 'text', 'lkey', 'type=html\r\ngroup=1\r\nrating=90\r\nfileview=1\r\ncktoolbar=Basic\r\n', '0000-00-00 00:00:00'),
	(27, 'Верхний уровень', '', 'texts_main_ru', 'lkey', 'type=tlist\r\nlist=texts_main_ru\r\nsort=1\r\nrating=7\r\ntemplate_w=field_select_dir\r\ntemplate_f=field_select_dir_filter\r\ngroup=1\r\nfilter=1\r\nhelp=Для построения вложенных меню выберите текст верхнего уровня из иерархического дерева текстов раздела. Для того, чтобы вернуть текст в главный уровень выберите самый главный уровень дерева texts_main_ru.\r\n', '2010-10-29 12:23:39'),
	(29, 'Группа', '', 'texts_news', 'lkey', 'type=tlist\nlist=texts_news_ru\ntable_list=5\nsort=1\nrating=7\ngroup=1\nfilter=1\nwhere=AND `texts_news`=0 AND `dir` = 1\nhelp=Тематическая группа, к которой принадлежит данная новость. Выберите из списка.\nfileview=1\n', '2010-08-21 19:28:46'),
	(31, 'Включать в RSS', '', 'rss', 'lkey', 'type=chb\nrating=12\ngroup=1\nyes=включать в RSS\nno=не включать в RSS\nfileview=1', '2008-10-23 12:58:40'),
	(32, 'Папка', '', 'dir', 'lkey', 'type=chb\ngroup=1\nrating=6\ntable_list=7\ntable_list_name=-\ntable_list_nosort=1\ntable_list_width=16\nyes=<img src="/admin/img/dtree/folder.gif">\nno=<img src="/admin/img/dtree/doc.gif">\nfilter=1\nhelp=Если установить данный флажок, то данная запись будет считаться папкой\ntemplate_w=field_checkbox_read\n', '2010-08-28 19:20:08'),
	(33, 'Рейтинг', 'texts_news_ru', 'rating', 'lkey', 'type=d\r\ngroup=1\r\nrating=16\r\nnoview=1\r\ndirview=1\r\ntemplate_w=field_rating\r\n', '0000-00-00 00:00:00'),
	(34, 'Картинка', '', 'pict', 'lkey', 'type=pict\r\nrating=14\r\ntemplate_w=field_pict\r\ntemplate_r=field_pict_read\r\nsizelimit=20000\r\next=*.jpg;*.jpeg;*.tif\r\nmini=209x161~montage\r\nfolder=/image/texts/\r\nfileview=1\r\ntable_list=7\r\ntable_list_type=pict\r\ntable_list_name=-\r\nhelp=Картинка для анонса новости', '2010-10-27 16:23:52'),
	(35, 'Файл', '', 'filename', 'lkey', 'type=filename\nrating=2\nsizelimit=20000\nfile_ext=*.*', '2010-10-29 12:20:44'),
	(36, 'Флаг удаления картинки', '', 'deletepict', 'lkey', 'type=chb\nsys=1', '2008-10-30 17:42:45'),
	(37, 'Фото галерея', '', 'image_gallery', 'lkey', 'type=tlist\nlist=images_gallery\nrating=15\ngroup=1\nwhere=AND `dir`=1\nshablon_w=field_select_input\nfileview=1\n', '2010-08-21 19:28:46'),
	(38, 'Новости', '', 'id_news', 'lkey', 'type=tlist\nlist=texts_news_ru\nrating=17\ngroup=1\nwhere=AND `dir` = 0\nshablon_w=field_multselect_input\nfileview=1\nnotnull=1', '2010-08-28 19:20:08'),
	(40, 'Дата', '', 'tdate', 'lkey', 'type=date\r\nrating=10\r\ngroup=1\r\nqview=1\r\nfilter=1\r\nfileview=1\r\ntable_list=8\r\ntable_list_width=70\r\ntemplate_f=field_date_filter\nhelp=Укажите какой датой датировать эту запись\n', '2010-10-27 11:04:12'),
	(44, 'Тексты. Добавить папку', '', 'add_link_dir', 'button', 'type_link=loadcontent\r\ntable_list_dir=1\r\ncontroller=texts\r\nimageiconmenu=/admin/img/icons/menu/icon_dir_add.png\r\naction=add_dir\r\ntitle=Создать папку\r\nparams=replaceme\r\nrating=1', '0000-00-00 00:00:00'),
	(45, 'Флаг скрыть', '', 'hide', 'lkey', 'type=s\nsys=1', '2010-10-28 15:33:25'),
	(46, 'Флаг показать', '', 'show', 'lkey', 'type=s\nsys=1', '2010-10-28 15:33:36'),
	(59, 'Год', '', 'year', 'lkey', 'type=d', '2010-05-07 13:59:22'),
	(60, 'Месяц', '', 'month', 'lkey', 'type=d', '2010-05-07 13:59:22'),
	(61, 'День', '', 'day', 'lkey', 'type=d', '2010-05-07 13:59:22'),
	(86, 'Тексты', '', 'texts', 'menu', 'type_link=loadcontent\naction=enter\nprogram=/cgi-bin/text_a.cgi\nrating=11\nparentid=edit\nreplaceme=replaceme\nsubmenuwidth=200\n', '0000-00-00 00:00:00'),
	(66, 'Группа', '', 'texts_articles', 'lkey', 'type=tlist\r\nlist=texts_articles_ru\r\nsort=1\r\nrating=7\r\ngroup=1\r\nfilter=1\r\nwhere=AND `dir`=1\r\nhelp=Тематическая группа, к которой принадлежит данная статья. Выберите из списка.\r\nfileview=1\r\n', '2010-07-06 16:01:54'),
	(67, 'Автор', '', 'author', 'lkey', 'type=s\r\nfilter=1\r\ngroup=1\r\nrating=25\r\nno_format=1\r\nhelp=Введите автора или ссылку на первоисточник', '2010-07-12 14:12:49'),
	(83, 'Документ', '', 'docfile', 'lkey', 'type=file\r\nrating=14\r\ntemplate_w=field_file\r\ntemplate_r=field_file_read\r\nsizelimit=20000\r\next=*.*\r\nfolder=/docfiles/\r\nfileview=1\r\ntable_list=2\r\nhelp=Название документа\r\n', '2010-10-25 15:11:09'),
	(84, 'Размер файла', '', 'docfile_size', 'lkey', 'type=filesize\ntemplate_w=field_input_read\ntable_list=5\ntable_list_name=Размер\ntable_list_width=70\n\n', '2009-03-24 17:50:05'),
	(78, 'Дата', '', 'adate', 'lkey', 'type=date\r\nrating=10\r\ngroup=1\r\nfilter=1\r\nfileview=1\nhelp=Укажите какой датой датировать эту запись\r\n', '2010-07-06 16:01:54'),
	(82, 'Тип файла', '', 'type_file', 'lkey', 'type=s\nshablon_w=field_input_read\nhelp=Тип файла картинки анонса\n', '2009-05-26 16:21:19'),
	(88, 'Флаг отсылки', '', 'send', 'lkey', 'type=d\r\nsys=1', '0000-00-00 00:00:00'),
	(127, 'Анонс', '', 'anons', 'lkey', 'type=html\r\nrating=5\r\ngroup=1\r\nprint=1\r\nshablon_w=field_text\r\n', '2009-12-18 15:37:15'),
	(157, 'Группа товаров или услуг', '', 'texts_docfiles', 'lkey', 'type=tlist\r\nlist=texts_docfiles_ru\r\nsort=1\r\nrating=10\r\ngroup=1\r\nfilter=1\r\nwhere= AND `texts_docfiles`>0\r\nhelp=Выбирите группу товаров или услуг к которой относится данный документ ( предварительно необходимо выбрать подрубрику, после чего будет подгружен список )\r\nfileview=1\r\n', '2010-01-15 14:38:53'),
	(169, 'Директория с файлами документов', '', 'docfolder', 'lkey', 'type=s\r\nsys=1', '0000-00-00 00:00:00'),
	(182, 'Цена', '', 'price', 'lkey', 'type=d\r\nprint=1\r\nqview=1\r\nqedit=1\r\ntable_list=4\r\ntable_list_width=70\r\nfileview=1\r\nrating=5\r\n', '0000-00-00 00:00:00'),
	(184, 'Звездность', '', 'stars', 'lkey', 'type=list\r\nlist=1|1~2|2~3|3~4|4~5|5\r\nlist_type=radio\r\nfilter=1\r\ntable_list=6\r\ntable_list_width=70\r\nrating=10\r\nfileview=1\r\nqedit=1\r\nnotnull=1\r\n\r\n', '0000-00-00 00:00:00'),
	(187, 'Заголовок h1', '', 'h1', 'lkey', 'type=s\r\ngroup=1\r\nrating=2\r\nqedit=1\r\nqview=1\r\ntable_list=3\ntable_list_width=200\nno_format=1\r\nfileview=1\r\nhelp=Заголовок страницы h1. Если он не заполнен, то используется заголовок из названия страницы', '2010-10-29 12:23:39'),
	(188, 'Копировать запись', '', 'copy', 'button', 'type_link=loadcontent\nprint_info=1\nedit_info=1\ncontroller=texts\naction=copy\nloading_msg=1\nimageiconmenu=/admin/img/icons/menu/icon_copy.png\ntitle=Копировать запись\nrating=5\nparams=replaceme,index,list_table', '0000-00-00 00:00:00');
/*!40000 ALTER TABLE `keys_texts` ENABLE KEYS */;


-- Дамп структуры для таблица dev_fabprint.keys_users
CREATE TABLE IF NOT EXISTS `keys_users` (
  `ID` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL DEFAULT '',
  `tbl` varchar(64) NOT NULL DEFAULT '',
  `lkey` varchar(64) NOT NULL DEFAULT '',
  `object` varchar(8) NOT NULL DEFAULT '',
  `settings` text NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `tbl` (`tbl`,`lkey`,`object`)
) ENGINE=MyISAM AUTO_INCREMENT=65 DEFAULT CHARSET=utf8 COMMENT='Ключи к модулю Тексты';

-- Дамп данных таблицы dev_fabprint.keys_users: 24 rows
/*!40000 ALTER TABLE `keys_users` DISABLE KEYS */;
INSERT INTO `keys_users` (`ID`, `name`, `tbl`, `lkey`, `object`, `settings`, `updated_at`) VALUES
	(1, 'Добавить запись', '', 'add_link', 'button', 'type_link=openpage\nposition=center\nid=newentry\r\ntable_list=1\r\nprint_info=1\r\ncontroller=users\r\naction=add\r\nimageiconmenu=/admin/img/icons/menu/icon_add.png\r\ntitle=Добавить\r\nrating=1\r\nparams=replaceme,list_table', '0000-00-00 00:00:00'),
	(2, 'Удалить запись', '', 'del_link', 'button', 'type_link=loadcontent\r\ncontroller=users\r\naction=delete\r\nconfirm=Действительно удалить запись?\r\ntitle=Удалить запись\r\nimageiconmenu=/admin/img/icons/menu/icon_delete.png\r\nprint_info=1\r\nrating=1\r\nparams=replaceme,index,list_table', '0000-00-00 00:00:00'),
	(3, 'Редактировать запись', '', 'edit_link', 'button', 'type_link=loadcontent\r\nprint_info=1\r\ncontroller=users\r\naction=edit\r\nimageiconmenu=/admin/img/icons/menu/icon_edit.png\r\ntitle=Редактировать запись\r\nrating=2\r\nparams=replaceme,index,list_table', '0000-00-00 00:00:00'),
	(4, 'Закончить редактирование', '', 'end_link', 'button', 'type_link=loadcontent\r\nedit_info=1\r\ncontroller=users\r\naction=info\r\nimageiconmenu=/admin/img/icons/menu/icon_ok.png\r\ntitle=Закончить редактирование\r\nrating=10\r\nparams=replaceme,index,list_table\r\n', '0000-00-00 00:00:00'),
	(5, 'Фильтр', '', 'filter', 'button', 'type_link=modullink\r\ntable_list=1\r\ntable_list_orders=1\r\ncontroller=users\r\naction=filter\r\nimageiconmenu=/admin/img/icons/menu/icon_filter.png\r\ntitle=Фильтр\r\nwidth=690\r\nheight=510\r\nlevel=3\r\nrating=2\r\nparams=replaceme,list_table', '0000-00-00 00:00:00'),
	(6, 'Очистка фильтра', '', 'filter_clear', 'button', 'type_link=loadcontent\r\ntable_list=1\r\ntable_list_orders=1\r\ntable_list_dir=1\r\ncontroller=users\r\naction=filter_clear\r\nimageiconmenu=/admin/img/icons/menu/icon_nofilter.png\r\ntitle=Снять фильтры\r\nrating=3\r\nparams=replaceme,list_table', '0000-00-00 00:00:00'),
	(7, 'Фамилия', '', 'name', 'lkey', 'type=s\r\nfilter=1\r\ngroup=1\r\nrating=1\r\nrequired=1\r\nqedit=1\r\ntable_list=1\r\nno_format=1\r\nfileview=1\r\nregister=1\r\nobligatory=1\r\n', '2010-10-31 11:29:29'),
	(52, 'Состояние учетной записи', '', 'active', 'lkey', 'type=chb\r\nprint=1\r\nqview=1\r\nqedit=1\r\nfilter=1\r\ntable_list=8\r\ntable_list_width=70\r\nyes=Активна\r\nno=Заблокирована\r\n', '0000-00-00 00:00:00'),
	(53, 'Ключ сессии', '', 'cck', 'lkey', 'type=s\r\nsys=1', '0000-00-00 00:00:00'),
	(41, 'Картинка', '', 'pict', 'lkey', 'type=pict\r\nrating=14\r\ntemplate_w=field_pict\r\ntemplate_r=field_pict_read\r\nsizelimit=20000\r\next=*.jpg;*.jpeg;*.gif;\r\nmini=117x77~montage,574x289~montage\r\nfolder=/image/catalog/\r\nfileview=1\r\ntable_list=4\r\ntable_list_type=pict\r\ntable_list_name=-\r\n', '0000-00-00 00:00:00'),
	(49, 'Адрес', '', 'addr', 'lkey', 'type=s\r\nprint=1\r\nqview=1\r\nqedit=1\r\nrating=11\r\n\r\n', '0000-00-00 00:00:00'),
	(50, 'Телефон', '', 'phone', 'lkey', 'type=s\r\nprint=1\r\nqview=1\r\nqedit=1\r\nrating=13\r\ntable_list=4\r\ntable_list_width=100\r\nregister=1\r\n', '0000-00-00 00:00:00'),
	(51, 'Настройки', '', 'data', 'lkey', 'type=code\r\nsys=1\r\n', '0000-00-00 00:00:00'),
	(39, 'Рейтинг', '', 'rating', 'lkey', 'type=d\r\ngroup=1\r\nqview=1\r\nqedit=1\r\ntable_list=4\r\ntable_list_name=Rt\r\ntable_list_width=32\r\nrating=6\r\nshablon_w=field_rating\r\n', '0000-00-00 00:00:00'),
	(16, 'Действие', '', 'do', 'lkey', 'type=s\r\nsys=1\r\n', '0000-00-00 00:00:00'),
	(54, 'Дата последней авторизации', '', 'vdate', 'lkey', 'type=time\r\nprint=1\r\ntable_list=9\r\ntable_list_width=100\r\nshablon_w=field_input_read\r\n', '0000-00-00 00:00:00'),
	(55, 'Пароль', '', 'password', 'lkey', 'type=s\r\nprint=1\r\nrating=10\r\nregister=1\r\nobligatory=1\r\n\r\n', '0000-00-00 00:00:00'),
	(56, 'E-mail', '', 'email', 'lkey', 'type=email\r\nprint=1\r\nqview=1\r\nrating=15\r\ntable_list=6\r\ntable_list_width=100\r\nregister=1\r\nobligatory=1\r\n', '0000-00-00 00:00:00'),
	(58, 'Компания', '', 'company', 'lkey', 'type=s\r\nprint=1\r\nqview=1\r\nqedit=1\r\nrating=16\r\nfileview=1\r\n', '0000-00-00 00:00:00'),
	(60, 'Менеджер', '', 'id_manager', 'lkey', 'type=tlist\r\nlist=data_projects_managers\r\nprint=1\r\nqview=1\r\nqedit=1\r\nfileview=1\r\ntable_list=5\r\ntable_list_width=150\r\nrating=20\r\nfilter=1\r\n', '0000-00-00 00:00:00'),
	(61, 'Должность', '', 'post', 'lkey', 'type=s\r\nprint=1\r\nqview=1\r\nqedit=1\r\nrating=15\r\nfileview=1\r\n', '0000-00-00 00:00:00'),
	(62, 'Имя', '', 'fname', 'lkey', 'type=s\r\nprint=1\r\nqview=1\r\nqedit=1\r\nrating=3\r\nfileview=1\r\ntable_list=3\r\ntable_list_width=100\r\n\r\n', '0000-00-00 00:00:00'),
	(63, 'Отчество', '', 'mname', 'lkey', 'type=s\r\nprint=1\r\nqview=1\r\nqedit=1\r\nrating=4\r\nfileview=1\r\ntable_list=4\r\ntable_list_width=100\r\n\r\n', '0000-00-00 00:00:00'),
	(64, 'Копировать запись', '', 'copy', 'button', 'type_link=loadcontent\nprint_info=1\nedit_info=1\ncontroller=users\naction=copy\nloading_msg=1\nimageiconmenu=/admin/img/icons/menu/icon_copy.png\ntitle=Копировать запись\nrating=5\nparams=replaceme,index,list_table', '0000-00-00 00:00:00');
/*!40000 ALTER TABLE `keys_users` ENABLE KEYS */;


-- Дамп структуры для таблица dev_fabprint.keys_vars
CREATE TABLE IF NOT EXISTS `keys_vars` (
  `ID` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL DEFAULT '',
  `tbl` varchar(64) NOT NULL DEFAULT '',
  `lkey` varchar(64) NOT NULL DEFAULT '',
  `object` varchar(8) NOT NULL DEFAULT '',
  `settings` text NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `tbl` (`tbl`,`lkey`,`object`)
) ENGINE=MyISAM AUTO_INCREMENT=29 DEFAULT CHARSET=utf8 COMMENT='Ключи к модулю Vars';

-- Дамп данных таблицы dev_fabprint.keys_vars: 17 rows
/*!40000 ALTER TABLE `keys_vars` DISABLE KEYS */;
INSERT INTO `keys_vars` (`ID`, `name`, `tbl`, `lkey`, `object`, `settings`, `updated_at`) VALUES
	(3, 'Список переменных', '', 'list_link', 'button', 'type_link=loadcontent\r\nadd_info=1\r\ncontroller=vars\r\nimageiconmenu=/admin/img/icons/menu/button.list.png\r\naction=enter\r\ntitle=Список переменных\r\nrating=1\r\nparams=replaceme', '0000-00-00 00:00:00'),
	(4, 'Глобальные переменные. Очистка фильтра', '', 'filter_clear', 'button', 'type_link=loadcontent\r\ntable_list=1\r\ncontroller=vars\r\naction=filter_clear\r\nimageiconmenu=/admin/img/icons/menu/icon_nofilter.png\r\ntitle=Снять фильтры\r\nrating=3\r\nparams=replaceme', '0000-00-00 00:00:00'),
	(5, 'Глобальные переменные. Фильтр', '', 'filter', 'button', 'type_link=modullink\r\ntable_list=1\r\ncontroller=vars\r\naction=filter\r\nimageiconmenu=/admin/img/icons/menu/icon_filter.png\r\ntitle=Настроить фильтр\r\nwidth=690\r\nheight=510\r\nlevel=3\r\nrating=2\r\nparams=replaceme', '0000-00-00 00:00:00'),
	(6, 'Закончить редактирование', '', 'end_link', 'button', 'type_link=loadcontent\r\nedit_info=1\r\ncontroller=vars\r\nimageiconmenu=/admin/img/icons/menu/icon_ok.png\r\naction=info\r\ntitle=Закончить редактирование\r\nrating=10\r\nparams=replaceme,index', '0000-00-00 00:00:00'),
	(7, 'Редактировать запись', '', 'edit_link', 'button', 'type_link=loadcontent\r\nprint_info=1\r\ncontroller=vars\r\naction=edit\r\nimageiconmenu=/admin/img/icons/menu/icon_edit.png\r\ntitle=Редактировать запись\r\nrating=2\r\nparams=replaceme,index', '0000-00-00 00:00:00'),
	(8, 'Удалить запись', '', 'del_link', 'button', 'type_link=loadcontent\r\ncontroller=vars\r\naction=delete\r\nimageiconmenu=/admin/img/icons/menu/icon_delete.png\r\nconfirm=Действительно удалить запись?\r\ntitle=Удалить запись\r\nprint_info=1\r\nrating=1\r\nparams=replaceme,index', '0000-00-00 00:00:00'),
	(10, 'Добавить запись', '', 'add_link', 'button', 'type_link=openpage\nposition=center\nid=newentry\r\ntable_list=1\r\ncontroller=vars\r\nimageiconmenu=/admin/img/icons/menu/icon_add.png\r\naction=add\r\ntitle=Добавить запись\r\nrating=1\r\nparams=replaceme', '0000-00-00 00:00:00'),
	(11, 'Название', '', 'name', 'lkey', 'type=s\nrating=1\ntable_list=1\nrequired=1\nqedit=1\nqview=1\nhelp=Название переменной для удобства поиска', '2010-10-27 17:54:27'),
	(12, 'Программа (модуль)', '', 'id_program', 'lkey', 'type=tlist\nlist=sys_program\nrating=2\ntable_list=2\nqedit=1\nqview=1\nfilter=1\nhelp=Программный модуль, для которого действует данная переменная. Если программа не указана, то переменная является глобальной', '2010-10-27 17:54:27'),
	(13, 'Ключ переменной', '', 'envkey', 'lkey', 'type=s\nrating=3\ntable_list=3\nrequired=1\nqedit=1\nqview=1\nhelp=Ключ переменной, по которому можно вызвать данную переменную в шаблоне или программе.', '2010-10-27 17:54:27'),
	(14, 'Значение', '', 'envvalue', 'lkey', 'type=code\r\nrating=5\r\nmax=99999\r\n', '2010-10-27 17:54:27'),
	(17, 'Комментарий', '', 'comment', 'lkey', 'type=code\r\nrating=10\r\n', '2010-10-27 17:54:27'),
	(18, 'Доступно для групп', '', 'groups_list', 'lkey', 'type=tlist\r\nlist=lst_group_user\r\ngroup=1\r\nrating=129\r\ndefault=6\r\nshablon_w=field_multselect\r\nnotnull=1\r\nhelp=Группы пользователей, которые могут изменять данную переменную', '2010-10-27 17:54:27'),
	(25, 'Глобальные переменные', '', 'vars', 'menu', 'type_link=loadcontent\r\naction=enter\r\nprogram=/cgi-bin/vars_a.cgi\r\nrating=22\r\nparentid=setting\r\nreplaceme=replaceme\r\nsubmenuwidth=200', '0000-00-00 00:00:00'),
	(26, 'Доступно для пользователей', '', 'users_list', 'lkey', 'type=tlist\r\nlist=sys_users\r\ngroup=1\r\nrating=128\r\nmult=5\r\nshablon_w=field_multselect\r\nnotnull=1\r\nhelp=Пользователи, которые могут изменять данную переменную', '0000-00-00 00:00:00'),
	(27, 'Параметры поля', '', 'settings', 'lkey', 'type=code\r\nrating=4\r\n\r\n', '0000-00-00 00:00:00'),
	(28, 'Копировать запись', '', 'copy', 'button', 'type_link=loadcontent\nprint_info=1\nedit_info=1\ncontroller=vars\naction=copy\nloading_msg=1\nimageiconmenu=/admin/img/icons/menu/icon_copy.png\ntitle=Копировать запись\nrating=5\nparams=replaceme,index,list_table', '0000-00-00 00:00:00');
/*!40000 ALTER TABLE `keys_vars` ENABLE KEYS */;


-- Дамп структуры для таблица dev_fabprint.keys_video
CREATE TABLE IF NOT EXISTS `keys_video` (
  `ID` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL DEFAULT '',
  `tbl` varchar(64) NOT NULL DEFAULT '',
  `lkey` varchar(64) NOT NULL DEFAULT '',
  `object` varchar(8) NOT NULL DEFAULT '',
  `settings` text NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `tbl` (`tbl`,`lkey`,`object`)
) ENGINE=MyISAM AUTO_INCREMENT=119 DEFAULT CHARSET=utf8 COMMENT='Ключи к модулю Видео';

-- Дамп данных таблицы dev_fabprint.keys_video: 32 rows
/*!40000 ALTER TABLE `keys_video` DISABLE KEYS */;
INSERT INTO `keys_video` (`ID`, `name`, `tbl`, `lkey`, `object`, `settings`, `updated_at`) VALUES
	(1, 'Добавить запись', '', 'add_link', 'button', 'type_link=loadcontent\r\ntable_list=1\r\nprint_info=1\r\ntable_list_dir=1\r\nprogram=/cgi-bin/portfolio_a.cgi\r\nimageiconmenu=/admin/img/icons/menu/icon_add.png\r\naction=add\r\ntitle=Добавить\r\nrating=1\r\nparams=replaceme,list_table', '0000-00-00 00:00:00'),
	(2, 'Удалить запись', '', 'del_link', 'button', 'type_link=loadcontent\r\nprogram=/cgi-bin/portfolio_a.cgi\r\naction=delete\r\nconfirm=Действительно удалить запись?\r\ntitle=Удалить запись\r\nimageiconmenu=/admin/img/icons/menu/icon_delete.png\r\nprint_info=1\r\nrating=1\r\nparams=replaceme,index,list_table', '0000-00-00 00:00:00'),
	(3, 'Редактировать запись', '', 'edit_link', 'button', 'type_link=loadcontent\r\nprint_info=1\r\nprogram=/cgi-bin/portfolio_a.cgi\r\nimageiconmenu=/admin/img/icons/menu/icon_edit.png\r\naction=edit\r\ntitle=Редактировать запись\r\nrating=2\r\nparams=replaceme,index,list_table', '0000-00-00 00:00:00'),
	(4, 'Закончить редактирование', '', 'end_link', 'button', 'type_link=loadcontent\r\nedit_info=1\r\nprogram=/cgi-bin/portfolio_a.cgi\r\naction=info\r\nimageiconmenu=/admin/img/icons/menu/icon_ok.png\r\ntitle=Закончить редактирование\r\nrating=1\r\nparams=replaceme,index,list_table\r\n', '0000-00-00 00:00:00'),
	(5, 'Фильтр', '', 'filter', 'button', 'type_link=modullink\r\ntable_list=1\r\ntable_list_orders=1\r\ntable_list_dir=1\r\nprogram=/cgi-bin/portfolio_a.cgi\r\nimageiconmenu=/admin/img/icons/menu/icon_filter.png\r\naction=filter\r\ntitle=Фильтр\r\nwidth=690\r\nheight=510\r\nlevel=3\r\nrating=2\r\nparams=replaceme,list_table', '0000-00-00 00:00:00'),
	(6, 'Очистка фильтра', '', 'filter_clear', 'button', 'type_link=loadcontent\r\ntable_list=1\r\ntable_list_orders=1\r\ntable_list_dir=1\r\nprogram=/cgi-bin/portfolio_a.cgi\r\nimageiconmenu=/admin/img/icons/menu/icon_nofilter.png\r\naction=filter_clear\r\ntitle=Снять фильтры\r\nrating=3\r\nparams=replaceme,list_table', '0000-00-00 00:00:00'),
	(7, 'Наименование', '', 'name', 'lkey', 'type=s\nfilter=1\ngroup=1\nrating=1\nrequired=1\nqedit=1\ntable_list=1\nno_format=1\nfileview=1\ndirview=1', '2011-12-07 14:34:14'),
	(8, 'Артикул', '', 'articul', 'lkey', 'type=s\r\nfilter=1\r\nrating=3\r\nprint=1\r\nqview=1\r\nqedit=1\r\nfileview=1\r\ngroup=1\r\ntable_list=5\r\n\r\n', '2011-09-28 18:45:41'),
	(19, 'Показывать на сайте', '', 'active', 'lkey', 'type=chb\r\nrating=99\r\ngroup=1\r\ntable_list=12\r\ntable_list_name=-\r\ntable_list_width=48\r\nyes=виден\r\nno=скрыт\r\nfilter=1\r\ndirview=1\r\nfileview=1\r\nhelp=Если видео требуется временно скрыть, просто установите данный флажок.', '2011-12-07 14:34:14'),
	(97, 'Модель', 'data_catalog_items', 'name', 'lkey', 'type=s\r\nfilter=1\r\ngroup=1\r\nrating=1\r\nrequired=1\r\nqedit=1\r\ntable_list=1\r\nno_format=1\r\nfileview=1\r\n', '2011-10-24 16:41:25'),
	(21, 'Рейтинг', '', 'rating', 'lkey', 'type=d\nrating=90\nprint=1\nfileview=1\ngroup=1\ntable_list=7\nqedit=1\ntable_list_name=Rt\ntable_list_width=32\nshablon_w=field_rating\ndirview=1', '2011-12-07 14:34:14'),
	(22, 'Фото', '', 'pict', 'lkey', 'type=pict\nrating=24\ntable_list=10\ntable_list_name=-\ntable_list_type=pict\nfolder=/images/video/\ntable_list_nosort=1\nshablon_w=field_pict\nshablon_r=field_pict_read\nsizelimit=20000\nmini=547x294~crop,297x168~crop\next=*.jpg;*.jpeg;*.gif;*.tif\nfileview=1\nhelp=Загрузите изображение на сервер', '2014-05-20 19:38:52'),
	(23, 'Файл', '', 'filename', 'lkey', 'type=filename\r\nrating=3\r\nsizelimit=200000\r\nfile_ext=*.*\r\nhelp=Для загрузки файла нажмите на кнопку <b>Выбрать</b>', '2011-12-07 14:34:13'),
	(24, 'Тип файла', '', 'type_file', 'lkey', 'type=slat\r\nsys=1', '2011-04-08 01:12:56'),
	(109, 'Видео', '', 'videofile', 'lkey', 'type=filename\r\nrating=14\r\nshablon_w=field_file\r\nshablon_r=field_file_link\r\nsizelimit=20000\r\nfile_ext=*.*\r\nfileview=1\r\ntable_list=2\r\n', '2011-12-05 19:19:18'),
	(26, 'Фото', '', 'images', 'lkey', 'type=table\r\ntable=dtbl_images\r\ngroup=3\r\nrating=301\r\ntable_fields=type_file,name,folder,pict,rating,rdate\r\ntable_svf=id_data_catalog\r\ntable_sortfield=name\r\ntable_buttons_key_w=delete_select,edit\r\ntable_buttons_key_r=upload\r\ntable_groupname=Информация по файлу\r\ntable_upload=1\r\ntable_icontype=1\r\ntable_noindex=1\r\nshablon_w=field_table\r\nshablon_r=field_table', '2011-04-08 01:12:56'),
	(29, 'Описание', '', 'text', 'lkey', 'type=html\r\nrating=90\r\ngroup=1\r\ncktoolbar=Basic\r\n', '2011-08-05 15:17:31'),
	(33, 'Дата', '', 'rdate', 'lkey', 'type=time\r\nrating=6\r\nprint=1\r\nqview=1\r\nsys=1\r\n\r\n', '2011-04-08 01:12:56'),
	(101, 'Алиас', '', 'alias', 'lkey', 'type=s\nrating=3\ntable_list=2\ntable_list_width=70\ngroup=1\nqview=1\nqedit=1\nhelp=Короткое латинское название, используется для формирование url на эту страницу\ndirview=1\nrequired=1\n', '2011-12-07 14:34:14'),
	(42, 'Цена', '', 'price', 'lkey', 'type=s\r\nprint=1\r\ngroup=1\r\nrating=17\r\ntable_list=4\r\ntable_list_width=70\r\nqview=1\r\nqedit=1\r\n\r\n', '2011-12-05 18:13:01'),
	(54, 'Показывать на сайте', '', 'active', 'list', 'list=0|Нет~1|Да\r\ntype=radio\r\n', '0000-00-00 00:00:00'),
	(61, 'Список', '', 'list_link', 'button', 'type_link=loadcontent\r\n#add_info=1\r\n#print_info=1\r\nprogram=/cgi-bin/portfolio_a.cgi\r\nimageiconmenu=/admin/img/icons/menu/button.list.png\r\naction=enter\r\ntitle=Список\r\nrating=1\r\nparams=replaceme,list_table', '0000-00-00 00:00:00'),
	(103, 'Группа', '', 'id_group', 'lkey', 'type=tlist\r\nlist=data_portfolio_groups\r\nprint=1\r\nqview=1\r\nfilter=1\r\nrating=3\r\ntable_list=4\r\ntable_list_width=100\r\nrequired=1\r\n', '2011-12-07 14:34:14'),
	(110, 'Ссылка на видео YouTube', '', 'youtubelink', 'lkey', 'type=s\r\nprint=1\r\nqview=1\r\nqedit=1\r\nrating=10\r\ntable_list=4\r\ntable_list_width=100\r\nfileview=1\nhelp=Укажите ID или полную ссылку на видео\r\n', '2011-12-07 14:34:14'),
	(111, 'Вложена в папку', '', 'id_video', 'lkey', 'type=tlist\nlist=data_video\nprint=1\nqview=1\nqedit=1\nfileview=1\nfilter=1\nwhere= AND `dir`=\'1\'  AND `id_video`=0 \nrating=10\ntable_list=3\ntable_list_width=200\n', '0000-00-00 00:00:00'),
	(112, 'Папка', '', 'dir', 'lkey', 'type=chb\ngroup=1\nrating=6\ntable_list=1\ntable_list_name=-\ntable_list_nosort=1\ntable_list_width=16\nyes=<img src="/admin/img/dtree/folder.gif">\nno=<img src="/admin/img/dtree/doc.gif">\nfilter=1\ndirview=1\nfileview=1', '0000-00-00 00:00:00'),
	(113, 'Видео. Добавить папку', '', 'add_link_dir', 'button', 'type_link=loadcontent\r\ntable_list=1\r\ncontroller=video\r\nimageiconmenu=/admin/img/icons/menu/icon_dir_add.png\r\naction=add_dir\r\ntitle=Создать папку\r\nparams=replaceme\r\nrating=1\n', '0000-00-00 00:00:00'),
	(114, 'Описание', '', 'description', 'lkey', 'type=text\r\nrating=90\r\ngroup=1\r\ndirview=1\nfileview=1\nqview=1\nqedit=1\n', '0000-00-00 00:00:00'),
	(115, 'Датировать датой', '', 'tdate', 'lkey', 'type=date\r\nrating=50\r\ngroup=1\r\nqview=1\r\nfilter=1\r\ndirview=1\r\ntable_list=8\r\ntable_list_width=70\r\ntemplate_f=field_date_filter', '2010-10-27 11:04:12'),
	(116, 'Показывать на главной странице', '', 'has_mainpage', 'lkey', 'type=chb\nprint=1\nqview=1\nqedit=1\nfilter=1\nrating=99\ntable_list=10\ntable_list_width=70\nyes=да\nno=нет\ndirview=1\n', '0000-00-00 00:00:00'),
	(117, 'Категория', '', 'id_category', 'lkey', 'type=tlist\nlist=lst_media_groups\nprint=1\nqview=1\nfilter=1\nadd_to_list=1\nwin_scroll=0\nwin_height=100\nrating=5\n', '2014-05-20 20:40:16'),
	(118, 'Ссылка на видео Vimeo', '', 'vimeolink', 'lkey', 'type=s\r\nprint=1\r\nqview=1\r\nqedit=1\r\nrating=11\r\ntable_list=5\r\ntable_list_width=100\r\nfileview=1\nhelp=Укажите ID или полную ссылку на видео\r\n', '2011-12-07 14:34:14');
/*!40000 ALTER TABLE `keys_video` ENABLE KEYS */;


-- Дамп структуры для таблица dev_fabprint.lst_banner_urls
CREATE TABLE IF NOT EXISTS `lst_banner_urls` (
  `ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Дамп данных таблицы dev_fabprint.lst_banner_urls: ~0 rows (приблизительно)
/*!40000 ALTER TABLE `lst_banner_urls` DISABLE KEYS */;
/*!40000 ALTER TABLE `lst_banner_urls` ENABLE KEYS */;


-- Дамп структуры для таблица dev_fabprint.lst_catalog_list
CREATE TABLE IF NOT EXISTS `lst_catalog_list` (
  `ID` int(6) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=MyISAM AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

-- Дамп данных таблицы dev_fabprint.lst_catalog_list: 0 rows
/*!40000 ALTER TABLE `lst_catalog_list` DISABLE KEYS */;
/*!40000 ALTER TABLE `lst_catalog_list` ENABLE KEYS */;


-- Дамп структуры для таблица dev_fabprint.lst_feedbacks
CREATE TABLE IF NOT EXISTS `lst_feedbacks` (
  `ID` smallint(6) unsigned NOT NULL AUTO_INCREMENT,
  `l_name` varchar(150) NOT NULL,
  `f_name` varchar(255) NOT NULL,
  `phone` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `text` text NOT NULL,
  `created_at` datetime DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

-- Дамп данных таблицы dev_fabprint.lst_feedbacks: 2 rows
/*!40000 ALTER TABLE `lst_feedbacks` DISABLE KEYS */;
INSERT INTO `lst_feedbacks` (`ID`, `l_name`, `f_name`, `phone`, `email`, `text`, `created_at`) VALUES
	(1, '', '', '', 'test@test.ru', 'test', '2010-10-05 11:42:18'),
	(2, 'test', 'test', 'test', 'test@test.ru', 'test', '2010-10-05 11:44:52');
/*!40000 ALTER TABLE `lst_feedbacks` ENABLE KEYS */;


-- Дамп структуры для таблица dev_fabprint.lst_group_user
CREATE TABLE IF NOT EXISTS `lst_group_user` (
  `ID` tinyint(3) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(32) NOT NULL DEFAULT '',
  PRIMARY KEY (`ID`)
) ENGINE=MyISAM AUTO_INCREMENT=7 DEFAULT CHARSET=utf8 COMMENT='Группы пользователей';

-- Дамп данных таблицы dev_fabprint.lst_group_user: 3 rows
/*!40000 ALTER TABLE `lst_group_user` DISABLE KEYS */;
INSERT INTO `lst_group_user` (`ID`, `name`) VALUES
	(1, 'Заблокированные'),
	(3, 'Администраторы'),
	(6, 'Системные администраторы');
/*!40000 ALTER TABLE `lst_group_user` ENABLE KEYS */;


-- Дамп структуры для таблица dev_fabprint.lst_images
CREATE TABLE IF NOT EXISTS `lst_images` (
  `ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL DEFAULT '',
  `key_razdel` varchar(32) NOT NULL DEFAULT '',
  `groups_list` varchar(255) NOT NULL DEFAULT '',
  `users_list` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`ID`),
  UNIQUE KEY `key_razdel` (`key_razdel`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COMMENT='Разделы базы изображений';

-- Дамп данных таблицы dev_fabprint.lst_images: 1 rows
/*!40000 ALTER TABLE `lst_images` DISABLE KEYS */;
INSERT INTO `lst_images` (`ID`, `name`, `key_razdel`, `groups_list`, `users_list`) VALUES
	(1, 'Галерея', 'gallery', '3=6', '');
/*!40000 ALTER TABLE `lst_images` ENABLE KEYS */;


-- Дамп структуры для таблица dev_fabprint.lst_layouts
CREATE TABLE IF NOT EXISTS `lst_layouts` (
  `ID` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `layout` varchar(255) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

-- Дамп данных таблицы dev_fabprint.lst_layouts: ~2 rows (приблизительно)
/*!40000 ALTER TABLE `lst_layouts` DISABLE KEYS */;
INSERT INTO `lst_layouts` (`ID`, `name`, `layout`) VALUES
	(1, 'Основной шаблон страницы', 'default'),
	(2, 'Основной шаблон главной страницы', 'main');
/*!40000 ALTER TABLE `lst_layouts` ENABLE KEYS */;


-- Дамп структуры для таблица dev_fabprint.lst_texts
CREATE TABLE IF NOT EXISTS `lst_texts` (
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
) ENGINE=MyISAM AUTO_INCREMENT=9 DEFAULT CHARSET=utf8 COMMENT='Разделы текстовой базы';

-- Дамп данных таблицы dev_fabprint.lst_texts: 2 rows
/*!40000 ALTER TABLE `lst_texts` DISABLE KEYS */;
INSERT INTO `lst_texts` (`ID`, `name`, `key_razdel`, `listf`, `ru`, `en`, `groups_list`, `users_list`, `rating`) VALUES
	(1, 'Основные тексты', 'main', 'ID,name,alias,rating,edate,rdate', 1, 0, '3=6', '', 1),
	(8, 'Новости', 'news', 'ID,name,tdate,rdate', 1, 0, '3=6', '', 2);
/*!40000 ALTER TABLE `lst_texts` ENABLE KEYS */;


-- Дамп структуры для таблица dev_fabprint.sys_access
CREATE TABLE IF NOT EXISTS `sys_access` (
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
) ENGINE=MyISAM AUTO_INCREMENT=27 DEFAULT CHARSET=utf8 COMMENT='Правила политики безопасности';

-- Дамп данных таблицы dev_fabprint.sys_access: 24 rows
/*!40000 ALTER TABLE `sys_access` DISABLE KEYS */;
INSERT INTO `sys_access` (`ID`, `modul`, `objecttype`, `objectname`, `id_group_user`, `users`, `r`, `w`, `d`, `cck`, `updated_at`, `created_at`) VALUES
	(1, 0, 'table', 'data_banner=data_catalog_items=data_faq=data_feedback=data_seo_meta=data_subscribe=data_users=dtbl_banner_stat=dtbl_catalog_items_images=dtbl_subscribe_stat=dtbl_subscribe_users=images_gallery=lst_catalog_list=texts_main_ru=texts_news_ru', 6, '', 1, 1, 1, '11eahKQhgdxuE', '2014-02-26 23:49:24', '2011-10-29 20:24:44'),
	(2, 0, 'table', 'lst_group_user=lst_images=lst_texts', 6, '', 1, 0, 0, '01dgKPEiFI6/2', '2012-11-16 15:13:07', '2011-10-29 20:26:15'),
	(6, 61, 'lkey', 'link=author=alias=anons=texts_main=id_data_video=rss=year=texts_articles=texts_news=texts_docfiles=tdate=adate=day=docfile=title=stars=pict=keywords=description=month=url_for=name=id_news=viewtext=dir=razdel=size=rating=place=text=type_file=filename=image_gallery=price=page_shablon=menu=nomap', 6, '', 1, 1, 1, '11GmsOurPH43E', '2012-07-13 16:03:10', '2011-10-29 21:15:12'),
	(19, 61, 'lkey', 'delnot', 6, '', 1, 0, 0, '01P0T8Mc0zYlY', '2012-07-13 16:03:33', '2012-07-13 20:03:17'),
	(20, 61, 'button', 'add_link=end_link=filter_clear=edit_link=list_link=add_link_dir=del_link=filter', 6, '', 1, 0, 0, '01LhT0dObGc5Q', '2012-09-18 12:30:26', '2012-07-13 20:03:37'),
	(4, 0, 'modul', '68=62=4=60=32=12=67=3=61=69', 6, '', 1, 1, 1, '11s2YJBHWDjEE', '2014-02-26 23:49:52', '2011-10-29 20:28:46'),
	(5, 32, 'menu', 'object', 6, '', 1, 0, 0, '01Ge2NaUJAgWw', '2014-03-01 13:40:43', '2011-10-29 20:31:26'),
	(8, 32, 'button', 'seo=logout=vars=catalog=admin=syslogs=lists=texts=sysusers=filemanager', 6, '', 1, 0, 0, '01GXuIo7CPjF2', '2014-02-26 23:50:17', '2011-10-29 23:02:02'),
	(9, 3, 'button', 'add_link=end_link=list_link=filter_clear=filter', 6, '0', 1, 0, 0, '00PHiAWCKowyo', '2011-11-28 12:34:30', '2011-11-28 16:34:19'),
	(10, 3, 'lkey', 'ulclass=email=max=weight=height=id_city=id_group_user=key_razdel=login=name=id_vilage=min=active=password=id_docfiles_subrubrics=users=id_recall=id_project=id_region=rating=id_rubrics=id_docfiles_rubrics=listf=link=per_click=per_show=id_countries=text=foto1=foto2=foto3=id_equipimg=id_images=width', 6, '0', 1, 1, 1, '10CSi38DZVS8Q', '2011-11-28 12:34:43', '2011-11-28 16:34:35'),
	(11, 62, 'button', 'add_link=end_link=filter_clear=edit_link=list_link=del_link=filter', 6, '0', 1, 0, 0, '00OrpeYwtHQqw', '2011-11-28 12:35:19', '2011-11-28 16:35:08'),
	(12, 62, 'lkey', 'ip_data_click=link=cash=time=height=tdate=showdateend=showdatefirst=week=titlelink=docfile=code=click_count=view_count=id_advert_block=name=view=target=size=rating=id_advert_users=click_pay=view_pay=list_page=stat=textlink=type_show=type_file=filename=width=texts_main_ru', 6, '0', 1, 1, 1, '10b/ML8RsME06', '2011-11-28 12:35:28', '2011-11-28 16:35:23'),
	(13, 4, 'button', 'filter_clear=filter=end_link=edit_link=list_link', 6, '0', 1, 0, 0, '00JoMr.WsBzOk', '2011-11-28 12:35:51', '2011-11-28 16:35:35'),
	(14, 4, 'lkey', 'envvalue', 6, '0', 1, 1, 1, '10L5lVbsabVEw', '2011-11-28 12:36:44', '2011-11-28 16:35:54'),
	(15, 4, 'lkey', 'groups_list=users_list=set_def=name=help=id_program', 6, '0', 1, 0, 0, '00E1Cs1WHkPlk', '2011-11-28 12:37:12', '2011-11-28 16:36:47'),
	(16, 12, 'button', 'add_link=end_link=edit_link=list_link=del_link=filter_clear=filter', 6, '0', 1, 0, 0, '00hg4dUwyLVF6', '2011-11-28 12:52:25', '2011-11-28 16:52:13'),
	(17, 12, 'lkey', 'email=groups_list=users_list=bip=name=login=password=ip', 6, '', 1, 1, 1, '11aFreujZ8rDE', '2012-10-08 18:34:33', '2011-11-28 16:52:28'),
	(18, 12, 'lkey', 'id_group_user=vdate=bip=btime=count=ip', 6, '', 1, 0, 0, '01ojkmyuN8xjE', '2012-10-08 18:34:46', '2011-11-28 16:53:34'),
	(21, 32, 'lkey', 'alias=index=do', 6, '', 1, 1, 1, '11XApzbNH3SWc', '2013-06-24 15:17:31', '2013-06-24 19:16:58'),
	(22, 68, 'lkey', 'name=keywords=description=url', 6, '', 1, 1, 1, '11NiQehBWD2/s', '2014-02-26 23:48:07', '2014-02-26 23:47:58'),
	(23, 68, 'button', 'add_link=end_link=filter_clear=edit_link=del_link=filter', 6, '', 1, 0, 0, '01R/7Kl.SZGUs', '2014-02-26 23:48:17', '2014-02-26 23:48:11'),
	(24, 69, 'lkey', '', 6, '', 1, 1, 1, '11rxcFz2cFY.s', '2014-02-26 23:48:35', '2014-02-26 23:48:23'),
	(25, 67, 'lkey', 'ip=id_sysusergroup=rdate=name=comment=id_program=id_sysuser=eventtype', 6, '', 1, 1, 1, '11r/RMyKgBSi6', '2014-02-26 23:48:53', '2014-02-26 23:48:44'),
	(26, 67, 'button', 'list_link=del_link=filter_clear=filter', 6, '', 1, 0, 0, '019dlmqGQs2Co', '2014-02-26 23:49:04', '2014-02-26 23:48:57');
/*!40000 ALTER TABLE `sys_access` ENABLE KEYS */;


-- Дамп структуры для таблица dev_fabprint.sys_blockip
CREATE TABLE IF NOT EXISTS `sys_blockip` (
  `ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `ip` varchar(15) NOT NULL DEFAULT '',
  `block` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `ip` (`ip`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Заблокированные IP';

-- Дамп данных таблицы dev_fabprint.sys_blockip: 0 rows
/*!40000 ALTER TABLE `sys_blockip` DISABLE KEYS */;
/*!40000 ALTER TABLE `sys_blockip` ENABLE KEYS */;


-- Дамп структуры для таблица dev_fabprint.sys_changes
CREATE TABLE IF NOT EXISTS `sys_changes` (
  `ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `list_table` varchar(255) DEFAULT '0',
  `item_id` int(10) unsigned NOT NULL,
  `lkey` varchar(255) DEFAULT '0',
  `value` text,
  `operator` varchar(255) DEFAULT '',
  `created_at` datetime DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 COMMENT='История изменений';

-- Дамп данных таблицы dev_fabprint.sys_changes: ~0 rows (приблизительно)
/*!40000 ALTER TABLE `sys_changes` DISABLE KEYS */;
/*!40000 ALTER TABLE `sys_changes` ENABLE KEYS */;


-- Дамп структуры для таблица dev_fabprint.sys_datalogs
CREATE TABLE IF NOT EXISTS `sys_datalogs` (
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
) ENGINE=MyISAM AUTO_INCREMENT=34 DEFAULT CHARSET=utf8 COMMENT='Логи работы с панелью';

-- Дамп данных таблицы dev_fabprint.sys_datalogs: 0 rows
/*!40000 ALTER TABLE `sys_datalogs` DISABLE KEYS */;
/*!40000 ALTER TABLE `sys_datalogs` ENABLE KEYS */;


-- Дамп структуры для таблица dev_fabprint.sys_filemanager_cache
CREATE TABLE IF NOT EXISTS `sys_filemanager_cache` (
  `hash` varchar(100) NOT NULL DEFAULT '',
  `info` blob,
  `updated` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`hash`),
  KEY `updated` (`updated`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Дамп данных таблицы dev_fabprint.sys_filemanager_cache: ~0 rows (приблизительно)
/*!40000 ALTER TABLE `sys_filemanager_cache` DISABLE KEYS */;
/*!40000 ALTER TABLE `sys_filemanager_cache` ENABLE KEYS */;


-- Дамп структуры для таблица dev_fabprint.sys_history
CREATE TABLE IF NOT EXISTS `sys_history` (
  `id_user` int(11) NOT NULL DEFAULT '0',
  `link` text NOT NULL,
  `title` varchar(255) DEFAULT NULL,
  `replaceme` varchar(128) NOT NULL DEFAULT '',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY `id_user` (`id_user`,`replaceme`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Таблица с историей загрузки доку';

-- Дамп данных таблицы dev_fabprint.sys_history: 0 rows
/*!40000 ALTER TABLE `sys_history` DISABLE KEYS */;
/*!40000 ALTER TABLE `sys_history` ENABLE KEYS */;


-- Дамп структуры для таблица dev_fabprint.sys_lists
CREATE TABLE IF NOT EXISTS `sys_lists` (
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
) ENGINE=MyISAM AUTO_INCREMENT=14 DEFAULT CHARSET=utf8 PACK_KEYS=0 COMMENT='Справочники';

-- Дамп данных таблицы dev_fabprint.sys_lists: 6 rows
/*!40000 ALTER TABLE `sys_lists` DISABLE KEYS */;
INSERT INTO `sys_lists` (`ID`, `name`, `lkey`, `listf`, `editlist`, `width`, `height`, `scroll`) VALUES
	(1, 'Список программных модулей', 'sys_program', 'ID,name,key_razdel', 0, 0, 0, 0),
	(2, 'Группы пользователей', 'lst_group_user', 'ID,name', 1, 0, 0, 0),
	(3, 'Пользователи', 'sys_users', 'ID,name', 0, 0, 0, 0),
	(10, 'Шаблоны страниц', 'lst_layouts', 'ID,name,layout', 0, 0, 0, 0),
	(12, 'Баннерокрутилка. URL страниц', 'lst_banner_urls', 'ID,name', 1, 0, 0, 0),
	(13, 'Обратная связь', 'lst_feedbacks', 'ID,name', 0, 0, 0, 0);
/*!40000 ALTER TABLE `sys_lists` ENABLE KEYS */;


-- Дамп структуры для таблица dev_fabprint.sys_lkeys_log
CREATE TABLE IF NOT EXISTS `sys_lkeys_log` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `keys_tbl` varchar(32) NOT NULL DEFAULT '',
  `qstring` text NOT NULL,
  `keys_send` longtext NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Лог переданных параметров';

-- Дамп данных таблицы dev_fabprint.sys_lkeys_log: 0 rows
/*!40000 ALTER TABLE `sys_lkeys_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `sys_lkeys_log` ENABLE KEYS */;


-- Дамп структуры для таблица dev_fabprint.sys_mysql_error
CREATE TABLE IF NOT EXISTS `sys_mysql_error` (
  `sql` text NOT NULL,
  `error` text NOT NULL,
  `qstring` varchar(255) NOT NULL DEFAULT '',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Ошибки MySQL';

-- Дамп данных таблицы dev_fabprint.sys_mysql_error: 0 rows
/*!40000 ALTER TABLE `sys_mysql_error` DISABLE KEYS */;
/*!40000 ALTER TABLE `sys_mysql_error` ENABLE KEYS */;


-- Дамп структуры для таблица dev_fabprint.sys_program
CREATE TABLE IF NOT EXISTS `sys_program` (
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
) ENGINE=MyISAM AUTO_INCREMENT=73 DEFAULT CHARSET=utf8 PACK_KEYS=0 COMMENT='Список программ';

-- Дамп данных таблицы dev_fabprint.sys_program: 21 rows
/*!40000 ALTER TABLE `sys_program` DISABLE KEYS */;
INSERT INTO `sys_program` (`ID`, `name`, `default_table`, `keys_table`, `key_razdel`, `menu_btn_key`, `pict`, `help`, `prgroup`, `ru`, `en`, `settings`) VALUES
	(3, 'Справочники', NULL, 'keys_lists', 'lists', 'menu_settings', '/admin/img/icons/program/lists.png', 'Модуль для работы со справочниками и списками.', 4, 1, 0, 'groupname=Общая информация\r\nqsearch=1\r\nqedit=1\r\nqview=1\r\ntree=1'),
	(4, 'Глобальные переменные', 'sys_vars', 'keys_vars', 'vars', 'menu_settings', '/admin/img/icons/program/settings.png', 'Модуль для настройки глобальных переменных.', 4, 1, 0, 'groupname=Общая информация\r\nqsearch=1\r\nqedit=1\r\nqview=1\r\ntree=1\r\n'),
	(1, 'Настройки', NULL, 'keys_mainconfig', 'admin', 'menu_settings', '/admin/img/icons/menu/icon_home.gif', 'Главная страница панели управления', 4, 0, 0, 'groupname='),
	(6, 'Ключи', NULL, 'keys_keys', 'keys', 'menu_settings', '/admin/img/icons/program/object.png', 'Модуль для работы с ключами: ключами, кнопками, списками.', 4, 1, 0, 'groupname=Ключ\r\nqsearch=1\r\nqedit=1\r\nqview=1\r\ntree=1\r\n\r\n'),
	(9, 'Стили', NULL, 'keys_styles', 'styles', 'menu_settings', '/admin/img/icons/program/styles.png', 'Модуль для редактирования таблиц стилей.', 4, 1, 0, 'groupname=Общая информация\r\nqsearch=1'),
	(11, 'Права доступа', 'sys_access', 'keys_access', 'access', 'menu_settings', '/admin/img/icons/program/access.png', 'Модуль для определение доступа к модулям, таблицам, полям.', 4, 1, 0, 'groupname=Тип объекта|Модуль|Настрока прав доступа\r\nqsearch=1\r\nqedit=1\r\nqview=1\r\ntree=1\r\n'),
	(12, 'Пользователи', 'sys_users', 'keys_sysusers', 'sysusers', 'menu_settings', '/admin/img/icons/program/users.png', 'Модуль для управления учетными записями пользователей.', 4, 1, 0, 'groupname=Общая информация\r\nqsearch=1\r\nqedit=1\r\nqview=1\r\ntree=1\r\n'),
	(5, 'Шаблоны', NULL, 'keys_templates', 'templates', 'menu_settings', '/admin/img/icons/program/templates.png', 'Модуль для работы с шаблонами.', 4, 1, 0, 'groupname=Шаблон\r\nqsearch=1\r\nqedit=1\r\nqview=1\r\ntree=0\r\n'),
	(32, 'Панель управления', NULL, 'keys_global', 'global', 'menu_button', '/admin/img/icons/menu/icon_home.gif', 'Главная страница панели управления', 4, 0, 0, 'groupname='),
	(60, 'Каталог', 'data_catalog_items', 'keys_catalog', 'catalog', 'menu_catalog', '/admin/img/icons/program/catalog2.png', 'Модуль работы с каталогом', 3, 1, 0, 'groupname=Общие данные|Фото\r\ngroupname_categorys=Общие данные\ngroupname_brands=Общие данные\r\ngroupname_set=Общие данные\r\nqsearch=1\r\nqedit=1\r\nqview=1\r\ndefcol=1\r\ntable_indexes=1\nfollow_changes=1\n\r\n'),
	(61, 'Тексты', 'texts_main_ru', 'keys_texts', 'texts', 'mainrazdel_button', '/admin/img/icons/program/text.png', 'Модуль для работы с текстами: добавление, редактирование, удаление, построение спискови и меню.', 1, 1, 1, 'groupname=Общая информация|Текст\r\ngroupname_docfiles=Общая информация\r\ngroupname_soffers=Общая информация\r\ngroupname_floating=Общая информация\r\nqsearch=1\r\nrazdels=1\r\nchange_lang=1\r\nqedit=1\r\nqview=1\r\ntree=1\r\nfollow_changes=1\n'),
	(62, 'Баннерокрутилка', 'data_banner', 'keys_banners', 'banners', 'menu_banner', '/admin/img/icons/program/banner.png', 'Модуль для управления показами рекламных баннеров на сайте.', 3, 1, 0, 'groupname=Общие данные|Рекламный блок|Настройки таргетинга|Статистика\r\ndefcol=1\r\nqsearch=1\r\nqedit=1\r\nqview=1\r\nexcel=1\r\ntree=1'),
	(63, 'Изображения', 'images_gallery', 'keys_images', 'images', 'mainrazdel_button', '/admin/img/icons/program/image.png', 'Модуль для работы с изображениями: добавление, редактирование, удаление.', 1, 0, 0, 'groupname=Общая информация\r\ngroupname_catalog=Общая информация\r\nqsearch=1\r\nrazdels=1\r\nqedit=1\r\nqview=1\r\ntree=1\r\n'),
	(64, 'Вопрос-ответ', 'data_faq', 'keys_faq', 'faq', 'menu_faq', '/admin/img/icons/program/faq.png', 'Модуль для работы с вопрос-ответ: редактирование, удаление.', 3, 1, 0, 'groupname=Общая информация\r\nqsearch=1\r\n#qedit=1\r\nqview=1'),
	(66, 'Внешние пользователи', 'data_users', 'keys_users', 'users', 'menu_users', '/admin/img/icons/program/users.gif', 'Модуль для управления учетными записями внешних пользователей.', 3, 1, 0, 'groupname=Общая информация\r\nqsearch=1\r\nqedit=1\r\nqview=1\r\n'),
	(67, 'Системный журнал', 'sys_datalogs', 'keys_syslogs', 'syslogs', 'menu_settings', '/admin/img/icons/program/syslogs.png', 'Модуль для просмотра системных логов пользователей', 4, 1, 0, 'groupname=Общая информация\r\nqsearch=1\r\nqview=1\r\n'),
	(68, 'SEO', 'data_seo_meta', 'keys_seo', 'seo', 'menu_settings', '/admin/img/icons/program/seo.png', 'Модуль для работы с meta тегами страниц', 4, 1, 0, 'groupname=Общая информация\r\nqsearch=1\r\nqview=1\r\n'),
	(69, 'Файлменеджер', NULL, 'keys_filemanager', 'filemanager', 'mainrazdel_button', '/admin/img/icons/program/filemanager.png', 'Модуль для работы с файлами', 1, 1, 1, 'groupname=Общая информация\r\n'),
	(70, '301 Redirect', 'data_redirects', 'keys_redirects', 'redirects', 'menu_settings', '/admin/img/icons/program/redirects.png', 'Модуль для создания редиректов страницу', 4, 1, 0, 'groupname=Общая информация\nqsearch=1\nqview=1\n'),
	(71, 'Отзывы', 'data_recall', 'keys_recall', 'recall', 'menu_recall', '/admin/img/icons/program/links.png', 'Модуль для работы с отзывами: редактирование, удаление.', 3, 1, 0, 'groupname=Общая информация\nqsearch=1\nqedit=1\nfollow_changes=1\nqview=1'),
	(72, 'Рассылка', 'data_subscribe', 'keys_subscribe', 'subscribe', 'menu_subscribe', '/admin/img/icons/program/subscribe.png', 'Модуль для работы с рассылкой', 3, 1, 0, 'groupname=Общая информация|Текст\r\ngroupname_data_subscribe_users=Общая информация\r\ngroupname_data_subscribe_groups=Общая информация\r\nqsearch=1\r\nqedit=1\r\nfollow_changes=1\r\nqview=1');
/*!40000 ALTER TABLE `sys_program` ENABLE KEYS */;


-- Дамп структуры для таблица dev_fabprint.sys_program_tables
CREATE TABLE IF NOT EXISTS `sys_program_tables` (
  `ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `table` varchar(50) NOT NULL,
  `program_id` smallint(5) unsigned DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `table` (`table`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;

-- Дамп данных таблицы dev_fabprint.sys_program_tables: ~7 rows (приблизительно)
/*!40000 ALTER TABLE `sys_program_tables` DISABLE KEYS */;
INSERT INTO `sys_program_tables` (`ID`, `name`, `table`, `program_id`) VALUES
	(1, 'Товары', 'data_catalog_items', 60),
	(2, 'Категории', 'data_catalog_categories', 60),
	(3, 'Бренды', 'data_catalog_brands', 60),
	(4, 'Заказы', 'data_catalog_orders', 60),
	(5, 'Баннеры', 'data_banner', 62),
	(6, 'Рекламные места', 'data_banner_advert_block', 62),
	(7, 'Рекламодатели', 'data_banner_advert_users', 62);
/*!40000 ALTER TABLE `sys_program_tables` ENABLE KEYS */;


-- Дамп структуры для таблица dev_fabprint.sys_related
CREATE TABLE IF NOT EXISTS `sys_related` (
  `ID` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `tbl_main` varchar(64) NOT NULL DEFAULT '',
  `tbl_main_title` varchar(255) NOT NULL,
  `tbl_dep` varchar(64) NOT NULL DEFAULT '',
  `tbl_dep_title` varchar(255) NOT NULL,
  `field` varchar(64) NOT NULL DEFAULT '',
  `mult` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `delete` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`ID`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

-- Дамп данных таблицы dev_fabprint.sys_related: 2 rows
/*!40000 ALTER TABLE `sys_related` DISABLE KEYS */;
INSERT INTO `sys_related` (`ID`, `tbl_main`, `tbl_main_title`, `tbl_dep`, `tbl_dep_title`, `field`, `mult`, `delete`) VALUES
	(1, 'lst_advert_block', '', 'data_banner', '', 'id_advert_block', 1, 0),
	(2, 'data_catalog_orders', 'заказы', 'dtbl_orders', 'заказы.товары', 'id_order', 0, 1);
/*!40000 ALTER TABLE `sys_related` ENABLE KEYS */;


-- Дамп структуры для таблица dev_fabprint.sys_users
CREATE TABLE IF NOT EXISTS `sys_users` (
  `ID` smallint(6) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL DEFAULT '',
  `login` varchar(32) NOT NULL DEFAULT '',
  `password_digest` varchar(255) NOT NULL DEFAULT '',
  `email` varchar(128) NOT NULL DEFAULT '',
  `id_group_user` varchar(255) NOT NULL DEFAULT '1',
  `vdate` datetime DEFAULT NULL,
  `count` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `btime` datetime DEFAULT NULL,
  `bip` varchar(15) NOT NULL DEFAULT '',
  `settings` text NOT NULL,
  `users_list` text NOT NULL,
  `groups_list` varchar(30) NOT NULL,
  `sys` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `access` blob NOT NULL,
  `vfe` tinyint(1) NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `login` (`login`)
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 PACK_KEYS=0 COMMENT='Таблица пользователей';

-- Дамп данных таблицы dev_fabprint.sys_users: 2 rows
/*!40000 ALTER TABLE `sys_users` DISABLE KEYS */;
INSERT INTO `sys_users` (`ID`, `name`, `login`, `password_digest`, `email`, `id_group_user`, `vdate`, `count`, `btime`, `bip`, `settings`, `users_list`, `groups_list`, `sys`, `access`, `vfe`, `updated_at`, `created_at`) VALUES
	(1, 'Системный администратор', 'root', '$2a$06$LUDXRF/MXxDLKRXNcUqzKOiX106yfsAExsnieDocZo8mJaPeuzaDu', 'dev@ifrog.ru,rn.dev@ifrog.ru', '6', NULL, 0, NULL, '10.0.2.2', 'catalog_data_catalog_categorys_page=1\nkeys_keys_catalog_page=1\nsysusers_sys_users_pcol=25\nimages_page_doptable=1\nlists_lst_group_user_page=1\ntexts_texts_floating_ru_page=1\nbanners_qedit=1\nstat_page_doptable=3\nlang=ru\ncatalog_data_catalog_items_asc=asc\ncatalog_data_catalog_items_page=1\ntexts_texts_main_ru_pcol=25\nvars_sys_vars_pcol=50\nbanners_data_banner_page=1\nfaq_data_faq_page=1\nusers_data_users_page=1\ntexts_sfield=ID\nstat_pcol_doptable=25\nsyslogs_sys_datalogs_page=1\nimages_sfield=ID\nkeys_keys_texts_page=1\nkeys_keys_keys_page=1\nredirects_data_redirects_page=1\ntexts_texts_news_ru_page=1\n_texts_floating_ru_sfield=ID\naccess_sys_access_page=1\ncatalog_data_catalog_items_sfield=name\nkeys_keys_catalog_filter_take=1\nkeys_keys_styles_page=1\ntexts_pcol=25\nkeys_keys_faq_page=1\ntexts_razdel=1\n_page=1\nkeys_keys_vars_page=1\nrightwin_hidden=1\nlists_lst_advert_users_page=1\nvars_sys_vars_page=1\nimages_images_gallery_page=1\ntexts_filter_tdatepref=>\nsyslogs_sys_datalogs_pcol=25\nimages_page=1\nsyslogs_sys_datalogs_filter_rdate=2014-02-20 00:00:00\nredirects_data_redirects_pcol=25\nkeys_keys_auth_page=1\nsubscribe_dtbl_subscribe_users_page=1\nimages_images_gallery_pcol=25\nsyslogs_sys_datalogs_filter_rdatepref=>\ntexts_texts_main_ru_sfield=ID\ntexts_texts_floating_ru_sfield=ID\nlists_lst_advert_block_page=1\n_sfield=ID\nkeys_keys_mainconfig_pcol=25\nbanners_data_banner_advert_block_page=1\nkeys_keys_lists_page=1\ntexts_qedit=1\ntexts_texts_news_ru_sfield=ID\nseo_data_seo_meta_page=1\ntexts_texts_main_ru_page=1\ncatalog_qedit=1\ncatalog_data_catalog_brands_page=1\n_texts_floating_ru_page=1\nimages_razdel=1\ntexts_page=1\nsubscribe_data_subscribe_page=1\nbanners_data_banner_advert_users_page=1\nsysusers_sys_users_page=1\nkeys_keys_access_page=1\ncatalog_data_catalog_items_pcol=25\nkeys_keys_banners_page=1\nkeys_keys_mainconfig_page=1', '1', '0', 1, _binary 0x65794A74623252316243493665794932496A6F784C4349324D5349364D5377694E7A45694F6A4573496A597A496A6F784C43497A4D6949364D5377694E7A49694F6A4573496A4579496A6F784C4349324D4349364D5377694E6A67694F6A4573496A45694F6A4573496A6B694F6A4573496A4578496A6F784C4349324F5349364D5377694E4349364D5377694E6A59694F6A4573496A4D694F6A4573496A5930496A6F784C4349324D6949364D5377694E7A41694F6A4573496A55694F6A4573496A5933496A6F786658302D, 1, '2011-11-16 22:28:16', '2009-01-31 16:23:35'),
	(3, 'Администратор', 'user', '$2a$06$Jy7yYkrAQ1bPLB/qOSH/Yu8wuhLzpJt9BlAPk1OyOUcwpWu.qg4Su', 'ifrogseo@gmail.com', '6', NULL, 0, NULL, '10.0.2.2', 'lang=ru\ntexts_sfield=ID\ntexts_pcol=25\ncatalog_data_catalog_items_page=1\ntexts_razdel=1\nvars_sys_vars_page=1\ntexts_page=1\nlists_lst_group_user_page=1\n_sfield=ID', '3', '', 0, _binary 0x65794A746232523162434936657949784D6949364D5377694E4349364D5377694E6A6B694F6A4573496A5978496A6F784C43497A4D6949364D5377694E6A63694F6A4573496A5934496A6F784C4349324D4349364D5377694D7949364D5377694E6A49694F6A463966512D3D, 1, '0000-00-00 00:00:00', '2011-05-07 19:14:35');
/*!40000 ALTER TABLE `sys_users` ENABLE KEYS */;


-- Дамп структуры для таблица dev_fabprint.sys_users_session
CREATE TABLE IF NOT EXISTS `sys_users_session` (
  `cck` varchar(32) NOT NULL,
  `time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `host` varchar(100) NOT NULL,
  `ip` varchar(100) NOT NULL,
  `id_user` int(6) unsigned NOT NULL,
  `data` blob,
  PRIMARY KEY (`id_user`,`cck`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- Дамп данных таблицы dev_fabprint.sys_users_session: 0 rows
/*!40000 ALTER TABLE `sys_users_session` DISABLE KEYS */;
/*!40000 ALTER TABLE `sys_users_session` ENABLE KEYS */;


-- Дамп структуры для таблица dev_fabprint.sys_vars
CREATE TABLE IF NOT EXISTS `sys_vars` (
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
) ENGINE=MyISAM AUTO_INCREMENT=12 DEFAULT CHARSET=utf8 PACK_KEYS=0 COMMENT='Глобальные переменные';

-- Дамп данных таблицы dev_fabprint.sys_vars: 6 rows
/*!40000 ALTER TABLE `sys_vars` DISABLE KEYS */;
INSERT INTO `sys_vars` (`ID`, `name`, `id_program`, `users_list`, `groups_list`, `envkey`, `envvalue`, `settings`, `types`, `comment`, `updated_at`, `operator`) VALUES
	(1, 'Название сайта', 0, '', '3=6', 'site_name', 'GG v9', '', 's', '', NULL, NULL),
	(4, 'Сохранять лог операций дней', 0, '', '6', 'time_log', '60', '', 'd', '60', NULL, NULL),
	(5, 'E-mail администратора сайта', 0, '', '3=6', 'email_admin', 'vdovin.a.a@gmail.com\r\n', '', 'email', '', NULL, NULL),
	(6, 'Максимальный размер картинок в файлменеджере', 0, '1=3', '3=6', 'filemanager_max_image_size', '1000', '', 'd', '1000', NULL, NULL),
	(10, 'Тестовая список', 0, '1', '6', 'test', '1=2=3', 'list=1|Параметр 1~2|Параметр 2~3|Параметр 3\n', 'list_chb', '', NULL, NULL),
	(11, 'Uploadcare ключ', 0, '', '6', 'UPLOADCARE_PUBLIC_KEY', '2d0e67e1e5f8a8d96345', '', 's', 'Введите ключ для сервиса Uploadcare. После добавления ключа требуется перезагрузка административной панели ( Ctrl+F5 )', NULL, NULL);
/*!40000 ALTER TABLE `sys_vars` ENABLE KEYS */;


-- Дамп структуры для таблица dev_fabprint.texts_main_ru
CREATE TABLE IF NOT EXISTS `texts_main_ru` (
  `ID` int(10) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL DEFAULT '',
  `h1` varchar(255) NOT NULL,
  `alias` varchar(128) NOT NULL DEFAULT '',
  `title` varchar(255) NOT NULL DEFAULT '',
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
  `text` text NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `alias` (`alias`),
  KEY `rating` (`rating`,`menu`,`viewtext`),
  FULLTEXT KEY `text` (`text`)
) ENGINE=MyISAM AUTO_INCREMENT=25 DEFAULT CHARSET=utf8 PACK_KEYS=0;

-- Дамп данных таблицы dev_fabprint.texts_main_ru: 1 rows
/*!40000 ALTER TABLE `texts_main_ru` DISABLE KEYS */;
INSERT INTO `texts_main_ru` (`ID`, `name`, `h1`, `alias`, `title`, `keywords`, `description`, `rating`, `texts_main_ru`, `operator`, `menu`, `viewtext`, `delnot`, `link`, `layout`, `url_for`, `text`, `updated_at`, `created_at`) VALUES
	(1, 'Главная страница', 'Главная', 'main', 'Главная страница', 'Главная страница', 'Главная страница', 1, 0, 'root', 0, 1, 1, '', 'main', '', '<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat. Ut wisi enim ad minim veniam, quis nostrud exerci tation ullamcorper suscipit lobortis nisl ut aliquip ex ea commodo consequat. Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi.</p>\n\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat vol</p>', '2015-04-18 16:49:32', '2012-03-05 13:28:44');
/*!40000 ALTER TABLE `texts_main_ru` ENABLE KEYS */;


-- Дамп структуры для таблица dev_fabprint.texts_news_ru
CREATE TABLE IF NOT EXISTS `texts_news_ru` (
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
) ENGINE=MyISAM AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 COMMENT='Новостная лента';

-- Дамп данных таблицы dev_fabprint.texts_news_ru: 5 rows
/*!40000 ALTER TABLE `texts_news_ru` DISABLE KEYS */;
INSERT INTO `texts_news_ru` (`ID`, `name`, `alias`, `title`, `description`, `keywords`, `tdate`, `viewtext`, `operator`, `text`, `updated_at`, `created_at`) VALUES
	(1, 'Sed scelerisque magnis augue, lectus nisi porttitor dolor, aliquet adipiscing et vel', 'Sed scelerisque magnis augue, lectus nisi porttitor dolor, aliquet adipiscing et vel', 'Sed scelerisque magnis augue, lectus nisi porttitor dolor, aliquet adipiscing et vel', 'Sed scelerisque magnis augue, lectus nisi porttitor dolor, aliquet adipiscing et vel', 'Sed scelerisque magnis augue, lectus nisi porttitor dolor, aliquet adipiscing et vel', '2012-03-11', 1, 'root', '<p>Velit nunc tempor mattis pulvinar mattis. Et enim mus, etiam! Ridiculus a dolor! Adipiscing scelerisque velit? Ultricies turpis, amet tristique, sed. Dapibus scelerisque magna. Placerat, nec cum parturient porttitor tincidunt, adipiscing, scelerisque aliquam pid purus turpis sed vut in sagittis! Habitasse tempor sed parturient? Eros! Augue pellentesque magnis, in a tempor cursus. Ultricies sit sed scelerisque lundium, nascetur pellentesque nunc aenean ridiculus magna? Ac egestas. Rhoncus! Penatibus sed, aenean ac mattis nec, platea enim! Et, aliquam scelerisque mid cum est, facilisis augue turpis hac. Magnis est sit. Rhoncus, a! Integer, et. Nisi amet facilisis, aliquet sed! Sed dolor turpis, urna. Mauris mauris vel nisi augue cras scelerisque rhoncus, non sed ultricies etiam, cum lorem ut eros, cum phasellus, dignissim. Augue.</p>\n\n<p>\nEst lectus in quis, integer lorem integer dis sed nec a, ac adipiscing turpis, ridiculus nunc elit elit placerat natoque ac vut nec? Pulvinar quis platea pulvinar, tempor purus et, proin? Porta, mattis amet rhoncus dolor magna hac cursus? Scelerisque urna ultricies, augue, porttitor odio. Nec nunc, dapibus, amet odio duis! Dis amet rhoncus phasellus, elementum adipiscing, massa platea risus pulvinar. Vel eros arcu mauris porttitor? Ac, lacus. Sit purus aenean in augue non nisi diam turpis. Elementum in dapibus augue purus dis! Lundium urna in! Quis! Elementum enim nascetur eu sed aenean dapibus enim porta! Rhoncus adipiscing magnis scelerisque mid vel in sociis ac porttitor mus elementum amet sit. A hac adipiscing adipiscing in urna nec, rhoncus dapibus.</p>\n\n<p>\nIn mauris. Duis, rhoncus adipiscing elit! Eros elementum a habitasse est, mid tempor lundium turpis mauris mid. Nisi. Amet, cursus purus enim in dictumst? Odio adipiscing magnis et hac magna rhoncus, sed, nunc tortor risus? Rhoncus cursus! Ac et, tortor cum placerat nisi rhoncus dictumst porttitor dignissim lectus lorem dictumst, magna, cum elementum adipiscing, montes sit phasellus egestas odio odio dapibus. Adipiscing tincidunt nisi vut, augue hac, ac in turpis aliquam! Scelerisque porta porttitor nisi in dapibus etiam vel? Nascetur magna turpis placerat, vel nec pulvinar enim! Hac auctor enim pulvinar porttitor? Tortor, cum tristique sed phasellus ultrices enim integer cum eros, sed elit! Sit duis porttitor et risus lorem magnis, dictumst in. Cras integer nisi habitasse facilisis, sed.</p>\n<p>\nQuis et est platea nec sagittis tristique, nec amet? Vel lacus, facilisis, et, adipiscing scelerisque ac, platea, cursus magnis odio diam platea risus? Augue? Integer nec aliquet egestas vut elementum nunc lundium a, nascetur augue. Sit urna massa, quis ultrices dapibus? Integer scelerisque, adipiscing enim. Montes mattis tincidunt montes placerat tincidunt penatibus tincidunt vel rhoncus? Etiam sit in nunc, ut. Scelerisque amet velit mauris tincidunt augue lacus natoque, penatibus platea ac! Auctor lacus, vut. Sed, eros odio? Lundium nascetur, cursus platea! Cum ac? Sit sit risus non? Ac montes? Sed adipiscing sed facilisis hac, pellentesque in vel cum urna montes quis sed, urna habitasse vut risus mid, amet natoque placerat massa, dignissim in facilisis, dictumst, sed turpis sed magna.</p>', '2012-10-11 12:42:39', '2011-03-29 11:17:43'),
	(2, 'Mid mus eu duis ut! Nascetur scelerisque adipiscing, magnis, ut tortor penatibus pulvinar est pulvinar', 'Mid mus eu duis ut! Nascetur scelerisque adipiscing, magnis, ut tortor penatibus pulvinar est pulvinar', 'Mid mus eu duis ut! Nascetur scelerisque adipiscing, magnis, ut tortor penatibus pulvinar est pulvinar', 'Mid mus eu duis ut! Nascetur scelerisque adipiscing, magnis, ut tortor penatibus pulvinar est pulvinar', 'Mid mus eu duis ut! Nascetur scelerisque adipiscing, magnis, ut tortor penatibus pulvinar est pulvinar', '2012-03-10', 1, 'root', '<p>Velit nunc tempor mattis pulvinar mattis. Et enim mus, etiam! Ridiculus a dolor! Adipiscing scelerisque velit? Ultricies turpis, amet tristique, sed. Dapibus scelerisque magna. Placerat, nec cum parturient porttitor tincidunt, adipiscing, scelerisque aliquam pid purus turpis sed vut in sagittis! Habitasse tempor sed parturient? Eros! Augue pellentesque magnis, in a tempor cursus. Ultricies sit sed scelerisque lundium, nascetur pellentesque nunc aenean ridiculus magna? Ac egestas. Rhoncus! Penatibus sed, aenean ac mattis nec, platea enim! Et, aliquam scelerisque mid cum est, facilisis augue turpis hac. Magnis est sit. Rhoncus, a! Integer, et. Nisi amet facilisis, aliquet sed! Sed dolor turpis, urna. Mauris mauris vel nisi augue cras scelerisque rhoncus, non sed ultricies etiam, cum lorem ut eros, cum phasellus, dignissim. Augue.</p>\n\n<p>\nEst lectus in quis, integer lorem integer dis sed nec a, ac adipiscing turpis, ridiculus nunc elit elit placerat natoque ac vut nec? Pulvinar quis platea pulvinar, tempor purus et, proin? Porta, mattis amet rhoncus dolor magna hac cursus? Scelerisque urna ultricies, augue, porttitor odio. Nec nunc, dapibus, amet odio duis! Dis amet rhoncus phasellus, elementum adipiscing, massa platea risus pulvinar. Vel eros arcu mauris porttitor? Ac, lacus. Sit purus aenean in augue non nisi diam turpis. Elementum in dapibus augue purus dis! Lundium urna in! Quis! Elementum enim nascetur eu sed aenean dapibus enim porta! Rhoncus adipiscing magnis scelerisque mid vel in sociis ac porttitor mus elementum amet sit. A hac adipiscing adipiscing in urna nec, rhoncus dapibus.</p>\n\n<p>\nIn mauris. Duis, rhoncus adipiscing elit! Eros elementum a habitasse est, mid tempor lundium turpis mauris mid. Nisi. Amet, cursus purus enim in dictumst? Odio adipiscing magnis et hac magna rhoncus, sed, nunc tortor risus? Rhoncus cursus! Ac et, tortor cum placerat nisi rhoncus dictumst porttitor dignissim lectus lorem dictumst, magna, cum elementum adipiscing, montes sit phasellus egestas odio odio dapibus. Adipiscing tincidunt nisi vut, augue hac, ac in turpis aliquam! Scelerisque porta porttitor nisi in dapibus etiam vel? Nascetur magna turpis placerat, vel nec pulvinar enim! Hac auctor enim pulvinar porttitor? Tortor, cum tristique sed phasellus ultrices enim integer cum eros, sed elit! Sit duis porttitor et risus lorem magnis, dictumst in. Cras integer nisi habitasse facilisis, sed.</p>\n<p>\nQuis et est platea nec sagittis tristique, nec amet? Vel lacus, facilisis, et, adipiscing scelerisque ac, platea, cursus magnis odio diam platea risus? Augue? Integer nec aliquet egestas vut elementum nunc lundium a, nascetur augue. Sit urna massa, quis ultrices dapibus? Integer scelerisque, adipiscing enim. Montes mattis tincidunt montes placerat tincidunt penatibus tincidunt vel rhoncus? Etiam sit in nunc, ut. Scelerisque amet velit mauris tincidunt augue lacus natoque, penatibus platea ac! Auctor lacus, vut. Sed, eros odio? Lundium nascetur, cursus platea! Cum ac? Sit sit risus non? Ac montes? Sed adipiscing sed facilisis hac, pellentesque in vel cum urna montes quis sed, urna habitasse vut risus mid, amet natoque placerat massa, dignissim in facilisis, dictumst, sed turpis sed magna.</p>', '2012-03-11 14:52:41', '0000-00-00 11:18:15'),
	(3, 'Dis pellentesque placerat amet quis nascetur sociis sed a, dictumst ', 'Dis pellentesque placerat amet quis nascetur sociis sed a, dictumst ', 'Dis pellentesque placerat amet quis nascetur sociis sed a, dictumst ', 'Dis pellentesque placerat amet quis nascetur sociis sed a, dictumst ', 'Dis pellentesque placerat amet quis nascetur sociis sed a, dictumst ', '2011-06-03', 1, '', '<p>Velit nunc tempor mattis pulvinar mattis. Et enim mus, etiam! Ridiculus a dolor! Adipiscing scelerisque velit? Ultricies turpis, amet tristique, sed. Dapibus scelerisque magna. Placerat, nec cum parturient porttitor tincidunt, adipiscing, scelerisque aliquam pid purus turpis sed vut in sagittis! Habitasse tempor sed parturient? Eros! Augue pellentesque magnis, in a tempor cursus. Ultricies sit sed scelerisque lundium, nascetur pellentesque nunc aenean ridiculus magna? Ac egestas. Rhoncus! Penatibus sed, aenean ac mattis nec, platea enim! Et, aliquam scelerisque mid cum est, facilisis augue turpis hac. Magnis est sit. Rhoncus, a! Integer, et. Nisi amet facilisis, aliquet sed! Sed dolor turpis, urna. Mauris mauris vel nisi augue cras scelerisque rhoncus, non sed ultricies etiam, cum lorem ut eros, cum phasellus, dignissim. Augue.</p>\n\n<p>\nEst lectus in quis, integer lorem integer dis sed nec a, ac adipiscing turpis, ridiculus nunc elit elit placerat natoque ac vut nec? Pulvinar quis platea pulvinar, tempor purus et, proin? Porta, mattis amet rhoncus dolor magna hac cursus? Scelerisque urna ultricies, augue, porttitor odio. Nec nunc, dapibus, amet odio duis! Dis amet rhoncus phasellus, elementum adipiscing, massa platea risus pulvinar. Vel eros arcu mauris porttitor? Ac, lacus. Sit purus aenean in augue non nisi diam turpis. Elementum in dapibus augue purus dis! Lundium urna in! Quis! Elementum enim nascetur eu sed aenean dapibus enim porta! Rhoncus adipiscing magnis scelerisque mid vel in sociis ac porttitor mus elementum amet sit. A hac adipiscing adipiscing in urna nec, rhoncus dapibus.</p>\n\n<p>\nIn mauris. Duis, rhoncus adipiscing elit! Eros elementum a habitasse est, mid tempor lundium turpis mauris mid. Nisi. Amet, cursus purus enim in dictumst? Odio adipiscing magnis et hac magna rhoncus, sed, nunc tortor risus? Rhoncus cursus! Ac et, tortor cum placerat nisi rhoncus dictumst porttitor dignissim lectus lorem dictumst, magna, cum elementum adipiscing, montes sit phasellus egestas odio odio dapibus. Adipiscing tincidunt nisi vut, augue hac, ac in turpis aliquam! Scelerisque porta porttitor nisi in dapibus etiam vel? Nascetur magna turpis placerat, vel nec pulvinar enim! Hac auctor enim pulvinar porttitor? Tortor, cum tristique sed phasellus ultrices enim integer cum eros, sed elit! Sit duis porttitor et risus lorem magnis, dictumst in. Cras integer nisi habitasse facilisis, sed.</p>\n<p>\nQuis et est platea nec sagittis tristique, nec amet? Vel lacus, facilisis, et, adipiscing scelerisque ac, platea, cursus magnis odio diam platea risus? Augue? Integer nec aliquet egestas vut elementum nunc lundium a, nascetur augue. Sit urna massa, quis ultrices dapibus? Integer scelerisque, adipiscing enim. Montes mattis tincidunt montes placerat tincidunt penatibus tincidunt vel rhoncus? Etiam sit in nunc, ut. Scelerisque amet velit mauris tincidunt augue lacus natoque, penatibus platea ac! Auctor lacus, vut. Sed, eros odio? Lundium nascetur, cursus platea! Cum ac? Sit sit risus non? Ac montes? Sed adipiscing sed facilisis hac, pellentesque in vel cum urna montes quis sed, urna habitasse vut risus mid, amet natoque placerat massa, dignissim in facilisis, dictumst, sed turpis sed magna.</p>', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
	(4, 'Habitasse tempor elementum parturient scelerisque elementum ', 'Habitasse tempor elementum parturient scelerisque elementum ', 'Habitasse tempor elementum parturient scelerisque elementum ', 'Habitasse tempor elementum parturient scelerisque elementum ', 'Habitasse tempor elementum parturient scelerisque elementum ', '2009-04-12', 1, '', '<p>Velit nunc tempor mattis pulvinar mattis. Et enim mus, etiam! Ridiculus a dolor! Adipiscing scelerisque velit? Ultricies turpis, amet tristique, sed. Dapibus scelerisque magna. Placerat, nec cum parturient porttitor tincidunt, adipiscing, scelerisque aliquam pid purus turpis sed vut in sagittis! Habitasse tempor sed parturient? Eros! Augue pellentesque magnis, in a tempor cursus. Ultricies sit sed scelerisque lundium, nascetur pellentesque nunc aenean ridiculus magna? Ac egestas. Rhoncus! Penatibus sed, aenean ac mattis nec, platea enim! Et, aliquam scelerisque mid cum est, facilisis augue turpis hac. Magnis est sit. Rhoncus, a! Integer, et. Nisi amet facilisis, aliquet sed! Sed dolor turpis, urna. Mauris mauris vel nisi augue cras scelerisque rhoncus, non sed ultricies etiam, cum lorem ut eros, cum phasellus, dignissim. Augue.</p>\n\n<p>\nEst lectus in quis, integer lorem integer dis sed nec a, ac adipiscing turpis, ridiculus nunc elit elit placerat natoque ac vut nec? Pulvinar quis platea pulvinar, tempor purus et, proin? Porta, mattis amet rhoncus dolor magna hac cursus? Scelerisque urna ultricies, augue, porttitor odio. Nec nunc, dapibus, amet odio duis! Dis amet rhoncus phasellus, elementum adipiscing, massa platea risus pulvinar. Vel eros arcu mauris porttitor? Ac, lacus. Sit purus aenean in augue non nisi diam turpis. Elementum in dapibus augue purus dis! Lundium urna in! Quis! Elementum enim nascetur eu sed aenean dapibus enim porta! Rhoncus adipiscing magnis scelerisque mid vel in sociis ac porttitor mus elementum amet sit. A hac adipiscing adipiscing in urna nec, rhoncus dapibus.</p>\n\n<p>\nIn mauris. Duis, rhoncus adipiscing elit! Eros elementum a habitasse est, mid tempor lundium turpis mauris mid. Nisi. Amet, cursus purus enim in dictumst? Odio adipiscing magnis et hac magna rhoncus, sed, nunc tortor risus? Rhoncus cursus! Ac et, tortor cum placerat nisi rhoncus dictumst porttitor dignissim lectus lorem dictumst, magna, cum elementum adipiscing, montes sit phasellus egestas odio odio dapibus. Adipiscing tincidunt nisi vut, augue hac, ac in turpis aliquam! Scelerisque porta porttitor nisi in dapibus etiam vel? Nascetur magna turpis placerat, vel nec pulvinar enim! Hac auctor enim pulvinar porttitor? Tortor, cum tristique sed phasellus ultrices enim integer cum eros, sed elit! Sit duis porttitor et risus lorem magnis, dictumst in. Cras integer nisi habitasse facilisis, sed.</p>\n<p>\nQuis et est platea nec sagittis tristique, nec amet? Vel lacus, facilisis, et, adipiscing scelerisque ac, platea, cursus magnis odio diam platea risus? Augue? Integer nec aliquet egestas vut elementum nunc lundium a, nascetur augue. Sit urna massa, quis ultrices dapibus? Integer scelerisque, adipiscing enim. Montes mattis tincidunt montes placerat tincidunt penatibus tincidunt vel rhoncus? Etiam sit in nunc, ut. Scelerisque amet velit mauris tincidunt augue lacus natoque, penatibus platea ac! Auctor lacus, vut. Sed, eros odio? Lundium nascetur, cursus platea! Cum ac? Sit sit risus non? Ac montes? Sed adipiscing sed facilisis hac, pellentesque in vel cum urna montes quis sed, urna habitasse vut risus mid, amet natoque placerat massa, dignissim in facilisis, dictumst, sed turpis sed magna.</p>', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
	(5, 'Platea magnis! Aliquam! Aliquam, turpis sit velit sociis pulvinar', 'Platea magnis_Aliquam_Aliquam, turpis sit velit sociis pulvinar', 'Platea magnis! Aliquam! Aliquam, turpis sit velit sociis pulvinar', 'Platea magnis! Aliquam! Aliquam, turpis sit velit sociis pulvinar', 'Platea magnis! Aliquam! Aliquam, turpis sit velit sociis pulvinar', '2004-11-21', 1, '', '<p>Velit nunc tempor mattis pulvinar mattis. Et enim mus, etiam! Ridiculus a dolor! Adipiscing scelerisque velit? Ultricies turpis, amet tristique, sed. Dapibus scelerisque magna. Placerat, nec cum parturient porttitor tincidunt, adipiscing, scelerisque aliquam pid purus turpis sed vut in sagittis! Habitasse tempor sed parturient? Eros! Augue pellentesque magnis, in a tempor cursus. Ultricies sit sed scelerisque lundium, nascetur pellentesque nunc aenean ridiculus magna? Ac egestas. Rhoncus! Penatibus sed, aenean ac mattis nec, platea enim! Et, aliquam scelerisque mid cum est, facilisis augue turpis hac. Magnis est sit. Rhoncus, a! Integer, et. Nisi amet facilisis, aliquet sed! Sed dolor turpis, urna. Mauris mauris vel nisi augue cras scelerisque rhoncus, non sed ultricies etiam, cum lorem ut eros, cum phasellus, dignissim. Augue.</p>\n\n<p>\nEst lectus in quis, integer lorem integer dis sed nec a, ac adipiscing turpis, ridiculus nunc elit elit placerat natoque ac vut nec? Pulvinar quis platea pulvinar, tempor purus et, proin? Porta, mattis amet rhoncus dolor magna hac cursus? Scelerisque urna ultricies, augue, porttitor odio. Nec nunc, dapibus, amet odio duis! Dis amet rhoncus phasellus, elementum adipiscing, massa platea risus pulvinar. Vel eros arcu mauris porttitor? Ac, lacus. Sit purus aenean in augue non nisi diam turpis. Elementum in dapibus augue purus dis! Lundium urna in! Quis! Elementum enim nascetur eu sed aenean dapibus enim porta! Rhoncus adipiscing magnis scelerisque mid vel in sociis ac porttitor mus elementum amet sit. A hac adipiscing adipiscing in urna nec, rhoncus dapibus.</p>\n\n<p>\nIn mauris. Duis, rhoncus adipiscing elit! Eros elementum a habitasse est, mid tempor lundium turpis mauris mid. Nisi. Amet, cursus purus enim in dictumst? Odio adipiscing magnis et hac magna rhoncus, sed, nunc tortor risus? Rhoncus cursus! Ac et, tortor cum placerat nisi rhoncus dictumst porttitor dignissim lectus lorem dictumst, magna, cum elementum adipiscing, montes sit phasellus egestas odio odio dapibus. Adipiscing tincidunt nisi vut, augue hac, ac in turpis aliquam! Scelerisque porta porttitor nisi in dapibus etiam vel? Nascetur magna turpis placerat, vel nec pulvinar enim! Hac auctor enim pulvinar porttitor? Tortor, cum tristique sed phasellus ultrices enim integer cum eros, sed elit! Sit duis porttitor et risus lorem magnis, dictumst in. Cras integer nisi habitasse facilisis, sed.</p>\n<p>\nQuis et est platea nec sagittis tristique, nec amet? Vel lacus, facilisis, et, adipiscing scelerisque ac, platea, cursus magnis odio diam platea risus? Augue? Integer nec aliquet egestas vut elementum nunc lundium a, nascetur augue. Sit urna massa, quis ultrices dapibus? Integer scelerisque, adipiscing enim. Montes mattis tincidunt montes placerat tincidunt penatibus tincidunt vel rhoncus? Etiam sit in nunc, ut. Scelerisque amet velit mauris tincidunt augue lacus natoque, penatibus platea ac! Auctor lacus, vut. Sed, eros odio? Lundium nascetur, cursus platea! Cum ac? Sit sit risus non? Ac montes? Sed adipiscing sed facilisis hac, pellentesque in vel cum urna montes quis sed, urna habitasse vut risus mid, amet natoque placerat massa, dignissim in facilisis, dictumst, sed turpis sed magna.</p>', '0000-00-00 00:00:00', '0000-00-00 00:00:00');
/*!40000 ALTER TABLE `texts_news_ru` ENABLE KEYS */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
