SELECT
state_desc,
permission_name,
class_desc,
case when class_desc = 'SCHEMA' then SCHEMA_NAME(perm.major_id)
else OBJECT_NAME(perm.major_id)
END SecurableName,
USER_NAME(grantee_principal_id) username,
*
FROM sys.database_permissions AS Perm
left JOIN sys.database_principals AS Prin
ON Perm.major_ID = Prin.principal_id
ORDER BY
	username,
	SecurableName