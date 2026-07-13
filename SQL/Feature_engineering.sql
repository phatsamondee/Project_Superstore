/*
========================================
========================================

			FEATURE ENGINEERING		
	
========================================
========================================
Create Analytical Views

- Date Features
    -> order_year
    -> order_month
    -> order_quarter

- Shipping Features
    -> ship_delay_days

- Discount Features
    -> discount_type

- Customer Features
    -> customer_level (Platinum (Top 10%), Gold (Top 20%), Silver (Top 40%) and Classic (Others))
*/
-- Drop existing view if it already exists
DROP VIEW IF EXISTS Sample_Superstore_clean_addfeature;

-- CREATE VIEW Add order_year, order_month, order_quarter, ship_delay_days, discount_type, customer_level
CREATE VIEW Sample_Superstore_clean_addfeature AS
WITH customer_sales AS (
    SELECT
        Customer_ID,
        Customer_Name,
        SUM(Sales) AS total_sales,
        SUM(Profit) AS total_profit,
        COUNT(DISTINCT Order_ID) AS total_orders
    FROM Sample_Superstore_clean
    GROUP BY Customer_ID, Customer_Name
	),
ranked AS (
    SELECT *,
        NTILE(10) OVER (ORDER BY total_sales DESC) AS sales_decile,
        NTILE(10) OVER (ORDER BY total_orders DESC) AS orders_decile
    FROM customer_sales
	),
customer_level AS (
    SELECT
        Customer_ID,
        CASE
            WHEN sales_decile = 1 AND orders_decile = 1 THEN 'Platinum'
            WHEN sales_decile <= 2 AND orders_decile <= 2 THEN 'Gold'
            WHEN sales_decile <= 4 AND orders_decile <= 4 THEN 'Silver'
            ELSE 'Classic'
        END AS customer_level
    FROM ranked
	)
SELECT
    s.*,
    CAST(strftime('%Y', s.Order_Date) AS INTEGER) AS order_year,
    CAST(strftime('%m', s.Order_Date) AS INTEGER) AS order_month,
    CASE
        WHEN CAST(strftime('%m', s.Order_Date) AS INTEGER) BETWEEN 1 AND 3 THEN 'Q1'
        WHEN CAST(strftime('%m', s.Order_Date) AS INTEGER) BETWEEN 4 AND 6 THEN 'Q2'
        WHEN CAST(strftime('%m', s.Order_Date) AS INTEGER) BETWEEN 7 AND 9 THEN 'Q3'
        ELSE 'Q4'
    END AS order_quarter,
    CAST(julianday(s.Ship_Date) - julianday(s.Order_Date) AS INTEGER) AS ship_delay_days,
    CASE
        WHEN s.Discount = 0 THEN 'No Discount'
        ELSE 'Discount'
    END AS discount_type,
    c.customer_level
FROM Sample_Superstore_clean s
LEFT JOIN customer_level c
ON s.Customer_ID = c.Customer_ID;

-- Validate Created Features
SELECT
    MIN(order_year) AS min_year,
    MAX(order_year) AS max_year,
    COUNT(DISTINCT order_quarter) AS total_quarters,
    MIN(ship_delay_days) AS min_delay,
    MAX(ship_delay_days) AS max_delay
FROM Sample_Superstore_clean_addfeature;

SELECT
    customer_level,
    COUNT(*) AS total_customers
FROM Sample_Superstore_clean_addfeature
GROUP BY customer_level;