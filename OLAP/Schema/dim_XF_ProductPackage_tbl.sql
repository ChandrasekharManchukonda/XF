USE [OLAP]
GO

/****** Object:  Table [dbo].[Dim_XF_ProductPackage_tbl]    ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Dim_XF_ProductPackage_tbl](
	[SK_Package] [int] IDENTITY(1,1) NOT NULL,
	[ProductGroupName] [nvarchar](50) NULL,
	[ProductCode] [varchar](50) NULL,
	[PackageName] [nvarchar](100) NULL,
 CONSTRAINT [PK_dim_XF_ProductPackage_tbl] PRIMARY KEY CLUSTERED 
(
	[SK_Package] ASC
)
) ON [PRIMARY]

GO


