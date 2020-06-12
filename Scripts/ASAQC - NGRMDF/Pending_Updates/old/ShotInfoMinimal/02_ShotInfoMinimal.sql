/****** Object:  View [acquisition_v].[ShotInfoMinimal]    Script Date: 27.06.2019 10:56:30 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE OR ALTER VIEW [acquisition_v].[ShotInfoMinimal] AS
SELECT
	i.[SurveyID]
	,[shottime]
	,[shotpoint_num]
	,[sailline_num]
	,CAST((select [value] FROM OPENJSON([srcline_num]) WHERE [key] = 0) AS INT) [srcline_num]
	,[seq_num]
	,d.[created]
	,CAST((select [value] FROM OPENJSON([northing]) WHERE [key] = 0) AS FLOAT) [northing]
	,CAST((select [value] FROM OPENJSON([easting]) WHERE [key] = 0) AS FLOAT) [easting]
	,CAST([InlineDeviation] AS FLOAT) [inline]
	,CAST([CrosslineDeviation] AS FLOAT) [crossline]
	,CAST([RadialDeviation] AS FLOAT) [radial]
	,[Latency] [latency]
FROM
	[acquisition_v].[ShotInfo] i
	LEFT JOIN [acquisition_v].[ShotInfoDeviation] d
		ON d.SurveyID = i.SurveyID
		AND d.ShotInfoID = i.ShotInfoID
GO


