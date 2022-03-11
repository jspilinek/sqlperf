WITH total_lookups AS (
SELECT SUM(user_lookups) sum_value FROM sys.dm_db_index_usage_stats s WHERE s.database_id = db_id())
SELECT TOP 20 
  total.sum_value,
  CAST(ROUND(100.00*s.user_lookups/total.sum_value,2) AS NUMERIC(6,2)) AS [% of Total],
  t.name AS TableName,
  ISNULL(i.name,'HeapTable') AS IndexName,
  s.*
FROM total_lookups total, sys.dm_db_index_usage_stats s 
INNER JOIN sys.indexes i
    ON i.object_id = s.object_id
        AND i.index_id = s.index_id
INNER JOIN sys.tables t
    ON i.object_id = t.object_id
WHERE database_id = db_id ()
AND s.user_lookups > 0
ORDER BY s.user_lookups DESC;
