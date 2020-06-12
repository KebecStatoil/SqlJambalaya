/****** Object:  View [acquisition_v].[ShotInfo]    Script Date: 04.09.2019 15:55:24 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER VIEW [acquisition_v].[ShotInfo] AS
	SELECT
		S.[SurveyID],
		S.[ShotInfoID],
		S.[type],
		S.[imo_num],
		S.[mmsi_num],
		S.[survey_name],
		S.[survey_id],
		S.[shottime],
		S.[shotpoint_num],
		S.[sailline_num],
		S.[srcline_num],
		S.[seq_num],
		S.[epsg],
		S.[northing],
		S.[easting],
		S.[vessel_speed],
		S.[bearing],
		S.[water_depth],
		S.[src_num],
		S.[gun_mask],
		S.[src_delay],
		S.[QaStatus],
		S.[QaMsg],
		S.[EnqueuedTimeUtc],
		S.[Created]
	FROM [acquisition].[ShotInfo] AS S WITH (NOLOCK)
	INNER JOIN [acquisition].[LatestShotInfo] AS L WITH (NOLOCK)
		ON S.SurveyID = L.SurveyID
      AND S.ShotInfoID = L.ShotInfoID
GO


