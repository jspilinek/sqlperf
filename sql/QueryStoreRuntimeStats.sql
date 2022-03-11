SELECT MIN(start_time) AS OldestEntry,
MAX(start_time) AS MostRecent,
COUNT(*) AS Count
FROM sys.query_store_runtime_stats_interval;
