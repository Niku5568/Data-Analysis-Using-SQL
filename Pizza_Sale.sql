-- -----------------------------------------------------------------
-- Question1: retrive all data where order not shipped
-- -----------------------------------------------------------------
select * 
from orders
where status != "Shipped";
 
 -- or -- 
 
select * 
from orders
where status <> "Shipped";


-- -----------------------------------------------------------------
-- Question2: find out top 5 customer who have highest credit limit
-- -----------------------------------------------------------------
select * from customers order by creditLimit desc limit 5;


-- -----------------------------------------------------------------
-- Question3: retrive all employees where jobtitle contain word "sale"
-- -----------------------------------------------------------------
select * from employees where jobTitle regexp "sale";

-- -----------------------------------------------------------------
-- Question4: retrive all customers where creditlimit between 20000 and 40000
-- -----------------------------------------------------------------
select * from customers where creditLimit between 20000 and 40000;


-- -----------------------------------------------------------------
-- Question5: display total order, shipped and pending orders 
-- -----------------------------------------------------------------
select count(requiredDate) as Total_Orders,
		count(shippedDate) as shipped_orders,
        ( count(requiredDate) - count(shippedDate)) as pending_orders
from Orders;


-- -----------------------------------------------------------------
-- Question6: dispaly total order, highest, lowest, avg sale and total payment
-- -----------------------------------------------------------------
select sum(amount) as Total_Payment,
max(amount) as Highest_Sale,
min(amount) as Lowest_Sale,
avg(amount) as Avg_Sale,
count(amount) as Total_Transaction
from payments;


-- -----------------------------------------------------------------
-- Question7: find first order day and last order day.
-- -----------------------------------------------------------------
select max(paymentDate) as recent_last_date,
min(paymentDate) as oldest_data
from payments;


-- -----------------------------------------------------------------
-- Question8: find No of products  in each product line 
-- -----------------------------------------------------------------
SELECT productline,count(*) as product_count 
from products 
group by productline;


-- -----------------------------------------------------------------
-- Question9: count of employees, display office code, location that work in the same office
-- -----------------------------------------------------------------
select officeCode,
	   count(employeeNumber) as employee_count, city,state
from employees join offices using (officeCode)
group by officeCode;

-- -----------------------------------------------------------------
-- Question10: which office have more than 4 employees 
-- -----------------------------------------------------------------
select officeCode,
	   count(employeeNumber) as employee_count, city
from employees join offices using (officeCode)
group by officeCode
having employee_count ;

-- -----------------------------------------------------------------
-- Question11: country wise no of orders,  display total order count > 20
-- -----------------------------------------------------------------
select country,count(orderNumber) as total_orders from orders 
join customers using (customerNumber)
group by country 
having total_orders > 20;
-- --------------------------- or ------------------------------------------
select country,count(*) as total_orders from orders 
join customers using (customerNumber)
group by country 
having total_orders > 20;


-- -----------------------------------------------------------------
-- Question12: show only orders of country - "France","Japan", "Finland","USA"
-- -----------------------------------------------------------------
select country,count(*) as total_orders from orders 
join customers using (customerNumber)
where country in ("France","Japan", "Finland","USA")
group by country 
having total_orders > 20;



-- -----------------------------------------------------------------
-- Question13: review order tables and find the customername and sales representative number from customer table and 
-- representative name from employees tables
-- -----------------------------------------------------------------
select orderDate,
		orderNumber,
		status,
		o.customerNumber,
		c.customerName,
		c.salesRepEmployeeNumber, 
		concat(firstName," ", lastName) as "Sales Person Name",
		e.jobTitle
from orders o join customers c
on o.customerNumber = c.customerNumber
join employees e on c.salesRepEmployeeNumber =e.employeeNumber
order by "Sales Person Name";	

-- -----------------------------------------------------------------
-- Question14: what orders have placed by each customer? don't include those customer who have not placed any orders
-- -----------------------------------------------------------------
select c.customerNumber,contactFirstName,o.orderNumber 
from customers as c 
left join orders as o
on c.customerNumber = o.customerNumber; 


