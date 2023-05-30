SELECT TOP ENTER_TOP_COUNT
  qp.query_id,
--  qp.plan_id,
  FORMAT(MAX(rs.last_execution_time), 'ENTER_DATE_FORMAT') AS LastExecution,
  SUM(rs.count_executions) AS Executions,
  ROUND(SUM(rs.avg_duration/1000000 * rs.count_executions),3) AS TotalSec,
  ROUND(SUM(rs.avg_duration/1000000 * rs.count_executions)/SUM(rs.count_executions),3) AS AvgSec,
  ROUND(MIN(rs.min_duration/1000000),3) AS MinSec,
  ROUND(MAX(rs.max_duration/1000000),3) AS MaxSec,
--  ROUND(SUM(rs.avg_cpu_time/1000000 * rs.count_executions)/SUM(rs.count_executions),3) AS AvgCpuSec,
  ROUND(SUM(rs.avg_logical_io_reads * rs.count_executions)/SUM(rs.count_executions),3) AS AvgLogicalReads,
  ROUND(SUM(rs.avg_logical_io_writes * rs.count_executions)/SUM(rs.count_executions),3) AS AvgLogicalWrites,
  ROUND(SUM(rs.avg_physical_io_reads * rs.count_executions)/SUM(rs.count_executions),3) AS AvgPhysicalReads,
  ROUND(SUM(rs.avg_rowcount * rs.count_executions)/SUM(rs.count_executions),3) AS AvgRowCount,
  CAST(MAX(qt.query_sql_text) AS VARCHAR(2000)) AS text
FROM sys.query_store_plan qp
INNER JOIN sys.query_store_query q
  ON qp.query_id = q.query_id
INNER JOIN sys.query_store_query_text qt
  ON q.query_text_id = qt.query_text_id
INNER JOIN sys.query_store_runtime_stats rs
  ON qp.plan_id = rs.plan_id
INNER JOIN sys.query_store_runtime_stats_interval rsi
  ON rsi.runtime_stats_interval_id = rs.runtime_stats_interval_id
WHERE qp.plan_id = ENTER_PLAN_ID
AND rsi.start_time >= 'ENTER_START_TIME' 
AND rsi.end_time <= 'ENTER_END_TIME'
GROUP BY qp.query_id, qp.plan_id
--ORDER BY TotalSec DESC
;