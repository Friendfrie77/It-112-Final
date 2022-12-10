-- --------------------------------------------------------------------------------
-- Name: Albert Friend
-- Class: IT-112
-- Abstract: Final Project
-- --------------------------------------------------------------------------------

-- --------------------------------------------------------------------------------
-- Options
-- --------------------------------------------------------------------------------
USE dbSQL1;     -- Get out of the master database
SET NOCOUNT ON; -- Report only errors

-- --------------------------------------------------------------------------------
--						Problem #1
-- --------------------------------------------------------------------------------

-- --------------------------------------------------------------------------------
--	 Drop tables
-- --------------------------------------------------------------------------------

-- Drops for stored procedure
IF OBJECT_ID ( 'uspRandomizePatient' )					IS NOT NULL DROP PROCEDURE uspRandomizePatient
IF OBJECT_ID ( 'uspWithdrawPatient' )					IS NOT NULL DROP PROCEDURE uspWithdrawPatient
IF OBJECT_ID ( 'uspScreenPatient' )						IS NOT NULL DROP PROCEDURE uspScreenPatient
IF OBJECT_ID ( 'uspAddVist' )							IS NOT NULL DROP PROCEDURE uspAddVist
IF OBJECT_ID ( 'uspAddPatient' )						IS NOT NULL DROP PROCEDURE uspAddPatient

-- Drops Functions
IF OBJECT_ID ( 'fn_GetNextTreatment' )					IS NOT NULL DROP FUNCTION fn_GetNextTreatment
IF OBJECT_ID ( 'fn_GetRandomNumber' )					IS NOT NULL DROP FUNCTION fn_GetRandomNumber

-- Drops for views
IF OBJECT_ID( 'VRandomNumber' )							IS NOT NULL DROP VIEW VRandomNumber
IF OBJECT_ID( 'VWithdrawnPatients' )					IS NOT NULL DROP VIEW VWithdrawnPatients
IF OBJECT_ID( 'VDrugKitsAvailable' )					IS NOT NULL DROP VIEW VDrugKitsAvailable
IF OBJECT_ID( 'VRandomCodeStudy2' )						IS NOT NULL DROP VIEW VRandomCodeStudy2
IF OBJECT_ID( 'VRandomCodeStudy1' )						IS NOT NULL DROP VIEW VRandomCodeStudy1
IF OBJECT_ID( 'VRandomizedPatients' )					IS NOT NULL DROP VIEW VRandomizedPatients
IF OBJECT_ID( 'VVist' )									IS NOT NULL DROP VIEW VVist
IF OBJECT_ID( 'VAllPatients' )							IS NOT NULL DROP VIEW VAllPatients

-- Drops for tables
IF OBJECT_ID( 'TDrugKits' )								IS NOT NULL DROP TABLE TDrugKits
IF OBJECT_ID( 'TVisits' )								IS NOT NULL DROP TABLE TVisits
IF OBJECT_ID( 'TPatients' )								IS NOT NULL DROP TABLE TPatients
IF OBJECT_ID( 'TRandomCodes' )							IS NOT NULL DROP TABLE TRandomCodes
IF OBJECT_ID( 'TSites' )								IS NOT NULL DROP TABLE TSites
IF OBJECT_ID( 'TStudies' )								IS NOT NULL DROP TABLE TStudies
IF OBJECT_ID( 'TVistTypes' )							IS NOT NULL DROP TABLE TVistTypes
IF OBJECT_ID( 'TWithdrawReasons' )						IS NOT NULL DROP TABLE TWithdrawReasons
IF OBJECT_ID( 'TGenders' )								IS NOT NULL DROP TABLE TGenders
IF OBJECT_ID( 'TStates' )								IS NOT NULL DROP TABLE TStates
-- --------------------------------------------------------------------------------
--	Create table 
-- --------------------------------------------------------------------------------
CREATE TABLE TGenders(
	intGenderID		INTEGER			NOT NULL,
	strGender		VARCHAR(25)		NOT NULL,
	CONSTRAINT TGenders_PK PRIMARY KEY (intGenderID)
)

CREATE TABLE TStates(
	intStateID		INTEGER			NOT NULL,
	strStateDesc	VARCHAR(25)		NOT NULL,
	CONSTRAINT TStates_PK PRIMARY KEY (intStateID)
)

CREATE TABLE TWithdrawReasons(
	intWithdrawReasonID		INTEGER			NOT NULL,
	strWithdrawDesc			VARCHAR(250)	NOT NULL,
	CONSTRAINT TWithdrawReasons_PK PRIMARY KEY (intWithdrawReasonID)
)

