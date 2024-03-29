SELECT FORMAT(MIN(start_time AT TIME ZONE 'ENTER_TIME_ZONE'), 'ENTER_DATE_FORMAT') AS OldestEntry,
FORMAT(MAX(start_time AT TIME ZONE 'ENTER_TIME_ZONE'), 'ENTER_DATE_FORMAT') AS MostRecent,
COUNT(*) AS Count
FROM sys.query_store_runtime_stats_interval;
