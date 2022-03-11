SELECT SCHEMA_NAME(t.schema_id) AS [Schema Name],
  t.name AS [Table Name],
  i.name AS [Index Name],
  c.name AS [Column Name],
  ic.index_column_id AS [COLM_ID],
  CASE when ic.is_descending_key = 1 THEN 'DESC' ELSE 'ASC' END AS [Sort],
  ic.is_included_column AS [Include],
  CAST(CASE WHEN i.is_unique = 1 THEN 'UNIQUE ' 
    ELSE ''
    END
    + i.type_desc AS VARCHAR(20)) AS [Index Type],
  pa.rows,
  pa.total_pages,
  pa.used_pages,
  CAST(pa.data_compression_desc AS VARCHAR(19)) AS [Data Compression],
  CAST(ROUND(CAST(pa.used_pages AS float) / 128.0, 3) AS numeric(18,3)) AS [Index Size MB],
  i.is_hypothetical AS [Hypothetical]
FROM sys.tables t
INNER JOIN sys.indexes i ON t.object_id = i.object_id
INNER JOIN sys.index_columns ic ON i.object_id = ic.object_id AND i.index_id = ic.index_id
INNER JOIN sys.columns c ON ic.object_id = c.object_id AND ic.column_id = c.column_id,
(SELECT p.rows, 
        p.object_id,
        p.index_id, 
        SUM(a.total_pages) total_pages, 
        SUM(a.used_pages) used_pages,
        p.data_compression_desc
    FROM sys.partitions p
        INNER JOIN sys.allocation_units a
        ON p.hobt_id = a.container_id 
    GROUP BY object_id, index_id, rows, data_compression_desc
) pa 
WHERE i.object_id = pa.object_id
  AND i.index_id = pa.index_id
ORDER BY t.name, i.name, ic.index_column_id;
