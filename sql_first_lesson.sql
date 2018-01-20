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












