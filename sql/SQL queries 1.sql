create database walmart_analysis;
use walmart_analysis;

CREATE TABLE walmart_sales (
    Store INT NOT NULL,
    Date DATE NOT NULL,
    Weekly_Sales DECIMAL(12,2) NOT NULL,
    Holiday_Flag TINYINT NOT NULL,
    Temperature FLOAT,
    Fuel_Price FLOAT,
    CPI FLOAT,
    Unemployment FLOAT,

    -- Engineered columns from Python
    Year INT,
    Month INT,
    Month_Name VARCHAR(15),
    Week INT,

    PRIMARY KEY (Store, Date)
);


LOAD DATA INFILE
'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/walmart_cleaned.csv'
INTO TABLE walmart_sales
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


select * from walmart_sales;
select count(*) from walmart_sales;
describe walmart_sales;


----  Row Count & Date Range

SELECT 
    COUNT(*) AS total_rows,
    MIN(Date) AS start_date,
    MAX(Date) AS end_date
FROM
    walmart_sales;

---- Check Holiday Flag Validity

SELECT 
    Holiday_Flag, COUNT(*) AS records
FROM
    walmart_sales
GROUP BY Holiday_Flag;

---- Negative or Zero Sales Check

SELECT 
    *
FROM
    walmart_sales
WHERE
    Weekly_Sales <= 0;
    
---- Total & Average Sales

SELECT 
    SUM(Weekly_Sales) AS total_sales,
    AVG(Weekly_Sales) AS avg_sales
FROM
    walmart_sales;
    
---- Yearly Sales Trend

SELECT 
    Year,
    SUM(Weekly_Sales) AS total_sales
FROM walmart_sales
GROUP BY Year
ORDER BY Year;


---- Monthly Seasonality

SELECT 
    Month,
    AVG(Weekly_Sales) AS avg_weekly_sales
FROM walmart_sales
GROUP BY Month
ORDER BY Month;


---- Holiday vs Non-Holiday Sales
---- Total Weekly_Sales for Holiday vs Non Holiday 

SELECT 
    Holiday_Flag, SUM(Weekly_Sales) AS total_sales
FROM
    walmart_sales
GROUP BY Holiday_Flag;


---- Average Weekly Sales for Holiday vs Non-Holiday

SELECT 
    CASE
        WHEN Holiday_Flag = 1 THEN 'Holiday'
        ELSE 'Non-Holiday'
    END AS week_type,
    ROUND(AVG(Weekly_Sales), 2) AS avg_weekly_sales
FROM
    walmart_sales
GROUP BY week_type;


---- Holiday Lift %
---- Calculates the percentage increase in average weekly sales during holidays compared to non-holiday weeks

/* 
“This query calculates the percentage increase in average weekly sales during holidays compared to normal weeks,
 with protection against division by zero.”
 
 Why did i use NULLIF?
 "To avoid division by zero and ensure the query doesn’t fail if non-holiday sales are missing.”
 */

SELECT 
    ROUND(((AVG(CASE WHEN Holiday_Flag = 1 THEN Weekly_Sales END) - AVG(CASE WHEN Holiday_Flag = 0 THEN Weekly_Sales END)) /
            NULLIF(AVG(CASE WHEN Holiday_Flag = 0 THEN Weekly_Sales END), 0)) * 100, 2) AS holiday_lift_percentage
FROM walmart_sales;

    
---- Top 10 Stores by Revenue

SELECT 
    store, SUM(Weekly_Sales) AS total_sales
FROM
    walmart_sales
GROUP BY store
ORDER BY total_sales DESC
LIMIT 10;


---- Store Ranking Using Window Functions 

SELECT
    Store,
    SUM(Weekly_Sales) AS total_sales,
    RANK() OVER (ORDER BY SUM(Weekly_Sales) DESC) AS store_rank
FROM walmart_sales
GROUP BY Store;


---- Store-Wise Holiday Lift 
---- Calculates holiday lift for EACH STORE separately
---- Compares holiday vs non-holiday average sales within the same store

/* I calculated store-wise holiday lift and used a HAVING clause 
to ensure each store had sufficient holiday and non-holiday data, preventing misleading averages.
*/

SELECT 
    Store,
    ((AVG(CASE WHEN Holiday_Flag = 1 THEN Weekly_Sales END) - AVG(CASE WHEN Holiday_Flag = 0 THEN Weekly_Sales END)) /
        AVG(CASE WHEN Holiday_Flag = 0 THEN Weekly_Sales END)) * 100 AS holiday_lift_percentage
FROM walmart_sales
GROUP BY Store
HAVING
    COUNT(CASE WHEN Holiday_Flag = 1 THEN 1 END) >= 2
AND COUNT(CASE WHEN Holiday_Flag = 0 THEN 1 END) >= 2
ORDER BY holiday_lift_percentage DESC;



---- Yearly Sales View

CREATE OR REPLACE VIEW vw_yearly_sales AS
SELECT
    Year,
    SUM(Weekly_Sales) AS total_sales
FROM walmart_sales
GROUP BY Year;


---- Monthly Sales view 

CREATE OR REPLACE VIEW vw_monthly_seasonality AS
SELECT
    Month,
    Month_Name,
    AVG(Weekly_Sales) AS avg_weekly_sales
FROM walmart_sales
GROUP BY Month, Month_Name
ORDER BY Month;


---- Store Performance View

CREATE OR REPLACE VIEW vw_store_performance AS
SELECT
    Store,
    SUM(Weekly_Sales) AS total_sales,
    RANK() OVER (ORDER BY SUM(Weekly_Sales) DESC) AS store_rank
FROM walmart_sales
GROUP BY Store;


---- Date view 

CREATE VIEW vw_dim_date AS
SELECT DISTINCT
    Date,
    Year,
    Month,
    Month_Name,
    Week,
    QUARTER(Date) AS Quarter,
    CASE WHEN Holiday_Flag = 1 THEN 'Holiday' ELSE 'Regular' END AS Date_Type
FROM walmart_sales;


SHOW FULL TABLES WHERE Table_type = 'VIEW';

Select * from vw_yearly_sales;

select * from vw_monthly_seasonality;

select * from vw_store_performance;

select * from vw_dim_date;

select * from walmart where unemployment is null;


    
-- Check for orphans (Records that Python might have missed but SQL caught)
SELECT 
    (SELECT COUNT(*) FROM walmart_sales) AS Total_Records,
    (SELECT SUM(Weekly_Sales) FROM walmart_sales) AS Total_Revenue;



