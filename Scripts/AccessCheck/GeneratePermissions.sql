with ExternalUserPermissions as (
	SELECT
	  pe.class_desc,
	  case
		when class_desc = 'SCHEMA' then SCHEMA_NAME(pe.major_id)
		else OBJECT_NAME(pe.major_id)
	  END SecurableName,
	  pr.principal_id,
	  pr.name,
	  pr.type_desc,
	  pr.authentication_type_desc,
	  pe.state_desc,
	  pe.permission_name,
	  s.name + '.' + o.name AS ObjectName
	FROM
	  sys.database_principals AS pr
	  JOIN sys.database_permissions AS pe ON pe.grantee_principal_id = pr.principal_id
	  JOIN sys.objects AS o ON pe.major_id = o.object_id
	  JOIN sys.schemas AS s ON o.schema_id = s.schema_id
	WHERE
	  pr.principal_id > 4
)

select
		state_desc + ' '
		+ string_agg(permission_name, ', ')
		+ ' ON SCHEMA::['
		+ SecurableName
		+ '] TO ['
		+ name collate Latin1_General_CS_AS_KS_WS
		+ ']'
	PermissionStatements
from
	ExternalUserPermissions up
group by
	state_desc,
	SecurableName,
	name
order by
	name


