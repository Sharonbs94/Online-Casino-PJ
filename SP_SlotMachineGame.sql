CREATE PROC sp_SlotMachineGAME 
@PlayerID INT,
@BetAmount MONEY,
@MSG VARCHAR(100) OUTPUT
AS

BEGIN
IF @PlayerID in (SELECT PlayerID FROM PlayerDetails)
	BEGIN
		--- Checking a betting experience:
		DECLARE @CurrentBankroll MONEY = (SELECT TotalAmount FROM BankRoll WHERE PlayerID = @PlayerID)
			IF 
				@BetAmount <= @CurrentBankroll 
				BEGIN
			--- Game Betting: 
					Declare 
						@Wheel1 INT = FLOOR(RAND() * 6 + 1),
						@Wheel2 INT = FLOOR(RAND() * 6 + 1),
						@Wheel3 INT = FLOOR(RAND() * 6 + 1)
							IF 
								@Wheel1 = @Wheel2 AND @Wheel1 = @Wheel3 AND @Wheel2 = @Wheel3 
								BEGIN
								UPDATE Bankroll  SET TotalAmount = TotalAmount + @BetAmount WHERE PlayerID = @PlayerID
								SET @MSG = 'You are lucky!, You earned ' + CAST(@BetAmount as varchar)
								DECLARE @RndResultSlot VARCHAR (10) = 'Win'
								END;
						
							ELSE
								BEGIN
									UPDATE Bankroll SET TotalAmount = TotalAmount - @BetAmount WHERE PlayerID = @PlayerID
									SET @MSG = 'You Didn''t Win This Round, You Lost' + CAST(@BetAmount as varchar) + 'In This Round!'
									SET @RndResultSlot = 'Lose'
	-- Update Result To Game_History Table:
								END;
						INSERT INTO GameHistory (GameID, PlayerID,RoundResult ,BetAmount,DATE) VALUES (1, @PlayerID, @RndResultSlot,@BetAmount, GETDATE()) 

				END;

			ELSE
				BEGIN
					SET @MSG = 'The bet amount is higher than your currenct bankroll. You are allowed to bet up to $' + CAST(@CurrentBankroll as varchar)+ ' in this round'
				END;
	END;
ELSE
	SET @MSG = 'PlayerID: ' + CAST(@PlayerID as varchar) + 'Does Not Exist'
END