CREATE TABLE TVistTypes(
	intVisitTypeID		INTEGER			NOT NULL,
	strVistDesc			VARCHAR(250)	NOT NULL,
	CONSTRAINT TVistTypes_PK PRIMARY KEY (intVisitTypeID)
)

CREATE TABLE TStudies(
	intStudyID		INTEGER			NOT NULL,
	strSudyDesc		VARCHAR(250)	NOT NULL,
	CONSTRAINT TStudies_PK PRIMARY KEY (intStudyID)
)

CREATE TABLE TSites(
	intSiteID		INTEGER			NOT NULL,
	intSiteNumber	INTEGER			NOT NULL,
	intStudyID		INTEGER			NOT NULL,
	strName			VARCHAR(250)	NOT NULL,
	strAddress		VARCHAR(250)	NOT NULL,
	strCity			VARCHAR(250)	NOT NULL,
	intStateID		INTEGER			NOT NULL,
	strZip			VARCHAR(250)	NOT NULL,
	strPhone		VARCHAR(250)	NOT NULL,
	CONSTRAINT TSites_PK PRIMARY KEY (intSiteID),

)

CREATE TABLE TRandomCodes(
	intRandomCodeID		INTEGER			NOT NULL,
	intRandomCode		INTEGER			NOT NULL,
	intStudyID			INTEGER			NOT NULL,
	strTreatment		VARCHAR(250)	NOT NULL,
	blnAvailable		VARCHAR(250)	NOT NULL,
	CONSTRAINT TRandomCodes_PK PRIMARY KEY (intRandomCodeID)
)

CREATE TABLE TPatients(
	intPatientID		INTEGER IDENTITY NOT NULL,
	intPatientNumber	INTEGER			 NOT NULL,
	intSiteID			INTEGER			 NOT NULL,
	dtmDOB				DATETIME		 NOT NULL,
	intGenderID			INTEGER			 NOT NULL,
	intWeight			INTEGER			 NOT NULL,
	intRandomCodeID		INTEGER					,
	CONSTRAINT TPatients_PK PRIMARY KEY (intPatientID)
)

CREATE TABLE TVisits(
	intVisitID				INTEGER IDENTITY	NOT NULL,
	intPatientID			INTEGER				NOT NULL,
	dtmVisit				DATETIME			NOT NULL,
	intVisitTypeID			INTEGER				NOT NULL,
	intWithdrawReasonID		INTEGER						,
	CONSTRAINT TVisits_PK PRIMARY KEY (intVisitID)
)

CREATE TABLE TDrugKits(
	intDrugKitID			INTEGER			NOT NULL,
	intDrugKitNumber		INTEGER			NOT NULL,
	intSiteID				INTEGER			NOT NULL,
	strTreatment			VARCHAR(250)	NOT NULL,
	intVisitID				INTEGER					,
	CONSTRAINT TDrugKits_PK PRIMARY KEY (intDrugKitID)
)
-- --------------------------------------------------------------------------------
-- Identify and Create Foreign Keys
-- --------------------------------------------------------------------------------
--
-- #	Child								Parent						Column(s)
-- -	-----								------						---------
-- 1	TSites								TStudies					intStudyID
-- 2	TSites								TStates						intStateID
-- 3	TRandomCodes						TStudies					intStudyID
-- 4	TPatients							TSites						intSiteID
-- 5	TPatients							TGenders					intGenderID
-- 6	TPatients							TRandomCodes				intRandomCodeID
-- 7	TVisits								TPatients					intPatientID
-- 8	TVisits								TVistTypes					intVisitTypeID
-- 9	TVisits								TWithdrawReasons			intWithdrawReasonID
-- 10	TDrugKits							TSites						intSiteID
-- 11	TDrugKits							TVisits						intVisitID

-- 1
ALTER TABLE TSites ADD CONSTRAINT TSites_TStudies_FK
FOREIGN KEY ( intStudyID ) REFERENCES TStudies ( intStudyID )

-- 2
ALTER TABLE TSites ADD CONSTRAINT TSites_TStates_FK
FOREIGN KEY ( intStateID ) REFERENCES TStates ( intStateID )

-- 3
ALTER TABLE TRandomCodes ADD CONSTRAINT TRandomCodes_TStudies_FK
FOREIGN KEY ( intStudyID ) REFERENCES TStudies ( intStudyID )

