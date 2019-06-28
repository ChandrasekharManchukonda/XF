USE OLAP
GO

IF OBJECT_ID('dbo.Refresh_XF_User_prc') IS NOT NULL
DROP PROCEDURE dbo.Refresh_XF_User_prc

GO

CREATE PROCEDURE dbo.Refresh_XF_User_prc
AS
BEGIN

	DECLARE @Today DATETIME = GETDATE()
		,@MaxModifyDate DATETIME
		
		select @MaxModifyDate = ISNULL(MAX(MaxModifyDate),'1900-01-01')
		FROM dbo.XF_Tracking_tbl (NOLOCK)
		WHERE TableName = 'dim_XF_User_tbl'

	IF OBJECT_ID('tempdb..#XF_User') IS NOT NULL
	DROP TABLE #XF_User

	SELECT EDXUsernameMIUnique,ModifyDate
	INTO #XF_User
	FROM dbo.EnvironmentEDXUserFromSalesforce (NOLOCK)
	WHERE ModifyDate > @MaxModifyDate
	

	
	INSERT INTO [dbo].[dim_XF_User_tbl](UserName)
	SELECT EDXUsernameMIUnique
	FROM #XF_User X
	WHERE  NOT EXISTS (SELECT 1 FROM [dbo].[dim_XF_User_tbl] U (NOLOCK) WHERE ISNULL(X.EDXUsernameMIUnique,'') = ISNULL(U.UserName,''))
	GROUP BY EDXUsernameMIUnique

	SELECT @MaxModifyDate = MAX(ModifyDate)
	FROM #XF_User


	IF @MaxModifyDate IS NOT NULL
	INSERT INTO dbo.XF_Tracking_tbl (TableName,[LastTrackingDate],MaxModifyDate)
	VALUES('dim_XF_User_tbl',@Today,@MaxModifyDate)

	DELETE FROM dbo.XF_Tracking_tbl WHERE TableName = 'dim_XF_User_tbl' AND [LastTrackingDate] < DATEADD(YY,-1,@Today)

END

