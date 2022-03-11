SELECT t.name AS TableName,
  p.rows
FROM sys.tables t
INNER JOIN sys.partitions p ON t.object_id = p.object_id
INNER JOIN sys.indexes i ON t.object_id = i.object_id AND p.index_id = i.index_id
WHERE OBJECTPROPERTY(t.object_id,'TableHasPrimaryKey') = 0
  AND i.type_desc NOT LIKE 'HEAP'
  AND i.index_id < 2
ORDER BY 1;
