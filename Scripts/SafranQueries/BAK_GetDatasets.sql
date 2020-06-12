/****** Object:  StoredProcedure [safran].[GetDatasets]    Script Date: 04.11.2019 11:21:05 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [safran].[GetDatasets]
(
    @TransferType [nvarchar](150),
	@PipelineRunId uniqueidentifier = null
) AS
BEGIN
	DECLARE	@sNow nvarchar(13) = CONVERT(nvarchar(13),getUTCDate(), 126)
	DECLARE
		@sYear nvarchar(4) = SUBSTRING(@sNow, 1, 4),
		@sMonth nvarchar(2) = SUBSTRING(@sNow, 6, 2),
		@sDay nvarchar(2) = SUBSTRING(@sNow, 9, 2),
		@sHour nvarchar(2) = SUBSTRING(@sNow, 12, 2)

	DECLARE @sDlsDailyFolder nvarchar(100) = 'raw/corporate/SafranProject/TEMP/' + @sYear + '/' + @sMonth -- Without terminating slash
	DECLARE @sDlsHourlyFolder nvarchar(100) = 'raw/corporate/SafranProject/TEMP/' + @sYear + '/' + @sMonth + '/' + @sDay -- Without terminating slash

	DECLARE @sYrMonthDay nvarchar(100) = @sYear + '_' + @sMonth + '_' + @sDay
	DECLARE @sYrMonthDayHour nvarchar(100) = @sYear + '_' + @sMonth + '_' + @sDay + '_' + @sHour

	IF @TransferType = 'full' -- daily
	BEGIN
		SELECT 'SafranProject' as [SourceSystem],
			'SAFRANSA.ACTIVITIES' as [SourceDataset],
			'[safran].[ACTIVITIES_STAGING_FULL]' as [DestinationDataset],
			'* ' as [SourceDatasetColumns],
			'ORDER BY NET_ID, SEQ' as [SourceDatasetFilter], -- cludge: ordering
			@sDlsDailyFolder as [DlsFolder],
			'ACTIVITIES_' + @sYrMonthDay + '.json' as [DlsFilename]
		UNION all
		SELECT 'SafranProject' as [SourceSystem],
            'SAFRANSA.ACTIVITIES_TEMP' as [SourceDataset],
            '[safran].[ACTIVITIES_TEMP_Staging]' as [DestinationDataset],
            '*' as [SourceDatasetColumns],
            '' as [SourceDatasetFilter],
            @sDlsDailyFolder  as [DlsFolder],
            'ACTIVITIES_TEMP_' + @sYrMonthDay + '.json' as [DlsFilename]
		UNION all
		SELECT 'SafranProject' as [SourceSystem],
            'SAFRANSA.ACTIVITY_BARS' as [SourceDataset],
            '[safran].[ACTIVITY_BARS_Staging]' as [DestinationDataset],
            '*' as [SourceDatasetColumns],
            '' as [SourceDatasetFilter],
            @sDlsDailyFolder  as [DlsFolder],
            'ACTIVITY_BARS_' + @sYrMonthDay + '.json' as [DlsFilename]
		UNION all
		SELECT 'SafranProject' as [SourceSystem],
            'SAFRANSA.ACTIVITY_HISTORY' as [SourceDataset],
            '[safran].[ACTIVITY_HISTORY_Staging]' as [DestinationDataset],
            '*' as [SourceDatasetColumns],
            '' as [SourceDatasetFilter],
            @sDlsDailyFolder  as [DlsFolder],
            'ACTIVITY_HISTORY_' + @sYrMonthDay + '.json' as [DlsFilename]
		UNION all
		SELECT 'SafranProject' as [SourceSystem],
            'SAFRANSA.ACTIVITY_TEXTS' as [SourceDataset],
            '[safran].[ACTIVITY_TEXTS_STAGING_FULL]' as [DestinationDataset],
            '*' as [SourceDatasetColumns],
            '' as [SourceDatasetFilter],
            @sDlsDailyFolder  as [DlsFolder],
            'ACTIVITY_TEXTS_' + @sYrMonthDay + '.json' as [DlsFilename]
		UNION all
		SELECT 'SafranProject' as [SourceSystem],
            'SAFRANSA.ACT_IMPACT' as [SourceDataset],
            '[safran].[ACT_IMPACT_Staging]' as [DestinationDataset],
            '*' as [SourceDatasetColumns],
            '' as [SourceDatasetFilter],
            @sDlsDailyFolder  as [DlsFolder],
            'ACT_IMPACT_' + @sYrMonthDay + '.json' as [DlsFilename]
		UNION all
		SELECT 'SafranProject' as [SourceSystem],
            'SAFRANSA.ACT_RISK' as [SourceDataset],
            '[safran].[ACT_RISK_Staging]' as [DestinationDataset],
            '*' as [SourceDatasetColumns],
            '' as [SourceDatasetFilter],
            @sDlsDailyFolder  as [DlsFolder],
            'ACT_RISK_' + @sYrMonthDay + '.json' as [DlsFilename]
		UNION all
		SELECT 'SafranProject' as [SourceSystem],
            'SAFRANSA.AVAILABLE_OUTLINE' as [SourceDataset],
            '[safran].[AVAILABLE_OUTLINE_Staging]' as [DestinationDataset],
            '*' as [SourceDatasetColumns],
            '' as [SourceDatasetFilter],
            @sDlsDailyFolder  as [DlsFolder],
            'AVAILABLE_OUTLINE_' + @sYrMonthDay + '.json' as [DlsFilename]
		UNION all
		SELECT 'SafranProject' as [SourceSystem],
            'SAFRANSA.AVAILABLE_REF' as [SourceDataset],
            '[safran].[AVAILABLE_REF_Staging]' as [DestinationDataset],
            '*' as [SourceDatasetColumns],
            '' as [SourceDatasetFilter],
            @sDlsDailyFolder  as [DlsFolder],
            'AVAILABLE_REF_' + @sYrMonthDay + '.json' as [DlsFilename]
		UNION all
		SELECT 'SafranProject' as [SourceSystem],
            'SAFRANSA.BASELINE_A' as [SourceDataset],
            '[safran].[BASELINE_A_Staging]' as [DestinationDataset],
            '*' as [SourceDatasetColumns],
            '' as [SourceDatasetFilter],
            @sDlsDailyFolder  as [DlsFolder],
            'BASELINE_A_' + @sYrMonthDay + '.json' as [DlsFilename]
		UNION all
		SELECT 'SafranProject' as [SourceSystem],
            'SAFRANSA.BASELINE_DIBB' as [SourceDataset],
            '[safran].[BASELINE_DIBB_Staging]' as [DestinationDataset],
            '*' as [SourceDatasetColumns],
            '' as [SourceDatasetFilter],
            @sDlsDailyFolder  as [DlsFolder],
            'BASELINE_DIBB_' + @sYrMonthDay + '.json' as [DlsFilename]
		UNION all
		SELECT 'SafranProject' as [SourceSystem],
            'SAFRANSA.BASELINE_LOG' as [SourceDataset],
            '[safran].[BASELINE_LOG_Staging]' as [DestinationDataset],
            '*' as [SourceDatasetColumns],
            '' as [SourceDatasetFilter],
            @sDlsDailyFolder  as [DlsFolder],
            'BASELINE_LOG_' + @sYrMonthDay + '.json' as [DlsFilename]
		UNION all
		SELECT 'SafranProject' as [SourceSystem],
            'SAFRANSA.CALENDARS' as [SourceDataset],
            '[safran].[CALENDARS_Staging]' as [DestinationDataset],
            '*' as [SourceDatasetColumns],
            '' as [SourceDatasetFilter],
            @sDlsDailyFolder  as [DlsFolder],
            'CALENDARS_' + @sYrMonthDay + '.json' as [DlsFilename]
		UNION all
		SELECT 'SafranProject' as [SourceSystem],
            'SAFRANSA.CODESET' as [SourceDataset],
            '[safran].[CODESET_STAGING_FULL]' as [DestinationDataset],
            '*' as [SourceDatasetColumns],
            '' as [SourceDatasetFilter],
            @sDlsDailyFolder  as [DlsFolder],
            'CODESET_' + @sYrMonthDay + '.json' as [DlsFilename]
		UNION all
		SELECT 'SafranProject' as [SourceSystem],
            'SAFRANSA.HISTORY_A' as [SourceDataset],
            '[safran].[HISTORY_A_Staging]' as [DestinationDataset],
            '*' as [SourceDatasetColumns],
            '' as [SourceDatasetFilter],
            @sDlsDailyFolder  as [DlsFolder],
            'HISTORY_A_' + @sYrMonthDay + '.json' as [DlsFilename]
		UNION all
		SELECT 'SafranProject' as [SourceSystem],
            'SAFRANSA.MP_MASTER' as [SourceDataset],
            '[safran].[MP_MASTER_Staging]' as [DestinationDataset],
            '*' as [SourceDatasetColumns],
            '' as [SourceDatasetFilter],
            @sDlsDailyFolder  as [DlsFolder],
            'MP_MASTER_' + @sYrMonthDay + '.json' as [DlsFilename]
		UNION all
		SELECT 'SafranProject' as [SourceSystem],
            'SAFRANSA.MP_MEMBER' as [SourceDataset],
            '[safran].[MP_MEMBER_Staging]' as [DestinationDataset],
            '*' as [SourceDatasetColumns],
            '' as [SourceDatasetFilter],
            @sDlsDailyFolder  as [DlsFolder],
            'MP_MEMBER_' + @sYrMonthDay + '.json' as [DlsFilename]
		UNION all
		SELECT 'SafranProject' as [SourceSystem],
            'SAFRANSA.MSP_UFIELD_MAPPING' as [SourceDataset],
            '[safran].[MSP_UFIELD_MAPPING_Staging]' as [DestinationDataset],
            '*' as [SourceDatasetColumns],
            '' as [SourceDatasetFilter],
            @sDlsDailyFolder  as [DlsFolder],
            'MSP_UFIELD_MAPPING_' + @sYrMonthDay + '.json' as [DlsFilename]
		UNION all
		SELECT 'SafranProject' as [SourceSystem],
            'SAFRANSA.NETWORKS' as [SourceDataset],
            '[safran].[NETWORKS_Staging]' as [DestinationDataset],
            '*' as [SourceDatasetColumns],
            '' as [SourceDatasetFilter],
            @sDlsDailyFolder  as [DlsFolder],
            'NETWORKS_' + @sYrMonthDay + '.json' as [DlsFilename]
		UNION all
		SELECT 'SafranProject' as [SourceSystem],
            'SAFRANSA.OUTLINE_CODES' as [SourceDataset],
            '[safran].[OUTLINE_CODES_STAGING_FULL]' as [DestinationDataset],
            '*' as [SourceDatasetColumns],
            '' as [SourceDatasetFilter],
            @sDlsDailyFolder  as [DlsFolder],
            'OUTLINE_CODES_' + @sYrMonthDay + '.json' as [DlsFilename]
		UNION all
		SELECT 'SafranProject' as [SourceSystem],
            'SAFRANSA.RESOURCES' as [SourceDataset],
            '[safran].[RESOURCES_STAGING_FULL]' as [DestinationDataset],
            '*' as [SourceDatasetColumns],
            '' as [SourceDatasetFilter],
            @sDlsDailyFolder  as [DlsFolder],
            'RESOURCES_' + @sYrMonthDay + '.json' as [DlsFilename]
	END
	ELSE 
	BEGIN -- 'partial' : run hourly
		SELECT 'SafranProject' as [SourceSystem],
			'SAFRANSA.ACTIVITIES A ' as [SourceDataset],
			'[safran].[ACTIVITIES_STAGING_DELTA]' as [DestinationDataset],
			'''' + CAST(@PipelineRunId AS char(36)) + ''' META_RUNID, A.*' as [SourceDatasetColumns],
			'WHERE ORA_ROWSCN >= TIMESTAMP_TO_SCN(FROM_TZ(TO_TIMESTAMP(''' 
				+ format([safran].[GetHighWaterMark]('{;SAFRANSA.ACTIVITIES A ;SAFRANSA.ACTIVITIES;}', '{;[safran].[ACTIVITIES_STAGING_DELTA];[safran].[ACTIVITIES_STAGING_FULL];}', '%'), 'yyyy.MM.dd HH:mm:ss') 
				+ ''', ''YYYY.MM.DD HH24:MI:SS''), ''UTC'' ) AT LOCAL) '
				+ ' ORDER BY NET_ID, SEQ' as [SourceDatasetFilter], -- cludge: ordering
			@sDlsHourlyFolder as [DlsFolder],
			'ACTIVITIES_' + @sYrMonthDayHour + '.delta.json' as [DlsFilename]
		UNION all
		SELECT 'SafranProject' as [SourceSystem],
			'SAFRANSA.ACTIVITIES' as [SourceDataset],
			'[safran].[ACTIVITIES_STAGING_KEYLIST]' as [DestinationDataset],
			'''' + CAST(@PipelineRunId AS char(36)) + ''' META_RUNID, SEQ, NET_ID' as [SourceDatasetColumns],
			' ORDER BY NET_ID, SEQ' as [SourceDatasetFilter], -- cludge: ordering
			@sDlsHourlyFolder as [DlsFolder],
			'ACTIVITIES_KEYLIST_' + @sYrMonthDayHour + '.delta.json' as [DlsFilename]
		UNION all		
		SELECT 'SafranProject' as [SourceSystem],
			'SAFRANSA.ACTIVITY_TEXTS A ' as [SourceDataset],
			'[safran].[ACTIVITY_TEXTS_STAGING_DELTA]' as [DestinationDataset],
			'''' + CAST(@PipelineRunId AS char(36)) + ''' META_RUNID, A.*' as [SourceDatasetColumns],
			'WHERE ORA_ROWSCN >= TIMESTAMP_TO_SCN(FROM_TZ(TO_TIMESTAMP(''' 
				+ format([safran].[GetHighWaterMark]('{;SAFRANSA.ACTIVITY_TEXTS A ;SAFRANSA.ACTIVITY_TEXTS;}', '{;[safran].[ACTIVITY_TEXTS_STAGING_DELTA];[safran].[ACTIVITY_TEXTS_STAGING_FULL];}', '%'), 'yyyy.MM.dd HH:mm:ss') 
				+ ''', ''YYYY.MM.DD HH24:MI:SS''), ''UTC'' ) AT LOCAL) '
				+ ' ORDER BY NET_ID, SEQ, FIELD_NR' as [SourceDatasetFilter], -- cludge: ordering
			@sDlsHourlyFolder as [DlsFolder],
			'ACTIVITY_TEXTS_' + @sYrMonthDayHour + '.delta.json' as [DlsFilename]
		UNION all
		SELECT 'SafranProject' as [SourceSystem],
			'SAFRANSA.ACTIVITY_TEXTS' as [SourceDataset],
			'[safran].[ACTIVITY_TEXTS_STAGING_KEYLIST]' as [DestinationDataset],
			'''' + CAST(@PipelineRunId AS char(36)) + ''' META_RUNID, SEQ, NET_ID, FIELD_NR' as [SourceDatasetColumns],
			' ORDER BY NET_ID, SEQ, FIELD_NR' as [SourceDatasetFilter], -- cludge: ordering
			@sDlsHourlyFolder as [DlsFolder],
			'ACTIVITY_TEXTS_KEYLIST_' + @sYrMonthDayHour + '.delta.json' as [DlsFilename]
		UNION all		
		SELECT 'SafranProject' as [SourceSystem],
			'SAFRANSA.CODESET A ' as [SourceDataset],
			'[safran].[CODESET_STAGING_DELTA]' as [DestinationDataset],
			'''' + CAST(@PipelineRunId AS char(36)) + ''' META_RUNID, A.*' as [SourceDatasetColumns],
			'WHERE ORA_ROWSCN >= TIMESTAMP_TO_SCN(FROM_TZ(TO_TIMESTAMP(''' 
				+ format([safran].[GetHighWaterMark]('{;SAFRANSA.CODESET A ;SAFRANSA.CODESET;}', '{;[safran].[CODESET_STAGING_DELTA];[safran].[CODESET_STAGING_FULL];}', '%'), 'yyyy.MM.dd HH:mm:ss') 
				+ ''', ''YYYY.MM.DD HH24:MI:SS''), ''UTC'' ) AT LOCAL) '
				+ ' ORDER BY CONFIG_ID, CODE, RFIELD_NR' as [SourceDatasetFilter], -- cludge: ordering
			@sDlsHourlyFolder as [DlsFolder],
			'CODESET_' + @sYrMonthDayHour + '.delta.json' as [DlsFilename]
		UNION all
		SELECT 'SafranProject' as [SourceSystem],
			'SAFRANSA.CODESET' as [SourceDataset],
			'[safran].[CODESET_STAGING_KEYLIST]' as [DestinationDataset],
			'''' + CAST(@PipelineRunId AS char(36)) + ''' META_RUNID, CONFIG_ID, CODE, RFIELD_NR' as [SourceDatasetColumns],
			' ORDER BY CONFIG_ID, CODE, RFIELD_NR' as [SourceDatasetFilter], -- cludge: ordering
			@sDlsHourlyFolder as [DlsFolder],
			'CODESET_KEYLIST_' + @sYrMonthDayHour + '.delta.json' as [DlsFilename]	
		UNION all		
		SELECT 'SafranProject' as [SourceSystem],
			'SAFRANSA.OUTLINE_CODES A ' as [SourceDataset],
			'[safran].[OUTLINE_CODES_STAGING_DELTA]' as [DestinationDataset],
			'''' + CAST(@PipelineRunId AS char(36)) + ''' META_RUNID, A.*' as [SourceDatasetColumns],
			'WHERE ORA_ROWSCN >= TIMESTAMP_TO_SCN(FROM_TZ(TO_TIMESTAMP(''' 
				+ format([safran].[GetHighWaterMark]('{;SAFRANSA.OUTLINE_CODES A ;SAFRANSA.OUTLINE_CODES;}', '{;[safran].[OUTLINE_CODES_STAGING_DELTA];[safran].[OUTLINE_CODES_STAGING_FULL];}', '%'), 'yyyy.MM.dd HH:mm:ss') 
				+ ''', ''YYYY.MM.DD HH24:MI:SS''), ''UTC'' ) AT LOCAL) '
				+ ' ORDER BY CONFIG_ID, OC_FIELD, SEQ' as [SourceDatasetFilter], -- cludge: ordering
			@sDlsHourlyFolder as [DlsFolder],
			'OUTLINE_CODES_' + @sYrMonthDayHour + '.delta.json' as [DlsFilename]
		UNION all
		SELECT 'SafranProject' as [SourceSystem],
			'SAFRANSA.OUTLINE_CODES' as [SourceDataset],
			'[safran].[OUTLINE_CODES_STAGING_KEYLIST]' as [DestinationDataset],
			'''' + CAST(@PipelineRunId AS char(36)) + ''' META_RUNID, CONFIG_ID, OC_FIELD, SEQ' as [SourceDatasetColumns],
			' ORDER BY CONFIG_ID, OC_FIELD, SEQ' as [SourceDatasetFilter], -- cludge: ordering
			@sDlsHourlyFolder as [DlsFolder],
			'OUTLINE_CODES_KEYLIST_' + @sYrMonthDayHour + '.delta.json' as [DlsFilename]	
		UNION all		
		SELECT 'SafranProject' as [SourceSystem],
			'SAFRANSA.RESOURCES A ' as [SourceDataset],
			'[safran].[RESOURCES_STAGING_DELTA]' as [DestinationDataset],
			'''' + CAST(@PipelineRunId AS char(36)) + ''' META_RUNID, A.*' as [SourceDatasetColumns],
			'WHERE ORA_ROWSCN >= TIMESTAMP_TO_SCN(FROM_TZ(TO_TIMESTAMP(''' 
				+ format([safran].[GetHighWaterMark]('{;SAFRANSA.RESOURCES A ;SAFRANSA.RESOURCES;}', '{;[safran].[RESOURCES_STAGING_DELTA];[safran].[RESOURCES_STAGING_FULL];}', '%'), 'yyyy.MM.dd HH:mm:ss') 
				+ ''', ''YYYY.MM.DD HH24:MI:SS''), ''UTC'' ) AT LOCAL) '
				+ ' ORDER BY SEQ, NET_ID' as [SourceDatasetFilter], -- cludge: ordering
			@sDlsHourlyFolder as [DlsFolder],
			'RESOURCES_' + @sYrMonthDayHour + '.delta.json' as [DlsFilename]
		UNION all
		SELECT 'SafranProject' as [SourceSystem],
			'SAFRANSA.RESOURCES' as [SourceDataset],
			'[safran].[RESOURCES_STAGING_KEYLIST]' as [DestinationDataset],
			'''' + CAST(@PipelineRunId AS char(36)) + ''' META_RUNID, SEQ, NET_ID' as [SourceDatasetColumns],
			' ORDER BY NET_ID, SEQ' as [SourceDatasetFilter], -- cludge: ordering
			@sDlsHourlyFolder as [DlsFolder],
			'RESOURCES_KEYLIST_' + @sYrMonthDayHour + '.delta.json' as [DlsFilename]	
	END
END
GO


