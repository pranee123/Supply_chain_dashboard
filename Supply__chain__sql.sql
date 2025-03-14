/*Problem statement“Richard’s Supply” is a company which deals with different food products. The company is associated with a pool of 
suppliers. Every Supplier supplies different types of food products to Richard’s supply. This company also receives orders for 
food products from various customers. Each order may have multiple products mentioned along with the quantity. The company is maintaining 
the database for 2 years.*/
# Section A: Level 1 Questions
# 1. Read the data from all the tables
use supply_chain;
show columns from customer;
select * from orderitem;
select * from orders;
select * from product;
select * from supplier;
#2. Find the country-wise count of customers
select country,count(id) as customer_count from customer group by country order by customer_count Desc;
#3.	Display the products that are not discontinued.
select * from product where isdiscontinued = 0;
#4.	Display the list of companies along with the product name that they are supplying. 
select s.companyname,p.productname from supplier as s join product as p on s.id=p.supplierid;
#5. Display customer information about who stays in 'Mexico'
select * from customer where country = 'Mexico';

## Additional: Level 1 questions
#6.	Display the costliest item that is ordered by the customer.
select p.productname,oi.unitprice from orderitem oi join product p on oi.productid=p.id order by oi.unitprice desc limit 1;
#7.	Display supplier ID who owns the highest number of products.
select supplierid,count(*) as productcount from product  p group by supplierid order by productcount desc limit 1;
#8.	Display month-wise and year-wise counts of the orders placed.
select year(orderdate) as orderyear, month(orderdate) as ordermonth,count(*) as ordercount from orders group by 
orderyear,ordermonth order by orderyear,ordermonth;
#9.	Which country has the maximum number of suppliers?
select country,count(*) as suppliercount from supplier group by country order by suppliercount desc limit 1;
#10. Which customers did not place any orders?
select c.* from customer as c left join orders o on c.id=o.customerid where o.customerid is null;
# Section B: Level 2 Questions:
#1.	Arrange the Product ID and Name based on the high demand by the customer.
select p.id as productid,p.productname,sum(oi.quantity) as totalordered from orderitem oi
join product p on oi.productid=p.id group by p.id,p.productname order by totalordered desc;
#2. Display the total number of orders delivered every year
select year(orderdate) as orderyear, count(id) as totalorders from orders  group by orderyear order by orderyear;
#3.	Calculate year-wise total revenue. 
select year(orderdate) as orderyear,sum(totalamount) as totalrevenue from orders group by orderyear order by orderyear;
#4.	Display the customer details whose order amount is maximum including his past orders. 
with maxorder as(select customerid from orders order by totalamount desc limit 1)
select c.id,c.firstname,c.lastname,c.city,c.country,o.id as orderid,o.orderdate,o.totalamount from customer c
join orders o on c.id = o.customerid where c.id=(select customerid from maxorder) order by o.orderdate desc;
#5.	Display the total amount ordered by each customer from high to low
select c.id,c.firstname,c.lastname,c.city,c.country,sum(o.totalamount) as totalorderedamount from customer c
join orders o on c.id=o.customerid group by c.id,c.firstname,c.lastname,c.city,c.country order by totalorderedamount desc;
/*Additional Level 2 Questions:
The sales and marketing department of this company wants to find out how frequently customers do business with them. */
#6.	Approach - List the current and previous order dates for each customer.
select o.customerid,c.firstname,c.lastname,o.orderdate as currentorderdate,lag(o.orderdate) over (partition by o.customerid 
order by o.orderdate) as previousorder from orders o join customer c on o.customerid=c.id order by o.customerid,o.orderdate;
#7. Find out the top 3 suppliers in terms of revenue generated by their products. 
select s.id as supplierid,s.companyname,sum(oi.unitprice*oi.quantity) as totalrevenue from supplier s 
join product p on p.supplierid=s.id join orderitem oi on oi.productid=p.id join orders o on oi.orderid=o.id
group by s.id,s.companyname order by totalrevenue desc limit 3;
#8.	Display the latest order date (should not be the same as the first order date) of all the customers with customer details. 
with order_rank as (select o.customerid, o.orderdate, 
           rank() over (partition by o.customerid order by o.orderdate asc) as order_rank_asc,
           rank() over (partition by o.customerid order by o.orderdate desc) as order_rank_desc
    from orders o)
