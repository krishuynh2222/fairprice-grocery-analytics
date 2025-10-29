-- ========================================================
-- Purpose: Segment-based sales analysis and index optimization
-- Author: Ngan Huynh
-- ========================================================

-- 1. Total sales by fat content
SELECT 
  Item_Fat_Content,
  ROUND(CAST(SUM(Sales) / 1000000 AS numeric), 2) AS total_sales
FROM fair_price_data
GROUP BY Item_Fat_Content;

-- 2. Total sales by item type (descending order)
SELECT 
  Item_Type,
  ROUND(CAST(SUM(Sales) / 1000 AS numeric), 2) AS Total_Sales
FROM fair_price_data
GROUP BY Item_Type
ORDER BY Total_Sales DESC;

-- 3. Sales comparison by fat content across outlet location types
WITH sales_by_fat AS (
  SELECT
    Outlet_Location_Type,
    Item_Fat_Content,
    ROUND(CAST(SUM(Sales) / 1000 AS numeric), 2) AS Total_Sales
  FROM fair_price_data
  GROUP BY Outlet_Location_Type, Item_Fat_Content
)
SELECT
  Outlet_Location_Type,
  COALESCE(MAX(CASE WHEN Item_Fat_Content = 'Low Fat' THEN Total_Sales END), 0) AS low_fat_sales,
  COALESCE(MAX(CASE WHEN Item_Fat_Content = 'Regular' THEN Total_Sales END), 0) AS regular_sales
FROM sales_by_fat
GROUP BY Outlet_Location_Type
ORDER BY Outlet_Location_Type;

-- 4. Percentage share of sales by outlet size
WITH size_totals AS (
  SELECT 
    Outlet_Size,
    ROUND(CAST(SUM(Sales) / 1000 AS numeric), 2) AS Total_Sales
  FROM fair_price_data
  GROUP BY Outlet_Size
)
SELECT
  Outlet_Size,
  Total_Sales,
  ROUND(Total_Sales * 100.0 / SUM(Total_Sales) OVER (), 2) AS Sales_Percentage
FROM size_totals
ORDER BY Total_Sales DESC;

5. Which outlet types perform best?
SELECT
  Outlet_Type,
  ROUND(CAST(SUM(Sales) / 1000.0 AS numeric), 2) AS total_sales,  
  COUNT(*) AS num_items,      
  ROUND(CAST(AVG(Sales) AS numeric), 0) AS avg_sales,       
  ROUND(CAST(AVG(Rating) AS numeric), 1) AS avg_rating,     
  ROUND(CAST(SUM(item_Visibility) AS numeric), 0) AS item_visibility 
FROM fair_price_data
GROUP BY Outlet_Type
ORDER BY total_sales DESC;

-- 5. Performance optimization: creating indexes on key columns
CREATE INDEX idx_fp_outlet_size ON fair_price_data(Outlet_Size);
CREATE INDEX idx_fp_fat_content ON fair_price_data(Item_Fat_Content);
