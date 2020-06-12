/****** Object:  View [acquisition_v].[ShotInfoMinimal]    Script Date: 27.06.2019 11:24:35 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE OR ALTER VIEW [acquisition_v].[ShotInfoMinimal] AS
	SELECT
		[SurveyID],
		[shottime],
		[shotpoint_num],
		[sailline_num],
		[srcline_num],
		[northing],
		[easting],
		[inline],
		[crossline],
		[radial],
		[latency]
	FROM [acquisition].[ShotInfoMinimal]
GO


