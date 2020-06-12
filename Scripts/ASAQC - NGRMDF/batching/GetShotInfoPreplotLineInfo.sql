/****** Object:  StoredProcedure [system_p].[GetShotInfoPreplotLineInfo]    Script Date: 01.07.2019 19:40:14 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE   PROCEDURE [system_p].[GetShotInfoPreplotLineInfo] (
	@KeyList nvarchar(max)
)
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON

	; with preplot_coords as (
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
			ShotInfoID in (select value from openjson ( @KeyList ))
	)

	, min_max_shotpoint_nums as (
		select
			sailline_num,
			min(shotpoint_num) min_shotpoint_num,
			max(shotpoint_num) max_shotpoint_num
		from
			survey.PreplotShotpoint
		group by
			sailline_num
	)

	, min_shotpoints as (
		select
			pp.sailline_num,
			pp.shotpoint_num,
			pp.sail_easting,
			pp.sail_northing
		from
			survey.PreplotShotpoint pp
			join min_max_shotpoint_nums mn
				on mn.min_shotpoint_num = pp.shotpoint_num
				and mn.sailline_num = pp.sailline_num
	)

	, max_shotpoints as (
		select
			pp.sailline_num,
			pp.shotpoint_num,
			pp.sail_easting,
			pp.sail_northing
		from
			survey.PreplotShotpoint pp
			join min_max_shotpoint_nums mx
				on mx.max_shotpoint_num = pp.shotpoint_num
				and mx.sailline_num = pp.sailline_num
	)

	select
		preplot_coords.sailline_num,
		preplot_coords.shotpoint_num,
		preplot_coords.src_easting,
		preplot_coords.src_northing,
		min_shotpoints.sail_northing min_sail_northing,
		min_shotpoints.sail_easting min_sail_easting,
		max_shotpoints.sail_northing max_sail_northing,
		max_shotpoints.sail_easting max_sail_easting
	from
		preplot_coords
		join max_shotpoints
			on max_shotpoints.sailline_num = preplot_coords.sailline_num
		join min_shotpoints
			on min_shotpoints.sailline_num = preplot_coords.sailline_num


END
GO


