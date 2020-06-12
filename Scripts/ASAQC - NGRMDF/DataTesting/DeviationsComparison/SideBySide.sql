
with diffs as (

	SELECT
		old.[SurveyID]
		,old.[ShotInfoID]

		,old.[InlineDeviation] [OldInlineDeviation], new.[InlineDeviation] [NewInlineDeviation], old.[InlineDeviation] - new.[InlineDeviation] [DiffInlineDeviation], ABS(old.[InlineDeviation]) - ABS(new.[InlineDeviation]) [DiffAbsInlineDeviation]
		,old.[CrosslineDeviation] [OldCrosslineDeviation], new.[CrosslineDeviation] [NewCrosslineDeviation], old.[CrosslineDeviation] - new.[CrosslineDeviation] [DiffCrosslineDeviation], ABS(old.[CrosslineDeviation]) - ABS(new.[CrosslineDeviation]) [DiffAbsCrosslineDeviation]
		,old.[RadialDeviation] [OldRadialDeviation], new.[RadialDeviation] [NewRadialDeviation], old.[RadialDeviation] - new.[RadialDeviation] [DiffRadialDeviation], ABS(old.[RadialDeviation]) - ABS(new.[RadialDeviation]) [DiffAbsRadialDeviation]
		,old.[Latency] [OldLatency], new.[Latency] [NewLatency], old.[Latency] - new.[Latency] [DiffLatency], ABS(old.[Latency]) - ABS(new.[Latency]) [DiffAbsLatency]

		---- this is really apples and oranges
		--,old.[MinGunDepthDeviation] [OldMinGunDepthDeviation], new.[MinGunDepth] [NewMinGunDepth], old.[MinGunDepthDeviation] - new.[MinGunDepth]
		--,old.[MaxGunDepthDeviation] [OldMaxGunDepthDeviation], new.[MaxGunDepth] [NewMaxGunDepth], old.[MaxGunDepthDeviation] - new.[MaxGunDepth]
		--,old.[AverageGunDepthDeviation] [OldAverageGunDepthDeviation], new.[MeanGunDepth] [NewMeanGunDepth], old.[AverageGunDepthDeviation] - new.[MeanGunDepth]

		--,[MinGunPressureDeviation]
		--,[MaxGunPressureDeviation]
		--,[AverageGunPressureDeviation]

		--,[StdevGunDepthDeviation]
		--,[StdevGunPressureDeviation]
	
		--,[GunPressureOutOfSpec]
		--,[InlineDeviationOutOfSpec]
		--,[CrosslineDeviationOutOfSpec]
		--,[GunDepthOutOfSpec]

		--,old.[Created] [OldCreated], new.[Created] [NewCreated]
	FROM
		[acquisition].[ShotInfoDeviation_prev] old
		join [acquisition].[ShotInfoDeviation] new
			on new.SurveyID = old.SurveyID
			and new.ShotInfoID = old.ShotInfoID

)

select * from diffs
where
	DiffAbsCrosslineDeviation > 0
	or DiffAbsInlineDeviation > 0
	or DiffAbsRadialDeviation > 0
	or DiffAbsLatency > 0
order by
	SurveyID,
	ShotInfoID