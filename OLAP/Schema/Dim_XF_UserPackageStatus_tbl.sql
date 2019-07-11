

USE [OLAP]
GO

/****** Object:  Table [dbo].[Dim_XF_UserPackageStatus_tbl]    Script Date: 6/17/2019 1:39:26 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID('Dim_XF_UserPackageStatus_tbl') IS NULL
CREATE TABLE [dbo].[Dim_XF_UserPackageStatus_tbl](
	[SK_UserPackage] [int] IDENTITY(1,1) NOT NULL,
	[SK_User] [int] NULL,
	[SK_Package] [int] NULL,
	[AccountStatus] [varchar](2) NULL,
 CONSTRAINT [PK_Dim_XF_UserPackageStatus_tbl] PRIMARY KEY CLUSTERED 
(
	[SK_UserPackage] ASC
)
) ON [PRIMARY]

GO
