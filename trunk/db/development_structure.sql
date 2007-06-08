CREATE TABLE `line_items` (
  `id` int(11) NOT NULL auto_increment,
  `product_id` int(11) NOT NULL default '0',
  `order_id` int(11) NOT NULL default '0',
  `quantity` int(11) NOT NULL default '0',
  `unit_price` float(10,2) NOT NULL default '0.00',
  PRIMARY KEY  (`id`),
  KEY `fk_items_order` (`order_id`),
  KEY `fk_items_product` (`product_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

CREATE TABLE `orders` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(100) NOT NULL default '',
  `email` text NOT NULL,
  `address` text NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

CREATE TABLE `products` (
  `id` int(11) NOT NULL auto_increment,
  `title` varchar(100) NOT NULL default '',
  `description` text NOT NULL,
  `image_url` varchar(200) NOT NULL default '',
  `price` decimal(10,2) NOT NULL default '0.00',
  `date_available` datetime NOT NULL default '0000-00-00 00:00:00',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

