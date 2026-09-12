CREATE DATABASE superstore_db;
use superstore_db;

SELECT COUNT(*) FROM sales;
SELECT * FROM sales LIMIT 10;

-- Region-wise total Sales aur Profit

SELECT region, 
       SUM(sales) AS total_sales, 
       SUM(profit) AS total_profit
FROM sales
GROUP BY region
ORDER BY total_sales DESC;

-- Category-wise performance

SELECT category, 
       SUM(sales) AS total_sales,
       SUM(profit) AS total_profit,
       ROUND(AVG(profit_margin_pct), 2) AS avg_margin
FROM sales
GROUP BY category
ORDER BY total_sales DESC;

-- Top 10 Customers by Revenue

SELECT customer_name, customer_id,
       SUM(sales) AS total_spent
FROM sales
GROUP BY customer_id,customer_name
ORDER BY total_spent DESC
LIMIT 10;

-- Monthly Sales Trend

SELECT order_year, order_month_name, 
       SUM(sales) AS monthly_sales
FROM sales
GROUP BY order_year, order_month, order_month_name
ORDER BY order_year, order_month;


-- High Discount = Loss?

SELECT discount, 
       ROUND(AVG(profit_margin_pct), 2) AS avg_margin,
       COUNT(*) AS num_orders
FROM sales
GROUP BY discount
ORDER BY discount;

-- Region-wise Sales Ranking

SELECT region, 
       SUM(sales) AS total_sales,
       RANK() OVER (ORDER BY SUM(sales) DESC) AS sales_rank
FROM sales
GROUP BY region;

-- Cumulative Sales Trend Over Time

SELECT order_year, order_month_name,
       SUM(sales) AS monthly_sales,
       SUM(SUM(sales)) OVER (ORDER BY order_year, order_month) AS running_total
FROM sales
GROUP BY order_year, order_month,order_month_name
ORDER BY order_year, order_month;

-- Top Customer by Region

WITH customer_sales AS (
    SELECT region, customer_name, SUM(sales) AS total_sales,
           RANK() OVER (PARTITION BY region ORDER BY SUM(sales) DESC) AS rnk
    FROM sales
    GROUP BY region, customer_name
)
SELECT region, customer_name, total_sales
FROM customer_sales
WHERE rnk = 1;

-- Delivery Performance by Ship Mode

SELECT ship_mode, 
       ROUND(AVG(delivery_days), 2) AS avg_delivery_days,
       COUNT(*) AS total_orders
FROM sales
GROUP BY ship_mode
ORDER BY avg_delivery_days;

-- Year-over-Year Growth

SELECT order_year, 
       SUM(sales) AS yearly_sales,
       LAG(SUM(sales)) OVER (ORDER BY order_year) AS prev_year_sales,
       ROUND(((SUM(sales) - LAG(SUM(sales)) OVER (ORDER BY order_year)) / 
              LAG(SUM(sales)) OVER (ORDER BY order_year)) * 100, 2) AS growth_pct
FROM sales
GROUP BY order_year
ORDER BY order_year;

-- Sub-Category Profitability Ranking

SELECT sub_category,
       SUM(sales) AS total_sales,
       SUM(profit) AS total_profit,
       RANK() OVER (ORDER BY SUM(profit) DESC) AS profit_rank
FROM sales
GROUP BY sub_category;