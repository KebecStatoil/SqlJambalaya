/****** Object:  View [security_v].[User]    Script Date: 26.06.2019 16:12:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[security_v].[User]'))
EXEC dbo.sp_executesql @statement = N'
CREATE   VIEW [security_v].[User] AS
	SELECT
		[UserID],
		[UserExternalID],
		[UserToken],
		[UserType]
	FROM [security].[User] WITH (NOLOCK)
'
GO

CREATE OR ALTER   PROC [client_p].[AuthorizeCertificateToSurvey] @UserExternalID AS NVARCHAR(128), @SurveyName AS CHAR(7), @ValidToDate AS DATETIME2 = NULL
AS

DECLARE @UserID AS INT = (SELECT UserID FROM [security_v].[User] WHERE UserExternalID = @UserExternalID),
		@SurveyID AS INT = (SELECT SurveyID FROM [survey_v].[Survey] WHERE survey_name = @SurveyName)


IF NOT EXISTS (SELECT 1
					FROM [security_v].[UserSurvey]
					WHERE UserID = @UserID
						AND SurveyID = @SurveyID)
	AND EXISTS (SELECT 1
					FROM [security_v].[User]
					WHERE UserExternalID = @UserExternalID)
BEGIN
	INSERT INTO [security].[UserSurvey]
	SELECT @UserID, @SurveyID, ISNULL(@ValidToDate, DATEADD(YEAR, 1 ,GETDATE()))
	SELECT 1 AS Success
END
ELSE
BEGIN
	SELECT 0 AS Success
END
GO

CREATE OR ALTER   PROC [client_p].[UnauthorizeCertificateToSurvey] @UserExternalID AS NVARCHAR(128), @SurveyName AS CHAR(7)
AS

DECLARE @UserID AS INT = (SELECT UserID FROM [security_v].[User] WHERE UserExternalID = @UserExternalID),
		@SurveyID AS INT = (SELECT SurveyID FROM [survey_v].[Survey] WHERE survey_name = @SurveyName)


IF NOT EXISTS (SELECT 1
					FROM [security_v].[UserSurvey]
					WHERE UserID = @UserID
						AND SurveyID = @SurveyID)
BEGIN
	SELECT 0 AS Success
END
ELSE
BEGIN
	DELETE
		FROM [security].[UserSurvey]
		WHERE UserID = @UserID
			AND SurveyID = @SurveyID
	SELECT 1 AS Success
END
GO