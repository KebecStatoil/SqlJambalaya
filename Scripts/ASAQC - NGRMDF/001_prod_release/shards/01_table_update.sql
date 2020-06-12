CREATE SCHEMA acquisition_old;
GO
ALTER SCHEMA acquisition_old TRANSFER acquisition.ShotInfo;
GO
ALTER SCHEMA acquisition_old TRANSFER acquisition.ShotInfoDeviation;
GO

/*
 *  [acquisition].[ShotInfo]
 */
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [acquisition].[ShotInfo](
	[SurveyID] [int] NOT NULL,
	[ShotInfoID] [uniqueidentifier] NOT NULL,
	[type] [nvarchar](16) NULL,
	[imo_num] [int] NULL,
	[mmsi_num] [int] NULL,
	[survey_name] [nchar](7) NULL,
	[survey_id] [int] NULL,
	[shottime] [float] NULL,
	[shotpoint_num] [int] NULL,
	[sailline_num] [int] NULL,
	[srcline_num] [nvarchar](1024) NULL,
	[seq_num] [int] NULL,
	[epsg] [int] NULL,
	[northing] [nvarchar](max) NULL,
	[easting] [nvarchar](max) NULL,
	[vessel_speed] [float] NULL,
	[bearing] [float] NULL,
	[water_depth] [float] NULL,
	[src_num] [int] NULL,
	[gun_mask] [nvarchar](max) NULL,
	[src_delay] [nvarchar](max) NULL,
	[QaStatus] [nvarchar](128) NOT NULL,
	[QaMsg] [nvarchar](max) NULL,
	[EnqueuedTimeUtc] [datetime2](7) NULL,
	[Created] [datetime2](7) NOT NULL,
	[ShotInfoFilePath] [nvarchar](128) NULL,
 CONSTRAINT [PK_ShotInfo] PRIMARY KEY CLUSTERED 
(
	[SurveyID] ASC,
	[ShotInfoID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [acquisition].[ShotInfo] ADD  CONSTRAINT [DF_ShotInfo_Created]  DEFAULT (sysutcdatetime()) FOR [Created]
GO


/*
 *  [acquisition].[ShotInfoDeviation]
 */
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
ALTER TABLE [acquisition].[ShotInfoDeviation] ADD  CONSTRAINT [DF_ShotInfoDeviation_Created]  DEFAULT (sysutcdatetime()) FOR [Created]
GO
ALTER TABLE [acquisition].[ShotInfoDeviation]  WITH CHECK ADD  CONSTRAINT [FK_ShotInfoDeviation_ShotInfo] FOREIGN KEY([SurveyID], [ShotInfoID])
REFERENCES [acquisition].[ShotInfo] ([SurveyID], [ShotInfoID])
GO
ALTER TABLE [acquisition].[ShotInfoDeviation] CHECK CONSTRAINT [FK_ShotInfoDeviation_ShotInfo]
GO
CREATE NONCLUSTERED INDEX [IX_ShotInfoDeviation_ShotInfoID]
    ON [acquisition].[ShotInfoDeviation]([ShotInfoID] ASC)
    INCLUDE([InlineDeviation], [CrosslineDeviation], [RadialDeviation], [Latency]);
GO

/*
 *  Copy data over from old [ShotInfo] to new [ShotInfo]
 */
INSERT INTO [acquisition].[ShotInfo] (
	[SurveyID]
	,[ShotInfoID]
	,[type]
	,[imo_num]
	,[mmsi_num]
	,[survey_name]
	,[survey_id]
	,[shottime]
	,[shotpoint_num]
	,[sailline_num]
	,[srcline_num]
	,[seq_num]
	,[epsg]
	,[northing]
	,[easting]
	,[vessel_speed]
	,[bearing]
	,[water_depth]
	,[src_num]
	,[gun_mask]
	,[src_delay]
	,[QaStatus]
	,[QaMsg]
	,[EnqueuedTimeUtc]
	,[Created]
	,[ShotInfoFilePath]
)
SELECT
	[SurveyID]
	,[ShotInfoID]
	,[type]
	,[imo_num]
	,[mmsi_num]
	,[survey_name]
	,[survey_id]
	,[shottime]
	,[shotpoint_num]
	,[sailline_num]
	,[srcline_num]
	,[seq_num]
	,[epsg]
	,[northing]
	,[easting]
	,[vessel_speed]
	,[bearing]
	,[water_depth]
	,[src_num]
	,[gun_mask]
	,[src_delay]
	,[QaStatus]
	,[QaMsg]
	,[EnqueuedTimeUtc]
	,[Created]
	,null
FROM 
	[acquisition_old].[ShotInfo]
GO

/*
 *  Copy data over from old [ShotInfoDeviation] to new [ShotInfoDeviation]
 */
INSERT INTO [acquisition].[ShotInfoDeviation] (
	[SurveyID]
	,[ShotInfoID]
	,[InlineDeviation]
	,[CrosslineDeviation]
	,[RadialDeviation]
	,[Latency]
	,[Created]
	,[InlineDeviationOutOfSpec]
	,[CrosslineDeviationOutOfSpec]
	,[GunDepthOutOfSpec]
	,[GunPressureOutOfSpec]
	,[MinGunDepthDeviation]
	,[MinGunPressureDeviation]
	,[MaxGunDepthDeviation]
	,[MaxGunPressureDeviation]
	,[AverageGunDepthDeviation]
	,[AverageGunPressureDeviation]
	,[StdevGunDepthDeviation]
	,[StdevGunPressureDeviation]
)
SELECT
	[SurveyID]
	,[ShotInfoID]
	,[InlineDeviation]
	,[CrosslineDeviation]
	,[RadialDeviation]
	,[Latency]
	,[Created]
	,[InlineDeviationOutOfSpec]
	,[CrosslineDeviationOutOfSpec]
	,[GunDepthOutOfSpec]
	,[GunPressureOutOfSpec]
	,[MinGunDepthDeviation]
	,[MinGunPressureDeviation]
	,[MaxGunDepthDeviation]
	,[MaxGunPressureDeviation]
	,[AverageGunDepthDeviation]
	,[AverageGunPressureDeviation]
	,[StdevGunDepthDeviation]
	,[StdevGunPressureDeviation]
FROM
	[acquisition_old].[ShotInfoDeviation]
GO


/*
 *  point FKeys to new tables
 */
ALTER TABLE [acquisition].[GunInfo] DROP CONSTRAINT [FK_GunInfo_ShotInfo]
GO
ALTER TABLE [acquisition].[GunInfo]  WITH NOCHECK ADD  CONSTRAINT [FK_GunInfo_ShotInfo] FOREIGN KEY([SurveyID], [ShotInfoID])
REFERENCES [acquisition].[ShotInfo] ([SurveyID], [ShotInfoID])
GO
ALTER TABLE [acquisition].[GunInfo] CHECK CONSTRAINT [FK_GunInfo_ShotInfo]
GO
ALTER TABLE [acquisition].[LatestShotInfo] DROP CONSTRAINT [FK_LatestShotInfo_ShotInfo]
GO
ALTER TABLE [acquisition].[LatestShotInfo]  WITH CHECK ADD  CONSTRAINT [FK_LatestShotInfo_ShotInfo] FOREIGN KEY([SurveyID], [ShotInfoID])
REFERENCES [acquisition].[ShotInfo] ([SurveyID], [ShotInfoID])
GO
ALTER TABLE [acquisition].[LatestShotInfo] CHECK CONSTRAINT [FK_LatestShotInfo_ShotInfo]
GO

/*
 *  New table [survey].[Events]
 */
CREATE TABLE [survey].[Events] (
    [EventID]         UNIQUEIDENTIFIER CONSTRAINT [DF_Events_EventID] DEFAULT (newid()) NOT NULL,
    [seq_num]         INT              NULL,
    [sailline_num]    INT              NULL,
    [type]            NVARCHAR (128)   NULL,
    [version]         NVARCHAR (10)    NULL,
    [createdutc]      FLOAT (53)       NULL,
    [event_data_json] NVARCHAR (MAX)   NULL,
    CONSTRAINT [PK_Events] PRIMARY KEY CLUSTERED ([EventID] ASC)
);
GO