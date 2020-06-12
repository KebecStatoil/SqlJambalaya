-------------------------------------------------------------------------------
-------------------------------------- move "altered" tables to "old" schema --
-------------------------------------------------------------------------------
--CREATE SCHEMA survey_old;
--GO
--ALTER SCHEMA survey_old TRANSFER survey.[Preplot];
--GO
--ALTER SCHEMA survey_old TRANSFER survey.[Survey];
--GO
--ALTER SCHEMA survey_old TRANSFER survey.[SurveyPreplotLink];
--GO

-------------------------------------------------------------------------------
-------------------------------------------------- create new table versions --
-------------------------------------------------------------------------------
--/****** Object:  Table [survey].[Preplot]    Script Date: 09.12.2019 14:27:31 ******/
--SET ANSI_NULLS ON
--GO
--SET QUOTED_IDENTIFIER ON
--GO
--CREATE TABLE [survey].[Preplot](
--	[PreplotID] [int] NOT NULL,
--	[PreplotName] [nvarchar](256) NOT NULL,
--	[epsg_code] [int] NULL,
--	[epsg_trans] [int] NULL,
--	[proj4] [nvarchar](max) NULL,
--	[Created] [datetime] NOT NULL,
--	[CreatedBy] [nvarchar](128) NOT NULL,
--	[Updated] [datetime] NOT NULL,
--	[UpdatedBy] [nvarchar](128) NOT NULL,
--	[SourceFilePath] [nvarchar](256) NULL,
--	[SailFilePath] [nvarchar](256) NULL,
--	[P111FilePath] [nvarchar](256) NULL,
-- CONSTRAINT [PK_Preplot_1] PRIMARY KEY CLUSTERED 
--(
--	[PreplotID] ASC
--)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY],
-- CONSTRAINT [IX_Preplot] UNIQUE NONCLUSTERED 
--(
--	[PreplotName] ASC
--)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
--) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
--GO
--/****** Object:  Table [survey].[Survey]    Script Date: 09.12.2019 14:27:31 ******/
--SET ANSI_NULLS ON
--GO
--SET QUOTED_IDENTIFIER ON
--GO
--CREATE TABLE [survey].[Survey](
--	[SurveyID] [int] NOT NULL,
--	[survey_name] [char](7) NULL,
--	[PlannedStartDate] [date] NULL,
--	[PlannedEndDate] [date] NULL,
--	[Field_ID] [int] NULL,
--	[SurveyType_ID] [int] NULL,
--	[EPSGCode] [int] NULL,
--	[VesselOperationalStatus] [nvarchar](64) NOT NULL,
--	[VesselOperationalStatusLastChanged] [datetime] NOT NULL,
--	[PrmLineStatus] [nvarchar](64) NOT NULL,
--	[PrmLineStatusLastChanged] [datetime] NOT NULL,
--	[Created] [datetime] NOT NULL,
--	[CreatedBy] [nvarchar](128) NOT NULL,
--	[Updated] [datetime] NOT NULL,
--	[UpdatedBy] [nvarchar](128) NOT NULL,
--	[SoftDeleted] [bit] NOT NULL,
--	[Archived] [bit] NOT NULL,
--	[Description] [nvarchar](2048) NULL,
--	[SoftDeletedBy] [nvarchar](256) NULL,
--	[SoftDeletedDate] [datetime] NULL,
-- CONSTRAINT [PK_Survey] PRIMARY KEY CLUSTERED 
--(
--	[SurveyID] ASC
--)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY],
-- CONSTRAINT [IX_Survey] UNIQUE NONCLUSTERED 
--(
--	[survey_name] ASC
--)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
--) ON [PRIMARY]
--GO
--/****** Object:  Table [survey].[SurveyPreplotLink]    Script Date: 09.12.2019 14:27:31 ******/
--SET ANSI_NULLS ON
--GO
--SET QUOTED_IDENTIFIER ON
--GO
--CREATE TABLE [survey].[SurveyPreplotLink](
--	[SurveyID] [int] NOT NULL,
--	[PreplotID] [int] NOT NULL,
-- CONSTRAINT [PK_SurveyPreplotLink] PRIMARY KEY CLUSTERED 
--(
--	[SurveyID] ASC,
--	[PreplotID] ASC
--)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
--) ON [PRIMARY]
--GO
--ALTER TABLE [survey].[Preplot] ADD  CONSTRAINT [DF_Preplot_Created]  DEFAULT (getutcdate()) FOR [Created]
--GO
--ALTER TABLE [survey].[Preplot] ADD  CONSTRAINT [DF_Preplot_CreatedBy]  DEFAULT (suser_sname()) FOR [CreatedBy]
--GO
--ALTER TABLE [survey].[Preplot] ADD  CONSTRAINT [DF_Preplot_Updated]  DEFAULT (getutcdate()) FOR [Updated]
--GO
--ALTER TABLE [survey].[Preplot] ADD  CONSTRAINT [DF_Preplot_UpdatedBy]  DEFAULT (suser_sname()) FOR [UpdatedBy]
--GO
--ALTER TABLE [survey].[Survey] ADD  CONSTRAINT [DF_Survey_VesselOperationalStatus]  DEFAULT ('Offline') FOR [VesselOperationalStatus]
--GO
--ALTER TABLE [survey].[Survey] ADD  CONSTRAINT [DF_Survey_VesselOperationalStatusLastChanged]  DEFAULT (getdate()) FOR [VesselOperationalStatusLastChanged]
--GO
--ALTER TABLE [survey].[Survey] ADD  CONSTRAINT [DF_Survey_PrmLineStatus]  DEFAULT ('Offline') FOR [PrmLineStatus]
--GO
--ALTER TABLE [survey].[Survey] ADD  CONSTRAINT [DF_Survey_PrmLineStatusLastChanged]  DEFAULT (getdate()) FOR [PrmLineStatusLastChanged]
--GO
--ALTER TABLE [survey].[Survey] ADD  CONSTRAINT [DF_Survey_Created]  DEFAULT (getutcdate()) FOR [Created]
--GO
--ALTER TABLE [survey].[Survey] ADD  CONSTRAINT [DF_Survey_CreatedBy]  DEFAULT (suser_sname()) FOR [CreatedBy]
--GO
--ALTER TABLE [survey].[Survey] ADD  CONSTRAINT [DF_Survey_Updated]  DEFAULT (getutcdate()) FOR [Updated]
--GO
--ALTER TABLE [survey].[Survey] ADD  CONSTRAINT [DF_Survey_UpdatedBy]  DEFAULT (suser_sname()) FOR [UpdatedBy]
--GO
--ALTER TABLE [survey].[Survey] ADD  CONSTRAINT [DF_Survey_SoftDeleted]  DEFAULT ((0)) FOR [SoftDeleted]
--GO
--ALTER TABLE [survey].[Survey] ADD  CONSTRAINT [DF_Survey_Archived]  DEFAULT ((0)) FOR [Archived]
--GO
--ALTER TABLE [survey].[Survey]  WITH CHECK ADD  CONSTRAINT [FK_Survey_Field] FOREIGN KEY([Field_ID])
--REFERENCES [management].[Field] ([IDFIELD])
--GO
--ALTER TABLE [survey].[Survey] CHECK CONSTRAINT [FK_Survey_Field]
--GO
--ALTER TABLE [survey].[Survey]  WITH CHECK ADD  CONSTRAINT [FK_Survey_PrmLineStatus] FOREIGN KEY([PrmLineStatus])
--REFERENCES [survey].[PrmLineStatus] ([Status])
--GO
--ALTER TABLE [survey].[Survey] CHECK CONSTRAINT [FK_Survey_PrmLineStatus]
--GO
--ALTER TABLE [survey].[Survey]  WITH CHECK ADD  CONSTRAINT [FK_Survey_VesselOperationalStatus] FOREIGN KEY([VesselOperationalStatus])
--REFERENCES [survey].[VesselOperationalStatus] ([Status])
--GO
--ALTER TABLE [survey].[Survey] CHECK CONSTRAINT [FK_Survey_VesselOperationalStatus]
--GO
--ALTER TABLE [survey].[SurveyPreplotLink]  WITH NOCHECK ADD  CONSTRAINT [FK_SurveyPreplotLink_Preplot] FOREIGN KEY([PreplotID])
--REFERENCES [survey].[Preplot] ([PreplotID])
--GO
--ALTER TABLE [survey].[SurveyPreplotLink] CHECK CONSTRAINT [FK_SurveyPreplotLink_Preplot]
--GO
--ALTER TABLE [survey].[SurveyPreplotLink]  WITH CHECK ADD  CONSTRAINT [FK_SurveyPreplotLink_Survey] FOREIGN KEY([SurveyID])
--REFERENCES [survey].[Survey] ([SurveyID])
--GO
--ALTER TABLE [survey].[SurveyPreplotLink] CHECK CONSTRAINT [FK_SurveyPreplotLink_Survey]
--GO

