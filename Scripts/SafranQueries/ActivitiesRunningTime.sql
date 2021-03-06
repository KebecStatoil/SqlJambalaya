/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000)
	--DATEDIFF(minute, [ExtractionTimeUTC], [CompletedTimeUTC])
	DATEDIFF(minute, [Created], [Updated]) minutes
	,case when [Created] = [Updated] then cast(DATEDIFF(minute, [ExtractionTimeUTC], SYSUTCDATETIME()) as nvarchar(max)) + '...' else 'complete' end state
	,[Created]
	,[Updated]
	,[SourceSystem]
	,[SourceDataset] 
	,[DestinationDataset]
	,[PipelineRunId]
	,[ExtractionTimeUTC]
	,[RowCountSource]
	,[RowCountDestination]
	,[CompletedTimeUTC]
	,[Status]
	,[ErrorMessage]
	,[TransferType]
FROM
	[Insights].[DataTransferLog]
where
	SourceSystem = 'Safran'
	and DestinationDataset = 'safran_Staging.A2O_ACTIVITies'
order by
	Created desc