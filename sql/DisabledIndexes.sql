SELECT t.name AS [Table Name],
  i.name AS [Index Name] 
FROM sys.tables t
INNER JOIN sys.indexes i ON t.object_id = i.object_id
WHERE i.is_disabled=1
ORDER BY t.name, i.name;
