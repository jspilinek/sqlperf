SELECT DB_NAME(database_id) [Database], open_transaction_count, status, session_id, login_time, host_name, program_name, client_interface_name, login_name,
cpu_time, memory_usage, total_scheduled_time, total_elapsed_time, 
last_request_start_time, last_request_end_time,
reads, writes, logical_reads
FROM sys.dm_exec_sessions 
WHERE session_id > 50 
AND session_id <> @@SPID
ORDER BY session_id;