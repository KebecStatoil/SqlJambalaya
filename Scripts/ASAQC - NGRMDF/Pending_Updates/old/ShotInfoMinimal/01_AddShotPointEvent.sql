/****** Object:  StoredProcedure [system_p].[AddShotPointEvent]    Script Date: 27.06.2019 11:19:11 ******/
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


