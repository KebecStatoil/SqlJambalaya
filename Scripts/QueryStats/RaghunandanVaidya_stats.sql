CREATE TABLE #sp_who2 (SPID INT,Status VARCHAR(255),
      Login  VARCHAR(255),HostName  VARCHAR(255),
      BlkBy  VARCHAR(255),DBName  VARCHAR(255),
      Command VARCHAR(255),CPUTime INT,
      DiskIO INT,LastBatch VARCHAR(255),
      ProgramName VARCHAR(255),SPID2 INT,
      REQUESTID INT)
INSERT INTO #sp_who2 EXEC sp_who2

SELECT sqltext.TEXT,
'kill ' + cast(req.session_id as nvarchar(max)) + ';' kill_statement,
who2.Login,
who2.HostName,
req.session_id,
req.status,
req.command,
req.cpu_time,
req.total_elapsed_time,
req.total_elapsed_time / 1000 seconds,
req.total_elapsed_time / 1000 / 60 minutes,
who2.ProgramName
FROM sys.dm_exec_requests req
CROSS APPLY sys.dm_exec_sql_text(sql_handle) AS sqltext
LEFT JOIN #sp_who2 who2 ON req.session_id=who2.SPID
--where
	--text like 'select *%'
	--req.status = 'suspended' 
ORDER BY seconds desc
DROP TABLE #sp_who2