-- 4
ALTER TABLE TPatients ADD CONSTRAINT TPatients_TSites_FK
FOREIGN KEY ( intSiteID ) REFERENCES TSites ( intSiteID )

-- 5
ALTER TABLE TPatients ADD CONSTRAINT TPatients_TGenders_FK
FOREIGN KEY ( intGenderID ) REFERENCES TGenders ( intGenderID )

-- 6
ALTER TABLE TPatients ADD CONSTRAINT TPatients_TRandomCodes_FK
FOREIGN KEY ( intRandomCodeID ) REFERENCES TRandomCodes ( intRandomCodeID )

-- 7
ALTER TABLE TVisits ADD CONSTRAINT TVisits_TPatients_FK
FOREIGN KEY ( intPatientID ) REFERENCES TPatients ( intPatientID )

-- 8
ALTER TABLE TVisits ADD CONSTRAINT TVisits_TVistTypes_FK
FOREIGN KEY ( intVisitTypeID ) REFERENCES TVistTypes ( intVisitTypeID )

-- 9
ALTER TABLE TVisits ADD CONSTRAINT TVisits_TWithdrawReasons_FK
FOREIGN KEY ( intWithdrawReasonID ) REFERENCES TWithdrawReasons ( intWithdrawReasonID )

-- 10
ALTER TABLE TDrugKits ADD CONSTRAINT TDrugKits_TSites_FK
FOREIGN KEY ( intSiteID ) REFERENCES TSites ( intSiteID )

-- 11
ALTER TABLE TDrugKits ADD CONSTRAINT TDrugKits_TVisits_FK
FOREIGN KEY ( intVisitID ) REFERENCES TVisits ( intVisitID )

-- --------------------------------------------------------------------------------
--	Add Sample Data - INSERTS
-- --------------------------------------------------------------------------------
INSERT INTO TGenders ( intGenderID, strGender )
VALUES		(1, 'Female'),
			(2, 'Male')

INSERT INTO TStates ( intStateID, strStateDesc )
VALUES		(1, 'Ohio'),
			(2, 'Kentucky'),
			(3, 'Indiana'),
			(4, 'New Jersey'),
			(5, 'Virginia'),
			(6, 'Georgia'),
			(7, 'Iowa')

INSERT INTO TWithdrawReasons ( intWithdrawReasonID, strWithdrawDesc )
VALUES		(1, 'Patient withdrew consent'),
			(2, 'Adverse event'),
			(3, 'Health issue-related to study'),
			(4, 'Health issue-unrelated to study'),
			(5, 'Personal reason'),
			(6, 'Completed the study')

INSERT INTO TVistTypes ( intVisitTypeID, strVistDesc)
VALUES		(1, 'Screening'),
			(2, 'Randomization'),
			(3, 'Withdrawal')

INSERT INTO TStudies ( intStudyID, strSudyDesc)
VALUES		(1, 'Study 12345'),
			(2, 'Study 54321')

INSERT INTO TSites ( intSiteID, intSiteNumber, intStudyID, strName, strAddress, strCity, intStateID, strZip, strPhone)
VALUES		(1, 101, 1, 'Dr. Stan Heinrich', '123 E. Main St', 'Atlanta', 6, '25869', '1234567890'),
			(2, 111, 1, 'Mercy Hospital', '3456 Elmhurst Rd.', 'Secaucus', 4, '32659', '5013629564'),
			(3, 121, 1, 'St. Elizabeth Hospital', '976 Jackson Way', 'Ft. Thomas', 2, '41258', '3026521478'),
			(4, 501, 2, 'Dr. Robert Adler', '9087 W. Maple Ave.', 'Cedar Rapids', 7, '42365', '6149652574'),
			(5, 511, 2, 'Dr. Tim Schmitz', '4539 Helena Run', 'Mason', 1, '45040', '5136987462'),
			(6, 521, 2, 'Dr. Lawrence Snell', '9201 NW. Washington Blvd.', 'Bristol', 5, '20163', '3876510249')

