--DROP EXTERNAL TABLE [acquisition].[ShotInfo]
--GO

--CREATE EXTERNAL TABLE [acquisition].[ShotInfo] (
--    [SurveyID] INT NOT NULL,
--    [ShotInfoID] UNIQUEIDENTIFIER NOT NULL,
--    [type] NVARCHAR (16) NULL,
--    [imo_num] INT NULL,
--    [mmsi_num] INT NULL,
--    [survey_name] NCHAR (7) NULL,
--    [survey_id] INT NULL,
--    [shottime] FLOAT (53) NULL,
--    [shotpoint_num] INT NULL,
--    [sailline_num] INT NULL,
--    [srcline_num] NVARCHAR (1024) NULL,
--    [seq_num] INT NULL,
--    [epsg] INT NULL,
--    [northing] NVARCHAR (MAX) NULL,
--    [easting] NVARCHAR (MAX) NULL,
--    [vessel_speed] FLOAT (53) NULL,
--    [bearing] FLOAT (53) NULL,
--    [water_depth] FLOAT (53) NULL,
--    [src_num] INT NULL,
--    [gun_mask] NVARCHAR (MAX) NULL,
--    [src_delay] NVARCHAR (MAX) NULL,
--    [QaStatus] NVARCHAR (128) NOT NULL,
--    [QaMsg] NVARCHAR (MAX) NULL,
--    [EnqueuedTimeUtc] DATETIME2 (7) NULL,
--    [Created] DATETIME2 (7) NOT NULL,
--    [ShotInfoFilePath] NVARCHAR (128) NULL
--)
--    WITH (
--    DATA_SOURCE = [acquisitions],
--    SCHEMA_NAME = N'acquisition_v',
--    OBJECT_NAME = N'ShotInfo',
--    DISTRIBUTION = SHARDED([SurveyID])
--    );
--GO

--CREATE EXTERNAL TABLE [survey].[MinimalFinalNavigationShotPointDeviation] (
--    [SurveyID] INT NOT NULL,
--    [shotpoint_num] INT NOT NULL,
--    [sailline_num] INT NULL,
--    [srcline_num] NVARCHAR (1024) NULL,
--    [seq_num] INT NULL,
--    [radial_error] FLOAT (53) NULL,
--    [inline_error] FLOAT (53) NULL,
--    [crossline_error] FLOAT (53) NULL,
--    [Created] DATETIME2 (7) NOT NULL
--)
--    WITH (
--    DATA_SOURCE = [acquisitions],
--    SCHEMA_NAME = N'survey_v',
--    OBJECT_NAME = N'MinimalFinalNavigationShotPointDeviation',
--    DISTRIBUTION = SHARDED([SurveyID])
--    );
--GO

--CREATE EXTERNAL TABLE [survey].[MinimalShotInfoDeviation] (
--    [SurveyID] INT NOT NULL,
--    [shotpoint_num] INT NOT NULL,
--    [sailline_num] INT NULL,
--    [srcline_num] NVARCHAR (1024) NULL,
--    [seq_num] INT NULL,
--    [RadialDeviation] NVARCHAR (MAX) NULL,
--    [InlineDeviation] NVARCHAR (MAX) NULL,
--    [CrosslineDeviation] NVARCHAR (MAX) NULL,
--    [Latency] FLOAT (53) NULL,
--    [Created] DATETIME2 (7) NOT NULL
--)
--    WITH (
--    DATA_SOURCE = [acquisitions],
--    SCHEMA_NAME = N'survey_v',
--    OBJECT_NAME = N'MinimalShotInfoDeviation',
--    DISTRIBUTION = SHARDED([SurveyID])
--    );
--GO

