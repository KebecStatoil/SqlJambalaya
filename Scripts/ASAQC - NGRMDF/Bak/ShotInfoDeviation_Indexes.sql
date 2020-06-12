/****** Object:  Table [acquisition].[ShotInfoDeviation]    Script Date: 27.11.2019 14:29:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [acquisition].[ShotInfoDeviation](
	[SurveyID] [int] NOT NULL,
	[ShotInfoID] [uniqueidentifier] NOT NULL,
	[InlineDeviation] [nvarchar](max) NULL,
	[CrosslineDeviation] [nvarchar](max) NULL,
	[RadialDeviation] [nvarchar](max) NULL,
	[Latency] [float] NULL,
	[Created] [datetime2](7) NOT NULL,
	[InlineDeviationOutOfSpec] [bit] NULL,
	[CrosslineDeviationOutOfSpec] [bit] NULL,
	[GunDepthOutOfSpec] [bit] NULL,
	[GunPressureOutOfSpec] [bit] NULL,
	[MinGunDepthDeviation] [nvarchar](max) NULL,
	[MinGunPressureDeviation] [nvarchar](max) NULL,
	[MaxGunDepthDeviation] [nvarchar](max) NULL,
	[MaxGunPressureDeviation] [nvarchar](max) NULL,
	[AverageGunDepthDeviation] [nvarchar](max) NULL,
	[AverageGunPressureDeviation] [nvarchar](max) NULL,
	[StdevGunDepthDeviation] [nvarchar](max) NULL,
	[StdevGunPressureDeviation] [nvarchar](max) NULL,
 CONSTRAINT [PK_ShotInfoDeviation] PRIMARY KEY CLUSTERED 
(
	[SurveyID] ASC,
	[ShotInfoID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Index [IX_ShotInfoDeviation_CrosslineDeviationOutOfSpec]    Script Date: 27.11.2019 14:29:10 ******/
CREATE NONCLUSTERED INDEX [IX_ShotInfoDeviation_CrosslineDeviationOutOfSpec] ON [acquisition].[ShotInfoDeviation]
(
	[SurveyID] ASC,
	[ShotInfoID] ASC
)
WHERE ([CrosslineDeviationOutOfSpec]=(1))
WITH (STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_ShotInfoDeviation_GunDepthOutOfSpec]    Script Date: 27.11.2019 14:29:10 ******/
CREATE NONCLUSTERED INDEX [IX_ShotInfoDeviation_GunDepthOutOfSpec] ON [acquisition].[ShotInfoDeviation]
(
	[SurveyID] ASC,
	[ShotInfoID] ASC
)
WHERE ([GunDepthOutOfSpec]=(1))
WITH (STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_ShotInfoDeviation_GunPressureOutOfSpec]    Script Date: 27.11.2019 14:29:10 ******/
CREATE NONCLUSTERED INDEX [IX_ShotInfoDeviation_GunPressureOutOfSpec] ON [acquisition].[ShotInfoDeviation]
(
	[SurveyID] ASC,
	[ShotInfoID] ASC
)
WHERE ([GunPressureOutOfSpec]=(1))
WITH (STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_ShotInfoDeviation_InlineDeviationOutOfSpec]    Script Date: 27.11.2019 14:29:10 ******/
CREATE NONCLUSTERED INDEX [IX_ShotInfoDeviation_InlineDeviationOutOfSpec] ON [acquisition].[ShotInfoDeviation]
(
	[SurveyID] ASC,
	[ShotInfoID] ASC
)
WHERE ([InlineDeviationOutOfSpec]=(1))
WITH (STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_ShotInfoDeviation_ShotInfoID]    Script Date: 27.11.2019 14:29:10 ******/
CREATE NONCLUSTERED INDEX [IX_ShotInfoDeviation_ShotInfoID] ON [acquisition].[ShotInfoDeviation]
(
	[ShotInfoID] ASC
)
INCLUDE([InlineDeviation],[CrosslineDeviation],[RadialDeviation],[Latency]) WITH (STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
GO
ALTER TABLE [acquisition].[ShotInfoDeviation] ADD  CONSTRAINT [DF_ShotInfoDeviation_Created]  DEFAULT (sysutcdatetime()) FOR [Created]
GO
ALTER TABLE [acquisition].[ShotInfoDeviation]  WITH NOCHECK ADD  CONSTRAINT [FK_ShotInfoDeviation_ShotInfo] FOREIGN KEY([SurveyID], [ShotInfoID])
REFERENCES [acquisition].[ShotInfo] ([SurveyID], [ShotInfoID])
GO
ALTER TABLE [acquisition].[ShotInfoDeviation] CHECK CONSTRAINT [FK_ShotInfoDeviation_ShotInfo]
GO