INSERT INTO TRandomCodes (intRandomCodeID, intRandomCode, intStudyID, strTreatment, blnAvailable)
VALUES		(1, 1000, 1, 'A', 'T'),
			(2, 1001, 1, 'P', 'T'),
			(3, 1002, 1, 'A', 'T'),
			(4, 1003, 1, 'P', 'T'),
			(5, 1004, 1, 'P', 'T'),
			(6, 1005, 1, 'A', 'T'),
			(7, 1006, 1, 'A', 'T'),
			(8, 1007, 1, 'P', 'T'),
			(9, 1008, 1, 'A', 'T'),
			(10, 1009, 1, 'P', 'T'),
			(11, 1010, 1, 'P', 'T'),
			(12, 1011, 1, 'A', 'T'),
			(13, 1012, 1, 'P', 'T'),
			(14, 1013, 1, 'A', 'T'),
			(15, 1014, 1, 'A', 'T'),
			(16, 1015, 1, 'A', 'T'),
			(17, 1016, 1, 'P', 'T'),
			(18, 1017, 1, 'P', 'T'),
			(19, 1018, 1, 'A', 'T'),
			(20, 1019, 1, 'P', 'T'),
			(21, 5000, 2, 'A', 'T'),
			(22, 5001, 2, 'A', 'T'),
			(23, 5002, 2, 'A', 'T'),
			(24, 5003, 2, 'A', 'T'),
			(25, 5004, 2, 'A', 'T'),
			(26, 5005, 2, 'A', 'T'),
			(27, 5006, 2, 'A', 'T'),
			(28, 5007, 2, 'A', 'T'),
			(29, 5008, 2, 'A', 'T'),
			(30, 5009, 2, 'A', 'T'),
			(31, 5010, 2, 'P', 'T'),
			(32, 5011, 2, 'P', 'T'),
			(33, 5012, 2, 'P', 'T'),
			(34, 5013, 2, 'P', 'T'),
			(35, 5014, 2, 'P', 'T'),
			(36, 5015, 2, 'P', 'T'),
			(37, 5016, 2, 'P', 'T'),
			(38, 5017, 2, 'P', 'T'),
			(39, 5018, 2, 'P', 'T'),
			(40, 5019, 2, 'P', 'T')

--INSERT INTO TVisits (intVisitID, intPatientID, dtmVisit, intVisitTypeID, intWithdrawReasonID)
--VALUES		(1, 1, '3/20/2022', 1, NULL),
--			(2, 1, (SELECT CONVERT(varchar, getdate(), 1)), 2, NULL),
--			(3, 2, '9/20/2022', 1, NULL),
--			(4, 2, '10/20/2022', 2, NULL),
--			(5, 2, (SELECT CONVERT(varchar, getdate(), 1)), 3, 5),
--			(6, 3, '10/21/2022', 1, NULL),
--			(7, 3, (SELECT CONVERT(varchar, getdate(), 1)), 2, NULL),
--			(8, 4, '10/30/2022', 1, NULL),
--			(9, 4, (SELECT CONVERT(varchar, getdate(), 1)), 2, NULL),
--			(10, 5, '9/20/2022', 1, NULL)

INSERT INTO TDrugKits (intDrugKitID, intDrugKitNumber, intSiteID, strTreatment, intVisitID)
VALUES		( 1, 10000, 1, 'A', NULL),
			( 2, 10001, 1, 'A', Null),
			( 3, 10002, 1, 'A', Null),
			( 4, 10003, 1, 'P', Null),
			( 5, 10004, 1, 'P', Null),
			( 6, 10005, 1, 'P', Null),
			( 7, 10006, 2, 'A', Null),
			( 8, 10007, 2, 'A', Null),
			( 9, 10008, 2, 'A', Null),
			(10, 10009, 2, 'P', Null),
			(11, 10010, 2, 'P', Null),
			(12, 10011, 2, 'P', Null),
			(13, 10012, 3, 'A', Null),
			(14, 10013, 3, 'A', Null),
			(15, 10014, 3, 'A', Null),
			(16, 10015, 3, 'P', Null),
			(17, 10016, 3, 'P', Null),
			(18, 10017, 3, 'P', Null),
			(19, 10018, 4, 'A', Null),
			(20, 10019, 4, 'A', Null),
			(21, 10020, 4, 'A', Null),
			(22, 10021, 4, 'P', Null),
			(23, 10022, 4, 'P', Null),
			(24, 10023, 4, 'P', Null),
			(25, 10024, 5, 'A', Null),
			(26, 10025, 5, 'A', Null),
			(27, 10026, 5, 'A', Null),
			(28, 10027, 5, 'P', Null),
			(29, 10028, 5, 'P', Null),
			(30, 10029, 5, 'P', Null),
			(31, 10030, 6, 'A', Null),
			(32, 10031, 6, 'A', Null),
			(33, 10032, 6, 'A', Null),
			(34, 10033, 6, 'P', Null),
			(35, 10034, 6, 'P', Null),
			(36, 10035, 6, 'P', Null)

