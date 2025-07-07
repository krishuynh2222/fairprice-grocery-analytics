-- ========================================================
-- Purpose: Segment-based sales analysis and index optimization
-- Author: Ngan Huynh
-- ========================================================

-- 1. Total sales by fat content
SELECT 
  Item_Fat_Content,
  SUM(Sales) AS total_sales
FROM fair_price_data
GROUP BY Item_Fat_Content;

-- 2. Total sales by item type (descending order)
SELECT 
  Item_Type,
  SUM(Sales) AS total_sales
FROM fair_price_data
GROUP BY Item_Type
ORDER BY total_sales DESC;

-- 3. Sales comparison by fat content across outlet location types
WITH sales_by_fat AS (
  SELECT
    Outlet_Location_Type,
    Item_Fat_Content,
    SUM(Sales) AS sales
  FROM fair_price_data
  GROUP BY Outlet_Location_Type, Item_Fat_Content
)
SELECT
  Outlet_Location_Type,
  COALESCE(MAX(CASE WHEN Item_Fat_Content = 'Low Fat' THEN sales END), 0) AS low_fat_sales,
  COALESCE(MAX(CASE WHEN Item_Fat_Content = 'Regular' THEN sales END), 0) AS regular_sales
FROM sales_by_fat
GROUP BY Outlet_Location_Type
ORDER BY Outlet_Location_Type;

-- 4. Percentage share of sales by outlet size
WITH size_totals AS (
  SELECT 
    Outlet_Size,
    SUM(Sales) AS total_sales
  FROM fair_price_data
  GROUP BY Outlet_Size
)
SELECT
  Outlet_Size,
  total_sales,
  ROUND(total_sales * 100.0 / SUM(total_sales) OVER (), 2) AS pct_share
FROM size_totals
ORDER BY total_sales DESC;

-- 5. Performance optimization: creating indexes on key columns
CREATE INDEX idx_fp_outlet_size ON fair_price_data(Outlet_Size);
CREATE INDEX idx_fp_fat_content ON fair_price_data(Item_Fat_Content);
