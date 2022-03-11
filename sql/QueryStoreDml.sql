SELECT TOP ENTER_TOP_COUNT
  qp.query_id,
  qp.plan_id,
  MAX(rs.last_execution_time) AS LastExecution,
  SUM(rs.count_executions) AS Executions,
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
WHERE rsi.start_time >= 'ENTER_START_TIME' 
AND rsi.end_time <= 'ENTER_END_TIME'
AND (UPPER(qt.query_sql_text) LIKE '%INSERT %'
OR UPPER(qt.query_sql_text) LIKE '%DELETE FROM %'
OR UPPER(qt.query_sql_text) LIKE '%UPDATE % SET %')
GROUP BY qp.query_id, qp.plan_id
ORDER BY Executions DESC;
