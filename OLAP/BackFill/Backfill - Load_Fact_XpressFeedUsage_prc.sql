-- Load 2018-01-01 to 2019-06-30

DECLARE @Start_EDXLogId INT
	,@End_EDXLogId INT
	,@EDXLogId INT


		DECLARE @Today DATETIME = GETDATE()
		,@PreviousLatestEDXLogId INT
		,@PresentLatestEDXLogId INT
		,@MaxFTPDate DATETIME
		
		select @PreviousLatestEDXLogId = MAX(LatestEDXLogId)
		FROM dbo.XF_Tracking_tbl (NOLOCK)
		WHERE TableName = 'Fact_XF_Usage_tbl'

-- It took 1 minute 46 seconds for identifying one day's min and max Id values
--SELECT  @Start_EDXLogId = MIN(EDXlogId), @End_EDXLogId = MAX(EDXlogId) 
--from Fa_EDXFTPLog (NOLOCK)   
--WHERE FTPDate BETWEEN '2018-01-01' AND '2018-01-02'

--SELECT  MAX(EDXlogId) 
--from Fa_EDXFTPLog (NOLOCK)   
--WHERE FTPDate >= '2018-06-30' AND FTPDate < '2019-07-01'



-- we can start from 136054647

SELECT  @Start_EDXLogId = ISNULL(@PreviousLatestEDXLogId,80954647), @End_EDXLogId = 160445600
,@EDXLogId = @Start_EDXLogId + 100000


WHILE @End_EDXLogId > @EDXLogId OR @End_EDXLogId BETWEEN @Start_EDXLogId AND @EDXLogId
BEGIN


	IF @End_EDXLogId BETWEEN @Start_EDXLogId AND @EDXLogId
	SET @EDXLogId = @End_EDXLogId

	PRINT @Start_EDXLogId PRINT @EDXLogId 
	
	IF OBJECT_ID('tempdb.dbo.#temp') IS NOT NULL
	DROP TABLE #temp

				SELECT 
						  dbo.DateToInt_fn(L.FTPDate) AS AccessedDateKey
						, U.SK_User
						, A.SK_Account
						, P.SK_Package
						, UP.SK_UserPackage
						, COUNT(*) AS AdjustedHits
						, MAX(EDXlogId) AS MaxEDXLogId
						, MAX(FTPDate)  AS MaxFTPDate
				INTO #temp
				from dbo.Fa_EDXFTPLog L (NOLOCK)
				JOIN dbo.dim_XF_ProductPackage_tbl P (NOLOCK)
					ON L.Package = P.ProductCode
				JOIN dbo.dim_XF_User_tbl U (NOLOCK)
					ON L.FTP_un = U.UserName 
				JOIN dbo.Dim_XF_UserPackageStatus_tbl UP (NOLOCK)
					ON UP.SK_User = U.SK_User AND UP.SK_Package = P.SK_Package
				JOIN dbo.EnvironmentEDXUserFromSalesforce EU (NOLOCK)
					ON EU.EDXUsernameMIUnique = L.FTP_un 
				JOIN dbo.dim_XF_SFDC_Account_tbl A (NOLOCK)
					ON EU.AccountId = A.AccountId 
				WHERE L.EDXlogId BETWEEN @Start_EDXLogId AND @EDXLogId
					AND L.FileName IS NOT NULL
				GROUP BY dbo.DateToInt_fn(FTPDate) , U.SK_User, P.SK_Package, A.SK_Account, UP.SK_UserPackage


				INSERT INTO [dbo].[Fact_XF_Usage_tbl] (AccessedDateKey, SK_User, SK_Account, SK_Package, SK_UserPackage, AdjustedHits)
				SELECT AccessedDateKey, SK_User, SK_Account, SK_Package, SK_UserPackage, AdjustedHits FROM #temp

	SET @Start_EDXLogId = @EDXLogId + 1
	SET @EDXLogId = @EDXLogId + 100000
END

		select @PresentLatestEDXLogId = MAX(MaxEDXLogId)
						,@MaxFTPDate = MAX(MaxFTPDate)
					FROM #temp

	INSERT INTO dbo.XF_Tracking_tbl (TableName,[LastTrackingDate],MaxModifyDate, LatestEDXLogId)
				VALUES('Fact_XF_Usage_tbl',@Today,@MaxFTPDate, @PresentLatestEDXLogId)

				--select * from #temp where MaxEDXLogId > 160354647
/*

select top 10 * from [dbo].[Fact_XF_Usage_tbl]
truncate table [Fact_XF_Usage_tbl]
select top 10 * from #temp

sp_spaceused [Fact_XF_Usage_tbl_1Day]

select * from sys.database_files
xp_fixeddrives
/*
drive	MB free
C	17628
D	8285
E	765308
F	755492
G	427622
H	412356
I	2428901
T	1626662
*/


*/