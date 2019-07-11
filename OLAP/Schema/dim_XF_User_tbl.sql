USE [OLAP]
GO

/****** Object:  Table [dbo].[dim_XF_User_tbl]    Script Date: 6/16/2019 4:45:57 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID('dim_XF_User_tbl') IS NULL
CREATE TABLE [dbo].[dim_XF_User_tbl](
	[SK_User] [int] IDENTITY(1,1) NOT NULL,
	[UserName] [nvarchar](100) NULL,
 CONSTRAINT [PK_dim_XF_User_tbl] PRIMARY KEY CLUSTERED 
(
	[SK_User] ASC
)
) ON [PRIMARY]

GO


