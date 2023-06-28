
--  Check for duplicates --
SELECT customer_id, COUNT(customer_id) as count_id
FROM customer_churn 
GROUP BY customer_id
HAVING COUNT(customer_id)>1  


-- 1. Find total number of customers --
SELECT COUNT(customer_id)
FROM customer_churn
-- result: 7043


-- 2. How much revenue did Maven lose to churned customers? --
Select Customer_Status,
COUNT(customer_id) AS customer_count,
ROUND( SUM(Total_Revenue)*100 / SUM(SUM(Total_Revenue))OVER() ,1) AS Revenue_Percentage

FROM customer_churn
group by Customer_Status
ORDER BY Customer_Status

-- 3. Typical tenure for churners 
 SELECT
	CASE 
		WHEN Tenure_in_Months <= 6 THEN '6 months'
		WHEN Tenure_in_Months <= 12 THEN '1 year'
		WHEN Tenure_in_Months <= 24 THEN '2 years'
		ELSE '>2 years'
	END AS Tenure,
	
ROUND(COUNT(customer_id)*100 / SUM(COUNT(customer_id))OVER(),1) AS Churn_Percentage
FROM customer_churn
WHERE Customer_Status = 'Churned'
GROUP BY Tenure
ORDER BY Churn_Percentage DESC

-- 4. which cities had the highest churn rates? --
SELECT 
	City,
	COUNT(customer_id) AS Churned,
	CEILING(
	 COUNT(CASE WHEN Customer_Status = 'Churned' 
							THEN customer_id 
							ELSE NULL
					END)*100 / COUNT(customer_id)
			) 
	AS Churned_rate
FROM customer_churn
GROUP BY City
HAVING COUNT(customer_id) > 30
ORDER BY Churned_rate DESC 
LIMIT 5

-- 5. why did customers leave?
SELECT Churn_Category,
ROUND(SUM(Total_Revenue),0) AS Churned_Rev,
ROUND( COUNT(customer_id)*100 / SUM(COUNT(customer_id))OVER())
	 AS churn_percentage
FROM customer_churn
WHERE Customer_Status = 'Churned'
GROUP BY Churn_Category
ORDER BY churn_percentage DESC

-- 5.1 specific reasons for churn 
SELECT  Churn_Reason,Churn_Category,
			 ROUND (COUNT(Churn_Reason)*100 / SUM(COUNT(Churn_Reason)) OVER(), 1)					AS churn_reason_percentage 
FROM customer_churn
WHERE Customer_Status = 'Churned'
GROUP BY Churn_Reason,Churn_Category
ORDER BY churn_reason_percentage DESC
LIMIT 5

-- 5.2 what kind of offers churners have 
SELECT Offer,
			 ROUND(COUNT(Offer)*100 / SUM(COUNT(Offer)) over() ,1) AS offer_churn_percentage
FROM customer_churn
WHERE Customer_Status = 'Churned'
GROUP BY Offer
ORDER BY offer_churn_percentage DESC

-- 5.3 what internet type did churners have? 
SELECT 
	Internet_Type,
	COUNT(customer_id) AS churned,
	ROUND(COUNT(customer_id)*100 / SUM(COUNT(customer_id)) over(),1) AS churn_percentage 
FROM customer_churn
WHERE Customer_Status = 'Churned' 
GROUP BY Internet_Type
ORDER BY churn_percentage DESC

-- 5.4 what internet type did 'compititor' churners have?
SELECT 
	Internet_Type,
	COUNT(customer_id) AS churned,
	ROUND(COUNT(customer_id)*100 / SUM(COUNT(customer_id)) over(),1) AS churn_percentage 
FROM customer_churn
WHERE Customer_Status = 'Churned' AND Churn_Category = 'Competitor'
GROUP BY Internet_Type, Churn_Category
ORDER BY churn_percentage DESC

-- 5.5 Did churners have preium tech support?
SELECT
	Premium_Tech_Support,
	COUNT(customer_id) AS Churned,
	ROUND(COUNT(customer_id)*100/SUM(COUNT(customer_id))over(),1) AS Churn_percentage 
FROM customer_churn
WHERE Customer_Status = 'Churned' 
GROUP BY Premium_Tech_Support
ORDER BY Churn_percentage DESC

-- 5.6 what contract were churners on? 
SELECT
	Contract,
	COUNT(customer_id) AS Churned,
	ROUND(COUNT(customer_id)*100/SUM(COUNT(customer_id))over(),1) AS Churn_percentage 
FROM customer_churn
WHERE Customer_Status = 'Churned' 
GROUP BY Contract
ORDER BY Churn_percentage DESC