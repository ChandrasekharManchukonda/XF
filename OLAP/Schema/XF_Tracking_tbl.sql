USE [OLAP]
GO

/****** Object:  Table [dbo].[XF_Tracking_tbl]    Script Date: 6/16/2019 4:51:37 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[XF_Tracking_tbl](
	[TableName] [nvarchar](100) NULL,
	[LastTrackingDate] [datetime] NULL,
	[MaxModifyDate] [datetime] NULL
) ON [PRIMARY]

GO

