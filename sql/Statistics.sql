SELECT t.name AS [Table Name],
  s.name AS [Stat Name],
  s.no_recompute,
  FORMAT(sp.last_updated AT TIME ZONE 'ENTER_TIME_ZONE', 'ENTER_DATE_FORMAT') AS [Stat Last Updated],
  sp.rows AS [Stat rows],
  sp.rows_sampled AS [Rows Sampled],
  CAST(ROUND(ISNULL(100.00*sp.rows_sampled/sp.rows,0),2) AS numeric(7,2)) AS [Sample Percentage],
  sp.persisted_sample_percent,
  sp.modification_counter,
  sp.unfiltered_rows,
  'DBCC SHOW_STATISTICS("' + SCHEMA_NAME(t.schema_id) + '.' + t.name + '",' + s.name + ')' AS [SHOW_STATISTICS_COMMAND]
FROM sys.tables t
INNER JOIN sys.stats s ON t.object_id = s.object_id
CROSS APPLY sys.dm_db_stats_properties(s.object_id, s.stats_id) AS sp
WHERE sp.rows IS NOT NULL
ORDER BY t.name, s.name;