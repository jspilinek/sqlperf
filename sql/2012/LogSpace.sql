SELECT DB_NAME(lsu.database_id) AS [Database Name], 
    db.recovery_model_desc AS [Recovery Model],
    CAST(total_log_size_in_bytes/1048576.0 AS DECIMAL(10, 2)) AS [Total Log Space (MB)],
    CAST(used_log_space_in_bytes/1048576.0 AS DECIMAL(10, 2)) AS [Used Log Space (MB)], 
    CAST(used_log_space_in_percent AS DECIMAL(10, 2)) AS [Used Log Space %],
    db.log_reuse_wait_desc 
FROM sys.dm_db_log_space_usage AS lsu
INNER JOIN sys.databases AS db
ON lsu.database_id = db.database_id;
