SELECT sqltext.TEXT,
--'kill ' + cast(req.session_id as nvarchar(max)) + ';' kill_statement,
'exec sp_who ' + cast(req.session_id as nvarchar(max)) user_to_kill,
req.session_id,
req.status,
req.command,
req.cpu_time,
req.total_elapsed_time,
req.total_elapsed_time / 1000 seconds,
req.total_elapsed_time / 1000 / 60 minutes
,*
FROM sys.dm_exec_requests req
CROSS APPLY sys.dm_exec_sql_text(sql_handle) AS sqltext

--kill session_id...

--exec sp_who 170 
