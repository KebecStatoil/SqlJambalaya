DECLARE @SurveyJson NVARCHAR(MAX) = '{
        "survey_id": 1974,
        "survey_name": "EQ57166",
        "vessel_vendor": "vessel_vendor_sample",
        "prm_vendor": "prm_vendor_sample",
        "acquisition_planned_startdate": "2019-05-01",
        "acquisition_planned_enddate": "2019-06-30",
        "coordination_system_params": {
            "projection": "projection_sample",
            "shooting_direction": "shooting_direction_sample",
            "datum": "datum_sample",
            "central_meridian": "central_meridian_sample"
        },
        "line_acceptance_criteria": {
            "source_pressure_spec": ' + cast(RAND() * 20 as nvarchar(max)) + ',
            "source_pressure_max_deviation": ' + cast(RAND() * 20 as nvarchar(max)) + ',
            "source_depth_spec": ' + cast(RAND() * 20 as nvarchar(max)) + ',
            "source_depth_max_deviation": ' + cast(RAND() * 20 as nvarchar(max)) + ',
            "inline_position_max_deviation_in_meters": ' + cast(RAND() * 20 as nvarchar(max)) + ',
            "inline_position_avg_deviation_in_meters": ' + cast(RAND() * 20 as nvarchar(max)) + ',
            "crossline_position_max_deviation_in_meters": ' + cast(RAND() * 20 as nvarchar(max)) + ',
            "crossline_position_avg_deviation_in_meters": ' + cast(RAND() * 20 as nvarchar(max)) + ',
            "drop_out_guns_max_deviation": ' + cast(cast(RAND() * 20 as int) as nvarchar(max)) + '
        }
    }'

DECLARE @Survey TABLE (
	[SurveyID] [int] NOT NULL,
	[survey_name] [char](7) NULL,
	[PlannedStartDate] [date] NULL,
	[PlannedEndDate] [date] NULL,
	[Recording_Company_ID] [nvarchar](128) NULL,
	[Source_Company_ID] [nvarchar](128) NULL
)

DECLARE @Preplot TABLE (
	[SurveyID] [int] NOT NULL,
	[PreplotID] [int] NOT NULL,
	[projection] [nvarchar](128) NULL,
	[shooting_direction] [nvarchar](128) NULL,
	[datum] [nvarchar](128) NULL,
	[central_meridian] [nvarchar](128) NULL
)

DECLARE @DeviationTolerance TABLE (
	[SurveyID] [int] NOT NULL,
	[source_pressure_spec] [float] NULL,
	[source_pressure_max_deviation] [float] NULL,
	[source_depth_spec] [float] NULL,
	[source_depth_max_deviation] [float] NULL,
	[inline_position_max_deviation_in_meters] [float] NULL,
	[inline_position_avg_deviation_in_meters] [float] NULL,
	[crossline_position_max_deviation_in_meters] [float] NULL,
	[crossline_position_avg_deviation_in_meters] [float] NULL,
	[drop_out_guns_max_deviation] [int] NULL
)

-------------------------------------------------------------------------------

insert into @Survey (
	[SurveyID],
	[survey_name],
	[PlannedStartDate],
	[PlannedEndDate],
	[Recording_Company_ID],
	[Source_Company_ID]
)
values
(
	JSON_VALUE(@SurveyJson, '$.survey_id'),
	JSON_VALUE(@SurveyJson, '$.survey_name'),
	JSON_VALUE(@SurveyJson, '$.acquisition_planned_startdate'),
	JSON_VALUE(@SurveyJson, '$.acquisition_planned_enddate'),
	JSON_VALUE(@SurveyJson, '$.vessel_vendor'),
	JSON_VALUE(@SurveyJson, '$.prm_vendor')
)

insert into @Preplot (
	[SurveyID],
	[PreplotID],
	[projection],
	[shooting_direction],
	[datum],
	[central_meridian]
)
values
(
	JSON_VALUE(@SurveyJson, '$.survey_id'),
	[system].[GetNextPreplotID](),
	JSON_VALUE(@SurveyJson, '$.coordination_system_params.projection'),
	JSON_VALUE(@SurveyJson, '$.coordination_system_params.shooting_direction'),
	JSON_VALUE(@SurveyJson, '$.coordination_system_params.datum'),
	JSON_VALUE(@SurveyJson, '$.coordination_system_params.central_meridian')
)

insert into @DeviationTolerance (
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
values
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

--------------------------------

select * from @Survey
select * from @Preplot
select * from @DeviationTolerance