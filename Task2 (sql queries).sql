CREATE DATABASE online_retail;
USE online_retail;
SHOW TABLES;

DESCRIBE retail_data;

SELECT * FROM retail_data;

SELECT `Quantity`, `UnitPrice` FROM retail_data;

SELECT 
CAST(Quantity AS DECIMAL(10,2)) * 
CAST(UnitPrice AS DECIMAL(10,2)) AS revenue
FROM retail_data;

SELECT 
YEAR(STR_TO_DATE(InvoiceDate, '%m/%d/%Y %H:%i'))
FROM retail_data;

SELECT * FROM retail_data LIMIT 5;

-- 1. Top 5 Products by Revenue
SELECT Description,
       SUM(CAST(Quantity AS DECIMAL(10,2)) * CAST(UnitPrice AS DECIMAL(10,2))) AS Revenue
FROM retail_data
GROUP BY Description
ORDER BY Revenue DESC
LIMIT 5;

-- 2. Monthly Revenue Trend
SELECT 
    YEAR(STR_TO_DATE(InvoiceDate, '%m/%d/%Y %H:%i')) AS Year,
    MONTH(STR_TO_DATE(InvoiceDate, '%m/%d/%Y %H:%i')) AS Month,
    SUM(CAST(Quantity AS DECIMAL(10,2)) * CAST(UnitPrice AS DECIMAL(10,2))) AS Revenue
FROM retail_data
GROUP BY Year, Month
ORDER BY Year, Month;

-- 3. Top 5 Customers by Spending
SELECT CustomerID,
       SUM(CAST(Quantity AS DECIMAL(10,2)) * CAST(UnitPrice AS DECIMAL(10,2))) AS Total_Spend
FROM retail_data
GROUP BY CustomerID
ORDER BY Total_Spend DESC
LIMIT 5;

-- 4. Revenue by Country
SELECT Country,
       SUM(CAST(Quantity AS DECIMAL(10,2)) * CAST(UnitPrice AS DECIMAL(10,2))) AS Revenue
FROM retail_data
GROUP BY Country
ORDER BY Revenue DESC;

-- 5. Most Sold Products
SELECT Description,
       SUM(CAST(Quantity AS DECIMAL(10,2))) AS Total_Quantity
FROM retail_data
GROUP BY Description
ORDER BY Total_Quantity DESC
LIMIT 5;

-- 7. Orders by Weekday
SELECT DAYNAME(STR_TO_DATE(InvoiceDate, '%m/%d/%Y %H:%i')) AS Day,
       COUNT(DISTINCT InvoiceNo) AS Total_Orders
FROM retail_data
GROUP BY Day

-- 8. Customer Lifetime Value (CLV)
SELECT 
    CustomerID,
    COUNT(DISTINCT InvoiceNo) AS total_orders,
    SUM(
        CAST(Quantity AS DECIMAL(10,2)) * 
        CAST(UnitPrice AS DECIMAL(10,2))
    ) AS total_revenue
FROM retail_data
WHERE CustomerID IS NOT NULL
GROUP BY CustomerID
ORDER BY total_revenue DESC
LIMIT 10;

-- 9. Average Order Value (AOV)
SELECT 
    AVG(order_total) AS avg_order_value
FROM (
    SELECT 
        InvoiceNo,
        SUM(
            CAST(Quantity AS DECIMAL(10,2)) * 
            CAST(UnitPrice AS DECIMAL(10,2))
        ) AS order_total
    FROM retail_data
    GROUP BY InvoiceNo
) t;

-- 10. Repeat vs One-Time Customers
SELECT customer_type, COUNT(*) AS total_customers
FROM (
    SELECT 
        CustomerID,
        CASE 
            WHEN COUNT(DISTINCT InvoiceNo) = 1 THEN 'One-time'
            ELSE 'Repeat'
        END AS customer_type
    FROM retail_data
    WHERE CustomerID IS NOT NULL
    GROUP BY CustomerID
) t
GROUP BY customer_type;

-- 11. Basket Size (Avg Items per Order)
SELECT 
    AVG(items_per_order) AS avg_basket_size
FROM (
    SELECT 
        InvoiceNo,
        SUM(CAST(Quantity AS DECIMAL(10,2))) AS items_per_order
    FROM retail_data
    GROUP BY InvoiceNo
) t;