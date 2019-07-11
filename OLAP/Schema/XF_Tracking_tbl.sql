USE [OLAP]
GO

/****** Object:  Table [dbo].[XF_Tracking_tbl]    Script Date: 7/11/2019 7:01:59 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
IF OBJECT_ID('XF_Tracking_tbl') IS NULL
CREATE TABLE [dbo].[XF_Tracking_tbl](
	[TableName] [nvarchar](100) NULL,
	[LastTrackingDate] [datetime] NULL,
	[MaxModifyDate] [datetime] NULL,
	[LatestEDXLogId] [int] NULL
) ON [PRIMARY]

GO



