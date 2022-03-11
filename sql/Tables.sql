WITH PageSize AS (SELECT v.low/1024.0 AS value FROM master.dbo.spt_values v WHERE v.number=1 and v.type='E')
SELECT SCHEMA_NAME(tbl.schema_id) AS [Schema Name],
  tbl.name AS [Table Name],
  CASE WHEN (tbl.is_memory_optimized=0) THEN p.rows
  ELSE(SELECT ISNULL([rows],0)  as [Total Records]
       FROM sys.hash_indexes as Ind
       CROSS APPLY sys.dm_db_stats_properties(Ind.object_id,Ind.index_id)
       WHERE Ind.index_id =2 AND Ind.object_id=tbl.object_id
      )
  END AS [Rows], 
  CASE WHEN (tbl.is_memory_optimized=0) THEN
        CAST(ROUND(TRY_CONVERT(float,ISNULL((SELECT PageSize.value * SUM(CASE WHEN a.type <> 1 THEN a.used_pages WHEN p.index_id < 2 THEN a.data_pages ELSE 0 END)
        FROM sys.indexes as i
        JOIN sys.partitions as p ON p.object_id = i.object_id and p.index_id = i.index_id
        JOIN sys.allocation_units as a ON a.container_id = p.partition_id
        WHERE i.object_id = tbl.object_id),0.0))/1024,3) AS NUMERIC(18,3))
  ELSE
        CAST(Round(TRY_CONVERT(float,isnull((SELECT (tms.[memory_used_by_table_kb])
        FROM [sys].[dm_db_xtp_table_memory_stats] tms
        WHERE tms.object_id = tbl.object_id), 0.0))/1024,3) AS NUMERIC(18,3))
  END as [DataSpace MB], 
  CASE WHEN (tbl.is_memory_optimized=0) THEN
    CAST(ROUND(TRY_CONVERT(float,ISNULL((
    (SELECT SUM (used_page_count) FROM sys.dm_db_partition_stats ps WHERE ps.object_id = tbl.object_id)
    + ( CASE (SELECT count(*) FROM sys.internal_tables WHERE parent_id = tbl.object_id AND internal_type IN (202,204,207,211,212,213,214,215,216,221,222))
        WHEN 0 THEN 0
        ELSE (
            SELECT sum(p.used_page_count)
            FROM sys.dm_db_partition_stats p, sys.internal_tables it
            WHERE it.parent_id = tbl.object_id AND it.internal_type IN (202,204,207,211,212,213,214,215,216,221,222) AND p.object_id = it.object_id)
        END )
    - (SELECT SUM (CASE WHEN(index_id < 2) THEN (in_row_data_page_count + lob_used_page_count + row_overflow_used_page_count) ELSE 0 END)
        FROM sys.dm_db_partition_stats WHERE object_id = tbl.object_id)
    ) * PageSize.value, 0.0) )/1024,3) AS NUMERIC(18,3))
    ELSE
      CAST(ROUND(TRY_CONVERT(float,isnull((SELECT (tms.[memory_used_by_indexes_kb])
      FROM [sys].[dm_db_xtp_table_memory_stats] tms
      WHERE tms.object_id = tbl.object_id), 0.0)) /1024,3) AS NUMERIC(18,3))
  END as [IndexSpace MB],
  p.data_compression_desc AS [Data Compression],
  tbl.is_memory_optimized AS [In-Memory]  
FROM sys.tables as tbl
JOIN sys.partitions p ON p.object_id = tbl.object_id, PageSize
WHERE (p.index_id < 2 
  OR (tbl.is_memory_optimized=1 AND p.index_id=2))
ORDER BY tbl.name;