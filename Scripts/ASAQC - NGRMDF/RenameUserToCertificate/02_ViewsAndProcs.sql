
CREATE   PROCEDURE [client_p].[DeleteSurvey]
	@SurveyID AS INT
AS

BEGIN
set xact_abort on
BEGIN TRANSACTION

	IF ((SELECT COUNT (*) FROM [survey].[Preplot] AS P
		INNER JOIN [survey].[SurveyPreplotLink] AS SP
			ON SP.PreplotID = P.PreplotID
		WHERE SP.SurveyID =  @SurveyID) = 1)
	BEGIN
		DECLARE @PreplotID AS INT = (SELECT SP.PreplotID FROM [survey].[SurveyPreplotLink] AS SP WHERE SP.SurveyID = @SurveyID) 

		DELETE SP
		FROM [survey].[SurveyPreplotLink] AS SP
		WHERE SP.SurveyId = @SurveyID

		DELETE P
		FROM [survey].[Preplot] AS P
		WHERE P.PreplotID = @PreplotID		
	END

	DELETE D
	FROM [survey].[DeviationTolerance] AS D
	WHERE D.SurveyId = @SurveyID

	DELETE US
	FROM [security].[CertificateSurvey] AS US
	WHERE US.SurveyID = @SurveyID

	DELETE R
	FROM [security].[ApplicationRolesSurveys] AS R
	WHERE R.SurveyID = @SurveyID

	DELETE S
	FROM [survey].[Survey] AS S
	WHERE S.SurveyId = @SurveyID


	SELECT 1
COMMIT TRANSACTION
END
go


CREATE   PROC [client_p].[DeleteCertificate] @Alias AS NVARCHAR(128)
AS

IF NOT EXISTS (SELECT 1 
				FROM [security].[Certificate]
				WHERE Alias = @Alias)
BEGIN
	SELECT 0 AS Success
END
ELSE
BEGIN 
	DELETE US
		FROM [security].[CertificateSurvey] AS US
		INNER JOIN [security].[Certificate] AS U
			ON U.CertID = US.CertID
		WHERE U.Alias = @Alias; 
	
	DELETE U
		FROM [security].[Certificate] AS U
		WHERE U.Alias = @Alias; 

	SELECT 1 AS Success
END
go
  CREATE PROC [client_p].[GetCertificateData] AS
SELECT
  U.Alias Alias,
  Thumbprint Thumbprint,
  CertType Type,
  A.Surveys,
  U.VendorName
FROM
  [Security_v].[Certificate] AS U
  OUTER APPLY (
    SELECT
      (
        SELECT
          JSON_QUERY(
            '[' + STUFF(
              (
                SELECT
                  ',' + '{"survey_name": "' + Survey_Name + '", "valid_to_date": "' + CAST(US.ValidToDate AS NVARCHAR(128)) + '"}'
                FROM
                  [Security_v].[CertificateSurvey] AS US
                  INNER JOIN [survey_v].[Survey] AS S ON S.SurveyID = US.SurveyID
                WHERE
                  US.CertID = U.CertID FOR XML PATH('')
              ),
              1,
              1,
              ''
            ) + ']'
          ) AS Surveys
      ) AS Surveys
  ) AS A
go



