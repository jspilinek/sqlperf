SELECT t.name AS [Table Name], 
  c.rows AS [Table Rows],
  s.name AS [Stat Name],
  sp.rows AS [Stat Rows],
  CAST(ROUND(100.00 * sp.rows / c.rows, 2) AS numeric(7,2)) AS [Stat/Table Ratio],
  FORMAT(sp.last_updated, 'ENTER_DATE_FORMAT') AS [Stat Last Updated],
  s.no_recompute,
  sp.rows_sampled AS [Rows Sampled],
  CAST(ROUND(ISNULL(100.00*sp.rows_sampled/sp.rows,0),2) AS numeric(7,2)) AS [Sample Percentage],
  sp.modification_counter,
  sp.unfiltered_rows
FROM sys.tables t
INNER JOIN sys.stats s ON t.object_id = s.object_id
CROSS APPLY sys.dm_db_stats_properties(s.object_id, s.stats_id) AS sp,
(SELECT p.rows, 
        p.object_id
    FROM sys.partitions p 
      INNER JOIN sys.allocation_units a ON p.hobt_id = a.container_id 
    WHERE p.index_id < 2
    GROUP BY p.object_id, p.rows, p.data_compression_desc
) c
WHERE t.object_id = c.object_id
AND sp.rows IS NOT NULL
AND c.rows > 10000
AND 100.00 * sp.rows / c.rows  < 10
ORDER BY [Stat/Table Ratio];
