CREATE PROCEDURE sp_HorseGame
@PlayerID INT,
@BetAmount MONEY,
@HorseNumberBet INT,
@MSG VARCHAR(100) OUTPUT
AS

BEGIN
IF @PlayerID IN (SELECT PlayerID FROM PlayerDetails)
	BEGIN

--- Checking a betting experience:
		DECLARE @CurrentBankroll MONEY = (SELECT TotalAmount FROM BankRoll WHERE PlayerID = @PlayerID)
			IF 
				@BetAmount <= @CurrentBankroll 
				BEGIN
					DECLARE		
						@Horse1Position AS TINYINT  = 0,
						@Horse2Position AS TINYINT  = 0,
						@Horse3Position AS TINYINT  = 0,
						@Horse4Position AS TINYINT  = 0,	
						@Horse5Position AS TINYINT  = 0,
						@MAXHorsePosition AS TINYINT  = 0,
						@MAXTrackPosition AS TINYINT  = 24,
						@MAXStepPerIteration AS TINYINT  =3,
						@Winner AS TINYINT ,
						@LineToPrint AS NVARCHAR(MAX);

					WHILE
						1 = 1
					BEGIN

----Visual:
						SET @LineToPrint = REPLICATE (N'_', @Horse1Position) + N'1' + REPLICATE (N'_', @MAXTrackPosition - @Horse1Position);
						RAISERROR (@LineToPrint, 0 ,1) WITH NOWAIT;

						SET @LineToPrint = REPLICATE (N'_', @Horse2Position) + N'2' + REPLICATE (N'_', @MAXTrackPosition - @Horse2Position);
						RAISERROR (@LineToPrint, 0 ,1) WITH NOWAIT;

						SET @LineToPrint = REPLICATE (N'_', @Horse3Position) + N'3' + REPLICATE (N'_', @MAXTrackPosition - @Horse3Position);
						RAISERROR (@LineToPrint, 0 ,1) WITH NOWAIT;

						SET @LineToPrint = REPLICATE (N'_', @Horse4Position) + N'4' + REPLICATE (N'_', @MAXTrackPosition - @Horse4Position);
						RAISERROR (@LineToPrint, 0 ,1) WITH NOWAIT;

						SET @LineToPrint = REPLICATE (N'_', @Horse5Position) + N'5' + REPLICATE (N'_', @MAXTrackPosition - @Horse5Position);
						RAISERROR (@LineToPrint, 0 ,1) WITH NOWAIT;

						RAISERROR (N'', 0 ,1) WITH NOWAIT;

						IF
							@MAXHorsePosition = @MAXTrackPosition
						BEGIN
		
							BREAK;

						END;

		---- HORSE 1:
						SET @Horse1Position += CAST ((RAND ()  * (@MAXStepPerIteration +1)) AS TINYINT) % (@MAXStepPerIteration + 1);

						IF 
							@Horse1Position > @MAXTrackPosition
						BEGIN

							SET @Horse1Position = @MAXTrackPosition;
						END;
						IF 
							@Horse1Position > @MAXHorsePosition
						BEGIN

							SET @MAXHorsePosition = @Horse1Position;
							SET @Winner = 1;
	
						END;

		---- HORSE 2:
						SET @Horse2Position += CAST ((RAND ()  * (@MAXStepPerIteration +1)) AS TINYINT) % (@MAXStepPerIteration + 1);

						IF 
							@Horse2Position > @MAXTrackPosition
						BEGIN

							SET @Horse2Position = @MAXTrackPosition;
						END;
						IF 
							@Horse2Position > @MAXHorsePosition
						BEGIN

							SET @MAXHorsePosition = @Horse2Position;
							SET @Winner = 2;
	
						END;

			---- HORSE 3:
						SET @Horse3Position += CAST ((RAND ()  * (@MAXStepPerIteration +1)) AS TINYINT) % (@MAXStepPerIteration + 1);

						IF 
							@Horse3Position > @MAXTrackPosition
						BEGIN

							SET @Horse3Position = @MAXTrackPosition;
						END;
						IF 
							@Horse3Position > @MAXHorsePosition
						BEGIN

							SET @MAXHorsePosition = @Horse3Position;
							SET @Winner = 3;
	
						END;

				---- HORSE 4: 
						SET @Horse4Position += CAST ((RAND ()  * (@MAXStepPerIteration +1)) AS TINYINT) % (@MAXStepPerIteration + 1);

						IF 
							@Horse4Position > @MAXTrackPosition
						BEGIN

							SET @Horse4Position = @MAXTrackPosition;
						END;
						IF 
							@Horse4Position > @MAXHorsePosition
						BEGIN

							SET @MAXHorsePosition = @Horse4Position;
							SET @Winner = 4;
	
						END;

				---- HORSE 5:
						SET @Horse5Position += CAST ((RAND ()  * (@MAXStepPerIteration +1)) AS TINYINT) % (@MAXStepPerIteration + 1);

						IF 
							@Horse5Position > @MAXTrackPosition
						BEGIN

							SET @Horse5Position = @MAXTrackPosition;
						END;
						IF 
							@Horse5Position > @MAXHorsePosition
						BEGIN

							SET @MAXHorsePosition = @Horse5Position;
							SET @Winner = 5;
	
						END;

						WAITFOR DELAY '00:00:02';

					END;

					SET @LineToPrint = N'The winner is horse #' + CAST (@Winner AS NVARCHAR (MAX)) + N'!';
					PRINT @LineToPrint;

--- Win OR Lose Result:
						IF @HorseNumberBet = @Winner												-- WIN
						BEGIN
						UPDATE Bankroll SET TotalAmount = TotalAmount + @BetAmount WHERE PlayerID = @PlayerID
						SET @MSG = 'You are lucky!, You earned ' + CAST(@BetAmount as varchar)
						Declare @RndResultHorse VARCHAR (10) = 'Win'	
						END;

						ELSE
							BEGIN
							UPDATE Bankroll SET TotalAmount = TotalAmount - @BetAmount WHERE PlayerID = @PlayerID
							SET @MSG = 'You Didn''t Win This Round, You Lost' + CAST(@BetAmount as varchar) + 'In This Round!'
						SET @RndResultHorse = 'Lose'	
						INSERT INTO GameHistory (GameID, PlayerID,RoundResult ,BetAmount,DATE) VALUES (1, @PlayerID, @RndResultHorse,@BetAmount, GETDATE()) 

							 
-- Update Result To Game_History Table:
						--IF @RndResultHorse = 'Win' 
						--BEGIN
						--	INSERT INTO GameHistory (RoundResult,BetAmount,DATE) VALUES (@RndResultHorse,@BetAmount, GETDATE()) 
						--END; 
						--ELSE
						--	INSERT INTO GameHistory (RoundResult,BetAmount,DATE) VALUES ('Lose' , @BetAmount, GETDATE())				
					END;
				END;
			ELSE
				BEGIN
					SET @MSG = 'The bet amount is higher than your currenct bankroll. You are allowed to bet up to $' + @CurrentBankroll  + ' in this round'
				END;
	END;
ELSE
	SET @MSG = 'PlayerID: ' + CAST(@PlayerID as varchar) + ' Does Not Exist'	
END