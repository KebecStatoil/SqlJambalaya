
----SELECT
----	[JobName],
----	[SourceSchema],
----	[SourceTableOrView],
----	[DestinationSchema],
----	[DestinationStagingSchema],
----	[DestinationTable],
----	[ExtractionSQL],
----	[HighWaterColumn],
----	[FilenameTemplate],
----	[Enabled],
----	[FullCopyOnNextRun],
----	[HighWaterMarkSCN]
----FROM
----	[Any2Omnia].[Jobs_Datasets]
----order by
----	JobName,
----	SourceTableOrView


----insert into [Any2Omnia].[Jobs_Datasets] (
----	[JobName],
----	[SourceSchema],
----	[SourceTableOrView],
----	[DestinationSchema],
----	[DestinationStagingSchema],
----	[DestinationTable],
----	[ExtractionSQL],
----	[HighWaterColumn],
----	[FilenameTemplate],
----	[Enabled],
----	[FullCopyOnNextRun],
----	[HighWaterMarkSCN]
----)
select
	[JobName]
	,'SAFRANSA' [SourceSchema]
	,o.name [SourceTableOrView]
	,'safran' [DestinationSchema]
	,'safran_staging' [DestinationStagingSchema]
	,o.name [DestinationTable]
	,'select ora_rowscn meta_OraRowScn, {{SourceDatabase}} META_SourceDatabase, T.* from SAFRANSA.' + o.name + ' T WHERE rownum < 1000' [ExtractionSQL]
	,'meta_OraRowScn' [HighWaterColumn]
	,'%SourceTableOrView%_%YY%_%MM%_%DD%_%hh%_%mm%_%ss%_%RunMode%.parquet' [FilenameTemplate]
	,1 [Enabled]
	,0 [FullCopyOnNextRun]
	,1 [HighWaterMarkSCN]
from
	sys.objects o
	join sys.schemas s
	on s.schema_id = o.schema_id
	cross join [Any2Omnia].[Jobs]
where
	o.type = 'u'
	and s.name = 'safran'
order by
	JobName,
	SourceTableOrView