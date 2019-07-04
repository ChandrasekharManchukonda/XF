USE [OLAP]
GO

/****** Object:  Table [dbo].[dim_SFDC_Account_tbl]    ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID('Dim_SFDC_Account_tbl') IS NULL
CREATE TABLE [dbo].[dim_SFDC_Account_tbl](
	[SK_Account] [int] IDENTITY(1,1) NOT NULL,
	[AccountName] [nvarchar](255) NULL,
	[AccountId] [nvarchar](18) NULL,
 CONSTRAINT [PK_dim_SFDC_Account_tbl] PRIMARY KEY CLUSTERED 
(
	[SK_Account] ASC
)
) ON [PRIMARY]

GO

