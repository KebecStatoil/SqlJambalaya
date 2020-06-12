
declare @SprocNames table (
	name nvarchar(128)
)
insert into @SprocNames
select
	'['+s.name + '].[' + o.name + ']'
from
	sys.objects o
	join sys.schemas s
		on s.schema_id = o.schema_id
where
	o.type = 'p'
	and o.schema_id in (
		select schema_id
		from sys.schemas
		where name in (
			'survey_p',
			'acquisition_p',
			'security_p',
			'management', -- testing
			'survey' -- testing
		)
	)

select * from @SprocNames

select
	name + ' ' + type_name(system_type_id) + case when type_name(system_type_id) like '%char' then '(' + cast(max_length as varchar(8)) + ')' else '' end
from
	sys.all_parameters
where
	object_id in (
		select object_id(s.name) from @SprocNames s
	)
order by
	parameter_id

SELECT name + ' ' + system_type_name
FROM sys.dm_exec_describe_first_result_set_for_object(OBJECT_ID('[acquisition_p].[GetRequestStatus]'), NULL)


