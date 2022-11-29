drop database if exists ecommerce_store;
create database ecommerce_store;
use ecommerce_store;

-- creating all the tables

create table supplier(
	Supp_Id int unsigned primary key auto_increment,
	Supp_Name varchar(50) not null,
	Supp_City varchar(50) not null,
	Supp_Phone varchar(50) not null
);

create table customer(
	Cus_Id int unsigned primary key auto_increment,
	Cus_Name varchar(20) not null,
	Cus_Phone varchar(10) not null,
	Cus_City varchar(30) not null,
	Cus_Gender enum ('M','F')
);

create table category(
	Cat_Id int unsigned primary key auto_increment,
	Cat_Name varchar(20) not null
);

create table product(
	Pro_Id int unsigned primary key auto_increment,
	Pro_Name VARCHAR(20) NOT NULL DEFAULT "Dummy",
	Pro_Desc varchar(60),
	Cat_Id int unsigned not null,
    constraint FK_Cat_Id foreign key (Cat_Id) references category(Cat_Id)
);

create table supplier_pricing(
	Pricing_Id int unsigned not null primary key auto_increment,
	Pro_Id int unsigned not null,
	Supp_Id int unsigned not null,
	Supp_Price INT DEFAULT 0,
    constraint FK_Pro_Id 
    foreign key (Pro_Id) references product(Pro_Id),
    constraint FK_Supp_Id
	foreign key (Supp_Id) references supplier(Supp_Id)
);

create table `order`(
	Ord_Id int unsigned not null primary key auto_increment,
	Ord_Amount int unsigned not null,
	Ord_Date date not null,
	Cus_Id int unsigned not null,
	Pricing_id int unsigned not null,
    constraint FK_Cus_Id
	foreign key (Cus_Id) references customer(Cus_Id),
    constraint FK_Pricing_Id
	foreign key (Pricing_Id) references supplier_pricing(Pricing_Id)
)auto_increment = 101;


create table rating(
	Rat_Id int unsigned not null primary key auto_increment,
	Ord_Id int unsigned not null,
	RAT_RATSTARS int unsigned not null default 0,
    constraint FK_Ord_Id
	foreign key (Ord_Id) references `order`(Ord_Id)
);

-- inserting data into tables
insert into supplier (Supp_Name, Supp_City, Supp_Phone) values
("Rajesh Retails","Delhi","1234567890"),
("Appario Ltd.", "Mumbai","2589631470"),
("Knome products","Banglore","9785462315"),
("Bansal Retails","Kochi","8975463285"),
("Mittal Ltd.",	"Lucknow","7898456532");


insert into customer (Cus_Name, Cus_Phone, Cus_City, Cus_Gender) values
("AAKASH","9999999999","DELHI",'M'),
("AMAN","9785463215","NOIDA",'M'),
("NEHA","9999999999","MUMBAI",'F'),
("MEGHA","9994562399","KOLKATA",'F'),
("PULKIT","7895999999","LUCKNOW",'M');


insert into category (Cat_Name) value
("BOOKS"),
("GAMES"),
("GROCERIES"),
("ELECTRONICS"),
("CLOTHES");


insert into product (Pro_Name, Pro_Desc, Cat_Id) values
("GTA V", "Windows 7 and above with i5 processor and 8GB RAM", 2),
("TSHIRT", "SIZE-L with Black, Blue and White variations", 5),
("ROG LAPTOP", "Windows 10 with 15inch screen, i7 processor, 1TB SSD", 4),
("OATS", "Highly Nutritious from Nestle", 3),
("HARRY POTTER", "Best Collection of all time by J.K Rowling", 1),
("MILK", "1L Toned MIlk", 3),
("Boat Earphones", "1.5 Meter long Dolby Atmos", 4),
("Jeans", "Stretchable Denim Jeans with various sizes and color", 5),
("Project IGI", "compatible with windows 7 and above", 2),
("Hoodie", "Black GUCCI for 13 yrs and above", 5),
("Rich Dad Poor Dad", "Written by RObert Kiyosaki", 1),
("Train Your Brain", "By Shireen Stephen", 1);


