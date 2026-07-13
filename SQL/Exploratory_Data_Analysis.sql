/*
========================================
========================================

        Exploratory Data Analysis
		
========================================
========================================
*/
-- 1. Dataset Overview
SELECT
    COUNT(*) AS total_records,
    COUNT(DISTINCT Order_ID) AS total_orders,
    COUNT(DISTINCT Customer_ID) AS total_customers,
    COUNT(DISTINCT Product_ID) AS total_products
FROM Sample_Superstore_clean;

-- 2. Date Range
SELECT
    MIN(Order_Date) AS first_order_date,
    MAX(Order_Date) AS last_order_date
FROM Sample_Superstore_clean;

-- 3. Sales Distribution
SELECT
    ROUND(MIN(Sales),2) AS min_sales,
    ROUND(MAX(Sales),2) AS max_sales,
    ROUND(AVG(Sales),2) AS avg_sales
FROM Sample_Superstore_clean;

-- 4. Profit Distribution
SELECT
    ROUND(MIN(Profit),2) AS min_profit,
    ROUND(MAX(Profit),2) AS max_profit,
    ROUND(AVG(Profit),2) AS avg_profit
FROM Sample_Superstore_clean;

-- 5. Discount Distribution
SELECT
    Discount,
    COUNT(*) AS total_records
FROM Sample_Superstore_clean
GROUP BY Discount
ORDER BY Discount;

-- 6. Shipping Delay Distribution
SELECT
    ship_delay_days,
    COUNT(*) AS total_orders
FROM Sample_Superstore_clean_addfeature
GROUP BY ship_delay_days
ORDER BY ship_delay_days;

-- 7. Category Overview
SELECT
    Category,
    COUNT(DISTINCT Product_ID) AS total_products,
    COUNT(DISTINCT Order_ID) AS total_orders
FROM Sample_Superstore_clean
GROUP BY Category;

-- 8. Region Overview
SELECT
    Region,
    COUNT(DISTINCT Customer_ID) AS total_customers,
    COUNT(DISTINCT Order_ID) AS total_orders
FROM Sample_Superstore_clean
GROUP BY Region;
