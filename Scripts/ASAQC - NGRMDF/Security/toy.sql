
--declare @Field table (
--	FieldID int
--)
--insert into @Field values
--(1),
--(2)

--declare @Survey table (
--	SurveyID int,
--	FK_FieldID int
--)
--insert into @Survey values
--(1, 1),
--(1, 2),
--(2, 3),
--(2, 4)

--declare @FieldGroup table (
--	FieldGroupID int
--)
--insert into @FieldGroup values
--(1),
--(2),
--(12)

--declare @SurveyGroup table (
--	SurveyGroupID int
--)
--insert into @SurveyGroup values
--(1),
--(2),
--(3),
--(4)

--declare @FieldGroupField table (
--	FieldGroupID int,
--	FK_FieldID int
--)
--insert into @FieldGroupField values
--(1, 1),
--(2, 2),
--(12, 1),
--(12, 2)

--declare @SurveyGroupSurvey table (
--	SurveyGroupID int,
--	FK_SurveyID int
--)
--insert into @SurveyGroupSurvey values
--(1, 1),
--(2, 2),
--(3, 3),
--(4, 4),
--(13, 1),
--(13, 3)

--declare @User table (
--	UserID int
--)
--insert into @User values
--(1),
--(2),
--(3),
--(4)

--declare @FieldGroupUser table (
--	FK_FieldGroupID int,
--	FK_UserID int
--)
--insert into @FieldGroupUser values 
--(1, 1), -- User 1 has access to Surveys 1 and 2
--(2, 12) -- User 2 has access to Surveys 1, 2, 3, and 4

--declare @SurveyGroupUser table (
--	FK_SurveyGroupID int,
--	FK_UserID int
--)
--insert into @SurveyGroupUser values
--(1),
--(2),
--(3)

execute as user = 'shards_data_writer'

select SUSER_NAME()

revert

select SUSER_NAME()