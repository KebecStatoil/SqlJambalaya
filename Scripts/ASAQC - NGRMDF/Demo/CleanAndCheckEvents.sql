
select * from [acquisition].[ShotInfoDeviation]
select * from [survey].[SystemEvent]
select * from [survey].[Event]

--delete [acquisition].[ShotInfoDeviation]
--delete [survey].[SystemEvent]
--delete [survey].[Event]


-- TODO: Set parameter values here.

EXECUTE [system_p].[GetShotPointEvent] 'E4F9A49D-07EB-4D52-8780-B17FBB702633'