-- --------------------------------------------------------------------------------
-- Views and functions: Steps 2-7
-----------------------------------------------------------------------------------

 --Step 2: View that shows all patients at all sites for both studies
GO
CREATE VIEW VAllPatients
AS
SELECT
	TP.intPatientID,
	TS.strName as 'Doctor/Site Name',
	TS.intStudyID as 'Site Study',
	TP.intSiteID,
	TP.intPatientNumber,
	TP.dtmDOB as 'Date of Birth',
	TG.strGender as 'Gender',
	TP.intWeight, 
	TP.intRandomCodeID
FROM
	((TPatients as TP JOIN TSites as TS ON TP.intSiteID = TS.intSiteID)
	  JOIN TGenders as TG ON TP.intGenderID = TG.intGenderID)
GO

 --Step 3: View to show all radomized patients, their site and their treatment
GO
CREATE VIEW VRandomizedPatients
AS
SELECT
	TP.intPatientID,
	TS.strName as 'Doctor/Site Name',
	TP.intSiteID,
	TP.intPatientNumber,
	TS.intStudyID,
	TST.strSudyDesc,
	TP.intRandomCodeID,
	TRC.strTreatment as 'Treatment Type',
	TP.dtmDOB as 'Date of Birth',
	TG.strGender as 'Gender',
	TP.intWeight as 'Weight'

FROM
	(((((TPatients as TP JOIN TVisits as TV ON TP.intPatientID = TV.intPatientID)
		 LEFT JOIN TRandomCodes as TRC ON TP.intRandomCodeID = TRC.intRandomCodeID)
		 JOIN TGenders as TG ON TP.intGenderID = TG.intGenderID)
		 JOIN TSites as TS ON TP.intSiteID = TS.intSiteID)
		 JOIN TStudies TST on TS.intStudyID = TST.intStudyID)
WHERE
	TV.intVisitTypeID = 2
GO


-- Step 4.1: View for next Random Code for study 1.
GO
CREATE VIEW VRandomCodeStudy1
AS
SELECT
	TOP 1
	intRandomCodeID as 'Random Code ID',
	intRandomCode as 'Random Code',
	strTreatment as 'Treatment type'
FROM
	TRandomCodes
WHERE
	intStudyID = 1
AND blnAvailable = 'T'
GO

-- Step 4.2: View for next Random Code for study 2.
GO
CREATE VIEW VRandomCodeStudy2
AS
SELECT
	MIN(intRandomCodeID) as 'Random Code ID',
	MIN(intRandomCode) as 'Random Code',
	strTreatment as 'Treatment type'
FROM
	TRandomCodes
WHERE
	intStudyID = 2
AND blnAvailable = 'T'
GROUP BY
	strTreatment
GO

-- Step 5 Create View showing all drugs at all sties for both studies

GO
CREATE VIEW VDrugKitsAvailable
AS
SELECT
	TS.intSiteID,
	TS.intSiteNumber,
	TS.strName as 'Doctor/Site Name',
	TS.strAddress + ' ' + TS.strCity + ' ' + TSTA.strStateDesc + ' ' + Ts.strZip as 'Location',
	TS.strPhone as 'Site Contact number',
	TD.intDrugKitID as 'Drug Kit ID',
	TD.intDrugKitNumber as 'Drug Kit Number',
	TD.strTreatment as 'Treatement Type',
	TS.intStudyID
FROM
	((TDrugKits as TD JOIN TSites as TS ON TD.intSiteID = TS.intSiteID)
	  JOIN TStates as TSTA ON Ts.intStateID = TSTA.intStateID)
	  
WHERE
	TD.intVisitID IS NULL 
GO

-- Step 6 Create View showing all withdrawn patients, their sites, withdrawl date and reason

GO
CREATE VIEW VWithdrawnPatients
AS
SELECT
	TP.intPatientID as 'Patient ID',
	TG.strGender as 'Patient Gender',
	TS.intSiteID 'Site Id',
	TS.strName as 'Doctor/Site Name',
	TS.strAddress + ' ' + TS.strCity + ' ' + TSTA.strStateDesc + ' ' + Ts.strZip as 'Location',
	TS.strPhone as 'Site Contact number',
	TS.intStudyID,
	TST.strSudyDesc,
	TV.dtmVisit as 'Date of Withdrawn',
	TV.intWithdrawReasonID as 'Withdraw ID', 
	TW.strWithdrawDesc as 'Withdraw Reason'
