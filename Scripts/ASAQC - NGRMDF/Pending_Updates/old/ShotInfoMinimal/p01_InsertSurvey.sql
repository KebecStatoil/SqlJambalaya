/****** Object:  StoredProcedure [client_p].[InsertSurvey]    Script Date: 28.06.2019 13:33:21 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO


CREATE OR ALTER PROCEDURE [client_p].[InsertSurvey] (
	@SurveyJson NVARCHAR(MAX)
)
AS
BEGIN

set xact_abort on
BEGIN TRANSACTION

	DECLARE @NewPreplotID AS INT = [system].[GetNextPreplotID]()

	INSERT INTO [survey].[Survey] (
		[SurveyID],
		[survey_name],
		[Field_ID],
		[PlannedStartDate],
		[PlannedEndDate],
		[Recording_Company_ID],
		[Source_Company_ID]
	)
	VALUES
	(
		JSON_VALUE(@SurveyJson, '$.survey_id'),
		JSON_VALUE(@SurveyJson, '$.survey_name'),
		JSON_VALUE(@SurveyJson, '$.field_id'),
		JSON_VALUE(@SurveyJson, '$.acquisition_planned_startdate'),
		JSON_VALUE(@SurveyJson, '$.acquisition_planned_enddate'),
		JSON_VALUE(@SurveyJson, '$.vessel_vendor'),
		JSON_VALUE(@SurveyJson, '$.prm_vendor')
	)

	INSERT INTO [survey].[Preplot] (
		[PreplotID],
		[PreplotName],
		[projection],
		[shooting_direction],
		[datum],
		[central_meridian]
	)
	VALUES
	(
		@NewPreplotID,
		JSON_VALUE(@SurveyJson, '$.coordination_system_params.preplot_name'),
		JSON_VALUE(@SurveyJson, '$.coordination_system_params.projection'),
		JSON_VALUE(@SurveyJson, '$.coordination_system_params.shooting_direction'),
		JSON_VALUE(@SurveyJson, '$.coordination_system_params.datum'),
		JSON_VALUE(@SurveyJson, '$.coordination_system_params.central_meridian')
	)

	INSERT INTO [survey].[SurveyPreplotLink] (SurveyID, PreplotID)
	VALUES
	(
		JSON_VALUE(@SurveyJson, '$.survey_id'), 
		@NewPreplotID
	)

	INSERT INTO [survey].[DeviationTolerance] (
		[SurveyID],
		[source_pressure_spec],
		[source_pressure_max_deviation],
		[source_depth_spec],
		[source_depth_max_deviation],
		[inline_position_max_deviation_in_meters],
		[inline_position_avg_deviation_in_meters],
		[crossline_position_max_deviation_in_meters],
		[crossline_position_avg_deviation_in_meters],
		[drop_out_guns_max_deviation]
	)
	VALUES
	(
		JSON_VALUE(@SurveyJson, '$.survey_id'),
		JSON_VALUE(@SurveyJson, '$.line_acceptance_criteria.source_pressure_spec'),
		JSON_VALUE(@SurveyJson, '$.line_acceptance_criteria.source_pressure_max_deviation'),
		JSON_VALUE(@SurveyJson, '$.line_acceptance_criteria.source_depth_spec'),
		JSON_VALUE(@SurveyJson, '$.line_acceptance_criteria.source_depth_max_deviation'),
		JSON_VALUE(@SurveyJson, '$.line_acceptance_criteria.inline_position_max_deviation_in_meters'),
		JSON_VALUE(@SurveyJson, '$.line_acceptance_criteria.inline_position_avg_deviation_in_meters'),
		JSON_VALUE(@SurveyJson, '$.line_acceptance_criteria.crossline_position_max_deviation_in_meters'),
		JSON_VALUE(@SurveyJson, '$.line_acceptance_criteria.crossline_position_avg_deviation_in_meters'),
		JSON_VALUE(@SurveyJson, '$.line_acceptance_criteria.drop_out_guns_max_deviation')
	)
	DECLARE @SurveyName AS CHAR(7) = JSON_VALUE(@SurveyJson, '$.survey_name'); 
	EXEC [client_p].[GetSurvey] @SurveyName


COMMIT TRANSACTION

END

GO


