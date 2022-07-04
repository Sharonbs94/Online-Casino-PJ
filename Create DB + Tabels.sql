USE master
GO

IF NOT EXISTS(
	SELECT[name]
	FROM sys.databases
	WHERE [name] = 'OnlineCasinoPJ'
)

CREATE DATABASE OnlineCasinoPJ;
GO

USE OnlineCasinoPJ;
GO

---Create Tables---

CREATE TABLE Employees(
	EmployeeID int IDENTITY (1,1) NOT NULL PRIMARY KEY,
	First_Name VARCHAR (50) NOT NULL,
	Last_Name VARCHAR (50) NOT NULL,
	Job_Title VARCHAR (30) NOT NULL,
	Email VARCHAR (100) NOT NULL,
	Phone VARCHAR (30) NOT NULL,
	Address VARCHAR (100) NOT NULL ,
	City VARCHAR (50),
	Country VARCHAR (50),
	HireDate DATETIME NOT NULL,
	BirthDate DATETIME,
);
GO

CREATE TABLE PlayerDetails ( 
	PlayerID int IDENTITY (1,1) NOT NULL PRIMARY KEY,
	Password VARCHAR (100) NOT NULL,
	FirstName VARCHAR (50) NOT NULL,
	LastName VARCHAR (50) NOT NULL,
	AddressPl VARCHAR (100) NOT NULL,
	Email VARCHAR (100) NOT NULL,
	Country VARCHAR (50),
	Gender VARCHAR (10),
	BirthDate DATETIME 
);
GO

CREATE TABLE Support (
	AlertID int IDENTITY (1,1) NOT NULL PRIMARY KEY,
	EmployeeID int NOT NULL FOREIGN KEY REFERENCES Employees(EmployeeID),
	PlayerID int NOT NULL FOREIGN KEY REFERENCES PlayerDetails(PlayerID),
	Status VARCHAR (50),
	AlertCase VARCHAR (50),
	AlertDate DATETIME
);
GO


CREATE TABLE BankRoll (
	TransactionID int IDENTITY (1,1) NOT NULL PRIMARY KEY,
	TransactionType VARCHAR (50) NOT NULL , 
	TransactionDate DATETIME , 
	PlayerID int NOT NULL FOREIGN KEY REFERENCES PlayerDetails(PlayerID),
	TotalAmount money NULL , 
	TransactionAMT money NULL
);
GO


CREATE TABLE GameDetails (
	GameID int IDENTITY (1,1) NOT NULL PRIMARY KEY,
	GameName VARCHAR (100) NOT NULL,
	Description TEXT NOT NULL
);
GO

Create TABLE GameHistory (
	RoundID int IDENTITY (1,1) NOT NULL PRIMARY KEY,
	PlayerID int NOT NULL FOREIGN KEY REFERENCES PlayerDetails(PlayerID),
	GameID int NOT NULL FOREIGN KEY REFERENCES GameDetails(GameID),
	BetAmount money NULL,
	RoundResult VARCHAR (50) NOT NULL ,
	Date DATETIME
);
GO


--- Temporal Game History:

CREATE SCHEMA History;
GO

ALTER TABLE [dbo].[GameHistory]
    ADD
        ValidFrom DATETIME2 GENERATED ALWAYS AS ROW START HIDDEN
            CONSTRAINT DF_InsurancePolicy_ValidFrom DEFAULT SYSUTCDATETIME()
      , ValidTo DATETIME2 GENERATED ALWAYS AS ROW END HIDDEN
            CONSTRAINT DF_InsurancePolicy_ValidTo DEFAULT CONVERT(DATETIME2, '9999-12-31 23:59:59.9999999')
      , PERIOD FOR SYSTEM_TIME (ValidFrom, ValidTo);
GO

ALTER TABLE [dbo].[GameHistory]
    SET (SYSTEM_VERSIONING = ON (HISTORY_TABLE = History.InsurancePolicy));



CREATE TABLE GameStat (
	GameID int NOT NULL FOREIGN KEY REFERENCES GameDetails(GameID),
	Date DATETIME, 
	NumOfRounds bigint NULL,
	WinsNO bigint NULL,
	TotalBetAmount int NULL , 
	TotalWinsAmount int NULL
);
GO

CREATE TABLE Log (
PlayerID INT FOREIGN KEY REFERENCES PlayerDetails(PlayerID) ,
LogStatus VARCHAR(10) ,
LogInTime DATETIME , 
LogOutTime DATETIME , 
Blocked VARCHAR(10) , 
NumberofFailedlogintries INT
);
GO