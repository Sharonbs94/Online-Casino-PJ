



CREATE PROC sp_UpdateGameStatTable @Sp_GameID INT
AS
BEGIN
	IF @Sp_GameID IN (SELECT GameID FROM GameStat)
	BEGIN
		UPDATE GameStat
		SET GameID = @Sp_GameID


		UPDATE GameStat
		SET NumOfRounds = (SELECT SUM(RoundID) 
								FROM GameHistory 
								WHERE GameID = @Sp_GameID AND Date BETWEEN GETDATE()-7 AND GETDATE())
		
		UPDATE GameStat
		SET TotalBetAmount = (SELECT SUM(BetAmount) 
									FROM GameHistory 
									WHERE GameID = @Sp_GameID AND Date BETWEEN GETDATE()-7 AND GETDATE())

		UPDATE GameStat
		SET WinsNO = (SELECT COUNT(RoundResult) 
									FROM GameHistory 
									WHERE GameID = @Sp_GameID AND Date BETWEEN GETDATE()-7 AND GETDATE())
	END
	ELSE
	PRINT 'GameID dosent exsists in the system'
END

GO