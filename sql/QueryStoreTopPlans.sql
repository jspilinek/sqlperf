WITH qstats AS (
SELECT rs.plan_id,
  MAX(rs.last_execution_time) AS [last_execution_time],
  MIN(rs.first_execution_time) AS first_execution_time,
  SUM(rs.count_executions) AS Executions,
  ROUND(SUM(rs.avg_duration/1000000*rs.count_executions),1) AS TotalSec,
  ROUND(SUM(rs.avg_duration/1000000 * rs.count_executions)/SUM(rs.count_executions),3) AS AvgSec,
  ROUND(SUM(rs.avg_cpu_time/1000000 * rs.count_executions)/SUM(rs.count_executions),3) AS AvgCpuSec,
  SUM(rs.avg_logical_io_reads*rs.count_executions) AS TotalLogicalReads,
  ROUND(SUM(rs.avg_logical_io_reads * rs.count_executions)/SUM(rs.count_executions),3) AS AvgLogicalReads,
  SUM(rs.avg_logical_io_writes*rs.count_executions) AS TotalLogicalWrites,
  ROUND(SUM(rs.avg_logical_io_writes * rs.count_executions)/SUM(rs.count_executions),3) AS AvgLogicalWrites,
  SUM(rs.avg_physical_io_reads*rs.count_executions) AS TotalPhysicalReads,
  ROUND(SUM(rs.avg_physical_io_reads * rs.count_executions)/SUM(rs.count_executions),3) AS AvgPhysicalReads,
  ROUND(SUM(rs.avg_rowcount * rs.count_executions)/SUM(rs.count_executions),3) AS AvgRowCount,
  ROUND(SUM(rs.avg_dop * rs.count_executions)/SUM(rs.count_executions),1) AS AvgDOP,
  ROUND(SUM(rs.avg_query_max_used_memory * rs.count_executions)/SUM(rs.count_executions),1) AS AvgQueryMaxUsedMemory
FROM sys.query_store_plan qp
INNER JOIN sys.query_store_runtime_stats rs
  ON qp.plan_id = rs.plan_id
INNER JOIN sys.query_store_runtime_stats_interval rsi
  ON rsi.runtime_stats_interval_id = rs.runtime_stats_interval_id
WHERE query_id = ENTER_QUERY_ID
GROUP BY rs.plan_id)

SELECT qstats.*,
  qp.compatibility_level, 
  qp.engine_version,
  qp.is_forced_plan,
  qp.force_failure_count,
  qp.last_force_failure_reason_desc,
  qp.initial_compile_start_time,
  qp.last_compile_start_time,
  qp.avg_compile_duration,
  qp.last_compile_duration,
  qp.query_plan,
  CASE WHEN CONVERT(nvarchar(max), qp.query_plan) LIKE N'%<MissingIndexes>%' THEN 'MissingIndex' ELSE NULL END AS [Has Missing Index]
FROM sys.query_store_plan qp
INNER JOIN qstats ON qstats.plan_id = qp.plan_id
WHERE query_id = ENTER_QUERY_ID
ORDER BY qstats.last_execution_time DESC;
