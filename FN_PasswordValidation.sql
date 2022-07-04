


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


Create FUNCTION [dbo].[PassValidation] (@pass VARCHAR(50))
returns VARCHAR(50)
AS
BEGIN
DECLARE @msg VARCHAR (50) = 'Good Password'
DECLARE @msg1 VARCHAR (50) = 'Bad Password'
IF @pass LIKE '%[a-z]%' COLLATE Latin1_General_BIN
	IF @pass LIKE '%[A-Z]%' COLLATE Latin1_General_BIN
		IF @pass LIKE '%[0-9]%'
			IF @pass LIKE '_____%'
				IF @pass NOT LIKE '%p%a%s%s%w%o%r%d'
						return @msg

return @msg1
END