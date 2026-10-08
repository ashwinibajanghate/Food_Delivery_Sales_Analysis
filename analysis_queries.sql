select * FROM daily_sales LIMIT 5;

select count(*) FROM daily_sales;

SELECT max(date),min(date) from daily_sales;

SELECT count(DISTINCT city) FROM daily_sales;

SELECT count(DISTINCT cuisine_type) FROM daily_sales;

-- city total net sales
SELECT 
    city,
    sum(net_sales) as total_net_sales
FROM daily_sales
GROUP BY city
ORDER BY total_net_sales DESC;

-- category net sales
SELECT category, sum(orders) as total_orders
from daily_sales
GROUP BY category
ORDER BY total_orders DESC;

-- cuision net sales, orders,aov
SELECT 
    cuisine_type,
    sum(net_sales) as total_net_sales,
    sum(orders) total_orders,
    round(avg(avg_order_value),2) as avg_aov
FROM daily_sales
GROUP BY cuisine_type
ORDER BY total_net_sales DESC;

-- Why does Indian cuisine receive the highest number of orders?
SELECT 
    city,
    sum(orders) as total_orders,
    sum(net_sales) as total_net_sales
FROM daily_sales
WHERE cuisine_type = 'Indian'
GROUP BY city
ORDER BY total_orders DESC;

-- If Bangalore drives Indian cuisine orders, why?
SELECT
    city,
    Round(AVG(rating),2) as avg_rating,
    sum(orders) as total_orders
FROM daily_sales
WHERE cuisine_type = 'Indian'
Group BY city 
ORDER BY avg_rating DESC

-- Do promotions contribute to Bangalore's Indian cuisine order volume?
select  
    city,
    sum(case when is_promo = TRUE then 1 else 0 end) as promo_count,
    sum(orders) as total_orders
FROM daily_sales
WHERE cuisine_type = 'Indian'
Group BY city
order by promo_count DESC;

-- compare performance when promotions are active vs inactive
select 
    is_promo,
    sum(orders) as total_orders,
    sum(net_sales) as total_net_sales,
    Round(avg(avg_order_value),2) as avg_aov
FROM daily_sales
WHERE cuisine_type = 'Indian' and city = 'Bangalore'
GROUP BY is_promo

-- Is Bangalore unusually biased toward Indian cuisine compared to other cities?
SELECT
    city,
    cuisine_type,
    sum(orders) as total_orders
FROM daily_sales
GROUP BY city, cuisine_type 
order by city,total_orders desc;

-- Mumbai has the highest total orders because it has the highest Net Sales?
select city,sum(orders) as total_orders
from daily_sales
group by city
order by total_orders desc;

-- How much revenue does each order generate in each city?(revenue_per_order by city)
select
    city,
    round(sum(net_sales)/sum(orders)) as revenue_per_order
FROM daily_sales
Group by city
order by revenue_per_order desc;

-- highest revenue per order
select
    cuisine_type,
    round(sum(net_sales)/sum(orders)) as revenue_per_order,
    sum(sales) as total_sales,
    sum(net_sales) as total_net_sales,
    sum(orders) as total_orders,
    Round(avg(avg_order_value),2) as avg_aov
FROM daily_sales
Group by cuisine_type
order by revenue_per_order desc;

-- Which cities contribute most to Chinese cuisine revenue per order?
select 
    city,
    round(sum(net_sales)/sum(orders)) as revenue_per_order
from daily_sales
where cuisine_type = 'Chinese'
group by city
order by revenue_per_order desc;

-- Why does Mumbai have such high Chinese revenue per order?
select 
    city,
    round(sum(net_sales)/sum(orders)) as revenue_per_order,
    round(avg(avg_order_value),2) as avg_aov
from daily_sales
where cuisine_type = 'Chinese'
group by city
order by revenue_per_order desc;

-- Which category contributes the most to Net Sales, Orders, and AOV?
select
    category,
    sum(net_sales) as total_net_sales,
    sum(orders) as total_orders,
    Round(avg(avg_order_value),2) as avg_aov
FROM daily_sales
GROUP BY category
order by total_net_sales DESC;

-- What percentage of total Net Sales comes from Fine Dining?
SELECT
    category,
    Round(
        100 * sum(net_sales) / 
        (select sum(net_sales) from daily_sales),
        2) as revenue_share_pct,
    sum(net_sales) as total_net_sales,
    sum(orders) as total_orders,
    Round(avg(avg_order_value),2) as avg_aov
from daily_sales
Group by category
order by revenue_share_pct desc;

-- Do customers spend more on weekends?
select 
    is_weekend,
    sum(net_sales) as total_net_sales,
    sum(orders) as total_orders
From daily_sales
GROUP BY is_weekend
order by total_net_sales desc;

-- On an average day, do weekends perform better than weekdays?
select
    is_weekend,
    count(DISTINCT date) as num_days,
    round(sum(net_sales)/count(DISTINCT date),2) as avg_daily_net_sales,
    round(sum(orders)/count(DISTINCT date),2) as avg_daily_orders,
    Round(
        100 * sum(net_sales) / 
        (select sum(net_sales) from daily_sales),
        2) as revenue_share_pct
From daily_sales
group by is_weekend;

