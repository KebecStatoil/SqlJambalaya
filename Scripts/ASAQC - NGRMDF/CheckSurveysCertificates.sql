

select
	s.survey_name,
	s.SurveyID,
	u.Alias,
	u.Thumbprint
from
	[survey].[Survey] s
	full outer join [security].[CertificateSurvey] us
		on us.SurveyID = s.SurveyID
	full outer join [security].[Certificate] u
		on u.CertID = us.CertID

SELECT
	[GroupRole]
    ,[Type]
    ,[SurveyID]
    ,[SurveyName]
FROM
	[security_v].[ApplicationRoleSurveyAccess]
WHERE
	Type <> 'Internal'