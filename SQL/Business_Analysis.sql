/*
========================================
========================================

			Business Analysis				
	
========================================
========================================
Business Questions: What factors influence sales and profitability?

1. What are the overall business performance metrics?
	-> Total Sales
	-> Total Profit
	-> Profit Margin
	-> Total Orders
	-> Average Order Values (AOV)
	-> Total Customers
2. Which product categories generate the highest sales and profit?
3. Which regions and states perform the best?
4. Which customer groups contribute the most revenue?
	-> Segment
	-> Customer Level (Platinum (Top 10%), Gold (Top 20%), Silver (Top 40%) and Classic (Others))
5. Which shipping mode is used most frequently, and how long does delivery take on average?
6. How has business performance changed over time?
   -> Monthly Trend
   -> Quarterly Trend
   -> Yearly Trend
   -> Average Monthly Performance (2014–2017)
*/

-- 1. What are the overall business performance metrics?
SELECT
	SUM(Sales) AS total_sales,
	SUM(Profit) AS total_profit,
	SUM(Profit)/SUM(Sales) AS profit_margin,
	COUNT(DISTINCT(Order_ID)) AS total_orders,
	SUM(Sales)/COUNT(DISTINCT(Order_ID)) AS avg_order_values,
	COUNT(DISTINCT(Customer_ID)) AS total_customer
FROM Sample_Superstore_clean;

-- 2. Which product categories generate the highest sales and profit?
SELECT Category, Sub_Category, SUM(Sales) AS total_sales, SUM(Profit) AS total_profit
FROM Sample_Superstore_clean
GROUP BY Category, Sub_Category
ORDER BY total_profit DESC;

-- 3. Which regions and states perform the best?
SELECT Region, State,
		SUM(Sales) AS total_sales, 
		SUM(Profit) AS total_profit, 
		ROUND(SUM(Profit)/SUM(Sales)*100, 2) AS profit_margin
FROM Sample_Superstore_clean
GROUP BY Region, State
ORDER BY total_profit DESC;

-- 4. Which customer groups contribute the most revenue?
-- Segment
SELECT Segment, 
		SUM(Sales) AS total_sales,
		SUM(Discount) AS total_discount,
		SUM(Profit) AS total_profit,
		ROUND(SUM(Profit)/SUM(Sales)*100, 2) AS profit_margin,
        COUNT(DISTINCT(Order_ID)) AS total_orders
FROM Sample_Superstore_clean
GROUP BY Segment;

-- Customer Level (Platinum (Top 10%), Gold (Top 20%), Silver (Top 40%) and Classic (Others))
WITH customer_sales AS (
    SELECT
        Customer_Name,
        SUM(Sales) AS total_sales,
        SUM(Profit) AS total_profit,
        COUNT(DISTINCT Order_ID) AS total_orders
    FROM Sample_Superstore_clean
    GROUP BY Customer_Name
	),
	ranked AS (
    SELECT *,
        NTILE(10) OVER (ORDER BY total_sales DESC) AS sales_decile,
        NTILE(10) OVER (ORDER BY total_orders DESC) AS orders_decile
    FROM customer_sales
	)
	SELECT
    CASE
        WHEN sales_decile = 1 AND orders_decile = 1 THEN 'Platinum'
        WHEN sales_decile <= 2 AND orders_decile <= 2 THEN 'Gold'
        WHEN sales_decile <= 4 AND orders_decile <= 4 THEN 'Silver'
        ELSE 'Classic'
    END AS customer_level,
    ROUND(SUM(total_sales),2) AS total_sales,
    ROUND(SUM(total_profit),2) AS total_profit,
    ROUND(SUM(total_profit) * 100.0 / SUM(total_sales),2) AS profit_margin,
    SUM(total_orders) AS total_orders
FROM ranked
GROUP BY customer_level
ORDER BY
CASE customer_level
    WHEN 'Platinum' THEN 1
    WHEN 'Gold' THEN 2
    WHEN 'Silver' THEN 3
    ELSE 4
END;

-- 5. Which shipping mode is used most frequently, and how long does delivery take on average?
SELECT Ship_Mode, 
		SUM(Profit) AS total_profit, 
		ROUND(SUM(Profit)*100/SUM(Sales),2) AS profit_margin
FROM Sample_Superstore_clean
GROUP BY Ship_Mode
ORDER BY total_profit DESC;

-- 6. How has business performance changed over time?
-- Monthly Trend
SELECT 
	order_month, 
	CAST(SUM(Sales) AS INTEGER) AS total_sales, 
	CAST(SUM(Profit) AS INTEGER) AS total_profit, 
	ROUND(SUM(Profit)/SUM(Sales)*100, 2) AS profit_margin, 
	ROUND(AVG(Discount)*100, 2) AS avg_discount
FROM Sample_Superstore_clean_addfeature
GROUP BY order_month;

-- Quarterly Trend
SELECT 
	order_quarter, 
	CAST(SUM(Sales) AS INTEGER) AS total_sales, 
	CAST(SUM(Profit) AS INTEGER) AS total_profit, 
	ROUND(SUM(Profit)/SUM(Sales)*100, 2) AS profit_margin, 
	ROUND(AVG(Discount)*100, 2) AS avg_discount
FROM Sample_Superstore_clean_addfeature
GROUP BY order_quarter;

-- Yearly Trend
SELECT 
	order_year, 
	CAST(SUM(Sales) AS INTEGER) AS total_sales, 
	CAST(SUM(Profit) AS INTEGER) AS total_profit, 
	ROUND(SUM(Profit)/SUM(Sales)*100, 2) AS profit_margin, 
	ROUND(AVG(Discount)*100, 2) AS avg_discount
FROM Sample_Superstore_clean_addfeature
GROUP BY order_year;

-- Average Monthly Performance (2014–2017)
WITH monthly_sales AS (
    SELECT
        order_year,
        order_month,
        SUM(Sales) AS total_sales,
        SUM(Profit) AS total_profit
    FROM Sample_Superstore_clean_addfeature
    GROUP BY order_year, order_month
	)
SELECT
    order_month,
    ROUND(AVG(total_sales), 2) AS avg_monthly_sales,
    ROUND(AVG(total_profit), 2) AS avg_monthly_profit,
    ROUND(SUM(total_profit) * 100 / SUM(total_sales), 2) AS avg_profit_margin
FROM monthly_sales
GROUP BY order_month
ORDER BY order_month;