-- 1. Standardize fat‐content labels
UPDATE fair_price_data
SET Item_Fat_Content = CASE LOWER(Item_Fat_Content)
  WHEN 'lf'       THEN 'Low Fat'
  WHEN 'low fat'  THEN 'Low Fat'
  WHEN 'reg'      THEN 'Regular'
  WHEN 'regular'  THEN 'Regular'
  ELSE INITCAP(Item_Fat_Content)
END;

-- 2. Validate remaining variants
SELECT DISTINCT Item_Fat_Content
FROM fair_price_data;
