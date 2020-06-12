/****** Object:  StoredProcedure [client_p].[AddSurveyPermissionToGroup]    Script Date: 09.12.2019 23:48:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE OR ALTER PROCEDURE [client_p].[AddSurveyPermissionToGroup] @SurveyName NCHAR(7), @RoleName NVARCHAR(128) AS 

DECLARE @SurveyID AS INT = (SELECT SurveyID FROM survey.survey AS S WHERE S.Survey_name = @SurveyName)

INSERT INTO [security].[ApplicationRolesSurveys] (SurveyID, RoleName)
VALUES(@SurveyID, @RoleName)


SELECT CAST (1 AS BIT) AS Success
GO
/****** Object:  StoredProcedure [client_p].[AddSurveyPermissionToRole]    Script Date: 09.12.2019 23:48:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER   PROC [client_p].[AddSurveyPermissionToRole] @SurveyName NCHAR(7), @RoleName NVARCHAR(128)
AS
 
INSERT INTO [security].[ApplicationRolesSurveys] (SurveyID, RoleName)
SELECT S.SurveyID, @RoleName 
  FROM [Survey].[Survey] AS S
  WHERE S.survey_name = @SurveyName
GO
/****** Object:  StoredProcedure [client_p].[AuthorizeCertificateToSurvey]    Script Date: 09.12.2019 23:48:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER PROCEDURE [client_p].[AuthorizeCertificateToSurvey] @Alias AS NVARCHAR(128), @SurveyName AS CHAR(7), @ValidToDate AS DATETIME2 = NULL
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
GO
/****** Object:  StoredProcedure [client_p].[ChangeCertificateToSurveyExpiryDate]    Script Date: 09.12.2019 23:48:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER PROCEDURE [client_p].[ChangeCertificateToSurveyExpiryDate] @Alias AS NVARCHAR(128), @SurveyName AS CHAR(7), @ValidToDate AS DATETIME2
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
GO
/****** Object:  StoredProcedure [client_p].[DeleteCertificate]    Script Date: 09.12.2019 23:48:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE OR ALTER PROCEDURE [client_p].[DeleteCertificate] @Alias AS NVARCHAR(128)
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
GO
/****** Object:  StoredProcedure [client_p].[DeleteSurvey]    Script Date: 09.12.2019 23:48:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE OR ALTER PROCEDURE [client_p].[DeleteSurvey]
	@SurveyID AS INT
AS

BEGIN
set xact_abort on
BEGIN TRANSACTION

	DECLARE @SurveyName AS CHAR(7) = (SELECT survey_name FROM Survey.Survey WHERE SurveyID = @SurveyID) 
	
	IF ((SELECT COUNT (*) FROM [survey].[Preplot] AS P
		INNER JOIN [survey].[SurveyPreplotLink] AS SP
			ON SP.PreplotID = P.PreplotID
		WHERE SP.SurveyID =  @SurveyID) = 1)
	BEGIN
		DECLARE @PreplotID AS INT = (SELECT SP.PreplotID FROM [survey].[SurveyPreplotLink] AS SP WHERE SP.SurveyID = @SurveyID) 
			   
		DELETE SP
		FROM [survey].[SurveyPreplotLink] AS SP
		WHERE SP.SurveyId = @SurveyID

		IF NOT EXISTS (SELECT * FROM [survey].[SurveyPreplotLink] WHERE PreplotID = @PreplotID)
			BEGIN
				DELETE P
				FROM [survey].[Preplot] AS P
				WHERE P.PreplotID = @PreplotID
			END	
		ELSE
			BEGIN
				IF ((SELECT LEFT(P111FilePath, 7) 
						FROM [survey].[Preplot] AS P
						WHERE P.PreplotID = @PreplotID) = @SurveyName)
					BEGIN
						UPDATE P
						SET P.P111FilePath = S.survey_name + SUBSTRING(P.P111FilePath, 8, 512)
						FROM [survey].[Preplot] AS P
						OUTER APPLY(
							SELECT TOP(1) S.survey_name 
							FROM [survey].[SurveyPreplotLink] AS SP
							INNER JOIN [survey].[survey] AS S
								ON S.SurveyID = SP.SurveyID
							WHERE S.Survey_name != @SurveyName
								AND SP.PreplotID = P.PreplotID
						) AS S
						WHERE P.PreplotID = @PreplotID

					END

				IF ((SELECT LEFT(SourceFilePath, 7) 
						FROM [survey].[Preplot] AS P
						WHERE P.PreplotID = @PreplotID) = @SurveyName)
					BEGIN
						UPDATE P
						SET P.SourceFilePath = S.survey_name + SUBSTRING(P.SourceFilePath, 8, 512)
						FROM [survey].[Preplot] AS P
						OUTER APPLY(
							SELECT TOP(1) S.survey_name 
							FROM [survey].[SurveyPreplotLink] AS SP
							INNER JOIN [survey].[survey] AS S
								ON S.SurveyID = SP.SurveyID
							WHERE S.Survey_name != @SurveyName
								AND SP.PreplotID = P.PreplotID
						) AS S
						WHERE P.PreplotID = @PreplotID

					END

				IF ((SELECT LEFT(SailFilePath, 7) 
						FROM [survey].[Preplot] AS P
						WHERE P.PreplotID = @PreplotID) = @SurveyName)
					BEGIN
						UPDATE P
						SET P.SailFilePath = S.survey_name + SUBSTRING(P.SailFilePath, 8, 512)
						FROM [survey].[Preplot] AS P
						OUTER APPLY(
							SELECT TOP(1) S.survey_name 
							FROM [survey].[SurveyPreplotLink] AS SP
							INNER JOIN [survey].[survey] AS S
								ON S.SurveyID = SP.SurveyID
							WHERE S.Survey_name != @SurveyName
								AND SP.PreplotID = P.PreplotID
						) AS S
						WHERE P.PreplotID = @PreplotID

					END
			END

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
GO
/****** Object:  StoredProcedure [client_p].[DoesPreplotAlreadyHaveUpload]    Script Date: 09.12.2019 23:48:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER   PROCEDURE [client_p].[DoesPreplotAlreadyHaveUpload] (
	@PreplotName NVARCHAR(256),
	@SurveyName CHAR(7),
	@Type NVARCHAR(256)
)
AS
BEGIN
SELECT 
	CASE @Type 
		WHEN 'sail' THEN CASE WHEN SailFilePath IS NULL THEN 0 ELSE 1 END
		WHEN 'source' THEN CASE WHEN SourceFilePath IS NULL THEN 0 ELSE 1 END
		WHEN 'p111' THEN CASE WHEN P111FilePath IS NULL THEN 0 ELSE 1 END
		ELSE NULL
	END  AS FileExistanceStatus,
	CASE WHEN SP.PreplotID IS NULL THEN 0 ELSE 1 END AS IsConnected 
	FROM [survey_v].[Preplot] AS P
	LEFT JOIN [survey_v].[SurveyPreplotLink] AS SP
		ON P.PreplotID = SP.PreplotID
	INNER JOIN [Survey_v].[Survey] AS S
		ON S.SurveyID = SP.SurveyID
	WHERE S.Survey_Name = @SurveyName 
		AND P.PreplotName = @PreplotName
END
GO
/****** Object:  StoredProcedure [client_p].[DoesPreplotIdExist]    Script Date: 09.12.2019 23:48:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE [client_p].[DoesPreplotIdExist] (
	@PreplotId int
)
AS

BEGIN
	SELECT CASE WHEN EXISTS 
			(
				SELECT 1 
					FROM Survey.Preplot WITH(NOLOCK)
				WHERE PreplotID = @PreplotId
			)
			THEN 1 ELSE 0 END

END
GO
/****** Object:  StoredProcedure [client_p].[DoesPreplotNameExist]    Script Date: 09.12.2019 23:48:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER   PROCEDURE [client_p].[DoesPreplotNameExist] (
	@PreplotName NVARCHAR(256)
)
AS

BEGIN
	SELECT CASE WHEN EXISTS 
			(
				SELECT 1 
					FROM Survey.Preplot WITH(NOLOCK)
				WHERE PreplotName = @PreplotName
			)
			THEN 1 ELSE 0 END

END
GO
/****** Object:  StoredProcedure [client_p].[DoesSurveyIdExist]    Script Date: 09.12.2019 23:48:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER   PROCEDURE [client_p].[DoesSurveyIdExist] (
	@SurveyID INT
)
AS

BEGIN
	SELECT CASE WHEN EXISTS 
			(
				SELECT 1 
					FROM Survey.Survey WITH(NOLOCK)
				WHERE SurveyID = @SurveyID
			)
			THEN 1 ELSE 0 END

END
GO
/****** Object:  StoredProcedure [client_p].[DoesSurveyNameExist]    Script Date: 09.12.2019 23:48:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER   PROCEDURE [client_p].[DoesSurveyNameExist] (
	@SurveyName CHAR(7)
)
AS

BEGIN
	SELECT CASE WHEN EXISTS 
			(
				SELECT 1 
					FROM survey.Survey WITH(NOLOCK)
				WHERE survey_name = @SurveyName
			)
			THEN 1 ELSE 0 END

END
GO
/****** Object:  StoredProcedure [client_p].[DoesSurveyNameSurveyIdAndPreplotExist]    Script Date: 09.12.2019 23:48:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER  PROCEDURE [client_p].[DoesSurveyNameSurveyIdAndPreplotExist] (
	@SurveyName CHAR(7),
	@PreplotName NVARCHAR(256),
	@SurveyID INT

)
AS

BEGIN
	SELECT CASE WHEN EXISTS 
			(
				SELECT 1 
					FROM survey.Survey WITH(NOLOCK)
				WHERE survey_name = @SurveyName
			)
			THEN 1 ELSE 0 END AS SurveyNameExists
			,
			CASE WHEN EXISTS 
			(
				SELECT 1 
					FROM survey.Survey WITH(NOLOCK)
				WHERE SurveyID = @SurveyID
			)
			THEN 1 ELSE 0 END AS SurveyIDExists
			,CASE WHEN EXISTS 
			(
				SELECT 1 
					FROM survey.Preplot WITH(NOLOCK)
				WHERE PreplotName = @PreplotName
			)
			THEN 1 ELSE 0 END AS PreplotNameExists


END
GO
/****** Object:  StoredProcedure [client_p].[GetAggregatedEventsBetween]    Script Date: 09.12.2019 23:48:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
  
CREATE OR ALTER   PROCEDURE [client_p].[GetAggregatedEventsBetween]
	@SurveyName NVARCHAR(128),
	@Start INT,
	@End INT
AS 

	DECLARE @SurveyID AS INT = (
		SELECT SurveyID
		FROM survey.Survey
		WHERE survey_name = @SurveyName
	)

	SELECT *, NULL AS RelatedEvents
	FROM [survey_v].[AggregatedEvent]
	WHERE
		SurveyID = @SurveyID
		AND RowNum BETWEEN @Start AND @End
GO
/****** Object:  StoredProcedure [client_p].[GetAllFieldOutlines]    Script Date: 09.12.2019 23:48:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE OR ALTER   PROCEDURE [client_p].[GetAllFieldOutlines] AS

	SELECT F.IDFIELD, F.FIELDNAME, '['+LEFT(Geo.Map, LEN(Geo.Map)-1)+']' AS [Geometry]
		FROM management_v.Field AS F
		OUTER APPLY(
			SELECT (
				SELECT M.geometry+','
					FROM management_v.Discovery AS D
					INNER JOIN management_v.map AS M
						ON M.IDDISCOVER = D.IDDISCOVER
					WHERE D.IDFIELD = F.IDFIELD
					FOR XML PATH ('')
			) AS Map
		) AS Geo
		ORDER BY FIELDNAME
GO
/****** Object:  StoredProcedure [client_p].[GetAllFields]    Script Date: 09.12.2019 23:48:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE OR ALTER PROCEDURE [client_p].[GetAllFields] AS 
	SELECT F.IDFIELD, F.FIELDNAME, F.FIELDURL
		FROM management.Field AS F 

GO
/****** Object:  StoredProcedure [client_p].[GetAttachmentEventsBetween]    Script Date: 09.12.2019 23:48:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE OR ALTER   PROCEDURE [client_p].[GetAttachmentEventsBetween] @SurveyName NVARCHAR(128), @Start INT, @End INT AS 

	DECLARE @SurveyID AS INT = (SELECT SurveyID FROM survey.Survey WHERE survey_name = @SurveyName)

	SELECT *
	  FROM [survey].[AttachmentEvent]
	  WHERE SurveyID = @SurveyID
		AND RowNum BETWEEN @Start AND @End

GO
/****** Object:  StoredProcedure [client_p].[GetAvailableInterestingParametes]    Script Date: 09.12.2019 23:48:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROC [client_p].[GetAvailableInterestingParametes] AS 

SELECT ParamCode, ParameterName, [Description] FROM [survey].[InterestingDataFields]
GO
/****** Object:  StoredProcedure [client_p].[GetCertificateData]    Script Date: 09.12.2019 23:48:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE [client_p].[GetCertificateData] AS
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
GO
/****** Object:  StoredProcedure [client_p].[GetDataByParameter]    Script Date: 09.12.2019 23:48:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER   PROC [client_p].[GetDataByParameter] @SurveyName NCHAR(7), @ParamCode CHAR(3), @From AS INT = NULL, @Top AS INT = NULL
WITH EXECUTE AS 'parameters_reader'
AS

DECLARE @SurveyID AS INT = (SELECT SurveyID FROM Survey.Survey WHERE Survey_name = @SurveyName)
DECLARE @ColumnName AS NVARCHAR(128) = (SELECT ColumnName FROM [survey_v].[InterestingDataFields] WHERE ParamCode = @ParamCode)
DECLARE @ExternalTable AS NVARCHAR(128) = (SELECT ExternalTable FROM [survey_v].[InterestingDataFields] WHERE ParamCode = @ParamCode)

DECLARE @SQL AS NVARCHAR(MAX) =
	'WITH CTE AS
	(
		SELECT ' +CASE WHEN @Top IS NULL THEN '' ELSE 'TOP('+CAST(@Top AS NVARCHAR(32))+')' END +' srcline_num, seq_num, shotpoint_num, DATEDIFF(SECOND,''1970-01-01'', Created) AS created, CAST('+ @ColumnName+ ' AS NVARCHAR(128)) AS value'+
		' FROM '+@ExternalTable +
		' WHERE SurveyID = '+ CAST(@SurveyID AS NVARCHAR(7))
	+')
	SELECT * FROM CTE' +CASE WHEN @From IS NULL THEN '' ELSE ' WHERE created >= '+CAST(@From AS NVARCHAR(24)) END
	;

EXEC sp_executesql @SQL;
GO
/****** Object:  StoredProcedure [client_p].[GetEspgCode]    Script Date: 09.12.2019 23:48:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE OR ALTER   PROCEDURE [client_p].[GetEspgCode] (
	@SurveyName NVARCHAR(128)
)
AS
BEGIN

	SELECT
		survey_name SurveyName,
		EPSGCode
	from
		survey_v.Survey s
	where
		s.survey_name = @SurveyName

END
GO
/****** Object:  StoredProcedure [client_p].[GetEvent]    Script Date: 09.12.2019 23:48:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE OR ALTER   PROCEDURE [client_p].[GetEvent] @SurveyName NVARCHAR(128), @EventID UNIQUEIDENTIFIER AS

DECLARE @SurveyID AS INT = (SELECT SurveyID FROM survey.Survey WHERE survey_name = @SurveyName)

SELECT *
  FROM [survey].[Event]
  WHERE SurveyID = isnull(@SurveyID, -1)
	AND EventID = @EventID

GO
/****** Object:  StoredProcedure [client_p].[GetEventsBetween]    Script Date: 09.12.2019 23:48:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE OR ALTER   PROCEDURE [client_p].[GetEventsBetween] @SurveyName NVARCHAR(128), @Start INT, @End INT AS 

DECLARE @SurveyID AS INT = (SELECT SurveyID FROM survey.Survey WHERE survey_name = @SurveyName)

SELECT *
  FROM [survey].[Event]
  WHERE SurveyID = isnull(@SurveyID, -1)
	AND RowNum BETWEEN @Start AND @End

GO
/****** Object:  StoredProcedure [client_p].[GetEventTypes]    Script Date: 09.12.2019 23:48:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE OR ALTER PROC [client_p].[GetEventTypes] @SurveyName AS NVARCHAR(7)
AS

DECLARE @SurveyID AS INT = (SELECT SurveyID FROM survey_v.Survey WHERE survey_name = @SurveyName)

SELECT
		('[' +
			STUFF
				(
					(
						SELECT ',' + '"' + event_type + '"'
							FROM [survey].[EventTypes]
							WHERE surveyID = @SurveyID
							FOR XML PATH('')
						),1,1,''
				)
			+ ']'
		) AS event_types,
		('[' +
			STUFF
				(
					(
						SELECT ',' + '"' + aggregate_type + '"'
							FROM [survey].[AggregateTypes]
							WHERE surveyID = @SurveyID
							FOR XML PATH('')
						),1,1,''
				)
			+ ']'
		) AS aggregate_types
GO
/****** Object:  StoredProcedure [client_p].[GetFieldOutlineForFieldID]    Script Date: 09.12.2019 23:48:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE OR ALTER   PROCEDURE [client_p].[GetFieldOutlineForFieldID] @IDFIELD INT AS

	SELECT F.IDFIELD, F.FIELDNAME, '['+LEFT(Geo.Map, LEN(Geo.Map)-1)+']' AS [geometry]
		FROM management_v.Field AS F
		OUTER APPLY(
			SELECT (
				SELECT M.geometry+','
					FROM management_v.Discovery AS D
					INNER JOIN management_v.map AS M
						ON M.IDDISCOVER = D.IDDISCOVER
					WHERE D.IDFIELD = F.IDFIELD
					FOR XML PATH ('')
			) AS Map
		) AS Geo
		WHERE F.IDFIELD = @IDFIELD
GO
/****** Object:  StoredProcedure [client_p].[GetGroups]    Script Date: 09.12.2019 23:48:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER   PROCEDURE [client_p].[GetGroups] AS
	SELECT
		R.RoleName AS GroupRole,				
		'['+STRING_AGG ('"'+RS.SurveyName+'"', ', ')+']' AS Surveys,
		R.Type,
		R.Alias,
		F.FIELDNAME AS FieldName
	FROM [security].[ApplicationRole] AS R WITH (NOLOCK)
	LEFT JOIN [security_v].[ApplicationRoleSurveyAccess] AS RS
		ON R.RoleName = RS.GroupRole
	LEFT JOIN [security].[ApplicationRolesFeilds] AS RF WITH (NOLOCK)
		ON RF.RoleName = R.RoleName
	LEFT JOIN [management_v].[Field] AS F 
		ON F.IDFIELD = RF.IDFIELD
	WHERE R.RoleName <> 'NGRMDF_ASAQC_Internal'
	GROUP BY R.RoleName, R.Type, R.Alias, F.FIELDNAME
GO
/****** Object:  StoredProcedure [client_p].[GetGroupSurveyAccess]    Script Date: 09.12.2019 23:48:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE [client_p].[GetGroupSurveyAccess] AS

	SELECT
		GroupRole,
		SurveyID,
		SurveyName,
		Type
	FROM
		[security_v].[ApplicationRoleSurveyAccess]
GO
/****** Object:  StoredProcedure [client_p].[GetMinimalShotInfo]    Script Date: 09.12.2019 23:48:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE OR ALTER   PROCEDURE [client_p].[GetMinimalShotInfo] (
	@SurveyName NVARCHAR(128)
)
AS
BEGIN

	DECLARE @SurveyID int = (
		SELECT SurveyID
		FROM survey_v.Survey s
		WHERE s.survey_name = @SurveyName
	) 

	SELECT
      [shottime],
      [shotpoint_num],
      [sailline_num],
	  [srcline_num],
	  [seq_num],
	  [created],
      [northing],
      [easting],
      [inline],
      [crossline],
      [radial],
      [latency]
	FROM
		[acquisition].[ShotInfoMinimal]
	WHERE
		SurveyID = @SurveyID

END
GO
/****** Object:  StoredProcedure [client_p].[GetPreplotFilePaths]    Script Date: 09.12.2019 23:48:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE OR ALTER   PROCEDURE [client_p].[GetPreplotFilePaths] (
	@PreplotName NVARCHAR(128)
)
AS

SELECT
	NULL AS SurveyID,
	P.PreplotName, 
	P.PreplotID, 
	
	CASE WHEN 
		EXISTS (
			SELECT 1 
				FROM Survey.Survey AS S WITH(NOLOCK)
				WHERE S.survey_name = LEFT(P.P111FilePath, 7)
		) 
		THEN P.P111FilePath
		ELSE NULL
	END AS P111FilePath,
	
	CASE WHEN 
		EXISTS (
			SELECT 1 
				FROM Survey.Survey AS S WITH(NOLOCK)
				WHERE S.survey_name = LEFT(P.SailFilePath, 7)
		) 
		THEN P.SailFilePath 
		ELSE NULL
	END AS SailFilePath,
	
	CASE WHEN 
		EXISTS (
			SELECT 1 
				FROM Survey.Survey AS S WITH(NOLOCK)
				WHERE S.survey_name = LEFT(P.SourceFilePath, 7)
		) 
		THEN P.SourceFilePath
		ELSE NULL
	END AS SourceFilePath	
	FROM [survey_v].[Preplot]	AS P
	WHERE P.PreplotName = @PreplotName

GO
/****** Object:  StoredProcedure [client_p].[GetPreplotList]    Script Date: 09.12.2019 23:48:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE [client_p].[GetPreplotList]
AS
BEGIN

    SELECT
		p.PreplotName
		,p.PreplotID
		,p.epsg_code
	FROM
		[survey_v].[Preplot] AS p

END
GO
/****** Object:  StoredProcedure [client_p].[GetPreplotSailLinesPoints]    Script Date: 09.12.2019 23:48:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE OR ALTER   PROCEDURE [client_p].[GetPreplotSailLinesPoints] (
	@SurveyName NVARCHAR(128)
)
AS
BEGIN

	DECLARE @SurveyID int = (
		SELECT s.SurveyID
		FROM survey_v.Survey s
		WHERE s.survey_name = @SurveyName
	)

    SELECT
		p.sailline_num,
		p.shotpoint_num,
		p.sail_easting,
		p.sail_northing
	FROM
		[survey].[PreplotShotpoint] p
	WHERE
		p.SurveyID = @SurveyID

END
GO
/****** Object:  StoredProcedure [client_p].[GetPreplotShotPoints]    Script Date: 09.12.2019 23:48:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE OR ALTER   PROCEDURE [client_p].[GetPreplotShotPoints] (
	@SurveyName NVARCHAR(128)
)
AS
BEGIN

	DECLARE @SurveyID int = (
		SELECT s.SurveyID
		FROM survey_v.Survey s
		WHERE s.survey_name = @SurveyName
	)

    SELECT
		p.sailline_num,
		p.shotpoint_num,
		p.sail_easting,
		p.sail_northing
	FROM
		[survey].[PreplotShotpoint] p
	WHERE
		p.SurveyID = @SurveyID

END
GO
/****** Object:  StoredProcedure [client_p].[GetPreplotSourceLinesPoints]    Script Date: 09.12.2019 23:48:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE OR ALTER   PROCEDURE [client_p].[GetPreplotSourceLinesPoints] (
	@SurveyName NVARCHAR(128)
)
AS
BEGIN

	DECLARE @SurveyID int = (
		SELECT s.SurveyID
		FROM survey_v.Survey s
		WHERE s.survey_name = @SurveyName
	)

    SELECT
		p.srcline_num,
		p.shotpoint_num,
		p.src_easting,
		p.src_northing
	FROM
		[survey].[PreplotShotpoint] p
	WHERE
		p.SurveyID = @SurveyID

END
GO
/****** Object:  StoredProcedure [client_p].[GetPrmStatus]    Script Date: 09.12.2019 23:48:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE OR ALTER   PROCEDURE [client_p].[GetPrmStatus]
(
    @SurveyName char(7)
)
AS
BEGIN
    SELECT
		S.survey_name SurveyName,
		LS.[IsLive],
		PrmLineStatusLastChanged LastChanged
	FROM
		[survey_v].[Survey] S
		JOIN [survey_v].[PrmLineStatus] LS
		ON LS.Status = S.PrmLineStatus
	WHERE
		S.survey_name = @SurveyName
END
GO
/****** Object:  StoredProcedure [client_p].[GetSailLineList]    Script Date: 09.12.2019 23:48:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE OR ALTER PROCEDURE [client_p].[GetSailLineList]
(
    @SurveyName char(7)
)
AS
BEGIN
	
	DECLARE @SurveyID int = (
		SELECT SurveyID
		FROM survey_v.Survey s
		WHERE s.survey_name = @SurveyName
	)

	SELECT DISTINCT sailline_num
	FROM acquisition_v.ShotInfo
	WHERE SurveyID = @SurveyID

END
GO
/****** Object:  StoredProcedure [client_p].[GetSailLineListList]    Script Date: 09.12.2019 23:48:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE OR ALTER   PROCEDURE [client_p].[GetSailLineListList]
(
    @SurveyName char(7)
)
AS
BEGIN
	
	DECLARE @SurveyID int = (
		SELECT SurveyID
		FROM survey_v.Survey s
		WHERE s.survey_name = @SurveyName
	)

	SELECT DISTINCT sailline_num
	FROM acquisition_v.ShotInfo
	WHERE SurveyID = @SurveyID

END
GO
/****** Object:  StoredProcedure [client_p].[GetSequenceNumberList]    Script Date: 09.12.2019 23:48:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE OR ALTER   PROCEDURE [client_p].[GetSequenceNumberList]
(
    @SurveyName char(7)
)
AS
BEGIN
	
	DECLARE @SurveyID int = (
		SELECT SurveyID
		FROM survey_v.Survey s
		WHERE s.survey_name = @SurveyName
	)

	SELECT DISTINCT seq_num
	FROM acquisition_v.ShotInfo
	WHERE SurveyID = @SurveyID

END
GO
/****** Object:  StoredProcedure [client_p].[GetShotInfoBySailLine]    Script Date: 09.12.2019 23:48:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE OR ALTER   PROCEDURE [client_p].[GetShotInfoBySailLine] (
	@SurveyName NVARCHAR(128),
	@SailLineNumber INT
)
AS
BEGIN

	DECLARE @SurveyID int = (
		SELECT SurveyID
		FROM survey_v.Survey s
		WHERE s.survey_name = @SurveyName
	) 

	SELECT
		SurveyID
		,type
		,imo_num
		,mmsi_num
		,survey_name
		,survey_id
		,shottime
		,shotpoint_num
		,sailline_num
		,seq_num
		,epsg
		,northing
		,srcline_num
		,easting
		,bearing
		,vessel_speed
		,water_depth
		,src_num
		,gun_mask
		,src_delay
		,guninfo
	FROM
		acquisition.[ShotInfoWithGunInfo]
	WHERE
		SurveyID = @SurveyID
		AND sailline_num = @SailLineNumber

END

GO
/****** Object:  StoredProcedure [client_p].[GetShotInfoBySequenceNumber]    Script Date: 09.12.2019 23:48:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE OR ALTER   PROCEDURE [client_p].[GetShotInfoBySequenceNumber] (
	@SurveyName NVARCHAR(128),
	@SequenceNumber INT
)
AS
BEGIN

	DECLARE @SurveyID int = (
		SELECT SurveyID
		FROM survey_v.Survey s
		WHERE s.survey_name = @SurveyName
	) 

	SELECT
		SurveyID
		,type
		,imo_num
		,mmsi_num
		,survey_name
		,survey_id
		,shottime
		,shotpoint_num
		,sailline_num
		,seq_num
		,epsg
		,northing
		,srcline_num
		,easting
		,bearing
		,vessel_speed
		,water_depth
		,src_num
		,gun_mask
		,src_delay
		,guninfo
	FROM
		acquisition.[ShotInfoWithGunInfo]
	WHERE
		SurveyID = @SurveyID
		AND seq_num = @SequenceNumber

END

GO
/****** Object:  StoredProcedure [client_p].[GetShotInfoBySourceLine]    Script Date: 09.12.2019 23:48:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE OR ALTER   PROCEDURE [client_p].[GetShotInfoBySourceLine] (
	@SurveyName NVARCHAR(128),
	@SourceLineNumber INT,
	@ShotpointNum INT
)
AS
BEGIN

	DECLARE @SurveyID int = (
		SELECT SurveyID
		FROM survey_v.Survey s
		WHERE s.survey_name = @SurveyName
	) 

	SELECT
		SurveyID
		,type
		,imo_num
		,mmsi_num
		,survey_name
		,survey_id
		,shottime
		,shotpoint_num
		,sailline_num
		,seq_num
		,epsg
		,northing
		-- This might get multiple values in the future
		,(SELECT TOP(1) value FROM OPENJSON(srcline_num)) AS srcline_num
		,easting
		,bearing
		,vessel_speed
		,water_depth
		,src_num
		,gun_mask
		,src_delay
		,guninfo
	FROM
		[acquisition].[ShotInfoWithGunInfo]
	WHERE
		SurveyID = @SurveyID
		AND @SourceLineNumber IN (SELECT value FROM OPENJSON(srcline_num))
		AND shotpoint_num = @ShotpointNum

END

GO
/****** Object:  StoredProcedure [client_p].[GetSimpleShotInfoBySailLine]    Script Date: 09.12.2019 23:48:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE OR ALTER   PROCEDURE [client_p].[GetSimpleShotInfoBySailLine] (
	@SurveyName NVARCHAR(128),
	@SailLineNumber INT
)
AS
BEGIN

	DECLARE @SurveyID int = (
		SELECT SurveyID
		FROM survey_v.Survey s
		WHERE s.survey_name = @SurveyName
	) 

	SELECT
		type,
		survey_id,
		shottime,
		shotpoint_num,
		sailline_num,
		seq_num,
		srcline_num,
		northing,
		easting
	FROM
		acquisition_v.ShotInfo
	WHERE
		SurveyID = @SurveyID
		AND sailline_num = @SailLineNumber

END

GO
/****** Object:  StoredProcedure [client_p].[GetSimpleShotInfoBySequenceNumber]    Script Date: 09.12.2019 23:48:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO



CREATE OR ALTER   PROCEDURE [client_p].[GetSimpleShotInfoBySequenceNumber] (
	@SurveyName NVARCHAR(128),
	@SequenceNumber INT
)
AS
BEGIN

	DECLARE @SurveyID int = (
		SELECT SurveyID
		FROM survey_v.Survey s
		WHERE s.survey_name = @SurveyName
	) 

	SELECT
		type,
		survey_id,
		shottime,
		shotpoint_num,
		sailline_num,
		seq_num,
		srcline_num,
		northing,
		easting
	FROM
		acquisition_v.ShotInfo
	WHERE
		SurveyID = @SurveyID
		AND seq_num = @SequenceNumber

END

GO
/****** Object:  StoredProcedure [client_p].[GetSimpleShotInfoBySourceLine]    Script Date: 09.12.2019 23:48:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO



CREATE OR ALTER   PROCEDURE [client_p].[GetSimpleShotInfoBySourceLine] (
	@SurveyName NVARCHAR(128),
	@SourceLineNumber INT
)
AS
BEGIN

	DECLARE @SurveyID int = (
		SELECT SurveyID
		FROM survey_v.Survey s
		WHERE s.survey_name = @SurveyName
	) 

	SELECT
		type,
		survey_id,
		shottime,
		shotpoint_num,
		sailline_num,
		seq_num,
		srcline_num,
		northing,
		easting
	FROM
		acquisition_v.ShotInfo
	WHERE
		SurveyID = @SurveyID
		AND srcline_num = @SourceLineNumber

END

GO
/****** Object:  StoredProcedure [client_p].[GetSourceLineList]    Script Date: 09.12.2019 23:48:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE OR ALTER   PROCEDURE [client_p].[GetSourceLineList]
(
    @SurveyName char(7)
)
AS
BEGIN
	
	DECLARE @SurveyID int = (
		SELECT SurveyID
		FROM survey_v.Survey s
		WHERE s.survey_name = @SurveyName
	)

	SELECT DISTINCT srcline_num
	FROM acquisition_v.ShotInfo
	WHERE SurveyID = @SurveyID

END

GO
/****** Object:  StoredProcedure [client_p].[GetSurvey]    Script Date: 09.12.2019 23:48:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER PROCEDURE [client_p].[GetSurvey] (
	@SurveyName CHAR(7)
)
AS
BEGIN

	DECLARE @SurveyJson NVARCHAR(MAX) = (
		SELECT
			s.SurveyID survey_id
			,s.survey_name
			,s.field_id
			,f.FIELDNAME field_name
			,s.PlannedStartDate acquisition_planned_startdate
			,s.PlannedEndDate acquisition_planned_enddate
			,p.PreplotID 'preplot_id'
			,p.PreplotName 'preplot_name'
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
			,s.[Description] 'description'
			,s.[Archived] 'archived'
			,s.[SoftDeleted] 'soft_deleted'
			,s.[SoftDeletedBy] 'deleted_by'
			,s.[SoftDeletedDate] 'deleted_date'
		FROM
			survey.Survey s WITH (NOLOCK)
			LEFT JOIN [survey_v].[SurveyPreplotLink] AS SP
				ON S.SurveyID  = SP.SurveyID
			LEFT JOIN survey_v.Preplot p
				ON P.PreplotID = SP.PreplotID
			LEFT JOIN survey_v.DeviationTolerance d
				ON d.SurveyID = s.SurveyID
			LEFT JOIN management_v.Field f
				ON s.Field_ID = f.IDFIELD
		WHERE
			s.survey_name = @SurveyName
		FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
	)

	SELECT @SurveyJson SurveyJson

END
GO
/****** Object:  StoredProcedure [client_p].[GetSurveyEspgCode]    Script Date: 09.12.2019 23:48:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE OR ALTER   PROCEDURE [client_p].[GetSurveyEspgCode] (
	@SurveyName NVARCHAR(128)
)
AS
BEGIN

	SELECT
		survey_name SurveyName,
		EPSGCode
	from
		survey_v.Survey s
	where
		s.survey_name = @SurveyName

END
GO
/****** Object:  StoredProcedure [client_p].[GetSurveyList]    Script Date: 09.12.2019 23:48:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE OR ALTER   PROCEDURE [client_p].[GetSurveyList]
AS
BEGIN

	DECLARE @SurveyListJson NVARCHAR(MAX) = (
		SELECT
			s.SurveyID survey_id
			,s.survey_name
			,s.field_id
			,f.FIELDNAME field_name
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
			,s.[Description] 'description'
			,s.[Archived] 'archived'
			,s.[SoftDeleted] 'soft_deleted'
			,s.[SoftDeletedBy] 'deleted_by'
			,s.[SoftDeletedDate] 'deleted_date'
		FROM
			survey.Survey s WITH(NOLOCK)
			LEFT JOIN [survey].[SurveyPreplotLink] AS SP
				ON S.SurveyID  = SP.SurveyID
			LEFT JOIN survey_v.Preplot p
				ON P.PreplotID = SP.PreplotID
			LEFT JOIN survey_v.DeviationTolerance d
				ON d.SurveyID = s.SurveyID
			LEFT JOIN management_v.Field f
				ON s.Field_ID = f.IDFIELD
		FOR JSON PATH
	)

	SELECT @SurveyListJson AS SurveyJson

END
GO
/****** Object:  StoredProcedure [client_p].[GetSurveyListByAccessGroups]    Script Date: 09.12.2019 23:48:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO




CREATE OR ALTER PROCEDURE [client_p].[GetSurveyListByAccessGroups] (
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
			,s.[Description] 'description'
			,s.[Archived] 'archived'
			,s.[SoftDeleted] 'soft_deleted'
			,s.[SoftDeletedBy] 'deleted_by'
			,s.[SoftDeletedDate] 'deleted_date'
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
GO
/****** Object:  StoredProcedure [client_p].[GetSurveyNameList]    Script Date: 09.12.2019 23:48:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE OR ALTER   PROCEDURE [client_p].[GetSurveyNameList]
AS
BEGIN
    SELECT
		S.survey_name SurveyName
	FROM
		[survey_v].[Survey] S

END

GO
/****** Object:  StoredProcedure [client_p].[GetSystemEventsBetween]    Script Date: 09.12.2019 23:48:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE OR ALTER   PROCEDURE [client_p].[GetSystemEventsBetween] @SurveyName NVARCHAR(128), @Start INT, @End INT AS 

DECLARE @SurveyID AS INT = (SELECT SurveyID FROM survey.Survey WHERE survey_name = @SurveyName)

SELECT *
  FROM [survey].[SystemEvent]
  WHERE SurveyID = @SurveyID
	AND RowNum BETWEEN @Start AND @End

GO
/****** Object:  StoredProcedure [client_p].[GetUserEventsBetween]    Script Date: 09.12.2019 23:48:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE OR ALTER PROCEDURE [client_p].[GetUserEventsBetween] @SurveyName NVARCHAR(128), @Start INT, @End INT AS 

DECLARE @SurveyID AS INT = (SELECT SurveyID FROM survey.Survey WHERE survey_name = @SurveyName)

SELECT *
  FROM [survey].[UserEvent]
  WHERE SurveyID = @SurveyID
	AND RowNum BETWEEN @Start AND @End

GO
/****** Object:  StoredProcedure [client_p].[GetVendors]    Script Date: 09.12.2019 23:48:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  CREATE OR ALTER   PROC [client_p].[GetVendors] AS 
  SELECT VendorName, Alias, RoleName, IsPrm, IsVessel 
	FROM survey_v.Vendor
GO
/****** Object:  StoredProcedure [client_p].[GetVendorsByType]    Script Date: 09.12.2019 23:48:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER PROCEDURE [client_p].[GetVendorsByType] (
	@Type NVARCHAR(32)
)
AS

SELECT VendorName UserExternalID
FROM [security].[Vendor] WITH (NOLOCK)
WHERE
	IsPrm = CASE WHEN @Type = 'prm' THEN 1 ELSE 0 END
	OR IsVessel = CASE WHEN @Type = 'vessel' THEN 1 ELSE 0 END
GO
/****** Object:  StoredProcedure [client_p].[GetVesselOperationalStatus]    Script Date: 09.12.2019 23:48:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE OR ALTER PROCEDURE [client_p].[GetVesselOperationalStatus]
(
    @SurveyName char(7)
)
AS
BEGIN
    SELECT
		S.survey_name SurveyName,
		VesselOperationalStatus  OperationalStatus,
		VesselOperationalStatusLastChanged LastChanged
	FROM
		[survey_v].[Survey] S
	WHERE
		S.survey_name = @SurveyName
END

GO
/****** Object:  StoredProcedure [client_p].[InsertCertificateThumbprint]    Script Date: 09.12.2019 23:48:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE OR ALTER PROCEDURE [client_p].[InsertCertificateThumbprint] @Alias AS NVARCHAR(128), @Thumbprint AS NVARCHAR(40), @Type AS NVARCHAR(32) = 'Other', @Vendor AS NVARCHAR(24) 
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
GO
/****** Object:  StoredProcedure [client_p].[InsertPreplot]    Script Date: 09.12.2019 23:48:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE [client_p].[InsertPreplot] (
	@PreplotJson NVARCHAR(MAX)
)
AS 
BEGIN

SET XACT_ABORT ON

BEGIN TRANSACTION

	DECLARE @NewPreplotID AS INT = [system].[GetNextPreplotID]()
	DECLARE @Json AS NVARCHAR(MAX) = REPLACE(@PreplotJson, '\"', '"')
	
	INSERT INTO [survey].[Preplot] (
		[PreplotID],
		[PreplotName],
		[epsg_code],
		[epsg_trans],
		[proj4]
	)
	VALUES
	(
		@NewPreplotID,
		JSON_VALUE(@Json, '$.preplot_name'),
		JSON_VALUE(@Json, '$.epsg_code'),
		JSON_VALUE(@Json, '$.epsg_trans'),
		JSON_VALUE(@Json, '$.proj4')
	)

	SELECT @NewPreplotID AS [PreplotID]

COMMIT TRANSACTION

END
GO
/****** Object:  StoredProcedure [client_p].[InsertSurvey]    Script Date: 09.12.2019 23:48:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE OR ALTER PROCEDURE [client_p].[InsertSurvey] (
	@SurveyJson NVARCHAR(MAX)
)
AS
BEGIN
	set xact_abort on
	BEGIN TRANSACTION

		DECLARE @NewSurveyID AS INT = ISNULL(JSON_VALUE(@SurveyJson, '$.survey_id'), [system].[GetNextSurveyID]())

		INSERT INTO [survey].[Survey] (
			[SurveyID],
			[survey_name],
			[Field_ID],
			[PlannedStartDate],
			[PlannedEndDate],
			[Description]
		)
		VALUES
		(
			@NewSurveyID,
			JSON_VALUE(@SurveyJson, '$.survey_name'),
			JSON_VALUE(@SurveyJson, '$.field_id'),
			JSON_VALUE(@SurveyJson, '$.acquisition_planned_startdate'),
			JSON_VALUE(@SurveyJson, '$.acquisition_planned_enddate'),
			JSON_VALUE(@SurveyJson, '$.description')
		)		
		

		IF (JSON_VALUE(@SurveyJson, '$.preplot_id') IS NOT NULL)
		BEGIN
			INSERT INTO [survey].[SurveyPreplotLink] (SurveyID, PreplotID)
			VALUES
			(
				@NewSurveyID,
				JSON_VALUE(@SurveyJson, '$.preplot_id')
			)
		END

		INSERT INTO [survey].[DeviationTolerance] (
			[SurveyID],
			[source_pressure_spec],
			[source_pressure_max_deviation],
			[source_depth_spec],
			[source_depth_max_deviation],
			[inline_position_max_deviation_in_meters],
			[inline_position_avg_deviation_in_meters],
			[crossline_position_max_deviation_in_meters],
			[crossline_position_avg_deviation_in_meters],
			[drop_out_guns_max_deviation]
		)
		VALUES
		(
			@NewSurveyID,
			JSON_VALUE(@SurveyJson, '$.line_acceptance_criteria.source_pressure_spec'),
			JSON_VALUE(@SurveyJson, '$.line_acceptance_criteria.source_pressure_max_deviation'),
			JSON_VALUE(@SurveyJson, '$.line_acceptance_criteria.source_depth_spec'),
			JSON_VALUE(@SurveyJson, '$.line_acceptance_criteria.source_depth_max_deviation'),
			JSON_VALUE(@SurveyJson, '$.line_acceptance_criteria.inline_position_max_deviation_in_meters'),
			JSON_VALUE(@SurveyJson, '$.line_acceptance_criteria.inline_position_avg_deviation_in_meters'),
			JSON_VALUE(@SurveyJson, '$.line_acceptance_criteria.crossline_position_max_deviation_in_meters'),
			JSON_VALUE(@SurveyJson, '$.line_acceptance_criteria.crossline_position_avg_deviation_in_meters'),
			JSON_VALUE(@SurveyJson, '$.line_acceptance_criteria.drop_out_guns_max_deviation')
		)
		DECLARE @SurveyName AS CHAR(7) = JSON_VALUE(@SurveyJson, '$.survey_name');
		EXEC [client_p].[GetSurvey] @SurveyName

	COMMIT TRANSACTION
END

GO
/****** Object:  StoredProcedure [client_p].[IsValidGroupRoleSurveyAccessPair]    Script Date: 09.12.2019 23:48:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE OR ALTER PROC [client_p].[IsValidGroupRoleSurveyAccessPair] @SurveyName AS NCHAR(7), @RoleName AS NVARCHAR(128)
	AS


IF EXISTS (SELECT * 
				FROM Survey.Survey AS S WITH(NOLOCK)
				INNER JOIN [security].[ApplicationRolesFeilds] AS F WITH(NOLOCK)
					ON F.IDFIELD = S.Field_ID
				WHERE S.Survey_Name = @SurveyName
					AND F.RoleName = @RoleName)
	OR EXISTS (SELECT * 
					FROM [security].[ApplicationRole] WITH (NOLOCK)
					WHERE RoleName = @RoleName AND Type <> 'Partner') 
		
	BEGIN
		SELECT CAST(1 AS BIT) AS Success
	END
ELSE
	BEGIN
		SELECT CAST(0 AS BIT) AS Success
	END
GO
/****** Object:  StoredProcedure [client_p].[RecoverSoftDeletedSurvey]    Script Date: 09.12.2019 23:48:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER     PROC [client_p].[RecoverSoftDeletedSurvey] @SurveyName AS CHAR(7)
AS 
	
BEGIN TRY  
	UPDATE S
		SET S.SoftDeleted = 0,
			S.SoftDeletedDate = NULL,
			S.SoftDeletedBy = NULL
		FROM Survey.Survey AS S
		WHERE S.Survey_name = @SurveyName
	SELECT 1 AS Success
END TRY  
BEGIN CATCH  
     SELECT 0 AS Success
END CATCH
GO
/****** Object:  StoredProcedure [client_p].[RemoveSurveyPermissionFromGroup]    Script Date: 09.12.2019 23:48:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE OR ALTER PROCEDURE [client_p].[RemoveSurveyPermissionFromGroup] @SurveyName NCHAR(7), @RoleName NVARCHAR(128) AS 

DECLARE @SurveyID AS INT = (SELECT SurveyID FROM survey.survey AS S WHERE S.Survey_name = @SurveyName)

DELETE RS
	FROM [security].[ApplicationRolesSurveys] AS RS 
	WHERE SurveyID = @SurveyID 
		AND RoleName = @RoleName
SELECT CAST (1 AS BIT) AS Success
GO
/****** Object:  StoredProcedure [client_p].[RemoveSurveyPermissionFromRole]    Script Date: 09.12.2019 23:48:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER   PROC [client_p].[RemoveSurveyPermissionFromRole] @SurveyName NCHAR(7), @RoleName NVARCHAR(128)
AS
 

DELETE RS 
FROM [security].[ApplicationRolesSurveys] AS RS
INNER JOIN [Survey].[Survey] AS S
	ON RS.SurveyID = S.SurveyID
WHERE S.survey_name = @SurveyName
	AND RS.RoleName = @RoleName
GO
/****** Object:  StoredProcedure [client_p].[SetPreplotP111FilePath]    Script Date: 09.12.2019 23:48:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE OR ALTER PROCEDURE [client_p].[SetPreplotP111FilePath] (
	@PreplotName NVARCHAR(128),
	@SurveyName CHAR(7),
	@FilePath NVARCHAR(256)
)
AS
BEGIN

	DECLARE @PreplotID AS INT = (SELECT PreplotID FROM [survey_v].[Preplot] AS P WHERE P.PreplotName = @PreplotName)

	UPDATE P
		SET P.P111FilePath = @FilePath
		FROM [survey_v].[Preplot]	AS P
		WHERE P.PreplotID = @PreplotID

	SELECT (SELECT SurveyID FROM Survey_v.Survey WHERE Survey_Name = @SurveyName) AS SurveyID, PreplotName, PreplotID, P111FilePath, SailFilePath, SourceFilePath
		FROM [survey_v].[Preplot]	AS P
		WHERE P.PreplotID = @PreplotID
END
GO
/****** Object:  StoredProcedure [client_p].[SetPreplotSailFilePath]    Script Date: 09.12.2019 23:48:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE OR ALTER PROCEDURE [client_p].[SetPreplotSailFilePath] (
	@PreplotName NVARCHAR(128),
	@SurveyName CHAR(7),
	@FilePath NVARCHAR(256)
)
AS
BEGIN

	DECLARE @PreplotID AS INT = (SELECT PreplotID FROM [survey_v].[Preplot] AS P WHERE P.PreplotName = @PreplotName)

	UPDATE P
		SET P.SailFilePath = @FilePath
		FROM [survey_v].[Preplot]	AS P
		WHERE P.PreplotID = @PreplotID
	SELECT (SELECT SurveyID FROM Survey_v.Survey WHERE Survey_Name = @SurveyName) AS SurveyID, PreplotName, PreplotID, P111FilePath, SailFilePath, SourceFilePath
		FROM [survey_v].[Preplot]	AS P
		WHERE P.PreplotID = @PreplotID
END
GO
/****** Object:  StoredProcedure [client_p].[SetPreplotSourceFilePath]    Script Date: 09.12.2019 23:48:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE OR ALTER PROCEDURE [client_p].[SetPreplotSourceFilePath] (
	@PreplotName NVARCHAR(128),
	@SurveyName CHAR(7),
	@FilePath NVARCHAR(256)
)
AS
BEGIN

	DECLARE @PreplotID AS INT = (SELECT PreplotID FROM [survey_v].[Preplot] AS P WHERE P.PreplotName = @PreplotName)

	UPDATE P
		SET P.SourceFilePath = @FilePath
		FROM [survey_v].[Preplot]	AS P
		WHERE P.PreplotID = @PreplotID
	SELECT (SELECT SurveyID FROM Survey_v.Survey WHERE Survey_Name = @SurveyName) AS SurveyID, PreplotName, PreplotID, P111FilePath, SailFilePath, SourceFilePath
		FROM [survey_v].[Preplot]	AS P
		WHERE P.PreplotID = @PreplotID
END
GO
/****** Object:  StoredProcedure [client_p].[SetSurveyArchivedField]    Script Date: 09.12.2019 23:48:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROC [client_p].[SetSurveyArchivedField] @SurveyName CHAR(7), @Archived BIT
AS


	UPDATE S
		SET S.Archived = @Archived
		FROM [survey].[Survey] AS S
		WHERE S.survey_name = @SurveyName
	SELECT 1 AS Success
GO
/****** Object:  StoredProcedure [client_p].[SetSurveyAsSoftDeleted]    Script Date: 09.12.2019 23:48:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROC [client_p].[SetSurveyAsSoftDeleted] @SurveyName AS CHAR(7), @UserEmail AS NVARCHAR(256)
AS 
	
BEGIN TRY  
	UPDATE S
		SET S.SoftDeleted = 1,
			S.SoftDeletedBy = @UserEmail,
			S.SoftDeletedDate = Sysutcdatetime()
		FROM Survey.Survey AS S
		WHERE S.Survey_name = @SurveyName
	SELECT 1 AS Success
END TRY  
BEGIN CATCH  
     SELECT 0 AS Success
END CATCH
GO
/****** Object:  StoredProcedure [client_p].[UnauthorizeCertificateToSurvey]    Script Date: 09.12.2019 23:48:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE OR ALTER PROCEDURE [client_p].[UnauthorizeCertificateToSurvey] @Alias AS NVARCHAR(128), @SurveyName AS CHAR(7)
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
GO
/****** Object:  StoredProcedure [client_p].[UpdateSurvey]    Script Date: 09.12.2019 23:48:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE [client_p].[UpdateSurvey] (
	@SurveyJson NVARCHAR(MAX)
)
AS
BEGIN

	UPDATE [survey].[Survey]
	SET
		[PlannedStartDate] = JSON_VALUE(@SurveyJson, '$.acquisition_planned_startdate'),
		[PlannedEndDate] = JSON_VALUE(@SurveyJson, '$.acquisition_planned_enddate'),
		[Description] = JSON_VALUE(@SurveyJson, '$.description'),
		[Updated] = GETUTCDATE(),
		[UpdatedBy] = SUSER_SNAME()
	WHERE
		[SurveyID] = JSON_VALUE(@SurveyJson, '$.survey_id')

	IF (JSON_VALUE(@SurveyJson, '$.preplot_id') IS NOT NULL)
	BEGIN
		IF EXISTS(SELECT 1 FROM [survey].[SurveyPreplotLink] WHERE[SurveyID] = JSON_VALUE(@SurveyJson, '$.survey_id'))
		BEGIN
			UPDATE [survey].[SurveyPreplotLink]
			SET
				[PreplotID] = JSON_VALUE(@SurveyJson, '$.preplot_id')
			WHERE
				[SurveyID] = JSON_VALUE(@SurveyJson, '$.survey_id')
		END
		ELSE
		BEGIN
			INSERT INTO [survey].[SurveyPreplotLink] (SurveyID, PreplotID)
				VALUES
				(
					JSON_VALUE(@SurveyJson, '$.survey_id'),
					JSON_VALUE(@SurveyJson, '$.preplot_id')
				)
		END
	END
	ELSE
	BEGIN
		DELETE FROM [survey].[SurveyPreplotLink]
			WHERE [SurveyID] = JSON_VALUE(@SurveyJson, '$.survey_id')
	END

	UPDATE [survey].[DeviationTolerance]
	SET
		[source_pressure_spec] = JSON_VALUE(@SurveyJson, '$.line_acceptance_criteria.source_pressure_spec'),
		[source_pressure_max_deviation] = JSON_VALUE(@SurveyJson, '$.line_acceptance_criteria.source_pressure_max_deviation'),
		[source_depth_spec] = JSON_VALUE(@SurveyJson, '$.line_acceptance_criteria.source_depth_spec'),
		[source_depth_max_deviation] = JSON_VALUE(@SurveyJson, '$.line_acceptance_criteria.source_depth_max_deviation'),
		[inline_position_max_deviation_in_meters] = JSON_VALUE(@SurveyJson, '$.line_acceptance_criteria.inline_position_max_deviation_in_meters'),
		[inline_position_avg_deviation_in_meters] = JSON_VALUE(@SurveyJson, '$.line_acceptance_criteria.inline_position_avg_deviation_in_meters'),
		[crossline_position_max_deviation_in_meters] = JSON_VALUE(@SurveyJson, '$.line_acceptance_criteria.crossline_position_max_deviation_in_meters'),
		[crossline_position_avg_deviation_in_meters] = JSON_VALUE(@SurveyJson, '$.line_acceptance_criteria.crossline_position_avg_deviation_in_meters'),
		[drop_out_guns_max_deviation] = JSON_VALUE(@SurveyJson, '$.line_acceptance_criteria.drop_out_guns_max_deviation'),
		[Updated] = GETUTCDATE(),
		[UpdatedBy] = SUSER_SNAME()
	WHERE
		[SurveyID] = JSON_VALUE(@SurveyJson, '$.survey_id');

	DECLARE @SurveyName AS CHAR(7) = JSON_VALUE(@SurveyJson, '$.survey_name')
	EXEC [client_p].[GetSurvey] @SurveyName
END
GO
/****** Object:  StoredProcedure [client_p].[WhoAmI]    Script Date: 09.12.2019 23:48:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER   PROCEDURE [client_p].[WhoAmI]
AS
BEGIN
    SET NOCOUNT ON

	SELECT UserName = SUSER_NAME()
END
GO
/****** Object:  StoredProcedure [common_p].[GetPrmLineStatus]    Script Date: 09.12.2019 23:48:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER PROCEDURE [common_p].[GetPrmLineStatus]
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
GO
/****** Object:  StoredProcedure [common_p].[GetThumbprintValidationPeriodbySurveyID]    Script Date: 09.12.2019 23:48:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE [common_p].[GetThumbprintValidationPeriodbySurveyID]
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
GO
/****** Object:  StoredProcedure [common_p].[GetThumbprintValidationPeriodBySurveyName]    Script Date: 09.12.2019 23:48:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE OR ALTER PROCEDURE [common_p].[GetThumbprintValidationPeriodBySurveyName]
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
GO
/****** Object:  StoredProcedure [common_p].[GetVesselOperationalStatus]    Script Date: 09.12.2019 23:48:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER PROCEDURE [common_p].[GetVesselOperationalStatus]
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
GO
/****** Object:  StoredProcedure [prm_p].[GetNextShotInfo]    Script Date: 09.12.2019 23:48:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER PROCEDURE [prm_p].[GetNextShotInfo] (
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
GO
/****** Object:  StoredProcedure [prm_p].[GetShotInfoSequenceLine]    Script Date: 09.12.2019 23:48:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER PROCEDURE [prm_p].[GetShotInfoSequenceLine] (
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
GO
/****** Object:  StoredProcedure [prm_p].[SetPrmLineStatus]    Script Date: 09.12.2019 23:48:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER PROCEDURE [prm_p].[SetPrmLineStatus]
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
GO
/****** Object:  StoredProcedure [system_p].[GetSimpleShotInfoByID]    Script Date: 09.12.2019 23:48:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE OR ALTER   PROCEDURE [system_p].[GetSimpleShotInfoByID] (
	@SurveyID int,
	@ShotInfoID uniqueidentifier
)
AS
BEGIN
	SELECT
		type,
		survey_id,
		shottime,
		shotpoint_num,
		sailline_num,
		seq_num,
		srcline_num,
		northing,
		easting,
		Created
	FROM
		acquisition_v.ShotInfo
	WHERE
		SurveyID = @SurveyID
		AND ShotInfoID = @ShotInfoID
END

GO
/****** Object:  StoredProcedure [system_p].[GetSurveyIds]    Script Date: 09.12.2019 23:48:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER   PROC [system_p].[GetSurveyIds]
AS

-- Set NOCOUNT ON to stop affected rows count from interfering with the result
SET NOCOUNT ON;

SELECT
  SurveyID,
  survey_name
FROM survey_v.Survey
WHERE sysutcdatetime() <= PlannedEndDate 
  AND sysutcdatetime() >= PlannedStartDate 
  AND SoftDeleted != 1
  AND Archived != 1;
GO
/****** Object:  StoredProcedure [system_p].[GetSurveyNameById]    Script Date: 09.12.2019 23:48:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE OR ALTER   PROCEDURE [system_p].[GetSurveyNameById] (
	@SurveyID int
)
AS

-- Set NOCOUNT ON to stop affected rows count from interfering with the result
SET NOCOUNT ON

BEGIN
	SELECT survey_name
	FROM 		[survey_v].[Survey]
	WHERE SurveyID = @SurveyID
END

GO
/****** Object:  StoredProcedure [vessel_p].[GetRequestStatus]    Script Date: 09.12.2019 23:48:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE OR ALTER   PROCEDURE [vessel_p].[GetRequestStatus]
(
    @SurveyName char(7),
    @RequestGuid uniqueidentifier,
	@Thumbprint char(40)
)
AS
BEGIN
    SELECT
		ShotInfoID RequestGuid,
		QaStatus,
		QaMsg
	FROM
		acquisition.ShotInfoAll
	WHERE
		ShotInfoID = @RequestGuid

	UNION ALL

	  SELECT
		FinalNavigationID RequestGuid,
		QaStatus,
		QaMsg
	FROM
		acquisition.FinalNavigation
	WHERE
		FinalNavigationID = @RequestGuid

	UNION ALL

	SELECT
		NavigationID RequestGuid,
		QaStatus,
		QaMsg
	FROM
		acquisition.Navigation
	WHERE
		NavigationID = @RequestGuid

	-- TODO: Combine this with user-survey access
END
GO
/****** Object:  StoredProcedure [vessel_p].[SetVesselOperationalStatus]    Script Date: 09.12.2019 23:48:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER PROCEDURE [vessel_p].[SetVesselOperationalStatus]
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
GO