insert into supplier_pricing (Pro_Id, Supp_Id, Supp_Price) values
(1, 2, 1500),
(3, 5, 30000),
(5, 1, 3000),
(2, 3, 2500),
(4, 1, 1000);


insert into `order` (Ord_Amount, Ord_Date, Cus_Id, Pricing_Id) values
(1500, "2021-10-06", 2, 1),
(1000, "2021-10-12", 3, 5),
(30000, "2021-09-16", 5, 2),
(1500, "2021-10-05", 1, 1),
(3000, "2021-08-16", 4, 3),
(1450, "2021-08-18", 1, 3),
(789, "2021-09-01", 3, 2),
(780, "2021-09-07", 5, 5),
(3000, "2021-09-10", 5, 3),
(2500, "2021-09-10", 2, 4),
(1000, "2021-09-15", 4, 5),
(789 , "2021-09-16", 4, 1),
(31000, "2021-09-16", 1, 2),
(1000, "2021-09-16", 3, 5),
(3000, "2021-09-16", 5, 3),
(99 , "2021-09-17", 2, 4);


insert into rating (Ord_Id, RAT_RATSTARS) values
(101, 4),
(102, 3),
(103, 1),
(104, 2),
(105, 4),
(106, 3),
(107, 4),
(108, 4),
(109, 3),
(110, 5),
(111, 3),
(112, 4),
(113, 2),
(114, 1),
(115, 1),
(116, 0);
    


-- 3)	Display the total number of customers based on gender who have placed orders of worth at least Rs.3000.

select cus_gender,count(*) as Gender_Count from customer where  cus_id in  (
select cus_id from `order` group by 1 having sum(ord_amount)>=3000)
group by 1;

-- 4)	Display all the orders along with product name ordered by a customer having Customer_Id=2

select c.cus_id , ord_id ,  pro_name from customer c 
inner join `order` o on c.cus_id = o.cus_id
inner join supplier_pricing s on o.Pricing_id = s.Pricing_Id
inner join product as p on s.Pro_Id = p.Pro_Id
where c.cus_id = 2;

-- 5)	Display the Supplier details who can supply more than one product.

select supp_id,supp_name,supp_city,supp_phone from supplier 
where Supp_Id in 
(select Supp_Id from supplier_pricing group by Supp_Id having count(Supp_Id) > 1);

-- 6)	Find the least expensive product from each category and print the table with category id, name, product name and price of the product

select c.cat_id,cat_name , pro_name , min(sp.supp_price) as Price from category c inner join product p on c.cat_id = p.cat_id
inner join supplier_pricing sp on p.pro_id = sp.pro_id group by
sp.pro_id; 

-- 7) Display the Id and Name of the Product ordered after “2021-10-05”.

select PRO_ID, PRO_NAME from product where PRO_ID in 
(select PRO_ID from supplier_pricing where PRICING_ID in 
(select PRICING_ID from `order` where ORD_DATE > '2021-10-05'));

-- 8)	Display customer name and gender whose names start or end with character 'A'.

SELECT cus_name, cus_gender FROM Customer
WHERE 
cus_name LIKE '%a%'; 

-- 9) Create a stored procedure to display supplier id, name, rating and Type_of_Service. For Type_of_Service, If rating =5, print “Excellent
-- Service”,If rating >4 print “Good Service”, If rating >2 print “Average Service” else print “Poor Service”

DELIMITER //
CREATE PROCEDURE supplierRatings()
BEGIN
select sp.supp_id as Supplier_Id,supp_name as Supplier_Name, RAT_RATSTARS as Rating, case
	when RAT_RATSTARS=5 
		then 'Excellent Service'
	when avg(RAT_RATSTARS)>4 
		then 'Good Service'
	when avg(RAT_RATSTARS)>2 
		then 'Average Service'
	else 'Poor Service' 
		end as Type_of_Service  
	from rating r 
		inner join `order` o on r.ord_id = o.ord_id
		inner join supplier_pricing sp on o.pricing_id = sp.pricing_id
	inner join supplier s on s.supp_id = sp.supp_id group by s.supp_id;
END //    
DELIMITER ;

call supplierRatings();



