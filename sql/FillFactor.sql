SELECT t.name AS [Table Name],
  ind.name AS [Index Name],
  ind.fill_factor
FROM sys.indexes ind 
INNER JOIN sys.tables t ON ind.object_id = t.object_id 
WHERE t.is_ms_shipped = 0 
  AND ind.fill_factor <> 0
ORDER BY ind.fill_factor, t.name, ind.name;