CREATE PROCEDURE [client_p].[GetSurveyListByAccessGroups] (
	@RoleList AS nvarchar(512)
)
AS
BEGIN

	DECLARE @SurveyListJson NVARCHAR(MAX) = (
		SELECT
			s.SurveyID survey_id
			,s.survey_name
			,s.field_id
			,f.FIELDNAME field_name
			,VesselUser.Alias 'vessel_vendor_name'
			,PrmUser.Alias prm_vendor_name
			,s.PlannedStartDate acquisition_planned_startdate
			,s.PlannedEndDate acquisition_planned_enddate
			,p.PreplotName 'preplot_name'
			,p.PreplotId 'preplot_id'
			,d.source_pressure_spec 'line_acceptance_criteria.source_pressure_spec'
			,d.source_pressure_max_deviation 'line_acceptance_criteria.source_pressure_max_deviation'
			,d.source_depth_spec 'line_acceptance_criteria.source_depth_spec'
			,d.source_depth_max_deviation 'line_acceptance_criteria.source_depth_max_deviation'
			,d.inline_position_max_deviation_in_meters 'line_acceptance_criteria.inline_position_max_deviation_in_meters'
			,d.inline_position_avg_deviation_in_meters 'line_acceptance_criteria.inline_position_avg_deviation_in_meters'
			,d.crossline_position_max_deviation_in_meters 'line_acceptance_criteria.crossline_position_max_deviation_in_meters'
			,d.crossline_position_avg_deviation_in_meters 'line_acceptance_criteria.crossline_position_avg_deviation_in_meters'
			,d.drop_out_guns_max_deviation 'line_acceptance_criteria.drop_out_guns_max_deviation'
			,s.Created 'created'
			,s.SoftDeleted 'soft_deleted'
			,s.Archived 'archived'
		FROM
			survey.Survey s WITH(NOLOCK)
			-- start: join user survey access
			JOIN (
				SELECT DISTINCT
					SurveyID
				FROM
				[security_v].[ApplicationRoleSurveyAccess] A
				JOIN OPENJSON(@RoleList) R
					ON A.GroupRole = R.value
			) A
				ON s.SurveyID = A.SurveyID
			-- end: join user survey access
			LEFT JOIN [survey].[SurveyPreplotLink] AS SP
				ON S.SurveyID  = SP.SurveyID
			LEFT JOIN [security].[Certificate] VesselUser
				ON S.Source_Company_ID = VesselUser.CertID
			LEFT JOIN [security].[Certificate] PrmUser
				ON S.Recording_Company_ID = PrmUser.CertID
			LEFT JOIN survey_v.Preplot p
				ON P.PreplotID = SP.PreplotID
			LEFT JOIN survey_v.DeviationTolerance d
				ON d.SurveyID = s.SurveyID
			LEFT JOIN management_v.Field f
				ON s.Field_ID = f.IDFIELD
		FOR JSON PATH
	)

	SELECT ISNULL(@SurveyListJson,'{}') AS SurveyJson

END
go

CREATE   PROC [client_p].[ChangeCertificateToSurveyExpiryDate] @Alias AS NVARCHAR(128), @SurveyName AS CHAR(7), @ValidToDate AS DATETIME2
AS

DECLARE @CertID AS INT = (SELECT CertID FROM [security_v].[Certificate] WHERE Alias = @Alias),
		@SurveyID AS INT = (SELECT SurveyID FROM [survey_v].[Survey] WHERE survey_name = @SurveyName)


IF EXISTS (SELECT 1 
					FROM [security_v].[CertificateSurvey]
					WHERE CertID = @CertID
						AND SurveyID = @SurveyID)
	AND EXISTS (SELECT 1 
					FROM [security_v].[Certificate] 
					WHERE Alias = @Alias)
BEGIN
	UPDATE US
		SET US.ValidToDate = @ValidToDate
		FROM [security].[CertificateSurvey] AS US
		WHERE US.CertID = @CertID
			AND US.SurveyID = @SurveyID
	SELECT 1 AS Success
END
ELSE
BEGIN
	SELECT 0 AS Success
END
go


CREATE   PROC [client_p].[InsertCertificateThumbprint] @Alias AS NVARCHAR(128), @Thumbprint AS NVARCHAR(40), @Type AS NVARCHAR(32) = 'Other', @Vendor AS NVARCHAR(24) 
AS


IF NOT EXISTS (SELECT 1
				FROM [security].[Certificate] 
				WHERE Alias = @Alias 
					OR Thumbprint = @Thumbprint)
BEGIN
	INSERT INTO [security].[Certificate]
	SELECT ISNULL((SELECT MAX(CertID)+1 FROM [security].[Certificate]), 1), @Alias, @Thumbprint, @Type, @Vendor
	SELECT 1 AS Success
END
ELSE
BEGIN
	SELECT 0 AS Success
END
go


CREATE   PROC [client_p].[UnauthorizeCertificateToSurvey] @Alias AS NVARCHAR(128), @SurveyName AS CHAR(7)
AS

DECLARE @CertID AS INT = (SELECT CertID FROM [security_v].[Certificate] WHERE Alias = @Alias),
		@SurveyID AS INT = (SELECT SurveyID FROM [survey_v].[Survey] WHERE survey_name = @SurveyName)


IF NOT EXISTS (SELECT 1 
					FROM [security_v].[CertificateSurvey]
					WHERE CertID = @CertID
						AND SurveyID = @SurveyID)
BEGIN
	SELECT 0 AS Success
END
ELSE
BEGIN
	DELETE 
		FROM [security].[CertificateSurvey]
		WHERE CertID = @CertID 
			AND SurveyID = @SurveyID	
	SELECT 1 AS Success
END
go

CREATE   PROC [client_p].[AuthorizeCertificateToSurvey] @Alias AS NVARCHAR(128), @SurveyName AS CHAR(7), @ValidToDate AS DATETIME2 = NULL
AS

