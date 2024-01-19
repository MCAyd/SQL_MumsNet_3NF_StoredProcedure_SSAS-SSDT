USE AssignmentPart1;

SELECT DISTINCT OrderItemNumber, OrderNumber, ProductGroup, ProductCode, VariantCode, Quantity, UnitPrice, LineItemTotal
INTO dbo.OrderItemLine   
FROM dbo.OrderItem

SELECT DISTINCT OrderNumber, OrderCreateDate, OrderStatusCode, CustomerCityId
INTO dbo.OrderAll  
FROM dbo.OrderItem

SELECT DISTINCT CustomerCityId, BillingCurrency
INTO dbo.Currency 
FROM dbo.OrderItem

--pk and index operations
ALTER TABLE dbo.OrderItemLine
ADD CONSTRAINT pk_orderitemline PRIMARY KEY CLUSTERED (OrderItemNumber)
GO

CREATE NONCLUSTERED INDEX NonClusteredIndOrderItemLine
ON dbo.OrderItemLine (OrderNumber);

ALTER TABLE dbo.OrderAll
ADD CONSTRAINT pk_orderall PRIMARY KEY NONCLUSTERED (OrderNumber)
GO

CREATE CLUSTERED INDEX ClusteredIndOrderAll
ON dbo.OrderAll (OrderCreateDate);


---In the Currency table the primary key will be customercityid but the pk also needs to be restricted from the customerinfo table
---There shouldn't be a customerid in the currency table that the customer information is not in the customerInfo table
ALTER TABLE dbo.Currency
ADD CONSTRAINT pk_currency PRIMARY KEY CLUSTERED (CustomerCityId)
GO

--Restricting the PK as stated above.
ALTER TABLE dbo.Currency
ADD CONSTRAINT fk_currency FOREIGN KEY (CustomerCityId) REFERENCES dbo.CustomerInfo (Id)
GO

--defining foreign keys
ALTER TABLE dbo.OrderItemLine
ADD CONSTRAINT fk_orderItemline FOREIGN KEY (OrderNumber) REFERENCES dbo.OrderAll (OrderNumber)
GO

--WE NEED TO ADD FK CONSTRAINTS TO ORDERITEMLINE TABLE CORREPONDS TO PRODGROUP TABLE, PRODVARIANT TABLE AND PRODCODE TABLE
ALTER TABLE dbo.OrderItemLine
ADD CONSTRAINT fk_orderItemline2 FOREIGN KEY (ProductGroup, VariantCode) REFERENCES dbo.ProdGroup (ProductGroup, VariantCode)
GO

ALTER TABLE dbo.OrderItemLine
ADD CONSTRAINT fk_orderItemline3 FOREIGN KEY (VariantCode) REFERENCES dbo.ProdVariant (VariantCode)
GO

ALTER TABLE dbo.OrderItemLine
ADD CONSTRAINT fk_orderItemline4 FOREIGN KEY (ProductCode) REFERENCES dbo.ProdCode (ProductCode)
GO

ALTER TABLE dbo.OrderAll
ADD CONSTRAINT fk_orderall FOREIGN KEY (CustomerCityId) REFERENCES dbo.Currency (CustomerCityId)
GO

ALTER TABLE dbo.OrderAll
ADD CONSTRAINT fk_orderall1 FOREIGN KEY (CustomerCityId) REFERENCES dbo.CustomerInfo (Id)
GO

--adding columns as requested and get the values from orderall table with below executions.
ALTER TABLE dbo.orderAll ADD TotalLineItems int null
ALTER TABLE dbo.orderAll ADD SavedTotal money null

UPDATE OrderAll SET
    TotalLineItems= (SELECT
      SUM(Quantity) FROM OrderItem 
	  WHERE OrderAll.OrderNumber = OrderNumber
	  GROUP BY orderNumber)

UPDATE OrderAll SET
    SavedTotal= (SELECT
      SUM(Quantity*UnitPrice) FROM OrderItem 
	  WHERE OrderAll.OrderNumber = OrderNumber
	  GROUP BY orderNumber)

SELECT *
FROM OrderAll

SELECT *
FROM OrderItemLine

SELECT *
FROM Currency

SELECT *
FROM OrderItemLine
WHERE OrderNumber = 'OR\01012009\22'