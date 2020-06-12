
/*
 *  SQL in Databricks
 */
--select top 5000 s.* 
--from [acquisition].[ShotInfo] as s with (nolock)
--  left join [acquisition].[ShotInfoDeviation] as d with (nolock)
--    on s.SurveyID = d.SurveyID
--      and s.ShotInfoID = d.ShotInfoID
--where d.ShotInfoID is null;

declare @shotinfoids nvarchar(max) = (
select '[' + STRING_AGG(ShotInfoID, ',') + ']' from (
		select top 5000 '"' + cast(s.ShotInfoID as nvarchar(max)) + '"' ShotInfoID
		from [acquisition].[ShotInfo] as s with (nolock)
		  left join [acquisition].[ShotInfoDeviation] as d with (nolock)
			on s.SurveyID = d.SurveyID
			  and s.ShotInfoID = d.ShotInfoID
		where d.ShotInfoID is null
	) t
)
select @shotinfoids
select * from openjson(@shotinfoids)