/*
 *  base selection
 */
--select
--	[Aedat]
--	,[Changedby]
--	,[Erdat]
--	,[EvAddNotes]
--	,[EvComm]
--	,[EvId]
--	,[EvStat]
--	,[HiddFilg]
--	,[Location]
--	,[Maintplant]
--	,[ScoreIns]
--from
--	[OM].[TechnicalIntegrityManagementInformation_ScoresWithLocations]
--where
--	Maintplant = 1219
--	and evstat = 'act'

/*
 *  counting across
 */
--select Location, count(*) from
--	[OM].[TechnicalIntegrityManagementInformation_ScoresWithLocations]
--where
--	Maintplant = 1219
--	and evstat = 'act'
--group by
--	Location

/*
 *  counting down
 */
--select [HiddFilg], count(*) from
--	[OM].[TechnicalIntegrityManagementInformation_ScoresWithLocations]
--where
--	Maintplant = 1219
--	and evstat = 'act'
--group by
--	[HiddFilg]

/*
 *  Just looking at PS1
 */
--select * from
--	[OM].[TechnicalIntegrityManagementInformation_ScoresWithLocations]
--where
--	Maintplant = 1219
--	and evstat = 'act'
--	and HiddFilg = 'PS1'

/*
 *  recreate TIMP table
 */
select
	Location,
	isnull(PS20, '') PS20,
	isnull(PS15, '') PS15,
	isnull(PS16, '') PS16,
	isnull(PS18, '') PS18,
	isnull(PS19, '') PS19,
	isnull(PS1, '') PS1,
	isnull(PS12, '') PS12,
	isnull(PS17, '') PS17,
	isnull(PS3, '') PS3,
	isnull(PS4, '') PS4,
	isnull(PS7, '') PS7,
	isnull(PS23, '') PS23,
	isnull(PS22, '') PS22,
	isnull(PS2, '') PS2,
	isnull(PS6, '') PS6,
	isnull(PS5, '') PS5,
	isnull(PS8, '') PS8,
	isnull(PS9, '') PS9,
	isnull(PS10, '') PS10,
	isnull(PS11, '') PS11,
	isnull(PS13, '') PS13,
	isnull(PS14, '') PS14
from
	(
		select
			Location,
			HiddFilg,
			ScoreIns
		from
			[OM].[TechnicalIntegrityManagementInformation_ScoresWithLocations]
		where
			Maintplant = 1219
			and evstat = 'act'
	) d
	pivot
	(
		max(ScoreIns) -- change to min and the 'C' would show through instead of a 'D'
		for HiddFilg in (
			PS20,
			PS15,
			PS16,
			PS18,
			PS19,
			PS1,
			PS12,
			PS17,
			PS3,
			PS4,
			PS7,
			PS23,
			PS22,
			PS2,
			PS6,
			PS5,
			PS8,
			PS9,
			PS10,
			PS11,
			PS13,
			PS14
		)
	) piv