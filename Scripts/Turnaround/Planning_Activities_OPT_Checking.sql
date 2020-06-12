--select netid, count(*) recordcount from [om].[Planning_Activities_OPT] group by netid order by recordcount desc
--select netid, count(*) recordcount from [om].[Planning_Activities_OPT] group by netid order by netid

--with activitycounts as (
--	select netid, count(*) recordcount from [om].[Planning_Activities_OPT] group by netid
--)

--select AVG(recordcount) from activitycounts

select * from [om].[Planning_Activities_OPT] where netid = 33 -- 308 -- 190 -- 
	