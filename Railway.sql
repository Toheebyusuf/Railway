SELECT *
FROM Portfolio.dbo.Railway

SELECT SUM(Price) as Revenue
FROM Portfolio.dbo.Railway




--------------------------------Customer and Purchase Behaviour-------------------------------------------------

--Top selling Routes
SELECT Departure_Station, Arrival_Destination, COUNT(*) AS total_tickets
FROM Portfolio.dbo.Railway
GROUP BY Departure_Station, Arrival_Destination
ORDER BY total_tickets DESC;


--Popular Purchase Channels
SELECT Purchase_Type, COUNT(*) AS count
FROM Portfolio.dbo.Railway
GROUP BY Purchase_Type
Order by count Desc;

--Ticket Class Preference
SELECT Ticket_Class, COUNT(*) AS count
FROM Portfolio.dbo.Railway
GROUP BY Ticket_Class
Order by count Desc;

--Payment Method Preference
SELECT Payment_Method, COUNT(*) AS count
FROM Portfolio.dbo.Railway
GROUP BY Payment_Method
Order by count Desc;


-------------------------Revenue Analysis---------------------------------------------------------------
--Total Revenue over Time
SELECT Date_of_Purchase, SUM(Price) AS daily_revenue
FROM Portfolio.dbo.Railway
GROUP BY Date_of_Purchase
ORDER BY Date_of_Purchase Asc;


--Revenue by Payment Method
SELECT Payment_Method,SUM(Price) as Revenue
FROM Portfolio.dbo.Railway
Group by Payment_Method
Order by Revenue Desc

--Revenue by Ticket Type
SELECT Ticket_Type,SUM(Price) as Revenue
FROM Portfolio.dbo.Railway
Group by Ticket_Type
Order by Revenue Desc

--Revenue by Purchase Type
SELECT Purchase_Type,SUM(Price) as Revenue
FROM Portfolio.dbo.Railway
Group by Purchase_Type

------------------------------Operational Efficiency--------------------------------------------------------

--Delay Rate by station or Route
SELECT Departure_Station, COUNT(*) AS total,
       SUM(CASE WHEN Journey_Status = 'Delayed' THEN 1 ELSE 0 END) AS delayed,
       ROUND(SUM(CASE WHEN Journey_Status = 'Delayed' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS delay_rate
FROM Portfolio.dbo.Railway
GROUP BY Departure_Station
Order by delay_rate Desc;

--Most Commont Delay reasons
SELECT Reason_for_Delay, COUNT(*) as TotalDelays
FROM Portfolio.dbo.Railway
Where Reason_for_Delay is not Null
Group by Reason_for_Delay
Order by TotalDelays Desc

---------------------------Customer Service-------------------------------------
--Refund Request Rate
SELECT Case
			When Refund_Request = 1 Then 'Yes'
			Else 'No'
		End AS RefundRequest,   
			COUNT(*) AS Total
FROM Portfolio.dbo.Railway
GROUP BY Refund_Request;

--Refunds Vs Delay
SELECT Journey_Status, 
						Case
								When Refund_Request = 1 Then 'Yes'
								Else 'No'
						End AS RefundRequest, 
		COUNT(*) AS Totalcount
FROM Portfolio.dbo.Railway
GROUP BY Journey_Status, Refund_Request
Order by Totalcount Desc;


------------------------------------------------Time Base Trends
--PURCHASE TIME 
SELECT Case
			When DATEPART(Hour, Time_Of_Purchase) Between 5 and 11 Then 'Morning'
			When DATEPART(Hour, Time_of_Purchase) Between 12 and 16 Then 'Afternoon'
			When DATEPART(Hour, Time_of_Purchase) Between 17 and 19 Then 'Evening'
			Else 'Night'
		End As TimeOfTheDay, COUNT(*) As TotalPurchase
FROM Portfolio.dbo.Railway
GROUP BY 
			Case
					When DATEPART(Hour, Time_of_Purchase) Between 5 and 11 Then 'Morning'
					When DATEPART(Hour, Time_of_Purchase) Between 12 and 16 Then 'Afternoon'
					When DATEPART(Hour, Time_Of_purchase) Between 17 and 19 Then 'Evening'
					Else 'Night'
			End
ORDER BY TotalPurchase Desc


--cte
WITH categorized_purchases AS (
    SELECT 
        CASE 
            WHEN DATEPART(hour, Time_Of_purchase) BETWEEN 5 AND 11 THEN 'Morning'
            WHEN DATEPART(hour, Time_Of_purchase) BETWEEN 12 AND 16 THEN 'Afternoon'
            WHEN DATEPART(hour, Time_Of_purchase) BETWEEN 17 AND 20 THEN 'Evening'
            ELSE 'Night'
        END AS TimeOfTheDay
    FROM Portfolio.dbo.Railway
)
SELECT TimeOfTheDay, COUNT(*) AS TotalPurchase
FROM categorized_purchases
GROUP BY TimeOfTheDay
Order by TotalPurchase Desc


SELECT 
    CASE 
        WHEN DATEDIFF(day, Date_of_Journey, Date_of_Purchase) = 0 THEN 'Same Day'
        WHEN DATEDIFF(day, Date_of_Journey, Date_of_Purchase) < 0 THEN 'After Travel'
        WHEN DATEDIFF(day, Date_of_Journey, Date_of_Purchase) > 0 THEN 'Before Travel'
    END AS purchase_timing,
    COUNT(*) AS total_purchases
FROM Portfolio.dbo.Railway
GROUP BY 
    CASE 
        WHEN DATEDIFF(day, Date_of_Journey, Date_of_Purchase) = 0 THEN 'Same Day'
        WHEN DATEDIFF(day, Date_of_Journey, Date_of_Purchase) < 0 THEN 'After Travel'
        WHEN DATEDIFF(day, Date_of_Journey, Date_of_Purchase) > 0 THEN 'Before Travel'
    END




SELECT		 DATEDIFF(day, date_of_Journey, Date_of_Purchase) AS days_diff, COUNT(*) AS total_purchases
FROM		 Portfolio.dbo.Railway
GROUP BY     DATEDIFF(day, Date_of_Journey, Date_of_Purchase)
ORDER BY	 days_diff

