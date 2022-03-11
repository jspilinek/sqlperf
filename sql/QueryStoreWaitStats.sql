WITH waits AS (SELECT w.wait_category_desc, 
  w.wait_category,
  SUM(w.total_query_wait_time_ms) AS total_query_wait_time_ms
FROM sys.query_store_wait_stats AS w
INNER JOIN sys.query_store_runtime_stats_interval AS rsi
ON rsi.runtime_stats_interval_id = w.runtime_stats_interval_id
WHERE rsi.start_time >= 'ENTER_START_TIME' 
AND rsi.end_time <= 'ENTER_END_TIME'
GROUP BY w.wait_category_desc, w.wait_category),

WaitTotal AS (SELECT SUM(total_query_wait_time_ms) as total_query_wait_time_ms FROM waits)

SELECT TOP 5 w.wait_category_desc, 
  w.wait_category,
  w.total_query_wait_time_ms, 
  CAST(ROUND((100.0*w.total_query_wait_time_ms/wt.total_query_wait_time_ms),2 ) AS decimal(10,2)) AS Percentage
FROM waits w, WaitTotal wt
ORDER BY w.total_query_wait_time_ms DESC;
