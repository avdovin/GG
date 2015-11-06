CREATE TABLE `anonymous_session` (
  `cck` varchar(32) NOT NULL,
  `time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `host` varchar(100) NOT NULL,
  `ip` varchar(100) NOT NULL,
  `data` blob,
  `user_id` int(6) unsigned DEFAULT NULL,
  PRIMARY KEY (`cck`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `captcha` (
  `code` varchar(100) NOT NULL,
  `time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`code`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

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
) ENGINE=MyISAM AUTO_INCREMENT=7 DEFAULT CHARSET=utf8 COMMENT='Хранилище рекламы';

CREATE TABLE `data_banner_advert_block` (
  `ID` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(128) NOT NULL DEFAULT '',
  `per_click` int(6) NOT NULL DEFAULT '0',
  `per_show` int(6) NOT NULL DEFAULT '0',
  `width` smallint(5) unsigned NOT NULL DEFAULT '0',
  `height` smallint(5) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`ID`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COMMENT='СПРАВОЧНИК рекламных блоков';

CREATE TABLE `data_banner_advert_users` (
  `ID` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL DEFAULT '',
  `email` varchar(50) NOT NULL DEFAULT '',
  `phone` varchar(100) NOT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `email` (`email`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COMMENT='Список пользователей банерокрут';

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
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

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
) ENGINE=MyISAM AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;

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
) ENGINE=MyISAM AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;

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
) ENGINE=MyISAM AUTO_INCREMENT=50 DEFAULT CHARSET=utf8;

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
) ENGINE=MyISAM AUTO_INCREMENT=86 DEFAULT CHARSET=cp1251 PACK_KEYS=0 COMMENT='Изображения для фотогалерей';

CREATE TABLE `data_feedback` (
  `ID` smallint(6) unsigned NOT NULL AUTO_INCREMENT,
  `l_name` varchar(150) NOT NULL,
  `f_name` varchar(255) NOT NULL,
  `phone` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `text` text NOT NULL,
  `created_at` datetime DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

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
) ENGINE=MyISAM AUTO_INCREMENT=9 DEFAULT CHARSET=cp1251 COMMENT='Отзывы';

CREATE TABLE `data_redirects` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `source_url` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `last_url` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `operator` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

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

CREATE TABLE `data_subscribe` (
  `ID` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL DEFAULT '',
  `subject` varchar(255) NOT NULL DEFAULT '',
  `send` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `stat` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `text` text NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=MyISAM AUTO_INCREMENT=27 DEFAULT CHARSET=cp1251;

CREATE TABLE `data_subscribe_groups` (
  `ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `data_subscribe_stat` (
  `ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `id_data_subscribe` int(11) NOT NULL DEFAULT '0',
  `id_user` int(11) NOT NULL DEFAULT '0',
  `send_date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`ID`),
  UNIQUE KEY `id_data_subscribe` (`id_data_subscribe`,`id_user`)
) ENGINE=MyISAM AUTO_INCREMENT=12 DEFAULT CHARSET=cp1251;

CREATE TABLE `data_subscribe_users` (
  `ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `email` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `id_group` int(10) unsigned NOT NULL DEFAULT '1',
  `cck` bigint(20) unsigned NOT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

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
) ENGINE=MyISAM AUTO_INCREMENT=7 DEFAULT CHARSET=utf8 PACK_KEYS=0 COMMENT='Таблица с паролями';

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
) ENGINE=MyISAM AUTO_INCREMENT=100 DEFAULT CHARSET=utf8;

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
) ENGINE=MyISAM AUTO_INCREMENT=2002 DEFAULT CHARSET=utf8 COMMENT='Статистика показов рекламы';

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
) ENGINE=MyISAM AUTO_INCREMENT=15 DEFAULT CHARSET=utf8;

CREATE TABLE `dtbl_search_results` (
  `idx` bigint(11) unsigned NOT NULL DEFAULT '0',
  `qsearch` varchar(255) NOT NULL DEFAULT '',
  `table` varchar(50) NOT NULL DEFAULT '',
  `controller` varchar(50) NOT NULL DEFAULT '',
  `tdate` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `primary_key` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`idx`,`qsearch`)
) ENGINE=MyISAM DEFAULT CHARSET=cp1251 COMMENT='Результаты поиска';

