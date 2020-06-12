
/*
 *  table schema
 */
--select *
--from sys.schemas
--where
--	name not like 'db[_]%'
--	and name not in (
--		'dbo',
--		'guest',
--		'INFORMATION_SCHEMA',
--		'sys'
--	)
--and name not like '%[_]%'


/*
 *  view schema
 */
select *
from sys.schemas
where
	name not like 'db[_]%'
	and name not in (
		'dbo',
		'guest',
		'INFORMATION_SCHEMA',
		'sys'
	)
and name like '%[_]v'


/*
 *  procedure schema
 */
--select *
--from sys.schemas
--where
--	name not like 'db[_]%'
--	and name not in (
--		'dbo',
--		'guest',
--		'INFORMATION_SCHEMA',
--		'sys'
--	)
--and name like '%[_]p'


/*
 * unknown schema
 */
--select *
--from sys.schemas
--where
--	name not like 'db[_]%'
--	and name not in (
--		'dbo',
--		'guest',
--		'INFORMATION_SCHEMA',
--		'sys'
--	)
--	and name not like '%[_]v'
--	and name not like '%[_]p'
--	and name like '%[_]%'