with QueryStats as (
	select
		text query_text,
		s.*
	from sys.dm_exec_query_stats s
	CROSS APPLY sys.dm_exec_sql_text(sql_handle) AS sqltext
)
select
	query_text
	execution_count,
	total_worker_time,
	last_worker_time,
	min_worker_time,
	max_worker_time,
	last_elapsed_time,
	min_elapsed_time,
	max_elapsed_time
	--,*
from
	QueryStats
where
	query_text not like '%CREATE PROCEDURE%'