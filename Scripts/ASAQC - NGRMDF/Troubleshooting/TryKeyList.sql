
declare @shotinfoids nvarchar(max) = (
select '[' + STRING_AGG(ShotInfoID, ',') + ']' from (
		select top 5000 '"' + cast(s.ShotInfoID as nvarchar(max)) + '"' ShotInfoID
		from [acquisition].[ShotInfo] as s with (nolock)
		  left join [acquisition].[ShotInfoDeviation] as d with (nolock)
			on s.SurveyID = d.SurveyID
			  and s.ShotInfoID = d.ShotInfoID
		where d.ShotInfoID is null
	) t
)
select @shotinfoids
select * from openjson(@shotinfoids)

		select
			pp.sailline_num,
			pp.shotpoint_num,
			pp.src_easting,
			pp.src_northing
		from
			[acquisition].[ShotInfo] si
			join survey.PreplotShotpoint pp
				on pp.sailline_num = si.sailline_num
				and pp.shotpoint_num = si.shotpoint_num
		where
			ShotInfoID in (select value from openjson ( @shotinfoids ))

