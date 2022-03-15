SELECT TOP 3 FORMAT(qs.last_execution_time, 'ENTER_DATE_FORMAT') AS last_execution_time, 
  qs.execution_count, 
  ISNULL(qs.total_elapsed_time/1000000, 0) AS TotalSec,
  ISNULL(qs.total_elapsed_time/1000000 / qs.execution_count, 0) AS AvgSec,
  ISNULL(qs.total_logical_reads / qs.execution_count, 0) AS AvgLogicalReads,
  ISNULL(qs.total_physical_reads / qs.execution_count, 0) AS AvgPhysicalReads,
  convert(varchar(max),sql_handle, 2) AS sql_handle,
  convert(varchar(max),plan_handle, 2) AS plan_handle,
  qp.query_plan,
  CASE WHEN CONVERT(nvarchar(max), qp.query_plan) LIKE N'%<MissingIndexes>%' THEN 'MissingIndex' ELSE NULL END AS [Has Missing Index]
FROM sys.dm_exec_query_stats qs
CROSS APPLY sys.dm_exec_query_plan(qs.plan_handle) AS qp
WHERE qs.query_hash = 0xENTER_QUERY_HASH
ORDER BY qs.last_execution_time DESC;
