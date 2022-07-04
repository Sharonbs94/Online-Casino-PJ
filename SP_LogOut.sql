





CREATE PROC sp_Logout @PlayerID VARCHAR(50) , @MSG VARCHAR(100) OUTPUT
AS
BEGIN
DECLARE @LOGOUT DATETIME
DECLARE @TIME DATETIME
DECLARE @STATUS VARCHAR(20)
		
		IF @PlayerID NOT IN (SELECT [PlayerID]				
									FROM [dbo].[PlayerDetails])
		BEGIN
			SET @MSG = 'Username Not Exists In The System'
			SET NOEXEC ON
		END
			ELSE
			SET @STATUS = 'Disconnected'
			SET @MSG = 'Good Bye :'
			SET @LOGOUT = GETUTCDATE()


			INSERT INTO [dbo].[Log]([PlayerID] , [LogStatus] , [LogOutTime])
			VALUES (@PlayerID ,@STATUS , @LOGOUT)
END
GO