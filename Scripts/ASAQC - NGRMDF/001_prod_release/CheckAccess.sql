

select
	s.survey_name,
	s.SurveyID,
	u.UserExternalID,
	u.UserToken
from
	[survey].[Survey] s
	full outer join [security].[UserSurvey] us
		on us.SurveyID = s.SurveyID
	full outer join [security].[User] u
		on u.UserID = us.UserID
order
	by SurveyID
--SELECT
--	[GroupRole]
--    ,[Type]
--    ,[SurveyID]
--    ,[SurveyName]
--FROM
--	[security_v].[ApplicationRoleSurveyAccess]
--WHERE
--	Type <> 'Internal'