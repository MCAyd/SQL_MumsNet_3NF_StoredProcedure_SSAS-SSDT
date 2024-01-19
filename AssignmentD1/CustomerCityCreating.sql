USE AssignmentPart1;

SELECT DISTINCT Id,Gender,FirstName,LastName,DateRegistered,City
INTO dbo.CustomerInfo   
FROM dbo.CustomerCity

ALTER TABLE dbo.CustomerInfo	
ADD CONSTRAINT pk_customerinfo PRIMARY KEY CLUSTERED (Id)
GO

ALTER TABLE dbo.customerinfo	
ADD CONSTRAINT fk_customerinfo FOREIGN KEY (city) REFERENCES dbo.county (city)
GO

SELECT DISTINCT City, County
INTO dbo.County	   
FROM dbo.CustomerCity

ALTER TABLE dbo.county	
ADD CONSTRAINT pk_county PRIMARY KEY CLUSTERED (city)
GO

ALTER TABLE dbo.county	
ADD CONSTRAINT fk_county FOREIGN KEY (county) REFERENCES dbo.region (county)
GO

SELECT DISTINCT County, Region
INTO dbo.Region	   
FROM dbo.CustomerCity

ALTER TABLE dbo.region	
ADD CONSTRAINT pk_region PRIMARY KEY CLUSTERED (county)
GO

ALTER TABLE dbo.region	
ADD CONSTRAINT fk_region FOREIGN KEY (region) REFERENCES dbo.country (region)
GO

SELECT DISTINCT Region, Country
INTO dbo.Country		   
FROM dbo.CustomerCity

ALTER TABLE dbo.country	
ADD CONSTRAINT pk_country PRIMARY KEY CLUSTERED (region)
GO

SELECT *
FROM CustomerInfo

SELECT *
FROM County

SELECT *
FROM Region

SELECT *
FROM Country

