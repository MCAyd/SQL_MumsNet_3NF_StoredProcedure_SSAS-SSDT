USE AssignmentPart1;

/*for finding composite primary key*/
--FIRST TABLE OrderItemNumber, FK OrderNumber
SELECT *
FROM OrderItem;

SELECT DISTINCT OrderItemNumber
FROM OrderItem;

/*for finding transitive dependencies */
--SECOND TABLE PK OrderNumber, FK CustomerCityId
SELECT OrderItemNumber,OrderNumber,OrderCreateDate, COUNT(*)
FROM OrderItem
GROUP BY OrderItemNumber, OrderNumber, OrderCreateDate
having COUNT(*) > 1

SELECT OrderItemNumber,OrderNumber,OrderStatusCode, COUNT(*)
FROM OrderItem
GROUP BY OrderItemNumber, OrderNumber, OrderStatusCode
having COUNT(*) > 1

SELECT OrderNumber, COUNT(DISTINCT(CustomerCityId)) AS Unique_Values_Assigned
FROM OrderItem
GROUP BY OrderNumber
having COUNT(DISTINCT(CustomerCityId)) > 1

SELECT OrderNumber, COUNT(DISTINCT(BillingCurrency)) AS Unique_Values_Assigned
FROM OrderItem
GROUP BY OrderNumber
having COUNT(DISTINCT(BillingCurrency)) > 1

--THIRD TABLE PK CustomerCityId
SELECT CustomerCityId, COUNT(DISTINCT(BillingCurrency)) AS Unique_Values_Assigned
FROM OrderItem
GROUP BY CustomerCityId
having COUNT(DISTINCT(BillingCurrency)) > 1
