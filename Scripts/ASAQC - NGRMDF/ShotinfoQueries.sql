
/*
 *  Survey ShotInfo Count
 */
--select
--	s.SurveyID,
--	s.survey_name,
--	count(*)
--from 
--	survey_v.Survey s
--	join acquisition_v.ShotInfo si
--		on s.SurveyID = si.SurveyID
--group by
--	s.SurveyID, s.survey_name

/*
 *  distinct sailline numbers
 */
--select distinct
--	si.sailline_num
--from 
--	acquisition_v.ShotInfo si
