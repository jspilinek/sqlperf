SELECT t.name AS [Table Name],
  s.name AS [Stat Name],
  FORMAT(sp.last_updated AT TIME ZONE 'ENTER_TIME_ZONE', 'ENTER_DATE_FORMAT') AS [Stat Last Updated],
  sp.rows AS [Stat rows],
  sp.rows_sampled AS [Rows Sampled],
  sp.modification_counter,
  sp.unfiltered_rows,
  'EXEC sp_autostats "' + SCHEMA_NAME(t.schema_id) + '.' + t.name + '", "ON";' AS [ENABLE AUTOSTATS COMMAND]
FROM sys.tables t
INNER JOIN sys.stats s ON t.object_id = s.object_id
CROSS APPLY sys.dm_db_stats_properties(s.object_id, s.stats_id) AS sp
WHERE s.no_recompute = 1
AND sp.last_updated IS NOT NULL
ORDER BY [Table Name], [Stat Name];