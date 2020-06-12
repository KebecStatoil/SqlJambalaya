/****** Object:  StoredProcedure [Any2Omnia].[GetSourceSQL]    Script Date: 11.09.2019 11:14:10 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE   PROC [Any2Omnia].[GetSourceSQL]
	@JobName [nvarchar](255),
	@SourceSchema [nvarchar](255),
	@SourceTableOrView [nvarchar](255),
	@RunMode [nvarchar](255),
	@Columns [nvarchar](MAX)
AS
BEGIN
	/* Prepare Extraction SQL
	*/
	DECLARE
		@Result [nvarchar](max),
		@StatsSQL [nvarchar](max);

	DECLARE @SourceType [nvarchar](255);
	select @SourceType = [SourceType] from [Any2Omnia].[Jobs] where [JobName] = @JobName
	
	DECLARE
		@ExtractionSQL [nvarchar](max),
		@HighWaterColumn [nvarchar](255),
		@HighWaterMark [datetime2](7);

	select @ExtractionSQL = [ExtractionSQL],
		@HighWaterMark = HighWaterMark,
		@HighWaterColumn = HighWaterColumn
		from [Any2Omnia].[Jobs_Datasets] where [JobName] = @JobName and [SourceSchema] = @SourceSchema and [SourceTableOrView] = @SourceTableOrView

	-- Prepare Columns List for extraction (Remove skipped columns, and add hashing call
	DECLARE @ColumnsTable TABLE(ColumnName nvarchar(255), SkipInCopy bit, OneWayHash bit, Processed bit, finalText nvarchar(500));

	insert into @ColumnsTable(ColumnName, SkipInCopy, OneWayHash)
	select AllCols.[name], SkipInCopy, OneWayHash
		from OPENJSON(@Columns)
			with
			(
				[name] nvarchar(255)
			) as AllCols
		left join [Any2Omnia].[Jobs_Datasets_SpecialColumns] sc on sc.ColumnName = AllCols.[name] and sc.JobName = @JobName and sc.SourceSchema = @SourceSchema and sc.SourceTableOrView = @SourceTableOrView

	-- Iterate columns temp table string
	while exists(select 1 from @ColumnsTable where isnull([Processed], 0) = 0)
	begin
		DECLARE @ThisColName nvarchar(255),
				@SkipInCopy bit,
				@OneWayHash bit,
				@FinalText nvarchar(500);
		select top 1 
			@ThisColName = ColumnName,
			@SkipInCopy = SkipInCopy,
			@OneWayHash = OneWayHash
		from @ColumnsTable where isnull([Processed], 0) = 0;

		--if @SkipInCopy = 1
		--begin
		--	delete from @ColumnsTable where ColumnName = @ThisColName;
		--end
		--else
		begin
			print @ThisColName
			IF (@SourceType = 'Oracle') 
			begin
				SET @FinalText = '"' + @ThisColName + '"';
			end
			else
			begin
				SET @FinalText = '[' + @ThisColName + ']';
			end

			if @SkipInCopy = 1
			begin
				SET @FinalText = ''''' as "' + @ThisColName + '"';
			end

			IF @OneWayHash = 1
			begin
				print @ThisColName
				IF (@SourceType = 'Oracle') 
				begin
					SET @FinalText = 'ORA_HASH(' + @FinalText + ') as "' + @ThisColName + '"';
				end
				else
				begin
					SET @FinalText = 'HASHBYTES(''SHA2_256'',' + @FinalText + ') as [' + @ThisColName + ']';
				end
			end;

			update @ColumnsTable set
				Processed = 1,
				finalText = @FinalText
			where ColumnName = @ThisColName;
		end;
	end

	DECLARE @ExtractionColumns [nvarchar](max);
	select @ExtractionColumns = STRING_AGG(finalText,', ') from @ColumnsTable;

	-- Prepare Extraction SQL (inner)
	IF (isnull(@ExtractionSQL,'') = '')
	begin
		if (@SourceType = 'Oracle')
			SET @ExtractionSQL = 'select * from "' + @SourceSchema+'"."' + @SourceTableOrView + '"';
		else 
			SET @ExtractionSQL = 'select * from [' + @SourceSchema+'].[' + @SourceTableOrView + ']';
	end

	-- Build result
	SET @Result = 'select ' + isnull(@ExtractionColumns,'') + ' from (' + @ExtractionSQL + ') Data';

	if (@RunMode='Delta' and @HighWaterMark is not null)
	begin
		-- NOTE: Chops of at 19 characters to get rid of fractions (rounds to closest second). This should make sure we get at least the data we need.
		DECLARE @HighWaterMarkString nvarchar(19) = CONVERT(nvarchar(19), @HighWaterMark, 126);
		IF (@SourceType = 'Oracle') 
		begin
			SET @Result = @Result + char(13) +
			' where [' + @HighWaterColumn + '] >= to_timestamp(''' + @HighWaterMarkString + ''',''YYYY-MM-DD"T"HH24:MI:SS.ff9'')';
		end
		else
		begin
			SET @Result = @Result + char(13) +
			' where [' + @HighWaterColumn + '] >= convert(datetime2(7), ''' + @HighWaterMarkString + ''')';
		end;
	end;
	if @SourceType = 'Oracle'
		SET @StatsSQL = 'SELECT SYS_EXTRACT_UTC(SYSTIMESTAMP) "ExtractionTimeUTC", count(*) "RowCountSource" FROM  "' + @SourceSchema+'"."' + @SourceTableOrView + '"'
	else
		SET @StatsSQL = 'SELECT getUtcDate() [ExtractionTimeUTC], count(*) [RowCountSource] FROM [' + @SourceSchema+'].[' + @SourceTableOrView + '] '

	select @Result as [SQL], @StatsSQL as [StatsSQL];
END
GO


