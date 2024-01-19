USE AssignmentPart1;
---THERE ARE NULL VALUES IN SIZE CUP LEGLENGTH COLOUR DESCRIPTION AND FEATURE COLUMNS
--THAT FAILS THE NORMALIZATION THEY NEED TO STAY IN ORIGINAL TABLE WHICH WILL BE ProdGroup

/*for finding composite primary key*/
SELECT *
FROM Product;

--THE MAIN TABLE PRIMARY KEYS WILL BE
SELECT DISTINCT ProductGroup, VariantCode
FROM Product
ORDER BY ProductGroup, VariantCode;

SELECT ProductGroup, COUNT(DISTINCT(VariantCode)) AS Unique_Values_Assigned
FROM Product
GROUP BY ProductGroup
having COUNT(DISTINCT(VariantCode)) > 1

SELECT VariantCode, COUNT(DISTINCT(ProductGroup)) AS Unique_Values_Assigned
FROM Product
GROUP BY VariantCode
having COUNT(DISTINCT(ProductGroup)) = 1 --not returns the row number of main table

-----------
--SECOND TABLE PK VARIANTCODE, FK PRODUCTCODE
SELECT DISTINCT VariantCode
FROM Product

SELECT VariantCode, COUNT(DISTINCT(ProductCode)) AS Unique_Values_Assigned
FROM Product
GROUP BY VariantCode
having COUNT(DISTINCT(ProductCode)) = 1

SELECT VariantCode, COUNT(DISTINCT(Name)) AS Unique_Values_Assigned
FROM Product
GROUP BY VariantCode
having COUNT(DISTINCT(Name)) = 1

SELECT VariantCode, COUNT(DISTINCT(Price)) AS Unique_Values_Assigned
FROM Product
GROUP BY VariantCode
having COUNT(DISTINCT(Price)) = 1

/*for finding transitive dependencies*/
SELECT DISTINCT ProductCode
FROM Product

--THIRD TABLE PK ProductCode
SELECT ProductCode, COUNT(DISTINCT(Name)) AS Unique_Values_Assigned
FROM Product
GROUP BY ProductCode
having COUNT(DISTINCT(Name)) = 1

/* no transitive dependencies between ProductCode and price*/
SELECT ProductCode, COUNT(DISTINCT(Price)) AS Unique_Values_Assigned
FROM Product
GROUP BY ProductCode
having COUNT(DISTINCT(Price)) > 1

SELECT ProductCode,Price
FROM ProdVariant
WHERE PRODUCTCODE = '11160'
GROUP BY ProductCode, Price