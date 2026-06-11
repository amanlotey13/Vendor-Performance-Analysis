-- =========================================
-- Vendor Performance Analysis Project
-- Focus: Sales, Profitability, Reliability
-- =========================================
create database vendor_data;
use vendor_data;

CREATE TABLE vendor_data (
    vendor_id INT,
    vendor_name VARCHAR(100),
    supplier_region VARCHAR(100),
    category VARCHAR(100),
    sub_category VARCHAR(100),
    product_id VARCHAR(50),
    product_name VARCHAR(150),
    country VARCHAR(100),
    order_id INT PRIMARY KEY,
    order_date DATE,
    ship_date DATE,
    ship_mode VARCHAR(50),
    lead_time INT,
    month VARCHAR(20),
    season VARCHAR(20),
    selling_price DECIMAL(10,2),
    cost_price DECIMAL(10,2),
    profit DECIMAL(10,2),
    profit_margin DECIMAL(5,2),
    quantity INT,
    sales DECIMAL(10,2),
    discount DECIMAL(5,2),
    stock_level INT,
    supplier_reliability DECIMAL(3,2),
    inventory_risk VARCHAR(50),
    demand_variability VARCHAR(50)
);

select * from vendor_data;

use vendor_data;


-- Preview Data
SELECT * FROM vendor_data LIMIT 10;

/* =====================================================
   STEP 1: Vendor Performance Overview (CORE KPI)
   ===================================================== */

SELECT 
    Vendor_Name,
    COUNT(Order_ID) AS total_orders,
    SUM(Sales) AS total_sales,
    SUM(Profit) AS total_profit,
    SUM(Quantity) AS total_quantity,
    AVG(`Profit_Margin_Pct`) AS avg_profit_margin
FROM vendor_data
GROUP BY Vendor_Name
ORDER BY total_sales DESC;


/* =====================================================
   STEP 2: Vendor Ranking (MOST IMPORTANT 🔥)
   ===================================================== */

SELECT 
    Vendor_Name,
    SUM(Sales) AS total_sales,
    SUM(Profit) AS total_profit,
    AVG(`Profit_Margin_Pct`) AS avg_margin,
    RANK() OVER (ORDER BY SUM(Sales) DESC) AS vendor_rank
FROM vendor_data
GROUP BY Vendor_Name;


/* =====================================================
   STEP 3: Top & Bottom Vendors
   ===================================================== */

-- Top 5 Vendors
SELECT 
    Vendor_Name,
    SUM(Sales) AS total_sales
FROM vendor_data
GROUP BY Vendor_Name
ORDER BY total_sales DESC
LIMIT 5;

-- Bottom 5 Vendors
SELECT 
    Vendor_Name,
    SUM(Sales) AS total_sales
FROM vendor_data
GROUP BY Vendor_Name
ORDER BY total_sales ASC
LIMIT 5;


/* =====================================================
   STEP 4: Vendor Profitability Analysis
   ===================================================== */

SELECT 
    Vendor_Name,
    SUM(Profit) AS total_profit,
    AVG(`Profit_Margin_Pct`) AS avg_margin
FROM vendor_data
GROUP BY Vendor_Name
ORDER BY total_profit DESC;


/* =====================================================
   STEP 5: Vendor Reliability & Supply Chain
   ===================================================== */

SELECT 
    Vendor_Name,
    AVG(Supplier_Reliability) AS reliability_score,
    AVG(Lead_Time) AS avg_lead_time,
    AVG(Inventory_Risk) AS risk_level
FROM vendor_data
GROUP BY Vendor_Name
ORDER BY reliability_score DESC;


/* =====================================================
   STEP 6: Vendor Risk Identification
   ===================================================== */

SELECT 
    Vendor_Name,
    AVG(Inventory_Risk) AS risk_level,
    AVG(Demand_Variability) AS demand_variation
FROM vendor_data
GROUP BY Vendor_Name
HAVING risk_level > 0.7
ORDER BY risk_level DESC;


/* =====================================================
   STEP 7: Vendor Sales Trend (Time-Based)
   ===================================================== */

SELECT 
    Vendor_Name,
    Month,
    SUM(Sales) AS monthly_sales
FROM vendor_data
GROUP BY Vendor_Name, Month
ORDER BY Vendor_Name, Month;


/* =====================================================
   STEP 8: Category Contribution by Vendor
   ===================================================== */

SELECT 
    Vendor_Name,
    Category,
    SUM(Sales) AS category_sales
FROM vendor_data
GROUP BY Vendor_Name, Category
ORDER BY Vendor_Name, category_sales DESC;


/* =====================================================
   STEP 9: Discount Impact on Vendor Performance
   ===================================================== */

SELECT 
    Vendor_Name,
    AVG(Discount) AS avg_discount,
    SUM(Sales) AS total_sales,
    SUM(Profit) AS total_profit
FROM vendor_data
GROUP BY Vendor_Name
ORDER BY avg_discount DESC;


/* =====================================================
   STEP 10: Poor Performing Vendors (Critical Insight 🚨)
   ===================================================== */

SELECT 
    Vendor_Name,
    SUM(Sales) AS total_sales,
    AVG(`Profit_Margin_Pct`) AS avg_margin,
    
    AVG(
        CASE 
            WHEN Supplier_Reliability = 'High' THEN 3
            WHEN Supplier_Reliability = 'Medium' THEN 2
            WHEN Supplier_Reliability = 'Low' THEN 1
        END
    ) AS reliability_score

FROM vendor_data
GROUP BY Vendor_Name
HAVING total_sales < 5000 
   OR avg_margin < 10 
   OR reliability_score < 2;
   