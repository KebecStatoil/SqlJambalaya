declare @SchemaName nvarchar(128) = '%' ------------------ schema here --


select
	s.name [SchemaName],
	o.name [TableName],
	c.name [ColumnName]
	--,*
from
	sys.all_objects o
	join sys.schemas s
		on s.schema_id = o.schema_id
	join sys.all_columns c
		on c.object_id = o.object_id
where
	o.type = 'u' -- search tables
	and s.name like @SchemaName
	and ( ------------------------------------------------ search terms here --
		c.name like '%'
		--or c.name like'%inv%'
	)
