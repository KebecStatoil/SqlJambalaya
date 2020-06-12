
/*
 *  List Transfers by Status & TransferType
 */
--SELECT
--[SourceSystem],
--	[SourceDataset]
--	,[DestinationDataset]
--	,[Status]
--	,[TransferType]
--	,COUNT(*) [RunCount]
--FROM
--	[Common].[DataTransferLog]
--WHERE
--	[SourceSystem] like 'DataFactoryTesting'
--	AND [CREATED] > dateadd(day, -2, cast(getdate() as date))
--	AND [TransferType] = 'full'
--GROUP BY
--	[SourceSystem]
--	,[TransferType]
--	,[SourceDataset]
--	,[DestinationDataset]
--	,[Status]
--ORDER BY
--	[SourceSystem]
--	,[TransferType]
--	,[SourceDataset]
--	,[DestinationDataset]
--	,[Status]




/*
 *  List Runs
 */
SELECT
	[SourceDataset]
	,[DestinationDataset]
	--,[PipelineRunId]
	,[ExtractionTimeUTC]
	,[RowCountSource]
	,[RowCountDestination]
	,[CompletedTimeUTC]
	,datediff(minute,[ExtractionTimeUTC] , [CompletedTimeUTC]) runningtimeinminutes
	,[Status]
	,[ErrorMessage]
	,[TransferType]
FROM
	[Common].[DataTransferLog]
WHERE
	[SourceSystem] like 'safranproject'
	AND [CREATED] > dateadd(day, -4, cast(getdate() as date))
	--AND [TransferType] = 'full'
ORDER BY
	[Created] desc

