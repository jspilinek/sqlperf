WITH PageSize AS (SELECT v.low/1024.0 AS value FROM master.dbo.spt_values v WHERE v.number=1 and v.type='E')
SELECT * ,
	CAST(ROUND(CASE WHEN A.[Rows] = 0 THEN A.[DataSpace MB] ELSE A.[DataSpace MB]/A.Rows END,3) AS NUMERIC(18,3)) AS [DataSpace/Row],
	CAST(ROUND(CASE WHEN A.[IndexSpace MB] = 0 THEN A.[DataSpace MB] ELSE A.[DataSpace MB]/A.[IndexSpace MB] END,3) AS NUMERIC(18,3)) AS [DataSpace/IndexSpace]
FROM (
SELECT SCHEMA_NAME(tbl.schema_id) AS [Schema Name],
  tbl.name AS [Table Name],
  p.rows AS [Rows], 
  CAST(ROUND(TRY_CONVERT(float,ISNULL((SELECT PageSize.value * SUM(CASE WHEN a.type <> 1 THEN a.used_pages WHEN p.index_id < 2 THEN a.data_pages ELSE 0 END)
    FROM sys.indexes AS i
    JOIN sys.partitions AS p ON p.object_id = i.object_id and p.index_id = i.index_id
    JOIN sys.allocation_units AS a ON a.container_id = p.partition_id
    WHERE i.object_id = tbl.object_id),0.0))/1024,3) AS NUMERIC(18,3)) AS [DataSpace MB], 
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
    ) * PageSize.value, 0.0) )/1024,3) AS NUMERIC(18,3)) AS [IndexSpace MB],
  p.data_compression_desc AS [Data Compression],
  CASE WHEN p.index_id = 0 THEN 'HEAP' ELSE 'CLUSTERED' END AS [Table Type]
FROM sys.tables AS tbl
JOIN sys.partitions p ON p.object_id = tbl.object_id, PageSize
WHERE p.index_id < 2 
  AND tbl.is_memory_optimized=0
) A
ORDER BY A.[Table Name];
