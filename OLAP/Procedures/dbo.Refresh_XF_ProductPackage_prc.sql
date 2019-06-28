USE OLAP
GO

IF OBJECT_ID('dbo.Refresh_XF_ProductPackage_prc') IS NOT NULL
DROP PROCEDURE dbo.Refresh_XF_ProductPackage_prc

GO

CREATE PROCEDURE dbo.Refresh_XF_ProductPackage_prc
AS
BEGIN

	DECLARE @Today DATETIME = GETDATE()
		,@MaxModifyDate DATETIME
		
		SELECT @MaxModifyDate = ISNULL(MAX(MaxModifyDate),'1900-01-01')
		FROM dbo.XF_Tracking_tbl (NOLOCK)
		WHERE TableName = 'dim_XF_ProductPackage_tbl'

		--select @MaxModifyDate

	IF OBJECT_ID('tempdb..#XF_ProductPackage') IS NOT NULL
	DROP TABLE #XF_ProductPackage

	SELECT ProductGroupName,ProductCode,ProductName AS PackageName,LastUpdateDate
	INTO #XF_ProductPackage
	FROM dbo.XpressfeedEntitlements (NOLOCK)
	WHERE LastUpdateDate > @MaxModifyDate
	GROUP BY  ProductGroupName,ProductCode,ProductName,LastUpdateDate

	
	IF EXISTS (SELECT top 1 1 FROM #XF_ProductPackage)
	BEGIN
			INSERT INTO [dbo].dim_XF_ProductPackage_tbl (ProductGroupName,ProductCode,PackageName)
			SELECT ISNULL(ProductGroupName,'Unknown'),ProductCode, PackageName
			FROM #XF_ProductPackage X
			WHERE  NOT EXISTS (SELECT 1 FROM [dbo].dim_XF_ProductPackage_tbl A (NOLOCK) WHERE ISNULL(X.PackageName,'') = ISNULL(A.PackageName,'')
			AND ISNULL(X.ProductGroupName,'') = ISNULL(A.ProductGroupName,'')
			AND ISNULL(X.ProductCode,'') = ISNULL(A.ProductCode,'')
			)
			GROUP BY ProductGroupName,ProductCode,PackageName

			--Record current max ModifyDate Tracking details
			SELECT @MaxModifyDate = MAX(LastUpdateDate)
			FROM #XF_ProductPackage

			IF @MaxModifyDate IS NOT NULL
			INSERT INTO dbo.XF_Tracking_tbl (TableName,[LastTrackingDate],MaxModifyDate)
			VALUES('dim_XF_ProductPackage_tbl',@Today,@MaxModifyDate)
	END

	DELETE FROM dbo.XF_Tracking_tbl WHERE TableName = 'dim_XF_ProductPackage_tbl' AND [LastTrackingDate] < DATEADD(YY,-1,getdate())

END