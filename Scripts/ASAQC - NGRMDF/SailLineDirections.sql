SELECT
	[seq_num]
	,case
		when 
			(select top 1 shotpoint_num from [acquisition].[ShotInfo] point where point.seq_num = line.seq_num order by point.shottime asc) = min([shotpoint_num])
		then
			'ascending line'
		else
			'descending line'
		end
	line_type
		,(select top 1 shotpoint_num from [acquisition].[ShotInfo] point where point.seq_num = line.seq_num order by point.shottime asc) first_shot
	,(select top 1 shotpoint_num from [acquisition].[ShotInfo] point where point.seq_num = line.seq_num order by point.shottime desc) last_shot
	,min([shottime]) min_shottime
	,max([shottime]) max_shottime
	,max([shottime]) - min([shottime]) line_duration
	--,[shotpoint_num]
	,min([shotpoint_num]) min_shotpoint_num
	,max([shotpoint_num]) max_shotpoint_num
FROM
	[acquisition].[ShotInfo] line
group by
	[seq_num]