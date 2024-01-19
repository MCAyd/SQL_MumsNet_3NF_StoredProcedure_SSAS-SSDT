USE AssignmentPart1;
---THERE ARE NULL VALUES IN SIZE CUP LEGLENGTH COLOUR DESCRIPTION AND FEATURE COLUMNS
--THAT FAILS THE NORMALIZATION THEY NEED TO STAY IN ORIGINAL TABLE WHICH WILL BE ProdGroup

SELECT DISTINCT ProductGroup, VariantCode, Size, Cup, LegLength, Colour, Description, Features
INTO dbo.ProdGroup   
FROM dbo.Product

SELECT DISTINCT VariantCode, ProductCode, Price
INTO dbo.ProdVariant   
FROM dbo.Product

SELECT DISTINCT ProductCode, Name
INTO dbo.ProdCode  
FROM dbo.Product

ALTER TABLE dbo.ProdGroup
ADD CONSTRAINT pk_prodgroup PRIMARY KEY CLUSTERED (ProductGroup, VariantCode)
GO

ALTER TABLE dbo.ProdVariant
ADD CONSTRAINT pk_prodvariant PRIMARY KEY CLUSTERED (VariantCode)
GO

ALTER TABLE dbo.ProdCode
ADD CONSTRAINT pk_prodcode PRIMARY KEY CLUSTERED (ProductCode)
GO

--TO REACH PRODVARIANT TABLE FROM PRODGROUP TABLE WE NEED TO IDENTIFY VARIANTCODE ALSO AS A FOREIGN KEY.
ALTER TABLE dbo.ProdGroup
ADD CONSTRAINT fk_prodgroup FOREIGN KEY (VariantCode) REFERENCES dbo.ProdVariant (VariantCode)

ALTER TABLE dbo.ProdVariant
ADD CONSTRAINT fk_prodvariant FOREIGN KEY (ProductCode) REFERENCES dbo.ProdCode (ProductCode)
GO

SELECT *
FROM ProdGroup

SELECT *
FROM ProdVariant

SELECT *
FROM ProdCode
