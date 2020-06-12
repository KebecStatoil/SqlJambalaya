select
  kill_session = 'kill ' + cast(sdes.session_id as nvarchar),
  sdes.session_id,
  sdes.[status],
  sdes.[login_name],
  sdes.[host_name],
  sder.blocking_session_id,
  kill_blocking = 'kill ' + cast(sder.blocking_session_id as nvarchar),
  sdb.[name],
  sdes.cpu_time,
  sdes.logical_reads, --optionally: sdes.reads + sdes.writes
  sdes.last_request_start_time,
  sdes.[program_name],
  sdes.session_id,
  sder.request_id,
  (select dest.[text] for xml path(''), type) as [text]
from sys.dm_exec_sessions as sdes
  left join sys.dm_exec_connections as sdec
    on sdes.session_id = sdec.session_id
  join sys.databases as sdb
    on sdes.database_id = sdb.database_id
  left join sys.dm_exec_requests as sder
    on sdes.session_id = sder.session_id
  cross apply sys.dm_exec_sql_text(sdec.most_recent_sql_handle) as dest
--where sdes.login_name not in (SUSER_NAME())
    --and blocking_session_id is not NULL
order by cpu_time desc, datepart(mm, sdes.last_request_start_time) desc, datepart(dd, sdes.last_request_start_time) desc;