DECLARE @CertID AS INT = (SELECT CertID FROM [security_v].[Certificate] WHERE Alias = @Alias),
		@SurveyID AS INT = (SELECT SurveyID FROM [survey_v].[Survey] WHERE survey_name = @SurveyName)


IF NOT EXISTS (SELECT 1 
					FROM [security_v].[CertificateSurvey]
					WHERE CertID = @CertID
						AND SurveyID = @SurveyID)
	AND EXISTS (SELECT 1 
					FROM [security_v].[Certificate] 
					WHERE Alias = @Alias)
BEGIN
	INSERT INTO [security].[CertificateSurvey]
	SELECT @CertID, @SurveyID, ISNULL(@ValidToDate, DATEADD(YEAR, 1 ,GETDATE()))	
	SELECT 1 AS Success
END
ELSE
BEGIN
	SELECT 0 AS Success
END
go

CREATE   PROCEDURE [common_p].[GetPrmLineStatus]
(
    @SurveyName char(7),
	@Thumbprint char(40)
)
AS
BEGIN
    SELECT
		S.survey_name SurveyName,
		PrmLineStatus LineStatus,
		PrmLineStatusLastChanged LastChanged
	FROM
		[survey_v].[Survey] S
		-- start: join user survey access
		JOIN [security_v].[CertificateSurvey] US
			ON US.[SurveyID] = S.SurveyID
		JOIN [security_v].[Certificate] U
			ON U.[CertID] = US.[CertID]
		-- end: join user survey access
	WHERE
		S.survey_name = @SurveyName
		AND U.[Thumbprint] = @Thumbprint
END

go
CREATE   PROCEDURE [common_p].[GetThumbprintValidationPeriodbySurveyID]
(
    @Thumbprint char(40),
    @SurveyID int
)
AS
BEGIN
    SELECT
			case when
				isnull([ValidToDate], cast(dateadd(day, 1, GetDate()) as date)) >= cast(GetDate() as date)
			then
				1
			else
				0
			end
		[IsValid],
		us.[ValidToDate]
	FROM
		[security_v].[Certificate] u
		join [security_v].[CertificateSurvey] us
			on u.CertID = us.CertID
	WHERE
		u.Thumbprint = @Thumbprint
		and us.SurveyID = @SurveyID
END

go


CREATE PROCEDURE [common_p].[GetThumbprintValidationPeriodBySurveyName]
(
    @Thumbprint char(40),
    @SurveyName char(7)
)
AS
BEGIN
	DECLARE @SurveyID AS INT = (SELECT SurveyID FROM survey_v.survey WHERE survey_name = @SurveyName);
	IF EXISTS( SELECT 1
					FROM [security_v].[Certificate] u
					join [security_v].[CertificateSurvey] us
						ON u.CertID = us.CertID
					WHERE us.SurveyID = @SurveyID
						AND Thumbprint = @Thumbprint)
		BEGIN

			SELECT
					case when
						isnull([ValidToDate], cast(dateadd(day, 1, GetDate()) as date)) >= cast(GetDate() as date)
					then
						1
					else
						0
					end
				[IsValid],
				us.[ValidToDate],
			1 AS SurveyExists
			FROM
				[security_v].[Certificate] u
				join [security_v].[CertificateSurvey] us
					on u.CertID = us.CertID
				join [survey_v].[Survey] s
					on s.SurveyID = us.SurveyID
			WHERE
				u.Thumbprint = @Thumbprint
				and s.[survey_name] = @SurveyName
	END
	ELSE
	BEGIN
		SELECT 0 AS IsValid,
		NULL AS ValidToDate,
		CASE WHEN @SurveyID IS NULL THEN 0 ELSE 1 END AS SurveyExists
	END
END

go

CREATE   PROCEDURE [common_p].[GetVesselOperationalStatus]
(
    @SurveyName char(7),
	@Thumbprint char(40)
)
AS
BEGIN
    SELECT
		S.survey_name SurveyName,
		VesselOperationalStatus  OperationalStatus,
		VesselOperationalStatusLastChanged LastChanged
	FROM
		[survey_v].[Survey] S
		-- start: join user survey access
		JOIN [security_v].[CertificateSurvey] US
			ON US.[SurveyID] = S.SurveyID
		JOIN [security_v].[Certificate] U
			ON U.[CertID] = US.[CertID]
		-- end: join user survey access
	WHERE
		S.survey_name = @SurveyName
		AND U.[Thumbprint] = @Thumbprint
END

go

