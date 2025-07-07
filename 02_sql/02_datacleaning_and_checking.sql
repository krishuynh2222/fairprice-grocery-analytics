-- ================================
-- Data Cleaning & Quality Check
-- Dataset: fair_price_data
-- Author: Ngan Huynh
-- Description: Normalize values, check duplicates, missing values, and data summary
-- ================================

-- 1. Normalize 'item_fat_content' values (standardize inconsistent labels)
UPDATE fair_price_data
SET item_fat_content = CASE 
    WHEN LOWER(item_fat_content) = 'lf' THEN 'Low Fat'
    WHEN LOWER(item_fat_content) = 'low fat' THEN 'Low Fat'
    WHEN LOWER(item_fat_content) = 'reg' THEN 'Regular'
    ELSE item_fat_content
END;

-- 2. Count total rows in the dataset
SELECT COUNT(*) AS total_rows
FROM fair_price_data;

-- 3. Check distinct values in 'item_fat_content' after normalization
SELECT item_fat_content,
       COUNT(*) AS frequency
FROM fair_price_data
GROUP BY item_fat_content
ORDER BY frequency DESC;

-- 4. Check for duplicate item identifiers
SELECT Item_Identifier,
       COUNT(*) AS duplicate_count
FROM fair_price_data
GROUP BY Item_Identifier
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC;

-- 5. Count number of duplicate item identifiers
SELECT COUNT(*) AS num_duplicate_ids
FROM (
  SELECT Item_Identifier
  FROM fair_price_data
  GROUP BY Item_Identifier
  HAVING COUNT(*) > 1
) AS duplicates;

-- 6. Check for missing values (NULLs) in key columns
SELECT 
  SUM(CASE WHEN Item_Identifier IS NULL THEN 1 ELSE 0 END) AS missing_item_id,
  SUM(CASE WHEN sales IS NULL THEN 1 ELSE 0 END) AS missing_sales,
  SUM(CASE WHEN item_fat_content IS NULL THEN 1 ELSE 0 END) AS missing_fat_content
FROM fair_price_data;

-- 7. Summary of sales (min, max, average, total)
SELECT 
  MIN(sales) AS min_sales,
  MAX(sales) AS max_sales,
  AVG(sales) AS avg_sales,
  SUM(sales) AS total_sales
FROM fair_price_data;

