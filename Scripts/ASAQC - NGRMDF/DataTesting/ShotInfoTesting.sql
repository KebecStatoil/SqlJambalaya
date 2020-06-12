/*
 *  Shot info missing deviation
 */
select *
from
	[acquisition].[ShotInfo] i
	left join [acquisition].[ShotInfoDeviation] d
		on d.ShotInfoID = i .ShotInfoID
where
	d.ShotInfoID is null
order by
	i.ShotInfoID

/*
 *  shot info without preplot 
 */
select *
from
	[acquisition].[ShotInfo] i
	left join [survey].[PreplotShotpoint] p
		on p.sailline_num = i.sailline_num
		and p.shotpoint_num = i.shotpoint_num
where
	p.PreplotID is null
order by
	i.ShotInfoID

/*
 *  shot info without event
 */
select *
from
	[acquisition].[ShotInfo] i
	left join [survey].[SystemEvent] e
		on JSON_VALUE(e.payload, '$.ShotInfoID') = i.ShotInfoID
where
	e.EventID is null
order by
	i.ShotInfoID


/*
 *  Compare ShotInfoDeviation with FinalNavigationShotPointDeviation
 */