
SELECT *
FROM coffee_shop_sales;

describe coffee_shop_sales;

SELECT transaction_date,
       STR_TO_DATE(transaction_date, '%d/%m/%Y')
FROM coffee_shop_sales_db.coffee_shop_sales;

ALTER TABLE coffee_shop_sales_db.coffee_shop_sales
ADD COLUMN new_transaction_date DATE;

UPDATE coffee_shop_sales_db.coffee_shop_sales
SET new_transaction_date = STR_TO_DATE(transaction_date, '%m/%d/%Y');

ALTER TABLE coffee_shop_sales_db.coffee_shop_sales
DROP COLUMN transaction_date;

ALTER TABLE coffee_shop_sales_db.coffee_shop_sales
CHANGE new_transaction_date transaction_date DATE;

 update coffee_shop_sales
 set transaction_time = str_to_date(transaction_time, '%H:%i:%s');

alter table coffee_shop_sales
modify column transaction_time time;

describe coffee_shop_sales;

alter table coffee_shop_sales
change column ï»¿transaction_id transaction_id INT;#

# Calculating business requirements of client

# Calculating total sales for each month

select ROUND(SUM(unit_price*transaction_qty)) as Total_Sales
from coffee_shop_sales
Where
month (transaction_date) = 3;

#Determine month on month increase or decrease in sales
#Calculate difference in sales between selected month & previous month

select 
     Month(transaction_date) as Month,
     Round(sum(unit_price*transaction_qty)) as Total_Sales,
     (sum(unit_price*transaction_qty) - LAG(SUM(unit_price*transaction_qty),1)
     Over(Order by month(transaction_date)))/LAG(SUM(unit_price*transaction_qty),1)
     Over(Order by month(transaction_date))*100 as MOM_increase_percentage
From 
    coffee_shop_sales
Where
   month(transaction_date) in (4,5)
group by
  month(transaction_date)
Order by
  month(transaction_date);
  
  
  ##Total Orders Analysis
  
Select COUNT(TRANSACTION_ID) AS TOTAL_ORDERS
from coffee_shop_sales
Where
month (transaction_date) = 3;     

select 
     Month(transaction_date) as Month,
     Round(COUNT(transaction_id)) as total_orders,
     (Count(transaction_id) - LAG(Count(transaction_id), 1)
     Over(Order by month(transaction_date)))/LAG(COUNT(transaction_id),1)
     Over(Order by month(transaction_date))*100 as MOM_increase_percentage
From 
    coffee_shop_sales
Where
   month(transaction_date) in (4,5)
group by
  month(transaction_date)
Order by
  month(transaction_date);

     
## Total Quantity sold

Select sum(transaction_qty) AS total_quantity_sold
from coffee_shop_sales
Where
month (transaction_date) = 6 ;     

Select 
	 Month(transaction_date) as Month,
     Round(COUNT(transaction_qty)) as total_quantity_sold,
     (sum(transaction_qty) - LAG(sum(transaction_qty), 1)
     Over(Order by month(transaction_date)))/LAG(sum(transaction_qty),1)
     Over(Order by month(transaction_date))*100 as MOM_increase_percentage
From 
    coffee_shop_sales
Where
   month(transaction_date) in (4,5)
group by
  month(transaction_date)
Order by
  month(transaction_date);


## Charts Requirements


Select 
     concat(Round(SUM(Unit_price * transaction_qty)/1000,1), 'k') as Total_sales,
     concat(round(SUM(transaction_qty)/1000,1), 'k') as Total_qty_sold,
     concat(round(count(transaction_id)/1000,1), 'k') as total_orders
From coffee_shop_sales   
where
     transaction_date = '2023-05-18'  
     
     
## Sales Analysis on weekends & weekdays

Select
	Case when dayofweek(transaction_date) in (1,7) then 'weekends'
	else 'weekdays'
	end as day_type,
	concat(round(sum(unit_price * transaction_qty)/1000,1), 'k') as Total_sales
from coffee_shop_sales
where month(transaction_date) = 5
group by
	Case when dayofweek(transaction_date) in (1,7) then 'weekends'
	else 'weekdays'
	end;
    
## Sales Analysis by store location

