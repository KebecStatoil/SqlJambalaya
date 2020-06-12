
--/*
-- *  Populate Table
-- */
-- select * into [testing].[ACTIVITIES_Keylist_WithDuplicates] from [testing].[ACTIVITIES_Keylist_pk_on]

--/*
-- *  Add Duplicates
-- */
-- insert into [testing].[ACTIVITIES_Keylist_WithDuplicates] select top 10000 * from [testing].[ACTIVITIES_Keylist_pk_on] order by newid()

--/*
-- *  Remove Duplicates
-- */
-- --src: https://stackoverflow.com/questions/18390574/how-to-delete-duplicate-rows-in-sql-server
--WITH cte_ExposeDuplicates AS(
--	SELECT
--		[NET_ID],
--		[SEQ],
--		ROW_NUMBER()OVER(PARTITION BY [NET_ID],[SEQ] ORDER BY [NET_ID],[SEQ]) RowNumber
--	FROM
--		[testing].[ACTIVITIES_Keylist_WithDuplicates]
--)
--DELETE FROM cte_ExposeDuplicates WHERE RowNumber > 1

--/*
-- *  Try to Add the Key
-- */
--ALTER TABLE
--	[testing].[ACTIVITIES_Keylist_WithDuplicates]
--ADD
--	CONSTRAINT [PK_ACTIVITIES_Keylist_WithDuplicates] PRIMARY KEY CLUSTERED ([NET_ID] ASC, [SEQ] ASC) WITH (
--		STATISTICS_NORECOMPUTE = OFF,
--		IGNORE_DUP_KEY = OFF,
--		ONLINE = OFF
--	) ON [PRIMARY];

--/*
-- *  Remove the Key
-- */
-- ALTER TABLE [testing].[ACTIVITIES_Keylist_WithDuplicates] DROP CONSTRAINT [PK_ACTIVITIES_Keylist_WithDuplicates] WITH (ONLINE = OFF);

--/*
-- *  Drop Table
-- */
-- DROP TABLE [testing].[ACTIVITIES_Keylist_WithDuplicates]