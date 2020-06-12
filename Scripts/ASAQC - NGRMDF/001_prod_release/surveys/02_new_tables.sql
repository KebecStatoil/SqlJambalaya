/****** Object:  Table [security].[ApplicationRole]    Script Date: 09.12.2019 15:03:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [security].[ApplicationRole](
	[RoleName] [nvarchar](128) NOT NULL,
	[Type] [nvarchar](128) NULL,
	[Alias] [nvarchar](64) NULL,
 CONSTRAINT [PK_ApplicationRole] PRIMARY KEY CLUSTERED 
(
	[RoleName] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [security].[ApplicationRolesFeilds]    Script Date: 09.12.2019 15:03:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [security].[ApplicationRolesFeilds](
	[RoleName] [nvarchar](128) NOT NULL,
	[IDFIELD] [int] NOT NULL,
 CONSTRAINT [PK_ApplicationRolesFeilds] PRIMARY KEY CLUSTERED 
(
	[RoleName] ASC,
	[IDFIELD] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [security].[ApplicationRolesSurveys]    Script Date: 09.12.2019 15:03:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [security].[ApplicationRolesSurveys](
	[RoleName] [nvarchar](128) NOT NULL,
	[SurveyID] [int] NOT NULL,
 CONSTRAINT [PK_ApplicationRolesSurveys] PRIMARY KEY CLUSTERED 
(
	[RoleName] ASC,
	[SurveyID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [security].[Certificate]    Script Date: 09.12.2019 15:03:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [security].[Certificate](
	[CertID] [int] NOT NULL,
	[Alias] [nvarchar](128) NOT NULL,
	[Thumbprint] [varchar](40) NULL,
	[CertType] [varchar](32) NULL,
	[VendorName] [nvarchar](128) NULL,
 CONSTRAINT [PK_Certificate] PRIMARY KEY CLUSTERED 
(
	[CertID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [security].[CertificateSurvey]    Script Date: 09.12.2019 15:03:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [security].[CertificateSurvey](
	[CertID] [int] NOT NULL,
	[SurveyID] [int] NOT NULL,
	[ValidToDate] [date] NULL,
 CONSTRAINT [PK_CertificateSurvey] PRIMARY KEY CLUSTERED 
(
	[CertID] ASC,
	[SurveyID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [security].[Vendor]    Script Date: 09.12.2019 15:03:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [security].[Vendor](
	[VendorName] [nvarchar](128) NOT NULL,
	[RoleName] [nvarchar](128) NULL,
	[IsPrm] [bit] NULL,
	[IsVessel] [bit] NULL,
	[Alias] [nvarchar](64) NULL,
 CONSTRAINT [PK_Vendor] PRIMARY KEY CLUSTERED 
(
	[VendorName] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [survey].[InterestingDataFields]    Script Date: 09.12.2019 15:03:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [survey].[InterestingDataFields](
	[ParamCode] [char](3) NOT NULL,
	[ParameterName] [nvarchar](128) NOT NULL,
	[TableName] [nvarchar](128) NOT NULL,
	[ColumnName] [nvarchar](128) NOT NULL,
	[Description] [nvarchar](128) NULL,
	[ExternalTable] [nvarchar](128) NULL,
 CONSTRAINT [PK_survey.InterestingDataFields] PRIMARY KEY CLUSTERED 
(
	[ParamCode] ASC,
	[ParameterName] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [security].[ApplicationRolesFeilds]  WITH NOCHECK ADD  CONSTRAINT [FK_ApplicationRolesFeilds_ApplicationRole] FOREIGN KEY([RoleName])
REFERENCES [security].[ApplicationRole] ([RoleName])
GO
ALTER TABLE [security].[ApplicationRolesFeilds] CHECK CONSTRAINT [FK_ApplicationRolesFeilds_ApplicationRole]
GO
ALTER TABLE [security].[ApplicationRolesFeilds]  WITH NOCHECK ADD  CONSTRAINT [FK_ApplicationRolesFeilds_Field] FOREIGN KEY([IDFIELD])
REFERENCES [management].[Field] ([IDFIELD])
GO
ALTER TABLE [security].[ApplicationRolesFeilds] CHECK CONSTRAINT [FK_ApplicationRolesFeilds_Field]
GO
ALTER TABLE [security].[Certificate]  WITH NOCHECK ADD  CONSTRAINT [FK_User_Vendor] FOREIGN KEY([VendorName])
REFERENCES [security].[Vendor] ([VendorName])
GO
ALTER TABLE [security].[Certificate] CHECK CONSTRAINT [FK_User_Vendor]
GO
ALTER TABLE [security].[CertificateSurvey]  WITH NOCHECK ADD  CONSTRAINT [FK_CertificateSurvey_Survey] FOREIGN KEY([SurveyID])
REFERENCES [survey].[Survey] ([SurveyID])
GO
ALTER TABLE [security].[CertificateSurvey] CHECK CONSTRAINT [FK_CertificateSurvey_Survey]
GO
ALTER TABLE [security].[CertificateSurvey]  WITH NOCHECK ADD  CONSTRAINT [FK_CertificateSurvey_Certificate] FOREIGN KEY([CertID])
REFERENCES [security].[Certificate] ([CertID])
GO
ALTER TABLE [security].[CertificateSurvey] CHECK CONSTRAINT [FK_CertificateSurvey_Certificate]
GO
ALTER TABLE [security].[Vendor]  WITH NOCHECK ADD  CONSTRAINT [FK_Vendor_ApplicationRole] FOREIGN KEY([RoleName])
REFERENCES [security].[ApplicationRole] ([RoleName])
GO
ALTER TABLE [security].[Vendor] CHECK CONSTRAINT [FK_Vendor_ApplicationRole]
GO

