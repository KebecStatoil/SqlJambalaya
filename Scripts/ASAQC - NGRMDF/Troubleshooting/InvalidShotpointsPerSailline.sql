
/*
 *  Listing of shotpoints per sailline_num that are not a part of the preplot
 */
select -- for "missed" shotpoints
	si.sailline_num,
	(select min(shotpoint_num) from [survey].[PreplotShotpoint] q where q.sailline_num = si.sailline_num) [min(preplot_shotpoint_num)],
	(select max(shotpoint_num) from [survey].[PreplotShotpoint] q where q.sailline_num = si.sailline_num) [max(preplot_shotpoint_num)],
	'['+string_agg(si.shotpoint_num, ',')+']' invalid_shotpoint_num_list
from
	[acquisition].[ShotInfo] si
	left join [survey].[PreplotShotpoint] pp
		on pp.sailline_num = si.sailline_num
		and pp.shotpoint_num = si.shotpoint_num
where
	pp.SurveyID is null
group by
	si.sailline_num