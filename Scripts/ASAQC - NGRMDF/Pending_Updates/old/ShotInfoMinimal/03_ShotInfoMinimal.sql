/****** Object:  Table [acquisition].[ShotInfoMinimal]    Script Date: 27.06.2019 11:23:40 ******/
DROP EXTERNAL TABLE [acquisition].[ShotInfoMinimal]
GO

/****** Object:  Table [acquisition].[ShotInfoMinimal]    Script Date: 27.06.2019 11:23:40 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

CREATE EXTERNAL TABLE [acquisition].[ShotInfoMinimal]
(
	[SurveyID] [int] NOT NULL,
	[shottime] [float] NULL,
	[shotpoint_num] [int] NULL,
	[sailline_num] [int] NULL,
	[srcline_num] [int] NULL,
	[seq_num] [int] NULL,
	[created] [datetime2](7) NULL,
	[northing] [float] NULL,
	[easting] [float] NULL,
	[inline] [float] NULL,
	[crossline] [float] NULL,
	[radial] [float] NULL,
	[latency] [float] NULL
)
WITH (DATA_SOURCE = [acquisitions],DISTRIBUTION = SHARDED([SurveyID]),SCHEMA_NAME = N'acquisition_v',OBJECT_NAME = N'ShotInfoMinimal')
GO


