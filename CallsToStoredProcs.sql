---------------------------------------------------------------------------------------------------------------------
-- Step 11 Calls to stored procedures
---------------------------------------------------------------------------------------------------------------------
USE dbSQL1;
-- Step 11.1 Eight patients for screening per study 
EXECUTE uspScreenPatient 101001, 1, 2, '12/1/1960', 160, '4/5/2022', 1
EXECUTE uspScreenPatient 101002, 1, 1, '3/4/2000', 120, '3/30/2022', 1
EXECUTE uspScreenPatient 101003, 1, 2, '6/8/1990', 200, '4/8/2022', 1
EXECUTE uspScreenPatient 111001, 2, 1, '7/30/1994', 140, '5/15/2022', 1
EXECUTE uspScreenPatient 111002, 2, 1, '1/1/1993', 162, '5/20/2022', 1
EXECUTE uspScreenPatient 111003, 2, 2, '4/5/1980', 170, '5/15/2022', 1
EXECUTE uspScreenPatient 121001, 3, 2, '6/15/1985', 125, '1/30/2022', 1
EXECUTE uspScreenPatient 121002, 3, 1, '2/26/1970', 150, '1/30/2022', 1
EXECUTE uspScreenPatient 121003, 3, 2, '8/20/1976', 136, '1/30/2022', 1
EXECUTE uspScreenPatient 121003, 3, 2, '8/20/1976', 136, '3/30/2022', 1
EXECUTE uspScreenPatient 501001, 4, 1, '6/30/1990', 170, '2/15/2022', 1
EXECUTE uspScreenPatient 501002, 4, 2, '8/24/1997', 150, '5/10/2022', 1
EXECUTE uspScreenPatient 501003, 4, 1, '2/5/1960', 140, '6/14/2022', 1
EXECUTE uspScreenPatient 511001, 5, 2, '1/30/1970', 170, '1/10/2022', 1
EXECUTE uspScreenPatient 511002, 5, 2, '4/15/2006', 140, '5/11/2022', 1
EXECUTE uspScreenPatient 511003, 5, 1, '6/20/2010', 160, '2/5/2022', 1
EXECUTE uspScreenPatient 521001, 6, 1, '2/21/2005', 210, '6/15/2022', 1
EXECUTE uspScreenPatient 521002, 6, 2, '3/15/2000', 140, '7/15/2022', 1
EXECUTE uspScreenPatient 521003, 6, 1, '11/11/2011', 220, '6/25/2022', 1

-- Step 11.2 5 randomized patients for each study

--Study 1
EXECUTE uspRandomizePatient 1
EXECUTE uspRandomizePatient 3
EXECUTE uspRandomizePatient 5
EXECUTE uspRandomizePatient 7
EXECUTE uspRandomizePatient 9

--Study 2
EXECUTE uspRandomizePatient 11
EXECUTE uspRandomizePatient 13
EXECUTE uspRandomizePatient 15
EXECUTE uspRandomizePatient 17
EXECUTE uspRandomizePatient 19


SELECT
		 TP.intPatientID
		,TR.intRandomCodeID
		,TV.intVisitID
		,TR.intRandomCode
		,TR.strTreatment
		,TD.intDrugKitNumber
		,TD.strTreatment
		,TD.intSiteID		AS DrugSite
		,TP.intSiteID		AS PatSite
		,TS.intSiteNumber
		,TP.intPatientNumber
FROM
		 TPatients		AS TP
		,TVisits		AS TV
		,TRandomCodes		AS TR
		,TDrugKits		AS TD
		,TSites		AS TS

WHERE		TP.intPatientID	= TV.intPatientID
AND	TP.intRandomCodeID	= TR.intRandomCodeID
AND	TV.intVisitID		= TD.intVisitID
AND	TS.intSiteID		= TP.intSiteID

-- Step 11.3 Withdrawn 8 patients
DECLARE @WithdrawDate as DATETIME = (SELECT CONVERT(varchar, getdate()+1, 1))

-- Study 1
EXECUTE uspWithdrawPatient 3, @WithdrawDate, 1
EXECUTE uspWithdrawPatient 5, '1/1/2023', 6
EXECUTE uspWithdrawPatient 2, '4/1/2022', 5
EXECUTE uspWithdrawPatient 6, '5/30/2022', 4

-- Study 2
EXECUTE uspWithdrawPatient 11, @WithdrawDate, 1
EXECUTE uspWithdrawPatient 17, '12/30/2022', 2
EXECUTE uspWithdrawPatient 16, '8/15/2022', 3
EXECUTE uspWithdrawPatient 12, '6/20/2022', 4

SELECT
		 TP.intPatientID
		,TR.intRandomCodeID
		,TV.intVisitID
		,TR.intRandomCode
		,TR.strTreatment
		,TD.intDrugKitNumber
		,TD.strTreatment
		,TD.intSiteID		AS DrugSite
		,TP.intSiteID		AS PatSite
		,TS.intSiteNumber
		,TP.intPatientNumber
FROM
		 TPatients		AS TP
		,TVisits		AS TV
		,TRandomCodes	AS TR
		,TDrugKits		AS TD
		,TSites			AS TS

WHERE		TP.intPatientID	= TV.intPatientID
AND	TP.intRandomCodeID	= TR.intRandomCodeID
AND	TV.intVisitID		= TD.intVisitID
AND	TS.intSiteID		= TP.intSiteID
