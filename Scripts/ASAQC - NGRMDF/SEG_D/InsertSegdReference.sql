/****** Object:  StoredProcedure [system_p].[InsertSegdReference]    Script Date: 27.05.2020 10:57:02 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE   PROC [system_p].[InsertSegdReference] 
	@SurveyName char(7),
	@OriginalContainer nvarchar(128),
	@OriginalFilePath nvarchar(512),
	@FileSizeBytes bigint,
	@shottime float = NULL,
	@ErrorMessage nvarchar(max) = NULL,
	@ErrorOrigin nvarchar(128) = NULL,
	@Uploaded datetime2(7)
AS

-- SET NOCOUNT ON added to prevent extra result sets from
-- interfering with SELECT statements.
SET NOCOUNT ON

SET @SurveyName = LOWER(@SurveyName)
SET @OriginalContainer = LOWER(@OriginalContainer)


DECLARE @IsMapped AS BIT = 0,
		@SequenceSegdID AS UNIQUEIDENTIFIER,
		@shotpoint_num AS INT,
        @sailline_num AS INT,
        @srcline_num AS NVARCHAR(MAX),
        @seq_num AS INT;
SELECT TOP (1) 
		@IsMapped = 1,
		@shotpoint_num = S.shotpoint_num, 
		@sailline_num = S.sailline_num, 
		@srcline_num = S.srcline_num, 
		@seq_num = S.seq_num
	FROM acquisition.ShotInfo AS S WITH(NOLOCK)
	WHERE S.shottime <= @shottime + 0.010 
		AND S.shottime >= @shottime - 0.010

 
SET @SequenceSegdID = (SELECT SequenceSegdID FROM [survey].[SequenceSegd] WITH (NOLOCK) WHERE ISNULL(seq_num, -1) = ISNULL(@seq_num, -1) AND ISNULL(sailline_num, -1) =  ISNULL(@sailline_num, -1))

IF @SequenceSegdID IS NULL 
BEGIN
	SET @SequenceSegdID = NEWID();

	INSERT INTO [survey].[SequenceSegd] ([SequenceSegdID], [seq_num],	[sailline_num])
	VALUES(@SequenceSegdID, ISNULL(@seq_num, -1), ISNULL(@sailline_num, -1));
	
	INSERT INTO [survey].[SequenceSegdAction]([SequenceSegdID], [Action], [ActionWbs], [ActionDate], CreatedBy)
	VALUES(@SequenceSegdID, 'FileTransfer', NULL, GETDATE(), '[system_p].[InsertSegdReference]');	
END

DECLARE @State AS NVARCHAR(128) = ( SELECT CASE WHEN @ErrorMessage IS NULL AND @IsMapped = 1 THEN 'InitialProcessing_Successfull' ELSE  'InitialProcessing_Failure' END );
DECLARE @NewFilePath AS NVARCHAR(512) = ( SELECT CASE WHEN @ErrorMessage IS NULL AND @IsMapped = 1 THEN 'Undecided_'+CAST(NEWID() AS NVARCHAR(MAX))+'.segd' ELSE  @OriginalFilePath END );

INSERT INTO [survey].[SegdReference]
(
	OriginalContainer,
	OriginalFilePath,
	NewContainer,
	NewFilePath,
	shottime,
	[State],
	ErrorMessage,
	ErrorOrigin,
	shotpoint_num,
	sailline_num,
	srcline_num,
	seq_num,
	Size,
	Uploaded,
	SequenceSegdID
)  
VALUES (
	@OriginalContainer,
	@OriginalFilePath,
	@SurveyName+'-segd',
	@NewFilePath,
	@shottime,
	@State,
	CASE WHEN @IsMapped = 0 THEN ISNULL(@ErrorMessage + ' ----------- and ----------- Shottime could not be mapped to shotinfo', 'Shottime could not be mapped to shotinfo') ELSE @ErrorMessage END,
	CASE WHEN @IsMapped = 0 THEN ISNULL(@ErrorOrigin + ' ----------- and ----------- [system_p].[InsertSegdReference]', '[system_p].[InsertSegdReference]') ELSE @ErrorOrigin END,
	@shotpoint_num,
	@sailline_num,
	@srcline_num,
	@seq_num,
	@FileSizeBytes,
	@Uploaded,
	@SequenceSegdID
);

SELECT 0 ExecutionResult -- Response required by Databricks

GO


