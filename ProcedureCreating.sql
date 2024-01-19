USE AssignmentPart1;

--THE FIRST PROCEDURE WE NEED TO EXECUTE IS ORDERGROUP THAT'S WHY THERE NEEDS TO BE A GENERAL ORDER FOR THE ITEMLINES, GIVES THE ERROR BELOW,
--Msg 547, Level 16, State 0, Procedure prCreateOrderItem, Line 18 [Batch Start Line 119]
--The INSERT statement conflicted with the FOREIGN KEY constraint "fk_orderItemline". The conflict occurred in database "AssignmentPart1", table "dbo.OrderAll", column 'OrderNumber'.

--PRCREATEORDERGROUP
GO
CREATE PROCEDURE prCreateOrderGroup
(@OrderNumber nvarchar(50),
@OrderCreateDate datetime,
@CustomerCityId bigint)
AS
BEGIN
	BEGIN TRANSACTION;
			BEGIN TRY
				INSERT INTO OrderAll
				(OrderNumber,
				OrderCreateDate,
				OrderStatusCode,
				CustomerCityId)
				VALUES (
				@OrderNumber,
				@OrderCreateDate,
				'0',
				@CustomerCityId)

				IF NOT EXISTS (SELECT CustomerCityId FROM Currency WHERE (CustomerCityId = @CustomerCityId))
					BEGIN		
						INSERT INTO Currency
						(CustomerCityId,
						BillingCurrency)
						VALUES  (
						@CustomerCityId,
						'GBP')
					END
				COMMIT TRANSACTION
			END TRY
	
		BEGIN CATCH
			ROLLBACK TRANSACTION
			  SELECT
				ERROR_NUMBER() AS ErrorNumber,
				ERROR_STATE() AS ErrorState,
				ERROR_SEVERITY() AS ErrorSeverity,
				ERROR_PROCEDURE() AS ErrorProcedure,
				ERROR_LINE() AS ErrorLine,
				ERROR_MESSAGE() AS ErrorMessage;		
		END CATCH
END
GO

--Cannot create an order for a customer not in the database, first customerinfo should be saved to db.
go
EXEC prCreateOrderGroup 'OR\19112022\01', '20221119', '39849093824'
go

go
EXEC prCreateOrderGroup 'OR\19112022\01', '20221119', '6200'
go

SELECT *
FROM OrderAll
WHERE OrderNumber = 'OR\19112022\01'

--Price and ProductCode CAN BE EXTRACTED FROM PRODVARIANT TABLE DIRECTLY SINCE THESE ARE UNIQUE FOR ANY VARIANTCODE
--PRCREATEORDERITEM
GO
CREATE PROCEDURE prCreateOrderItem
(@OrderNumber nvarchar(50),
@OrderItemNumber nvarchar(32),
@ProductGroup nvarchar(128),
@VariantCode nvarchar(50),
@Quantity int)
AS
BEGIN
	BEGIN TRANSACTION;
		DECLARE @UnitPrice money;
		SET @UnitPrice = (SELECT Price FROM ProdVariant WHERE VariantCode = @VariantCode)
		BEGIN TRY
			INSERT INTO OrderItemLine
			(OrderItemNumber,
			OrderNumber,
			ProductGroup,
			ProductCode,
			VariantCode,
			Quantity,
			UnitPrice,
			LineItemTotal)
			VALUES (
			@OrderItemNumber,
			@OrderNumber,
			@ProductGroup,
			(SELECT ProductCode FROM ProdVariant WHERE VariantCode = @VariantCode),
			@VariantCode,
			@Quantity,
		    @UnitPrice,
			@UnitPrice * @Quantity)
			COMMIT TRANSACTION 

			BEGIN TRANSACTION
				UPDATE OrderAll
					SET TotalLineItems = (SELECT
					SUM(Quantity) FROM OrderItemLine 
					WHERE OrderNumber = @OrderNumber) WHERE OrderAll.OrderNumber = @OrderNumber

				UPDATE OrderAll
					SET SavedTotal = (SELECT SUM(Quantity*UnitPrice) FROM OrderItemLine 
					WHERE OrderNumber = @OrderNumber) WHERE OrderAll.OrderNumber = @OrderNumber
			COMMIT TRANSACTION
		END TRY

		BEGIN CATCH
			ROLLBACK TRANSACTION
			  SELECT
				ERROR_NUMBER() AS ErrorNumber,
				ERROR_STATE() AS ErrorState,
				ERROR_SEVERITY() AS ErrorSeverity,
				ERROR_PROCEDURE() AS ErrorProcedure,
				ERROR_LINE() AS ErrorLine,
				ERROR_MESSAGE() AS ErrorMessage;	
		END CATCH

END
GO

go
EXEC prCreateOrderItem 'OR\19112022\01', 'OR\19112022\01\1', 'Bedtime', '00136325', '4'
go

SELECT *
FROM OrderAll
WHERE OrderNumber = 'OR\19112022\01'

go
EXEC prCreateOrderItem 'OR\19112022\01', 'OR\19112022\01\2', 'Maternity Sale', '306803', '4'
go

SELECT *
FROM OrderAll
WHERE OrderNumber = 'OR\19112022\01'

go
EXEC prCreateOrderItem 'OR\19112022\01', 'OR\19112022\01\3', 'Christmas Sale', '306803', '6'
go

SELECT *
FROM OrderAll
WHERE OrderNumber = 'OR\19112022\01'

DELETE  
FROM OrderItemLine
WHERE OrderNumber = 'OR\19112022\01'

DELETE  
FROM OrderAll
WHERE OrderNumber = 'OR\19112022\01'
