SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROC sp_LogIn @PlayerID INT , @Pass VARCHAR (100) , @MSG VARCHAR(100) OUTPUT
AS
BEGIN
DECLARE @Status VARCHAR(100) , @LogINTime DATETIME , @IsBlocked VARCHAR(100) , @Count int
	
	IF (@PlayerID IN (SELECT [PlayerID]				
				FROM [dbo].[PlayerDetails])
					AND @Pass IN (SELECT [Password]
																					FROM [dbo].[PlayerDetails]))
	BEGIN
		SET @Status = 'Connected'
		SET @LogINTime = GETUTCDATE()
		SET @IsBlocked = 'No'
		SET @Count = 0
				IF @PlayerID NOT IN (SELECT [PlayerID] FROM [dbo].[Log])
					INSERT INTO Log (PlayerID , LogStatus , LogInTime , Blocked , NumberofFailedlogintries)
	   				VALUES (@PlayerID , @STATUS , @LogINTime , @IsBlocked , @Count )
				ELSE
			  		UPDATE Log  SET [NumberofFailedlogintries] = @Count WHERE PlayerID = @PlayerID
					UPDATE Log
						SET [PlayerID] = @PlayerID , LogStatus = @STATUS , LogInTime = @LogINTime , Blocked = @IsBlocked
						WHERE @PlayerID IN (SELECT PlayerID FROM [dbo].[Log])
	END

		IF (@PlayerID IN (SELECT [PlayerID]				
				  	FROM [dbo].[PlayerDetails])
						AND @Pass NOT IN (SELECT [Password]
																					FROM [dbo].[PlayerDetails]))
	BEGIN
		SET @Status = 'Disconnected'
		SET @LogINTime = 0000-00-00
		SET @IsBlocked = 'No'
		SET @Count = 1

				IF @PlayerID NOT IN (SELECT [PlayerID] FROM [dbo].[Log])
					INSERT INTO Log (PlayerID , LogStatus , LogInTime , Blocked  , NumberofFailedlogintries)
	   				VALUES (@PlayerID , @STATUS , @LogINTime , @IsBlocked , @Count)
				ELSE
					UPDATE Log  SET [NumberofFailedlogintries] += @Count WHERE PlayerID = @PlayerID
					UPDATE Log
						SET [PlayerID] = @PlayerID , LogStatus = @STATUS , LogInTime = @LogINTime , Blocked = @IsBlocked
						WHERE @PlayerID IN (SELECT [PlayerID] FROM [dbo].[Log])

	END

	IF (SELECT NumberofFailedlogintries FROM Log WHERE PlayerID = @PlayerID) > 4 
	UPDATE Log
	SET Blocked = 'Yes'
	WHERE PlayerID = @PlayerID
	
END
GO


