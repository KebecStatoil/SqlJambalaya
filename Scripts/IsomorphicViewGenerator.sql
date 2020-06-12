
/*
 *  Isomorphic View Generator
 */

DECLARE
	@ViewSchemaName nvarchar(128) = 'om',

	@ObjectId int,
	@ObjectName nvarchar(128),
	@SchemaName nvarchar(128),
	@ColumnName nvarchar(128),

	@FirstColumn bit,
	@TabChar char(1) = char(9)

DECLARE table_cursor CURSOR FOR
	select
		o.object_id,
		o.name,
		s.name
	from
		sys.objects o
		join sys.schemas s
			on s.schema_id = o.schema_id
	where
		type = 'u'
		and s.name = 'shipweight'

OPEN table_cursor  
  
FETCH NEXT FROM table_cursor   
INTO
	@ObjectId,
	@ObjectName,
	@SchemaName
  
WHILE @@FETCH_STATUS = 0  
BEGIN

	SET @FirstColumn = 1

	print 'CREATE OR ALTER VIEW ['+@ViewSchemaName+'].['+@ObjectName+'] AS'
	print @TabChar + 'SELECT'

	---------------------------------------------------------------------------

		DECLARE column_cursor CURSOR FOR
			select name
			from sys.columns c
			where object_id = @ObjectId
		
		OPEN column_cursor  
  
		FETCH NEXT FROM column_cursor INTO @ColumnName

		WHILE @@FETCH_STATUS = 0  
		BEGIN



		---------------------------------------------------------------------------

		print @TabChar + @TabChar + (case when @FirstColumn = 1 then '' else ',' end) + '['+@ColumnName+']'

		---------------------------------------------------------------------------

		if @FirstColumn = 1
		begin
			set @FirstColumn = 0
		end

		FETCH NEXT FROM column_cursor INTO @ColumnName

		END

		CLOSE column_cursor;  
		DEALLOCATE column_cursor;  

	---------------------------------------------------------------------------

	print @TabChar + 'FROM'
	print @TabChar + @TabChar + '['+@SchemaName+'].['+@ObjectName+'] WITH (NOLOCK)'
	print 'GO'
	print ''

	FETCH NEXT FROM table_cursor INTO
		@ObjectId,
		@ObjectName,
		@SchemaName
END

CLOSE table_cursor;  
DEALLOCATE table_cursor;  