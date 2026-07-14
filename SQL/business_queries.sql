CREATE DATABASE retail_db,

SELECT TOP 10 *
FROM store_sales_data;

-- Total Sales
SELECT SUM(Sales) AS Total_Sales
FROM store_sales_data;

-- Total Profit
SELECT SUM(Profit) AS Total_Profit
FROM store_sales_data;

-- Total Orders
SELECT COUNT(DISTINCT Order_ID) AS Total_Orders
FROM store_sales_data;

-- Total Customers
SELECT COUNT(DISTINCT Customer_ID) AS Total_Customers
FROM store_sales_data;

--Total Quantity Sold
SELECT SUM(Quantity) AS Total_Quantity
FROM store_sales_data;

--Average Sales Per Order
SELECT
SUM(Sales) / COUNT(DISTINCT Order_ID) AS Avg_Sales_Per_Order
FROM store_sales_data;

--Average Profit Per Order
SELECT
SUM(Profit) / COUNT(DISTINCT Order_ID) AS Avg_Profit_Per_Order
FROM store_sales_data;

--Total Number of Products Sold
SELECT COUNT(DISTINCT Product_ID) AS Total_Products
FROM store_sales_data;

--Total Categories
SELECT COUNT(DISTINCT Category_of_Goods) AS Total_Categories
FROM store_sales_data;

--Total States
SELECT COUNT(DISTINCT State) AS Total_States
FROM store_sales_data;

--Monthly Sales
SELECT
    YEAR(Order_Date) AS Year,
    MONTH(Order_Date) AS Month,
    SUM(Sales) AS Total_Sales
FROM store_sales_data
GROUP BY YEAR(Order_Date), MONTH(Order_Date)
ORDER BY Year, Month;

--Yearly Sales
SELECT
    YEAR(Order_Date) AS Year,
    SUM(Sales) AS Total_Sales
FROM store_sales_data
GROUP BY YEAR(Order_Date)
ORDER BY Year;

--Category-wise Sales
SELECT
    Category_of_Goods,
    SUM(Sales) AS Total_Sales
FROM store_sales_data
GROUP BY Category_of_Goods
ORDER BY Total_Sales DESC;

--Sub-Category-wise Sales
SELECT
    Sub_Category,
    SUM(Sales) AS Total_Sales
FROM store_sales_data
GROUP BY Sub_Category
ORDER BY Total_Sales DESC;

--Region-wise Sales
SELECT
    Region,
    SUM(Sales) AS Total_Sales
FROM store_sales_data
GROUP BY Region
ORDER BY Total_Sales DESC;

--State-wise Sales
SELECT
    State,
    SUM(Sales) AS Total_Sales
FROM store_sales_data
GROUP BY State
ORDER BY Total_Sales DESC;

--City-wise Sales
SELECT
    City_Type,
    SUM(Sales) AS Total_Sales
FROM store_sales_data
GROUP BY City_Type
ORDER BY Total_Sales DESC;

--Top 10 Products by Sales
SELECT TOP 10
    Product_Name,
    SUM(Sales) AS Total_Sales
FROM store_sales_data
GROUP BY Product_Name
ORDER BY Total_Sales DESC;

--Top 10 Customers
SELECT TOP 10
    Customer_Name,
    SUM(Sales) AS Total_Sales
FROM store_sales_data
GROUP BY Customer_Name
ORDER BY Total_Sales DESC;

--Top 10 Profitable Products
SELECT TOP 10
    Product_Name,
    SUM(Profit) AS Total_Profit
FROM store_sales_data
GROUP BY Product_Name
ORDER BY Total_Profit DESC;

--Running Total of Sales
SELECT
    Order_Date,
    Sales,
    SUM(Sales) OVER (
        ORDER BY Order_Date
    ) AS Running_Total
FROM store_sales_data;

--Monthly Running Total
SELECT
    YEAR(Order_Date) AS Year,
    MONTH(Order_Date) AS Month,
    SUM(Sales) AS Monthly_Sales,
    SUM(SUM(Sales)) OVER(
        ORDER BY YEAR(Order_Date), MONTH(Order_Date)
    ) AS Running_Total
FROM store_sales_data
GROUP BY YEAR(Order_Date), MONTH(Order_Date);

--Rolling 3-Month Average
WITH MonthlySales AS
(
SELECT
YEAR(Order_Date) AS Year,
MONTH(Order_Date) AS Month,
SUM(Sales) AS MonthlySales
FROM store_sales_data
GROUP BY YEAR(Order_Date),MONTH(Order_Date)
)

SELECT *,
AVG(MonthlySales) OVER(
ORDER BY Year,Month
ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
) AS Rolling_Average
FROM MonthlySales;

--Customer Lifetime Value (CLV)
SELECT
Customer_ID,
Customer_Name,
SUM(Sales) AS Lifetime_Value
FROM store_sales_data
GROUP BY Customer_ID,Customer_Name
ORDER BY Lifetime_Value DESC;

--Repeat Customers
SELECT
Customer_ID,
Customer_Name,
COUNT(DISTINCT Order_ID) AS Total_Orders
FROM store_sales_data
GROUP BY Customer_ID,Customer_Name
HAVING COUNT(DISTINCT Order_ID)>1
ORDER BY Total_Orders DESC;

--Top 10 Customers using RANK()
SELECT *
FROM
(
SELECT
Customer_Name,
SUM(Sales) AS TotalSales,
RANK() OVER(
ORDER BY SUM(Sales) DESC
) AS Ranking
FROM store_sales_data
GROUP BY Customer_Name
)t
WHERE Ranking<=10;

--Top 10 Products using DENSE_RANK()
SELECT *
FROM
(
SELECT
Product_Name,
SUM(Sales) AS TotalSales,
DENSE_RANK() OVER(
ORDER BY SUM(Sales) DESC
) AS Ranking
FROM store_sales_data
GROUP BY Product_Name
)t
WHERE Ranking<=10;

--ROW_NUMBER()
SELECT
ROW_NUMBER() OVER(
ORDER BY Sales DESC
) AS Row_Num,
Order_ID,
Customer_Name,
Sales
FROM store_sales_data;

--CASE WHEN (Profit or Loss)
SELECT
Order_ID,
Product_Name,
Profit,
CASE
WHEN Profit>0 THEN 'Profit'
WHEN Profit<0 THEN 'Loss'
ELSE 'No Profit No Loss'
END AS Profit_Status
FROM store_sales_data;

--Sales Above Average (Subquery)
SELECT *
FROM store_sales_data
WHERE Sales >
(
SELECT AVG(Sales)
FROM store_sales_data
);

--Customer Sales Percentage
SELECT
Customer_Name,
SUM(Sales) AS Customer_Sales,
ROUND(
SUM(Sales)*100.0/
(SELECT SUM(Sales) FROM store_sales_data),2
) AS Sales_Percentage
FROM store_sales_data
GROUP BY Customer_Name
ORDER BY Customer_Sales DESC;

--Most Profitable Category
SELECT TOP 1
Category_of_Goods,
SUM(Profit) AS Total_Profit
FROM store_sales_data
GROUP BY Category_of_Goods
ORDER BY Total_Profit DESC;

--Top State by Profit
SELECT TOP 1
State,
SUM(Profit) AS Total_Profit
FROM store_sales_data
GROUP BY State
ORDER BY Total_Profit DESC;
