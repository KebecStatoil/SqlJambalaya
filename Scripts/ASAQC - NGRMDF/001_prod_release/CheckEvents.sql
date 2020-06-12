/*
 *  Check Events
 */
SELECT
	[EventID]
	,[seq_num]
	,[sailline_num]
	,[type]
	,[version]
	,[createdutc]
	,[event_data_json]
FROM
	[survey].[Events]