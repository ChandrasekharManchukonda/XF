USE [OLAP]
GO

/****** Object:  Table [dbo].[dim_XF_SFDC_Account_tbl]    Script Date: 6/16/2019 4:47:30 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[dim_XF_SFDC_Account_tbl](
	[SK_Account] [int] IDENTITY(1,1) NOT NULL,
	[AccountName] [nvarchar](255) NULL,
	[AccountId] [nvarchar](30) NULL,
 CONSTRAINT [PK_dim_XF_SFDC_Account_tbl] PRIMARY KEY CLUSTERED 
(
	[SK_Account] ASC
)
) ON [PRIMARY]

GO

