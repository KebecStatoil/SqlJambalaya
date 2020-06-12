/****** Object:  StoredProcedure [client_p].[GetSurveyList]    Script Date: 04.06.2019 15:48:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO



CREATE   PROCEDURE [client_p].[GetSurveyList]
AS
BEGIN

	DECLARE @SurveyListJson NVARCHAR(MAX) = (
		SELECT
			s.SurveyID survey_id,
			s.survey_name
			,s.field_id
			,s.type -- todo
			,f.FIELDNAME field_name
			,s.Recording_Company_ID vessel_vendor_name -- modded
			,s.Recording_Company_ID vessel_vendor_certificate_thumprint -- todo
			,s.Source_Company_ID prm_vendor_name_ -- modded
			,s.Source_Company_ID vessel_vendor_certificate_thumprint -- todo
			,s.PlannedStartDate acquisition_planned_startdate
			,s.PlannedEndDate acquisition_planned_enddate
			,p.name -- todo
			,p.type -- todo
			,p.projection 'coordination_system_params.projection' -- dunno
			,p.shooting_direction 'coordination_system_params.shooting_direction' -- dunno
			,p.datum 'coordination_system_params.datum' -- dunno
			,p.central_meridian 'coordination_system_params.central_meridian' -- dunno
			,d.source_pressure_spec 'line_acceptance_criteria.source_pressure_spec'
			,d.source_pressure_max_deviation 'line_acceptance_criteria.source_pressure_max_deviation'
			,d.source_depth_spec 'line_acceptance_criteria.source_depth_spec'
			,d.source_depth_max_deviation 'line_acceptance_criteria.source_depth_max_deviation'
			,d.inline_position_max_deviation_in_meters 'line_acceptance_criteria.inline_position_max_deviation_in_meters'
			,d.inline_position_avg_deviation_in_meters 'line_acceptance_criteria.inline_position_avg_deviation_in_meters'
			,d.crossline_position_max_deviation_in_meters 'line_acceptance_criteria.crossline_position_max_deviation_in_meters'
			,d.crossline_position_avg_deviation_in_meters 'line_acceptance_criteria.crossline_position_avg_deviation_in_meters'
			,d.drop_out_guns_max_deviation 'line_acceptance_criteria.drop_out_guns_max_deviation'
		FROM
			survey_v.Survey s
			LEFT JOIN survey_v.Preplot p
				ON p.SurveyID = s.SurveyID
			LEFT JOIN survey_v.DeviationTolerance d
				ON d.SurveyID = s.SurveyID
			LEFT JOIN management_v.Field f
				ON s.Field_ID = f.IDFIELD
		FOR JSON PATH
	)

	SELECT @SurveyListJson AS SurveyJson

END

GO


