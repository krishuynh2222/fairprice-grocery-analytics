# FairPrice Grocery Sales Performance Analysis

**Tools Used:** Excel, MySQL, Tableau

Analyzing Fair Price sales performance, customer satisfaction, and inventory distribution for the marketing campaign in May 2025. An interactive Tableau dashboard can be found [Tableau](https://public.tableau.com/views/FairPriceGroceryDashboard/FairPrice?:language=en-US&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link)


![Executive Summary](./04_dashboard/FairPrice.png)
## Project Objective

Analyze sales performance data from the FairPrice dataset to uncover key insights into revenue distribution, product category performance, outlet contribution, and customer ratings.
This project focuses on identifying opportunities to improve profitability, optimize store operations, and guide promotional strategies using SQL analytics and data visualization using Tableau. 

## FairPrice Grocery Metrics and Dimensions

### Metrics (Measures)
- **Total Sales:** Total revenue generated (USD) across all transactions or products.
- **Average Sales:** Mean revenue per transaction or product (`SUM(Sales) / COUNT(*)`).
- **Number of Items:** Count of individual sale records (proxy for volume sold).
- **Average Rating:** Mean customer rating on a 1–5 scale.
- **Sales Percentage:** Segment’s share of overall sales (`SUM(Sales) / SUM(Sales) OVER()`).

### Dimensions (Attributes)
- **Item Fat Content:** Categorical label of product fat level (e.g. “Low Fat” vs. “Regular”).
- **Item Type:** Product category (e.g. Fruits and Vegetables, Dairy, Snack Foods, etc.).
- **Outlet Location Type:** Store’s geographic tier (Tier 1, Tier 2, Tier 3).
- **Outlet Size:** Store footprint classification (Small, Medium, High).
- **Outlet Type:** Store format (e.g. Supermarket Type1, Grocery Store, etc.).
- **Outlet Establishment Year:** Year the store first opened (2010–2022).
- **Product Visibility:** Percent visibility score in shelf placement (0–1 scale).
- **Product Weight:** Weight of each item in kilograms.

## Key Business Questions
- **1.**	What is the total revenue, average order value (AOV), and total number of orders?
- **2.**	How do Low Fat vs Regular items contribute to total sales?
- **3.**	Which product categories generate the highest revenue?
- **4.**	How do sales vary across location tiers and outlet sizes?
- **5.**	What is the average product rating, and does it vary by outlet or category?
- **6.**	Which business areas can be optimized to improve revenue and satisfaction?

## Summary of Insights & Key Business Questions
### 1. What is the total revenue, average order value (AOV), and total number of orders?
- Total revenue
```sql
SELECT 
    CAST(SUM(Sales) / 1000000.0 AS DECIMAL(10,2)) AS total_sales_millions
FROM fair_price_data;
```
Result:

<img width="183" height="64" alt="Screenshot 2025-10-29 at 6 30 40 PM" src="https://github.com/user-attachments/assets/4c6c361b-e06b-41da-8dc3-0c1121321eed" />

- Average order value
```sql
SELECT 
    CAST(SUM(Sales) / 1000000.0 AS DECIMAL(10,2)) AS total_sales_millions
FROM fair_price_data; 
```
Result: 

<img width="168" height="66" alt="Screenshot 2025-10-29 at 6 29 11 PM" src="https://github.com/user-attachments/assets/a81d538d-00e5-4bbc-b455-ddab25b54498" />

- Total number of orders
```sql
SELECT 
    COUNT(*) AS total_orders 
FROM fair_price_data;
```
Result:

<img width="146" height="67" alt="Screenshot 2025-10-29 at 6 32 55 PM" src="https://github.com/user-attachments/assets/0f4e5459-748f-49a4-a43d-44b79de000f5" />

- Average rating
```sql
SELECT 
    CAST(AVG(Rating) AS DECIMAL(3,2)) AS avg_rating
FROM fair_price_data;
```
Result:

<img width="150" height="67" alt="Screenshot 2025-10-29 at 6 33 24 PM" src="https://github.com/user-attachments/assets/7311230c-b45b-49dc-b49f-bf2a5cdf2313" />

### 2. How do Low Fat vs Regular items contribute to total sales?
```sql
SELECT 
  Item_Fat_Content,
  CAST(SUM(Sales) AS DECIMAL(10,2)) AS total_sales
FROM fair_price_data
GROUP BY Item_Fat_Content;
```
Result:

<img width="291" height="89" alt="Screenshot 2025-10-29 at 6 46 38 PM" src="https://github.com/user-attachments/assets/aa58be13-15ae-4b7f-a839-6f059fa99bbb" />

- **Low Fat** products account for ~64% ( $0.78 M ) of total sales, while **Regular** products make up ~36% ($0.43 M).
- **Opportunity:** Promote targeted “Low Fat” campaigns; this segment is driving the majority of revenue.
  
### 3. Which product categories generate the highest revenue?
```sql
SELECT 
  Item_Type,
  ROUND(CAST(SUM(Sales) / 1000 AS numeric), 2) AS Total_Sale
FROM fair_price_data
GROUP BY Item_Type
ORDER BY Total_Sales DESC;
```
Result: 

<img width="331" height="440" alt="Screenshot 2025-10-29 at 6 44 36 PM" src="https://github.com/user-attachments/assets/9aa27149-54f8-4780-8a0f-ee1ff9df7617" />

- **Fruits & Vegetables** ($178 K) and Snack Foods ($175 K) lead sales, together representing >30% of category revenue.
- **Opportunity:** Reevaluate pricing, promotions, or in-store placement for underperforming categories like Seafood.
- 
### 4. How do sales vary across location tiers and outlet sizes?
#### Location tiers 
```sql
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
```
Result: 

<img width="410" height="117" alt="Screenshot 2025-10-29 at 7 05 04 PM" src="https://github.com/user-attachments/assets/446a7006-b37c-4fca-ab88-acf85094578b" />

- **Tier 3** stores generate the highest total sales for both Low Fat ($307 K) and Regular ($165 K).
- **Tier 1** stores trail by ~30% in combined sales.
- **Opportunity:** Expand Tier 3 best practices (product mix, shelving) into Tier 1 locations to boost sales there.

#### Outlet sizes
```sql
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
```
Result: 

<img width="417" height="115" alt="Screenshot 2025-10-29 at 7 09 16 PM" src="https://github.com/user-attachments/assets/e58f3aca-f298-4089-a745-b1f20ddfbe85" />

- **Medium-sized** outlets capture 42% of total sales, followed by **Small** at 37%, and **High** at 21%.
- Despite larger footprint, **High-size** stores underperform relative to **Medium**.
- **Opportunity:** Audit High-size outlets for assortment gaps or promotional execution issues.

### What is the average product rating, sales, and item visibility, and does it vary by outlet or category?
```sql
SELECT
  Outlet_Type,
  ROUND(CAST(SUM(Sales) / 1000.0 AS numeric), 2) AS total_sales,  
  COUNT(*) AS num_items,      
  ROUND(CAST(AVG(Sales) AS numeric), 0) AS avg_sales,       
  ROUND(CAST(AVG(Rating) AS numeric), 1) AS avg_rating,     
  ROUND(CAST(SUM(item_visibility) AS numeric), 0) AS item_visibility 
FROM fair_price_data
GROUP BY Outlet_Type
ORDER BY total_sales DESC;
```
Result:

<img width="667" height="141" alt="Screenshot 2025-10-29 at 7 26 48 PM" src="https://github.com/user-attachments/assets/69f8d6fb-09be-4d2b-8596-db61fb27a9c8" />

#### Customer Ratings
- **Average rating** holds at (~4.0) across all segments, indicating stable customer satisfaction.
- **Opportunity:** Introduce targeted feedback loops in Tier 1 or High-size stores to sustain or raise perception further.

#### Store Age (Establishment Year) Trends
- **Newer stores (established 2018)** saw a revenue bump to $205K (50%) above the 10-year average of (~$132 K).
- **Older outlets (2010-2012)** started lower ($78K) but have steadily grown.
- **Opportunity**: Leverage learnings from the 2018 cohort’s design and rollout to rejuvenate older locations.

### Which business areas can be optimized to improve revenue and satisfaction?
- **Promotional Focus:** Roll out “Low Fat” cross-category bundles in Tier 1 outlets to capture incremental share.
- **Category Revitalization:** Test limited-time offers on lagging categories (Seafood, Breakfast) with eye-catching in-store displays.
- **Outlet Audit:** Conduct operational reviews at Underperforming “High” outlets to uncover merchandising or assortment issues.
- **Best Practice Sharing:** Document and replicate the product mix and marketing tactics from top-performing Tier 3 and 2018 stores across the network.
- **A/B Test Layouts:** Pilot new shelf layouts in Medium and High-size outlets to optimize product visibility and basket size.
  
By acting on these insights, FairPrice can better align product mix, promotional focus, and store execution to sustain growth and optimize profitability.


## Contact & Attribution
👤 Author: Ngan Huynh - Data Analyst

✉️ krishuynh2222@gmail.com

🔗 www.linkedin.com/in/krishuynh2222
