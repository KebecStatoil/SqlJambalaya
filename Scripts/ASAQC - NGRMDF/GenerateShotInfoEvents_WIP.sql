

DECLARE @EventID uniqueidentifier
DECLARE @ShotInfoID uniqueidentifier
DECLARE @event_text nvarchar(max)

declare @idlist table (
	id uniqueidentifier
)

DECLARE shotinfo_cursor CURSOR FOR   
SELECT shotinfoId from acquisition_v.ShotInfo


  
OPEN shotinfo_cursor  
FETCH NEXT FROM shotinfo_cursor INTO @shotinfoid  



WHILE @@FETCH_STATUS = 0  
BEGIN  

		SET @EventID = newid()
		SET @event_text = 'Simulated event.'

		insert into @idlist
		EXECUTE [system_p].[AddShotPointEvent] 
		   @EventID
		  ,@ShotInfoID
		  ,@event_text

		--print @event_text

	FETCH NEXT FROM shotinfo_cursor INTO @shotinfoid  

END  
  
CLOSE shotinfo_cursor  
DEALLOCATE shotinfo_cursor 