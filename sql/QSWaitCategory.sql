SELECT TOP ENTER_TOP_COUNT 
  q.query_id,
  ws.plan_id, 
  SUM(ws.total_query_wait_time_ms) AS TotalWait_ms, 
  MAX(ws.avg_query_wait_time_ms) AS MaxAvgWait_ms,
  MIN(ws.avg_query_wait_time_ms) AS MinAvgWait_ms,
  ws.execution_type, 
  MAX(qt.query_sql_text) AS text
FROM sys.query_store_runtime_stats_interval rsi
INNER JOIN sys.query_store_wait_stats ws
ON ws.runtime_stats_interval_id = rsi.runtime_stats_interval_id
INNER JOIN sys.query_store_plan qp
INNER JOIN sys.query_store_query q
  ON qp.query_id = q.query_id
INNER JOIN sys.query_store_query_text qt
  ON q.query_text_id = qt.query_text_id
ON qp.plan_id = ws.plan_id
WHERE rsi.start_time >= 'ENTER_START_TIME' 
AND rsi.end_time <= 'ENTER_END_TIME'
AND ws.wait_category = ENTER_WAIT_CATEGORY
GROUP BY q.query_id, ws.plan_id, ws.execution_type
ORDER BY SUM(ws.total_query_wait_time_ms) DESC;
