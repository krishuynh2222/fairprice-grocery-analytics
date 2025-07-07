-- ========================================================
-- Purpose: Calculate core KPIs for fair_price_data
-- Author: Ngan Huynh
-- ========================================================

-- A. Total Sales (in millions)
SELECT 
    CAST(SUM(Sales) / 1000000.0 AS DECIMAL(10,2)) AS total_sales_millions
FROM fair_price_data;

-- B. Average Order Value (AOV)
SELECT 
    CAST(AVG(Sales) AS DECIMAL(10,2)) AS avg_order_value
FROM fair_price_data;

-- C. Total Number of Orders
SELECT 
    COUNT(*) AS total_orders 
FROM fair_price_data;

-- D. Average Rating across all items
SELECT 
    CAST(AVG(Rating) AS DECIMAL(3,2)) AS avg_rating
FROM fair_price_data;
