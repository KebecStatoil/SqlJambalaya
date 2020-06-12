select
	s.name + '.' + o.name QualifiedName
	,s.name SchemaName
	,o.name TableName
	,c.name ColumnName
	--,*
from
	sys.objects o
	join sys.schemas s
		on s.schema_id = o.schema_id
	join sys.all_columns c
		on c.object_id = o.object_id
where
	o.type = 'u'
	and s.name in ('security', 'management')
	and o.name not in ('Company', 'Discovery')
order by
	s.name,
	o.name,
	c.column_id
