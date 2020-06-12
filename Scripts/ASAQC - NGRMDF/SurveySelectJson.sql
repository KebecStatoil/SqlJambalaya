
DECLARE @SurveyName CHAR(7) = 'ST42101'

SELECT
	s.SurveyID survey_id
	,s.survey_name
	,s.Recording_Company_ID vessel_vendor
	,s.Source_Company_ID prm_vendor
	,s.PlannedStartDate acquisition_planned_startdate
	,s.PlannedEndDate acquisition_planned_enddate
	,p.projection 'coordination_system_params.projection'
	,p.shooting_direction 'coordination_system_params.shooting_direction'
	,p.datum 'coordination_system_params.datum'
	,p.central_meridian 'coordination_system_params.central_meridian'
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
	SURVEY.Survey s
	JOIN survey.Preplot p
		ON p.SurveyID = s.SurveyID
	JOIN survey.DeviationTolerance d
		ON d.SurveyID = s.SurveyID
WHERE
	s.survey_name = @SurveyName
FOR JSON PATH