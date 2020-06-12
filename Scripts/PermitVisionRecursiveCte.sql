/*

	[x] list tables with timestamp
	[x] get fk constriaints
	[x] list children of tables with timestamp
	[x] see if they have children...
	[x] get table column count
	[x] get table row count
	[ ] construct select statements

*/

with timestamped_tables as (
	select 
		t.name table_name,
		t.object_id table_object_id
	from
		sys.objects t
			join sys.columns c
			on c.object_id = t.object_id
		join sys.schemas s
			on s.schema_id = t.schema_id
	where
		t.type = 'u'
		and c.name = 'timestamp'
		and s.name = 'ReportVision'
)

, fk_relations as (
	SELECT 
		FK.TABLE_NAME as child_table, 
		CU.COLUMN_NAME as child_column, 
		PK.TABLE_NAME  as parent_table, 
		PT.COLUMN_NAME as parent_column,
		C.CONSTRAINT_NAME 
	FROM 
	INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS C 
	INNER JOIN 
	INFORMATION_SCHEMA.TABLE_CONSTRAINTS FK 
		ON C.CONSTRAINT_NAME = FK.CONSTRAINT_NAME 
	INNER JOIN 
	INFORMATION_SCHEMA.TABLE_CONSTRAINTS PK 
		ON C.UNIQUE_CONSTRAINT_NAME = PK.CONSTRAINT_NAME 
	INNER JOIN 
	INFORMATION_SCHEMA.KEY_COLUMN_USAGE CU 
		ON C.CONSTRAINT_NAME = CU.CONSTRAINT_NAME 
	INNER JOIN 
	(
		SELECT 
			i1.TABLE_NAME, i2.COLUMN_NAME
		FROM 
			INFORMATION_SCHEMA.TABLE_CONSTRAINTS i1 
			INNER JOIN 
			INFORMATION_SCHEMA.KEY_COLUMN_USAGE i2 
			ON i1.CONSTRAINT_NAME = i2.CONSTRAINT_NAME 
			WHERE i1.CONSTRAINT_TYPE = 'PRIMARY KEY' 
	) PT 
	ON PT.TABLE_NAME = PK.TABLE_NAME 
)

, related_tables as (
	select distinct child_table, parent_table from fk_relations
)

, relation_graph as (
			select
				cast(null as sysname) as parent_table,
				parent_table as child_table,
				0 depth,
				cast('[ "' + parent_table + '"' as nvarchar(max)) as relation_chain
			from
				related_tables
			where
				parent_table in (
					select table_name from timestamped_tables
				)
		union all
			select
				t.parent_table,
				t.child_table,
				g.depth + 1 depth,
				g.relation_chain + ', "' + t.child_table + '"' as relation_chain
			from
				related_tables t
				join relation_graph g
					on g.child_table = t.parent_table
)

, table_shape as (
	select
		t.name table_name,
		(select count(*) from sys.columns c where c.object_id = t.object_id) column_count,
		i.Rows row_count
	from
		sys.objects t
		JOIN sys.sysindexes I ON T.OBJECT_ID = I.ID
	where
		t.type = 'u'
		and i.indid IN (0, 1)
)

select distinct
	g.parent_table,
	g.child_table,
	s.column_count,
	s.row_count,
	case 
		when exists ( 
			select * 
			from sys.columns c 
			where 
			c.object_id = object_id('reportvision.'+g.child_table)
			and c.name = 'Timestamp' 
		)  
		then 1 
		else 0 
	end HasTimestamp,
	g.depth,
	g.relation_chain + ' ]' relation_chain
from
	relation_graph g
	join table_shape s
		on s.table_name = g.child_table
order by
	relation_chain



