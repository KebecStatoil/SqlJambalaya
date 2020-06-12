/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000)
	max([Created])[Created]
	,max([Updated])[Updated]
	,[SourceSystem]
	,[SourceDataset]
FROM
	[Common].[DataTransferLog]
where
	SourceSystem = 'SafranProject'
	and  not (
		SourceDataset = 'SafranProject'
		and DestinationDataset = 'SafranProject'
	)
	and Status = 'Failed'
group by
	SourceSystem,
	SourceDataset
order by
	max(Created) desc