FROM
	((((((TVisits as TV JOIN TPatients as TP ON TV.intPatientID = TP.intPatientID)
	      JOIN TWithdrawReasons as TW ON TV.intWithdrawReasonID = TW.intWithdrawReasonID)
	      JOIN TSites as TS ON TP.intSiteID = TS.intSiteID)
		  JOIN TGenders as TG ON TP.intGenderID = TG.intGenderID)
		  JOIN TStudies as TST ON TS.intStudyID = TST.intStudyID)
		  JOIN TStates as TSTA ON TS.intStateID = TSTA.intStateID)
WHERE
	TV.intVisitTypeID = 3
GO



-- Step 7.1 Adding Patients to TPatients
Go
CREATE PROCEDURE uspAddPatient
	@intPatientNumber	AS INTEGER,
	@intSiteID			AS INTEGER,
	@dtmDOB				AS DATETIME,
	@intGenderID		AS INTEGER,
	@intWeight			AS INTEGER,
	@intRandomCodeID    AS INTEGER = NULL
AS
SET XACT_ABORT ON
BEGIN TRANSACTION
		
		INSERT INTO TPatients (intPatientNumber, intSiteID, dtmDOB, intGenderID, intWeight, intRandomCodeID)
		VALUES (@intPatientNumber, @intSiteID, @dtmDOB, @intGenderID, @intWeight, @intRandomCodeID)
COMMIT TRANSACTION
GO

-- Step 7.2 Adding in A patient vist to TVisits
GO
CREATE PROCEDURE uspAddVist
	@intPatientID			INTEGER,
	@dtmVisit				DATETIME,
	@intVisitTypeID			INTEGER,		
	@intWithdrawReasonID	INTEGER = NULL		
AS
SET XACT_ABORT ON	-- Terminate and rollback entire transaction on error
BEGIN TRANSACTION
	
	INSERT INTO TVisits (intPatientID, dtmVisit, intVisitTypeID, intWithdrawReasonID)
	VALUES	(@intPatientID, @dtmVisit, @intVisitTypeID, @intWithdrawReasonID)

COMMIT TRANSACTION
GO

-- Step 7.3.1 View for random number
GO
CREATE VIEW VRandomNumber
AS
SELECT RAND() AS random_value
GO

-- Step 7.3.2 Function for Study 2 Random number
GO
CREATE FUNCTION  fn_GetRandomNumber()
	RETURNS FLOAT
	AS
	BEGIN
		DECLARE @RandomNumber as FLOAT = (select random_value from VRandomNumber)
		RETURN @RandomNumber
	END

-- Step 7.4 View for vistes
GO
CREATE VIEW VVist
AS
SELECT
	intVisitID,
	intPatientID, 
	dtmVisit,
	intVisitTypeID,
	intWithdrawReasonID
FROM
	TVisits
GO

-- Step 7.5 Function for Study 2 treatment
GO
CREATE FUNCTION fn_GetNextTreatment()
	RETURNS INT
	AS
	BEGIN
		DECLARE @intRandomCodeID AS INT
		DECLARE @intACount AS INT
		DECLARE @RandomNum as FLOAT
		EXECUTE @RandomNum = fn_GetRandomNumber
		BEGIN
			DECLARE ACountCursor CURSOR LOCAL FOR
			SELECT COUNT(intRandomCodeID) FROM TRandomCodes
			WHERE intStudyID = 2
			AND strTreatment = 'A'
			AND blnAvailable = 'F'
			OPEN ACountCursor
			FETCH FROM ACountCursor
			INTO @intACount
			CLOSE ACountCursor
			DEALLOCATE ACountCursor
		END

		DECLARE @intPCount as INT
		BEGIN
			DECLARE PCountCursor CURSOR LOCAL FOR
			SELECT COUNT(intRandomCodeID) FROM TRandomCodes
			WHERE intStudyID = 2
			AND strTreatment = 'P'
			AND blnAvailable = 'F'
			OPEN PCountCursor
			FETCH FROM PCountCursor
			INTO @intPCount
			CLOSE PCountCursor
			DEALLOCATE PCountCursor
		END

		IF (@intACount -2) >= @intPCount
		BEGIN
			DECLARE StudyIdCursor CURSOR LOCAL FOR
			SELECT [Random Code ID] FROM VRandomCodeStudy2
			WHERE [Treatment type] = 'P'
			OPEN StudyIdCursor
			FETCH FROM StudyIdCursor
			INTO @intRandomCodeID
			CLOSE StudyIdCursor
			DEALLOCATE StudyIdCursor
		END
		ELSE
		BEGIN
			IF (@intPCount -2) >= @intACount
			BEGIN
				DECLARE StudyIdCursor CURSOR LOCAL FOR
				SELECT [Random Code ID] FROM VRandomCodeStudy2
				WHERE [Treatment type] = 'A'
				OPEN StudyIdCursor
				FETCH FROM StudyIdCursor
				INTO @intRandomCodeID
				CLOSE StudyIdCursor
				DEALLOCATE StudyIdCursor
			END
			ELSE
			BEGIN
				IF @RandomNum <= .5
				BEGIN
					DECLARE StudyIdCursor CURSOR LOCAL FOR
					SELECT [Random Code ID] FROM VRandomCodeStudy2
					WHERE [Treatment type] = 'P'
					OPEN StudyIdCursor
					FETCH FROM StudyIdCursor
					INTO @intRandomCodeID
					CLOSE StudyIdCursor
					DEALLOCATE StudyIdCursor
				END
				ELSE
				BEGIN
					IF @RandomNum > .5
					BEGIN
						DECLARE StudyIdCursor CURSOR LOCAL FOR
						SELECT [Random Code ID] FROM VRandomCodeStudy2
						WHERE [Treatment type] = 'A'
						OPEN StudyIdCursor
						FETCH FROM StudyIdCursor
						INTO @intRandomCodeID
						CLOSE StudyIdCursor
						DEALLOCATE StudyIdCursor
					END
				END
			END
		END
		RETURN @intRandomCodeID
	END
