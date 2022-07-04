



Create PROC sp_Register
@Username VARCHAR(100) , @Password VARCHAR (100) , @First_Name VARCHAR(50) , 
@Last_Name VARCHAR(50) , @Address VARCHAR(100) , @Country VARCHAR(100) , 
@Gender VARCHAR(100) , @Birthdate DATETIME
AS
BEGIN
DECLARE @a int
	SET @Password = [dbo].[PassValidation] (@Password)
	SELECT @Password
		IF @Password = 'Bad Password'
		BEGIN
			SET NOEXEC ON
		END
INSERT INTO PlayerDetails (Password, FirstName , LastName , AddressPl , Country , Gender , BirthDate)
     VALUES
           (@Password , 
           @First_Name ,
           @Last_Name ,
           @Address ,
           @Country ,
           @Gender ,
           @Birthdate )
END