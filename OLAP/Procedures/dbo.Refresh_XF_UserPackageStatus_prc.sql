USE OLAP
GO

IF OBJECT_ID('dbo.Refresh_XF_UserPackageStatus_prc') IS NOT NULL
DROP PROCEDURE dbo.Refresh_XF_UserPackageStatus_prc

GO

CREATE PROCEDURE dbo.Refresh_XF_UserPackageStatus_prc
AS
BEGIN

	DECLARE @Today DATETIME = GETDATE()
		,@MaxModifyDate DATETIME
		
		select @MaxModifyDate = ISNULL(MAX(MaxModifyDate),'1900-01-01')
		FROM dbo.XF_Tracking_tbl (NOLOCK)
		WHERE TableName = 'Dim_XF_UserPackageStatus_tbl'


	IF OBJECT_ID('tempdb..#XF_UserPackageStatus') IS NOT NULL
	DROP TABLE #XF_UserPackageStatus

	
	SELECT U.SK_User , P.SK_Package , E.PartnerStatus,E.LastUpdateDate
		INTO #XF_UserPackageStatus
	from dbo.XpressfeedEntitlements E (NOLOCK)
	JOIN dbo.dim_XF_ProductPackage_tbl P (NOLOCK)
		ON P.ProductCode = E.ProductCode
	JOIN dbo.dim_XF_User_tbl U (NOLOCK)
		ON U.UserName = E.PartnerCode
	WHERE E.LastUpdateDate > @MaxModifyDate
	GROUP BY U.SK_User , P.SK_Package , E.PartnerStatus ,E.LastUpdateDate


	IF EXISTS (SELECT top 1 1 FROM #XF_UserPackageStatus)
	BEGIN
			
			UPDATE PS
				SET PS.AccountStatus = X.PartnerStatus
			FROM dbo.Dim_XF_UserPackageStatus_tbl PS 
			JOIN #XF_UserPackageStatus X
				ON X.SK_User = PS.SK_User
				AND X.SK_Package = PS.SK_Package
			WHERE ISNULL(PS.AccountStatus,'') <> ISNULL(X.PartnerStatus,'' )
			
			
			INSERT INTO dbo.Dim_XF_UserPackageStatus_tbl(SK_User, SK_Package,AccountStatus)
			SELECT SK_User, SK_Package, PartnerStatus
			FROM #XF_UserPackageStatus X
			WHERE  NOT EXISTS (SELECT 1 FROM [dbo].dim_XF_UserPackageStatus_tbl A (NOLOCK) 
			WHERE X.SK_User = A.SK_User
				AND X.SK_Package = A.SK_Package
			)
	END

	
		--Record current max ModifyDate Tracking details
		SELECT @MaxModifyDate = MAX(LastUpdateDate)
		FROM #XF_UserPackageStatus

		IF @MaxModifyDate IS NOT NULL
		INSERT INTO dbo.XF_Tracking_tbl (TableName,[LastTrackingDate],MaxModifyDate)
		VALUES('Dim_XF_UserPackageStatus_tbl',@Today,@MaxModifyDate)

		DELETE FROM dbo.XF_Tracking_tbl WHERE TableName = 'Dim_XF_UserPackageStatus_tbl' AND [LastTrackingDate] < DATEADD(YY,-1,@Today)


END
