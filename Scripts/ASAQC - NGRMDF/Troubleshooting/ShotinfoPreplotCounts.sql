/*
 *  base counts
 */
declare
	@ShotInfo int,
	@PreplotShotpoint int,
	@ShotInfoDeviation int

select @ShotInfo = count(*) from [acquisition].[ShotInfo]
select @PreplotShotpoint = count(*) from [survey].[PreplotShotpoint]
select @ShotInfoDeviation = count(*) from [acquisition].[ShotInfoDeviation]

select @ShotInfo [ShotInfo]
select @PreplotShotpoint [PreplotShotpoint]
select @ShotInfoDeviation [ShotInfoDeviation]

/*
 *  shotInfo with corresponding shotpoint
 */
declare @ShotInfoWithPreplotShotpoint int

select @ShotInfoWithPreplotShotpoint = count(*)
from
	[acquisition].[ShotInfo] si
	join [survey].[PreplotShotpoint] pp
		on pp.sailline_num = si.sailline_num
		and pp.shotpoint_num = si.shotpoint_num

select @ShotInfoWithPreplotShotpoint [ShotInfoWithPreplotShotpoint]

/*
 *  shotinfo without corresponding shotpoint
 */
declare @ShotInfoWithoutPreplotShotpoint int

select @ShotInfoWithoutPreplotShotpoint = count(*)
from
	[acquisition].[ShotInfo] si
	left join [survey].[PreplotShotpoint] pp
		on pp.sailline_num = si.sailline_num
		and pp.shotpoint_num = si.shotpoint_num
where
	pp.SurveyID is null

select @ShotInfoWithoutPreplotShotpoint [ShotInfoWithoutPreplotShotpoint]

/*
 *  Check
 */
select @ShotInfo Total, @ShotInfoWithPreplotShotpoint + @ShotInfoWithoutPreplotShotpoint WithAndWithout

select
	@ShotInfoDeviation Calulated,
	@ShotInfoWithPreplotShotpoint Expected,
	@ShotInfoWithPreplotShotpoint - @ShotInfoDeviation NotCalculated,
	(100.0 * @ShotInfoDeviation) / nullif(@ShotInfoWithPreplotShotpoint, 0) [PercentCalculated]