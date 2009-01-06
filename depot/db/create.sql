drop table if exists users;
drop table if exists line_items;
drop table if exists orders;
drop table if exists products;

create table products (
 id              int(11)       not null auto_increment,
 title           varchar(100)  not null default '',
 description     text          not null,
 image_url       varchar(200)  not null default '',
 price           decimal(10,2) not null default '0.00',
 date_available  datetime      not null default '0000-00-00 00:00:00',
 primary key (id)
);

/*START:orders*/
create table orders (
 id              int(11)       not null auto_increment,
 name            varchar(100)  not null,
 email           varchar(255)  not null,
 address         text          not null,
 pay_type        char(10)      not null,
 shipped_at	     datetime      null,
 primary key (id)
);
/*END:orders*/

create table line_items (
  id             int(11)       not null auto_increment,
  product_id     int(11)       not null,
  order_id       int(11)       not null,
  quantity       int(11)       not null default 0,
  unit_price     decimal(10,2) not null,
  primary key (id),
  KEY `fk_items_product` (`product_id`),
  KEY `fk_items_order` (`order_id`)
);


create table users (
  id              int           not null auto_increment,
  name		  varchar(100)  not null,
  hashed_password char(40)      null,
  primary key (id)
);

/* password = 'secret' */
insert into users values(null, 'dave', 'e5e9fa1ba31ecd1ae84f75caaa474f3a663f05f4');
