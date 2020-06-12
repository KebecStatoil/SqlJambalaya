



declare @RoleList nvarchar(max) = '[
	"NGRMDF_ASAQC_Internal",
	"NGRMDF_ASAQC_GR",
	"NGRMDF_ASAQC_JC",
	"NGRMDF_ASAQC_JS",
	"NGRMDF_ASAQC_SN",
	"NGRMDF_ASAQC_ASN_Vendor",
	"NGRMDF_ASAQC_CGG_Vendor",
	"NGRMDF_ASAQC_GERI_Vendor",
	"NGRMDF_ASAQC_WGP_Vendor"
]'


-- SELECT ISJSON(@RoleList) [isJson]

SELECT
	A.GroupRole,
	A.SurveyID,
	A.SurveyName
FROM
	[security_v].[ApplicationRoleSurveyAccess] A
	JOIN OPENJSON(@RoleList) R
		ON A.GroupRole = R.value