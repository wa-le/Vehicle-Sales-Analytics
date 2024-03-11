create database VehicleData;
use VehicleData;

# imported Data from CSV file as Vehicle as "sales"

# show tables in database
show tables;

# view sales table
select * from sales
limit 10;

# Rename some columns
ALTER TABLE sales
RENAME COLUMN myunknowncolumn TO id;

ALTER TABLE sales
RENAME COLUMN mmr TO marketvalue;

select * from sales
limit 50;

##### Queries #####
# 1. Which manufacturer sells the best?
select year as Year, make as VehicleMake, count(make) as QuantitySold
from sales
group by year, make
order by QuantitySold desc;

# 2. Which car body sells the most?
select body, count(body) as body_sales
from sales
group by body
order by body_sales desc;

# A bit of data cleaning - issues with vehicle color
UPDATE sales
SET color = CASE
			WHEN color = 'â€”' THEN 'navy blue'
			ELSE color
			END
WHERE color = 'â€”';

# 3. Which color sells the best?
select year as Year, color as Color, count(color) as QuantitySold
from sales
group by year, color
order by QuantitySold desc;

# 4. Day of week with highest sales
select sale_Day, count(sale_Day) as dayofweek_high_sales
from sales
group by sale_Day
order by dayofweek_high_sales desc;

#5. Day with highest sale ever
# first we concatenate some columns to get a new column
ALTER TABLE sales
ADD the_date VARCHAR(255);
UPDATE sales
SET the_date = CONCAT(sale_Date, '-', sale_Month, '-', sale_year);

select the_date, count(the_date) as highest_selling_day
from sales
group by the_date
order by highest_selling_day desc;


# 6. Which model sells the best for each manufacturer?
With cte1 as (
select make, model, count(model) as model_count
from sales
group by model, make
order by model_count desc
),
cte2 as (
    SELECT 
		make, 
        model,
        model_count,
        ROW_NUMBER() OVER (PARTITION BY make ORDER BY model_count DESC) as a1
    FROM 
        cte1
)
SELECT 
	make, 
    model,
    model_count
FROM 
    cte2
WHERE 
    a1 = 1
    order by model_count desc
    limit 15;
    
# 7. Which manufacturer sells the best?
select make, sum(sellingprice) as totalamount
from sales
group by make
order by totalamount desc;

 # 8. show yearly sales of each company
select year as Year, make as VehicleMake, count(sellingprice) as Totalvehicles, sum(sellingprice) as TotalSales
from sales
group by year, make;

# 9. Most expensive vehicles on a yearly basis
WITH MaxPrices AS (
    SELECT year, max(sellingprice) AS maxprice
    FROM sales
    GROUP BY year
)
SELECT v.year, v.make, v.model, v.sellingprice
FROM sales v
JOIN MaxPrices m ON v.year = m.year AND v.sellingprice = m.maxprice;


select * from sales where make = "ford";

select distinct(year) from sales;