-- -----------------------------------------------------------------
-- Question15: find manger of each employees 
-- -----------------------------------------------------------------
select emp.employeeNumber,
concat(mgr.firstName," ",mgr.lastName) as "Manger",
mgr.jobTitle as "Manger Title"
from employees as emp join employees mgr on emp.reportsTo = mgr.employeeNumber;


-- -----------------------------------------------------------------
-- Question16: retrive all employee number,employee name, jobtitle, thier manger and manger name
-- -----------------------------------------------------------------
select emp.employeeNumber,
concat(emp.firstName," ",emp.lastName) as "Employee",
emp.jobTitle,
concat(mgr.firstName," ",mgr.lastName) as "Manger",
mgr.jobTitle as "Manger Title"
from employees as emp left join employees mgr on emp.reportsTo = mgr.employeeNumber;


-- -------------------------------------------------------------------------------------
-- Question17:  Find products that have same product line as of "1917 Grand Touring Seadan"  
-- -------------------------------------------------------------------------------------
select * from  products
where productLine =  
(select productLine from  products 
where productName = "1917 Grand Touring Sedan");

-- -------------------------------------------------------------------------------------
-- Question18:  Find cars that are costlier than "1936 Mercedes-Benz 500K Special Roadster".
-- -------------------------------------------------------------------------------------
select * from products
where productLine regexp "Cars" and MSRP > (select MSRP from products
where productName = "1936 Mercedes-Benz 500K Special Roadster");


-- -------------------------------------------------------------------------------------
-- Question19:   find the cars that are costlier than average cost of all cars
-- -------------------------------------------------------------------------------------
select * from products
where productLine regexp "Cars" and MSRP > (select avg(MSRP) from products
where productLine in ("Classic Cars","Vintage Cars") );

-- -------------------------------------------------------------------------------------
-- Question20: custome who has never placed an orders (subqueries and join)
-- -------------------------------------------------------------------------------------
# using subquery: - 
select customerNumber from customers
where customerNumber not in (select distinct customerNumber from orders);

# same query using join
select * from customers left join orders using (customerNumber)
where orderNumber is null;

-- -------------------------------------------------------------------------------------
-- Question21:  customer who ordered the product with product code "S18_1749"
# (example where join is prefrred over subquery)
-- -------------------------------------------------------------------------------------
select count(customerNumber) from orderdetails
join orders using (orderNumber) 
where productCode = "S18_1749" ;

# using subquery
select * from customers
where customerNumber in (select customerNumber from orderdetails
join orders using (orderNumber) 
where productCode = "S18_1749" );

# using join function
select distinct * from customers
join orders using (customerNumber)
join orderdetails using (orderNumber)
where productCode = "S18_1749";

-- -------------------------------------------------------------------------------------
-- Question22: Find products costlier than all trucks	 
-- -------------------------------------------------------------------------------------

select * from products 
where MSRP > (
select max(MSRP) from products 
where productLine regexp "truck");
 
 -- or -- 

select * from products 
where MSRP > all(
select max(MSRP) from products 
where productLine regexp "truck");


-- -------------------------------------------------------------------------------------
-- Question23: select clients who has made atleast two payments 
-- -------------------------------------------------------------------------------------

select * from customers
where customerNumber in (
select customerNumber from payments
group by customerNumber
having count(amount) >= 2); 

-- or -- 

select * from customers
where customerNumber =any (
select customerNumber from payments
group by customerNumber
having count(amount) >= 2); 

-- --------------------------------------------------------------------------------------------
-- ------------------------------ Correlated Subquery (always Depends on main query) -----------
-- Question24: find products whose price higher than average MSRP in their corrosponding line 
-- ---------------------------------------------------------------------------------------------

select * from products p
where MSRP > (
select avg(MSRP) from products
where productLine = p.productLine
);


-- --------------------------------------------------------------------------------------------
-- Question25: select customer who made any payment
-- --------------------------------------------------------------------------------------------
select * from customers 
where customerNumber in (
select distinct customerNumber
from payments);

