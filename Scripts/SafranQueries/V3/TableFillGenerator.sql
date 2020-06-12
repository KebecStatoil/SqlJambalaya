
declare
	@insert nvarchar(max),
	@tableName nvarchar(128),
	@tableId int,
	@columns nvarchar(max)

declare copy_cursor cursor for select o.name, o.object_id from sys.objects o join sys.schemas s on s.schema_id = o.schema_id where type = 'u' and o.name not like '%staging%' and s.name = 'v5_safran'

open copy_cursor  

fetch next from copy_cursor into @tableName, @tableId

while @@fetch_status = 0  
begin

		set @columns = (select string_agg(c.name, ',') from sys.columns c where c.object_id = @tableId and c.name not in ('META_ORAROWSCN','META_SourceDatabase'))

		set @insert = 'insert into v5_safran.' + @tableName + ' (META_SourceDatabase,'+@columns+') select 299,' + @columns + ' from safran.' + @tableName

		print @insert

	fetch next from copy_cursor into @tablename, @tableid

end

close copy_cursor;  
deallocate copy_cursor;
