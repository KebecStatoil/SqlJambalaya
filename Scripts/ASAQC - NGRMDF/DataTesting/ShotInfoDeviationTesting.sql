
-- from surveys database to check id/name
--select * from survey.Survey

-- check counts
SELECT COUNT(*) FROM [acquisition].[ShotInfo]
SELECT COUNT(*) FROM [acquisition].[ShotInfoDeviation]
SELECT COUNT(*) FROM [acquisition].[ShotInfoDeviation2]

-- to do 

-- check the events count
select count(*) from (select distinct seq_num, sailline_num from acquisition.ShotInfo) si
select count(*) from survey.Events where type = 'event.qc.shotinfo.aggregated'

-- missing | orphaned events
select
	si.seq_num,
	si.sailline_num,
	si.count,
	e.seq_num,
	e.sailline_num,
	e.type
from
	(
		select seq_num, sailline_num, count(*) count
		from acquisition.ShotInfo
		group by seq_num, sailline_num
	) si
	left join survey.Events e
		on si.seq_num = e.seq_num
		and si.sailline_num = e.sailline_num
		and e.type = 'event.qc.shotinfo.aggregated'
where
	si.seq_num is null
	or e.seq_num is null
order by
	si.seq_num,
	si.sailline_num


-- check for duplicated sequence numbers
select
	seq_num,
	sailline_num,
	count(*) DuplicateCount
from
	survey.Events
where
	type = 'event.qc.shotinfo.aggregated'
group by
	seq_num,
	sailline_num
having
	COUNT(*) > 1

-- compare deviations

