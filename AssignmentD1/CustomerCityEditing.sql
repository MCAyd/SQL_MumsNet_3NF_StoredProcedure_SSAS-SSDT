USE AssignmentPart1;

/*PRIMARY KEY WILL BE ID*/
SELECT DISTINCT Id
FROM CustomerCity;

SELECT	*
from CustomerCity;

SELECT *
FROM CustomerCity
WHERE FirstName='Corinne' and LastName='Bacon'
ORDER BY FirstName,LastName;

--FIRST TABLE
SELECT Id, Gender, FirstName, LastName, Dateregistered, City, COUNT(*)
FROM CustomerCity
GROUP BY Id, Gender, FirstName, LastName, DateRegistered, City
having COUNT(*) = 1;

--transitive dependencies check
--OTHER TABLES
SELECT City, COUNT(DISTINCT(County)) AS Unique_Values_Assigned
FROM CustomerCity
GROUP BY City
having COUNT(DISTINCT(County)) > 1

SELECT County, COUNT(DISTINCT(Region)) AS Unique_Values_Assigned
FROM CustomerCity
GROUP BY County
having COUNT(DISTINCT(Region)) > 1

SELECT Region, COUNT(DISTINCT(Country)) AS Unique_Values_Assigned
FROM CustomerCity
GROUP BY Region
having COUNT(DISTINCT(Country)) > 1

SELECT *
FROM CustomerInfo