USE [OLAP]
GO

/****** Object:  Table [dbo].[Fact_XF_Usage_tbl]   ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID('Fact_XF_Usage_tbl') IS NULL
CREATE TABLE [dbo].[Fact_XF_Usage_tbl](
	[XFUsageId] [int] IDENTITY(1,1) NOT NULL,
	[AccessedDateKey] [int] NULL,
	[SK_User] [int] NULL,
	[SK_Account] [int] NULL,
	[SK_Package] [int] NULL,
	[AdjustedHits] [float] NULL,
	[SK_UserPackage] [int] NULL,
 CONSTRAINT [PK_Fact_XF_Usage_tbl] PRIMARY KEY CLUSTERED 
(
	[XFUsageId] ASC
)
) ON [PRIMARY]

GO

