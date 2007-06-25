drop table if exists users;
drop table if exists line_items;
drop table if exists orders;
drop table if exists products;

create table products (
 id              int           not null auto_increment,
 title           varchar(100)  not null,
 description     text          not null,
 image_url       varchar(200)  not null,
 price           decimal(10,2) not null,
 date_available  datetime      not null,
 primary key (id)
);

/*START:orders*/
create table orders (
 id              int           not null auto_increment,
 name            varchar(100)  not null,
 email           varchar(255)  not null,
 address         text          not null,
 pay_type        char(10)      not null,
 shipped_at	 datetime      null,
 primary key (id)
);
/*END:orders*/

create table line_items (
  id              int           not null auto_increment,
  product_id	  int 	        not null,
  order_id        int           not null,
  quantity	  int           not null default 0,
  unit_price	  decimal(10,2) not null,
  constraint fk_items_product   foreign key (product_id) references products(id),
  constraint fk_items_order     foreign key (order_id) references orders(id),
  primary key (id)
);


create table users (
  id              int           not null auto_increment,
  name		  varchar(100)  not null,
  hashed_password char(40)      null,
  primary key (id)
);

/* password = 'secret' */
insert into users values(null, 'dave', 'e5e9fa1ba31ecd1ae84f75caaa474f3a663f05f4');
