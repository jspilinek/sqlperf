SELECT TOP ENTER_TOP_COUNT
  rs.plan_id,
  ROUND(SUM(rs.avg_rowcount * rs.count_executions)/SUM(rs.count_executions),3) AS AvgRowCount
FROM sys.query_store_runtime_stats rs
INNER JOIN sys.query_store_runtime_stats_interval rsi
  ON rsi.runtime_stats_interval_id = rs.runtime_stats_interval_id
WHERE rs.avg_rowcount > 1000 -- 1k row count
AND rsi.start_time >= 'ENTER_START_TIME' 
AND rsi.end_time <= 'ENTER_END_TIME'
GROUP BY rs.plan_id
ORDER BY AvgRowCount DESC;
