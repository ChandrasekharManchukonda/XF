USE [OLAP]
GO

/****** Object:  Table [dbo].[Fact_XF_Usage_tbl]   ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Fact_XF_Usage_tbl](
	[AccessedDateKey] [int] NULL,
	[SK_User] [int] NULL,
	[SK_Account] [int] NULL,
	[SK_Package] [int] NULL,
	[AdjustedHits] [float] NULL,
	[SK_UserPackage] [int] NULL
) ON [PRIMARY]

GO

