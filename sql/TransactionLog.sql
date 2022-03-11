SELECT db.name AS [Database Name], 
  db.recovery_model_desc AS [Recovery Model], 
  db.state_desc AS Status, 
  db.log_reuse_wait_desc AS [Log Reuse Wait Description], 
  CONVERT(DECIMAL(18,2), ls.cntr_value/1024.0) AS [Log Size (MB)], 
  CONVERT(DECIMAL(18,2), lu.cntr_value/1024.0) AS [Log Used (MB)],
  CAST(CAST(lu.cntr_value AS FLOAT) / CAST(ls.cntr_value AS FLOAT)AS DECIMAL(18,2)) * 100 AS [Log Used %]
FROM sys.databases AS db WITH (NOLOCK)
INNER JOIN sys.dm_os_performance_counters AS lu WITH (NOLOCK)
ON db.name = lu.instance_name
INNER JOIN sys.dm_os_performance_counters AS ls WITH (NOLOCK)
ON db.name = ls.instance_name
WHERE lu.counter_name LIKE N'Log File(s) Used Size (KB)%' 
AND ls.counter_name LIKE N'Log File(s) Size (KB)%'
AND ls.cntr_value > 0;
