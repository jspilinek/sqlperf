SELECT TOP 20
  t.name AS TableName,
  i.name AS IndexName,
  s.user_scans*p.row_count AS [Scans*Rows],
  p.row_count,
  s.*
FROM sys.dm_db_index_usage_stats s 
INNER JOIN sys.dm_db_partition_stats  p 
  ON s.object_id = p.object_id 
INNER JOIN sys.indexes i
    ON i.object_id = s.object_id
        AND i.index_id = s.index_id
INNER JOIN sys.tables t
    ON i.object_id = t.object_id
WHERE s.database_id = db_id () 
AND p.index_id < 2
AND s.user_scans > 0
order by s.user_scans*p.row_count DESC;
