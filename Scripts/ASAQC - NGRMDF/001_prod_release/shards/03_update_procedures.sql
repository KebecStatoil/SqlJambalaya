/****** Object:  Schema [system_p]    Script Date: 09.12.2019 13:24:00 ******/
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = N'client_p')
EXEC sys.sp_executesql N'CREATE SCHEMA [client_p]'
GO

GRANT EXECUTE
    ON SCHEMA::[client_p] TO [shards_data_reader];
GO

/****** Object:  StoredProcedure [client_p].[GetEventsBetween]    Script Date: 09.12.2019 13:18:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE OR ALTER PROC [client_p].[GetEventsBetween] @Type AS NVARCHAR(128) = NULL, @Start AS INT = 1, @End AS INT = NULL
AS

WITH CTE AS (
	SELECT *, Row_Number() OVER (ORDER BY createdutc DESC) AS RowNumber
		FROM [survey].[Events]
		WHERE [type] = ISNULL(@Type, [type])
)
SELECT [EventID]
	,RowNumber
	,[event_data_json]
	FROM CTE
	WHERE RowNumber >= @Start
		AND RowNumber <= ISNULL(@End, RowNumber)
GO
/****** Object:  StoredProcedure [client_p].[GetMinimalShotInfo]    Script Date: 09.12.2019 13:18:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER PROCEDURE [client_p].[GetMinimalShotInfo] AS
BEGIN

	SELECT
	  [SurveyID],
      [shottime],
      [shotpoint_num],
      [sailline_num],
	  [srcline_num],
	  [seq_num],
	  [created],
      [northing],
      [easting],
      [inline],
      [crossline],
      [radial],
      [latency]
	FROM
		[acquisition_v].[ShotInfoMinimal]

END
GO
/****** Object:  StoredProcedure [system_p].[AddP111Event]    Script Date: 09.12.2019 13:18:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER PROCEDURE [system_p].[AddP111Event] (
	 @EventID uniqueidentifier,
	 @FinalNavigationID uniqueidentifier,
	 @event_text nvarchar(max)
 )
 AS
 BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	 DECLARE
		 @event_type nvarchar(128) = 'event.system.finalnavigation', -- event_type
		 @SurveyID int = (SELECT TOP 1 SurveyID FROM [acquisition].[ShotInfo]),
		 @Payload nvarchar(max) = (
			select top 1
				n.FinalNavigationID,
				p.seq_num,
				p.sailline_num,
				radial_error_min,
				radial_error_max,
				radial_error_mean,
				radial_error_std_dev,
				inline_error_min,
				inline_error_max,
				inline_error_mean,
				inline_error_std_dev,
				crossline_error_min,
				crossline_error_max,
				crossline_error_mean,
				crossline_error_std_dev,
				QaStatus,
				QaMsg
			from
				[acquisition].[FinalNavigation] n
				left join [acquisition].[FinalNavigationShotPoint] p
					on p.FinalNavigationID = n.FinalNavigationID
				left join [acquisition].[FinalNavigationSummary] s
					on s.FinalNavigationID = n.FinalNavigationID
			where
				n.FinalNavigationID = @FinalNavigationID
			for
				json path, without_array_wrapper
		 )

	 INSERT INTO [survey].[Event] (
		 SurveyID,
		 EventID,
		 survey_name,
		 event_text,
		 event_type
	 ) VALUES (
		 @SurveyID,
		 @EventID,
		 (SELECT TOP 1 survey_name FROM [acquisition].[ShotInfo]), -- TODO: This assumes that there is at least one [ShotInfo] before this is called
		 @event_text,
		 @event_type
	 )

	 INSERT INTO [survey].[SystemEvent] (
		 SurveyID,
		 EventID,
		 payload
	 ) VALUES (
		 @SurveyID,
		 @EventID,
		 @Payload
	 )

	 SELECT EventID
	 FROM [survey].[SystemEvent]
	 WHERE EventID = @EventID
 END

GO
/****** Object:  StoredProcedure [system_p].[AddShotPointEvent]    Script Date: 09.12.2019 13:18:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER PROCEDURE [system_p].[AddShotPointEvent] (
	 @EventID uniqueidentifier,
	 @ShotInfoID uniqueidentifier,
	 @event_text nvarchar(max)
 )
 AS
 BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	 DECLARE
		 @event_type nvarchar(128) = 'event.system.shotpoint', -- event_type
		 @SurveyID int = (SELECT SurveyID FROM [acquisition].[ShotInfo] WHERE [ShotInfoID] = @ShotInfoID),
		 @Payload nvarchar(max) = (
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
				,[seq_num]
				,[epsg]
				,JSON_QUERY([northing]) [northing]
				,JSON_QUERY([srcline_num]) [srcline_num]
				,JSON_QUERY([easting]) [easting]
				,[bearing]
				,[vessel_speed]
				,[water_depth]
				,[src_num]
				,JSON_QUERY([gun_mask]) [gun_mask]
				,JSON_QUERY([src_delay]) [src_delay]
				,JSON_QUERY([deviation]) [deviation]
				,[guninfo]
			FROM
			[acquisition_v].[ShotInfoExtended]
			WHERE
				ShotInfoID = @ShotInfoID
			FOR
				JSON PATH , WITHOUT_ARRAY_WRAPPER
		 )

	 INSERT INTO [survey].[Event] (
		 SurveyID,
		 EventID,
		 survey_name,
		 event_text,
		 event_type
	 ) VALUES (
		 @SurveyID,
		 @EventID,
		 (SELECT survey_name FROM [acquisition].[ShotInfo] WHERE [ShotInfoID] = @ShotInfoID),
		 @event_text,
		 @event_type
	 )

	 INSERT INTO [survey].[SystemEvent] (
		 SurveyID,
		 EventID,
		 payload
	 ) VALUES (
		 @SurveyID,
		 @EventID,
		 @Payload
	 )

	 SELECT EventID
	 FROM [survey].[SystemEvent]
	 WHERE EventID = @EventID
 END
GO
/****** Object:  StoredProcedure [system_p].[CreateShotPointEventBatch]    Script Date: 09.12.2019 13:18:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE OR ALTER PROCEDURE [system_p].[CreateShotPointEventBatch] (
	@ShotInfoIDList nvarchar(max)
)
AS
BEGIN

	--SET NOCOUNT ON added to prevent extra result sets from
	--interfering with SELECT statements.
	SET NOCOUNT ON;


	DECLARE @IdList TABLE (
	ShotInfoID UNIQUEIDENTIFIER,
	EventID UNIQUEIDENTIFIER
	)
	INSERT INTO @IdList
	SELECT
	[value] ShotInfoID,
	NEWID() EventID
	FROM
	OPENJSON ( @ShotInfoIDList )


	DECLARE
		@event_type nvarchar(128) = 'event.system.shotpoint', -- event_type
		@event_text nvarchar(max) = 'Shot Info Processed',
		@SurveyID int = (SELECT top 1 SurveyID FROM [acquisition_v].[ShotInfo]),
		@survey_name nchar(7) = (SELECT top 1 survey_name FROM [acquisition_v].[ShotInfo])


	INSERT INTO [survey].[Event] (
		SurveyID,
		EventID,
		survey_name,
		event_text,
		event_type
	)
	SELECT
	@SurveyID,
		EventID,
		@survey_name,
		@event_text,
		@event_type
	FROM
		@IdList


	INSERT INTO [survey].[SystemEvent] (
		SurveyID,
		EventID,
		payload
	)
	SELECT
		@SurveyID SurveyID,
		EventID,
		(
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
			,[seq_num]
			,[epsg]
			,JSON_QUERY([northing]) [northing]
			,JSON_QUERY([srcline_num]) [srcline_num]
			,JSON_QUERY([easting]) [easting]
			,[bearing]
			,[vessel_speed]
			,[water_depth]
			,[src_num]
			,JSON_QUERY([gun_mask]) [gun_mask]
			,JSON_QUERY([src_delay]) [src_delay]
			,JSON_QUERY([deviation]) [deviation]
			,[guninfo]
		FROM
			[acquisition_v].[ShotInfoExtended]
		WHERE
			ShotInfoID = i.ShotInfoID
		FOR
			JSON PATH , WITHOUT_ARRAY_WRAPPER
		) Payload
	FROM
	@IdList l
	JOIN [acquisition_v].[ShotInfoExtended] i
		ON i.ShotInfoID = l.ShotInfoID


	SELECT
	(
		SELECT
			e.SurveyID,
			e.EventID,
			e.survey_name,
			e.event_text,
			e.event_type,
			JSON_QUERY(se.payload) payload,
			e.Created created_at,
			e.CreatedBy created_by
		FROM
			[survey_v].[Event] e
			JOIN [survey_v].[SystemEvent] se
				ON se.EventID = e.EventID
		WHERE
			e.EventID = IdList.EventID
		FOR
			JSON PATH , WITHOUT_ARRAY_WRAPPER
	) EventJson
	FROM
		@IdList IdList


 END
GO
/****** Object:  StoredProcedure [system_p].[GetPreplotSailCoordsWithPrevious]    Script Date: 09.12.2019 13:18:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER PROCEDURE [system_p].[GetPreplotSailCoordsWithPrevious] (
	@ShotInfoID uniqueidentifier
)
AS
	select
	  CurrentShotInfo.[sailline_num],
	  CurrentShotInfo.[shotpoint_num],
	  PreviousShotInfo.[sailline_num],
	  PreviousShotInfo.[shotpoint_num],

	  (
		select
		  [sail_easting]
		from
		  [survey_v].[PreplotShotpoint] p
		where
		  p.[sailline_num] = CurrentShotInfo.[sailline_num]
		  and p.[shotpoint_num] = CurrentShotInfo.[shotpoint_num]
	  ) CurrentShotInfoPreplotSailEasting,
	  (
		select
		  [sail_northing]
		from
		  [survey_v].[PreplotShotpoint] p
		where
		  p.[sailline_num] = CurrentShotInfo.[sailline_num]
		  and p.[shotpoint_num] = CurrentShotInfo.[shotpoint_num]
	  ) CurrentShotInfoPreplotSailNorthing,
	  (
		select
		  [src_easting]
		from
		  [survey_v].[PreplotShotpoint] p
		where
		  p.[sailline_num] = CurrentShotInfo.[sailline_num]
		  and p.[shotpoint_num] = CurrentShotInfo.[shotpoint_num]
	  ) CurrentShotInfoPreplotSrcEasting,
	  (
		select
		  [src_northing]
		from
		  [survey_v].[PreplotShotpoint] p
		where
		  p.[sailline_num] = CurrentShotInfo.[sailline_num]
		  and p.[shotpoint_num] = CurrentShotInfo.[shotpoint_num]
	  ) CurrentShotInfoPreplotSrcNorthing,
	  (
		select
		  [sail_easting]
		from
		  [survey_v].[PreplotShotpoint] p
		where
		  p.[sailline_num] = PreviousShotInfo.[sailline_num]
		  and p.[shotpoint_num] = PreviousShotInfo.[shotpoint_num]
	  ) PreviousShotInfoPreplotSailEasting,
	  (
		select
		  [sail_northing]
		from
		  [survey_v].[PreplotShotpoint] p
		where
		  p.[sailline_num] = PreviousShotInfo.[sailline_num]
		  and p.[shotpoint_num] = PreviousShotInfo.[shotpoint_num]
	  ) PreviousShotInfoPreplotSailNorthing
	from
	  [acquisition_v].[ShotInfo] CurrentShotInfo
	  join [acquisition_v].[NextShotInfo] MapToNextShot on MapToNextShot.NextShotInfoID = CurrentShotInfo.ShotInfoID
	  join [acquisition_v].[ShotInfo] PreviousShotInfo on PreviousShotInfo.ShotInfoID = MapToNextShot.ShotInfoID
	where
	  CurrentShotInfo.ShotInfoID = @ShotInfoID

GO
/****** Object:  StoredProcedure [system_p].[GetPreplotShotpoints]    Script Date: 09.12.2019 13:18:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER PROCEDURE [system_p].[GetPreplotShotpoints]
AS
BEGIN
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
	FROM
		[survey_v].[PreplotShotpoint]
END
GO
/****** Object:  StoredProcedure [system_p].[GetSaillineAggregatedEvent]    Script Date: 09.12.2019 13:18:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE OR ALTER PROCEDURE [system_p].[GetSaillineAggregatedEvent] (
	@SequenceNumber [int] = NULL
)
AS
BEGIN

	SET NOCOUNT ON; -- =c@ Oh my glob!

	IF(@SequenceNumber IS NULL)
		SET @SequenceNumber = (
			SELECT MAX(seq_num)
			FROM [acquisition_v].[SailLineAggregateDeviation]
		)

	DECLARE @EventJson NVARCHAR(MAX) = (
		SELECT
			SurveyID,
			EventID,
			SurveyName survey_name,
			event_text,
			event_type,
			aggregate_type,
			JSON_QUERY(payload) payload,
			Created created_at,
			CreatedBy created_by
		FROM
			[survey_v].[AggregatedEvent]
		WHERE
			JSON_VALUE(payload,'$.seq_num') = @SequenceNumber
		FOR
			JSON PATH , WITHOUT_ARRAY_WRAPPER
	)

	SELECT @EventJson EventJson
END
GO
/****** Object:  StoredProcedure [system_p].[GetShotInfoPreplotLineInfo]    Script Date: 09.12.2019 13:18:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER PROCEDURE [system_p].[GetShotInfoPreplotLineInfo] (
	@KeyList nvarchar(max)
)
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON

	; with preplot_coords as (
		select
			pp.sailline_num,
			pp.shotpoint_num,
			pp.src_easting,
			pp.src_northing
		from
			[acquisition_v].[ShotInfo] si
			join survey_v.PreplotShotpoint pp
				on pp.sailline_num = si.sailline_num
				and pp.shotpoint_num = si.shotpoint_num
		where
			ShotInfoID in (select value from openjson ( @KeyList ))
	)

	, min_max_shotpoint_nums as (
		select
			sailline_num,
			min(shotpoint_num) min_shotpoint_num,
			max(shotpoint_num) max_shotpoint_num
		from
			survey_v.PreplotShotpoint
		group by
			sailline_num
	)

	, min_shotpoints as (
		select
			pp.sailline_num,
			pp.shotpoint_num,
			pp.sail_easting,
			pp.sail_northing
		from
			survey_v.PreplotShotpoint pp
			join min_max_shotpoint_nums mn
				on mn.min_shotpoint_num = pp.shotpoint_num
				and mn.sailline_num = pp.sailline_num
	)

	, max_shotpoints as (
		select
			pp.sailline_num,
			pp.shotpoint_num,
			pp.sail_easting,
			pp.sail_northing
		from
			survey.PreplotShotpoint pp
			join min_max_shotpoint_nums mx
				on mx.max_shotpoint_num = pp.shotpoint_num
				and mx.sailline_num = pp.sailline_num
	)

	select
		preplot_coords.sailline_num,
		preplot_coords.shotpoint_num,
		preplot_coords.src_easting,
		preplot_coords.src_northing,
		min_shotpoints.sail_northing min_sail_northing,
		min_shotpoints.sail_easting min_sail_easting,
		max_shotpoints.sail_northing max_sail_northing,
		max_shotpoints.sail_easting max_sail_easting
	from
		preplot_coords
		join max_shotpoints
			on max_shotpoints.sailline_num = preplot_coords.sailline_num
		join min_shotpoints
			on min_shotpoints.sailline_num = preplot_coords.sailline_num


END

GO
/****** Object:  StoredProcedure [system_p].[GetShotPointEvent]    Script Date: 09.12.2019 13:18:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER PROCEDURE [system_p].[GetShotPointEvent] (
	@EventID uniqueidentifier
)
AS
BEGIN

	DECLARE @EventJson NVARCHAR(MAX) = (
		SELECT
			e.SurveyID,
			e.EventID,
			e.survey_name,
			e.event_text,
			e.event_type,
			JSON_QUERY(se.payload) payload,
			e.Created created_at,
			e.CreatedBy created_by
		FROM
			[survey_v].[Event] e
			JOIN [survey_v].[SystemEvent] se
				ON se.EventID = e.EventID
		WHERE
			e.EventID = @EventID
		FOR
			JSON PATH , WITHOUT_ARRAY_WRAPPER
	)

	SELECT @EventJson EventJson
END

GO
/****** Object:  StoredProcedure [system_p].[UpsertEvent]    Script Date: 09.12.2019 13:18:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER PROCEDURE [system_p].[UpsertEvent] (
	@EventID uniqueidentifier = NULL,
	@seq_num int = NULL,
	@sailline_num int = NULL,
	@type nvarchar(128) = NULL,
	@version nvarchar(10) = NULL,
	@createdutc float = NULL,
	@event_data_json nvarchar(max) = NULL
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	IF EXISTS(SELECT * FROM [survey].[Events] WHERE EventID = @EventID)
	BEGIN
		UPDATE [survey].[Events]
		SET
			seq_num = @seq_num,
			sailline_num = @sailline_num,
			type = @type,
			version = @version,
			createdutc = @createdutc,
			event_data_json = @event_data_json
		WHERE
			EventID = @EventID
	END
	ELSE
	BEGIN
		INSERT INTO [survey].[Events] (
			EventID,
			seq_num,
			sailline_num,
			type,
			version,
			createdutc,
			event_data_json
		)
		VALUES (
			@EventID,
			@seq_num,
			@sailline_num,
			@type,
			@version,
			@createdutc,
			@event_data_json
		)
	END
	SELECT @EventID EventID
END
GO
/****** Object:  StoredProcedure [system_p].[UpsertFinalNavigation]    Script Date: 09.12.2019 13:18:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE OR ALTER PROCEDURE [system_p].[UpsertFinalNavigation] (
	@SurveyID int,
	@FinalNavigationID uniqueidentifier,
	@QaStatus nvarchar(128) = NULL,
	@QaMsg nvarchar(max) = NULL
)
AS

  SET NOCOUNT ON;

	IF NOT EXISTS (
		SELECT *
		FROM [acquisition_v].[FinalNavigation]
		WHERE FinalNavigationID = @FinalNavigationID
	)

		INSERT INTO [acquisition].[FinalNavigation] (
			[SurveyID]
			,[FinalNavigationID]
			,[QaStatus]
			,[QaMsg]
		)
		VALUES
		(
			@SurveyID,
			@FinalNavigationID,
			@QaStatus,
			@QaMsg
		)

	ELSE

		UPDATE [acquisition].[FinalNavigation]
		SET
			[QaStatus] = @QaStatus,
			[QaMsg] = @QaMsg
		WHERE
			FinalNavigationID = @FinalNavigationID

	SELECT @FinalNavigationID as FinalNavigationID;

GO
/****** Object:  StoredProcedure [system_p].[UpsertLatestShotInfo]    Script Date: 09.12.2019 13:18:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER PROC [system_p].[UpsertLatestShotInfo]
  @ShotInfoJsonArray NVARCHAR(MAX)
AS

SET NOCOUNT ON;

WITH LatestNumbered
AS (
  SELECT
    ROW_NUMBER() OVER(
      PARTITION BY SurveyID, sailline_num, srcline_num, seq_num, shotpoint_num
      ORDER BY EnqueuedTimeUtc DESC) AS RowNumber,
    SurveyID,
    ShotInfoID,
    shotpoint_num,
    sailline_num,
    srcline_num,
    seq_num,
    EnqueuedTimeUtc
  FROM OPENJSON(@ShotInfoJsonArray)
  WITH (
	  SurveyID INT 'strict $.SurveyID',
	  ShotInfoID UNIQUEIDENTIFIER 'strict $.ShotInfoID',
	  shotpoint_num INT '$.shotpoint_num',
	  sailline_num INT '$.sailline_num',
	  srcline_num NVARCHAR(1024) '$.srcline_num',
	  seq_num INT '$.seq_num',
	  EnqueuedTimeUtc DATETIME2(7) '$.EnqueuedTimeUtc'
  )
),
LatestDeduplicated
AS (
  SELECT
    SurveyID,
    ShotInfoID,
    shotpoint_num,
    sailline_num,
    srcline_num,
    seq_num,
    EnqueuedTimeUtc
  FROM LatestNumbered
  WHERE RowNumber = 1
)

MERGE INTO [acquisition].[LatestShotInfo] AS Target
USING (
	SELECT
    SurveyID,
    ShotInfoID,
    shotpoint_num,
    sailline_num,
    srcline_num,
    seq_num,
    EnqueuedTimeUtc
	FROM LatestDeduplicated) AS Source
	ON (
			Target.sailline_num = Source.sailline_num
			AND Target.srcline_num = Source.srcline_num
			AND Target.seq_num = Source.seq_num
			AND Target.shotpoint_num = Source.shotpoint_num
			)
WHEN MATCHED
	AND ISNULL(Target.EnqueuedTimeUtc, '1970-01-01') <= Source.EnqueuedTimeUtc
	THEN
		UPDATE
		SET Target.ShotInfoID = Source.ShotInfoID,
			Target.EnqueuedTimeUtc = Source.EnqueuedTimeUtc
WHEN NOT MATCHED BY TARGET
	THEN
		INSERT (
			[SurveyID],
			[ShotInfoID],
			[shotpoint_num],
			[sailline_num],
			[srcline_num],
			[seq_num],
			[EnqueuedTimeUtc]
			)
		VALUES (
			Source.SurveyID,
			Source.ShotInfoID,
			Source.shotpoint_num,
			Source.sailline_num,
			Source.srcline_num,
			Source.seq_num,
			Source.EnqueuedTimeUtc
			);
GO