CREATE PROCEDURE [prm_p].[GetNextShotInfo] (
	@SurveyName char(7),
	@Timestamp [float],
	@Thumbprint char(40)
)
AS
	DECLARE @SurveyID int = (
		SELECT S.SurveyID
		FROM survey_v.Survey S
		-- start: join user survey access
		JOIN [security_v].[CertificateSurvey] US
			ON US.[SurveyID] = S.SurveyID
		JOIN [security_v].[Certificate] U
			ON U.[CertID] = US.[CertID]
		-- end: join user survey access
		WHERE
			S.survey_name = @SurveyName
			AND U.[Thumbprint] = @Thumbprint
	)

	DECLARE @NextShotInfoID uniqueidentifier
	DECLARE @MinShotTime float

	SELECT @MinShotTime = MIN([shottime])
	FROM acquisition_v.shotinfo
	WHERE SurveyID = @SurveyID

	IF @Timestamp < @MinShotTime
		SET @NextShotInfoID = (
			SELECT TOP 1 [ShotInfoID]
			FROM [acquisition_v].[shotinfo]
			WHERE
				[shottime] = @MinShotTime
				AND SurveyID = @SurveyID
			)
	ELSE
		SET @NextShotInfoID = (
		SELECT TOP 1 [NextShotInfoID]
		FROM [acquisition].[NextShotInfo]
		WHERE
			[shottime] <= @Timestamp
			AND [NextShotTime] > @Timestamp
			AND SurveyID = @SurveyID
	)

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
		[QaMsg]
	FROM
		acquisition_v.shotinfo
	WHERE
		[ShotInfoID] = @NextShotInfoID
		AND SurveyID = @SurveyID

go

CREATE PROCEDURE [prm_p].[GetShotInfoSequenceLine] (
    @SurveyName char(7),
	@SequenceNumber int,
	@SailLineNumber int,
	@Thumbprint char(40)
)
AS
	DECLARE @SurveyID int = (
		SELECT S.SurveyID
		FROM survey_v.Survey S
		-- start: join user survey access
		JOIN [security_v].[CertificateSurvey] US
			ON US.[SurveyID] = S.SurveyID
		JOIN [security_v].[Certificate] U
			ON U.[CertID] = US.[CertID]
		-- end: join user survey access
		WHERE
			S.survey_name = @SurveyName
			AND U.[Thumbprint] = @Thumbprint
	)
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
		[QaMsg]
	FROM
		acquisition_v.shotinfo
	WHERE
		[SurveyID] = @SurveyID
		AND [seq_num] = @SequenceNumber
		AND [sailline_num] = @SailLineNumber

go

CREATE PROCEDURE [prm_p].[SetPrmLineStatus]
(
    @SurveyName char(7),
	@LineStatus nvarchar(64),
	@Thumbprint char(40)
)
AS
BEGIN
	UPDATE S
	SET
		[PrmLineStatus] = @LineStatus,
		[PrmLineStatusLastChanged] = GETUTCDATE()
	FROM
		[survey_v].[Survey] S
		-- start: join user survey access
		JOIN [security_v].[CertificateSurvey] US
			ON US.[SurveyID] = S.SurveyID
		JOIN [security_v].[Certificate] U
			ON U.[CertID] = US.[CertID]
		-- end: join user survey access
	WHERE
		S.[survey_name] = @SurveyName
		AND U.[Thumbprint] = @Thumbprint
END

go


CREATE VIEW [security_v].[Certificate] AS
	SELECT
		[CertID],
		[Alias],
		[Thumbprint],
		[CertType],
		[VendorName]
	FROM [security].[Certificate] WITH (NOLOCK)
go

CREATE   VIEW [security_v].[CertificateSurvey] AS
	SELECT
		[CertID],
		[SurveyID],
		[ValidToDate]
	FROM [security].[CertificateSurvey] WITH (NOLOCK)
go

CREATE   PROCEDURE [vessel_p].[SetVesselOperationalStatus]
(
    @SurveyName char(7),
	@OperationalStatus nvarchar(64),
	@Thumbprint char(40)
)
AS
BEGIN
	UPDATE S
	SET
		[VesselOperationalStatus] = @OperationalStatus,
		[VesselOperationalStatusLastChanged] = GETUTCDATE()
	FROM
		[survey_v].[Survey] S
		-- start: join user survey access
		JOIN [security_v].[CertificateSurvey] US
			ON US.[SurveyID] = S.SurveyID
		JOIN [security_v].[Certificate] U
			ON U.[CertID] = US.[CertID]
		-- end: join user survey access
	WHERE
		S.[survey_name] = @SurveyName
		AND U.[Thumbprint] = @Thumbprint
END

go