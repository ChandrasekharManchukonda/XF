USE OLAP
GO

IF OBJECT_ID('dbo.Refresh_XF_SFDC_Account_prc') IS NOT NULL
DROP PROCEDURE dbo.Refresh_XF_SFDC_Account_prc

GO

CREATE PROCEDURE dbo.Refresh_XF_SFDC_Account_prc
AS
BEGIN

	DECLARE @Today DATETIME = GETDATE()
		,@MaxModifyDate DATETIME
		,@LastRefreshDate DATETIME

		SELECT @MaxModifyDate = ISNULL(MAX(MaxModifyDate),'1900-01-01')
		FROM dbo.XF_Tracking_tbl (NOLOCK)
		WHERE TableName = 'dim_XF_SFDC_Account_tbl'

	IF OBJECT_ID('tempdb..#XF_SFDC_Account') IS NOT NULL
	DROP TABLE #XF_SFDC_Account

	SELECT AccountId,NULL AS AccountName,ModifyDate
	INTO #XF_SFDC_Account
	FROM dbo.EnvironmentEDXUserFromSalesforce (NOLOCK)
	WHERE ModifyDate > @MaxModifyDate

	IF EXISTS (SELECT top 1 1 FROM #XF_SFDC_Account)
	BEGIN
			INSERT INTO [dbo].[dim_XF_SFDC_Account_tbl] (AccountId, AccountName)
			SELECT AccountId,NULL
			FROM #XF_SFDC_Account X
			WHERE  NOT EXISTS (SELECT 1 FROM [dbo].[dim_XF_SFDC_Account_tbl] A (NOLOCK) WHERE ISNULL(X.AccountId,'') = ISNULL(A.AccountId,''))
			GROUP BY AccountId

			--Record current max ModifyDate Tracking details
			SELECT @MaxModifyDate = MAX(ModifyDate)
			FROM #XF_SFDC_Account

			IF @MaxModifyDate IS NOT NULL
			INSERT INTO dbo.XF_Tracking_tbl (TableName,LastTrackingDate,MaxModifyDate)
			VALUES('dim_XF_SFDC_Account_tbl',@Today,@MaxModifyDate)
	END

	DELETE FROM dbo.XF_Tracking_tbl WHERE TableName = 'dim_XF_SFDC_Account_tbl' AND LastTrackingDate < DATEADD(YY,-1,@Today)


END