select
     store_location,
     concat(round(SUM(unit_price*transaction_qty)/1000), 'k') as total_sales
from coffee_shop_sales
where month(transaction_date)  = 5
group by store_location
order by sum(unit_price*transaction_qty)desc

# Daily sales Analysis with average line
      
select avg (unit_price*transaction_qty) as avg_sales
from coffee_shop_sales
where month(transaction_date) = 5;

select 
     concat(round(avg(total_Sales)/1000,1),'k') as avg_sales
from
    (
    select sum(transaction_qty*unit_price) as total_sales
    from coffee_shop_sales
    where month (transaction_date)=5
    group by transaction_date
    ) as internal_query
    
## Daily sales for month selected
select 
	  Day(transaction_date) as day_of_month,
      sum(unit_price*transaction_qty) as total_sales
from coffee_shop_sales
where month (transaction_date) = 5
group by day(transaction_date)
order by day(transaction_date)

## Comparing daily sales with average sales-if greater than "above average" and lesser than "below average"

SELECT 
    day_of_month,
    CASE 
        WHEN total_sales > avg_sales THEN 'Above Average'
        WHEN total_sales < avg_sales THEN 'Below Average'
        ELSE 'Average'
    END AS sales_status,
    total_sales
FROM (
    SELECT 
        DAY(transaction_date) AS day_of_month,
        SUM(unit_price * transaction_qty) AS total_sales,
        AVG(SUM(unit_price * transaction_qty)) OVER () AS avg_sales
    FROM 
        coffee_shop_sales
    WHERE 
         MONTH(transaction_date) = 5  -- Filter for May
    GROUP BY 
        DAY(transaction_date)
) AS sales_data
ORDER BY 
    day_of_month;

## Sales analysis with respect to product category

Select 
	product_category,
    SUM(unit_price*transaction_qty) as total_sales
from coffee_shop_sales
where month(transaction_date) = 5
group by product_category;

## Sales Analysis with respect to product_category = Coffee
Select 
	product_category,
    SUM(unit_price*transaction_qty) as total_sales
from coffee_shop_sales
where month(transaction_date) = 5 AND product_category='Coffee'
group by product_type
order by sum(unit_price*transaction_qty) DESC
LIMIT 10;
    
## Top 10 products by sales

Select 
	product_type,
    SUM(unit_price*transaction_qty) as total_sales
from coffee_shop_sales
where month(transaction_date) = 5 
group by product_type
order by sum(unit_price*transaction_qty) DESC
LIMIT 10;

##Sales Analysis by days & hours 

select
	SUM(unit_price*transaction_qty) as total_sales,
    SUM(transaction_qty) as total_quantity_sold,
    count(*) as Total_orders
from coffee_shop_sales
where month(transaction_date) = 5
and dayofweek(transaction_date) =2
and hour(transaction_time)=8;

## In which hours of day is the coffee sold highest

select
     hour (transaction_time),
     sum(unit_price*transaction_qty) as total_sales
from coffee_shop_sales
where month(transaction_date) = 5
group by hour(transaction_time)
order by hour(transaction_time)

Select
     Case 
		when dayofweek(transaction_date)=2 THEN 'Monday'
        when dayofweek(transaction_date)=3 THEN 'Tueday'
        when dayofweek(transaction_date)=4 THEN 'Wednesday'
        when dayofweek(transaction_date)=5 THEN 'Thursday'
        when dayofweek(transaction_date)=6 THEN 'Friday'
        when dayofweek(transaction_date)=7 THEN 'Saturday'
        Else 'Sunday'
    End as Day_of_week,
    Round(sum(unit_price*transaction_qty)) as Total_sales
From 
    coffee_shop_sales
where
	month(transaction_date) = 5
Group by
   Case 
		when dayofweek(transaction_date)=2 THEN 'Monday'
        when dayofweek(transaction_date)=3 THEN 'Tueday'
        when dayofweek(transaction_date)=4 THEN 'Wednesday'
        when dayofweek(transaction_date)=5 THEN 'Thursday'
        when dayofweek(transaction_date)=6 THEN 'Friday'
        when dayofweek(transaction_date)=7 THEN 'Saturday'
        Else 'Sunday'
    End;
		


        
    