GO

-----------------------------------------------------------------------------------------------------------
-- Steps 8 - 10 Stored procedures
-----------------------------------------------------------------------------------------------------------

-- Step 8 Stored procedure for screening a patient for both studies
GO 
CREATE PROCEDURE uspScreenPatient
	@intPatientNumber		AS INTEGER,
	@intSiteID				AS INTEGER,
	@intGenderID			AS INTEGER,
	@dtmDOB					AS DATETIME,
	@intWeight				AS INTEGER,
	@dtmVisit				AS	DATETIME,
	@intVisitTypeID			AS	INTEGER,		
	@intWithdrawReasonID	AS	INTEGER = NULL	
AS
SET NOCOUNT ON		
SET XACT_ABORT ON	
BEGIN TRANSACTION


	EXECUTE uspAddPatient  @intPatientNumber, @intSiteID, @dtmDOB, @intGenderID, @intWeight
	DECLARE @intPatientID as INTEGER  = (SELECT Max (intPatientID) FROM VAllPatients)
	EXECUTE uspAddVist @intPatientID, @dtmVisit, @intVisitTypeID , @intWithdrawReasonID

COMMIT TRANSACTION
GO

-- Step 9 Withdraw from Study
Go
CREATE PROCEDURE uspWithdrawPatient
	@intPatientID			as INTEGER,
	@dtmVisit				as DATETIME,
	@intWithdrawReasonID	as INTEGER
AS
SET NOCOUNT ON		
SET XACT_ABORT ON	
BEGIN TRANSACTION
	--DECLARE @intVistID as INT

	--BEGIN
	--		DECLARE VistID CURSOR LOCAL FOR
	--		SELECT intVisitID FROM VVist
	--		WHERE intPatientID = @intPatientID
	--		OPEN VistID
	--		FETCH FROM VistID
	--		INTO @intVistID
	--	END

	EXECUTE uspAddVist @intPatientID, @dtmVisit, 3, @intWithdrawReasonID

COMMIT TRANSACTION
GO
--EXECUTE uspScreenPatient 111002, 2, 1, '1/1/1993', 162, '5/20/2022', 1
----EXECUTE uspWithdrawPatient 5, '1/1/2023', 6
--EXECUTE uspScreenPatient 111002, 2, 1, '1/1/1993', 162, '5/20/2022', 1
--EXECUTE uspRandomizePatient 5
--			SELECT intVisitID FROM VVist
--			WHERE intPatientID = 5
--			AND intVisitTypeID = 2
--			SELECT * FROM VVist where intPatientID = 5
-- Step 10 Randomize patient from both studies
Go
CREATE PROCEDURE uspRandomizePatient
	@intPatientID as INTEGER
