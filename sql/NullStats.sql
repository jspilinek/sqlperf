SELECT t.name AS [Table Name],
  s.name AS [Stat Name],
  s.no_recompute,
  sp.last_updated AT TIME ZONE 'ENTER_TIME_ZONE' AS [Stat Last Updated],
  sp.rows AS [Stat rows]
FROM sys.tables t
INNER JOIN sys.stats s ON t.object_id = s.object_id
CROSS APPLY sys.dm_db_stats_properties(s.object_id, s.stats_id) AS sp
WHERE sp.rows IS NULL
ORDER BY t.name, s.name;