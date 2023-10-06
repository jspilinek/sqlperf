SELECT SCHEMA_NAME(tbl.schema_id) AS [Schema Name],
  tbl.name AS [Table Name],
  (SELECT ISNULL([rows],0)  AS [Total Records]
    FROM sys.hash_indexes AS Ind
    CROSS APPLY sys.dm_db_stats_properties(Ind.object_id,Ind.index_id)
    WHERE Ind.index_id =2 AND Ind.object_id=tbl.object_id
  ) AS [Rows], 
  CAST(Round(TRY_CONVERT(float,isnull((SELECT (tms.[memory_used_by_table_kb])
    FROM [sys].[dm_db_xtp_table_memory_stats] tms
    WHERE tms.object_id = tbl.object_id), 0.0))/1024,3) AS NUMERIC(18,3)) AS [DataSpace MB], 
  CAST(ROUND(TRY_CONVERT(float,isnull((SELECT (tms.[memory_used_by_indexes_kb])
    FROM [sys].[dm_db_xtp_table_memory_stats] tms
    WHERE tms.object_id = tbl.object_id), 0.0)) /1024,3) AS NUMERIC(18,3)) AS [IndexSpace MB],
  p.data_compression_desc AS [Data Compression]
FROM sys.tables AS tbl
JOIN sys.partitions p ON p.object_id = tbl.object_id
WHERE tbl.is_memory_optimized=1 
  AND p.index_id=2
ORDER BY tbl.name;
