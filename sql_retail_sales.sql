CREATE TABLE retail_sales
            (
                transaction_id INT PRIMARY KEY,	
                sale_date DATE,	 
                sale_time TIME,	
                customer_id	INT,
                gender	VARCHAR(15),
                age	INT,
                category VARCHAR(15),	
                quantity	INT,
                price_per_unit FLOAT,	
                cogs	FLOAT,
                total_sale FLOAT
            );

SELECT * FROM retail_sales
LIMIT 10;

SELECT 
    COUNT(*) 
FROM retail_sales

-- Data Cleaning

SELECT * FROM retail_sales
WHERE transactions_id IS null

SELECT * 
FROM retail_sales
WHERE 
    transactions_id IS NULL
    OR
    sale_date IS NULL
    OR 
    sale_time IS NULL
    OR
    gender IS NULL
    OR
    category IS NULL
    OR
    quantiy IS NULL
    OR
    cogs IS NULL
    OR
    total_sale IS NULL;
    
DELETE FROM retail_sales
WHERE 
    transactions_id IS NULL
    OR
    sale_date IS NULL
    OR 
    sale_time IS NULL
    OR
    gender IS NULL
    OR
    category IS NULL
    OR
    quantiy IS NULL
    OR
    cogs IS NULL
    OR
    total_sale IS NULL;
   
   -- Data Exploration
   
   -- How many sales we have?
   
   select 
   COUNT(*) as total_sales
   from 
   retail_sales;
  
  -- How many unique customers we have?
  
  select 
  COUNT(distinct customer_id)
  from 
  retail_sales rs ;
 
 -- How many category we have?
 
select 
distinct category
from
retail_sales;

-- Data Analysis : Answering business questions

-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05

select *
from retail_sales rs 
where 
sale_date = '2022-11-05';


-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022

select*
from 
retail_sales rs 
where 
category = 'Clothing'
and
sale_date between '2022-11-1' and '2022-11-30'
and 
quantiy >=4;

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.

select 
category,
sum(total_sale) as net_sale
from
retail_sales rs 
group by category ;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

select
category, 
ROUND(avg(age),0) as avg_age
from
retail_sales rs 
where 
category  = 'Beauty'
group by category;

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.

select *
from 
retail_sales rs 
where total_sale >1000;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

select
category,
gender,
count(*) as tota_number_transactions
from 
retail_sales rs
group by category ,gender
order by 1;

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year

select 
year,
month,
avg_sale
from
	(select 
		extract (year from sale_date) as year,
		extract (month from sale_date) as month,
		avg(total_sale) as avg_sale,
		rank() over(partition by extract (year from sale_date) order by avg(total_sale) desc  ) as rank
		from 
		retail_sales rs 
		group by 1,2
   ) as t1
where 
rank =1;


-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 

select
customer_id, 
sum(total_sale) as total_sales 
from
retail_sales rs
group by customer_id 
order by total_sales desc
limit 5 ;

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.

select 
category, 
count(distinct (customer_id))
from 
retail_sales rs
group by category; 

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)

with hourly_sale
as
(
select*,
	case
		when extract (hour from sale_time) <=12  then 'Morning'
		when extract (hour from sale_time) between 12 and 17 then 'Afternoon'
		else 'Evening'
	end as shift
from 
retail_sales rs 
) 
select 
shift,
count(*) as total_orders
from hourly_sale
group by shift
order by 
case 
	when shift = 'Morning' then 1
	when shift = 'Afternoon' then 2
	when shift = 'Evening' then 3
	else 4
end;


   
    
   