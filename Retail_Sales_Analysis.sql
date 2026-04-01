-- create database retail_sales;
-- use retail_sales;
-- alter table retail rename column ï»¿transactions_id to transaction_id;
-- start transaction;
-- select * from retail order by transaction_id;
-- commit;
-- select * from retail;
select count(*) from retail;


-- Data Cleaning

set sql_safe_updates = 0;

Delete from retail where transaction_id is null or sale_date is null
 or 
 gender is null
 or
 category is null
 or
 quantiy is null
 or
 cogs is null 
 or
 total_sale is null;

-- Data Exploration

 -- how many sales we have
select count(total_sale) from retail;
 
 -- how many sales we have year wise:
 select count(year(sale_date)) as total_sales,year(sale_date) from retail group by year(sale_date);
 
 -- how many customers we have:
 select count(distinct customer_id) from retail;
 
 -- total category with its count
 select count(category), category from retail group by category;
 
 -- Data analysis & business key problems & ansers
 
-- 1. Write a SQL query to retrieve all columns for sales made on '2022-11-05:
select * from retail where sale_date = '2022-11-05';

-- 2.Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022:
select * from retail where sale_date like '2022-11-__' and category  = 'clothing' and quantiy >=4;

-- 3. Write a SQL query to calculate the total sales (total_sale) for each category.:
select category,sum(total_sale) as sale, count(*) as total_orders from retail group by category order by sum(total_sale) desc;

-- 4. Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.:
select round(avg(age)), category as average_age from retail group by category;

-- 5. Write a SQL query to find all transactions where the total_sale is greater than 1000.:
select * from retail where total_sale> 1000 order by sale_date;

-- 6.Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.:
select gender,category,count(*) as total_transactions from retail group by category,gender; 

-- 7. Write a SQL query to calculate the average sale for each month. Find out best selling month in each year:
select * from (select year(sale_date),month(sale_date) as monthh, avg(total_sale), rank() over (partition by year(sale_date) order by avg(total_sale) desc) as rankk from retail group by year(sale_date), month(sale_date)) as rank_table
where rankk in (1);

-- 8.Write a SQL query to find the top 5 customers based on the highest total sales:
select customer_id, sum(total_sale) as sale from retail group by customer_id order by sum(total_sale)desc limit 5; 

-- 9. Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17):

with hourly_sales
as
(
select *,
	case
		when hour(sale_time) <12 then 'Morning'
        when hour(sale_time) between 12 and 17 then 'Aternoon'
        Else 'Evening'
	End as shifts
from retail
)
select * from hourly_sales;
