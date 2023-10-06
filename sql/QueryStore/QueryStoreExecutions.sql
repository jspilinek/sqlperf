SELECT TOP ENTER_TOP_COUNT
  rs.plan_id,
  SUM(rs.count_executions) AS Executions
FROM sys.query_store_runtime_stats rs
INNER JOIN sys.query_store_runtime_stats_interval rsi
  ON rsi.runtime_stats_interval_id = rs.runtime_stats_interval_id
WHERE 1=1 --no filter
AND rsi.start_time >= 'ENTER_START_TIME' 
AND rsi.end_time <= 'ENTER_END_TIME'
GROUP BY rs.plan_id
ORDER BY Executions DESC;
