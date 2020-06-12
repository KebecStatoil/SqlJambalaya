/****** Object:  StoredProcedure [ReportVision_Staging].[SwapOrMergeStagingToFull]    Script Date: 04.03.2020 10:50:22 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



/*****************************************************************************************************
******************************************************************************************************
**																									**
**		STANDARD OBJECTS BELOW HERE. THESE SHOULD NOT HAVE TO CHANGE BASED ON SOLUTION				**
**																									**
**		Proc:	[SwapOrMergeStagingToFull]															**
**		Proc:	[DDLCreateCopyOfTable]																**
**		Proc:	[DDLCopyTablesFromSchemaToSchema]													**
**																									**
******************************************************************************************************
******************************************************************************************************/


ALTER   PROC [ReportVision_Staging].[SwapOrMergeStagingToFull]
	@DestinationTable [nvarchar](255),
	@RunMode [nvarchar](255),
	@HighWaterColumn [nvarchar](255)
AS
BEGIN
	/* Prepare Partition Swap or Merge SQL
	*/
	DECLARE 
		@crlf nvarchar(2) = char(13)+char(10),
		@Result [nvarchar](max);
	print 'Start'
	DECLARE
		@StagingSchema [nvarchar](255) = 'ReportVision_Staging',
		@MainSchema [nvarchar](255) = 'ReportVision',
		@HighWaterMarkSQL nvarchar(500)= '(select null) as [HighWaterMark]';

	if (isnull(@HighWaterColumn,'')  != '')
		SET @HighWaterMarkSQL = '(select max(['+@HighWaterColumn+']) from [' + @MainSchema + '].[' + @DestinationTable + '])  as [HighWaterMark]';

	if @RunMode='Full'
	begin
		SET @Result = 
			'begin tran ' + @crlf +
			'	truncate table [' + @MainSchema + '].[' + @DestinationTable + ']' + @crlf +
			'	alter table [' + @StagingSchema + '].[' + @DestinationTable + '] switch to [' + @MainSchema + '].[' + @DestinationTable + ']' + @crlf +
			'commit tran;' + @crlf +
			'select ' + @crlf +
			'	''[' + @MainSchema + '].[' + @DestinationTable + ']'' as DestinationTableName,' + @crlf +
			'	count(*) as RowCountDestination,' + @crlf + 
			'	0 as RowsUpdated,' + @crlf + 
			'	count(*) as RowsInserted,' + @crlf + 
			'	sysutcdatetime() as CompletionTimeUTC,' + @crlf +
			'	' + @HighWaterMarkSQL + @crlf +
			'from [' + @MainSchema + '].[' + @DestinationTable + '] with (nolock);';
	end
	else
	begin
		-- Prepare Columns List for generating merge statement
		DECLARE @ColumnsTable TABLE(ColumnName nvarchar(255), PK bit, SkipInCopy bit);

		insert into @ColumnsTable(ColumnName, PK)
		select c.[Name], case when ic.column_id is null then 0 else 1 end PK
			from sys.columns c
			left join sys.indexes as pk on pk.object_id = c.object_id  and is_primary_key=1
			left join sys.index_columns as ic
				on ic.object_id = pk.object_id
				and ic.index_id = pk.index_id
				and ic.column_id = c.column_id
			where c.object_id = OBJECT_ID('['+@MainSchema+'].['+@DestinationTable+']');

		DECLARE @AllColumns nvarchar(max);
		select @AllColumns = STRING_AGG('[' + ColumnName + ']',', ')
			from @ColumnsTable;

		DECLARE @JoinsPrimKeys nvarchar(max);
		select @JoinsPrimKeys = STRING_AGG('[target].[' + ColumnName + '] = [source].[' + ColumnName + ']',' AND ')
			from @ColumnsTable where isnull(PK, 0) = 1;

		if @JoinsPrimKeys is null -- this is nonsense, but keeps @Result from nulling out.
		begin -- if the table has no primary key, try to match on everyhting but the system change number. 
			select @JoinsPrimKeys = STRING_AGG(cast('[target].[' + ColumnName + '] = [source].[' + ColumnName + ']' as nvarchar(max)),' AND ')
			from @ColumnsTable; -- exclude Omnia metadata columns eg:  where ColumnName <> 'META_ORAROWSCN'
		end

		-- print ' @JoinsPrimKeys' + @JoinsPrimKeys -- Debug

		DECLARE @DiffCompare nvarchar(max);
		select @DiffCompare = STRING_AGG(cast('[target].[' + ColumnName + '] <> [source].[' + ColumnName + '] OR ' +
				'([target].[' + ColumnName + '] IS NULL AND [source].[' + ColumnName + '] IS NOT NULL) OR '+
				'([target].[' + ColumnName + '] IS NOT NULL AND [source].[' + ColumnName + '] IS NULL)' as nvarchar(max)),' OR ')
			from @ColumnsTable where isnull(PK, 0) = 0;
		
		DECLARE @UpdateSets nvarchar(max);
		select @UpdateSets = STRING_AGG('[' + ColumnName + '] = [source].[' + ColumnName + ']',', ')
			from @ColumnsTable where isnull(PK, 0) = 0;

		SET @Result = 'DECLARE @CHANGES TABLE([Action] VARCHAR(20))' + @crlf +
			'MERGE INTO [' + @MainSchema + '].[' + @DestinationTable + '] WITH (HOLDLOCK) AS target' + @crlf +
			'	USING (SELECT ' + @AllColumns + @crlf +
            '		FROM [' + @StagingSchema + '].[' + @DestinationTable + ']) AS source ' + @crlf +
			'	ON (' + @JoinsPrimKeys +')' + @crlf +
			'	WHEN MATCHED AND ( ' + @DiffCompare + ') THEN' + @crlf +
			'		UPDATE SET ' + @crlf +
			'			' + @UpdateSets + @crlf +
			'	WHEN NOT MATCHED BY TARGET THEN' + @crlf +
			'		INSERT (' + @AllColumns + ')' + @crlf +
			'		VALUES(' + @AllColumns + ')' + @crlf +
			'OUTPUT $action INTO @CHANGES;' + @crlf +
			'select ' + @crlf +
			'	''[' + @MainSchema + '].[' + @DestinationTable + ']'' as DestinationTableName,' + @crlf +
			'	count(*) as RowCountDestination,' + @crlf + 
			'	(select COUNT(*) FROM @CHANGES where [Action] = ''UPDATE'') as RowsUpdated,' + @crlf + 
			'	(select COUNT(*) FROM @CHANGES where [Action] = ''INSERT'') as RowsInserted,' + @crlf + 
			'	sysutcdatetime() as CompletionTimeUTC,' + @crlf +
			'	' + @HighWaterMarkSQL + @crlf +
			'from [' + @MainSchema + '].[' + @DestinationTable + '] with (nolock);';
	end
	EXEC sp_executesql @statement = @Result
END
GO


