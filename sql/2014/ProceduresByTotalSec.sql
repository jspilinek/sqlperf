SELECT TOP 25 
  p.name AS [SP Name], 
  ps.execution_count, 
  ps.total_elapsed_time / 1000000 AS [TotalSeconds], 
  ps.total_elapsed_time / ps.execution_count / 1000000 AS [AvgSeconds],
  ps.max_elapsed_time / 1000000 AS [MaxSeconds], 
  ps.last_elapsed_time / 1000000 AS [LastSeconds],
  ps.total_logical_reads AS [TotalLogicalReads], 
  ps.total_logical_reads / ps.execution_count AS [AvgLogicalReads],
  FORMAT(ps.last_execution_time, 'ENTER_DATE_FORMAT') AS last_execution_time,
  FORMAT(ps.cached_time, 'ENTER_DATE_FORMAT') AS cached_time
FROM sys.procedures AS p 
INNER JOIN sys.dm_exec_procedure_stats AS ps ON p.object_id = ps.object_id
ORDER BY [TotalSeconds] DESC;
