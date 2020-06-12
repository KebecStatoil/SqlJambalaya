
/*
 *  Super Dagerous Code! =c@
 */
--select
--	'delete ' + s.name + '.' + t.name,
--	s.name,
--	t.name
--from sys.tables t join sys.schemas s on t.schema_id = s.schema_id
--where
--	s.name in ('survey', 'acquisition')
--	and t.name <> 'PreplotShotpoint'
--		and t.name <> 'DeviationTolerance'

/*
 *  Less dangerous code. ^^)
 */
--select
--	'select ''' + s.name + '.' + t.name + ''' TableName, count(*) TableCount from ' +s.name + '.' + t.name,
--	s.name,
--	t.name
--from sys.tables t join sys.schemas s on t.schema_id = s.schema_id
--where
--	s.name in ('survey', 'acquisition')
--	and t.name <> 'PreplotShotpoint'
--	and t.name <> 'DeviationTolerance'
