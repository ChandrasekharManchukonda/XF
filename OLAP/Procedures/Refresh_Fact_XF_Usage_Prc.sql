USE OLAP
GO

IF OBJECT_ID('dbo.Refresh_Fact_XF_Usage_Prc') IS NOT NULL
DROP PROCEDURE dbo.Refresh_Fact_XF_Usage_Prc

GO

CREATE PROCEDURE dbo.Refresh_Fact_XF_Usage_Prc
AS
BEGIN

		DECLARE @Today DATETIME = GETDATE()
		,@PreviousLatestEDXLogId INT
		,@PresentLatestEDXLogId INT
		,@MaxFTPDate DATETIME
		
		select @PreviousLatestEDXLogId = MAX(LatestEDXLogId)
		FROM dbo.XF_Tracking_tbl (NOLOCK)
		WHERE TableName = 'Fact_XF_Usage_tbl'


		IF @PreviousLatestEDXLogId IS NOT  NULL
		BEGIN
				IF OBJECT_ID('tempdb..#XF_Usage') IS NOT NULL
				DROP TABLE #XF_Usage

					SELECT 
								dbo.DateToInt_fn(L.FTPDate) AS AccessedDateKey
							, U.SK_User
							, A.SK_Account
							, P.SK_Package
							, UP.SK_UserPackage
							, COUNT(*) AS AdjustedHits
							, MAX(L.EDXlogId) AS MaxEDXLogId
							, MAX(FTPDate)  AS MaxFTPDate
					INTO #XF_Usage
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
					WHERE L.EDXlogId >  @PreviousLatestEDXLogId
					AND L.FileName IS NOT NULL
					GROUP BY dbo.DateToInt_fn(FTPDate) , U.SK_User, P.SK_Package, A.SK_Account, UP.SK_UserPackage


					select @PresentLatestEDXLogId = MAX(MaxEDXLogId)
						,@MaxFTPDate = MAX(MaxFTPDate)
					FROM #XF_Usage


					select @PresentLatestEDXLogId , @MaxFTPDate

					INSERT INTO [dbo].[Fact_XF_Usage_tbl] (AccessedDateKey, SK_User, SK_Account, SK_Package, SK_UserPackage, AdjustedHits)
					SELECT AccessedDateKey, SK_User, SK_Account, SK_Package, SK_UserPackage, AdjustedHits FROM #XF_Usage

				INSERT INTO dbo.XF_Tracking_tbl (TableName,[LastTrackingDate],MaxModifyDate, LatestEDXLogId)
				VALUES('Fact_XF_Usage_tbl',@Today,@MaxFTPDate, @PresentLatestEDXLogId)

		END

	DELETE FROM dbo.XF_Tracking_tbl WHERE TableName = 'Fact_XF_Usage_tbl' AND [LastTrackingDate] < DATEADD(YY,-1,@Today)

END