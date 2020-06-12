/****** Object:  StoredProcedure [client_p].[GetSurvey]    Script Date: 01.07.2019 10:49:53 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE   PROCEDURE [client_p].[GetSurvey] (
	@SurveyName CHAR(7)
)
AS
BEGIN

	DECLARE @SurveyJson NVARCHAR(MAX) = (
		SELECT
			s.SurveyID survey_id
			,s.survey_name
			,s.field_id
			,f.FIELDNAME field_name
			,VesselUser.UserExternalID 'vessel_vendor_name'
			,VesselUser.UserToken 'vessel_vendor_certificate_thumprint'
			,PrmUser.UserExternalID prm_vendor_name	
			,PrmUser.UserToken rprm_vendor_certificate_thumprint
			,s.PlannedStartDate acquisition_planned_startdate
			,s.PlannedEndDate acquisition_planned_enddate
			,p.PreplotName 'preplot_meta.preplot_name'
			,p.projection 'preplot_meta.projection'
			,p.shooting_direction 'preplot_meta.shooting_direction'
			,p.datum 'preplot_meta.datum'
			,p.central_meridian 'preplot_meta.central_meridian'
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
			LEFT JOIN [survey].[SurveyPreplotLink] AS SP
				ON S.SurveyID  = SP.SurveyID
			LEFT JOIN [security].[User] VesselUser
				ON S.Source_Company_ID = VesselUser.UserID
			LEFT JOIN [security].[User] PrmUser
				ON S.Source_Company_ID = PrmUser.UserID
			LEFT JOIN survey_v.Preplot p
				ON P.PreplotID = SP.PreplotID
			LEFT JOIN survey_v.DeviationTolerance d
				ON d.SurveyID = s.SurveyID
			LEFT JOIN management_v.Field f
				ON s.Field_ID = f.IDFIELD
		WHERE
			s.survey_name = @SurveyName
		FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
	)

	SELECT @SurveyJson SurveyJson

END

GO


