/****** Object:  View [acquisition_v].[FinalNavigation]    Script Date: 09.12.2019 23:43:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
 
CREATE OR ALTER VIEW [acquisition_v].[FinalNavigation] AS
	SELECT
		[SurveyID],
		[FinalNavigationID],
		[QaStatus],
		[QaMsg]
	FROM [acquisition].[FinalNavigation]
GO
/****** Object:  View [acquisition_v].[GunInfo]    Script Date: 09.12.2019 23:43:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
 
CREATE OR ALTER VIEW [acquisition_v].[GunInfo] AS
	SELECT
		[SurveyID],
		[ShotInfoID],
		[subarray_num],
		[gun_num],
		[gun_mask],
		[gun_depth],
		[gun_pressure]
	FROM [acquisition].[GunInfo]
GO
/****** Object:  View [acquisition_v].[Navigation]    Script Date: 09.12.2019 23:43:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
 
CREATE OR ALTER VIEW [acquisition_v].[Navigation] AS
	SELECT
		[SurveyID],
		[NavigationID],
		[QaStatus],
		[QaMsg]
	FROM [acquisition].[Navigation]
GO
/****** Object:  View [acquisition_v].[NextShotInfo]    Script Date: 09.12.2019 23:43:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
 
CREATE OR ALTER VIEW [acquisition_v].[NextShotInfo] AS
	SELECT
		[SurveyID],
		[ShotTimeNumber],
		[ShotInfoID],
		[shottime],
		[NextShotTimeNumber],
		[NextShotInfoID],
		[NextShotTime]
	FROM [acquisition].[NextShotInfo]
GO
/****** Object:  View [acquisition_v].[ShotInfo]    Script Date: 09.12.2019 23:43:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER VIEW [acquisition_v].[ShotInfo] AS
	SELECT
		[SurveyID],
		[ShotInfoID],
		[type],
		[imo_num],
		[mmsi_num],
		[survey_name],
		[survey_id],
		[shottime],
		[shotpoint_num],
		[sailline_num],
		[srcline_num],
		[seq_num],
		[epsg],
		[northing],
		[easting],
		[vessel_speed],
		[bearing],
		[water_depth],
		[src_num],
		[gun_mask],
		[src_delay],
		[QaStatus],
		[QaMsg],
		[EnqueuedTimeUtc],
		[Created]
	FROM [acquisition].[ShotInfo]
GO
/****** Object:  View [acquisition_v].[ShotInfoMinimal]    Script Date: 09.12.2019 23:43:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE OR ALTER VIEW [acquisition_v].[ShotInfoMinimal] AS
	SELECT
		[SurveyID],
		[shottime],
		[shotpoint_num],
		[sailline_num],
		[srcline_num],
		[northing],
		[easting],
		[inline],
		[crossline],
		[radial],
		[latency]
	FROM [acquisition].[ShotInfoMinimal]
GO
/****** Object:  View [acquisition_v].[ShotInfoWithGunInfo]    Script Date: 09.12.2019 23:43:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

 
CREATE OR ALTER VIEW [acquisition_v].[ShotInfoWithGunInfo] AS
	SELECT
		[SurveyID],
		[type],
		[imo_num],
		[mmsi_num],
		[survey_name],
		[survey_id],
		[shottime],
		[shotpoint_num],
		[sailline_num],
		[seq_num],
		[epsg],
		[northing],
		[srcline_num],
		[easting],
		[bearing],
		[vessel_speed],
		[water_depth],
		[src_num],
		[gun_mask],
		[src_delay],
		[guninfo]
	FROM [acquisition].[ShotInfoWithGunInfo]
GO
/****** Object:  View [management_v].[Company]    Script Date: 09.12.2019 23:43:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE OR ALTER VIEW [management_v].[Company] AS
	SELECT
		[Company_ID],
		[Recording],
		[Source],
		[CompanyName]
	FROM [management].[Company] WITH (NOLOCK)
GO
/****** Object:  View [management_v].[Discovery]    Script Date: 09.12.2019 23:43:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
 
CREATE OR ALTER VIEW [management_v].[Discovery] AS
	SELECT
		[IDDISCOVER],
		[DISCNAME],
		[IDFIELD],
		[RESIDSCNME],
		[INC_IN_FLD],
		[MAP_DSC_HC],
		[DSC_HCTYPE],
		[DSCACTSTAT],
		[LABEL],
		[FACTURL]
	FROM [management].[Discovery] WITH (NOLOCK)
GO
/****** Object:  View [management_v].[Field]    Script Date: 09.12.2019 23:43:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
 
CREATE OR ALTER VIEW [management_v].[Field] AS
	SELECT
		[IDFIELD],
		[FIELDNAME],
		[FIELDURL]
	FROM [management].[Field] WITH (NOLOCK)
GO
/****** Object:  View [management_v].[Map]    Script Date: 09.12.2019 23:43:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
 
CREATE OR ALTER VIEW [management_v].[Map] AS
	SELECT
		[MAPNUMBER],
		[IDDISCOVER],
		[type],
		[geometry]
	FROM [management].[Map] WITH (NOLOCK)
GO
/****** Object:  View [security_v].[ApplicationRoleSurveyAccess]    Script Date: 09.12.2019 23:43:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO



CREATE OR ALTER VIEW [security_v].[ApplicationRoleSurveyAccess] AS

	WITH InternalGroupAllSurveys AS (
		SELECT
			R.RoleName GroupRole,
			SurveyID,
			survey_name
		FROM
			[survey].[Survey] WITH (NOLOCK)
			CROSS JOIN [security].[ApplicationRole] R WITH (NOLOCK)
		WHERE
			R.RoleName = 'NGRMDF_ASAQC_Internal'
	),

	GroupRoles AS (
		SELECT
			R.RoleName GroupRole,
			S.SurveyID,
			S.survey_name
		FROM
			[survey].[Survey] AS S WITH (NOLOCK)
			INNER JOIN [security].[ApplicationRolesSurveys] R WITH (NOLOCK)
				ON R.SurveyID = S.SurveyID
	),

	CombinedAccess AS (
		SELECT
			GroupRole,
			SurveyID,
			survey_name
		FROM
			GroupRoles
		UNION ALL 

		SELECT
			GroupRole,
			SurveyID,
			survey_name
		FROM
			InternalGroupAllSurveys

	)
	SELECT
		G.RoleName GroupRole,
		G.Type,
		A.SurveyID,
		A.survey_name SurveyName
	FROM
		[security].[ApplicationRole] G WITH (NOLOCK)
		INNER JOIN CombinedAccess A
			ON G.RoleName = A.GroupRole
GO
/****** Object:  View [security_v].[Certificate]    Script Date: 09.12.2019 23:43:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE OR ALTER VIEW [security_v].[Certificate] AS
	SELECT
		[CertID],
		[Alias],
		[Thumbprint],
		[CertType],
		[VendorName]
	FROM [security].[Certificate] WITH (NOLOCK)
GO
/****** Object:  View [security_v].[CertificateSurvey]    Script Date: 09.12.2019 23:43:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER VIEW [security_v].[CertificateSurvey] AS
	SELECT
		[CertID],
		[SurveyID],
		[ValidToDate]
	FROM [security].[CertificateSurvey] WITH (NOLOCK)
GO
/****** Object:  View [survey_v].[AggregatedEvent]    Script Date: 09.12.2019 23:43:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE OR ALTER VIEW [survey_v].[AggregatedEvent] AS
	SELECT
		[SurveyID]
		,[SurveyName]
		,[EventID]
		,[event_text]
		,[event_type]
		,[aggregate_type]
		,[Payload]
		,[Created]
		,[CreatedBy]
		,[RowNum]
	FROM
		[survey].[AggregatedEvent]
GO
/****** Object:  View [survey_v].[AttachmentEvent]    Script Date: 09.12.2019 23:43:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE OR ALTER VIEW [survey_v].[AttachmentEvent] AS
	SELECT
		[SurveyID],
		[EventID],
		[event_text],
		[event_type],
		[RowNum],
		[Created],
		[CreatedBy],
		[SurveyName],
		[Path],
		[RelatedEvents]
	FROM [survey].[AttachmentEvent]
GO
/****** Object:  View [survey_v].[DeviationTolerance]    Script Date: 09.12.2019 23:43:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
 
CREATE OR ALTER VIEW [survey_v].[DeviationTolerance] AS
	SELECT
		[SurveyID],
		[source_pressure_spec],
		[source_pressure_max_deviation],
		[source_depth_spec],
		[source_depth_max_deviation],
		[inline_position_max_deviation_in_meters],
		[inline_position_avg_deviation_in_meters],
		[crossline_position_max_deviation_in_meters],
		[crossline_position_avg_deviation_in_meters],
		[drop_out_guns_max_deviation],
		[Created],
		[CreatedBy],
		[Updated],
		[UpdatedBy]
	FROM [survey].[DeviationTolerance] WITH (NOLOCK)
GO
/****** Object:  View [survey_v].[InterestingDataFields]    Script Date: 09.12.2019 23:43:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE OR ALTER VIEW [survey_v].[InterestingDataFields] AS 
SELECT [ParamCode]
      ,[ParameterName]
      ,[TableName]
      ,[ColumnName]
      ,[Description]
      ,[ExternalTable]
  FROM [survey].[InterestingDataFields] WITH (NOLOCK)
GO
/****** Object:  View [survey_v].[Preplot]    Script Date: 09.12.2019 23:43:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE OR ALTER VIEW [survey_v].[Preplot] AS
	SELECT
    --AKOLE: Commented out because the underlying table does not have this column
		--[SurveyID],
		[PreplotName],
		[PreplotID],
		[epsg_code],
		[epsg_trans],
		[proj4],
		[Created],
		[CreatedBy],
		[Updated],
		[UpdatedBy],
		[SourceFilePath],
		[SailFilePath],
		[P111FilePath]
	FROM [survey].[Preplot] WITH (NOLOCK)
GO
/****** Object:  View [survey_v].[PreplotShotpoint]    Script Date: 09.12.2019 23:43:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
 
CREATE OR ALTER VIEW [survey_v].[PreplotShotpoint] AS
	SELECT
		[SurveyID],
		[PreplotID],
		[srcline_num],
		[shotpoint_num],
		[src_easting],
		[src_northing],
		[sailline_num],
		[sail_easting],
		[sail_northing]
	FROM [survey].[PreplotShotpoint]
GO
/****** Object:  View [survey_v].[PrmLineStatus]    Script Date: 09.12.2019 23:43:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
 
CREATE OR ALTER VIEW [survey_v].[PrmLineStatus] AS
	SELECT
		[Status],
		[IsLive]
	FROM [survey].[PrmLineStatus] WITH (NOLOCK)
GO
/****** Object:  View [survey_v].[Survey]    Script Date: 09.12.2019 23:43:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO





CREATE OR ALTER VIEW [survey_v].[Survey] AS
	SELECT
		[SurveyID],
		[survey_name],
		[PlannedStartDate],
		[PlannedEndDate],
		[Field_ID],
		[SurveyType_ID],
		[EPSGCode],
		[VesselOperationalStatus],
		[VesselOperationalStatusLastChanged],
		[PrmLineStatus],
		[PrmLineStatusLastChanged],
		[Created],
		[CreatedBy],
		[Updated],
		[UpdatedBy],
		[SoftDeleted],
		[Archived],
		[Description]
	FROM [survey].[Survey] WITH (NOLOCK)
	WHERE SoftDeleted = 0
		AND Archived = 0
GO
/****** Object:  View [survey_v].[SurveyPreplotLink]    Script Date: 09.12.2019 23:43:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER VIEW [survey_v].[SurveyPreplotLink] AS 
SELECT [SurveyID]
      ,[PreplotID]
  FROM [survey].[SurveyPreplotLink] WITH(NOLOCK)
GO
/****** Object:  View [survey_v].[SystemEvent]    Script Date: 09.12.2019 23:43:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
 
CREATE OR ALTER VIEW [survey_v].[SystemEvent] AS
	SELECT
		[SurveyID],
		[EventID],
		[Payload],
		[event_text],
		[event_type],
		[RowNum],
		[Created],
		[CreatedBy]
	FROM [survey].[SystemEvent]
GO
/****** Object:  View [survey_v].[Vendor]    Script Date: 09.12.2019 23:43:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER VIEW [survey_v].[Vendor] AS

SELECT *
  FROM [security].[Vendor]
  WITH (NOLOCK)
GO
/****** Object:  View [survey_v].[VesselOperationalStatus]    Script Date: 09.12.2019 23:43:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
 
CREATE OR ALTER VIEW [survey_v].[VesselOperationalStatus] AS
	SELECT
		[Status],
		[IsLive]
	FROM [survey].[VesselOperationalStatus] WITH (NOLOCK)
GO
