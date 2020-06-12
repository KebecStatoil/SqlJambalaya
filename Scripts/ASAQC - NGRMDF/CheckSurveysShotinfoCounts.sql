

select
	s.survey_name,
	s.SurveyID,
	count(*) ShotinfoCount
from
	[survey].[Survey] s
	left join acquisition_v.ShotInfo i
		on i.SurveyID = s.SurveyID
group by
	s.survey_name,
	s.SurveyID


select
	s.survey_name,
	s.SurveyID,
	count(*) PreplotShotpointCount
from
	[survey].[Survey] s
	left join survey_v.PreplotShotpoint p
		on p.SurveyID = s.SurveyID
group by
	s.survey_name,
	s.SurveyID