--  using exists -----------
select * from customers c
where exists (
select customerNumber
from payments
where customerNumber=c.customerNumber);


-- --------------------------------------------------------------------------------------------
-- Question26: write a query create the following "view" of payment table
-- --------------------------------------------------------------------------------------------

select *, (select avg(amount) from payments) as Avg_amount,
amount - (select avg_amount) as Diffrence
from payments;

-- --------------------------------------------------------------------------------------------
-- Question27: write a query create the following "view" of payment table where differnce > 0 
-- (amount is higher than average)
-- --------------------------------------------------------------------------------------------

select * from 
(select *, 
(select avg(amount) from payments) as Avg_amount,
amount - (select avg_amount) as Diffrence
from payments) as pay
where Diffrence > 0;

-- --------------------------------------------------------------------------------------------
-- Question28: Total payment from each customer after a certain date 
-- -----------------------------------------------------------------
select * from payments;

select customerNumber,sum(amount) as total_amount, customerName 
from payments join customers using (customerNumber)
where paymentDate > "2002-02-02"
group by customerNumber
order by customerNumber, customerName ;

-- ---------------------------------------------------------------------------------------
-- Question29: value of each unique order sorted by total order values
-- ----------------------------------------------------------------------------------------
select orderNumber,sum(quantityOrdered*priceEach) as order_total 
from orderdetails 
group by orderNumber
order by order_total desc ;

-- ---------------------------------------------------------------------------------------
-- Question30: value of each unique order and it's customer name sorted by total order values
-- ----------------------------------------------------------------------------------------
select * from orderdetails;
select * from orders;
select * from customers;

select orderNumber,customerNumber,customerName,sum(quantityOrdered*priceEach) as order_total 
from orderdetails 
join orders using (orderNumber) 
join customers using (customerNumber)
group by orderNumber
order by order_total desc;


-- ---------------------------------------------------------------------------------------
-- Question 31: value of each unique order and it's customer name and sales employees sorted by total order values
-- ----------------------------------------------------------------------------------------

select * from orderdetails;
select * from orders;
select * from customers;

select orderNumber,customerNumber,customerName,
sum(quantityOrdered*priceEach) as order_total, salesRepEmployeeNumber, 
concat(emp.firstName," ",emp.lastName) as salesRepEmployeeName
from orderdetails 
join orders using (orderNumber) 
join customers using (customerNumber)
join employees as emp on (salesRepEmployeeNumber = employeeNumber)
group by orderNumber
order by order_total desc;

-- ---------------------------------------------------------------------------------------
-- Question 32: Number of orders placed by each customers and sales employee of that customer.
-- ----------------------------------------------------------------------------------------

select * from employees;
select * from orders;
select * from customers;

select customerNumber,count(*) as Total_Order,  
salesRepEmployeeNumber as emp_number, concat(firstName," ",lastName) as emp_name
from orders 
join customers using(customerNumber)
join employees on ( salesRepEmployeeNumber = employeeNumber)
group by customerNumber;


-- ---------------------------------------------------------------------------------------
-- Question 33: Number of orders Through each sales employee/Representive.
-- ----------------------------------------------------------------------------------------

select employeeNumber, concat(firstName," ",lastName) as emp_name, count(orderNumber) as total_orders
from orders 
join customers using (customerNumber)
join employees on ( salesRepEmployeeNumber = employeeNumber)
group by employeeNumber
order by total_orders desc;

-- ---------------------------------------------------------------------------------------
-- Question 34: Number of orders country wise
-- ----------------------------------------------------------------------------------------
select * from orders;
select * from customers;

select country,orderDate,count(*) as total_orders from orders
join customers using (customerNumber)
group by country,orderDate
order by country,orderDate;


-- ---------------------------------------------------------------------------------------
-- Question 35: find the customers from france whose total orders values > 80,000 across all thier orders
-- ----------------------------------------------------------------------------------------

select customerNumber,customerName,sum(quantityOrdered*priceEach) as order_values from customers
join orders using (customerNumber)
join orderdetails using (orderNumber)
where country = "France"
group by customerNumber,customerName
having order_values> 80000
order by order_values desc;