AS
SET NOCOUNT ON		
SET XACT_ABORT ON	
BEGIN TRANSACTION

	DECLARE @dtmVisit as DATETIME = (SELECT CONVERT(varchar, getdate(), 1))
	EXECUTE uspAddVist @intPatientID, @dtmVisit, 2

	DECLARE @intVistID as INT
	DECLARE @intStudyID AS INT
	DECLARE @DrugKitID as INT
	DECLARE @strTreatmentType as VARCHAR(25)
	DECLARE @intSiteID as INT

		BEGIN
			DECLARE StudyCursor CURSOR LOCAL FOR
			SELECT [Site Study] FROM VAllPatients
			WHERE intPatientID = @intPatientID
			OPEN StudyCursor
			FETCH FROM StudyCursor
			INTO @intStudyID	
		END

		BEGIN
			DECLARE SiteCursor CURSOR LOCAL FOR
			SELECT intSiteID FROM VAllPatients
			WHERE intPatientID = @intPatientID
			OPEN SiteCursor
			FETCH FROM SiteCursor
			INTO @intSiteID
		END

		IF @intStudyID = 1
		BEGIN
			DECLARE @intStudy1Code as INT
			BEGIN
				DECLARE CodeCursor CURSOR LOCAL FOR
				SELECT [Random Code ID] FROM VRandomCodeStudy1
				OPEN CodeCursor
				FETCH FROM CodeCursor
				INTO @intStudy1Code
			END
			
			BEGIN
				DECLARE TreatmentCursor CURSOR LOCAL FOR
				SELECT [Treatment type] FROM VRandomCodeStudy1
				WHERE [Random Code ID] = @intStudy1Code
				OPEN TreatmentCursor
				FETCH FROM TreatmentCursor
				INTO @strTreatmentType
			END

			BEGIN
				DECLARE Drugkit CURSOR LOCAL FOR
				SELECT [Drug Kit ID] FROM VDrugKitsAvailable
				WHERE intStudyID = @intStudyID
				AND [Treatement Type] = @strTreatmentType
				AND intSiteID = @intSiteID
				OPEN Drugkit
				FETCH FROM Drugkit
				INTO @DrugKitID
			END
		
			BEGIN
				DECLARE VistCursor CURSOR LOCAL FOR
				SELECT intVisitID FROM VVist
				WHERE intPatientID = @intPatientID
				AND intVisitTypeID = 2 
				OPEN VistCursor
				FETCH FROM VistCursor
				INTO @intVistID
			END

			UPDATE
				TDrugKits
			SET 
				intVisitID = @intVistID
			WHERE strTreatment = @strTreatmentType
			AND  intDrugKitID = @DrugKitID
						
			UPDATE 
				TPatients
			SET
				intRandomCodeID = @intStudy1Code
			WHERE
				intPatientID = @intPatientID

			DECLARE @intDrugKit as INT

			UPDATE
				TRandomCodes
			SET
				blnAvailable = 'F'
			WHERE
				intRandomCodeID = @intStudy1Code
		END

		IF @intStudyID = 2
		BEGIN
			DECLARE @intStudy2Code as INT
			EXECUTE @intStudy2Code = fn_GetNextTreatment

			BEGIN
				DECLARE TreatmentCursor CURSOR LOCAL FOR
				SELECT [Treatment type] FROM VRandomCodeStudy2 
				where [Random Code ID] = @intStudy2Code
				OPEN TreatmentCursor
				FETCH FROM TreatmentCursor
				INTO @strTreatmentType
			END

			BEGIN
				DECLARE VistCursor CURSOR LOCAL FOR
				SELECT intVisitID FROM VVist
				WHERE intPatientID = @intPatientID
				AND intVisitTypeID = 2 
				OPEN VistCursor
				FETCH FROM VistCursor
				INTO @intVistID
			END

			BEGIN
				DECLARE Drugkit CURSOR LOCAL FOR
				SELECT [Drug Kit ID] FROM VDrugKitsAvailable
				WHERE intStudyID = @intStudyID
				AND [Treatement Type] = @strTreatmentType
				and intSiteID = @intSiteID
				OPEN Drugkit
				FETCH FROM Drugkit
				INTO @DrugKitID
			END

			UPDATE
				TPatients
			SET
				intRandomCodeID = @intStudy2Code
			WHERE
				intPatientID = @intPatientID

			UPDATE
				TRandomCodes
			SET
				blnAvailable = 'F'
			WHERE
				intRandomCodeID = @intStudy2Code

			UPDATE
				TDrugKits
			SET 
				intVisitID = @intVistID
			WHERE
				 intSiteID = @intSiteID
			AND  strTreatment = @strTreatmentType
			AND  intDrugKitID = @DrugKitID

		END
COMMIT TRANSACTION
GO

