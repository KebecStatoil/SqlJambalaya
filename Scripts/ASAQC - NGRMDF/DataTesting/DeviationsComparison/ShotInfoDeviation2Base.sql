/****** Script for SelectTopNRows command from SSMS  ******/
SELECT
	[SurveyID]
	,[ShotInfoID]
	,[InlineDeviation]
	,[CrosslineDeviation]
	,[RadialDeviation]
	,[Latency]
	,[Created]

	--,[MinGunDepth]
	--,[MaxGunDepth]
	--,[MeanGunDepth]

	--,[MinGunPressure]
	--,[MaxGunPressure]
	--,[MeanGunPressure]

	--,[ExGunNumPressure]
	--,[ExGunNumDepth]

	--,[CrabAngleProxy]
	--,[ShotInterval]

FROM
	[acquisition].[ShotInfoDeviation2]
order by
	ShotInfoID