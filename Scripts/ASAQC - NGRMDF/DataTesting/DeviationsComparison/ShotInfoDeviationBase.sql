/****** Script for SelectTopNRows command from SSMS  ******/
SELECT
	[SurveyID]
	,[ShotInfoID]
	,[InlineDeviation]
	,[CrosslineDeviation]
	,[RadialDeviation]
	,[Latency]
	,[Created]

	,[MinGunDepthDeviation]
	,[MaxGunDepthDeviation]
	,[AverageGunDepthDeviation]

	,[MinGunPressureDeviation]
	,[MaxGunPressureDeviation]
	,[AverageGunPressureDeviation]

	,[StdevGunDepthDeviation]
	,[StdevGunPressureDeviation]
	
	,[GunPressureOutOfSpec]
	,[InlineDeviationOutOfSpec]
	,[CrosslineDeviationOutOfSpec]
	,[GunDepthOutOfSpec]

FROM
	[acquisition].[ShotInfoDeviation] sid
order by
	ShotInfoID