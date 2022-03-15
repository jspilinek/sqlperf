WITH rs AS (
SELECT 
  qp.query_id,
  FORMAT(MAX(qp.last_execution_time), 'ENTER_DATE_FORMAT') AS last_execution_time,
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
WHERE rsi.start_time >= 'ENTER_START_TIME' 
AND rsi.end_time <= 'ENTER_END_TIME'
AND qp.query_id IN (SELECT q.query_id 
FROM sys.query_store_query_text qt
INNER JOIN sys.query_store_query q
  ON q.query_text_id = qt.query_text_id
WHERE qt.query_sql_text NOT LIKE 'SELECT StatMan%')
GROUP BY qp.query_id
--ORDER BY TotalSec DESC
),
top_elapsed_time AS (
  SELECT TOP ENTER_TOP_COUNT *
  FROM rs
  --WHERE rs.TotalSec >= 1 -- nothing less than 1 sec
  ORDER BY rs.TotalSec DESC
),
top_elap_per_exec AS (
  SELECT TOP ENTER_TOP_COUNT *
  FROM rs
  --WHERE AvgSec >= 1 -- nothing less than 1 sec
  ORDER BY rs.AvgSec DESC),
  
top_logical_reads AS (
  SELECT TOP ENTER_TOP_COUNT *
  FROM rs
  --WHERE rs.AvgLogicalReads > 10000
  ORDER BY rs.AvgLogicalReads DESC),

top_physical_reads AS (
  SELECT TOP ENTER_TOP_COUNT *
  FROM rs
  --WHERE rs.AvgPhysicalReads > 10000
  ORDER BY rs.AvgPhysicalReads DESC),

top_executions AS (
  SELECT TOP ENTER_TOP_COUNT *
  FROM rs
  --WHERE rs.Executions > 1000
  ORDER BY rs.Executions DESC),

top_rows_per_exec AS (
  SELECT TOP ENTER_TOP_COUNT *
  FROM rs
  --WHERE rs.AvgRowCount > 10000
  ORDER BY rs.AvgRowCount DESC)

SELECT A.*, 
  qt.query_sql_text AS text
FROM (
  SELECT * FROM top_elapsed_time 
  UNION SELECT * FROM top_elap_per_exec 
  UNION SELECT * FROM top_logical_reads 
  UNION SELECT * FROM top_physical_reads 
  UNION SELECT * FROM top_executions 
  UNION SELECT * FROM top_rows_per_exec) A
INNER JOIN sys.query_store_plan qp
  ON qp.query_id = A.query_id AND qp.last_execution_time = A.last_execution_time
INNER JOIN sys.query_store_query q
  ON A.query_id = q.query_id
INNER JOIN sys.query_store_query_text qt
  ON q.query_text_id = qt.query_text_id
ORDER BY A.query_id;
