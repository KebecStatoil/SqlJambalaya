INSERT [security].[Certificate] (
	[CertID],
	[Alias],
	[Thumbprint],
	[CertType],
	[VendorName]
)
SELECT
	[UserID]
	,[UserExternalID]
	,[UserToken]
	,[UserType]
	,CASE WHEN UserExternalID like ('ASN%') THEN 'ASN' ELSE 'WGP' END VendorName
FROM
	[security].[User]
GO

INSERT [security].[CertificateSurvey] (
	[CertID],
	[SurveyID],
	[ValidToDate]
)
SELECT
	[UserID]
	,[SurveyID]
	,[ValidToDate]
FROM
	[security].[UserSurvey]
GO





