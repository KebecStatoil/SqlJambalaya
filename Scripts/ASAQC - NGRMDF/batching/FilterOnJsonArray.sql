declare @KeyList nvarchar(max) = '["6FEB6506-85DA-424D-83E7-2ED9461A5C70","246EAB76-7483-423E-85AF-A6A816C60A92","CB95B495-63BF-461B-A375-6E97A224DB98","1BDFEE46-A5D8-49EE-94C8-1B4C2367E056","8DCFDE68-1DC2-4281-A4B1-A164DCE2C542","50A01897-84EF-49AE-A1C4-D0A4A2147F29","B5FDAF62-7456-42FA-AEA4-DBDC2783660D","2189E9C9-C7D8-4F40-9C86-C43897B18AA5","294FF11B-C09F-4358-8B7E-62C9DAFE37D7","9A874BC2-2FBB-4DB5-8155-C6C4391C96BA"]'

--select ISJSON(@keylist)

--SELECT * FROM OPENJSON ( @KeyList )

--select * from [acquisition].[ShotInfo] where shotinfoid in (select value from openjson ( @KeyList ))

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
  