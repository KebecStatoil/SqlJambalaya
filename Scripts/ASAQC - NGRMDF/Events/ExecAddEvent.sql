USE [11]
GO

DECLARE @RC int
DECLARE @EventID uniqueidentifier = '0B8A9245-DCA6-4C19-97B1-D45BD32E512A'
DECLARE @ShotInfoID uniqueidentifier = '8BFFD707-513D-4611-BFCC-00080A0CABC2'
DECLARE @event_text nvarchar(max) = 'Let''s try this again...'

-- TODO: Set parameter values here.

EXECUTE @RC = [system_p].[AddShotPointEvent] 
   @EventID
  ,@ShotInfoID
  ,@event_text
GO


