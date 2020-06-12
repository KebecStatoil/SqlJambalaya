
declare @sometimestamp float = 1540876569.36803 -- 1540753197.89603

--select top 1 *
--from acquisition_v.ShotInfo
--order by NEWID()

---- This is BAD 
--select count(*) from acquisition_v.ShotInfo
--select count(distinct shottime) from acquisition_v.ShotInfo
--select shottime, count(*) duplicatetimes from acquisition_v.ShotInfo group by shottime order by duplicatetimes desc

--select
--	row_number() over(order by shottime desc) as "row number"
--from
--	acquisition_v.ShotInfo


select
	t.ShotTimeNumber,
	t.ShotInfoID,
	t.shottime,
	next_t.ShotTimeNumber NextShotTimeNumber,
	next_t.ShotInfoID NextShotInfoID,
	next_t.shottime NextShotTime
from
	(
		select
			row_number() over(order by shottime) as ShotTimeNumber,
			ShotInfoID,
			shottime
		from
		acquisition_v.ShotInfo
	) t left join (
		select
			row_number() over(order by shottime) as ShotTimeNumber,
			ShotInfoID,
			shottime
		from
		acquisition_v.ShotInfo
	) next_t
		on t.ShotTimeNumber + 1 = next_t.ShotTimeNumber
where
	t.shottime <= @sometimestamp
	and next_t.shottime > @sometimestamp