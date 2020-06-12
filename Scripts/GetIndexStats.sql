declare @SchemaName nvarchar(128) = 'safran'
declare @ObjectName nvarchar(128) = 'ACTIVITIES'

SELECT
  sysdatetime() checkedAtSysdatetime,
  s.name SchemaName,
  o.name ObjectName,
  indexstats.*
FROM
  sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, NULL) AS indexstats
  join sys.all_objects o
	on o.object_id = indexstats.object_id
  join sys.schemas s
	on s.schema_id = o.schema_id	
WHERE
  s.name like @SchemaName
  and o.name like @ObjectName
 -- and (
 --   indexstats.avg_fragmentation_in_percent >= 30
	--AND indexstats.page_count >= 1000
 -- )
