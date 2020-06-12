--IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'survey')
--    DECLARE @sql NVARCHAR(max) = 'CREATE SCHEMA survey'
--    EXEC sp_executesql @statement = @sql
--GO


/*
 *  view schemas
 */
select name from sys.schemas where name not in (
	'dbo',
	'guest',
	'INFORMATION_SCHEMA',
	'sys'
)
and name not like 'db[_]%'
and name like '%[_]v'

/*
 *  view schemas
 */
select name from sys.schemas where name not in (
	'dbo',
	'guest',
	'INFORMATION_SCHEMA',
	'sys'
)
and name not like 'db[_]%'
and name like '%[_]v'

