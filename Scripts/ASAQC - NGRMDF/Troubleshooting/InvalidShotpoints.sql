
-- Problems:

/*
 *  Check for duplicate sequence numbers
 */
select distinct seq_num, sailline_num from acquisition.ShotInfo order by seq_num

/*
 *  Check for duplicate (sailline_num, shotpoint_num)
 */
select seq_num, sailline_num, shotpoint_num, count(*) occurances
from acquisition.ShotInfo
group by seq_num, sailline_num, shotpoint_num
having count(*) > 1 order by count(*) desc, seq_num, sailline_num, shotpoint_num


/*
 *  sailline-shotpoint count not in preplot
 */
select count(*) ShotInfoWithoutPreplotShotpoint
from
	[acquisition].[ShotInfo] si
	left join [survey].[PreplotShotpoint] pp
		on pp.sailline_num = si.sailline_num
		and pp.shotpoint_num = si.shotpoint_num
where
	pp.SurveyID is null

/*
 *  sailline-shotpoint list not in preplot
 */
select si.sailline_num, si.shotpoint_num ShotpointNumbersNotInPreplotSailline
from
	[acquisition].[ShotInfo] si
	left join [survey].[PreplotShotpoint] pp
		on pp.sailline_num = si.sailline_num
		and pp.shotpoint_num = si.shotpoint_num
where
	pp.SurveyID is null
	and si.shotpoint_num not in (
		select shotpoint_num from survey.PreplotShotpoint p where p.sailline_num = si.sailline_num
	)


/*
 *  saillines not in preplot (shoud be empty)
 */
select si.sailline_num SaillineNumbersNotInPreplot
from
	[acquisition].[ShotInfo] si
	left join [survey].[PreplotShotpoint] pp
		on pp.sailline_num = si.sailline_num
		and pp.shotpoint_num = si.shotpoint_num
where
	pp.SurveyID is null
	and si.sailline_num not in (
		select sailline_num from survey.PreplotShotpoint
	)