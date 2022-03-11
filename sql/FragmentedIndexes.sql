DECLARE @DatabaseID int

SET @DatabaseID = DB_ID()

SELECT o.[name] AS ObjectName,
       i.[name] AS IndexName,
       o.type_desc AS ObjectType,
       i.type_desc AS IndexType,
       ROUND(ps.avg_fragmentation_in_percent,2) AS AvgFragmentationInPercent,
       ps.partition_number AS PartitionNumber,
       ps.fragment_count AS FragmentCount,
       ps.page_count AS [PageCount],
       CASE
         WHEN ps.avg_fragmentation_in_percent > 30 
           THEN 'alter index' + ' ' + i.name + ' ' + 'on' + ' ' 
             + '[' + DB_NAME() + '].[' + OBJECT_SCHEMA_NAME(ps.[object_id],@DatabaseID) + '].['
             + OBJECT_NAME(ps.object_id, @DatabaseID) + ']' + ' ' + 'rebuild with (online = on)'
         WHEN ps.avg_fragmentation_in_percent > 15
           THEN 'alter index' + ' ' + i.name + ' ' + 'on' + ' ' + '[' + DB_NAME() + '].[' 
       	  + OBJECT_SCHEMA_NAME(ps.object_id,@DatabaseID) + '].['
             + OBJECT_NAME(ps.object_id, @DatabaseID) + ']' + ' ' + 'reorganize' 
         ELSE 'nothing to do'
       END AS Command
FROM sys.dm_db_index_physical_stats (@DatabaseID, NULL, NULL, NULL, 'LIMITED') ps
INNER JOIN sys.indexes i ON ps.[object_id] = i.[object_id] AND ps.index_id = i.index_id
INNER JOIN sys.objects o ON i.[object_id] = o.[object_id]
WHERE o.[type] IN('U','V')
AND o.is_ms_shipped = 0
AND i.[type] IN(1,2,3,4)
AND i.is_disabled = 0
AND i.is_hypothetical = 0
AND ps.alloc_unit_type_desc = 'IN_ROW_DATA'
AND ps.index_level = 0
AND ps.page_count >= 1000
AND ps.avg_fragmentation_in_percent >= 15
ORDER BY ps.avg_fragmentation_in_percent DESC