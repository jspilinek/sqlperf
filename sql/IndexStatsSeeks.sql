WITH total_seeks AS (
SELECT SUM(user_seeks) sum_value FROM sys.dm_db_index_usage_stats s WHERE s.database_id = db_id())
SELECT TOP 20 
  total.sum_value,
  CAST(ROUND(100.00*s.user_seeks/total.sum_value,2) AS NUMERIC(6,2)) AS [% of Total],
  t.name AS TableName,
  ISNULL(i.name,'HeapTable') AS IndexName,
  s.*
FROM total_seeks total, sys.dm_db_index_usage_stats s 
INNER JOIN sys.indexes i
    ON i.object_id = s.object_id
        AND i.index_id = s.index_id
INNER JOIN sys.tables t
    ON i.object_id = t.object_id
WHERE database_id = db_id ()
AND s.user_seeks > 0
ORDER BY s.user_seeks DESC;