select c.id, c.firstname, c.lastname, c.city, c.country, o.orderdate as latest_order_date from customer c
join order_rank o on c.id = o.customerid where o.order_rank_desc = 2;
#9.	Display the product name and supplier name for each order
select o.id as orderid,p.productname,s.companyname as suppliername from orders o
join orderitem oi on oi.orderid=o.id join product p on oi.productid=p.id
join supplier s on p.supplierid=s.id;
/* Section C: Level 3 Questions: */
#1.	Fetch the customer details who ordered more than 10 products in a single order.
select c.id,c.firstname,c.lastname,c.city,c.country,o.id as orderid,sum(oi.quantity) as totalproducts
from customer c join orders o on c.id=o.customerid join orderitem oi on o.id=oi.orderid
group by c.id,o.id having totalproducts>10;
#2.	Display all the product details with the ordered quantity size as 1. 
select p.* from product p join orderitem oi on p.id = oi.productid where oi.quantity = 1; 
#3.	Display the companies that supply products whose cost is above 100.
select s.companyname,p.unitprice from supplier s join product p on p.supplierid=s.id 
where p.unitprice>100;
#4.	Create a combined list to display customers and supplier lists 
select 'customer' as type,concat(firstname,' ',lastname)as contactname,city,country,phone from customer
union
select 'supplier' as type,contactname,city,country,phone from supplier;
#5.	Display the customer list who belongs to the same city and country arranged country-wise
select * from customer 
where (city, country) in (select city, country from customer group by city, country having count(*) > 1) order by country, city;
#Section D: Level 4 Questions:
/*1.The company sells the products at different discount rates. Refer actual product price in the product table and the 
selling price in the order item table. Write a query to find out the total amount saved in each order then display the 
orders from highest to lowest amount saved. */
select oi.orderid, sum((p.unitprice - oi.unitprice) * oi.quantity) as total_amount_saved from orderitem oi
join product p on oi.productid = p.id group by oi.orderid order by total_amount_saved desc;
/*2.Mr. Kavin wants to become a supplier. He got the database of "Richard's Supply" for reference. Help him to pick: 
a.List a few products that he should choose based on demand.*/
select p.productname, sum(oi.quantity) as total_quantity_ordered from orderitem oi join product p on oi.productid = p.id
group by p.productname order by total_quantity_ordered desc limit 5; 
#b.	Who will be the competitors for him for the products suggested in the above questions? 
with top_products as (select p.id as productid, p.productname, sum(oi.quantity) as total_quantity_ordered
    from orderitem oi join product p on oi.productid = p.id group by p.id, p.productname order by total_quantity_ordered desc limit 5 )
select tp.productname, s.companyname as competitor_supplier from top_products tp join product p on tp.productid = p.id 
join supplier s on p.supplierid = s.id;
/*3.Create a combined list to display customers' and suppliers' details considering the following criteria 
a.Both customer and supplier belong to the same country */
select 'Customer' as type, c.firstname as contactname, c.city, c.country, c.phone from customer c join supplier s on c.country = s.country
union all select 'Supplier' as type, s.contactname, s.city, s.country, s.phone from supplier s join customer c on s.country = c.country;
#b.	Customers who do not have a supplier in their country
select c.id, c.firstname, c.lastname, c.city, c.country, c.phone from customer c left join supplier s on c.country = s.country
where s.id is null;
#c.	A supplier who does not have customers in their country 
select s.id, s.companyname, s.contactname, s.city, s.country, s.phone from supplier s left join customer c on s.country = c.country
where c.id is null;
/*4.Find out for which products, the UK is dependent on other countries for the supply. List the countries which are supplying 
these products in the same list. */
select p.productname, s.country as supplying_country from product p join supplier s on p.supplierid = s.id where s.country <> 'UK';










