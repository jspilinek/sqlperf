SELECT SCHEMA_NAME(t.schema_id) AS [Schema Name],
  t.name AS [Table Name], 
  c.rows, 
  c.total_pages, 
  c.used_pages,
  CAST(ROUND(CAST(c.used_pages AS float) * 8.0 / 1024.0, 2) AS numeric(18,2)) AS [Size MB],
  CAST(c.data_compression_desc AS VARCHAR(19)) AS [Data Compression]
FROM sys.tables t,
(SELECT p.rows, 
        p.object_id, 
        SUM(a.total_pages) total_pages, 
        SUM(a.used_pages) used_pages,
        p.data_compression_desc
    FROM sys.partitions p 
      INNER JOIN sys.allocation_units a ON p.hobt_id = a.container_id 
    WHERE p.index_id < 2
    GROUP BY p.object_id, p.rows, p.data_compression_desc
) c
WHERE t.object_id = c.object_id
ORDER BY t.name;
