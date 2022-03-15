SELECT session_id, status, FORMAT(start_time, 'ENTER_DATE_FORMAT') AS start_time, 
  total_elapsed_time/1000 AS TotalElapsedSec, command, wait_type, wait_time/1000 AS WaitTimeSec, blocking_session_id, 
  database_id, user_id, reads, writes, logical_reads, cpu_time, dop, parallel_worker_count, 
  convert(varchar(max),query_hash, 2) AS query_hash,
  st.text
FROM sys.dm_exec_requests
CROSS APPLY sys.dm_exec_sql_text(sql_handle) AS st
WHERE session_id > 50
AND session_id <> @@SPID
ORDER BY TotalElapsedSec DESC;