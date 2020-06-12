SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER VIEW  [acquisition_v].[ShotInfoDeviation2] AS 
	SELECT
		S.[SurveyID]
		,S.[ShotInfoID]
		,S.[CrosslineDeviation]
		,S.[InlineDeviation]
		,S.[RadialDeviation]
		,S.[MinGunPressure]
		,S.[MaxGunPressure]
		,S.[MeanGunPressure]
		,S.[Latency]
		,S.[ExGunNumPressure]
		,S.[ExGunNumDepth]
		,S.[MinGunDepth]
		,S.[MaxGunDepth]
		,S.[MeanGunDepth]
		,S.[CrabAngleProxy]
		,S.[ShotInterval]
		,S.[Created]
	FROM
		[acquisition].[ShotInfoDeviation2] AS S WITH (NOLOCK)
		INNER JOIN [acquisition].[LatestShotInfo] AS L WITH (NOLOCK)
			ON S.SurveyID = L.SurveyID
			AND S.ShotInfoID = L.ShotInfoID
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER VIEW [acquisition_v].[ShotInfoMinimal] AS
/*
	WITH LatestShotpoints AS (
		SELECT
			shotpoint_num,
			sailline_num,
			srcline_num,
			MAX(seq_num) seq_num
		FROM
			[acquisition].[ShotInfo] WITH (NOLOCK) -- joined with [acquisition_v].[ShotInfo] in output SELECT
		GROUP BY
			shotpoint_num,
			sailline_num,
			srcline_num
	)

	, LatestShotpointsKeys AS (
		SELECT
			s.ShotInfoID
		FROM
			[acquisition].[ShotInfo] s WITH (NOLOCK) -- joined with [acquisition_v].[ShotInfo] in output SELECT
			JOIN LatestShotpoints l
				ON l.shotpoint_num = s.shotpoint_num
				AND l.sailline_num = s.sailline_num
				AND l.srcline_num = s.srcline_num
				AND l.seq_num = s.seq_num
	)

	SELECT
		i.[SurveyID]
		,[shottime]
		,[shotpoint_num]
		,[sailline_num]
		,CAST((select [value] FROM OPENJSON([srcline_num]) WHERE [key] = 0) AS INT) [srcline_num]
		,[seq_num]
		,i.[created]
		,CAST((select [value] FROM OPENJSON([northing]) WHERE [key] = 0) AS FLOAT) [northing]
		,CAST((select [value] FROM OPENJSON([easting]) WHERE [key] = 0) AS FLOAT) [easting]
		,CAST([InlineDeviation] AS FLOAT) [inline]
		,CAST([CrosslineDeviation] AS FLOAT) [crossline]
		,CAST([RadialDeviation] AS FLOAT) [radial]
		,[Latency] [latency]
	FROM
		LatestShotpointsKeys k
		JOIN [acquisition_v].[ShotInfo] i -- this should limit the output to most recent shots that are on the preplot.
			ON i.ShotInfoID = k.ShotInfoID
		LEFT JOIN [acquisition_v].[ShotInfoDeviation] d
			ON d.SurveyID = i.SurveyID
			AND d.ShotInfoID = i.ShotInfoID

GO
*/

SELECT
	 S.[SurveyID]
	,ROUND(S.[shottime], 2) [shottime]
	,S.[shotpoint_num]
	,S.[sailline_num]
	,CAST((select [value] FROM OPENJSON(S.[srcline_num]) WHERE [key] = 0) AS INT) [srcline_num]
	,S.[seq_num]
	,S.[created]
	,ROUND(CAST((select [value] FROM OPENJSON(S.[northing]) WHERE [key] = 0) AS FLOAT), 2) [northing]
	,ROUND(CAST((select [value] FROM OPENJSON(S.[easting]) WHERE [key] = 0) AS FLOAT), 2) [easting]	
	,ROUND(CAST(D.[InlineDeviation] AS FLOAT), 2) [inline]											
	,ROUND(CAST(D.[CrosslineDeviation] AS FLOAT), 2) [crossline]										
	,ROUND(CAST(D.[RadialDeviation] AS FLOAT), 2) [radial]											
	,ROUND(D.[Latency],0) [latency]
FROM [acquisition].[ShotInfo] AS S WITH (NOLOCK)
INNER JOIN [acquisition].[LatestShotInfo] AS L WITH (NOLOCK)
	ON S.SurveyID = L.SurveyID
	AND S.ShotInfoID = L.ShotInfoID
INNER JOIN survey_v.PreplotShotpoint AS P
	ON P.SurveyID = S.SurveyID
	AND P.sailline_num = S.sailline_num
	AND P.shotpoint_num = S.shotpoint_num
LEFT JOIN [acquisition_v].[ShotInfoDeviation2] AS D
	ON D.SurveyID = S.SurveyID
	AND D.ShotInfoID = S.ShotInfoID
GO


