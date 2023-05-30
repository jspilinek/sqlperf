SELECT TOP ENTER_TOP_COUNT
  rs.plan_id,
  ROUND(SUM(rs.avg_cpu_time/1000000 * rs.count_executions)/SUM(rs.count_executions),3) AS AvgCpuSec
FROM sys.query_store_runtime_stats rs
INNER JOIN sys.query_store_runtime_stats_interval rsi
  ON rsi.runtime_stats_interval_id = rs.runtime_stats_interval_id
WHERE rs.avg_cpu_time > 10000 --10 milliseconds
AND rsi.start_time >= 'ENTER_START_TIME' 
AND rsi.end_time <= 'ENTER_END_TIME'
GROUP BY rs.plan_id
ORDER BY AvgCpuSec DESC;