CREATE TABLE `dtbl_subscribe_stat` (
  `ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `id_data_subscribe` int(11) NOT NULL DEFAULT '0',
  `id_user` int(11) NOT NULL DEFAULT '0',
  `send_date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`ID`),
  UNIQUE KEY `id_data_subscribe` (`id_data_subscribe`,`id_user`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=cp1251;

CREATE TABLE `dtbl_subscribe_users` (
  `ID` bigint(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `cck` varchar(150) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

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
) ENGINE=MyISAM AUTO_INCREMENT=33 DEFAULT CHARSET=utf8 COMMENT='Ключи к модулю Access';INSERT INTO `keys_access` ( `ID`,`lkey`,`name`,`object`,`settings`,`tbl`,`updated_at`)  VALUES 
("1","modul","Модуль","lkey","type=tlist
list=sys_program
rating=1
group=2
table_list=1
filter=1
qview=1
help=Программный модуль, для которого действует данное право
","","2010-10-31 19:34:50"),("3","objecttype","Объект","lkey","type=list
list=|не определен~modul|Модуль~table|Таблица~lkey|Ключ~button|Кнопка~menu|Пункт главного меню
notnull=1
list_type=radio
group=1
rating=9
filter=1
required=1
table_list=2
qview=1
qedit=1
help=Тип объекта, для которого действительно данное правило
","","2010-10-31 19:34:46"),("4","id_group_user","Группа пользователей","lkey","type=tlist
list=lst_group_user
table_list=3
rating=5
group=3
qview=1
filter=1
help=Группа пользователей, для которых действительно данное правило","","2010-10-31 19:38:38"),("5","filter","Управление доступом. Фильтр","button","type_link=modullink
table_list=1
program=/cgi-bin/access_a.cgi
imageiconmenu=/admin/img/icons/menu/icon_filter.png
action=filter
title=Настроить фильтр
width=690
height=510
level=3
rating=2
params=replaceme","","0000-00-00 00:00:00"),("6","filter_clear","Управление доступом. Очистка фильтра","button","type_link=loadcontent
table_list=1
program=/cgi-bin/access_a.cgi
action=filter_clear
imageiconmenu=/admin/img/icons/menu/icon_nofilter.png
title=Снять фильтры
rating=3
params=replaceme","","0000-00-00 00:00:00"),("7","objectname","Названия объектов","lkey","type=list
list=objectname
group=3
rating=2
mult=7
nocheck=1
template_w=field_multselect
notnull=1
help=Перечень объектов, на которые распространяется данное правило. Выделите объекты и переведите их в правое окошко.","","2010-10-31 19:38:38"),("9","users","Пользователь","lkey","type=tlist
list=sys_users
group=3
table_list=4
rating=10
qview=1
filter=1
help=Пользователь, для которого действительно правило.","","2010-10-31 19:38:38"),("10","r","Права на чтение","lkey","type=chb
yes=да
no=нет
group=3
rating=11
qview=1
help=Пользователь может видеть выбранные объекты","","2010-10-31 19:38:38"),("11","w","Права на запись","lkey","type=chb
yes=да
no=нет
group=3
rating=12
qview=1
help=У пользователя есть право редактировать выбранные объекты","","2010-10-31 19:38:38"),("12","d","Права на удаление","lkey","type=chb
yes=да
no=нет
group=3
rating=13
qview=1
help=Пользователь может удалить выбранные объекты","","2010-10-31 19:38:38"),("13","name","Название","lkey","type=s","","2008-04-11 01:17:14"),("14","config_table","Таблица объектов","lkey","type=s","","2008-04-19 10:54:59"),("15","end_link","Закончить редактирование","button","type_link=loadcontent
edit_info=1
program=/cgi-bin/access_a.cgi
action=info
imageiconmenu=/admin/img/icons/menu/icon_ok.png
title=Закончить редактирование
rating=1
params=replaceme,index
","","0000-00-00 00:00:00"),("16","list_link","Список правил","button","type_link=loadcontent
add_info=1
program=/cgi-bin/access_a.cgi
imageiconmenu=/admin/img/icons/menu/button.list.png
action=enter
title=Список правил
rating=1
params=replaceme","","0000-00-00 00:00:00"),("17","edit_link","Редактировать запись","button","type_link=loadcontent
print_info=1
program=/cgi-bin/access_a.cgi
controller=access
action=edit
imageiconmenu=/admin/img/icons/menu/icon_edit.png
title=Редактировать запись
rating=2
params=replaceme,index","","0000-00-00 00:00:00"),("18","del_link","Удалить запись","button","type_link=loadcontent
program=/cgi-bin/access_a.cgi
action=delete
imageiconmenu=/admin/img/icons/menu/icon_delete.png
confirm=Действительно удалить запись?
title=Удалить запись
print_info=1
rating=1
params=replaceme,index","","0000-00-00 00:00:00"),("19","add_link","Добавить запись","button","type_link=openpage
position=center
id=newentry
table_list=1
print_info=1
program=/cgi-bin/access_a.cgi
imageiconmenu=/admin/img/icons/menu/icon_add.png
controller=access
action=add
title=Добавить запись
rating=1
params=replaceme","","0000-00-00 00:00:00"),("24","access_add","Добавить правило доступа","menu","type_link=loadcontent
action=add
program=/cgi-bin/access_a.cgi
rating=116
parentid=access
replaceme=replaceme","","0000-00-00 00:00:00"),("30","access","Права доступа","menu","type_link=loadcontent
action=enter
program=/cgi-bin/access_a.cgi
rating=16
parentid=setting
replaceme=replaceme
submenuwidth=200
","","0000-00-00 00:00:00"),("31","data","Данные","lkey","type=code
sys=1
","","0000-00-00 00:00:00"),("32","update_access","Обновить права","button","type_link=loadcontent
table_list=1
print_info=1
imageiconmenu=/admin/img/icons/menu/icon_change.png
controller=access
action=update_access
title=Обновить права
rating=4
params=replaceme","","");


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
) ENGINE=MyISAM AUTO_INCREMENT=64 DEFAULT CHARSET=utf8 COMMENT='Ключи к модулю Баннерокрутилка';INSERT INTO `keys_banners` ( `ID`,`lkey`,`name`,`object`,`settings`,`tbl`,`updated_at`)  VALUES 
("1","add_link","Добавить запись","button","type_link=openpage
position=center
id=newentry
table_list=1
controller=banners
imageiconmenu=/admin/img/icons/menu/icon_add.png
action=add
title=Добавить
rating=1
params=replaceme","","0000-00-00 00:00:00"),("3","del_link","Удалить запись","button","type_link=loadcontent
controller=banners
action=delete
confirm=Действительно удалить запись?
imageiconmenu=/admin/img/icons/menu/icon_delete.png
title=Удалить запись
print_info=1
rating=1
params=replaceme,index","","0000-00-00 00:00:00"),("4","edit_link","Редактировать запись","button","type_link=loadcontent
print_info=1
controller=banners
imageiconmenu=/admin/img/icons/menu/icon_edit.png
action=edit
title=Редактировать запись
rating=2
params=replaceme,index","","0000-00-00 00:00:00"),("5","end_link","Закончить редактирование","button","type_link=loadcontent
edit_info=1
controller=banners
imageiconmenu=/admin/img/icons/menu/icon_ok.png
action=info
title=Закончить редактирование
rating=10
params=replaceme,index","","0000-00-00 00:00:00"),("6","filter","Фильтр","button","type_link=modullink
table_list=1
table_list_view=1
controller=banners
imageiconmenu=/admin/img/icons/menu/icon_filter.png
action=filter
title=Фильтр
width=690
height=510
level=3
rating=2
params=replaceme","","0000-00-00 00:00:00"),("7","filter_clear","Очистка фильтра","button","type_link=loadcontent
table_list=1
table_list_view=1
controller=banners
imageiconmenu=/admin/img/icons/menu/icon_nofilter.png
action=filter_clear
title=Снять фильтры
rating=3
params=replaceme","","0000-00-00 00:00:00"),("10","name","Название баннера","lkey","type=s
filter=1
table_list=1
required=1
qview=1
qedit=1
group=1
rating=1
no_format=1
help=Название баннера предназначено для облегчения его дальнейшей идентификации в системе. Чем четче будет название, тем легче будет найти баннер среди прочих","","2010-09-13 15:28:12"),("11","view","Публиковать рекламу","lkey","type=chb
rating=110
group=1
filter=1
table_list=11
table_list_name=-
table_list_width=48
yes=Виден
no=Скрыт
qview=1
help=Для того, чтобы баннер показывался, необходимо установить данный влажок.","","2010-09-13 15:28:12"),("12","width","Ширина","lkey","type=d
group=2
qview=1
filter=1
required=1
table_list=4
table_list_name=W
table_list_width=32
rating=15
help=Ширина баннера. По умолчанию задается из размеров выбраного баннерого места
","","2010-09-13 15:28:29"),("58","per_click","Цена за клик","lkey","type=d
print=1
qview=1
qedit=1
rating=10
fileview=1
table_list=4
table_list_width=100
","","0000-00-00 00:00:00"),("13","height","Высота","lkey","type=d
group=2
rating=16
required=1
table_list=5
table_list_name=H
table_list_width=32
qview=1
filter=1
help=Высота баннера. По умолчанию задается из размеров выбраного баннерого места
","","2010-09-13 15:28:29"),("14","code","Код рекламного блока","lkey","type=code
group=2
rating=10
help=Если у вас готовый код, то воспользуйтесь данным полем. Все остальные поля заполнять в этом случае не надо.","","2010-09-13 15:28:29"),("15","cash","Бюджет","lkey","type=float
table_list=6
table_list_width=72
group=1
qedit=1
filter=1
rating=98
help=Доступное количество денег для открутки показов. Снимается сумма, которая прописана в настройках рекламного места и, в зависимости от типа показов, (за клики, за показы). Если выбран тип показа "без ограничения", то данное поле можно не заполнять","","2010-09-13 15:28:12"),("16","showdateend","Дата конца показов","lkey","type=date
group=3
rating=8
filter=1
help=Установите дату окончания показов, если показ баннера привязан к конкретному сроку (для коммерческих показов)","","2010-09-13 15:28:44"),("17","showdatefirst","Дата начала показов","lkey","type=date
group=3
rating=7
filter=1
help=Установите дату начала показов, если показ баннера привязан к конкретному сроку (для коммерческих показов)","","2010-09-13 15:28:44"),("18","link","URL-ссылка","lkey","type=site
group=1
rating=2
qview=1
help=Адрес ссылки, куда ведет баннер.
table_list=5
table_list_width=200
","","2010-09-13 15:28:12"),("20","type_show","Тип показа баннера","lkey","type=list
list=0|без ограничения~1|по показам~2|по переходам
list_type=radio
group=1
rating=99
filter=1
qview=1
help=Опция для коммерческого показа баннеров. В зависимости от выбранного типа расходуется (или не расходуется) рекламный бюджет","","2010-09-13 15:28:12"),("21","id_advert_users","Рекламодатель","lkey","type=tlist
list=data_banner_advert_users
add_to_list=1
win_scroll=0
win_height=100
rating=100
group=1
filter=1
width=650
height=300
help=Если баннерокрутилка используется для коммерческого показа баннеров, то указав рекламодателя, можно сделать ему доступ к статистике показов и переходов данного баннера.","","2010-09-13 15:28:12"),("22","textlink","Текст ссылки","lkey","type=text
group=2
rating=3
help=Если требуется показывать рекламную ссылку, а не графический баннер, то воспользуйтесь этим полем","","2010-09-13 15:28:29"),("23","size","Размер файла","lkey","type=d
shablon_w=field_input_read
rating=20
group=2
","","2009-04-19 00:18:01"),("24","type_file","Тип файла","lkey","type=slat
group=2
rating=21
table_list=2
table_list_name=-
table_list_nosort=1
table_list_width=16
shablon_w=field_input_read
","","2009-04-19 00:18:01"),("25","titlelink","Заголовок ссылки","lkey","type=s
group=2
rating=2
help=Текстовый баннер может состоять из заголовка и текста. Это поле предназначено для определения заголовка текстового рекламного блока","","2010-09-13 15:28:29"),("26","docfile","Картинка","lkey","type=pict
rating=1
group=2
table_list=3
table_list_name=-
table_list_type=pict
table_list_nosort=1
template_w=field_file
template_r=field_pict_read
folder=/image/bb/
sizelimit=20000
file_ext=*.jpg;*.jpeg;*.gif;*.swf;*.png
help=Баннер может быть загружен на сервер.","","2010-09-13 15:24:47"),("27","target","Постраничный таргетинг","lkey","type=list
list=0|на всех страницах~1|только на страницах~2|исключая страницы
list_type=radio
list_sort=asc_d
group=3
rating=10
help=Баннер может показываться на определенных страницах. Для этого выберите режим <b>Только на страницах</b> и в поле <b>Список страниц</b> укажите эти страницы. В режиме <b>Исключая страницы</b> баннер будет показан на всех страницах, за исключением тех, которые указаны в списке.","","2010-09-13 15:28:44"),("29","week","Дни недели","lkey","type=list
list=-1|Все дни~1|Понедельник~2|Вторник~3|Среда~4|Четверг~5|Пятница~6|Суббота~7|Воскресенье
list_type=checkbox
list_sort=asc_d
notnull=1
group=3
rating=4
help=Для коммерческого показа рекламы можно использовать таргетинг по дням. Если таргетинг по дням не используется, то установите флажок в положение "Все дни", в противном случае баннер показываться не будет","","2010-09-13 15:28:44"),("32","time","Время показов","lkey","type=list
list=-1|Все время&nbsp;&nbsp;&nbsp;~1|00:00-01:00~2|01:00-02:00~3|02:00-03:00~4|03:00-04:00~5|04:00-05:00~6|05:00-06:00~7|06:00-07:00~8|07:00-08:00~9|08:00-09:00~10|09:00-10:00~11|10:00-11:00~12|11:00-12:00~13|12:00-13:00~14|13:00-14:00~15|14:00-15:00~16|15:00-16:00~17|16:00-17:00~18|17:00-18:00~19|18:00-19:00~20|19:00-20:00~21|20:00-21:00~22|21:00-22:00~23|22:00-23:00~24|23:00-24:00
list_type=checkbox
list_sort=asc_d
notnull=1
group=3
rating=5
help=Для коммерческого показа рекламы можно использовать таргетинг по времени. Если таргетинг по времени не используется, то установите флажок в положение "Все время", в противном случае баннер показываться не будет","","2010-09-13 15:28:44"),("33","id_advert_block","Место","lkey","type=tlist
list=data_banner_advert_block
group=1
rating=6
filter=1
required=1
table_list=5
qview=1
shablon_w=field_multselect
notnull=1
help=Баннер можно привязать к нескольким местам, которые прописаны в системе и в шаблонах. Желательно соблюдать размерность баннера и места, на которое он размещается, чтобы не портить верстку макета страницы
","","2010-09-13 15:28:44"),("36","stat","Статистика","lkey","type=table
table=dtbl_banner_stat
group=4
rating=15
template_w=field_table
table_fields=tdate,view_count,view_pay,click_count,click_pay
table_svf=id_banner
table_sortfield=tdate
table_buttons_key_w=delete
table_groupname=Общая информация
table_noindex=1
help=Статистика показов и переходов за период. При клике по названию поля в таблице происходит сортировка по данному полю. Повторный клик приводит к обратной сортировке ","","2009-04-19 00:18:01"),("37","click_pay","Списано за клики","lkey","type=d
floor=1
rating=31
group=1","","2008-08-13 15:48:49"),("38","click_count","Кол-во переходов","lkey","type=d
group=1
rating=2","","2008-08-13 15:48:49"),("39","view_pay","Списано за показы","lkey","type=d
floor=1
rating=30
group=1","","2008-08-13 15:48:49"),("40","view_count","Кол-во просмотров","lkey","type=d
group=1
rating=1","","2008-08-13 15:48:49"),("41","tdate","Дата","lkey","type=date
rating=7
group=1
shablon_w=field_input_read","","0000-00-00 00:00:00"),("42","filename","Файл","lkey","type=filename
rating=2
sizelimit=20000
file_ext=*.*","","2010-09-13 15:24:08"),("43","deletepict","Флаг удаления картинки","lkey","type=chb
sys=1","","2008-10-26 13:53:51"),("44","list_page","Список страниц","lkey","type=tlist
list=texts_main_ru
sort=1
rating=22
group=3
mult=5
request_url=/admin/banners/body
notdef=1
template_w=field_multselect_input
help=Данное поле работает в паре с полем <b>Постраничный таргетинг</b>. Для выбора страниц нажмите на ссылку <b>Расширенный поиск</b>, расположенную слева. Появятся несколько дополнительных полей. В поле <b>поиск</b> введите подстроку, содержащуюся в названии страницы. В поле <b>доступные значения</b> появятся документы, которые содержат данную подстроку. При помощи кнопок со стрелками, расположенными справа, перенесите нужные страницы во второе поле <b>Выбранные значения</b>. Из последнего поля можно удалить документы, воспользовавшись соответствующими кнопками справа.
","","2010-09-13 15:28:44"),("45","show","Флаг показать","lkey","type=s
sys=1","","2009-04-29 17:55:04"),("46","hide","Флаг скрыть","lkey","type=s
sys=1","","0000-00-00 00:00:00"),("47","texts_main_ru","ключ","lkey","type=tlist
list=texts_main_ru","","0000-00-00 00:00:00"),("48","id_banner","Баннер","lkey","type=tlist
list=data_banner
sort=1
sys=1","","2009-04-17 12:43:22"),("50","list_link","Список","button","type_link=loadcontent
add_info=1
controller=banners
imageiconmenu=/admin/img/icons/menu/button.list.png
action=enter
title=Список
rating=1
params=replaceme","","0000-00-00 00:00:00"),("51","rating","Рейтинг","lkey","type=d
group=1
filter=1
rating=15
table_list=9
table_list_name=Rt
table_list_width=32
qedit=1
qview=1
shablon_w=field_rating
help=При прочих равных условиях, чем меньше рейтинг, тем чаще будет показываться баннер. Используется, если на одно место прописано несколько баннеров","","2010-09-13 15:28:12"),("52","index","Индекс","lkey","type=d
sys=1","","2010-10-27 16:37:28"),("53","ip_data_click","IP адреса","lkey","type=code
print=1
qview=1
rating=99
group=1
","","0000-00-00 00:00:00"),("54","name","Имя рекламодателя","lkey","type=s
filter=1
table_list=1
required=1
qview=1
qedit=1
group=1
rating=1
no_format=1
","lst_advert_users","0000-00-00 00:00:00"),("55","email","E-mail","lkey","type=email
print=1
qview=1
qedit=1
rating=5
table_list=4
table_list_width=100
","","0000-00-00 00:00:00"),("56","phone","Телефон","lkey","type=s
print=1
qview=1
qedit=1
rating=5
table_list=3
table_list_width=100
","","0000-00-00 00:00:00"),("57","targetblank","Открывать в новом окне","lkey","type=chb
print=1
qview=1
qedit=1
rating=1
filter=1
qview=1
rating=3
group=1
yes=Да
no=Нет
help=Если указана URL-ссылка, то она будет открываться в новом окне","","0000-00-00 00:00:00"),("59","per_show","Цена за показ","lkey","type=d
print=1
qview=1
qedit=1
rating=11
fileview=1
table_list=5
table_list_width=100
","","0000-00-00 00:00:00"),("60","langs","Языковые версии","lkey","type=list
list_out=lang
#list=ru|Русский~en|English
notnull=1
list_type=checkbox
rating=101
filter=1
table_list=10
table_list_width=100
fileview=1
qedit=1
qview=1
","","0000-00-00 00:00:00"),("61","copy","Копировать запись","button","type_link=loadcontent
print_info=1
edit_info=1
loading_msg=1
controller=banners
action=copy
imageiconmenu=/admin/img/icons/menu/icon_copy.png
title=Копировать запись
rating=5
params=replaceme,index,list_table","","0000-00-00 00:00:00"),("62","target_url","Таргетинг по URL","lkey","type=list
list=0|на всех страницах~1|только на страницах~2|исключая страницы
list_type=radio
list_sort=asc_d
group=3
rating=25
help=Баннер может показываться на определенных URL","","0000-00-00 00:00:00"),("63","urls","URL страниц","lkey","type=tlist
list=lst_banner_urls
template_w=field_multselect_input
group=3
mult=5
add_to_list=1
rating=26
","","2014-08-25 13:33:28");


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
) ENGINE=MyISAM AUTO_INCREMENT=63 DEFAULT CHARSET=utf8 COMMENT='Ключи к модулю Тексты';INSERT INTO `keys_catalog` ( `ID`,`lkey`,`name`,`object`,`settings`,`tbl`,`updated_at`)  VALUES 
("1","add_link","Добавить запись","button","type_link=openpage
position=center
id=newentry
table_list=1
print_info=1
edit_info=1
controller=catalog
action=add
imageiconmenu=/admin/img/icons/menu/icon_add.png
title=Добавить
rating=1
params=replaceme,list_table","","0000-00-00 00:00:00"),("2","del_link","Удалить запись","button","type_link=loadcontent
controller=catalog
action=delete
confirm=Действительно удалить запись?
title=Удалить запись
imageiconmenu=/admin/img/icons/menu/icon_delete.png
print_info=1
rating=1
params=replaceme,index,list_table","","0000-00-00 00:00:00"),("3","edit_link","Редактировать запись","button","type_link=loadcontent
print_info=1
controller=catalog
action=edit
imageiconmenu=/admin/img/icons/menu/icon_edit.png
title=Редактировать запись
rating=2
params=replaceme,index,list_table","","0000-00-00 00:00:00"),("4","end_link","Закончить редактирование","button","type_link=loadcontent
edit_info=1
controller=catalog
action=info
imageiconmenu=/admin/img/icons/menu/icon_ok.png
title=Закончить редактирование
rating=10
params=replaceme,index,list_table
","","0000-00-00 00:00:00"),("5","filter","Фильтр","button","type_link=modullink
table_list=1
table_list_orders=1
controller=catalog
action=filter
imageiconmenu=/admin/img/icons/menu/icon_filter.png
title=Фильтр
width=690
height=510
level=3
rating=2
params=replaceme,list_table","","0000-00-00 00:00:00"),("6","filter_clear","Очистка фильтра","button","type_link=loadcontent
table_list=1
table_list_orders=1
table_list_dir=1
controller=catalog
action=filter_clear
imageiconmenu=/admin/img/icons/menu/icon_nofilter.png
title=Снять фильтры
rating=3
params=replaceme,list_table","","0000-00-00 00:00:00"),("7","name","Название","lkey","type=s
filter=1
group=1
rating=1
required=1
qedit=1
table_list=1
no_format=1
fileview=1
","","2010-10-31 11:29:29"),("8","text","Текст - правый блок","lkey","type=html
print=1
group=2
rating=201
","","0000-00-00 00:00:00"),("9","rating","Рейтинг","lkey","type=d
group=1
qview=1
qedit=1
table_list=10
table_list_name=Rt
table_list_width=32
rating=99
template_w=field_rating
","","0000-00-00 00:00:00"),("10","images","Фото","lkey","type=table
table=dtbl_catalog_items_images
group=3
rating=15
template_w=field_table
table_fields=name,pict,rating
table_svf=id_item
table_sortfield=rating
table_buttons_key_w=delete,edit
table_groupname=Общая информация
table_noindex=1
table_add=1
","","0000-00-00 00:00:00"),("11","pict","Картинка","lkey","type=pict
rating=14
template_w=field_pict
template_r=field_pict_read
sizelimit=20000
ext=*.jpg;*.jpeg;*.gif;
mini=188x180~crop,250x333~montage,550x733~montage,102x136~crop
folder=/image/catalog/items/
fileview=1
table_list=4
table_list_type=pict
table_list_name=-
","","0000-00-00 00:00:00"),("12","pict","Картинка","lkey","type=pict
rating=14
sizelimit=20000
ext=*.jpg;*.jpeg;*.gif;
mini=102x136~crop,550x733~montage
folder=/image/catalog/items/dopimgs/
fileview=1
table_list=4
table_list_type=pict
table_list_name=-


","dtbl_catalog_items_images","0000-00-00 00:00:00"),("13","id_item","Товар","lkey","type=tlist
list=data_catalog_items
sys=1
","","0000-00-00 00:00:00"),("14","recommend","Рекомендуемые товары","lkey","type=tlist
list=data_catalog_items
template_w=field_multselect_input
select_help=1
rating=80
group=1
fileview=1

","","0000-00-00 00:00:00"),("15","alias","Алиас","lkey","type=s
rating=2
table_list=2
group=1
filter=1
qview=1
qedit=1
required=1
help=Короткое латинское название, которое учавствует в формирование URL для данной страницы","","0000-00-00 00:00:00"),("16","active","Публиковать на сайте","lkey","type=chb
print=1
qview=1
qedit=1
filter=1
table_list=10
table_list_name=-
table_list_width=48
yes=Виден
no=Скрыт
rating=99
","","0000-00-00 00:00:00"),("47","parent_category_id","Родительская категория","lkey","type=tlist
list=data_catalog_categories
print=1
qview=1
qedit=1
filter=1
table_list=4
table_list_width=200
rating=10
where= AND parent_category_id=0


","data_catalog_categorys","0000-00-00 00:00:00"),("18","pict","Картинка","lkey","type=pict
rating=14
template_w=field_pict
template_r=field_pict_read
sizelimit=20000
ext=*.jpg;*.jpeg;*.gif;
mini=317x103~crop
folder=/image/catalog/categories/
fileview=1
table_list=4
table_list_type=pict
table_list_name=-
","data_catalog_categorys","0000-00-00 00:00:00"),("19","category_id","Категория","lkey","type=tlist
list=data_catalog_categories
print=1
qview=1
qedit=1
filter=1
table_list=4
table_list_width=200
rating=9

","","0000-00-00 00:00:00"),("20","price","Цена","lkey","type=float
print=1
qview=1
qedit=1
rating=10
table_list=7
table_list_widht=100
rating=15
required=1


","","0000-00-00 00:00:00"),("21","articul","Артикул","lkey","type=s
print=1
rating=12
fileview=1
table_list=7
table_list_width=100
qedit=1
qview=1
print=1
","","0000-00-00 00:00:00"),("52","pict","Картинка","lkey","type=pict
rating=14
sizelimit=20000
ext=*.jpg;*.jpeg;*.gif;
mini=122x122~montage,269x269~montage
folder=/image/catalog/brands/
fileview=1
table_list=4
table_list_type=pict
table_list_name=-


","data_catalog_brands","0000-00-00 00:00:00"),("23","keywords","Ключевые слова","lkey","type=s
rating=3
group=1
filter=1
qedit=1
help=Ключевые слова и выражения, разделенные запятой, которые соответствуют данному тексту. Используется для оптимизации страницы под поисковые системы. Указанные слова в данном поле должны обязательно присутствовать в тексте — в противном случае они не будут учитываться поисковыми машинами.
dirview=1
fileview=1","","2010-10-29 12:23:39"),("24","description","Краткое описание страницы","lkey","type=text
rating=3
group=1
qview=1
help=Краткое описание текста. Используется для поисковых систем. Выводится на странице в meta-теге description. Как правило, пользователь данный текст не видет. Для поисковых систем полезнее для каждой страницы формировать свое описание, наиболее соответствующее данной странице.
dirview=1
fileview=1","","2010-10-29 12:23:39"),("25","title","Заголовок окна","lkey","type=s
no_format=1
rating=2
group=1
qview=1
qedit=1
help=Заголовок окна браузера. Может отличаться от названия текста. Используется для оптимизации под поисковые системы.
dirview=1
fileview=1","","2010-10-29 12:23:39"),("26","copy","Копировать запись","button","type_link=loadcontent
print_info=1
edit_info=1
loading_msg=1
controller=catalog
action=copy
imageiconmenu=/admin/img/icons/menu/icon_copy.png
title=Копировать запись
rating=5
params=replaceme,index,list_table
","","0000-00-00 00:00:00"),("27","comment","Комментарий","lkey","type=text
print=1
qview=1
rating=90
fileview=1
","","0000-00-00 00:00:00"),("28","operator_comment","Комментарий оператора","lkey","type=text
print=1
qview=1
rating=95
fileview=1
","","0000-00-00 00:00:00"),("29","name","Название","lkey","type=s
filter=1
group=1
rating=1
qedit=1
table_list=1
no_format=1
fileview=1
","dtbl_catalog_items_images","2010-10-31 11:29:29"),("30","text_bottom","Текст - нижний блок","lkey","type=html
print=1
group=2
rating=202

","","0000-00-00 00:00:00"),("31","order","Товары","lkey","type=table
table=dtbl_orders
group=2
rating=201
table_fields=pict,id_item,articul,name,price,totalprice,count,size,footsize
table_svf=id_order
table_sortfield=name
table_buttons_key_w=delete_select,edit
table_buttons_key_r=
table_groupname=Информация по файлу
table_icontype=1
table_noindex=1
shablon_w=field_table
shablon_r=field_table","","2011-10-27 09:47:47"),("62","name","ФИО","lkey","type=s
filter=1
group=1
rating=1
required=1
qedit=1
table_list=1
no_format=1
fileview=1
","data_catalog_orders","2010-10-31 11:29:29"),("33","color","Цвет","lkey","type=tlist
list=lst_catalog_colors
template_w=field_list_read
rating=82
group=1
fileview=1
","","0000-00-00 00:00:00"),("34","count","Кол-во","lkey","type=d
print=1
qview=1
qedit=1
rating=4
fileview=1
","","0000-00-00 00:00:00"),("35","totalprice","Сумма","lkey","type=float
print=1
qview=1
qedit=1
rating=11
table_list=8
table_list_widht=100
rating=15
required=1


","","0000-00-00 00:00:00"),("36","city","Город","lkey","type=s
print=1
qview=1
qedit=1
table_list=5
table_list_widht=200
rating=31



","","0000-00-00 00:00:00"),("37","phone","Телефон","lkey","type=s
print=1
qview=1
qedit=1
table_list=5
table_list_widht=200
rating=11



","","0000-00-00 00:00:00"),("38","email","E-mail","lkey","type=s
print=1
qview=1
qedit=1
table_list=6
table_list_widht=200
rating=12



","","0000-00-00 00:00:00"),("39","orderstatus","Статус заказа","lkey","type=list
list=0|Новый~1|Проверен~2|Выполнен~3|Закрыт
list_type=radio
table_list=7
table_list_width=100
filter=1
qedit=1
qview=1
print=1
","","0000-00-00 00:00:00"),("40","is_new","Новинка","lkey","type=chb
print=1
qview=1
filter=1
rating=90
table_list=7
table_list_width=70
yes=да
no=нет
qedit=1
","","0000-00-00 00:00:00"),("41","is_sale","Распродажа","lkey","type=chb
print=1
qview=1
filter=1
rating=91
table_list=8
table_list_width=70
yes=да
no=нет
qedit=1
","","0000-00-00 00:00:00"),("42","brand_id","Бренд","lkey","type=tlist
list=data_catalog_brands
print=1
qview=1
qedit=1
filter=1
table_list=5
table_list_width=200
rating=11

","","0000-00-00 00:00:00"),("43","sizes","Размеры товара","lkey","type=s
print=1
qview=1
qedit=1
table_list=6
table_list_width=150
rating=50
fileview=1
","","0000-00-00 00:00:00"),("44","parent_category_id","Подкатегория","lkey","type=tlist
list=data_catalog_categories
print=1
qview=1
qedit=1
filter=1
table_list=4
table_list_width=200
rating=10
#where= AND parent_category_id>0


","","0000-00-00 00:00:00"),("45","color_id","Цвет","lkey","type=tlist
list=lst_catalog_colors
print=1
filter=1
table_list=7
table_list_width=100
qview=1
qedit=1
rating=45
fileview=1
add_to_list=1
","","0000-00-00 00:00:00"),("46","gender","Пол","lkey","type=list
list=1|Мужское~2|Женское~3|Детское
notnull=1
rating=10
fileview=1
qview=1
qedit=1
rating=40
filter=1
table_list=9
table_list_width=70
list_type=radio
required=1
","","0000-00-00 00:00:00"),("48","category_id","Категория","lkey","type=tlist
list=data_catalog_categories
print=1
qview=1
qedit=1
filter=1
table_list=4
table_list_width=200
rating=9
where= AND parent_category_id=0
rules=parent_category_id:data_catalog_categories.parent_category_id=index
required=1
","data_catalog_items","0000-00-00 00:00:00"),("49","parent_category_id","Подкатегория","lkey","type=tlist
list=data_catalog_categories
print=1
qview=1
qedit=1
filter=1
table_list=4
table_list_width=200
rating=10
where= AND parent_category_id>0
required=1


","data_catalog_items","0000-00-00 00:00:00"),("50","sostav","Состав","lkey","type=s
print=1
qview=1
qedit=1
rating=55
fileview=1
","","0000-00-00 00:00:00"),("51","subcategory_id","Подкатегория","lkey","type=tlist
list=data_catalog_categories
print=1
qview=1
qedit=1
filter=1
table_list=4
table_list_width=200
rating=10
where= AND parent_category_id>0
required=1


","","0000-00-00 00:00:00"),("53","pict_logo","Лого","lkey","type=pict
rating=20
sizelimit=20000
ext=*.png;
folder=/image/catalog/brands/logo/
fileview=1
table_list=6
table_list_type=pict
table_list_name=Лого
origin=1


","","0000-00-00 00:00:00"),("54","pict_logo_hover","Лого ЧБ","lkey","type=pict
rating=21
sizelimit=20000
ext=*.png;
folder=/image/catalog/brands/logo/
fileview=1
table_list=7
table_list_type=pict
table_list_name=Лого ЧБ
origin=1


","","0000-00-00 00:00:00"),("55","addressindex","Индекс","lkey","type=s
print=1
qview=1
qedit=1
rating=30","","0000-00-00 00:00:00"),("56","street","Улица","lkey","type=s
print=1
qview=1
qedit=1
rating=32","","0000-00-00 00:00:00"),("57","house","Дом","lkey","type=s
print=1
qview=1
qedit=1
rating=33","","0000-00-00 00:00:00"),("58","korpus","Корпус","lkey","type=s
print=1
qview=1
qedit=1
rating=34","","0000-00-00 00:00:00"),("59","apartment","Квартира","lkey","type=s
print=1
qview=1
qedit=1
rating=35","","0000-00-00 00:00:00"),("60","ordercomment","Комментарий","lkey","type=text
print=1
rating=50
fileview=1
qview=1
","","0000-00-00 00:00:00"),("61","operatorcomment","Комментарий оператора","lkey","type=text
print=1
rating=51
fileview=1
qview=1
","","0000-00-00 00:00:00");


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
) ENGINE=MyISAM AUTO_INCREMENT=82 DEFAULT CHARSET=cp1251 COMMENT='Ключи к модулю Тексты';INSERT INTO `keys_faq` ( `ID`,`lkey`,`name`,`object`,`settings`,`tbl`,`updated_at`)  VALUES 
("62","add_link","Добавить запись","button","type_link=openpage
position=center
id=newentry
table_list=1
print_info=1
controller=faq
action=add
imageiconmenu=/admin/img/icons/menu/icon_add.png
title=Добавить
rating=1
params=replaceme","","0000-00-00 00:00:00"),("61","del_link","Удалить запись","button","type_link=loadcontent
controller=faq
action=delete
imageiconmenu=/admin/img/icons/menu/icon_delete.png
confirm=Действительно удалить запись?
title=Удалить запись
print_info=1
rating=1
params=replaceme,index","","0000-00-00 00:00:00"),("60","edit_link","Редактировать запись","button","type_link=loadcontent
print_info=1
controller=faq
action=edit
imageiconmenu=/admin/img/icons/menu/icon_edit.png
title=Редактировать запись
rating=2
params=replaceme,index","","0000-00-00 00:00:00"),("59","end_link","Закончить редактирование","button","type_link=loadcontent
edit_info=1
controller=faq
action=info
imageiconmenu=/admin/img/icons/menu/icon_ok.png
title=Закончить редактирование
rating=10
params=replaceme,index
","","0000-00-00 00:00:00"),("58","filter","Фильтр","button","type_link=modullink
table_list=1
controller=faq
action=filter
imageiconmenu=/admin/img/icons/menu/icon_filter.png
title=Фильтр
width=690
height=510
level=3
rating=2
params=replaceme","","0000-00-00 00:00:00"),("57","filter_clear","Очистка фильтра","button","type_link=loadcontent
table_list=1
program=/cgi-bin/faq_a.cgi
imageiconmenu=/admin/img/icons/menu/icon_nofilter.png
action=filter_clear
title=Снять фильтры
rating=3
params=replaceme","","0000-00-00 00:00:00"),("56","list_link","Список","button","type_link=loadcontent
add_info=1
controller=faq
action=enter
imageiconmenu=/admin/img/icons/menu/button.list.png
title=Список
rating=1
params=replaceme","","0000-00-00 00:00:00"),("44","quest_date","Дата вопроса","lkey","type=time
rating=5
table_list=6
table_list_name=Дата
shablon_w=field_time_exp
group=1
fileview=1
dirview=1","","0000-00-00 00:00:00"),("18","keywords","Ключевые слова","lkey","type=s
rating=10
group=1
filter=1
","","2008-10-30 17:15:04"),("20","active","Публиковать","lkey","type=chb
rating=99
table_list=5
table_list_name=-
table_list_width=48
yes=Виден
no=Скрыт
group=1
filter=1
fileview=1
dirview=1","","2011-04-04 15:00:44"),("22","tdate","Датировать датой","lkey","type=time
rating=7
table_list=6
table_list_name=Дата
shablon_w=field_time_exp
group=1
filter=1
fileview=1
dirview=1","","2008-10-30 17:15:04"),("34","show","Флаг показать","lkey","type=s
sys=1","","2011-04-04 15:52:08"),("35","hide","Флаг скрыть","lkey","type=s
sys=1","","2011-04-04 15:52:05"),("36","day","День","lkey","type=d","","0000-00-00 00:00:00"),("37","month","Месяц","lkey","type=d","","0000-00-00 00:00:00"),("38","year","Год","lkey","type=d","","0000-00-00 00:00:00"),("39","author_name","Имя","lkey","type=s
table_list=1
filter=1
group=1
rating=1
no_format=1
required=1
qview=1
shablon_reg=field_input
shablon_view=field_input_read
editform=1
saveform=1
obligatory=1","","2011-04-04 15:00:44"),("41","name","Вопрос","lkey","type=text
group=1
rating=6
shablon_reg=field_text
shablon_view=field_text_read
editform=1
saveform=1
obligatory=1
obligatory_rules=validate[required]
cktoolbar=Basic

","","2011-04-04 15:00:44"),("42","answer","Ответ","lkey","type=html
group=1
rating=90
cktoolbar=Basic
","","2010-07-23 14:29:28"),("45","answer_date","Дата ответа","lkey","type=time
rating=5
table_list=6
table_list_name=Дата
shablon_w=field_time_exp
group=1
","","0000-00-00 00:00:00"),("48","number","Поле подтверждения по картинке","lkey","type=d
rating=90
group=1
obligatory=1
#regform=1
#editform=1
shablon_reg=field_imgconfirm","regform","0000-00-00 00:00:00"),("49","code","Код на картинке","lkey","type=d
sys=1","","0000-00-00 00:00:00"),("71","answer_name","Автор ответа","lkey","type=s
filter=1
group=1
rating=2
no_format=1
qview=1","","2010-07-23 14:29:20"),("76","email","E-mail","lkey","type=s
table_list=1
filter=1
group=1
rating=3
no_format=1
required=1
qview=1
editform=1
saveform=1
obligatory=1
","","2011-04-04 15:00:44"),("77","quest_anons","Тема вопроса","lkey","type=s
print=1
qview=1
rating=5
qview=1
table_list=5
table_list_width=100
required=1
next_td=1


","","2011-04-04 15:00:44"),("80","phone","Телефон","lkey","type=s
table_list=1
filter=1
group=1
rating=3
no_format=1
qview=1
saveform=1
","","0000-00-00 00:00:00"),("81","copy","Копировать запись","button","type_link=loadcontent
print_info=1
edit_info=1
controller=faq
action=copy
loading_msg=1
imageiconmenu=/admin/img/icons/menu/icon_copy.png
title=Копировать запись
rating=5
params=replaceme,index,list_table","","0000-00-00 00:00:00");


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
) ENGINE=MyISAM AUTO_INCREMENT=17 DEFAULT CHARSET=cp1251 COMMENT='Ключи к модулю Тексты';INSERT INTO `keys_feedback` ( `ID`,`edate`,`lkey`,`name`,`object`,`settings`,`tbl`)  VALUES 
("1","0000-00-00 00:00:00","number","Поле подтверждения по картинке","lkey","type=d
rating=90
group=1
obligatory=1
regform=1
editform=1
shablon_reg=field_imgconfirm
",""),("8","0000-00-00 00:00:00","index","Индекс","lkey","sys=1",""),("3","0000-00-00 00:00:00","name","ФИО","lkey","type=s
rating=1
keys_read=1
shablon_reg=field_input
shablon_view=field_input_read
editform=1
saveform=1
obligatory=1
obligatory_rules=validate[required,custom[noSpecialCaracters],length[0,255]]",""),("5","0000-00-00 00:00:00","code","Код на картинке","lkey","type=d
sys=1",""),("6","0000-00-00 00:00:00","lang","Язык сайта","lkey","type=list
list=lang
rating=20",""),("7","0000-00-00 00:00:00","ftext","Ваше сообщение","lkey","type=text
rating=5
keys_read=1
shablon_reg=field_text
shablon_view=field_input_read
vacancy=1
editform=1
saveform=1
obligatory=1
obligatory_rules=validate[required]",""),("11","0000-00-00 00:00:00","send","флаг отсылки","lkey","type=d
sys=1",""),("14","0000-00-00 00:00:00","email","E-mail","lkey","type=email
rating=4
keys_read=1
shablon_reg=field_input
shablon_view=field_input_read
editform=1
saveform=1
obligatory=1
obligatory_rules=validate[required,custom[email]]",""),("15","0000-00-00 00:00:00","subject","Тема сообщения","lkey","type=s
rating=5
keys_read=1
shablon_reg=field_input
shablon_view=field_input_read
#editform=1
#saveform=1
obligatory_rules=validate[optional]",""),("16","0000-00-00 00:00:00","phone","Телефон","lkey","type=s
rating=3
keys_read=1
shablon_reg=field_input
shablon_view=field_input_read
editform=1
saveform=1
","");


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
) ENGINE=MyISAM AUTO_INCREMENT=135 DEFAULT CHARSET=utf8 COMMENT='Глобальные ключи';INSERT INTO `keys_global` ( `ID`,`lkey`,`name`,`object`,`settings`,`tbl`,`updated_at`)  VALUES 
("1","action","Ключ функции","lkey","type=slat","","2008-01-17 03:42:23"),("2","index","Индекс","lkey","type=d","","2008-01-12 20:31:32"),("3","rdate","Дата создания","lkey","type=datetime
template_w=field_input_read
group=1
rating=200","","2009-02-05 02:01:30"),("4","edate","Дата редактирования","lkey","type=datetime
template_w=field_input_read
group=1
rating=199","","0000-00-00 00:00:00"),("5","rndval","Случайная переменная","lkey","type=d
sys=1","","2008-01-17 03:42:23"),("6","sfield","Поле сортировки","lkey","type=s","","2008-01-12 20:31:32"),("7","page","Страница","lkey","type=d","","2008-01-12 20:31:32"),("8","asc","Порядок сортировки","lkey","type=slat","","2008-01-12 20:31:32"),("9","pcol","Количество записей на страницу","lkey","type=d","","2008-01-12 20:31:32"),("10","lang","Язык сайта","lkey","type=list
list=ru|Русский
notnull=1
","","2008-02-15 13:31:34"),("12","id_program","Программный модуль","lkey","type=tlist
list=sys_program
sort=1
rating=2
filter=1
qview=1","","2007-12-06 21:23:35"),("13","envkey","Ключ","lkey","type=slat
rating=3
qview=1","","2007-12-06 21:23:35"),("14","envvalue","Значение переменной","lkey","type=text
rating=4
qview=1","","2007-12-06 21:23:35"),("15","help","Подсказка","lkey","type=s
rating=4","","2007-12-06 21:23:35"),("16","types","Тип поля","lkey","type=list
list=s|Строка~slat|Строка-латиница~list|Список(выпадающий)~chb|Чебокс(да/нет)~list_chb|Список(множественный выбор)~list_radio|Список(единичный выбор)~email|e-mail~d|Число~code|Программный код~text|Текст~html|HTML текст~pict|Картинка~file|Файл
rating=3
list_sort=asc_d","","2007-12-06 21:23:35"),("18","set_def","Значение по умолчнию","lkey","type=text
rating=7","","2007-12-06 21:23:35"),("19","listindex","Список индексов","lkey","type=s
sys=1","","2007-05-08 20:40:34"),("20","lkey","Ключ","lkey","type=slat","","2007-06-05 03:42:33"),("21","tbl","Таблица","lkey","type=slat","","2007-06-05 03:42:33"),("22","modul","Программа (модуль)","lkey","type=slat","","2007-06-05 03:42:33"),("23","login","Логин","lkey","type=login
rating=4","","2008-02-29 03:03:10"),("24","pwd","Пароль","lkey","type=slat","","2008-02-29 03:03:10"),("25","leftwin_hidden","Включать левую панель","lkey","type=chb
yes=включать
не включать
sys=1","","0000-00-00 00:00:00"),("26","rightwin_hidden","Включать правую панель","lkey","type=chb
yes=включать
не включать
sys=1","","0000-00-00 00:00:00"),("34","delete","Флаг удаления","lkey","type=d","","2008-03-13 22:08:22"),("35","replaceme","Контейнер для вставки информации","lkey","type=s
sys=1","","2008-03-16 04:07:49"),("33","qsearch","Строка быстрого поиска","lkey","type=s","","2008-03-12 15:30:36"),("36","group","Группа","lkey","type=d
sys=1","","2008-03-17 01:14:18"),("37","pid","Индекс родительского объекта","lkey","type=d","","2008-01-12 20:31:32"),("38","first_flag","Флаг первого открытия","lkey","type=d
sys=1","","0000-00-00 00:00:00"),("39","key_program","Ключ программы","lkey","type=s
sys=1","","0000-00-00 00:00:00"),("40","keystring","Подстрока поиска","lkey","type=s
sys=1","","0000-00-00 00:00:00"),("41","listfields","Поле","lkey","type=s
sys=1","","0000-00-00 00:00:00"),("42","rules","Правила связки полей","lkey","type=s
sys=1","","0000-00-00 00:00:00"),("43","flag_win","Флаг открытия в модальном окне","lkey","type=chb
sys=1
yes=да
no=нет","","0000-00-00 00:00:00"),("44","lfield","Поле","lkey","type=s
sys=1","","0000-00-00 00:00:00"),("45","dop_table","Дополнительная таблица","lkey","type=s
sys=1","","0000-00-00 00:00:00"),("46","access_flag","Доступ","lkey","type=s
sys=1","","0000-00-00 00:00:00"),("47","cck","Ключ сессии","lkey","type=s
sys=1","","0000-00-00 00:00:00"),("48","Upload","Файл","lkey","type=file
sys=1","","0000-00-00 00:00:00"),("49","Filename","Имя файла","lkey","type=filename
sys=1","","0000-00-00 00:00:00"),("50","upfilefilename","Имя файла","lkey","type=file
sys=1","","0000-00-00 00:00:00"),("51","filenamefilename","Имя файла","lkey","type=filename
sys=1","","0000-00-00 00:00:00"),("52","operator","Оператор","lkey","type=s
sys=1","","0000-00-00 00:00:00"),("53","folder","Директория с файлами","lkey","type=s
sys=1","","0000-00-00 00:00:00"),("54","size","Размер файла","lkey","type=d
sys=1

","","0000-00-00 00:00:00"),("55","type_file","Тип файла","lkey","type=s
sys=1
","","0000-00-00 00:00:00"),("57","upfilepict","Имя файла","lkey","type=file
sys=1","","0000-00-00 00:00:00"),("58","filenamepict","Имя файла","lkey","type=s
sys=1","","0000-00-00 00:00:00"),("59","upfile","Имя файла","lkey","type=file
sys=1","","0000-00-00 00:00:00"),("60","ID","Индекс","lkey","type=d
sys=1","","0000-00-00 00:00:00"),("61","list_table","Дополнительная таблица","lkey","type=s
sys=1","","0000-00-00 00:00:00"),("62","auth_rem","Запоминать при входе","lkey","type=chb
yes=запоминать
не запоминать
sys=1","","0000-00-00 00:00:00"),("63","key_razdel","Ключ раздела","lkey","type=s
sys=1","","0000-00-00 00:00:00"),("64","menu_button_no","Флаг не перегружать меню кнопок","lkey","type=d
sys=1","","0000-00-00 00:00:00"),("65","Filedata","Имя файла","lkey","type=file
sys=1","","0000-00-00 00:00:00"),("66","panel_razdel","Разделы меню основной страницы ПУ","lkey","type=list
list=1|Основные модули~2|Каталог, интернет-магазин~3|Дополнительные модули~4|Настройки","","2008-03-06 19:53:50"),("67","admin","Панель управления","button","type_link=loadcontent
menu_button=1
menu_settings=1
menu_banner=1
menu_center=1
menu_subscribe=1
menu_catalog=1
menu_usercommon=1
mainrazdel_button=1
replaceme=replaceme
controller=main
action=mainpage
imageiconmenu=/admin/img/icons/menu/icon_home.png
title=Панель управления
rating=1
","","2009-02-04 22:29:30"),("68","logout","Выйти","button","type_link=javascript
function=loadfile("/admin/logout");
menu_button=1
menu_subscribe=1
menu_center=1
menu_catalog=1
menu_settings=1
menu_banner=1
menu_usercommon=1
mainrazdel_button=1
imageiconmenu=/admin/img/icons/menu/icon_exit.png
title=Выйти
rating=200","","2009-02-04 22:30:40"),("70","keys","Ключи","button","type_link=loadcontent
menu_settings=1
replaceme=replaceme
controller=keys
action=mainpage
imageiconmenu=/admin/img/icons/menu/icon_objects.png
title=Объекты
rating=3","","2008-03-15 21:51:53"),("71","access","Права доступа","button","type_link=loadcontent
menu_settings=1
replaceme=replaceme
controller=access
action=enter
imageiconmenu=/admin/img/icons/menu/icon_access.png
title=Политика безопасности
rating=7","","2009-02-05 02:00:03"),("72","templates","Шаблоны","button","type_link=loadcontent
menu_settings=1
replaceme=replaceme
controller=templates
action=mainpage
imageiconmenu=/admin/img/icons/menu/icon_templates.png
title=Шаблоны
rating=14
settings_topmenu=1
","","2009-02-05 02:00:11"),("73","styles","Стили","button","type_link=loadcontent
menu_settings=1
replaceme=replaceme
controller=styles
action=mainpage
imageiconmenu=/admin/img/icons/menu/icon_styles.png
title=Стили
rating=4
settings_topmenu=1
","","2009-02-05 02:00:58"),("74","vars","Глобальные переменные","button","type_link=loadcontent
menu_settings=1
replaceme=replaceme
controller=vars
action=enter
imageiconmenu=/admin/img/icons/menu/icon_settings.png
title=Глобальные переменные
rating=5
settings_topmenu=1
","","2009-02-05 02:00:50"),("75","sysusers","Учетные записи","button","type_link=loadcontent
menu_settings=1
replaceme=replaceme
controller=sysusers
action=enter
imageiconmenu=/admin/img/icons/menu/icon_users.png
title=Учетные записи
rating=6
settings_topmenu=1
","","2009-02-05 01:59:53"),("76","lists","Справочники","button","type_link=loadcontent
menu_settings=1
replaceme=replaceme
controller=lists
action=mainpage
program=/cgi-bin/lists_a.cgi
imageiconmenu=/admin/img/icons/menu/icon_lists.png
title=Справочники
rating=2
settings_topmenu=1
","","2009-02-05 02:00:25"),("77","object","Объекты","menu","type_link=loadcontent
action=enter
program=/cgi-bin/object_a.cgi
rating=18
parentid=setting
replaceme=replaceme
submenuwidth=200","","0000-00-00 00:00:00"),("78","table_flag","Флаг загрузки таблицы","lkey","type=d
sys=1","","2009-02-06 02:26:28"),("79","amp"," Временная переменная","lkey","type=s
sys=1
","","2009-02-07 14:10:19"),("80","textEditValue","Новые данные сохранения QEdit","lkey","type=s
sys=1","","2009-02-08 19:35:58"),("81","textEditElementId","ID элемента для QEdit","lkey","type=s
sys=1","","2009-02-08 19:35:58"),("84","saveTextEdit","Флаг работы QEdit","lkey","type=d
sys=1","","2009-02-14 13:59:54"),("85","texts","Тексты","button","type_link=loadcontent
mainrazdel_button=1
texts_topmenu=1
replaceme=replaceme
controller=texts
action=enter
imageiconmenu=/admin/img/icons/menu/button.text.png
title=Тексты
rating=2","","2009-03-17 17:09:40"),("86","images","Изображения","button","type_link=loadcontent
#mainrazdel_button=1
images_topmenu=1
replaceme=replaceme
controller=images
action=enter
imageiconmenu=/admin/img/icons/menu/button.image.png
title=Изображения
rating=5","","2009-04-09 16:41:55"),("87","advplace","Рекламные места","button","type_link=loadcontent
menu_banner=1
banners_topmenu=1
replaceme=replaceme
controller=banners
do=list_container&list_table=data_banner_advert_block
imageiconmenu=/admin/img/icons/menu/button.advplace.png
title=Рекламные места
rating=3
","","2009-04-16 16:58:36"),("88","advuser","Рекламодатели","button","type_link=loadcontent
menu_banner=1
banners_topmenu=1
replaceme=replaceme
controller=banners
do=list_container&list_table=data_banner_advert_users
imageiconmenu=/admin/img/icons/menu/button.users.png
title=Рекламодатели
rating=4
","","2009-04-16 16:59:00"),("89","banners","Баннеры","button","type_link=loadcontent
menu_banner=1
banners_topmenu=1
replaceme=replaceme
controller=banners
do=enter
imageiconmenu=/admin/img/icons/menu/button.banner.png
title=Баннеры
rating=2","","2009-04-16 16:59:18"),("90","eexcel_key","ключ поля заменить на описание","lkey","type=chb
sys=1
yes=да
no=нет","","2009-04-19 20:41:32"),("91","eexcel_field","индексы заменять на описание","lkey","type=chb
sys=1
yes=да
no=нет","","2009-04-19 20:42:10"),("100","catalog","Каталог","button","type_link=loadcontent
menu_center=1
catalog_topmenu=1
replaceme=replaceme
controller=catalog
do=enter
imageiconmenu=/admin/img/icons/program/catalog2.png
rating=5
title=Каталог","","2009-10-21 14:50:12"),("99","tdatepref","Датировать датой. Фильтр","lkey","type=s
sys=1","","2009-10-20 17:27:07"),("101","subscribeusers","Подписчики","button","type_link=loadcontent
#menu_center=1
replaceme=replaceme
controller=subscribe
do=list_container&list_table=dtbl_subscribe_users
imageiconmenu=/admin/img/icons/menu/button.users.png
rating=11
title=Подписчики","","2010-01-14 15:51:20"),("102","status","Группы подписчиков","button","type_link=loadcontent
menu_subscribe=1
program=/cgi-bin/lists_a.cgi
action=list&list_table=lst_status&menu_button_no=1
imageiconmenu=/admin/img/icons/menu/button.advplace.png
rating=3
title=Группы подписчиков
replaceme=replaceme
replaceme=listslst_status
id=listslst_status","","2010-01-14 15:58:27"),("107","users","Внешние пользователи","button","type_link=loadcontent
menu_center=1
users_topmenu=1
replaceme=replaceme
controller=users
action=enter
imageiconmenu=/admin/img/icons/program/users.gif
rating=10
title=Внешние пользователи","","2010-03-31 21:25:01"),("115","faq","Вопрос-Ответ","button","type_link=loadcontent
menu_center=1
faq_topmenu=1
replaceme=replaceme
controller=faq
do=enter
imageiconmenu=/admin/img/icons/program/faq.png
rating=11
title=Вопрос-Ответ","","2010-07-12 18:46:24"),("123","do","Ключ функции","lkey","type=slat
","","2012-10-11 16:38:24"),("119","pcol_doptable","Кол-во записей на страницу (доп таблица)","lkey","type=d
","","2011-11-05 16:22:01"),("120","page_doptable","Страница (доптаблица)","lkey","type=d
","","2011-11-05 17:55:32"),("121","alias","Алиас","lkey","type=s
rating=2
table_list=2
group=1
filter=1
qview=1
qedit=1
required=1
help=Короткое латинское название, которое учавствует в формирование URL для данной страницы","","2012-01-21 18:18:21"),("122","subscribe","Рассылка","button","type_link=loadcontent
#menu_center=1
replaceme=replaceme
controller=subscribe
do=enter
imageiconmenu=/admin/img/icons/menu/button.subscribe.png
rating=10
title=Рассылка","","2012-05-21 21:09:02"),("124","cataloggroups","Каталог. Категории","button","type_link=loadcontent
menu_center=1
catalog_topmenu=1
replaceme=replaceme
controller=catalog
do=list_container&list_table=data_catalog_categorys
imageiconmenu=/admin/img/icons/program/category.png
title=Каталог. Категории
rating=6
","","2009-04-16 16:58:36"),("125","catalogbrands","Каталог. Бренды","button","type_link=loadcontent
menu_center=1
catalog_topmenu=1
replaceme=replaceme
controller=catalog
do=list_container&list_table=data_catalog_brands
imageiconmenu=/admin/img/icons/program/brands.png
title=Каталог. Бренды
rating=7
","","2009-04-16 16:58:36"),("127","catalogorders","Каталог. Заказы","button","type_link=loadcontent
menu_center=1
catalog_topmenu=1
replaceme=replaceme
controller=catalog
do=enter&list_table=data_catalog_orders
imageiconmenu=/admin/img/icons/program/order.png
rating=9
title=Каталог. Заказы","","2009-04-16 16:58:36"),("128","syslogs","Системный журнал","button","type_link=loadcontent
menu_settings=1
replaceme=replaceme
controller=syslogs
action=enter
imageiconmenu=/admin/img/icons/program/syslogs.png
title=Системный журнал
rating=15
settings_topmenu=1
","","2009-02-05 01:59:53"),("129","seo","SEO","button","type_link=loadcontent
menu_settings=1
replaceme=replaceme
controller=seo
action=enter
imageiconmenu=/admin/img/icons/program/seo.png
title=SEO
rating=9
settings_topmenu=1
","","2013-07-04 21:06:27"),("130","filemanager","Файлменеджер","button","type_link=loadcontent
mainrazdel_button=1
replaceme=replaceme
controller=filemanager
action=mainpage
imageiconmenu=/admin/img/icons/program/filemanager.png
title=Файлменеджер
rating=99
filemanager_topmenu=1
","","2009-02-05 02:00:58"),("131","updated_at","Дата редактирования","lkey","type=datetime
template_w=field_input_read
group=1
rating=199","","0000-00-00 00:00:00"),("132","created_at","Дата создания","lkey","type=datetime
template_w=field_input_read
group=1
rating=200","","2009-02-05 02:01:30"),("133","redirects","301 Redirect","button","type_link=loadcontent
menu_settings=1
replaceme=replaceme
controller=redirects
action=enter
imageiconmenu=/admin/img/icons/program/redirects.png
title=301 Redirects
rating=10
settings_topmenu=1
","","2013-07-04 21:06:27"),("134","recall","Отзывы","button","type_link=loadcontent
menu_center=1
recall_topmenu=1
replaceme=replaceme
controller=recall
do=enter
imageiconmenu=/admin/img/icons/program/links.png
rating=15
title=Отзывы","","");


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
) ENGINE=MyISAM AUTO_INCREMENT=189 DEFAULT CHARSET=utf8 COMMENT='Ключи к модулю Изображения';INSERT INTO `keys_images` ( `ID`,`lkey`,`name`,`object`,`settings`,`tbl`,`updated_at`)  VALUES 
("1","add_link","Добавить запись","button","type_link=openpage
position=center
id=newentry
table_list=1
print_info=1
table_list_dir=1
controller=images
imageiconmenu=/admin/img/icons/menu/icon_add.png
action=add
title=Добавить
rating=1
params=replaceme","","0000-00-00 00:00:00"),("2","add_link_dir","Тексты. Добавить папку","button","type_link=loadcontent
table_list_dir=1
controller=images
imageiconmenu=/admin/img/icons/menu/icon_dir_add.png
action=add_dir
title=Создать папку
params=replaceme
rating=1","","0000-00-00 00:00:00"),("5","del_link","Удалить запись","button","type_link=loadcontent
controller=images
action=delete
confirm=Действительно удалить запись?
title=Удалить запись
imageiconmenu=/admin/img/icons/menu/icon_delete.png
print_info=1
rating=1
params=replaceme,index,list_table","","0000-00-00 00:00:00"),("6","edit_link","Редактировать запись","button","type_link=loadcontent
print_info=1
controller=images
imageiconmenu=/admin/img/icons/menu/icon_edit.png
action=edit
title=Редактировать запись
rating=2
params=replaceme,index,list_table","","0000-00-00 00:00:00"),("7","end_link","Закончить редактирование","button","type_link=loadcontent
edit_info=1
controller=images
imageiconmenu=/admin/img/icons/menu/icon_ok.png
action=info
title=Закончить редактирование
rating=10
params=replaceme,index,list_table","","0000-00-00 00:00:00"),("8","filter","Фильтр","button","type_link=modullink
table_list=1
table_list_dir=1
controller=images
imageiconmenu=/admin/img/icons/menu/icon_filter.png
action=filter
title=Фильтр
width=690
height=510
level=3
rating=4
params=replaceme","","0000-00-00 00:00:00"),("9","filter_clear","Очистка фильтра","button","type_link=loadcontent
table_list=1
table_list_dir=1
controller=images
imageiconmenu=/admin/img/icons/menu/icon_nofilter.png
action=filter_clear
title=Снять фильтры
rating=5
params=replaceme","","0000-00-00 00:00:00"),("11","list_link","Список","button","type_link=loadcontent
add_info=1
controller=images
imageiconmenu=/admin/img/icons/menu/button.list.png
action=enter
title=Список
rating=1
params=replaceme","","0000-00-00 00:00:00"),("15","razdel","Раздел","lkey","type=tlist
list=lst_images
notnull=1","","2010-10-27 13:03:54"),("16","name","Название","lkey","type=s
filter=1
table_list=1
group=1
required=1
qview=1
qedit=1
rating=1
dirview=1
fileview=1
help=Название изображения для дальнейшей его идентификации в базе. На страницах сайта с клиентской стороны не используется.","","2010-10-27 13:03:54"),("17","title_en","Заголовок (en)","lkey","type=s
rating=5
group=1
qview=1
qedit=1
dirview=1
fileview=1
table_list=3
table_list_widht=150
help=Описание изображения для клиентской части. Используется в фотогалерее для подписи изображения


","","2008-10-20 11:22:12"),("18","description","Краткое описание","lkey","type=html
rating=11
group=2
dirview=1
fileview=1
qview=1","","2010-10-19 15:39:29"),("19","title_ru","Заголовок (ru)","lkey","type=s
rating=4
group=1
qview=1
qedit=1
filter=1
dirview=1
fileview=1
table_list=2
table_list_width=150
help=Описание изображения для клиентской части. Используется в фотогалерее для подписи изображения
","","2010-10-27 13:03:54"),("20","pict","Картинка","lkey","type=pict
rating=24
table_list=8
table_list_name=-
table_list_type=pict
folder=/images/gallery/
table_list_nosort=1
shablon_w=field_pict
shablon_r=field_pict_read
sizelimit=20000
mini=214x124~crop,1000
ext=*.jpg;*.jpeg;*.tif
fileview=1
dirview=1
help=Загрузите изображение на сервер","","2010-10-27 13:03:54"),("21","dir","Папка/файл","lkey","type=chb
group=1
rating=6
table_list=1
table_list_name=-
table_list_nosort=1
table_list_width=16
yes=<img src="/admin/img/dtree/folder.gif">
no=<img src="/admin/img/dtree/doc.gif">
filter=1
template_w=field_checkbox_read

","","2010-10-27 13:03:54"),("22","keywords","Ключевые слова","lkey","type=s
rating=6
group=1
dirview=1
fileview=1
help=Ключевые слова. Используются в фотогалерее при генерации страницы с данной фотографией или группой фотографий (для папок)
","","2010-10-27 13:03:54"),("23","rating","Рейтинг","lkey","type=d
group=1
rating=99
table_list=10
table_list_name=Rt
table_list_width=32
qedit=1
dirview=1
fileview=1
shablon_w=field_rating
help=Рейтинг служит для выстраивания фотографий и галерей друг относительно друга. Чем меньше значение, тем выше изображение (галерея) в иерархии","","2010-10-27 13:03:54"),("24","width","Ширина","lkey","type=d
group=1
rating=21
shablon_w=field_input_read
help=реальная ширина изображения. информация из файла
fileview=1
qview=1
","","2010-05-31 16:13:29"),("25","height","Высота","lkey","type=d
group=1
rating=21
shablon_w=field_input_read
help=Высота изображения. Информация из файла
fileview=1
qview=1
","","2010-05-31 16:13:29"),("26","size","Размер файла","lkey","type=d
shablon_w=field_input_read
rating=20
group=1
filter=1
qview=1
table_list=5
table_list_name=byte","","2010-05-31 16:13:29"),("27","image_gallery","Вложена в папку","lkey","type=tlist
list=images_gallery
sort=1
qview=1
rating=7
shablon_w=field_select_dir
shablon_f=field_select_dir_filter
where=AND `dir`=1 AND `image_gallery`=0
group=1
table_list=4
table_list_width=200
filter=1
dirview=1
fileview=1
help=Папка (галерея) для изображения","","2010-10-27 13:03:54"),("28","viewimg","Публикация","lkey","type=chb
rating=101
group=1
qedit=1
table_list=11
table_list_name=-
table_list_width=48
yes=Виден
no=Скрыт
qview=1
filter=1
dirview=1
fileview=1
help=Данная опция предназначена для отключения отображения картинки в фотогалерее. Если вы используете изображение в тексте, то включение опции на отображение в тексте не влияет.","","2010-10-27 13:03:54"),("30","mini","Миниатюрная копия","lkey","type=list
list=mini
group=1
rating=15
fileview=1
help=При выборе соответствующего пункта будет создано миниатюрное изображение. Кадрировать - копия горизонтальная в 3:4, происходит вырезка кадра из базового изображения. Пропорционально - уменьшение до системного размера пропорционально. В квадрат - вписывается в квадрат. фон белый.
","","2009-12-21 13:38:54"),("31","use","Используется","lkey","type=d
group=1
rating=55
fileview=1
shablon_w=field_use
shablon_r=field_use_read
help=Если указаны документы, то в них используется данное изображение. Чтобы удалить его из базы необходимо вначале убрать изображение из документов. ","","2008-10-30 17:10:45"),("32","deletepict","Флаг удаления картинки","lkey","type=chb
sys=1","","2008-10-30 18:03:51"),("33","filename","Файл","lkey","type=filename
rating=2
sizelimit=20000
file_ext=*.*","","2010-10-27 13:03:51"),("34","type_file","Тип файла","lkey","type=slat
group=2
rating=21
shablon_w=field_input_read
","","2008-10-30 17:10:45"),("35","hide","Флаг скрыть","lkey","type=s
sys=1","","2009-06-04 18:16:14"),("36","show","Флаг показать","lkey","type=s
sys=1","","2010-08-21 19:28:17"),("37","x","Координата X","lkey","type=d
sys=1","","2009-04-09 23:35:06"),("38","y","Координата Y","lkey","type=d
sys=1","","2009-04-09 23:35:06"),("39","percent_size","Процент","lkey","type=s
sys=1","","2009-04-09 23:35:06"),("40","height_crop","Высота кадрирования","lkey","type=d
sys=1","","2009-04-09 23:35:06"),("41","width_crop","Ширина кадрирования","lkey","type=d
sys=1","","2009-04-09 23:35:06"),("42","import","Загрузка архива","button","type_link=modullink
table_list=1
table_list_dir=1
controller=images
imageiconmenu=/admin/img/icons/menu/button.zipload.png
action=zipimport
title=Загрузка архива
width=690
height=710
level=3
rating=2
params=replaceme","","0000-00-00 00:00:00"),("43","zip","Архив","lkey","type=file
rating=14
template_w=field_file
template_r=field_file_read
sizelimit=20000
ext=*.zip
fileview=1
table_list=2
help=ZIP архив
save_msg=Нажмите «Начать загрузку»","","2010-08-21 19:26:56"),("44","swf","Flash","lkey","type=filename
rating=24
shablon_w=field_pict
shablon_r=field_pict_read
sizelimit=20000
file_ext=*.swf
","","2009-04-27 13:16:38"),("45","day","День","lkey","type=d","","0000-00-00 00:00:00"),("46","month","Месяц","lkey","type=d","","0000-00-00 00:00:00"),("47","year","Год","lkey","type=d","","0000-00-00 00:00:00"),("52","mini","Варианты миниатюры","list","list=|не создавать~1|Кадрировать~2|Пропорционально~3|В квадрат
type=radio","","0000-00-00 00:00:00"),("53","widthpref","Ширина (параметр для фильтра)","lkey","type=s
sys=1","","2010-05-31 16:13:29"),("54","heightpref","Высота (параметр для фильтра)","lkey","type=s
sys=1","","2010-05-31 16:13:29"),("55","sizepref","Размер (параметр для фильтра)","lkey","type=s
sys=1","","2010-05-31 16:13:29"),("56","image_catalog","Папка","lkey","type=tlist
list=images_catalog
sort=1
rating=7
shablon_w=field_select_dir
shablon_f=field_select_dir_filter
where=AND `dir`=1 AND `image_catalog`=0
group=1
filter=1
dirview=1
fileview=1
help=Папка (галерея) для каталога объектов","","2009-06-15 14:17:42"),("65","tdate","Датировать датой","lkey","type=date
rating=10
group=1
qview=1
filter=1
fileview=1
table_list=5
table_list_width=70
template_f=field_date_filter","","0000-00-00 00:00:00"),("66","alias","Алиас","lkey","type=s
rating=5
table_list=2
group=1
filter=1
qview=1
qedit=1
required=1
dirview=1
help=Короткое латинское название, которое учавствует в формирование URL для данной страницы
","","0000-00-00 00:00:00"),("188","copy","Копировать запись","button","type_link=loadcontent
print_info=1
edit_info=1
controller=images
action=copy
loading_msg=1
imageiconmenu=/admin/img/icons/menu/icon_copy.png
title=Копировать запись
rating=5
params=replaceme,index,list_table","","0000-00-00 00:00:00");


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
) ENGINE=MyISAM AUTO_INCREMENT=38 DEFAULT CHARSET=utf8 COMMENT='Ключи к модулю Object';INSERT INTO `keys_keys` ( `ID`,`lkey`,`name`,`object`,`settings`,`tbl`,`updated_at`)  VALUES 
("4","config_table","Таблица объектов","lkey","type=slat
sys=1","","2010-09-13 19:48:27"),("5","tbl","Таблица","lkey","type=slat
rating=4
table_list=4
filter=1
help=Каждый ключ уникален для определенной таблицы. Чтобы разделить похожие объекты укажите таблицу, для которой действительны данные параметры ","","2010-09-10 21:49:59"),("6","object","Объект","lkey","type=list
list=lkey|Ключ~button|Кнопка~pane|Определение вкладки
notnull=1
list_type=radio
rating=9
filter=1
table_list=2
qview=1
qedit=1
help=В системе определено несколько типов объектов. Выберите, какой объект вы создаете
","","2010-09-10 21:49:59"),("8","settings","Настройки","lkey","type=code
rating=10
group=1
template_r=field_settings_read
template_w=field_settings
qview=1
help=Дополнительные параметры объекта. Каждая строка описывает один параметр. Формат: КЛЮЧ=ЗНАЧЕНИЕ
","","2010-09-10 21:49:59"),("9","name","Наименование","lkey","type=s
rating=1
filter=1
table_list=1
help=Название объекта
required=1
qview=1
qedit=1
","","2010-09-10 21:49:59"),("11","lkey","Ключ","lkey","type=slat
rating=4
table_list=3
required=1
qview=1
qedit=1
filter=1
help=Ключ, по которому можно обратиться к объекту","","2010-09-10 21:49:59"),("12","add_link","Добавить запись","button","type_link=openpage
position=center
id=newentry
table_list=1
print_info=1
controller=keys
action=add
title=Добавить запись
imageiconmenu=/admin/img/icons/menu/icon_add.png
rating=1
params=list_table,replaceme
","","2008-03-15 21:51:53"),("13","copy_link","Копировать запись","button","type_link=loadcontent
controller=keys
do=copy
imageiconmenu=/admin/img/icons/menu/icon_copy.png
title=Копировать объект
rating=3
params=list_table,replaceme,index
#print_info=1
#edit_info=1
","","0000-00-00 00:00:00"),("14","delete","Удалить запись","button","type_link=loadcontent
controller=keys
action=delete
imageiconmenu=/admin/img/icons/menu/icon_delete.png
confirm=Действительно удалить запись?
title=Удалить объект
rating=3
params=list_table,replaceme,index
print_info=1
","","0000-00-00 00:00:00"),("15","edit_link","Редактировать запись","button","type_link=loadcontent
print_info=1
controller=keys
action=edit
imageiconmenu=/admin/img/icons/menu/icon_edit.png
title=Редактировать запись
rating=2
params=list_table,replaceme,index","","2008-03-17 02:22:20"),("16","filter","Объекты. Фильтр","button","type_link=modullink
table_list=1
controller=keys
action=filter
imageiconmenu=/admin/img/icons/menu/icon_filter.png
title=Настроить фильтр
width=690
height=510
level=3
rating=2
params=list_table,replaceme","","2008-03-15 21:51:53"),("17","filter_clear","Объекты. Очистка фильтра","button","type_link=loadcontent
table_list=1
controller=keys
action=filter_clear
title=Снять фильтры
imageiconmenu=/admin/img/icons/menu/icon_nofilter.png
rating=3
params=list_table,replaceme","","2008-03-15 21:51:53"),("18","list_link","Список объектов","button","type_link=loadcontent
add_info=1
controller=keys
imageiconmenu=/admin/img/icons/menu/button.list.png
action=list
title=Список объектов
rating=1
params=list_table,replaceme","","2008-03-15 21:51:53"),("19","end_link","Закончить редактирование","button","type_link=loadcontent
edit_info=1
controller=keys
action=info
imageiconmenu=/admin/img/icons/menu/icon_ok.png
title=Закончить редактирование
rating=10
params=list_table,replaceme,index","","2008-03-15 21:51:53"),("29","listtable","Объекты","button","type_link=loadcontent
add_object=1
controller=keys
imageiconmenu=/admin/img/icons/menu/button.list.png
action=enter
title=Объекты
rating=1
params=replaceme","","0000-00-00 00:00:00"),("37","copy","Копировать запись","button","type_link=loadcontent
print_info=1
edit_info=1
controller=keys
action=copy
loading_msg=1
imageiconmenu=/admin/img/icons/menu/icon_copy.png
title=Копировать запись
rating=5
params=replaceme,index,list_table","","0000-00-00 00:00:00");


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
) ENGINE=MyISAM AUTO_INCREMENT=83 DEFAULT CHARSET=utf8 COMMENT='Ключи к модулю Lists';INSERT INTO `keys_lists` ( `ID`,`lkey`,`name`,`object`,`settings`,`tbl`,`updated_at`)  VALUES 
("44","end_link","Закончить редактирование","button","type_link=loadcontent
edit_info=1
controller=lists
action=info
imageiconmenu=/admin/img/icons/menu/icon_ok.png
title=Закончить редактирование
rating=10
params=list_table,replaceme,index","","0000-00-00 00:00:00"),("10","name","Название","lkey","type=s
rating=1
required=1
qview=1
qedit=1
table_list=2
","","2010-10-04 16:44:07"),("11","list_table","Таблица-справочник","lkey","type=s
sys=1","","2010-10-27 14:06:24"),("12","id_countries","Страна","lkey","type=tlist
list=lst_countries
rating=2
filter=1
qview=1
shablon_w=field_select_input
shablon_f=field_select_input_filter
rules=id_region:lst_region.id_countries=index
add_to_list=1
width=450
height=250","","2008-07-16 18:35:18"),("13","id_region","Регион","lkey","type=tlist
list=lst_region
rating=3
filter=1
qview=1
shablon_w=field_select_input
shablon_f=field_select_input_filter
rules=id_countries:lst_region.index=id_countries","","2008-07-16 18:35:17"),("15","list_link","Список справочников","button","type_link=loadcontent
add_info=1
controller=lists
imageiconmenu=/admin/img/icons/menu/button.list.png
action=list
title=Список справочников
rating=1
params=list_table,replaceme","","0000-00-00 00:00:00"),("16","filter_clear","Справочники. Очистка фильтра","button","type_link=loadcontent
table_list=1
controller=lists
imageiconmenu=/admin/img/icons/menu/icon_nofilter.png
action=filter_clear
title=Снять фильтры
rating=3
params=list_table,replaceme","","0000-00-00 00:00:00"),("17","filter","Справочники. Фильтр","button","type_link=modullink
table_list=1
controller=lists
action=filter
imageiconmenu=/admin/img/icons/menu/icon_filter.png
title=Настроить фильтр
width=690
height=510
level=3
rating=2
params=list_table,replaceme","","0000-00-00 00:00:00"),("18","add_link","Добавить запись","button","type_link=openpage
position=center
id=newentry
table_list=1
print_info=1
controller=lists
imageiconmenu=/admin/img/icons/menu/icon_add.png
action=add
title=Добавить запись
rating=1
params=list_table,replaceme","","0000-00-00 00:00:00"),("20","id_city","Город","lkey","type=tlist
list=lst_citys
rating=3
filter=1
group=1
qview=1
required=1
","","2010-05-24 15:51:53"),("22","id_vilage","Населенный пункт","lkey","type=tlist
list=lst_vilage
rating=34
filter=1
group=2
key_program=lists
shablon_w=field_select_input
shablon_f=field_select_input_filter
rules=id_city:lst_vilage.index=id_city","","2008-07-16 18:35:19"),("23","lists","Справочники","menu","type_link=loadcontent
action=enter
program=/cgi-bin/lists_a.cgi
rating=21
parentid=setting
replaceme=replaceme
submenuwidth=200","","0000-00-00 00:00:00"),("25","key_razdel","Ключ раздела","lkey","type=s
rating=2
required=1","","2009-11-19 17:03:46"),("26","id_group_user","Группа пользователей","lkey","type=tlist
list=lst_group_user
rating=5
qview=1
mult=7
shablon_w=field_multselect","","2008-09-16 23:35:30"),("27","users","Пользователь","lkey","type=tlist
list=sys_users
rating=10
qview=1
mult=7
shablon_w=field_multselect","","2008-09-16 23:35:30"),("28","listf","Список ключей для редактирования","lkey","type=s
rating=3","","2008-09-16 23:35:30"),("32","width","Ширина","lkey","type=d
group=1
rating=15
table_list_name=W
table_list_width=32
qview=1
qedit=1","lst_advert_block","2009-08-25 18:46:00"),("33","height","Высота","lkey","type=d
group=1
rating=16
table_list_name=H
table_list_width=32
qview=1
qedit=1","lst_advert_block","2009-08-25 18:46:00"),("34","per_click","Цена за клик","lkey","type=d
fileview=1
table_list=4
table_list_name=$/click
table_list_width=100
rating=10
group=1
qview=1
qedit=1
","","2009-08-25 18:46:00"),("35","per_show","Цена за показ","lkey","type=d
rating=11
group=1
qview=1
qedit=1
fileview=1
table_list=5
table_list_width=100
table_list_name=$/показ","","2009-08-25 18:46:00"),("45","password","Пароль","lkey","type=password
required=1
rating=3","lst_advert_users","2009-04-16 15:56:33"),("46","email","E-mail","lkey","type=email
rating=5","lst_advert_users","2009-04-16 15:56:33"),("47","login","Логин","lkey","type=slat
required=1
rating=2","lst_advert_users","2009-04-16 15:56:33"),("48","foto1","Фото 1","lkey","type=tlist
list=images_fond
rating=20
group=1
key_program=lists
shablon_w=field_select_input
shablon_f=field_select_input_filter
help=Введите несколько символов фото из базы изображений и потом выберите его из списка
where= `dir`=0","","0000-00-00 00:00:00"),("49","foto2","Фото 2","lkey","type=tlist
list=images_fond
rating=21
group=1
key_program=lists
shablon_w=field_select_input
shablon_f=field_select_input_filter
help=Введите несколько символов фото из базы изображений и потом выберите его из списка
where= `dir`=0","","0000-00-00 00:00:00"),("50","foto3","Фото 3","lkey","type=tlist
list=images_fond
rating=22
group=1
key_program=lists
shablon_w=field_select_input
shablon_f=field_select_input_filter
help=Введите несколько символов фото из базы изображений и потом выберите его из списка
where= `dir`=0","","0000-00-00 00:00:00"),("51","id_images","Фотографии","lkey","type=tlist
list=images_projects
sort=1
rating=10
group=1
where= AND `image_projects`='0' AND `dir`=1
filter=1
shablon_w=field_select_input
shablon_f=field_select_input_filter","","0000-00-00 00:00:00"),("52","text","Текст","lkey","type=html
group=1
rating=4
shablon=field_html_full
fileview=1
","","2009-12-17 12:07:25"),("53","id_equipimg","Фотографии","lkey","type=tlist
list=images_equipment
sort=1
rating=8
group=1
where= AND `image_equipment`='0' AND `dir`=1
filter=1
shablon_w=field_select_input
shablon_f=field_select_input_filter","","0000-00-00 00:00:00"),("54","id_project","Проект","lkey","type=tlist
list=texts_projects_ru
sort=1
rating=10
group=1
filter=1
shablon_w=field_select_input
shablon_f=field_select_input_filter","","0000-00-00 00:00:00"),("55","id_recall","Прикрепить отзыв","lkey","type=tlist
list=data_recall
sort=1
rating=40
group=1
filter=1
shablon_w=field_select_input
shablon_f=field_select_input_filter
","","0000-00-00 00:00:00"),("56","id_docfiles_rubrics","Рубрика","lkey","type=tlist
list=lst_docfiles_rubrics
sort=1
rating=3
group=1
filter=1
shablon_w=field_select_input
shablon_f=field_select_input_filter
help=Выберите тематическую рубрику
fileview=1
add_to_list=1
width=400
height=250
rules_all=1
","","0000-00-00 00:00:00"),("57","id_docfiles_subrubrics","Подрубрика","lkey","type=tlist
list=lst_docfiles_rubrics
sort=1
rating=9
group=1
filter=1
shablon_w=field_select_input
shablon_f=field_select_input_filter
rules=id_docfiles_rubrics:lst_docfiles_rubrics.ID=tmp|texts_docfiles:texts_docfiles_ru.id_docfiles_subrubrics=index
rules_where= AND `dir`='1'
where= AND `id_rubrics`>'0'
help=Выберите тематическую подрубрику
fileview=1
add_to_list=1
width=400
height=250
rules_all=1
","","0000-00-00 00:00:00"),("58","id_rubrics","Родительская рубрика","lkey","type=tlist
list=lst_docfiles_rubrics
sort=1
rating=2
print=1
fileview=1
where= AND `id_rubrics`='0'
","","2010-01-15 12:14:22"),("59","rating","Рейтинг","lkey","type=d
group=1
qview=1
qedit=1
table_list=6
table_list_name=Rt
table_list_width=32
rating=99
template_w=field_rating","","2010-09-30 14:33:40"),("60","active","Отображать на сайте","lkey","type=chb
print=1
rating=99
fileview=1
filter=1
table_list=10
table_list_width=48
table_list_name=-
yes=Виден
no=Скрыт

","","2010-10-04 16:44:07"),("71","max","Верхняя цена диапозона","lkey","type=d
print=1
qview=1
rating=4
qedit=1
shablon_w=field_rating
","","2010-05-27 14:47:05"),("63","get","Флаг получения инф.","lkey","type=d
sys=1","","0000-00-00 00:00:00"),("70","min","Нижняя цена диапозона","lkey","type=d
print=1
qview=1
rating=3
qedit=1
shablon_w=field_rating
","","2010-05-27 14:47:05"),("72","ulclass","CSS class списка","lkey","type=s
print=1
rating=30
","","0000-00-00 00:00:00"),("73","divclass","CSS class контейнера","lkey","type=s
sys=1
","","0000-00-00 00:00:00"),("74","weight","Вес","lkey","type=d
print=1
qview=1
table_list=3
table_list_width=70
filter=1
shablon_w=field_rating
rating=4

","","2010-10-04 16:44:07"),("75","link","Ссылка","lkey","type=s
print=1
qview=1
rating=3
table_list=2
table_list_width=100
","","2010-10-04 16:44:07"),("76","material_id","Материал ID","lkey","type=s
print=1
sys=1

","","0000-00-00 00:00:00"),("77","name","Рост, см","lkey","type=d
rating=1
required=1
qview=1
qedit=1
table_list=2
","lst_catalog_sizes","0000-00-00 00:00:00"),("78","age","Возраст","lkey","type=s
rating=3
qview=1
qedit=1
table_list=3
","","0000-00-00 00:00:00"),("79","code","Короткий код","lkey","type=s
rating=5
required=1
qview=1
qedit=1
table_list=3
","","0000-00-00 00:00:00"),("80","edit_link","Редактировать запись","button","type_link=loadcontent
print_info=1
controller=lists
action=edit
imageiconmenu=/admin/img/icons/menu/icon_edit.png
title=Редактировать запись
rating=2
params=replaceme,index,list_table","","0000-00-00 00:00:00"),("81","layout","Название шаблона","lkey","type=s
print=1
qview=1
rating=10
table_list=3
table_list_width=100
sys=1

","","0000-00-00 00:00:00"),("82","copy","Копировать запись","button","type_link=loadcontent
print_info=1
edit_info=1
controller=lists
action=copy
loading_msg=1
imageiconmenu=/admin/img/icons/menu/icon_copy.png
title=Копировать запись
rating=5
params=replaceme,index,list_table","","0000-00-00 00:00:00");


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
) ENGINE=MyISAM AUTO_INCREMENT=17 DEFAULT CHARSET=utf8 COMMENT='Ключи к модулю MainConfig';INSERT INTO `keys_mainconfig` ( `ID`,`lkey`,`name`,`object`,`settings`,`tbl`,`updated_at`)  VALUES 
("10","qstring","Строка запроса","lkey","type=s
sys=1","","0000-00-00 00:00:00"),("6","exit"," Выход","menu","type_link=javascript
function=loadfile("/cgi-bin/auth.cgi?action=logout");
#type_link=openurl
title=Выход
imageiconmenu=/admin/img/icons/menu/icon_exit_min.gif
url=/cgi-bin/auth.cgi?action=logout
rating=25
parentid=file","","2008-03-09 15:23:23"),("8","keys_log","Лог ключей","menu","type_link=openpage
action=keys_log
program=/cgi-bin/admin.cgi
title=Лог ключей
tabtitle=Лог ключей
rating=5
parentid=instrument
position=east
id=keys_log","","2008-03-09 15:23:23"),("9","log_mysql","Лог ошибок mysql","menu","type_link=openpage
action=log_mysql
program=/cgi-bin/admin.cgi
title=Лог ошибок MySQL
tabtitle=log_mysql
rating=6
parentid=instrument
position=east
id=log_mysql","","2008-03-09 15:23:23"),("12","instrument","Инструменты","menu","type_link=nothing
title=Инструменты
rating=5
submenuwidth=200","","0000-00-00 00:00:00"),("13","setting","Настройки","menu","type_link=nothing
title=Настройки
rating=15
submenuwidth=200
","","0000-00-00 00:00:00"),("14","edit","Правка","menu","type_link=nothing
title=Правка
rating=2
submenuwidth=200
","","0000-00-00 00:00:00"),("15","help","Справка","menu","type_link=openurl
title=Справка
url=http://office/admin
rating=25","","0000-00-00 00:00:00"),("16","file","Файл","menu","type_link=nothing
title=Файл
rating=1
submenuwidth=200
","","0000-00-00 00:00:00");


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
) ENGINE=MyISAM AUTO_INCREMENT=82 DEFAULT CHARSET=cp1251 COMMENT='Ключи к модулю Отзывы';INSERT INTO `keys_recall` ( `ID`,`lkey`,`name`,`object`,`settings`,`tbl`,`updated_at`)  VALUES 
("62","add_link","Добавить запись","button","type_link=openpage
position=center
id=newentry
table_list=1
print_info=1
controller=recall
action=add
imageiconmenu=/admin/img/icons/menu/icon_add.png
title=Добавить
rating=1
params=replaceme","","0000-00-00 00:00:00"),("61","del_link","Удалить запись","button","type_link=loadcontent
controller=recall
action=delete
imageiconmenu=/admin/img/icons/menu/icon_delete.png
confirm=Действительно удалить запись?
title=Удалить запись
print_info=1
rating=1
params=replaceme,index","","0000-00-00 00:00:00"),("60","edit_link","Редактировать запись","button","type_link=loadcontent
print_info=1
controller=recall
action=edit
imageiconmenu=/admin/img/icons/menu/icon_edit.png
title=Редактировать запись
rating=2
params=replaceme,index","","0000-00-00 00:00:00"),("59","end_link","Закончить редактирование","button","type_link=loadcontent
edit_info=1
controller=recall
action=info
imageiconmenu=/admin/img/icons/menu/icon_ok.png
title=Закончить редактирование
rating=10
params=replaceme,index
","","0000-00-00 00:00:00"),("58","filter","Фильтр","button","type_link=modullink
table_list=1
controller=recall
action=filter
imageiconmenu=/admin/img/icons/menu/icon_filter.png
title=Фильтр
width=690
height=510
level=3
rating=2
params=replaceme","","0000-00-00 00:00:00"),("57","filter_clear","Очистка фильтра","button","type_link=loadcontent
table_list=1
program=/cgi-bin/recall_a.cgi
imageiconmenu=/admin/img/icons/menu/icon_nofilter.png
action=filter_clear
title=Снять фильтры
rating=3
params=replaceme","","0000-00-00 00:00:00"),("56","list_link","Список","button","type_link=loadcontent
add_info=1
controller=recall
action=enter
imageiconmenu=/admin/img/icons/menu/button.list.png
title=Список
rating=1
params=replaceme","","0000-00-00 00:00:00"),("44","quest_date","Дата вопроса","lkey","type=time
rating=5
table_list=6
table_list_name=Дата
shablon_w=field_time_exp
group=1
fileview=1
dirview=1","","0000-00-00 00:00:00"),("18","keywords","Ключевые слова","lkey","type=s
rating=10
group=1
filter=1
","","2008-10-30 17:15:04"),("20","active","Публиковать","lkey","type=chb
rating=99
table_list=5
table_list_name=-
table_list_width=48
yes=Виден
no=Скрыт
group=1
filter=1
fileview=1
dirview=1","","2011-04-04 15:00:44"),("22","tdate","Датировать датой","lkey","type=date
rating=10
group=1
qview=1
filter=1
fileview=1
table_list=8
table_list_width=70
template_f=field_date_filter
help=Укажите какой датой датировать эту запись","","2015-04-03 18:15:57"),("34","show","Флаг показать","lkey","type=s
sys=1","","2011-04-04 15:52:08"),("35","hide","Флаг скрыть","lkey","type=s
sys=1","","2011-04-04 15:52:05"),("36","day","День","lkey","type=d","","0000-00-00 00:00:00"),("37","month","Месяц","lkey","type=d","","0000-00-00 00:00:00"),("38","year","Год","lkey","type=d","","0000-00-00 00:00:00"),("39","recall","Отзыв","lkey","type=text
table_list=3
filter=1
group=1
rating=5
no_format=1
required=1
qview=1
editform=1
saveform=1
obligatory=1","","2015-04-03 18:13:22"),("41","name","Имя автора","lkey","type=s
group=1
rating=1
qview=1
qedit=1
table_list=1
editform=1
saveform=1
obligatory=1
obligatory_rules=validate[required]
cktoolbar=Basic","","2015-04-03 17:06:58"),("42","answer","Ответ","lkey","type=html
group=1
rating=8
rating=90
cktoolbar=Basic","","2015-04-03 17:04:28"),("48","number","Поле подтверждения по картинке","lkey","type=d
rating=90
group=1
obligatory=1
#regform=1
#editform=1
shablon_reg=field_imgconfirm","regform","0000-00-00 00:00:00"),("49","code","Код на картинке","lkey","type=d
sys=1","","0000-00-00 00:00:00"),("71","answer_name","Автор ответа","lkey","type=s
filter=1
group=1
rating=7
no_format=1
qview=1","","2015-04-03 17:04:16"),("76","email","E-mail","lkey","type=s
table_list=2
filter=1
group=1
rating=4
no_format=1
required=1
qview=1
editform=1
saveform=1
obligatory=1","","2015-04-03 17:06:01"),("77","quest_anons","Тема вопроса","lkey","type=s
print=1
qview=1
rating=5
qview=1
table_list=5
table_list_width=100
required=1
next_td=1


","","2011-04-04 15:00:44"),("80","phone","Телефон","lkey","type=s
table_list=1
filter=1
group=1
rating=3
no_format=1
qview=1
saveform=1
","","0000-00-00 00:00:00"),("81","copy","Копировать запись","button","type_link=loadcontent
print_info=1
edit_info=1
controller=recall
action=copy
loading_msg=1
imageiconmenu=/admin/img/icons/menu/icon_copy.png
title=Копировать запись
rating=5
params=replaceme,index,list_table","","0000-00-00 00:00:00");


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
) ENGINE=MyISAM AUTO_INCREMENT=50 DEFAULT CHARSET=utf8 COMMENT='Ключи к модулю Тексты';INSERT INTO `keys_redirects` ( `ID`,`edate`,`lkey`,`name`,`object`,`settings`,`tbl`)  VALUES 
("1","2014-06-30 18:32:10","add_link","Добавить запись","button","type_link=loadcontent
table_list=1
print_info=1
controller=redirects
action=add
imageiconmenu=/admin/img/icons/menu/icon_add.png
title=Добавить
rating=1
params=replaceme,list_table",""),("2","2014-06-30 18:32:20","del_link","Удалить запись","button","type_link=loadcontent
controller=redirects
action=delete
confirm=Действительно удалить запись?
title=Удалить запись
imageiconmenu=/admin/img/icons/menu/icon_delete.png
print_info=1
rating=1
params=replaceme,index,list_table",""),("3","2014-06-30 18:32:28","edit_link","Редактировать запись","button","type_link=loadcontent
print_info=1
controller=redirects
action=edit
imageiconmenu=/admin/img/icons/menu/icon_edit.png
title=Редактировать запись
rating=2
params=replaceme,index,list_table",""),("4","2014-06-30 18:32:36","end_link","Закончить редактирование","button","type_link=loadcontent
edit_info=1
controller=redirects
action=info
imageiconmenu=/admin/img/icons/menu/icon_ok.png
title=Закончить редактирование
rating=1
params=replaceme,index,list_table",""),("5","2014-06-30 18:32:43","filter","Фильтр","button","type_link=modullink
table_list=1
table_list_orders=1
controller=redirects
action=filter
imageiconmenu=/admin/img/icons/menu/icon_filter.png
title=Фильтр
width=690
height=510
level=3
rating=2
params=replaceme,list_table",""),("6","2014-06-30 18:32:51","filter_clear","Очистка фильтра","button","type_link=loadcontent
table_list=1
table_list_orders=1
table_list_dir=1
controller=redirects
action=filter_clear
imageiconmenu=/admin/img/icons/menu/icon_nofilter.png
title=Снять фильтры
rating=3
params=replaceme,list_table",""),("39","2014-06-30 19:10:18","source_url","Исходная ссылка","lkey","type=site
group=1
qview=1
qedit=1
table_list=3
required=1
rating=3
",""),("49","2014-06-30 19:10:26","last_url","Ссылка назначения","lkey","type=site
group=1
qview=1
qedit=1
table_list=4
required=1
table_list_width=500
rating=4","");


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
) ENGINE=MyISAM AUTO_INCREMENT=52 DEFAULT CHARSET=utf8 COMMENT='Ключи к модулю Тексты';INSERT INTO `keys_seo` ( `ID`,`lkey`,`name`,`object`,`settings`,`tbl`,`updated_at`)  VALUES 
("1","add_link","Добавить запись","button","type_link=openpage
position=center
id=newentry
table_list=1
print_info=1
controller=seo
action=add
imageiconmenu=/admin/img/icons/menu/icon_add.png
title=Добавить
rating=1
params=replaceme,list_table","","0000-00-00 00:00:00"),("2","del_link","Удалить запись","button","type_link=loadcontent
controller=seo
action=delete
confirm=Действительно удалить запись?
title=Удалить запись
imageiconmenu=/admin/img/icons/menu/icon_delete.png
print_info=1
rating=1
params=replaceme,index,list_table","","0000-00-00 00:00:00"),("3","edit_link","Редактировать запись","button","type_link=loadcontent
print_info=1
controller=seo
action=edit
imageiconmenu=/admin/img/icons/menu/icon_edit.png
title=Редактировать запись
rating=2
params=replaceme,index,list_table","","0000-00-00 00:00:00"),("4","end_link","Закончить редактирование","button","type_link=loadcontent
edit_info=1
controller=seo
action=info
imageiconmenu=/admin/img/icons/menu/icon_ok.png
title=Закончить редактирование
rating=10
params=replaceme,index,list_table
","","0000-00-00 00:00:00"),("5","filter","Фильтр","button","type_link=modullink
table_list=1
table_list_orders=1
controller=seo
action=filter
imageiconmenu=/admin/img/icons/menu/icon_filter.png
title=Фильтр
width=690
height=510
level=3
rating=2
params=replaceme,list_table","","0000-00-00 00:00:00"),("6","filter_clear","Очистка фильтра","button","type_link=loadcontent
table_list=1
table_list_orders=1
table_list_dir=1
controller=seo
action=filter_clear
imageiconmenu=/admin/img/icons/menu/icon_nofilter.png
title=Снять фильтры
rating=3
params=replaceme,list_table","","0000-00-00 00:00:00"),("7","name","Заголовок (title)","lkey","type=s
filter=1
group=1
rating=1
required=1
qedit=1
table_list=1
no_format=1
fileview=1
help=Заголовок окна браузера. Может отличаться от названия текста. Используется для оптимизации под поисковые ","","2010-10-31 11:29:29"),("39","url","Ссылка","lkey","type=site
group=1
qview=1
qedit=1
table_list=3
table_list_width=200
rating=3
","","0000-00-00 00:00:00"),("38","keywords","Ключевые слова (keywords)","lkey","type=s
print=1
group=1
rating=10
qview=1
qedit=1
help=Ключевые слова и выражения, разделенные запятой, которые соответствуют данному тексту. Используется для оптимизации страницы под поисковые системы. Указанные слова в данном поле должны обязательно присутствовать в тексте — в противном случае они не будут учитываться поисковыми машинами.

","","0000-00-00 00:00:00"),("48","description","Краткое описание страницы (description)","lkey","type=text
print=1
group=1
rating=11
qview=1
qedit=1
help=Краткое описание текста. Используется для поисковых систем. Выводится на странице в meta-теге description. Как правило, пользователь данный текст не видет. Для поисковых систем полезнее для каждой страницы формировать свое описание, наиболее соответствующее данной странице.

","","0000-00-00 00:00:00"),("49","copy","Копировать запись","button","type_link=loadcontent
print_info=1
edit_info=1
controller=seo
action=copy
loading_msg=1
imageiconmenu=/admin/img/icons/menu/icon_copy.png
title=Копировать запись
rating=5
params=replaceme,index,list_table","","0000-00-00 00:00:00"),("50","seo_title","SEO заголовок","lkey","type=s
rating=5
group=1
qview=1
qedit=1
filter=1
table_list=0
table_list_width=0
fileview=1
required=0","","2015-04-17 17:29:41"),("51","seo_text","SEO текст","lkey","type=html
rating=6
group=1
qview=1
qedit=1
filter=1
table_list=0
table_list_width=0
fileview=1
required=0","","2015-04-17 17:29:48");


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
) ENGINE=MyISAM AUTO_INCREMENT=17 DEFAULT CHARSET=utf8 COMMENT='Ключи к модулю Object';INSERT INTO `keys_styles` ( `ID`,`lkey`,`name`,`object`,`settings`,`tbl`,`updated_at`)  VALUES 
("7","code","Код","lkey","type=code
rating=4
shablon_w=field_css
shablon_r=field_code_read
","","2010-10-27 14:12:45"),("15","dir","Папка","lkey","type=s
rating=2
help=Путь к файлу
required=1
template_w=field_input_read
qview=1
qedit=1
","","0000-00-00 00:00:00"),("16","name","Файл","lkey","type=s
rating=1
filter=1
table_list=1
help=Название шаблона
required=1
template_w=field_input_read
qview=1
qedit=1
","","0000-00-00 00:00:00");


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
) ENGINE=MyISAM AUTO_INCREMENT=37 DEFAULT CHARSET=cp1251 COMMENT='Ключи к модулю Рассылка';INSERT INTO `keys_subscribe` ( `ID`,`lkey`,`name`,`object`,`settings`,`tbl`,`updated_at`)  VALUES 
("1","id_status","Рассылка","lkey","type=tlist
list=lst_status
rating=5
class=required
required=1
filter=1
table_list=3
","","2010-02-12 17:13:56"),("2","name","E-mail","lkey","type=email
filter=1
group=1
rating=1
table_list=1
no_format=1
required=1
obligatory=1","dtbl_subscribe_users","2010-02-16 23:31:20"),("3","code","Код на картинке","lkey","type=d
sys=1","","0000-00-00 00:00:00"),("4","number","Поле подтверждения по картинке","lkey","type=d
rating=90
group=1
shablon_reg=field_imgconfirm
","","0000-00-00 00:00:00"),("5","email","Email","lkey","type=email
group=1
rating=3
table_list=2
required=1
obligatory=1
fileview=1
","","2010-02-16 23:31:20"),("6","active","Активация","lkey","type=chb
rating=11
table_list=5
table_list_name= 
group=1
yes=активен
no=не активен
filter=1
","","2010-02-16 23:31:20"),("7","add_link","Добавить запись","button","type_link=openpage
position=center
id=newentry
table_list=1
controller=subscribe
action=add
imageiconmenu=/admin/img/icons/menu/icon_add.png
title=Добавить
rating=1
params=replaceme,users_flag,list_table","","0000-00-00 00:00:00"),("10","del_link","Удалить запись","button","type_link=loadcontent
controller=subscribe
action=delete
confirm=Действительно удалить запись?
imageiconmenu=/admin/img/icons/menu/icon_delete.png
title=Удалить запись
print_info=1
rating=1
params=replaceme,index,users_flag","","0000-00-00 00:00:00"),("11","edit_link","Редактировать запись","button","type_link=loadcontent
print_info=1
controller=subscribe
imageiconmenu=/admin/img/icons/menu/icon_edit.png
action=edit
title=Редактировать запись
rating=2
params=replaceme,index,list_table","","0000-00-00 00:00:00"),("12","end_link","Закончить редактирование","button","type_link=loadcontent
edit_info=1
controller=subscribe
action=info
imageiconmenu=/admin/img/icons/menu/icon_ok.png
title=Закончить редактирование
rating=1
params=replaceme,index,list_table","","0000-00-00 00:00:00"),("13","filter","Фильтр","button","type_link=modullink
table_list=1
controller=subscribe
action=filter
imageiconmenu=/admin/img/icons/menu/icon_filter.png
title=Фильтр
width=690
height=510
level=3
rating=2
params=replaceme,users_flag","","0000-00-00 00:00:00"),("14","filter_clear","Очистка фильтра","button","type_link=loadcontent
table_list=1
controller=subscribe
imageiconmenu=/admin/img/icons/menu/icon_nofilter.png
action=filter_clear
title=Снять фильтры
rating=3
params=replaceme,users_flag","","0000-00-00 00:00:00"),("16","status","Группы подписчиков","button","type_link=openpage
menu_button=1
program=/cgi-bin/lists_a.cgi
action=list&list_table=lst_status&menu_button_no=1
imageiconmenu=/admin/img/icons/menu/button.advplace.png
title=Группы подписчиков
rating=3
replaceme=listslst_status
id=listslst_status
","","0000-00-00 00:00:00"),("29","emails","Адреса","lkey","type=table
table=dtbl_subscribe_emails
group=2
rating=15
shablon_w=field_table
table_fields=id_user,email
table_svf=id_user
table_sortfield=email
table_buttons_key_w=delete,edit
table_groupname=Общая информация
table_noindex=1","","0000-00-00 00:00:00"),("18","users_flag","Флаг для таблицы пользователей","lkey","type=d
sys=1","","2010-02-16 23:43:17"),("19","name","Название рассылки","lkey","type=s
filter=1
group=1
rating=1
table_list=1
no_format=1
required=1
obligatory=1","data_subscribe","0000-00-00 00:00:00"),("20","name","Название","lkey","type=s
filter=1
group=1
rating=1
table_list=1
no_format=1
required=1
obligatory=1","","2010-02-12 17:13:56"),("21","subject","Тема письма рассылки","lkey","type=s
rating=2
group=1
required=1","","2010-02-12 17:13:56"),("22","list_link","Список","button","type_link=loadcontent
add_info=1
controller=subscribe
action=enter
title=Список
rating=1
params=replaceme,users_flag","","0000-00-00 00:00:00"),("23","text","Текст рассылки","lkey","type=html
group=2
rating=1","","2010-02-11 18:01:58"),("24","stat","Статистика","lkey","type=table
table=dtbl_subscribe_stat
group=3
rating=15
shablon_w=field_table
table_fields=id_user,send_date
table_svf=id_data_subscribe
table_sortfield=send_date
table_buttons_key_w=delete,edit
table_groupname=Общая информация
table_noindex=1","","0000-00-00 00:00:00"),("25","id_user","Пользователь","lkey","type=tlist
list=dtbl_subscribe_users
rating=2","","2010-01-14 13:13:37"),("26","send_date","Дата отправки","lkey","type=time
","","0000-00-00 00:00:00"),("27","send_link","Разослать письмо","button","type_link=loadcontent
print_info=1
controller=subscribe
imageiconmenu=/admin/img/icons/menu/icon_subscribesend.png
action=send
title=Разослать письмо
rating=1
params=replaceme,index","","0000-00-00 00:00:00"),("28","send","Разослано","lkey","type=chb
rating=11
table_list=5
table_list_name= 
group=1
yes=да
no=нет
filter=1
","","2010-02-12 17:13:56"),("31","name","ФИО","lkey","type=s
rating=1
keys_read=1
shablon_reg=field_input
shablon_view=field_input_read
obligatory=1
editform=1
saveform=1
obligatory_rules=validate[required]","regform","0000-00-00 00:00:00"),("32","index","Индекс","lkey","type=d
sys=1
","","2010-03-12 17:03:16"),("33","number","Поле подтверждения по картинке","lkey","type=d
rating=90
group=1
obligatory=1
regform=1
editform=1
shablon_reg=field_imgconfirm
","regform","0000-00-00 00:00:00"),("34","email","Email","lkey","type=email
group=1
rating=4
table_list=2
shablon_reg=field_input_dopemail
shablon_view=field_input_read","regform","0000-00-00 00:00:00"),("35","status","Рассылки","lkey","type=tlist
list=lst_status
rating=20
class=validate[required]
required=1
filter=1
table_list=3
shablon_reg=field_checkbox
editform=1
saveform=1
notnull=1","regform","0000-00-00 00:00:00"),("36","status","Рассылки","lkey","type=tlist
list=lst_status
rating=5
class=required
required=1
filter=1
table_list=3
shablon_w=field_multselect_input
help=Рассылки, на которые подписан пользователь","","2010-02-16 23:31:20");


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
) ENGINE=MyISAM AUTO_INCREMENT=46 DEFAULT CHARSET=utf8 COMMENT='Ключи к модулю Sysusers';INSERT INTO `keys_syslogs` ( `ID`,`lkey`,`name`,`object`,`settings`,`tbl`,`updated_at`)  VALUES 
("1","name","Действие","lkey","type=s
rating=1
table_list=1
required=1
qview=1
qedit=1
template_w=field_input_read
","","2010-03-11 14:34:30"),("7","filter","Управление доступом. Фильтр","button","type_link=modullink
table_list=1
controller=syslogs
action=filter
imageiconmenu=/admin/img/icons/menu/icon_filter.png
title=Настроить фильтр
width=690
height=510
level=3
rating=2
params=replaceme","","0000-00-00 00:00:00"),("8","filter_clear","Управление доступом. Очистка фильтра","button","type_link=loadcontent
table_list=1
controller=syslogs
imageiconmenu=/admin/img/icons/menu/icon_nofilter.png
action=filter_clear
title=Снять фильтры
rating=3
params=replaceme","","0000-00-00 00:00:00"),("9","del_link","Удалить запись","button","type_link=loadcontent
controller=syslogs
action=delete
imageiconmenu=/admin/img/icons/menu/icon_delete.png
confirm=Действительно удалить запись?
title=Удалить запись
print_info=1
rating=1
params=replaceme,index","","0000-00-00 00:00:00"),("10","list_link","Список пользователей","button","type_link=loadcontent
add_info=1
controller=syslogs
imageiconmenu=/admin/img/icons/menu/button.list.png
action=enter
title=Список пользователей
rating=1
params=replaceme","","0000-00-00 00:00:00"),("45","created_at","Дата создания","lkey","type=datetime
rating=100
group=1
qview=1
filter=1
fileview=1
table_list=11
table_list_width=70
template_f=field_date_filter","","2014-02-20 10:12:54"),("41","comment","Комментарий","lkey","type=text
print=1
qview=1
rating=90
fileview=1
template_w=field_input_read

","","0000-00-00 00:00:00"),("42","ip","IP","lkey","type=s
print=1
qview=1
qedit=1
filter=1
rating=15
table_list=9
table_list_width=70
template_w=field_input_read
","","0000-00-00 00:00:00"),("40","id_program","Модуль","lkey","type=tlist
list=sys_program
rating=6
print=1
qview=1
filter=1
table_list=2
table_list_width=150
template_w=field_list_read
","","0000-00-00 00:00:00"),("44","eventtype","Тип события","lkey","type=list
list=1|Добавление~2|Удаление~3|Редактирование~4|Восстановление~5|Авторизация~6|Ошибка
list_type=radio
filter=1
rating=30
fileview=1
table_list=8
table_list_width=70
qview=1
print=1
template_w=field_list_read
","","0000-00-00 00:00:00"),("43","id_sysusergroup","Группа","lkey","type=tlist
list=lst_group_user
rating=6
print=1
qview=1
filter=1
table_list=6
table_list_width=150
template_w=field_list_read
","","0000-00-00 00:00:00"),("39","id_sysuser","Пользователь","lkey","type=tlist
list=sys_users
rating=5
print=1
qview=1
filter=1
table_list=5
table_list_width=150
template_w=field_list_read
","","2014-04-04 12:53:36");


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
) ENGINE=MyISAM AUTO_INCREMENT=40 DEFAULT CHARSET=utf8 COMMENT='Ключи к модулю Sysusers';INSERT INTO `keys_sysusers` ( `ID`,`lkey`,`name`,`object`,`settings`,`tbl`,`updated_at`)  VALUES 
("1","name","Имя пользователя","lkey","type=s
rating=1
table_list=1
required=1
qview=1
qedit=1","","2010-03-11 11:34:30"),("2","login","Логин","lkey","type=s
rating=1
required=1
qview=1
qedit=1
table_list=2
","","2010-03-11 11:34:30"),("3","email","E-mail","lkey","type=email
rating=3
mask=email
","","2010-03-11 11:34:30"),("4","password_digest","Пароль","lkey","type=password
rating=5
required=1","","2010-03-11 11:34:30"),("5","id_group_user","Группа пользователей","lkey","type=tlist
list=lst_group_user
table_list=3
rating=5
required=1
qview=1
filter=1
mult=7
shablon_w=field_multselect
notnull=1","","2010-03-11 11:34:30"),("6","vdate","Дата последней авторизации","lkey","type=datetime
rating=10
","","2010-03-10 20:25:26"),("7","filter","Управление доступом. Фильтр","button","type_link=modullink
table_list=1
controller=sysusers
action=filter
imageiconmenu=/admin/img/icons/menu/icon_filter.png
title=Настроить фильтр
width=690
height=510
level=3
rating=2
params=replaceme","","0000-00-00 00:00:00"),("8","filter_clear","Управление доступом. Очистка фильтра","button","type_link=loadcontent
table_list=1
controller=sysusers
imageiconmenu=/admin/img/icons/menu/icon_nofilter.png
action=filter_clear
title=Снять фильтры
rating=3
params=replaceme","","0000-00-00 00:00:00"),("9","del_link","Удалить запись","button","type_link=loadcontent
controller=sysusers
action=delete
imageiconmenu=/admin/img/icons/menu/icon_delete.png
confirm=Действительно удалить запись?
title=Удалить запись
print_info=1
rating=1
params=replaceme,index","","0000-00-00 00:00:00"),("10","list_link","Список пользователей","button","type_link=loadcontent
add_info=1
controller=sysusers
imageiconmenu=/admin/img/icons/menu/button.list.png
action=enter
title=Список пользователей
rating=1
params=replaceme","","0000-00-00 00:00:00"),("11","edit_link","Редактировать запись","button","type_link=loadcontent
print_info=1
controller=sysusers
imageiconmenu=/admin/img/icons/menu/icon_edit.png
action=edit
title=Редактировать запись
rating=2
params=replaceme,index","","0000-00-00 00:00:00"),("14","end_link","Закончить редактирование","button","type_link=loadcontent
edit_info=1
controller=sysusers
imageiconmenu=/admin/img/icons/menu/icon_ok.png
action=info
title=Закончить редактирование
rating=10
params=replaceme,index","","0000-00-00 00:00:00"),("15","add_link","Добавить запись","button","type_link=openpage
position=center
id=newentry
table_list=1
controller=sysusers
imageiconmenu=/admin/img/icons/menu/icon_add.png
action=add
title=Добавить запись
rating=1
params=replaceme","","0000-00-00 00:00:00"),("19","btime","Заблокирован до","lkey","type=datetime
rating=21","","2010-03-10 20:25:26"),("20","count","Количество попыток авторизации","lkey","type=d
rating=22","","2010-03-10 20:25:26"),("21","settings","Настройки","lkey","type=code
template_w=field_settings_read
rating=30
filter=1
shablon_r=field_settings_read
","","2010-03-10 20:25:26"),("22","ip","Последний заход с IP","lkey","type=s
template_w=field_input_read
rating=22","","2010-03-10 20:25:26"),("23","bip","Заблокирован IP","lkey","type=s
template_w=field_input_read
rating=23","","2010-03-10 20:25:26"),("29","users_list","Доступно для пользователей","lkey","type=tlist
list=sys_users
group=1
rating=128
mult=5
shablon_w=field_multselect
notnull=1","","2010-03-11 11:34:30"),("30","users","Учетные записи","menu","type_link=loadcontent
action=enter
program=/cgi-bin/users_a.cgi
rating=23
parentid=setting
replaceme=replaceme
submenuwidth=200","","0000-00-00 00:00:00"),("31","users_add","Добавить пользователя","menu","type_link=loadcontent
action=add
program=/cgi-bin/users_a.cgi
rating=123
parentid=users
replaceme=replaceme","","0000-00-00 00:00:00"),("34","sys","Супер пользователь","lkey","type=chb
group=1
rating=130
yes=Супер пользователь
no=Пользователь","","2010-03-10 20:25:26"),("35","groups_list","Доступно для групп","lkey","type=tlist
list=lst_group_user
group=1
rating=129
default=6
shablon_w=field_multselect
notnull=1","","0000-00-00 00:00:00"),("37","access","Права доступа","lkey","type=code
sys=1
","","0000-00-00 00:00:00"),("38","vfe","Visual Front-end Editor","lkey","type=chb
group=1
rating=131
yes=Включен
no=Выключен","","0000-00-00 00:00:00"),("39","copy","Копировать запись","button","type_link=loadcontent
print_info=1
edit_info=1
controller=sysusers
action=copy
loading_msg=1
imageiconmenu=/admin/img/icons/menu/icon_copy.png
title=Копировать запись
rating=5
params=replaceme,index,list_table","","0000-00-00 00:00:00");


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
) ENGINE=MyISAM AUTO_INCREMENT=33 DEFAULT CHARSET=utf8 COMMENT='Ключи к модулю Шаблоны';INSERT INTO `keys_templates` ( `ID`,`lkey`,`name`,`object`,`settings`,`tbl`,`updated_at`)  VALUES 
("2","name","Название","lkey","type=s
rating=1
filter=1
table_list=1
help=Название шаблона
required=1
template_w=field_input_read
qview=1
qedit=1
","","2010-10-28 17:55:00"),("30","modifytime","Дата редактирования","lkey","type=s
rating=3
help=Дата редактирования файла
required=1
template_w=field_input_read


","","2011-10-20 02:37:05"),("31","dir","Путь к шаблону","lkey","type=s
rating=2
help=Путь к файлу
required=1
template_w=field_input_read
qview=1
qedit=1
","","2011-10-20 02:43:12"),("6","edate","Дата редактирования","lkey","type=time
table_list=5
group=1
rating=7
sys=1
qview=1","","0000-00-00 00:00:00"),("8","list_shablon_table","Таблицы шаблонов","list","list=0|-----","","0000-00-00 00:00:00"),("12","del_link","Удалить запись","button","type_link=loadcontent
controller=templates
action=delete
imageiconmenu=/admin/img/icons/menu/icon_delete.png
confirm=Действительно удалить запись?
title=Удалить шаблон
rating=3
params=shablon_table,replaceme,index
print_info=1","","0000-00-00 00:00:00"),("20","end_link","Закончить редактирование","button","type_link=loadcontent
#edit_info=1
controller=templates
action=mainpage
imageiconmenu=/admin/img/icons/menu/icon_ok.png
title=Закончить редактирование
rating=1
params=dir,replaceme,index","","0000-00-00 00:00:00"),("21","add_link","Добавить шаблон","button","type_link=openPage
#templates_list=1
controller=templates
action=add
title=Добавить шаблон
imageiconmenu=/admin/img/icons/menu/icon_add.png
rating=1
params=replaceme,dir
","","0000-00-00 00:00:00"),("32","code","Код","lkey","type=code
rating=4
template_w=field_template
template_r=field_code_read
fileview=1
dirview=1
","","2011-11-16 21:10:05");


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
) ENGINE=MyISAM AUTO_INCREMENT=190 DEFAULT CHARSET=utf8 COMMENT='Ключи к модулю Тексты';INSERT INTO `keys_texts` ( `ID`,`lkey`,`name`,`object`,`settings`,`tbl`,`updated_at`)  VALUES 
("1","add_link","Добавить запись","button","type_link=openpage
position=center
id=newentry
table_list=1
print_info_text=1
print_info=1
table_list_dir=1
controller=texts
imageiconmenu=/admin/img/icons/menu/icon_add.png
action=add
title=Добавить
rating=1
params=replaceme","","0000-00-00 00:00:00"),("3","del_link","Удалить запись","button","type_link=loadcontent
print_info=1
print_info_text=1
controller=texts
action=delete
confirm=Действительно удалить запись?
title=Удалить запись
imageiconmenu=/admin/img/icons/menu/icon_delete.png
rating=1
params=replaceme,index,list_table","","0000-00-00 00:00:00"),("4","edit_link","Редактировать запись","button","type_link=loadcontent
print_info=1
print_info_text=1
controller=texts
imageiconmenu=/admin/img/icons/menu/icon_edit.png
action=edit
title=Редактировать запись
rating=2
params=replaceme,index,list_table","","0000-00-00 00:00:00"),("5","end_link","Закончить редактирование","button","type_link=loadcontent
edit_info=1
controller=texts
action=info
imageiconmenu=/admin/img/icons/menu/icon_ok.png
title=Закончить редактирование
rating=10
params=replaceme,index,list_table","","0000-00-00 00:00:00"),("7","filter","Фильтр","button","type_link=modullink
table_list=1
table_list_dir=1
controller=texts
imageiconmenu=/admin/img/icons/menu/icon_filter.png
action=filter
title=Фильтр
width=690
height=510
level=3
rating=2
params=replaceme","","0000-00-00 00:00:00"),("8","filter_clear","Очистка фильтра","button","type_link=loadcontent
table_list=1
table_list_dir=1
controller=texts
imageiconmenu=/admin/img/icons/menu/icon_nofilter.png
action=filter_clear
title=Снять фильтры
rating=3
params=replaceme","","0000-00-00 00:00:00"),("9","list_link","Список","button","type_link=loadcontent
add_info=1
controller=texts
imageiconmenu=/admin/img/icons/menu/button.list.png
action=enter
title=Список
rating=1
params=replaceme","","0000-00-00 00:00:00"),("11","alias","Алиас","lkey","type=s
rating=5
table_list=2
group=1
filter=1
qview=1
qedit=1
required=1
help=Короткое латинское название, которое учавствует в формирование URL для данной страницы","","2010-10-29 12:23:39"),("12","text","Текст","lkey","type=html
group=2
rating=1
fileview=1","","2010-10-29 15:22:54"),("13","name","Название","lkey","type=s
filter=1
group=1
rating=1
required=1
qedit=1
qview=1
table_list=1
no_format=1
dirview=1
fileview=1
help=Название страницы. Используется при генерации меню, автоматических ссылок, заголовков h1","","2010-10-29 12:23:39"),("14","razdel","Раздел","lkey","type=tlist
list=lst_texts
list_sort=asc_d
where= AND `<%= $self->sysuser->settings->{lang} %>`='1' 
notnull=1","","2010-10-29 15:22:54"),("15","title","Заголовок окна","lkey","type=s
no_format=1
rating=2
group=1
qview=1
qedit=1
help=Заголовок окна браузера. Может отличаться от названия текста. Используется для оптимизации под поисковые системы.
dirview=1
fileview=1","","2010-10-29 12:23:39"),("16","keywords","Ключевые слова","lkey","type=s
rating=3
group=1
filter=1
qedit=1
help=Ключевые слова и выражения, разделенные запятой, которые соответствуют данному тексту. Используется для оптимизации страницы под поисковые системы. Указанные слова в данном поле должны обязательно присутствовать в тексте — в противном случае они не будут учитываться поисковыми машинами.
dirview=1
fileview=1","","2010-10-29 12:23:39"),("17","description","Краткое описание страницы","lkey","type=text
rating=3
group=1
qview=1
help=Краткое описание текста. Используется для поисковых систем. Выводится на странице в meta-теге description. Как правило, пользователь данный текст не видет. Для поисковых систем полезнее для каждой страницы формировать свое описание, наиболее соответствующее данной странице.
dirview=1
fileview=1","","2010-10-29 12:23:39"),("18","rating","Рейтинг","lkey","type=d
group=1
qview=1
qedit=1
table_list=4
table_list_name=Rt
table_list_width=32
rating=6
template_w=field_rating
help=Рейтинг служит для выстраивания текстов друг относительно друга. Чем меньше значение, тем выше текст в иерархии","","2010-10-29 12:23:39"),("19","menu","Включать в меню","lkey","type=chb
rating=10
group=1
qedit=1
filter=1
table_list=7
table_list_name=Меню
table_list_width=64
yes=да
no=нет
help=При установке флажка данный текст будет участвовать в формировании меню основного сайта.","","2010-10-29 12:23:39"),("21","viewtext","Публикация","lkey","type=chb
rating=99
group=1
qview=1
table_list=10
table_list_name=-
table_list_width=48
yes=Виден
no=Скрыт
filter=1
dirview=1
qedit=1
fileview=1
help=Публиковать страницу на сайте","","2010-10-29 12:23:39"),("186","edit_link_text","Редактировать текст","button","type_link=loadcontent
print_info_text=1
controller=texts
imageiconmenu=/admin/img/icons/menu/button.text.gif
action=edit&group=2
title=Редактировать текст
rating=3
params=replaceme,index,list_table","","0000-00-00 00:00:00"),("22","delnot","Неудаляем","lkey","type=chb
rating=12
group=1
table_list=4
table_list_name=-
table_list_nosort=1
table_list_width=16
yes=<img src="/admin/img/icons/ico_lock.gif">
no=<img src="/admin/img/icons/ico_unlock.gif">
dirview=1
fileview=1
help=Данная опция защищает текст от случайного удаления.","","2010-10-29 12:23:39"),("23","link","URL-ссылка на страницу в Internet","lkey","type=s
group=1
rating=4
help=Используется при построении основного меню. Происходит подмена алиаса на указанную в данном поле ссылку. ","","2010-10-29 12:23:39"),("24","layout","Шаблон страницы","lkey","type=s
template_w=field_layout
group=1
rating=20
help=Если для страницы требуется установить какой-то особенный шаблон, то выберите его из выпадающего списка. По умолчанию используется шаблон default","","2010-10-29 12:23:39"),("25","url_for","Модуль","lkey","type=code
template_w=field_url_for
group=1
rating=21
help=Выберите модуль, который будет показан на данной странице
#help=XML-директива, которая будет выполняться при загрузке страницы и выводить результаты выполнения в контентной области, вместо вывода текста. Открывающая и закрывающая угловые скобки в данном поле опускаются. Вводится только код.","","2010-10-29 12:23:39"),("185","text","Текст","lkey","type=html
group=1
rating=90
fileview=1
cktoolbar=Basic
","texts_floating_ru","0000-00-00 00:00:00"),("27","texts_main_ru","Верхний уровень","lkey","type=tlist
list=texts_main_ru
sort=1
rating=7
template_w=field_select_dir
template_f=field_select_dir_filter
group=1
filter=1
help=Для построения вложенных меню выберите текст верхнего уровня из иерархического дерева текстов раздела. Для того, чтобы вернуть текст в главный уровень выберите самый главный уровень дерева texts_main_ru.
","","2010-10-29 12:23:39"),("29","texts_news","Группа","lkey","type=tlist
list=texts_news_ru
table_list=5
sort=1
rating=7
group=1
filter=1
where=AND `texts_news`=0 AND `dir` = 1
help=Тематическая группа, к которой принадлежит данная новость. Выберите из списка.
fileview=1
","","2010-08-21 19:28:46"),("31","rss","Включать в RSS","lkey","type=chb
rating=12
group=1
yes=включать в RSS
no=не включать в RSS
fileview=1","","2008-10-23 12:58:40"),("32","dir","Папка","lkey","type=chb
group=1
rating=6
table_list=7
table_list_name=-
table_list_nosort=1
table_list_width=16
yes=<img src="/admin/img/dtree/folder.gif">
no=<img src="/admin/img/dtree/doc.gif">
filter=1
help=Если установить данный флажок, то данная запись будет считаться папкой
template_w=field_checkbox_read
","","2010-08-28 19:20:08"),("33","rating","Рейтинг","lkey","type=d
group=1
rating=16
noview=1
dirview=1
template_w=field_rating
","texts_news_ru","0000-00-00 00:00:00"),("34","pict","Картинка","lkey","type=pict
rating=14
template_w=field_pict
template_r=field_pict_read
sizelimit=20000
ext=*.jpg;*.jpeg;*.tif
mini=209x161~montage
folder=/image/texts/
fileview=1
table_list=7
table_list_type=pict
table_list_name=-
help=Картинка для анонса новости","","2010-10-27 16:23:52"),("35","filename","Файл","lkey","type=filename
rating=2
sizelimit=20000
file_ext=*.*","","2010-10-29 12:20:44"),("36","deletepict","Флаг удаления картинки","lkey","type=chb
sys=1","","2008-10-30 17:42:45"),("37","image_gallery","Фото галерея","lkey","type=tlist
list=images_gallery
rating=15
group=1
where=AND `dir`=1
shablon_w=field_select_input
fileview=1
","","2010-08-21 19:28:46"),("38","id_news","Новости","lkey","type=tlist
list=texts_news_ru
rating=17
group=1
where=AND `dir` = 0
shablon_w=field_multselect_input
fileview=1
notnull=1","","2010-08-28 19:20:08"),("40","tdate","Дата","lkey","type=date
rating=10
group=1
qview=1
filter=1
fileview=1
table_list=8
table_list_width=70
template_f=field_date_filter
help=Укажите какой датой датировать эту запись
","","2010-10-27 11:04:12"),("44","add_link_dir","Тексты. Добавить папку","button","type_link=loadcontent
table_list_dir=1
controller=texts
imageiconmenu=/admin/img/icons/menu/icon_dir_add.png
action=add_dir
title=Создать папку
params=replaceme
rating=1","","0000-00-00 00:00:00"),("45","hide","Флаг скрыть","lkey","type=s
sys=1","","2010-10-28 15:33:25"),("46","show","Флаг показать","lkey","type=s
sys=1","","2010-10-28 15:33:36"),("59","year","Год","lkey","type=d","","2010-05-07 13:59:22"),("60","month","Месяц","lkey","type=d","","2010-05-07 13:59:22"),("61","day","День","lkey","type=d","","2010-05-07 13:59:22"),("86","texts","Тексты","menu","type_link=loadcontent
action=enter
program=/cgi-bin/text_a.cgi
rating=11
parentid=edit
replaceme=replaceme
submenuwidth=200
","","0000-00-00 00:00:00"),("66","texts_articles","Группа","lkey","type=tlist
list=texts_articles_ru
sort=1
rating=7
group=1
filter=1
where=AND `dir`=1
help=Тематическая группа, к которой принадлежит данная статья. Выберите из списка.
fileview=1
","","2010-07-06 16:01:54"),("67","author","Автор","lkey","type=s
filter=1
group=1
rating=25
no_format=1
help=Введите автора или ссылку на первоисточник","","2010-07-12 14:12:49"),("83","docfile","Документ","lkey","type=file
rating=14
template_w=field_file
template_r=field_file_read
sizelimit=20000
ext=*.*
folder=/docfiles/
fileview=1
table_list=2
help=Название документа
","","2010-10-25 15:11:09"),("84","docfile_size","Размер файла","lkey","type=filesize
template_w=field_input_read
table_list=5
table_list_name=Размер
table_list_width=70

","","2009-03-24 17:50:05"),("78","adate","Дата","lkey","type=date
rating=10
group=1
filter=1
fileview=1
help=Укажите какой датой датировать эту запись
","","2010-07-06 16:01:54"),("82","type_file","Тип файла","lkey","type=s
shablon_w=field_input_read
help=Тип файла картинки анонса
","","2009-05-26 16:21:19"),("88","send","Флаг отсылки","lkey","type=d
sys=1","","0000-00-00 00:00:00"),("127","anons","Анонс","lkey","type=html
rating=5
group=1
print=1
shablon_w=field_text
","","2009-12-18 15:37:15"),("157","texts_docfiles","Группа товаров или услуг","lkey","type=tlist
list=texts_docfiles_ru
sort=1
rating=10
group=1
filter=1
where= AND `texts_docfiles`>0
help=Выбирите группу товаров или услуг к которой относится данный документ ( предварительно необходимо выбрать подрубрику, после чего будет подгружен список )
fileview=1
","","2010-01-15 14:38:53"),("169","docfolder","Директория с файлами документов","lkey","type=s
sys=1","","0000-00-00 00:00:00"),("182","price","Цена","lkey","type=d
print=1
qview=1
qedit=1
table_list=4
table_list_width=70
fileview=1
rating=5
","","0000-00-00 00:00:00"),("184","stars","Звездность","lkey","type=list
list=1|1~2|2~3|3~4|4~5|5
list_type=radio
filter=1
table_list=6
table_list_width=70
rating=10
fileview=1
qedit=1
notnull=1

","","0000-00-00 00:00:00"),("187","h1","Заголовок h1","lkey","type=s
group=1
rating=2
qedit=1
qview=1
table_list=3
table_list_width=200
no_format=1
fileview=1
help=Заголовок страницы h1. Если он не заполнен, то используется заголовок из названия страницы","","2010-10-29 12:23:39"),("188","copy","Копировать запись","button","type_link=loadcontent
print_info=1
edit_info=1
controller=texts
action=copy
loading_msg=1
imageiconmenu=/admin/img/icons/menu/icon_copy.png
title=Копировать запись
rating=5
params=replaceme,index,list_table","","0000-00-00 00:00:00"),("189","map","Карта","lkey","type=map
rating=99
group=1
required=0","","");


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
) ENGINE=MyISAM AUTO_INCREMENT=65 DEFAULT CHARSET=utf8 COMMENT='Ключи к модулю Тексты';INSERT INTO `keys_users` ( `ID`,`lkey`,`name`,`object`,`settings`,`tbl`,`updated_at`)  VALUES 
("1","add_link","Добавить запись","button","type_link=openpage
position=center
id=newentry
table_list=1
print_info=1
controller=users
action=add
imageiconmenu=/admin/img/icons/menu/icon_add.png
title=Добавить
rating=1
params=replaceme,list_table","","0000-00-00 00:00:00"),("2","del_link","Удалить запись","button","type_link=loadcontent
controller=users
action=delete
confirm=Действительно удалить запись?
title=Удалить запись
imageiconmenu=/admin/img/icons/menu/icon_delete.png
print_info=1
rating=1
params=replaceme,index,list_table","","0000-00-00 00:00:00"),("3","edit_link","Редактировать запись","button","type_link=loadcontent
print_info=1
controller=users
action=edit
imageiconmenu=/admin/img/icons/menu/icon_edit.png
title=Редактировать запись
rating=2
params=replaceme,index,list_table","","0000-00-00 00:00:00"),("4","end_link","Закончить редактирование","button","type_link=loadcontent
edit_info=1
controller=users
action=info
imageiconmenu=/admin/img/icons/menu/icon_ok.png
title=Закончить редактирование
rating=10
params=replaceme,index,list_table
","","0000-00-00 00:00:00"),("5","filter","Фильтр","button","type_link=modullink
table_list=1
table_list_orders=1
controller=users
action=filter
imageiconmenu=/admin/img/icons/menu/icon_filter.png
title=Фильтр
width=690
height=510
level=3
rating=2
params=replaceme,list_table","","0000-00-00 00:00:00"),("6","filter_clear","Очистка фильтра","button","type_link=loadcontent
table_list=1
table_list_orders=1
table_list_dir=1
controller=users
action=filter_clear
imageiconmenu=/admin/img/icons/menu/icon_nofilter.png
title=Снять фильтры
rating=3
params=replaceme,list_table","","0000-00-00 00:00:00"),("7","name","Фамилия","lkey","type=s
filter=1
group=1
rating=1
required=1
qedit=1
table_list=1
no_format=1
fileview=1
register=1
obligatory=1
","","2010-10-31 11:29:29"),("52","active","Состояние учетной записи","lkey","type=chb
print=1
qview=1
qedit=1
filter=1
table_list=8
table_list_width=70
yes=Активна
no=Заблокирована
","","0000-00-00 00:00:00"),("53","cck","Ключ сессии","lkey","type=s
sys=1","","0000-00-00 00:00:00"),("41","pict","Картинка","lkey","type=pict
rating=14
template_w=field_pict
template_r=field_pict_read
sizelimit=20000
ext=*.jpg;*.jpeg;*.gif;
mini=117x77~montage,574x289~montage
folder=/image/catalog/
fileview=1
table_list=4
table_list_type=pict
table_list_name=-
","","0000-00-00 00:00:00"),("49","addr","Адрес","lkey","type=s
print=1
qview=1
qedit=1
rating=11

","","0000-00-00 00:00:00"),("50","phone","Телефон","lkey","type=s
print=1
qview=1
qedit=1
rating=13
table_list=4
table_list_width=100
register=1
","","0000-00-00 00:00:00"),("51","data","Настройки","lkey","type=code
sys=1
","","0000-00-00 00:00:00"),("39","rating","Рейтинг","lkey","type=d
group=1
qview=1
qedit=1
table_list=4
table_list_name=Rt
table_list_width=32
rating=6
shablon_w=field_rating
","","0000-00-00 00:00:00"),("16","do","Действие","lkey","type=s
sys=1
","","0000-00-00 00:00:00"),("54","vdate","Дата последней авторизации","lkey","type=time
print=1
table_list=9
table_list_width=100
shablon_w=field_input_read
","","0000-00-00 00:00:00"),("55","password","Пароль","lkey","type=s
print=1
rating=10
register=1
obligatory=1

","","0000-00-00 00:00:00"),("56","email","E-mail","lkey","type=email
print=1
qview=1
rating=15
table_list=6
table_list_width=100
register=1
obligatory=1
","","0000-00-00 00:00:00"),("58","company","Компания","lkey","type=s
print=1
qview=1
qedit=1
rating=16
fileview=1
","","0000-00-00 00:00:00"),("60","id_manager","Менеджер","lkey","type=tlist
list=data_projects_managers
print=1
qview=1
qedit=1
fileview=1
table_list=5
table_list_width=150
rating=20
filter=1
","","0000-00-00 00:00:00"),("61","post","Должность","lkey","type=s
print=1
qview=1
qedit=1
rating=15
fileview=1
","","0000-00-00 00:00:00"),("62","fname","Имя","lkey","type=s
print=1
qview=1
qedit=1
rating=3
fileview=1
table_list=3
table_list_width=100

","","0000-00-00 00:00:00"),("63","mname","Отчество","lkey","type=s
print=1
qview=1
qedit=1
rating=4
fileview=1
table_list=4
table_list_width=100

","","0000-00-00 00:00:00"),("64","copy","Копировать запись","button","type_link=loadcontent
print_info=1
edit_info=1
controller=users
action=copy
loading_msg=1
imageiconmenu=/admin/img/icons/menu/icon_copy.png
title=Копировать запись
rating=5
params=replaceme,index,list_table","","0000-00-00 00:00:00");


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
) ENGINE=MyISAM AUTO_INCREMENT=29 DEFAULT CHARSET=utf8 COMMENT='Ключи к модулю Vars';INSERT INTO `keys_vars` ( `ID`,`lkey`,`name`,`object`,`settings`,`tbl`,`updated_at`)  VALUES 
("3","list_link","Список переменных","button","type_link=loadcontent
add_info=1
controller=vars
imageiconmenu=/admin/img/icons/menu/button.list.png
action=enter
title=Список переменных
rating=1
params=replaceme","","0000-00-00 00:00:00"),("4","filter_clear","Глобальные переменные. Очистка фильтра","button","type_link=loadcontent
table_list=1
controller=vars
action=filter_clear
imageiconmenu=/admin/img/icons/menu/icon_nofilter.png
title=Снять фильтры
rating=3
params=replaceme","","0000-00-00 00:00:00"),("5","filter","Глобальные переменные. Фильтр","button","type_link=modullink
table_list=1
controller=vars
action=filter
imageiconmenu=/admin/img/icons/menu/icon_filter.png
title=Настроить фильтр
width=690
height=510
level=3
rating=2
params=replaceme","","0000-00-00 00:00:00"),("6","end_link","Закончить редактирование","button","type_link=loadcontent
edit_info=1
controller=vars
imageiconmenu=/admin/img/icons/menu/icon_ok.png
action=info
title=Закончить редактирование
rating=10
params=replaceme,index","","0000-00-00 00:00:00"),("7","edit_link","Редактировать запись","button","type_link=loadcontent
print_info=1
controller=vars
action=edit
imageiconmenu=/admin/img/icons/menu/icon_edit.png
title=Редактировать запись
rating=2
params=replaceme,index","","0000-00-00 00:00:00"),("8","del_link","Удалить запись","button","type_link=loadcontent
controller=vars
action=delete
imageiconmenu=/admin/img/icons/menu/icon_delete.png
confirm=Действительно удалить запись?
title=Удалить запись
print_info=1
rating=1
params=replaceme,index","","0000-00-00 00:00:00"),("10","add_link","Добавить запись","button","type_link=openpage
position=center
id=newentry
table_list=1
controller=vars
imageiconmenu=/admin/img/icons/menu/icon_add.png
action=add
title=Добавить запись
rating=1
params=replaceme","","0000-00-00 00:00:00"),("11","name","Название","lkey","type=s
rating=1
table_list=1
required=1
qedit=1
qview=1
help=Название переменной для удобства поиска","","2010-10-27 17:54:27"),("12","id_program","Программа (модуль)","lkey","type=tlist
list=sys_program
rating=2
table_list=2
qedit=1
qview=1
filter=1
help=Программный модуль, для которого действует данная переменная. Если программа не указана, то переменная является глобальной","","2010-10-27 17:54:27"),("13","envkey","Ключ переменной","lkey","type=s
rating=3
table_list=3
required=1
qedit=1
qview=1
help=Ключ переменной, по которому можно вызвать данную переменную в шаблоне или программе.","","2010-10-27 17:54:27"),("14","envvalue","Значение","lkey","type=code
rating=5
max=99999
","","2010-10-27 17:54:27"),("17","comment","Комментарий","lkey","type=code
rating=10
","","2010-10-27 17:54:27"),("18","groups_list","Доступно для групп","lkey","type=tlist
list=lst_group_user
group=1
rating=129
default=6
shablon_w=field_multselect
notnull=1
help=Группы пользователей, которые могут изменять данную переменную","","2010-10-27 17:54:27"),("25","vars","Глобальные переменные","menu","type_link=loadcontent
action=enter
program=/cgi-bin/vars_a.cgi
rating=22
parentid=setting
replaceme=replaceme
submenuwidth=200","","0000-00-00 00:00:00"),("26","users_list","Доступно для пользователей","lkey","type=tlist
list=sys_users
group=1
rating=128
mult=5
shablon_w=field_multselect
notnull=1
help=Пользователи, которые могут изменять данную переменную","","0000-00-00 00:00:00"),("27","settings","Параметры поля","lkey","type=code
rating=4

","","0000-00-00 00:00:00"),("28","copy","Копировать запись","button","type_link=loadcontent
print_info=1
edit_info=1
controller=vars
action=copy
loading_msg=1
imageiconmenu=/admin/img/icons/menu/icon_copy.png
title=Копировать запись
rating=5
params=replaceme,index,list_table","","0000-00-00 00:00:00");


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
) ENGINE=MyISAM AUTO_INCREMENT=119 DEFAULT CHARSET=utf8 COMMENT='Ключи к модулю Видео';INSERT INTO `keys_video` ( `ID`,`lkey`,`name`,`object`,`settings`,`tbl`,`updated_at`)  VALUES 
("1","add_link","Добавить запись","button","type_link=loadcontent
table_list=1
print_info=1
table_list_dir=1
program=/cgi-bin/portfolio_a.cgi
imageiconmenu=/admin/img/icons/menu/icon_add.png
action=add
title=Добавить
rating=1
params=replaceme,list_table","","0000-00-00 00:00:00"),("2","del_link","Удалить запись","button","type_link=loadcontent
program=/cgi-bin/portfolio_a.cgi
action=delete
confirm=Действительно удалить запись?
title=Удалить запись
imageiconmenu=/admin/img/icons/menu/icon_delete.png
print_info=1
rating=1
params=replaceme,index,list_table","","0000-00-00 00:00:00"),("3","edit_link","Редактировать запись","button","type_link=loadcontent
print_info=1
program=/cgi-bin/portfolio_a.cgi
imageiconmenu=/admin/img/icons/menu/icon_edit.png
action=edit
title=Редактировать запись
rating=2
params=replaceme,index,list_table","","0000-00-00 00:00:00"),("4","end_link","Закончить редактирование","button","type_link=loadcontent
edit_info=1
program=/cgi-bin/portfolio_a.cgi
action=info
imageiconmenu=/admin/img/icons/menu/icon_ok.png
title=Закончить редактирование
rating=1
params=replaceme,index,list_table
","","0000-00-00 00:00:00"),("5","filter","Фильтр","button","type_link=modullink
table_list=1
table_list_orders=1
table_list_dir=1
program=/cgi-bin/portfolio_a.cgi
imageiconmenu=/admin/img/icons/menu/icon_filter.png
action=filter
title=Фильтр
width=690
height=510
level=3
rating=2
params=replaceme,list_table","","0000-00-00 00:00:00"),("6","filter_clear","Очистка фильтра","button","type_link=loadcontent
table_list=1
table_list_orders=1
table_list_dir=1
program=/cgi-bin/portfolio_a.cgi
imageiconmenu=/admin/img/icons/menu/icon_nofilter.png
action=filter_clear
title=Снять фильтры
rating=3
params=replaceme,list_table","","0000-00-00 00:00:00"),("7","name","Наименование","lkey","type=s
filter=1
group=1
rating=1
required=1
qedit=1
table_list=1
no_format=1
fileview=1
dirview=1","","2011-12-07 14:34:14"),("8","articul","Артикул","lkey","type=s
filter=1
rating=3
print=1
qview=1
qedit=1
fileview=1
group=1
table_list=5

","","2011-09-28 18:45:41"),("19","active","Показывать на сайте","lkey","type=chb
rating=99
group=1
table_list=12
table_list_name=-
table_list_width=48
yes=виден
no=скрыт
filter=1
dirview=1
fileview=1
help=Если видео требуется временно скрыть, просто установите данный флажок.","","2011-12-07 14:34:14"),("97","name","Модель","lkey","type=s
filter=1
group=1
rating=1
required=1
qedit=1
table_list=1
no_format=1
fileview=1
","data_catalog_items","2011-10-24 16:41:25"),("21","rating","Рейтинг","lkey","type=d
rating=90
print=1
fileview=1
group=1
table_list=7
qedit=1
table_list_name=Rt
table_list_width=32
shablon_w=field_rating
dirview=1","","2011-12-07 14:34:14"),("22","pict","Фото","lkey","type=pict
rating=24
table_list=10
table_list_name=-
table_list_type=pict
folder=/images/video/
table_list_nosort=1
shablon_w=field_pict
shablon_r=field_pict_read
sizelimit=20000
mini=547x294~crop,297x168~crop
ext=*.jpg;*.jpeg;*.gif;*.tif
fileview=1
help=Загрузите изображение на сервер","","2014-05-20 19:38:52"),("23","filename","Файл","lkey","type=filename
rating=3
sizelimit=200000
file_ext=*.*
help=Для загрузки файла нажмите на кнопку <b>Выбрать</b>","","2011-12-07 14:34:13"),("24","type_file","Тип файла","lkey","type=slat
sys=1","","2011-04-08 01:12:56"),("109","videofile","Видео","lkey","type=filename
rating=14
shablon_w=field_file
shablon_r=field_file_link
sizelimit=20000
file_ext=*.*
fileview=1
table_list=2
","","2011-12-05 19:19:18"),("26","images","Фото","lkey","type=table
table=dtbl_images
group=3
rating=301
table_fields=type_file,name,folder,pict,rating,rdate
table_svf=id_data_catalog
table_sortfield=name
table_buttons_key_w=delete_select,edit
table_buttons_key_r=upload
table_groupname=Информация по файлу
table_upload=1
table_icontype=1
table_noindex=1
shablon_w=field_table
shablon_r=field_table","","2011-04-08 01:12:56"),("29","text","Описание","lkey","type=html
rating=90
group=1
cktoolbar=Basic
","","2011-08-05 15:17:31"),("33","rdate","Дата","lkey","type=time
rating=6
print=1
qview=1
sys=1

","","2011-04-08 01:12:56"),("101","alias","Алиас","lkey","type=s
rating=3
table_list=2
table_list_width=70
group=1
qview=1
qedit=1
help=Короткое латинское название, используется для формирование url на эту страницу
dirview=1
required=1
","","2011-12-07 14:34:14"),("42","price","Цена","lkey","type=s
print=1
group=1
rating=17
table_list=4
table_list_width=70
qview=1
qedit=1

","","2011-12-05 18:13:01"),("54","active","Показывать на сайте","list","list=0|Нет~1|Да
type=radio
","","0000-00-00 00:00:00"),("61","list_link","Список","button","type_link=loadcontent
#add_info=1
#print_info=1
program=/cgi-bin/portfolio_a.cgi
imageiconmenu=/admin/img/icons/menu/button.list.png
action=enter
title=Список
rating=1
params=replaceme,list_table","","0000-00-00 00:00:00"),("103","id_group","Группа","lkey","type=tlist
list=data_portfolio_groups
print=1
qview=1
filter=1
rating=3
table_list=4
table_list_width=100
required=1
","","2011-12-07 14:34:14"),("110","youtubelink","Ссылка на видео YouTube","lkey","type=s
print=1
qview=1
qedit=1
rating=10
table_list=4
table_list_width=100
fileview=1
help=Укажите ID или полную ссылку на видео
","","2011-12-07 14:34:14"),("111","id_video","Вложена в папку","lkey","type=tlist
list=data_video
print=1
qview=1
qedit=1
fileview=1
filter=1
where= AND `dir`='1'  AND `id_video`=0 
rating=10
table_list=3
table_list_width=200
","","0000-00-00 00:00:00"),("112","dir","Папка","lkey","type=chb
group=1
rating=6
table_list=1
table_list_name=-
table_list_nosort=1
table_list_width=16
yes=<img src="/admin/img/dtree/folder.gif">
no=<img src="/admin/img/dtree/doc.gif">
filter=1
dirview=1
fileview=1","","0000-00-00 00:00:00"),("113","add_link_dir","Видео. Добавить папку","button","type_link=loadcontent
table_list=1
controller=video
imageiconmenu=/admin/img/icons/menu/icon_dir_add.png
action=add_dir
title=Создать папку
params=replaceme
rating=1
","","0000-00-00 00:00:00"),("114","description","Описание","lkey","type=text
rating=90
group=1
dirview=1
fileview=1
qview=1
qedit=1
","","0000-00-00 00:00:00"),("115","tdate","Датировать датой","lkey","type=date
rating=50
group=1
qview=1
filter=1
dirview=1
table_list=8
table_list_width=70
template_f=field_date_filter","","2010-10-27 11:04:12"),("116","has_mainpage","Показывать на главной странице","lkey","type=chb
print=1
qview=1
qedit=1
filter=1
rating=99
table_list=10
table_list_width=70
yes=да
no=нет
dirview=1
","","0000-00-00 00:00:00"),("117","id_category","Категория","lkey","type=tlist
list=lst_media_groups
print=1
qview=1
filter=1
add_to_list=1
win_scroll=0
win_height=100
rating=5
","","2014-05-20 20:40:16"),("118","vimeolink","Ссылка на видео Vimeo","lkey","type=s
print=1
qview=1
qedit=1
rating=11
table_list=5
table_list_width=100
fileview=1
help=Укажите ID или полную ссылку на видео
","","2011-12-07 14:34:14");


CREATE TABLE `lst_banner_urls` (
  `ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `lst_catalog_list` (
  `ID` int(6) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=MyISAM AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

CREATE TABLE `lst_group_user` (
  `ID` tinyint(3) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(32) NOT NULL DEFAULT '',
  PRIMARY KEY (`ID`)
) ENGINE=MyISAM AUTO_INCREMENT=7 DEFAULT CHARSET=utf8 COMMENT='Группы пользователей';

CREATE TABLE `lst_images` (
  `ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL DEFAULT '',
  `key_razdel` varchar(32) NOT NULL DEFAULT '',
  `groups_list` varchar(255) NOT NULL DEFAULT '',
  `users_list` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`ID`),
  UNIQUE KEY `key_razdel` (`key_razdel`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COMMENT='Разделы базы изображений';

CREATE TABLE `lst_layouts` (
  `ID` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `layout` varchar(255) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

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
) ENGINE=MyISAM AUTO_INCREMENT=9 DEFAULT CHARSET=utf8 COMMENT='Разделы текстовой базы';

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
) ENGINE=MyISAM AUTO_INCREMENT=27 DEFAULT CHARSET=utf8 COMMENT='Правила политики безопасности';INSERT INTO `sys_access` ( `ID`,`cck`,`created_at`,`d`,`id_group_user`,`modul`,`objectname`,`objecttype`,`r`,`updated_at`,`users`,`w`)  VALUES 
("1","11eahKQhgdxuE","2011-10-29 20:24:44","1","6","","data_banner=data_catalog_items=data_faq=data_feedback=data_seo_meta=data_subscribe=data_users=dtbl_banner_stat=dtbl_catalog_items_images=dtbl_subscribe_stat=dtbl_subscribe_users=images_gallery=lst_catalog_list=texts_main_ru=texts_news_ru","table","1","2014-02-26 23:49:24","","1"),("2","01dgKPEiFI6/2","2011-10-29 20:26:15","","6","","lst_group_user=lst_images=lst_texts","table","1","2012-11-16 15:13:07","",""),("6","11GmsOurPH43E","2011-10-29 21:15:12","1","6","61","link=author=alias=anons=texts_main=id_data_video=rss=year=texts_articles=texts_news=texts_docfiles=tdate=adate=day=docfile=title=stars=pict=keywords=description=month=url_for=name=id_news=viewtext=dir=razdel=size=rating=place=text=type_file=filename=image_gallery=price=page_shablon=menu=nomap","lkey","1","2012-07-13 16:03:10","","1"),("19","01P0T8Mc0zYlY","2012-07-13 20:03:17","","6","61","delnot","lkey","1","2012-07-13 16:03:33","",""),("20","01LhT0dObGc5Q","2012-07-13 20:03:37","","6","61","add_link=end_link=filter_clear=edit_link=list_link=add_link_dir=del_link=filter","button","1","2012-09-18 12:30:26","",""),("4","11s2YJBHWDjEE","2011-10-29 20:28:46","1","6","","68=62=4=60=32=12=67=3=61=69","modul","1","2014-02-26 23:49:52","","1"),("5","01Ge2NaUJAgWw","2011-10-29 20:31:26","","6","32","object","menu","1","2014-03-01 13:40:43","",""),("8","01GXuIo7CPjF2","2011-10-29 23:02:02","","6","32","seo=logout=vars=catalog=admin=syslogs=lists=texts=sysusers=filemanager","button","1","2014-02-26 23:50:17","",""),("9","00PHiAWCKowyo","2011-11-28 16:34:19","","6","3","add_link=end_link=list_link=filter_clear=filter","button","1","2011-11-28 12:34:30","",""),("10","10CSi38DZVS8Q","2011-11-28 16:34:35","1","6","3","ulclass=email=max=weight=height=id_city=id_group_user=key_razdel=login=name=id_vilage=min=active=password=id_docfiles_subrubrics=users=id_recall=id_project=id_region=rating=id_rubrics=id_docfiles_rubrics=listf=link=per_click=per_show=id_countries=text=foto1=foto2=foto3=id_equipimg=id_images=width","lkey","1","2011-11-28 12:34:43","","1"),("11","00OrpeYwtHQqw","2011-11-28 16:35:08","","6","62","add_link=end_link=filter_clear=edit_link=list_link=del_link=filter","button","1","2011-11-28 12:35:19","",""),("12","10b/ML8RsME06","2011-11-28 16:35:23","1","6","62","ip_data_click=link=cash=time=height=tdate=showdateend=showdatefirst=week=titlelink=docfile=code=click_count=view_count=id_advert_block=name=view=target=size=rating=id_advert_users=click_pay=view_pay=list_page=stat=textlink=type_show=type_file=filename=width=texts_main_ru","lkey","1","2011-11-28 12:35:28","","1"),("13","00JoMr.WsBzOk","2011-11-28 16:35:35","","6","4","filter_clear=filter=end_link=edit_link=list_link","button","1","2011-11-28 12:35:51","",""),("14","10L5lVbsabVEw","2011-11-28 16:35:54","1","6","4","envvalue","lkey","1","2011-11-28 12:36:44","","1"),("15","00E1Cs1WHkPlk","2011-11-28 16:36:47","","6","4","groups_list=users_list=set_def=name=help=id_program","lkey","1","2011-11-28 12:37:12","",""),("16","00hg4dUwyLVF6","2011-11-28 16:52:13","","6","12","add_link=end_link=edit_link=list_link=del_link=filter_clear=filter","button","1","2011-11-28 12:52:25","",""),("17","11aFreujZ8rDE","2011-11-28 16:52:28","1","6","12","email=groups_list=users_list=bip=name=login=password=ip","lkey","1","2012-10-08 18:34:33","","1"),("18","01ojkmyuN8xjE","2011-11-28 16:53:34","","6","12","id_group_user=vdate=bip=btime=count=ip","lkey","1","2012-10-08 18:34:46","",""),("21","11XApzbNH3SWc","2013-06-24 19:16:58","1","6","32","alias=index=do","lkey","1","2013-06-24 15:17:31","","1"),("22","11NiQehBWD2/s","2014-02-26 23:47:58","1","6","68","name=keywords=description=url","lkey","1","2014-02-26 23:48:07","","1"),("23","01R/7Kl.SZGUs","2014-02-26 23:48:11","","6","68","add_link=end_link=filter_clear=edit_link=del_link=filter","button","1","2014-02-26 23:48:17","",""),("24","11rxcFz2cFY.s","2014-02-26 23:48:23","1","6","69","","lkey","1","2014-02-26 23:48:35","","1"),("25","11r/RMyKgBSi6","2014-02-26 23:48:44","1","6","67","ip=id_sysusergroup=rdate=name=comment=id_program=id_sysuser=eventtype","lkey","1","2014-02-26 23:48:53","","1"),("26","019dlmqGQs2Co","2014-02-26 23:48:57","","6","67","list_link=del_link=filter_clear=filter","button","1","2014-02-26 23:49:04","","");


CREATE TABLE `sys_blockip` (
  `ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `ip` varchar(15) NOT NULL DEFAULT '',
  `block` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `ip` (`ip`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Заблокированные IP';CREATE TABLE `sys_changes` (
  `ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `list_table` varchar(255) DEFAULT '0',
  `item_id` int(10) unsigned NOT NULL,
  `lkey` varchar(255) DEFAULT '0',
  `value` text,
  `operator` varchar(255) DEFAULT '',
  `created_at` datetime DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8 COMMENT='История изменений';CREATE TABLE `sys_datalogs` (
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
) ENGINE=MyISAM AUTO_INCREMENT=43 DEFAULT CHARSET=utf8 COMMENT='Логи работы с панелью';INSERT INTO `sys_datalogs` ( `ID`,`comment`,`created_at`,`eventtype`,`id_program`,`id_sysuser`,`id_sysusergroup`,`ip`,`name`)  VALUES 
("31","Обновление запись [1] «Главная страница123». Основные тексты » Тексты [texts_main_ru]","2015-10-23 22:28:44","3","61","1","6","127.0.0.1","Обновление запись в Основные тексты » Тексты"),("30","","2015-10-23 22:18:54","5","61","1","6","127.0.0.1","Авторизация прошла успешно"),("29","Обновление запись [1] «Главная страница123». Основные тексты » Тексты [texts_main_ru]","2015-10-23 22:11:32","3","61","1","6","127.0.0.1","Обновление запись в Основные тексты » Тексты"),("28","Обновление запись [1] «Главная страница123». Основные тексты » Тексты [texts_main_ru]","2015-10-23 22:01:33","3","61","1","6","127.0.0.1","Обновление запись в Основные тексты » Тексты"),("25","","2015-10-23 21:10:26","5","","1","6","127.0.0.1","Авторизация прошла успешно"),("26","","2015-10-23 21:13:54","5","","1","6","127.0.0.1","Авторизация прошла успешно"),("27","","2015-10-23 21:57:19","5","61","1","6","127.0.0.1","Авторизация прошла успешно"),("24","","2015-10-23 20:47:45","5","","1","6","127.0.0.1","Авторизация прошла успешно"),("21","","2015-10-23 20:35:20","5","","1","6","127.0.0.1","Авторизация прошла успешно"),("22","","2015-10-23 20:36:07","5","","1","6","127.0.0.1","Авторизация прошла успешно"),("23","","2015-10-23 20:38:27","5","","1","6","127.0.0.1","Авторизация прошла успешно"),("19","","2015-10-23 19:55:37","5","","1","6","127.0.0.1","Авторизация прошла успешно"),("20","","2015-10-23 20:29:15","5","","1","6","127.0.0.1","Авторизация прошла успешно"),("17","","2015-10-23 19:46:18","5","","1","6","127.0.0.1","Авторизация прошла успешно"),("18","","2015-10-23 19:46:54","5","","1","6","127.0.0.1","Авторизация прошла успешно"),("16","Добавление запись [189] «Карта». Ключи [keys_texts]","2015-10-23 19:45:01","1","6","1","6","127.0.0.1","Добавление запись в Ключи"),("14","","2015-10-23 19:37:45","5","","1","6","127.0.0.1","Авторизация прошла успешно"),("15","","2015-10-23 19:41:28","5","","1","6","127.0.0.1","Авторизация прошла успешно"),("32","Обновление запись [1] «Главная страница123». Основные тексты » Тексты [texts_main_ru]","2015-10-23 22:34:41","3","61","1","6","127.0.0.1","Обновление запись в Основные тексты » Тексты"),("33","","2015-10-26 12:51:06","5","","1","6","127.0.0.1","Авторизация прошла успешно"),("34","","2015-10-26 13:41:35","5","61","1","6","127.0.0.1","Авторизация прошла успешно"),("35","","2015-10-26 13:46:39","5","","1","6","127.0.0.1","Авторизация прошла успешно"),("36","","2015-10-26 13:59:03","5","","1","6","127.0.0.1","Авторизация прошла успешно"),("37","Обновление запись [1] «Главная страница123». Основные тексты » Тексты [texts_main_ru]","2015-10-26 14:05:27","3","61","1","6","127.0.0.1","Обновление запись в Основные тексты » Тексты"),("38","","2015-10-26 14:06:06","5","","1","6","127.0.0.1","Авторизация прошла успешно"),("39","Обновление запись [1] «Главная страница123». Основные тексты » Тексты [texts_main_ru]","2015-10-26 14:07:33","3","61","1","6","127.0.0.1","Обновление запись в Основные тексты » Тексты"),("40","","2015-10-26 15:39:15","5","","1","6","127.0.0.1","Авторизация прошла успешно"),("41","","2015-10-26 18:26:07","5","","1","6","127.0.0.1","Авторизация прошла успешно"),("42","","2015-11-05 15:38:26","5","","1","6","127.0.0.1","Авторизация прошла успешно");


CREATE TABLE `sys_filemanager_cache` (
  `hash` varchar(100) NOT NULL DEFAULT '',
  `info` blob,
  `updated` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`hash`),
  KEY `updated` (`updated`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;CREATE TABLE `sys_history` (
  `id_user` int(11) NOT NULL DEFAULT '0',
  `link` text NOT NULL,
  `title` varchar(255) DEFAULT NULL,
  `replaceme` varchar(128) NOT NULL DEFAULT '',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY `id_user` (`id_user`,`replaceme`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Таблица с историей загрузки доку';CREATE TABLE `sys_lists` (
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
) ENGINE=MyISAM AUTO_INCREMENT=13 DEFAULT CHARSET=utf8 PACK_KEYS=0 COMMENT='Справочники';INSERT INTO `sys_lists` ( `ID`,`editlist`,`height`,`listf`,`lkey`,`name`,`scroll`,`width`)  VALUES 
("1","","","ID,name,key_razdel","sys_program","Список программных модулей","",""),("2","1","","ID,name","lst_group_user","Группы пользователей","",""),("3","","","ID,name","sys_users","Пользователи","",""),("10","","","ID,name,layout","lst_layouts","Шаблоны страниц","",""),("12","1","","ID,name","lst_banner_urls","Баннерокрутилка. URL страниц","","");


CREATE TABLE `sys_lkeys_log` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `keys_tbl` varchar(32) NOT NULL DEFAULT '',
  `qstring` text NOT NULL,
  `keys_send` longtext NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Лог переданных параметров';CREATE TABLE `sys_mysql_error` (
  `sql` text NOT NULL,
  `error` text NOT NULL,
  `qstring` varchar(255) NOT NULL DEFAULT '',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Ошибки MySQL';CREATE TABLE `sys_program` (
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
) ENGINE=MyISAM AUTO_INCREMENT=72 DEFAULT CHARSET=utf8 PACK_KEYS=0 COMMENT='Список программ';INSERT INTO `sys_program` ( `ID`,`default_table`,`en`,`help`,`key_razdel`,`keys_table`,`menu_btn_key`,`name`,`pict`,`prgroup`,`ru`,`settings`)  VALUES 
("3","","","Модуль для работы со справочниками и списками.","lists","keys_lists","menu_settings","Справочники","/admin/img/icons/program/lists.png","4","1","groupname=Общая информация
qsearch=1
qedit=1
qview=1
tree=1"),("4","sys_vars","","Модуль для настройки глобальных переменных.","vars","keys_vars","menu_settings","Глобальные переменные","/admin/img/icons/program/settings.png","4","1","groupname=Общая информация
qsearch=1
qedit=1
qview=1
tree=1
"),("1","","","Главная страница панели управления","admin","keys_mainconfig","menu_settings","Настройки","/admin/img/icons/menu/icon_home.gif","4","","groupname="),("6","","","Модуль для работы с ключами: ключами, кнопками, списками.","keys","keys_keys","menu_settings","Ключи","/admin/img/icons/program/object.png","4","1","groupname=Ключ
qsearch=1
qedit=1
qview=1
tree=1

"),("9","","","Модуль для редактирования таблиц стилей.","styles","keys_styles","menu_settings","Стили","/admin/img/icons/program/styles.png","4","1","groupname=Общая информация
qsearch=1"),("11","sys_access","","Модуль для определение доступа к модулям, таблицам, полям.","access","keys_access","menu_settings","Права доступа","/admin/img/icons/program/access.png","4","1","groupname=Тип объекта|Модуль|Настрока прав доступа
qsearch=1
qedit=1
qview=1
tree=1
"),("12","sys_users","","Модуль для управления учетными записями пользователей.","sysusers","keys_sysusers","menu_settings","Пользователи","/admin/img/icons/program/users.png","4","1","groupname=Общая информация
qsearch=1
qedit=1
qview=1
tree=1
"),("5","","","Модуль для работы с шаблонами.","templates","keys_templates","menu_settings","Шаблоны","/admin/img/icons/program/templates.png","4","1","groupname=Шаблон
qsearch=1
qedit=1
qview=1
tree=0
"),("32","","","Главная страница панели управления","global","keys_global","menu_button","Панель управления","/admin/img/icons/menu/icon_home.gif","4","","groupname="),("60","data_catalog_items","","Модуль работы с каталогом","catalog","keys_catalog","menu_center","Каталог","/admin/img/icons/program/catalog2.png","3","1","groupname=Общие данные|Фото
groupname_categorys=Общие данные
groupname_brands=Общие данные
groupname_set=Общие данные
qsearch=1
qedit=1
qview=1
defcol=1
table_indexes=1
follow_changes=1

"),("61","texts_main_ru","1","Модуль для работы с текстами: добавление, редактирование, удаление, построение спискови и меню.","texts","keys_texts","mainrazdel_button","Тексты","/admin/img/icons/program/text.png","1","1","groupname=Общая информация|Текст
groupname_docfiles=Общая информация
groupname_soffers=Общая информация
groupname_floating=Общая информация
qsearch=1
razdels=1
change_lang=1
qedit=1
qview=1
tree=1
follow_changes=1
"),("62","data_banner","","Модуль для управления показами рекламных баннеров на сайте.","banners","keys_banners","menu_banner","Баннерокрутилка","/admin/img/icons/program/banner.png","3","1","groupname=Общие данные|Рекламный блок|Настройки таргетинга|Статистика
defcol=1
qsearch=1
qedit=1
qview=1
excel=1
tree=1"),("63","images_gallery","","Модуль для работы с изображениями: добавление, редактирование, удаление.","images","keys_images","mainrazdel_button","Изображения","/admin/img/icons/program/image.png","1","","groupname=Общая информация
groupname_catalog=Общая информация
qsearch=1
razdels=1
qedit=1
qview=1
tree=1
"),("64","data_faq","","Модуль для работы с вопрос-ответ: редактирование, удаление.","faq","keys_faq","menu_center","Вопрос-ответ","/admin/img/icons/program/faq.png","3","1","groupname=Общая информация
qsearch=1
#qedit=1
qview=1"),("66","data_users","","Модуль для управления учетными записями внешних пользователей.","users","keys_users","menu_center","Внешние пользователи","/admin/img/icons/program/users.gif","3","1","groupname=Общая информация
qsearch=1
qedit=1
qview=1
"),("67","sys_datalogs","","Модуль для просмотра системных логов пользователей","syslogs","keys_syslogs","menu_settings","Системный журнал","/admin/img/icons/program/syslogs.png","4","1","groupname=Общая информация
qsearch=1
qview=1
"),("68","data_seo_meta","","Модуль для работы с meta тегами страниц","seo","keys_seo","menu_settings","SEO","/admin/img/icons/program/seo.png","4","1","groupname=Общая информация
qsearch=1
qview=1
"),("69","","1","Модуль для работы с файлами","filemanager","keys_filemanager","mainrazdel_button","Файлменеджер","/admin/img/icons/program/filemanager.png","1","1","groupname=Общая информация
"),("70","data_redirects","","Модуль для создания редиректов страницу","redirects","keys_redirects","menu_settings","301 Redirect","/admin/img/icons/program/redirects.png","4","1","groupname=Общая информация
qsearch=1
qview=1
"),("71","data_recall","","Модуль для работы с отзывами: редактирование, удаление.","recall","keys_recall","menu_center","Отзывы","/admin/img/icons/program/links.png","3","1","groupname=Общая информация
qsearch=1
qedit=1
follow_changes=1
qview=1");


CREATE TABLE `sys_program_tables` (
  `ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `table` varchar(50) NOT NULL,
  `program_id` smallint(5) unsigned DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `table` (`table`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;INSERT INTO `sys_program_tables` ( `ID`,`name`,`program_id`,`table`)  VALUES 
("1","Товары","60","data_catalog_items"),("2","Категории","60","data_catalog_categories"),("3","Бренды","60","data_catalog_brands"),("4","Заказы","60","data_catalog_orders"),("5","Баннеры","62","data_banner"),("6","Рекламные места","62","data_banner_advert_block"),("7","Рекламодатели","62","data_banner_advert_users");


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
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;INSERT INTO `sys_related` ( `ID`,`delete`,`field`,`mult`,`tbl_dep`,`tbl_dep_title`,`tbl_main`,`tbl_main_title`)  VALUES 
("1","","id_advert_block","1","data_banner","","lst_advert_block",""),("2","1","id_order","","dtbl_orders","заказы.товары","data_catalog_orders","заказы");


CREATE TABLE `sys_users` (
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
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 PACK_KEYS=0 COMMENT='Таблица пользователей';INSERT INTO `sys_users` ( `ID`,`access`,`bip`,`btime`,`count`,`created_at`,`email`,`groups_list`,`id_group_user`,`login`,`name`,`password_digest`,`settings`,`sys`,`updated_at`,`users_list`,`vdate`,`vfe`)  VALUES 
("1","eyJtb2R1bCI6eyI2OCI6MSwiNjYiOjEsIjUiOjEsIjYxIjoxLCI2NyI6MSwiNjMiOjEsIjY0IjoxLCI5IjoxLCIxMiI6MSwiMSI6MSwiMTEiOjEsIjYwIjoxLCI2OSI6MSwiMzIiOjEsIjcxIjoxLCIzIjoxLCI2IjoxLCI3MCI6MSwiNCI6MSwiNjIiOjF9fQ-=","10.0.2.2","","","2009-01-31 16:23:35","dev@ifrog.ru,rn.dev@ifrog.ru","","6","root","Системный администратор","$2a$06$LUDXRF/MXxDLKRXNcUqzKOiX106yfsAExsnieDocZo8mJaPeuzaDu","catalog_data_catalog_categorys_page=1
keys_keys_catalog_page=1
sysusers_sys_users_pcol=25
images_page_doptable=1
lists_lst_group_user_page=1
texts_texts_floating_ru_page=1
banners_qedit=1
stat_page_doptable=3
lang=ru
catalog_data_catalog_items_asc=asc
catalog_data_catalog_items_page=1
texts_texts_main_ru_pcol=25
vars_sys_vars_pcol=50
banners_data_banner_page=1
faq_data_faq_page=1
users_data_users_page=1
texts_sfield=ID
stat_pcol_doptable=25
syslogs_sys_datalogs_page=1
images_sfield=ID
keys_keys_texts_page=1
keys_keys_keys_page=1
redirects_data_redirects_page=1
texts_texts_news_ru_page=1
_texts_floating_ru_sfield=ID
access_sys_access_page=1
catalog_data_catalog_items_sfield=name
keys_keys_catalog_filter_take=1
keys_keys_styles_page=1
texts_pcol=25
keys_keys_faq_page=1
texts_razdel=1
_page=1
keys_keys_vars_page=1
rightwin_hidden=1
lists_lst_advert_users_page=1
vars_sys_vars_page=1
images_images_gallery_page=1
texts_filter_tdatepref=>
syslogs_sys_datalogs_pcol=25
images_page=1
syslogs_sys_datalogs_filter_rdate=2014-02-20 00:00:00
redirects_data_redirects_pcol=25
keys_keys_auth_page=1
subscribe_dtbl_subscribe_users_page=1
images_images_gallery_pcol=25
syslogs_sys_datalogs_filter_rdatepref=>
texts_texts_main_ru_sfield=ID
texts_texts_floating_ru_sfield=ID
lists_lst_advert_block_page=1
_sfield=ID
keys_keys_mainconfig_pcol=25
banners_data_banner_advert_block_page=1
keys_keys_lists_page=1
texts_qedit=1
texts_texts_news_ru_sfield=ID
seo_data_seo_meta_page=1
texts_texts_main_ru_page=1
catalog_qedit=1
catalog_data_catalog_brands_page=1
_texts_floating_ru_page=1
images_razdel=1
texts_page=1
subscribe_data_subscribe_page=1
banners_data_banner_advert_users_page=1
sysusers_sys_users_page=1
keys_keys_access_page=1
catalog_data_catalog_items_pcol=25
keys_keys_banners_page=1
keys_keys_mainconfig_page=1","1","2011-11-16 22:28:16","1","","1"),("3","eyJtb2R1bCI6eyIxMiI6MSwiNCI6MSwiNjkiOjEsIjYxIjoxLCIzMiI6MSwiNjciOjEsIjY4IjoxLCI2MCI6MSwiMyI6MSwiNjIiOjF9fQ-=","10.0.2.2","","","2011-05-07 19:14:35","ifrogseo@gmail.com","","6","user","Администратор","$2a$06$Jy7yYkrAQ1bPLB/qOSH/Yu8wuhLzpJt9BlAPk1OyOUcwpWu.qg4Su","lang=ru
texts_sfield=ID
texts_pcol=25
catalog_data_catalog_items_page=1
texts_razdel=1
vars_sys_vars_page=1
texts_page=1
lists_lst_group_user_page=1
_sfield=ID","","0000-00-00 00:00:00","3","","1");


CREATE TABLE `sys_users_session` (
  `cck` varchar(32) NOT NULL,
  `time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `host` varchar(100) NOT NULL,
  `ip` varchar(100) NOT NULL,
  `id_user` int(6) unsigned NOT NULL,
  `data` blob,
  PRIMARY KEY (`id_user`,`cck`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;CREATE TABLE `sys_vars` (
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
) ENGINE=MyISAM AUTO_INCREMENT=12 DEFAULT CHARSET=utf8 PACK_KEYS=0 COMMENT='Глобальные переменные';INSERT INTO `sys_vars` ( `ID`,`comment`,`envkey`,`envvalue`,`groups_list`,`id_program`,`name`,`operator`,`settings`,`types`,`updated_at`,`users_list`)  VALUES 
("1","","site_name","GG v9","3=6","","Название сайта","","","s","",""),("4","60","time_log","60","6","","Сохранять лог операций дней","","","d","",""),("5","","email_admin","vdovin.a.a@gmail.com
","3=6","","E-mail администратора сайта","","","email","",""),("6","1000","filemanager_max_image_size","1000","3=6","","Максимальный размер картинок в файлменеджере","","","d","","1=3"),("10","","test","1=2=3","6","","Тестовая список","","list=1|Параметр 1~2|Параметр 2~3|Параметр 3
","list_chb","","1"),("11","Введите ключ для сервиса Uploadcare. После добавления ключа требуется перезагрузка административной панели ( Ctrl+F5 )","UPLOADCARE_PUBLIC_KEY","2d0e67e1e5f8a8d96345","6","","Uploadcare ключ","","","s","","");


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
) ENGINE=MyISAM AUTO_INCREMENT=25 DEFAULT CHARSET=utf8 PACK_KEYS=0;

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
) ENGINE=MyISAM AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 COMMENT='Новостная лента';

