/* PAHW. A script to generate insert statement for data from a table.
   NOTE: This script does not handle data-types properly, but instead treats all columns as strings!
*/


DECLARE @TableSchema nvarchar(255) = 'dbo'
DECLARE @TableName nvarchar(255) = 'WorkOrderOperation'
DECLARE @TableAliasColumnPrefix nvarchar(5) = 'wo.'  -- Always use prefix and DOT (e.g. 'w.') or leave empty string
DECLARE @TopN nvarchar(255) = ''; -- Leave empty string for all rows
DECLARE @WhereClause nvarchar(max) = 'where Iwerk = 1766 and fsavd <= ''2018-10-25'' and fsedd >= ''2018-10-05'' ';

DECLARE @Statement nvarchar(max);
set @Statement = 'select ' + @TopN + ' ''insert into ['+@TableSchema+'].['+@TableName+']('+
stuff((
    SELECT ', [' + cast(COLUMN_NAME as varchar(max))+']'
    FROM INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = @TableName and TABLE_SCHEMA=@TableSchema order by ordinal_position
    FOR XML PATH('')
    ), 1, 2, '')+')'
+ ' values(''+'+
stuff((
    SELECT ',''+isnull(char(39)+replace(replace(replace(convert(nvarchar(max),' + @TableAliasColumnPrefix + COLUMN_NAME+'),char(39),char(39)+char(39)),char(13),''''''+char(13)+''''''),char(10),''''''+char(10)+'''''')+char(39),''NULL'')+'''
    FROM INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = @TableName and TABLE_SCHEMA=@TableSchema order by ordinal_position
    FOR XML PATH('')
    ), 1, 3, '')
	+');'' from ['+@TableSchema+'].[' + @TableName + '] ' + @WhereClause
select @Statement
--EXECUTE sp_executesql @Statement

/* use this a the query...
from (
	select distinct wo.*
	from
	  [dbo].[WorkOrder] w
	  join [dbo].[WorkOrderOperation] wo
		on wo.aufnr_fk = w.aufnr
	where
	  Iwerk = 1766
	  and fsavd <= '2018-10-25'
	  and fsedd >= '2018-10-05'
) wo
*/