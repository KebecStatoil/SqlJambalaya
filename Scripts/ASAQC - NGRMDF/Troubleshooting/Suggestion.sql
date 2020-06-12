/*
 *  The current selection method in the databricks script
 */
select top 5000 s.* 
from [acquisition].[ShotInfo] as s with (nolock)
  left join [acquisition].[ShotInfoDeviation] as d with (nolock)
    on s.SurveyID = d.SurveyID
      and s.ShotInfoID = d.ShotInfoID
where d.ShotInfoID is null;

--select count(*) from acquisition.ShotInfo where 

--select distinct sailline_num from survey.PreplotShotpoint order by sailline_num desc

/*
 *  A slapdash fix
 */
select top 5000 s.* 
from [acquisition].[ShotInfo] as s with (nolock)
  left join [acquisition].[ShotInfoDeviation] as d with (nolock)
    on s.SurveyID = d.SurveyID
      and s.ShotInfoID = d.ShotInfoID
where
  d.ShotInfoID is null
  and sailline_num <> 0;


/*
 *  A bit better
 */
select top 5000 s.* 
from [acquisition].[ShotInfo] as s with (nolock)
  left join [acquisition].[ShotInfoDeviation] as d with (nolock)
    on s.SurveyID = d.SurveyID
      and s.ShotInfoID = d.ShotInfoID
where
  d.ShotInfoID is null
  and s.sailline_num in (
	select sailline_num
	from survey.PreplotShotpoint
  );

/*
 *  Or...
 */
select top 5000 s.* 
from [acquisition].[ShotInfo] as s with (nolock)
  join survey.PreplotShotpoint as p with (nolock)
    on s.sailline_num = p.sailline_num
	and s.shotpoint_num = p.shotpoint_num
  left join [acquisition].[ShotInfoDeviation] as d with (nolock)
    on s.SurveyID = d.SurveyID
      and s.ShotInfoID = d.ShotInfoID
where
  d.ShotInfoID is null;