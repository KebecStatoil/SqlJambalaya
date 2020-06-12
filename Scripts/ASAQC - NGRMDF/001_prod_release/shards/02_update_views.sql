GRANT SELECT
    ON SCHEMA::[acquisition_v] TO [shards_data_writer];
GO

/****** Object:  View [survey_v].[PreplotShotpoint]    Script Date: 09.12.2019 10:44:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER VIEW [survey_v].[PreplotShotpoint] AS
	SELECT
		[SurveyID],
		[PreplotID],
		[srcline_num],
		[shotpoint_num],
		[src_easting],
		[src_northing],
		[sailline_num],
		[sail_easting],
		[sail_northing]
	FROM [survey].[PreplotShotpoint] WITH (NOLOCK)
GO
/****** Object:  View [acquisition_v].[ShotInfo]    Script Date: 09.12.2019 10:44:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER VIEW [acquisition_v].[ShotInfo] AS
	SELECT
		S.[SurveyID],
		S.[ShotInfoID],
		S.[type],
		S.[imo_num],
		S.[mmsi_num],
		S.[survey_name],
		S.[survey_id],
		S.[shottime],
		S.[shotpoint_num],
		S.[sailline_num],
		S.[srcline_num],
		S.[seq_num],
		S.[epsg],
		S.[northing],
		S.[easting],
		S.[vessel_speed],
		S.[bearing],
		S.[water_depth],
		S.[src_num],
		S.[gun_mask],
		S.[src_delay],
		S.[QaStatus],
		S.[QaMsg],
		S.[EnqueuedTimeUtc],
		S.[Created],
		S.[ShotInfoFilePath]
	FROM [acquisition].[ShotInfo] AS S WITH (NOLOCK)
	INNER JOIN [acquisition].[LatestShotInfo] AS L WITH (NOLOCK)
		ON S.SurveyID = L.SurveyID
      AND S.ShotInfoID = L.ShotInfoID
		JOIN survey_v.PreplotShotpoint P
			ON P.SurveyID = S.SurveyID
			AND P.sailline_num = S.sailline_num
			AND P.shotpoint_num = S.shotpoint_num
			--AND P.srcline_num = json_value(S.srcline_num, '$[0]')
GO
/****** Object:  View [acquisition_v].[ShotInfoDeviation]    Script Date: 09.12.2019 10:44:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER VIEW [acquisition_v].[ShotInfoDeviation] AS
	SELECT
    S.[SurveyID],
    S.[ShotInfoID],
    S.[InlineDeviation],
    S.[CrosslineDeviation],
    S.[RadialDeviation],
    S.[MinGunDepthDeviation],
    S.[MinGunPressureDeviation],
    S.[MaxGunDepthDeviation],
    S.[MaxGunPressureDeviation],
    S.[AverageGunDepthDeviation],
    S.[AverageGunPressureDeviation],
    S.[StdevGunDepthDeviation],
    S.[StdevGunPressureDeviation],
    S.[InlineDeviationOutOfSpec],
    S.[CrosslineDeviationOutOfSpec],
    S.[GunDepthOutOfSpec],
    S.[GunPressureOutOfSpec],
    S.[Latency],
    S.[Created]
	FROM [acquisition].[ShotInfoDeviation] AS S WITH (NOLOCK)
	INNER JOIN [acquisition].[LatestShotInfo] AS L WITH (NOLOCK)
		ON S.SurveyID = L.SurveyID
      AND S.ShotInfoID = L.ShotInfoID
GO
/****** Object:  View [acquisition_v].[SailLineAggregateDeviation]    Script Date: 09.12.2019 10:44:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER VIEW [acquisition_v].[SailLineAggregateDeviation] AS
WITH ShotInfoDeviations
AS (
  SELECT
    i.[SurveyID],
    i.[shotpoint_num],
    i.[survey_name],
    i.[sailline_num],
    i.[seq_num],
    CAST(d.[InlineDeviation] AS FLOAT) AS [InlineDeviation],
    CAST(d.[CrosslineDeviation] AS FLOAT) AS [CrosslineDeviation],
    CAST(d.[RadialDeviation] AS FLOAT) AS [RadialDeviation],
    CAST(d.[MinGunDepthDeviation] AS FLOAT) AS [MinGunDepthDeviation],
    CAST(d.[MinGunPressureDeviation] AS FLOAT) AS [MinGunPressureDeviation],
    CAST(d.[MaxGunDepthDeviation] AS FLOAT) AS [MaxGunDepthDeviation],
    CAST(d.[MaxGunPressureDeviation] AS FLOAT) AS [MaxGunPressureDeviation],
    CAST(d.[AverageGunDepthDeviation] AS FLOAT) AS [AverageGunDepthDeviation],
    CAST(d.[AverageGunPressureDeviation] AS FLOAT) AS [AverageGunPressureDeviation],
    CAST(d.[StdevGunDepthDeviation] AS FLOAT) AS [StdevGunDepthDeviation],
    CAST(d.[StdevGunPressureDeviation] AS FLOAT) AS [StdevGunPressureDeviation],
    d.[InlineDeviationOutOfSpec],
    d.[CrosslineDeviationOutOfSpec],
    d.[GunDepthOutOfSpec],
    d.[GunPressureOutOfSpec],
    d.[Latency],
    i.[Created]
  FROM [acquisition_v].[ShotInfoDeviation] AS d
  RIGHT JOIN [acquisition_v].[ShotInfo] AS i
    ON i.SurveyID = d.SurveyID
     AND i.ShotInfoID = d.ShotInfoID
  ),
LineDeviationAggregates
AS (
  SELECT
    [SurveyID],
    [survey_name],
    [sailline_num],
    [seq_num],
    COUNT(*) AS [NumberOfShots],
    AVG([InlineDeviation]) AS [AverageInlineDeviation],
    AVG([CrosslineDeviation]) AS [AverageCrosslineDeviation],
    AVG([RadialDeviation]) AS [AverageRadialDeviation],
    AVG([AverageGunDepthDeviation]) AS [AverageGunDepthDeviation],
    AVG([AverageGunPressureDeviation]) AS [AverageGunPressureDeviation],
    AVG([Latency]) AS [AverageLatency],
    MIN([InlineDeviation]) AS [MinInlineDeviation],
    MIN([CrosslineDeviation]) AS [MinCrosslineDeviation],
    MIN([RadialDeviation]) AS [MinRadialDeviation],
    MIN([MinGunDepthDeviation]) AS [MinGunDepthDeviation],
    MIN([MinGunPressureDeviation]) AS [MinGunPressureDeviation],
    MIN([Latency]) AS [MinLatency],
    MAX([InlineDeviation]) AS [MaxInlineDeviation],
    MAX([CrosslineDeviation]) AS [MaxCrosslineDeviation],
    MAX([RadialDeviation]) AS [MaxRadialDeviation],
    MAX([MaxGunDepthDeviation]) AS [MaxGunDepthDeviation],
    MAX([MaxGunPressureDeviation]) AS [MaxGunPressureDeviation],
    MAX([Latency]) AS [MaxLatency],
    STDEV([InlineDeviation]) AS [StdevInlineDeviation],
    STDEV([CrosslineDeviation]) AS [StdevCrosslineDeviation],
    STDEV([RadialDeviation]) AS [StdevRadialDeviation],
    STDEV([AverageGunDepthDeviation]) AS [StdevGunDepthDeviation],
    STDEV([AverageGunPressureDeviation]) AS [StdevGunPressureDeviation],
    STDEV([Latency]) AS [StdevLatency],
    MAX(Created) AS [Created],
    CAST('System_Created' AS NVARCHAR(128)) AS [CreatedBy],
    ROW_NUMBER() OVER (
      ORDER BY [seq_num] DESC
      ) AS [RowNum]
  FROM ShotInfoDeviations
  GROUP BY
    [SurveyID],
    [survey_name],
    [sailline_num],
    [seq_num]
  ),
OutsideCrosslineSpecJson
AS (
  SELECT
    [seq_num],
    '[' + string_agg(cast([shotpoint_num] as nvarchar(max)), ',') + ']' AS OutOfSpecShots
  FROM ShotInfoDeviations
  WHERE CrosslineDeviationOutOfSpec = 1
  GROUP BY [seq_num]
  ),
OutsideInlineSpecJson
AS (
  SELECT
     [seq_num],
    '[' + string_agg(cast([shotpoint_num] as nvarchar(max)), ',') + ']' AS OutOfSpecShots
  FROM ShotInfoDeviations
  WHERE InlineDeviationOutOfSpec = 1
  GROUP BY [seq_num]
  ),
OutsideDepthSpecJson
AS (
  SELECT
    [seq_num],
    '[' + string_agg(cast([shotpoint_num] as nvarchar(max)), ',') + ']' AS OutOfSpecShots
  FROM ShotInfoDeviations
  WHERE GunDepthOutOfSpec = 1
  GROUP BY [seq_num]
  ),
OutsidePressureSpecJson
AS (
  SELECT
    [seq_num],
    '[' + string_agg(cast([shotpoint_num] as nvarchar(max)), ',') + ']' AS OutOfSpecShots
  FROM ShotInfoDeviations
  WHERE GunPressureOutOfSpec = 1
  GROUP BY [seq_num]
  )
SELECT
  ld.[SurveyID],
  ld.[survey_name],
  ld.[sailline_num],
  ld.[seq_num],
  ld.[NumberOfShots],
  ld.[AverageInlineDeviation],
  ld.[AverageCrosslineDeviation],
  ld.[AverageRadialDeviation],
  ld.[AverageGunDepthDeviation],
  ld.[AverageGunPressureDeviation],
  ld.[AverageLatency],
  ld.[MinInlineDeviation],
  ld.[MinCrosslineDeviation],
  ld.[MinRadialDeviation],
  ld.[MinGunDepthDeviation],
  ld.[MinGunPressureDeviation],
  ld.[MinLatency],
  ld.[MaxInlineDeviation],
  ld.[MaxCrosslineDeviation],
  ld.[MaxRadialDeviation],
  ld.[MaxGunDepthDeviation],
  ld.[MaxGunPressureDeviation],
  ld.[MaxLatency],
  ld.[StdevInlineDeviation],
  ld.[StdevCrosslineDeviation],
  ld.[StdevRadialDeviation],
  ld.[StdevGunDepthDeviation],
  ld.[StdevGunPressureDeviation],
  ld.[StdevLatency],
  cl.[OutOfSpecShots] AS [OutsideCrosslineSpec],
  il.[OutOfSpecShots] AS [OutsideInlineSpec],
  d.[OutOfSpecShots] AS [OutsideDepthSpec],
  p.[OutOfSpecShots] AS [OutsidePressureSpec],
  ld.[Created],
  ld.[CreatedBy],
  ld.[RowNum]
FROM LineDeviationAggregates AS ld
LEFT JOIN OutsideCrosslineSpecJson AS cl
  ON ld.[seq_num] = cl.[seq_num]
LEFT JOIN OutsideInlineSpecJson AS il
  ON ld.[seq_num] = il.[seq_num]
LEFT JOIN OutsideDepthSpecJson AS d
  ON ld.[seq_num] = d.[seq_num]
LEFT JOIN OutsidePressureSpecJson AS p
  ON ld.[seq_num] = p.[seq_num]
GO
/****** Object:  View [survey_v].[AggregatedEvent]    Script Date: 09.12.2019 10:44:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER VIEW [survey_v].[AggregatedEvent] AS
SELECT
  [SurveyID],
  [survey_name] AS [SurveyName],
  newid() AS [EventID], -- this is pointless in this context but is part of the API
  CAST('Aggregated deviations for Sail Line: ' + CAST([sailline_num] AS NVARCHAR(max)) +
       ', Sequence Number: ' + CAST([seq_num] AS NVARCHAR(max)) AS NVARCHAR(max)) AS [event_text],
  CAST('event.aggregated.sailline' AS NVARCHAR(128)) AS [event_type],
  CAST('aggregate.sailline' AS NVARCHAR(128)) AS [aggregate_type],
  (
    SELECT
      [sailline_num],
      [seq_num],
      [NumberOfShots],
      [AverageInlineDeviation],
      [AverageCrosslineDeviation],
      [AverageRadialDeviation],
      [AverageGunDepthDeviation],
      [AverageGunPressureDeviation],
      [AverageLatency],
      [MinInlineDeviation],
      [MinCrosslineDeviation],
      [MinRadialDeviation],
      [MinGunDepthDeviation],
      [MinGunPressureDeviation],
      [MinLatency],
      [MaxInlineDeviation],
      [MaxCrosslineDeviation],
      [MaxRadialDeviation],
      [MaxGunDepthDeviation],
      [MaxGunPressureDeviation],
      [MaxLatency],
      [StdevInlineDeviation],
      [StdevCrosslineDeviation],
      [StdevRadialDeviation],
      [StdevGunDepthDeviation],
      [StdevGunPressureDeviation],
      [StdevLatency],
      [OutsideCrosslineSpec],
      [OutsideInlineSpec],
      [OutsideDepthSpec],
      [OutsidePressureSpec]
    FOR JSON PATH, WITHOUT_ARRAY_WRAPPER) AS [Payload],
  [Created],
  [CreatedBy],
  [RowNum]
FROM [acquisition_v].[SailLineAggregateDeviation] AS e
GO
/****** Object:  View [acquisition_v].[NextShotInfo]    Script Date: 09.12.2019 10:44:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE OR ALTER VIEW [acquisition_v].[NextShotInfo] AS
SELECT
	t.SurveyID,
	t.ShotTimeNumber,
	t.ShotInfoID,
	t.shottime,
	next_t.ShotTimeNumber NextShotTimeNumber,
	next_t.ShotInfoID NextShotInfoID,
	next_t.shottime NextShotTime
FROM
	(
		SELECT
			SurveyID,
			ROW_NUMBER() OVER(ORDER BY shottime, Created DESC) AS ShotTimeNumber,
			ShotInfoID,
			shottime
		FROM
		acquisition_v.ShotInfo
	) t LEFT JOIN (
		SELECT
			ROW_NUMBER() OVER(ORDER BY shottime, Created DESC) AS ShotTimeNumber,
			ShotInfoID,
			shottime
		FROM
		acquisition_v.ShotInfo
	) next_t
		on t.ShotTimeNumber + 1 = next_t.ShotTimeNumber

GO
/****** Object:  View [acquisition_v].[GunInfo]    Script Date: 09.12.2019 10:44:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER VIEW [acquisition_v].[GunInfo] AS
	SELECT
		[SurveyID],
		[ShotInfoID],
		[subarray_num],
		[gun_num],
		[gun_mask],
		[gun_depth],
		[gun_pressure]
	FROM [acquisition].[GunInfo] WITH (NOLOCK)
GO
/****** Object:  View [acquisition_v].[ShotInfoExtended]    Script Date: 09.12.2019 10:44:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER VIEW [acquisition_v].[ShotInfoExtended] AS

	SELECT
		SurveyID,
		ShotInfoID,
		type,
		imo_num,
		mmsi_num,
		survey_name,
		survey_id,
		shottime,
		shotpoint_num,
		sailline_num,
		seq_num,
		epsg,
		northing,
		srcline_num,
		easting,
		bearing,
		vessel_speed,
		water_depth,
		src_num,
		gun_mask,
		src_delay,
		(
			SELECT
				InlineDeviation inline,
				CrosslineDeviation crossline,
				RadialDeviation radial,
				Latency latency
			FROM
				acquisition_v.ShotInfoDeviation d
			WHERE
				d.ShotInfoID = s.ShotInfoID
			FOR
				JSON AUTO , WITHOUT_ARRAY_WRAPPER
		) deviation,
		(
			SELECT
				subarray_num,
				gun_num,
				gun_mask,
				gun_depth,
				gun_pressure
			FROM
				acquisition_v.GunInfo g
			WHERE
				g.ShotInfoID = s.ShotInfoID
			FOR
				JSON AUTO
		) guninfo

	FROM
		acquisition_v.ShotInfo s


GO
/****** Object:  View [acquisition_v].[ShotInfoMinimal]    Script Date: 09.12.2019 10:44:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE OR ALTER VIEW [acquisition_v].[ShotInfoMinimal] AS

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
/****** Object:  View [acquisition_v].[ShotInfoWithGunInfo]    Script Date: 09.12.2019 10:44:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER VIEW [acquisition_v].[ShotInfoWithGunInfo] AS

	SELECT
		SurveyID,
		type,
		imo_num,
		mmsi_num,
		survey_name,
		survey_id,
		shottime,
		shotpoint_num,
		sailline_num,
		seq_num,
		epsg,
		northing,
		srcline_num,
		easting,
		bearing,
		vessel_speed,
		water_depth,
		src_num,
		gun_mask,
		src_delay,
		(
			SELECT
				subarray_num,
				gun_num,
				gun_mask,
				gun_depth,
				gun_pressure
			FROM
				acquisition_v.GunInfo g
			WHERE
				g.ShotInfoID = s.ShotInfoID
			FOR
				JSON AUTO
		) guninfo
	FROM
		acquisition_v.ShotInfo s

GO
/****** Object:  View [survey_v].[UserEvent]    Script Date: 09.12.2019 10:44:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE OR ALTER VIEW [survey_v].[UserEvent] AS
	SELECT
		[SurveyID],
		[EventID],
		[Comment]
	FROM [survey].[UserEvent] WITH (NOLOCK)
GO
/****** Object:  View [survey_v].[Event]    Script Date: 09.12.2019 10:44:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE OR ALTER VIEW [survey_v].[Event] AS
	SELECT
		[SurveyID],
		[EventID],
		[survey_name],
		[event_text],
		[event_type],
		[Created],
		[CreatedBy],
		[RelatedEvents]
	FROM [survey].[Event] WITH (NOLOCK)
GO
/****** Object:  View [survey_v].[UserEventCombined]    Script Date: 09.12.2019 10:44:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER VIEW [survey_v].[UserEventCombined] AS

SELECT
		E.SurveyID
		,E.EventID
		,E.event_text
		,E.event_type
		,E.Created
		,E.CreatedBy
		,E.RelatedEvents
		,U.Comment
		,ROW_NUMBER() OVER (ORDER BY CREATED DESC) AS RowNum
	FROM survey_v.Event AS E
	INNER JOIN survey_v.UserEvent AS U
		ON U.SurveyID = E.SurveyID
			AND U.EventID = E.EventID
GO
/****** Object:  View [survey_v].[AggregateTypes]    Script Date: 09.12.2019 10:44:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE OR ALTER VIEW [survey_v].[AggregateTypes] AS

SELECT DISTINCT
	aggregate_type, SurveyID
	FROM survey_v.AggregatedEvent
GO
/****** Object:  View [survey_v].[EventTypes]    Script Date: 09.12.2019 10:44:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER VIEW [survey_v].[EventTypes] AS

SELECT DISTINCT
	event_type,
	surveyID
	FROM survey_v.Event
GO
/****** Object:  View [survey_v].[AttachmentEvent]    Script Date: 09.12.2019 10:44:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER VIEW [survey_v].[AttachmentEvent] AS
	SELECT
		[SurveyID],
		[EventID],
		[SurveyName],
		[Path]
	FROM [survey].[AttachmentEvent] WITH (NOLOCK)
GO
/****** Object:  View [survey_v].[SystemEvent]    Script Date: 09.12.2019 10:44:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER VIEW [survey_v].[SystemEvent] AS
	SELECT
		[SurveyID],
		[EventID],
		[payload]
	FROM [survey].[SystemEvent] WITH (NOLOCK)
GO
/****** Object:  View [survey_v].[AllEventsCombined]    Script Date: 09.12.2019 10:44:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER VIEW [survey_v].[AllEventsCombined]
AS
WITH AllEvents AS (
	SELECT
			 E.SurveyID
			,E.EventID
			,E.event_text
			,E.event_type
			,E.Created
			,E.CreatedBy
			,E.RelatedEvents
			,U.Comment
			,S.payload
			,A.Path
			,NULL AS aggregate_type
		FROM
			survey_v.Event AS E
			LEFT JOIN survey_v.SystemEvent AS S
				ON S.EventID = E.EventID
			LEFT JOIN survey_v.AttachmentEvent AS A
				ON A.EventID = E.EventID
			LEFT JOIN survey_v.UserEvent AS U
				ON U.EventID = E.EventID
		WHERE
			E.event_type <> 'event.system.shotpoint'

	UNION ALL

	SELECT
			 A.SurveyID
			,A.EventID
			,A.event_text
			,A.event_type
			,A.Created
			,A.CreatedBy
			,NULL AS RelatedEvents
			,NULL AS Comment
			,A.Payload
			,NULL AS Path
			,A.aggregate_type
		FROM survey_v.AggregatedEvent AS A
)

SELECT *, ROW_NUMBER() OVER (ORDER BY E.CREATED DESC) AS RowNum
	FROM AllEvents AS E
GO
/****** Object:  View [survey_v].[AttachmentEventCombined]    Script Date: 09.12.2019 10:44:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER VIEW [survey_v].[AttachmentEventCombined] AS
SELECT
		E.SurveyID
		,E.EventID
		,E.event_text
		,E.event_type
		,E.Created
		,E.CreatedBy
		,E.RelatedEvents
		,A.SurveyName
		,A.Path
		,ROW_NUMBER() OVER (ORDER BY CREATED DESC) AS RowNum
	FROM survey_v.Event AS E
	INNER JOIN survey_v.AttachmentEvent AS A
		ON A.SurveyID = E.SurveyID
			AND A.EventID = E.EventID

GO
/****** Object:  View [survey_v].[SystemEventCombined]    Script Date: 09.12.2019 10:44:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER VIEW [survey_v].[SystemEventCombined] AS

SELECT
		E.SurveyID
		,E.EventID
		,E.event_text
		,E.event_type
		,E.Created
		,E.CreatedBy
		,E.RelatedEvents
		,S.Payload
		,ROW_NUMBER() OVER (ORDER BY CREATED DESC) AS RowNum
	FROM survey_v.Event AS E
	INNER JOIN survey_v.SystemEvent AS S
		ON S.SurveyID = E.SurveyID
			AND S.EventID = E.EventID

GO
/****** Object:  View [acquisition_v].[LatestShotInfo]    Script Date: 09.12.2019 10:44:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER VIEW [acquisition_v].[LatestShotInfo] AS
	SELECT
		[SurveyID],
		[ShotInfoID],
		[shotpoint_num],
		[sailline_num],
		[srcline_num],
		[seq_num],
    [EnqueuedTimeUtc],
		[Created]
  FROM [acquisition].[LatestShotInfo] WITH (NOLOCK);
GO
/****** Object:  View [survey_v].[MinimalShotInfoDeviation]    Script Date: 09.12.2019 10:44:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER VIEW [survey_v].[MinimalShotInfoDeviation]
AS
SELECT DISTINCT S.SurveyID, S.shotpoint_num, S.sailline_num, S.srcline_num, S.seq_num, D.RadialDeviation, D.CrosslineDeviation, D.InlineDeviation, D.Latency, D.[Created]
	FROM [acquisition_v].[LatestShotInfo] AS S
	INNER JOIN [acquisition_v].[ShotInfoDeviation] AS D
		ON D.ShotInfoID = S.ShotInfoID
GO
/****** Object:  View [acquisition_v].[FinalNavigationShotPointDeviation]    Script Date: 09.12.2019 10:44:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER VIEW [acquisition_v].[FinalNavigationShotPointDeviation] AS
	SELECT
		[SurveyID],
		[FinalNavigationID],
		[shotpoint_num],
		[sailline_num],
		[seq_num],
		[radial_error],
		[inline_error],
		[crossline_error],
		[Created]
	FROM [acquisition].[FinalNavigationShotPointDeviation] WITH (NOLOCK)
GO
/****** Object:  View [survey_v].[MinimalFinalNavigationShotPointDeviation]    Script Date: 09.12.2019 10:44:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER VIEW [survey_v].[MinimalFinalNavigationShotPointDeviation]
AS
SELECT DISTINCT S.SurveyID, S.shotpoint_num, S.sailline_num, S.srcline_num, S.seq_num, D.radial_error, D.inline_error, D.crossline_error, D.[Created]
	FROM [acquisition_v].[LatestShotInfo] AS S
	INNER JOIN [acquisition_v].[FinalNavigationShotPointDeviation] AS D
		ON D.Sailline_num = S.sailline_num
		AND D.shotpoint_num = S.shotpoint_num
		AND D.seq_num = S.seq_num
GO
/****** Object:  View [acquisition_v].[FinalNavigation]    Script Date: 09.12.2019 10:44:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER VIEW [acquisition_v].[FinalNavigation] AS
	SELECT
		[SurveyID],
		[FinalNavigationID],
		[QaStatus],
		[QaMsg]
	FROM [acquisition].[FinalNavigation] WITH (NOLOCK)
GO
/****** Object:  View [acquisition_v].[FinalNavigationShotPoint]    Script Date: 09.12.2019 10:44:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER VIEW [acquisition_v].[FinalNavigationShotPoint] AS
	SELECT
		[SurveyID],
		[FinalNavigationID],
		[sailline_name],
		[shotpoint_num],
		[shottime],
		[src_easting],
		[src_northing],
		[src_depth],
		[sailline_num],
		[seq_num]
	FROM [acquisition].[FinalNavigationShotPoint] WITH (NOLOCK)
GO
/****** Object:  View [acquisition_v].[FinalNavigationSummary]    Script Date: 09.12.2019 10:44:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER VIEW [acquisition_v].[FinalNavigationSummary] AS
	SELECT
		[SurveyID],
		[FinalNavigationID],
		[sailline_num],
		[radial_error_min],
		[radial_error_max],
		[radial_error_mean],
		[radial_error_std_dev],
		[inline_error_min],
		[inline_error_max],
		[inline_error_mean],
		[inline_error_std_dev]
		[crossline_error_min],
		[crossline_error_max],
		[crossline_error_mean],
		[crossline_error_std_dev]
	FROM [acquisition].[FinalNavigationSummary] WITH (NOLOCK)
GO
/****** Object:  View [acquisition_v].[Navigation]    Script Date: 09.12.2019 10:44:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER VIEW [acquisition_v].[Navigation] AS
	SELECT
		[SurveyID],
		[NavigationID],
		[QaStatus],
		[QaMsg]
	FROM [acquisition].[Navigation] WITH (NOLOCK)
GO
/****** Object:  View [acquisition_v].[ShotInfoAll]    Script Date: 09.12.2019 10:44:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER VIEW [acquisition_v].[ShotInfoAll] AS
	SELECT
		S.[SurveyID],
		S.[ShotInfoID],
		S.[type],
		S.[imo_num],
		S.[mmsi_num],
		S.[survey_name],
		S.[survey_id],
		S.[shottime],
		S.[shotpoint_num],
		S.[sailline_num],
		S.[srcline_num],
		S.[seq_num],
		S.[epsg],
		S.[northing],
		S.[easting],
		S.[vessel_speed],
		S.[bearing],
		S.[water_depth],
		S.[src_num],
		S.[gun_mask],
		S.[src_delay],
		S.[QaStatus],
		S.[QaMsg],
		S.[EnqueuedTimeUtc],
		S.[Created]
	FROM [acquisition].[ShotInfo] AS S WITH (NOLOCK)
GO
/****** Object:  View [survey_v].[DeviationTolerance]    Script Date: 09.12.2019 10:44:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER VIEW [survey_v].[DeviationTolerance]
AS
SELECT
  [SurveyID],
	[source_pressure_spec],
	[source_pressure_max_deviation],
	[source_depth_spec],
	[source_depth_max_deviation],
	[inline_position_max_deviation_in_meters],
	[inline_position_avg_deviation_in_meters],
	[crossline_position_max_deviation_in_meters],
	[crossline_position_avg_deviation_in_meters],
	[drop_out_guns_max_deviation],
	[Created],
	[CreatedBy],
	[Updated],
	[UpdatedBy]
FROM [survey].[DeviationTolerance]
GO
/****** Object:  View [survey_v].[FileEvent]    Script Date: 09.12.2019 10:44:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER VIEW [survey_v].[FileEvent] AS
	SELECT
		[SurveyID],
		[EventID],
		[FileReference]
	FROM [survey].[FileEvent] WITH (NOLOCK)
GO
