



Create PROC [dbo].[sp_TEST] @PlayerID VARCHAR(10) , @TransactionAMT MONEY  , @TType VARCHAR(10) , @MSG VARCHAR(100) OUTPUT
AS
BEGIN
		-- Declaring parameters 
DECLARE @TransactionType VARCHAR (10)
DECLARE @TDate DATETIME
DECLARE @TotalAMT MONEY
						--Checking Validation of the Username in the System
					IF @PlayerID NOT IN (SELECT @PlayerID
												FROM [dbo].[PlayerDetails])
					BEGIN
						SET @MSG = 'PlayerID is Not Exists In The System'
						SET NOEXEC ON
					END
		SET @TDate = GETUTCDATE() --Sets default date
		SET @TransactionType = @TType --Checking the transaction type if it's Depossit or Withdraw and fixes the value from @TransactionAMT
					IF(@TType = 'Deposit' )
				BEGIN
					SET @TransactionAMT = +(@TransactionAMT)
				END
					ELSE 
				BEGIN
					SET @TransactionAMT = -(@TransactionAMT)
				END
		SET @TotalAMT = (@TransactionAMT + COALESCE((SELECT SUM(TransactionAMT) --Sums the TotalAmount per Username
							FROM BankRoll
								WHERE PlayerID = @PlayerID),0))
		IF (@TransactionType = 'Withdraw' AND @TotalAMT <0 OR @TransactionAMT > @TotalAMT) --Validation for Withdraws transactions
		BEGIN
			SET @MSG = 'Transaction Cannot Be Completed'
			SET NOEXEC ON
		END
		ELSE
		BEGIN
			SET @MSG = 'Transaction Completed'
		END
				--Inserting the values into the [dbo].[BankRoll] Table
		INSERT INTO [dbo].[BankRoll] ([TransactionType] , [TransactionAMT] , [TransactionDate],[PlayerID],[TotalAmount])
		VALUES(@TransactionType , @TransactionAMT , @TDate , @PlayerID , @TotalAMT)
END
GO