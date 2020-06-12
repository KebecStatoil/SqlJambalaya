declare @objectTable table (
  SchemaName nvarchar(128),
  ObjectName nvarchar(128),
  ObjectDefinition nvarchar(max)
)
insert into
  @objectTable
SELECT
  s.name,
  o.name,
  m.definition
FROM
  sys.sql_modules m
  INNER JOIN sys.objects o ON m.object_id = o.object_id
  join sys.schemas s on s.schema_id = o.schema_id
WHERE
  m.definition Like '%' + '.[[]User]' + '%'
  or definition like '%' + '.[[]UserSurvey]' + '%'
  
-------------------------------------------------------------------------------

declare @definition nvarchar(max)

declare object_cursor cursor for
select
  ObjectDefinition
from
  @objectTable
  
open object_cursor
fetch next
from
  object_cursor into @definition while @@fetch_status = 0
begin

    print @definition
    print 'go'
 
  fetch next
  from
    object_cursor into @definition

end

close object_cursor;
deallocate object_cursor;

-------------------------------------------------------------------------------

select
  *
from
  @objectTable
order by
  ObjectName