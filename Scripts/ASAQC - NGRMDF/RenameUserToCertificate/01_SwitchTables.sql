
/****** Object:  Table [security].[Certificate]    Script Date: 11.11.2019 13:45:59 ******/
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

ALTER TABLE [security].[Certificate]  WITH CHECK ADD  CONSTRAINT [FK_User_Vendor] FOREIGN KEY([VendorName])
REFERENCES [security].[Vendor] ([VendorName])
GO

ALTER TABLE [security].[Certificate] CHECK CONSTRAINT [FK_User_Vendor]
GO


/****** Object:  Table [security].[CertificateSurvey]    Script Date: 11.11.2019 13:46:11 ******/
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

ALTER TABLE [security].[CertificateSurvey]  WITH CHECK ADD  CONSTRAINT [FK_UserSurvey_Survey] FOREIGN KEY([SurveyID])
REFERENCES [survey].[Survey] ([SurveyID])
GO

ALTER TABLE [security].[CertificateSurvey] CHECK CONSTRAINT [FK_UserSurvey_Survey]
GO

ALTER TABLE [security].[CertificateSurvey]  WITH CHECK ADD  CONSTRAINT [FK_UserSurvey_User] FOREIGN KEY([CertID])
REFERENCES [security].[Certificate] ([CertID])
GO

ALTER TABLE [security].[CertificateSurvey] CHECK CONSTRAINT [FK_UserSurvey_User]
GO

-------------------------------------------------------------------------------

INSERT INTO [security].[Certificate] (
	[CertID],
	[Alias],
	[Thumbprint],
	[CertType],
	[VendorName]
)
SELECT
	[UserID],
	[UserExternalID],
	[UserToken],
	[UserType],
	[VendorName]
FROM [security].[User]


INSERT INTO [security].[CertificateSurvey] (
    [CertID],
	[SurveyID],
	[ValidToDate]
)
SELECT
    [UserID],
    [SurveyID],
    [ValidToDate]
FROM [security].[UserSurvey]

-------------------------------------------------------------------------------

ALTER TABLE [security].[UserSurvey] DROP CONSTRAINT [FK_UserSurvey_User]
GO

ALTER TABLE [security].[UserSurvey] DROP CONSTRAINT [FK_UserSurvey_Survey]
GO

/****** Object:  Table [security].[UserSurvey]    Script Date: 11.11.2019 13:46:11 ******/
DROP TABLE [security].[UserSurvey]
GO


ALTER TABLE [security].[User] DROP CONSTRAINT [FK_User_Vendor]
GO

/****** Object:  Table [security].[User]    Script Date: 11.11.2019 13:45:59 ******/
DROP TABLE [security].[User]
GO