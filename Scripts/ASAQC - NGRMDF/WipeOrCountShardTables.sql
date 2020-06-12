/*
 *  Topological Sort??? ^^)
 */
select
	'select count(*) [' + s.name + '.' + o.name + '] from [' + s.name + '].[' + o.name + ']' SqlCount,
	'delete [' + s.name + '].[' + o.name + ']' SqlDelete,
	s.name SchemaName,
	o.name TableName,
	*
from
	sys.objects o
	join sys.schemas s
		on s.schema_id = o.schema_id
where
	type = 'u'
	and s.name <> '__ShardManagement'
	and (
		s.name <> 'survey'
		or o.name not in (
			'PreplotShotpoint',
			'InterestingDataFields',
			'EventsTypes',
			'FileReferenceActionTypes',
			'FileReferenceActionStates',
			'SegdReferenceStates',
			'SequenceSegdActionStates',
			'SequenceSegdActionTypes'
		)
	)