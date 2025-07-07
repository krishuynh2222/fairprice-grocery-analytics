-- Total row count
SELECT COUNT(*) AS total_rows FROM fair_price_data;

-- Detect duplicate items
SELECT Item_Identifier, COUNT(*) 
FROM fair_price_data
GROUP BY Item_Identifier
HAVING COUNT(*) > 1;

-- Verify visibility bounds
SELECT COUNT(*) AS invalid_visibility
FROM fair_price_data
WHERE Item_Visibility < 0 OR Item_Visibility > 1;

-- Check establishment years range
SELECT MIN(Outlet_Establishment_Year) AS min_year,
       MAX(Outlet_Establishment_Year) AS max_year
FROM fair_price_data;


