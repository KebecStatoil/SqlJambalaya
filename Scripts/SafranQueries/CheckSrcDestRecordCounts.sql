/****** Script for SelectTopNRows command from SSMS  ******/
--SELECT
--	[Created]
--	,[Updated]
--	,[SourceSystem]
--	,[SourceDataset]
--	/*,*/[DestinationDataset]
--	,[PipelineRunId]
--	,[ExtractionTimeUTC]
--	,[RowCountDestination]-[RowCountSource] RowDiff
--	,[RowCountSource]
--	,[RowCountDestination]
--	,[CompletedTimeUTC]
--	,[Status]
--	,[ErrorMessage]
--	,[TransferType]
--FROM
--	[Common].[DataTransferLog]
--where
--	SourceSystem like '%safran%'
--	and [RowCountDestination]-[RowCountSource] <> 0
--order by
--	updated desc

with LatestRun as (
	SELECT
		[SourceDataset]
		,[DestinationDataset]
		,max(ExtractionTimeUTC) ExtractionTimeUTC
	FROM
		[Common].[DataTransferLog]
	where
		SourceSystem like '%safran%'
	group by
		[SourceDataset]
		,[DestinationDataset]
)

select
	[RowCountDestination]-[RowCountSource] RowDiff
	,xferlog.*
from
	LatestRun latest
	join [Common].[DataTransferLog] xferlog
		on xferlog.SourceDataset = latest.SourceDataset
		and xferlog.DestinationDataset = latest.DestinationDataset
		and xferlog.ExtractionTimeUTC = latest.ExtractionTimeUTC
order by
	xferlog.[SourceDataset]
	,xferlog.[DestinationDataset]