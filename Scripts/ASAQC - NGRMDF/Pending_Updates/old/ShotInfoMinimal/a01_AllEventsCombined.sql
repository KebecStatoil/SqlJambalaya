/****** Object:  View [survey_v].[AllEventsCombined]    Script Date: 28.06.2019 14:15:49 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER VIEW [survey_v].[AllEventsCombined] AS

WITH AllEvents AS (
	SELECT
			 E.SurveyID
			,E.EventID
			,E.event_text
			,E.event_type
			,E.Created
			,E.CreatedBy
			,E.RelatedEvents
			,A.Path
			,S.payload
			,NULL AS aggregate_type
		FROM
			survey_v.Event AS E
			LEFT JOIN survey_v.SystemEvent AS S
				ON S.EventID = E.EventID
			LEFT JOIN survey_v.AttachmentEvent AS A
				ON A.EventID = E.EventID
		WHERE
			E.event_type <> 'event.system.shotpoint'

	UNION ALL

	SELECT
			 A.SurveyID
			,A.EventID
			,A.event_text
			,A.event_type
			,A.Created
			,A.CreatedBy
			,NULL AS RelatedEvents
			,NULL AS Path
			,A.Payload
			,A.aggregate_type
		FROM survey_v.AggregatedEvent AS A
)

SELECT
	*, ROW_NUMBER() OVER (ORDER BY E.CREATED DESC) AS RowNum
	FROM AllEvents AS E
GO