-------------------------------------------------------------------------------
------------------------------------------- populate new tables from the old -
-------------------------------------------------------------------------------
--INSERT INTO [survey].[Preplot](
--	[PreplotID]
--	,[PreplotName]
--	,[epsg_code]
--	,[epsg_trans]
--	,[proj4]
--	,[Created]
--	,[CreatedBy]
--	,[Updated]
--	,[UpdatedBy]
--	,[SourceFilePath]
--	,[SailFilePath]
--	,[P111FilePath]
--)
--SELECT
--	[PreplotID]
--	,[PreplotName]
--	,[epsg_code]
--	,[epsg_trans]
--	,[proj4]
--	,[Created]
--	,[CreatedBy]
--	,[Updated]
--	,[UpdatedBy]
--	,[SourceFilePath]
--	,[SailFilePath]
--	,[P111FilePath]
--FROM
--	[survey_old].[Preplot]
--GO

--INSERT INTO [survey].[Survey] (
--	[SurveyID]
--	,[survey_name]
--	,[PlannedStartDate]
--	,[PlannedEndDate]
--	,[Field_ID]
--	,[SurveyType_ID]
--	,[EPSGCode]
--	,[VesselOperationalStatus]
--	,[VesselOperationalStatusLastChanged]
--	,[PrmLineStatus]
--	,[PrmLineStatusLastChanged]
--	,[Created]
--	,[CreatedBy]
--	,[Updated]
--	,[UpdatedBy]
--	,[SoftDeleted]
--	,[Archived]
--	,[Description]
--	,[SoftDeletedBy]
--	,[SoftDeletedDate]
--)
--SELECT 
--	[SurveyID]
--	,[survey_name]
--	,[PlannedStartDate]
--	,[PlannedEndDate]
--	,[Field_ID]
--	,[SurveyType_ID]
--	,[EPSGCode]
--	,[VesselOperationalStatus]
--	,[VesselOperationalStatusLastChanged]
--	,[PrmLineStatus]
--	,[PrmLineStatusLastChanged]
--	,[Created]
--	,[CreatedBy]
--	,[Updated]
--	,[UpdatedBy]
--	,0 [SoftDeleted]
--	,0 [Archived]
--	,NULL [Description]
--	,NULL [SoftDeletedBy]
--	,NULL [SoftDeletedDate]
--FROM
--	[survey_old].[Survey]


--INSERT INTO [survey].[SurveyPreplotLink] (
--	[SurveyID]
--	,[PreplotID]
--)
--SELECT
--	[SurveyID]
--	,[PreplotID]
--FROM
--	[survey_old].[SurveyPreplotLink]
--GO

