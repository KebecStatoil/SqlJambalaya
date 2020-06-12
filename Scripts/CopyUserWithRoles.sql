
/*
 *  Generated from source database
 */
--CREATE USER [enbl@statoil.com] FROM  EXTERNAL PROVIDER  WITH DEFAULT_SCHEMA=[dbo]
--GO

/*
 *  run in source database to find Elinæs roles
 */
--select top 1
--	roles.name,
--	members.name
--from
--	sys.database_principals roles
--	join sys.database_role_members mapping
--		on roles.principal_id = mapping.role_principal_id
--	join sys.database_principals members
--		on mapping.member_principal_id = members.principal_id

/*
 *  Elin "just" had db_owner
 */
--alter role db_owner add member [enbl@statoil.com]