-- Which categories perform differently on weekends?
select
    is_weekend,
    category,
    count(DISTINCT date) as num_days,
    round(sum(net_sales)/count(DISTINCT date),2) as avg_daily_net_sales,
    round(sum(orders)/count(DISTINCT date),2) as avg_daily_orders
From daily_sales
group by category,is_weekend
order by avg_daily_net_sales desc;
    
-- Do festivals actually increase sales and orders?
select
    is_festival,
    sum(net_sales) as total_net_sales,
    sum(orders) as total_orders,
    round(avg(avg_order_value),2) as avg_aov,
    Round(100 * sum(net_sales)/(select sum(net_sales) from daily_sales),2) as revenue_share_pct
FROM daily_sales
Group by is_festival;

-- Compare Daily Averages(On an average day, do festival perform better than no festival?)
select
    is_festival,
    count(DISTINCT date) as num_days,
    round(sum(net_sales)/count(DISTINCT date),2) as avg_daily_net_sales,
    round(sum(orders)/count(DISTINCT date),2) as avg_daily_orders
from daily_sales
group by is_festival
order by avg_daily_net_sales desc;

-- **Do promotions actually increase sales and orders?**
select 
    is_promo,
    sum(net_sales) as total_net_sales,
    sum(orders) as total_orders,
    avg(avg_order_value) as avg_aov,
    round(100 * sum(net_sales)/(select sum(net_sales) from daily_sales),2) as revenue_share_pct
from daily_sales
group by is_promo
order by total_net_sales desc;

-- Daily Average Comparison
select
    is_promo,
    count(DISTINCT date) as num_days,
    round(sum(net_sales)/count(DISTINCT date),2) as avg_daily_net_sales,
    round(sum(orders)/count(DISTINCT date),2) as avg_daily_orders
from daily_sales
GROUP BY is_promo;

-- Revenue Per Order
SELECT
    is_promo,
    ROUND(SUM(net_sales)/SUM(orders),2) AS revenue_per_order,
    ROUND(AVG(avg_order_value),2) AS avg_aov
FROM daily_sales
GROUP BY is_promo;

-- Which Categories Benefit Most?
SELECT
    category,
    is_promo,
    SUM(net_sales) AS total_net_sales,
    SUM(orders) AS total_orders
FROM daily_sales
GROUP BY category, is_promo
ORDER BY category, total_net_sales DESC;

-- Which categories use promotions most?
select  
    category,
    sum(case when is_promo = TRUE then orders else 0 end) as promo_orders,
    sum(orders) as total_orders,
    round(100 * sum(case when is_promo = TRUE then orders else 0 end)/ sum(orders),2) as promo_orders_pct
from daily_sales
group by category
order by promo_orders_pct desc;

-- *Does delivery performance affect customer satisfaction?*

-- Delivery Delay Metric
SELECT
    delivery_time_actual - delivery_time_min AS delay_minutes
FROM daily_sales;

-- Does Delay Affect Ratings?
select
    round(avg(delivery_time_actual - delivery_time_min),2) as avg_delay,
    round(avg(rating),2) as avg_rating
from daily_sales;

-- Does Delay Affect Ratings?
select  
    case 
        when delivery_time_actual - delivery_time_min <= 0 then 'On Time/Early'
        when delivery_time_actual - delivery_time_min <= 5 then '1-5 Min Late'
        when delivery_time_actual - delivery_time_min <= 10 then '6-10 Min Late'
        else '10+ Min Late'
    end as delivery_bucket,
    round(avg(rating),2) as avg_rating,
    round(avg(customer_satisfaction),2) as avg_satisfaction,
    sum(orders) as total_orders
from daily_sales
Group by delivery_bucket
order by total_orders desc;

-- What is the maximum delay in the dataset?
select
    MIN(delivery_time_actual - delivery_time_min) AS min_delay,
    MAX(delivery_time_actual - delivery_time_min) AS max_delay,
    ROUND(AVG(delivery_time_actual - delivery_time_min),2) AS avg_delay
FROM daily_sales;

-- Which categories generate the most commission revenue for the platform?
select
    category,
    round(sum(net_sales*commission_rate),2) as commission_revenue,
    sum(net_sales) as total_net_sales,
    round(avg(commission_rate)*100,2) as avg_commission_pctS
from daily_sales
group by category
order by commission_revenue desc;

-- Commission Share % by Category
select
    category,
    round(
        100* sum(net_sales*commission_rate)/
        (select sum(net_sales * commission_rate) from daily_sales),
        2) as commission_share_pct,
    round(sum(net_sales*commission_rate),2) as commission_revenue
from daily_sales
group by category
order by commission_share_pct desc;

-- packaging fee revenue by category
select
    category,
    sum(orders * packaging_fee) as packaging_fee_revenue
from daily_sales
group by category
order by packaging_fee_revenue desc

-- 24*7 revenue share %
select
    is_24x7,
    round(100 * sum(net_sales)/(select sum(net_sales) from daily_sales),2) as revenue_share_pct
from daily_sales
group by is_24x7
order by revenue_share_pct desc

-- 24*7 
SELECT
    is_24x7,
    SUM(net_sales) AS total_net_sales,
    SUM(orders) AS total_orders,
    ROUND(AVG(avg_order_value),2) AS avg_aov
FROM daily_sales
GROUP BY is_24x7;