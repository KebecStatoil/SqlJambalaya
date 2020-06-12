with OriginalTables as (
  select
    s.name + '.' + o.name QualifiedTableName
  from
    sys.objects o
    join sys.schemas s on s.schema_id = o.schema_id
  where
    type = 'u'
    and s.name = 'safran'
    and o.name not like '%staging%'
    and o.name not like '%a2o%'
    and o.name not like '%v3%'
)

, A2oTables as (
  select
    s.name + '.' + o.name QualifiedTableName
  from
    sys.objects o
    join sys.schemas s on s.schema_id = o.schema_id
  where
    type = 'u'
    and o.name like '%a2o%'
)

,OriginalStagingTables as (
  select
    s.name + '.' + o.name QualifiedTableName
  from
    sys.objects o
    join sys.schemas s on s.schema_id = o.schema_id
  where
    type = 'u'
    and s.name = 'safran'
    and o.name like '%staging%'
)

select
  'drop table ' + QualifiedTableName
from
  A2oTables
 -- full outer join A2oTables
	--on OriginalTables.QualifiedTableName = replace(A2oTables.QualifiedTableName, 'A2O_', '')