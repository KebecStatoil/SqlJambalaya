declare @SprocLines as table (
	text nvarchar(max)
)

declare @SprocName nvarchar(128) = '[survey_p].[SetVesselOperationalStatus]'

insert into @SprocLines
EXEC sp_helptext @SprocName

select * from @SprocLines