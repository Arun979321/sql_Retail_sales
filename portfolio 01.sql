-- Creating Database
CREATE DATABASE sql_project2;

-- Creating Table
DROP TABLE IF EXISTS Retail_sales;
CREATE TABLE Retail_sales
  (
    transactions_id  INT PRIMARY KEY,
    sale_date  DATE,    
    sale_time   TIME,
    customer_id INT,
    gender  VARCHAR(15),
    age INT,
    category VARCHAR(15),   
    quantity    INT,
    price_per_unit  FLOAT,
    cogs    FLOAT,
    total_sale FLOAT
  );

SELECT * FROM Retail_sales
LIMIT 20

SELECT COUNT(*) FROM Retail_sales

SELECT * FROM Retail_sales
WHERE

     transactions_id IS NULL
	 OR
	 sale_date IS NULL
	 OR 
	 sale_time IS NULL
	 OR
	 customer_id IS NULL
	 OR
	 gender IS NULL
	 OR
	 category IS NULL
	 OR
	 quantity IS NULL

DELETE FROM Retail_sales
WHERE
     transactions_id IS NULL
	 OR
	 sale_date IS NULL
	 OR 
	 sale_time IS NULL
	 OR
	 customer_id IS NULL
	 OR
	 gender IS NULL
	 OR
	 category IS NULL
	 OR
	 quantity IS NULL

SELECT COUNT(DISTINCT total_sale) FROM Retail_sales	 
SELECT COUNT( DISTINCT customer_id) FROM Retail_sales	
SELECT DISTINCT total_sale FROM Retail_sales
SELECT DISTINCT category FROM Retail_sales

-- write a sql query to retrive all columns made on '2022-11-05'
SELECT * FROM Retail_sales
WHERE sale_date = '2022-11-05';

-- write a sql query to retrive all transaction where the category is 'Clothing' and quantity is sold more than 10 in the month of nov-2022....
SELECT *
FROM Retail_sales
WHERE 
category = 'Clothing'
AND
TO_CHAR(sale_date,'yyyy-mm')= '2022-11'
AND 
quantity >= 4

-- write a sql query to calculate the total sales(total_sale) of each category..
SELECT
category, 
SUM(total_sale) AS net_sale
FROM Retail_sales
GROUP BY 1

SELECT category, SUM(total_sale)
FROM Retail_sales
GROUP BY category;

-- write a sql query to find the average age of customer who purchased item of 'Beauty' category...
SELECT 
AVG(age) AS avg_age
FROM Retail_sales
WHERE category = 'Beauty';

SELECT 
ROUND(AVG(age), 2) AS avg_age
FROM Retail_sales
WHERE category = 'Beauty';

--write a sql query to find all transactions where the total_sale is greater than 1000...
SELECT 
transactions_id AS transactions 
FROM Retail_sales
WHERE
total_sale >1000

SELECT * FROM Retail_sales
WHERE total_sale >1000

SELECT COUNT(transactions_id) AS Total_transactions
FROM Retail_sales
WHERE total_sale > 1000

-- write a sql query to find out the total number of transaction(transaction_id) made by each gender in each category...
SELECT 
category,
gender,
COUNT(transactions_id) AS total_tran
FROM Retail_sales 
GROUP 
BY
 category,
 gender
ORDER BY 1; 


SELECT 
category,
gender,
COUNT(*) AS total_tran
FROM Retail_sales 
GROUP 
BY
 category,
 gender
ORDER BY 1; 

--write sql query for calculate the avg sale for each month,,find out best selling month in each year...

SELECT
   EXTRACT(YEAR FROM sale_date) AS year,
   EXTRACT (MONTH FROM sale_date) AS month,
   AVG(total_sale) AS avg_sale,
RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) AS RANK
FROM Retail_sales
GROUP BY 1, 2


SELECT
year,
month,
avg_sale
FROM
(SELECT
   EXTRACT(YEAR FROM sale_date) AS year,
   EXTRACT (MONTH FROM sale_date) AS month,
   AVG(total_sale) AS avg_sale,
RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) AS rank
FROM Retail_sales
GROUP BY 1, 2
) AS T1
WHERE
rank = 1

--write a sql query to find the top 5 customer based on the total highest sales...
SELECT 
 customer_id, 
 SUM(total_sale) AS total_sales
FROM Retail_sales
GROUP BY 1
ORDER BY 2  DESC  
LIMIT 5


-- write a sql query to find the number of uniqe customer who purchased item from each category...
SELECT
category,
COUNT( DISTINCT customer_id) as unique_cust
FROM Retail_sales
GROUP BY 1


--write a sql query to create each shift and number of orders(for example Morning<12, Afternoon between 12 & 17, Evening>17)
WITH hourly_sale
AS(
SELECT*,
  CASE
      WHEN EXTRACT (HOUR FROM sale_time )<12 THEN 'Morning'
	  WHEN EXTRACT (HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
	  ELSE 'Evening'
	  END AS shift
  FROM Retail_sales	  
 )
SELECT 
 shift,
 COUNT(*) AS total_orders
 FROM hourly_sale
 GROUP BY shift