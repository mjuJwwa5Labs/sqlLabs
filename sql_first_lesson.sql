-- tworzenie tabel

/*
CREATE TABLE customer (
    customer_id INT NOT NULL AUTO_INCREMENT,
   customer_name VARCHAR(50) NOT NULL,
   customer_phone VARCHAR(15) NOT NULL,
   customer_email VARCHAR(45) NOT NULL,
    PRIMARY KEY (customer_id)
);
*/

/*
CREATE TABLE customer_address (
    customer_address_id INT NOT NULL AUTO_INCREMENT,
    street VARCHAR(50) NOT NULL,
   city VARCHAR(20) NOT NULL,
   country VARCHAR(40) NOT NULL,
   zip_code VARCHAR(10),
   customer_id INT NOT NULL,
    PRIMARY KEY (customer_address_id)
);
*/

/*
ALTER TABLE customer DROP COLUMN customer_address_id;
*/

/*
CREATE TABLE customer_order (
	customer_order_id INT NOT NULL auto_increment,
    customer_id int not null,
    customer_order_status enum('NEW','IN_PROGRESS','CLOSED'),
    customer_order_creation_date date not null,
    customer_order_completation_date date,
    primary key(customer_order_id)
);
*/

/*
insert into customer (customer_name, customer_phone, customer_email) values
('John Smith', '111-222-333', 'js@mail.com'),
('Alice Smith', '222-333-444', 'al@mail.com');
*/

/*
insert into customer () values (null, 'Mark Thomas', '777-111-333', 'mt@mail.net');
*/

/*
insert into customer_address (street, city, country, zip_code, customer_id) values
('Street 1','Town 1','USA','00-111',1),
('Street 2','Town 2','USA','00-111',2),
('Ulica 3','Miasto 3','Poland','00-111',3);
*/

insert into customer_address (street, city, country, zip_code, customer_id) values
('Ulica 2','Miasto 2','Poland','00-111',3);

select * 
from customer;

select c.customer_id 'Customer ID', c.customer_name 
from client_order.customer as c;

select * 
from customer as c 
where 
c.customer_id=2;

select * 
from customer 
where customer_phone like '%333%';

select * 
from customer 
where customer_name like '%Smith'
and customer_email like '%com';

select * 
from customer 
where customer_email like '%com'
or customer_email like '%net';

select cust.* 
 from client_order.customer as cust
 where cust.customer_email like '%com'
 or cust.customer_email like '%net'
 order by customer_name asc, customer_phone desc;


select * from customer_address;

select *
from customer c, customer_address ca
where c.customer_id=ca.customer_id;

select *
from customer c, customer_address ca
where c.customer_id=ca.customer_id
and c.customer_email like '%.com'
and ca.city = 'Town 1';

-- =======================
-- 		   21.01
-- =======================
use client_order;
alter table customer_order;

ALTER TABLE customer_order ADD COLUMN customer_order_total_cost DECIMAL NOT NULL AFTER customer_order_completation_date;
ALTER TABLE customer_order ADD COLUMN customer_address_id INT NOT NULL AFTER customer_order_total_cost;

create table product (
	product_id int not null auto_increment,
    product_name varchar(50) not null,
    product_price decimal not null,
    product_category int not null,
    quantity decimal not null,
    unit_id int not null,
    primary key(product_id)
);

create table unit (
	unit_id int not null auto_increment,
    unit_code varchar(10) not null,
    unit_description varchar(50),
    primary key  (unit_id)
);

create table product_category (
	product_category_id int not null auto_increment,
    category_name varchar(50) not null,
    category_description varchar(70),
    primary key (product_category_id)
);

create table order_entry (
	order_entry_id int not null auto_increment,
    product_id int not null,
    quantity decimal not null,
    product_price decimal not null,
    customer_order_id int not null,
	primary key (order_entry_id)
);

