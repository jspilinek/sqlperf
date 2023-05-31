SELECT 
  MAX(qp.last_execution_time) AS last_execution_time,
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
WHERE qp.query_id = ENTER_QUERY_ID
AND rsi.start_time >= 'ENTER_START_TIME' 
AND rsi.end_time <= 'ENTER_END_TIME'
GROUP BY qp.query_id;
