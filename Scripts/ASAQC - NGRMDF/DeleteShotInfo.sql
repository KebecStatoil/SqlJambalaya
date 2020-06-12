/*

	declare @events_to_remove table (
		EventID uniqueidentifier 
	)

	insert into @events_to_remove
	select EventID from [survey].[SystemEvent]

	delete [survey].[SystemEvent]
	delete [survey].[Event] where EventID in (select EventID from @events_to_remove)

	delete [acquisition].[GunInfo]
	delete [acquisition].[ShotInfoDeviation]
	delete [acquisition].[ShotInfo]

*/



	declare @events_to_remove table (
		EventID uniqueidentifier 
	)

	insert into @events_to_remove
	select EventID from [survey].[SystemEvent]

	select * from [survey].[SystemEvent]
	select * from [survey].[Event] where EventID in (select EventID from @events_to_remove)

	select * from [acquisition].[GunInfo]
	select * from [acquisition].[ShotInfoDeviation]
	select * from [acquisition].[ShotInfo]

