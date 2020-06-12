select
	db_name() SurveyID,
	(select
		count(*) ShotInfoAll
	from
		acquisition.ShotInfo i with (nolock)
	) ShotInfoAll,
	(select
		count(*) ShotInfo
	from
		acquisition_v.ShotInfo i
	) ShotInfo,
	(select
		count(*) ShotInfoDeviation
	from
		acquisition_v.ShotInfoDeviation d
	) ShotInfoDeviation,
	(select
		count(*) PreplotShotpoint
	from
		survey_v.PreplotShotpoint p	
	) PreplotShotpoint,
	(select
		count(*) ShotInfoShotInfoDeviation
	from
		acquisition_v.ShotInfo i
		join acquisition_v.ShotInfoDeviation d
			on d.ShotInfoID = i.ShotInfoID
	) ShotInfoShotInfoDeviation	