WITH AggregateBufferPoolUsage
AS
(SELECT database_id,
CAST(COUNT(*) * 8/1024.0 AS DECIMAL (10,2))  AS [CachedSize]
FROM sys.dm_os_buffer_descriptors
WHERE database_id <> 32767 
GROUP BY database_id)
SELECT ROW_NUMBER() OVER(ORDER BY CachedSize DESC) AS [Buffer Pool Rank], 
        CAST(DB_NAME(database_id) AS VARCHAR(30)) AS [Database Name], 
        CachedSize AS [Cached Size (MB)],
        CAST(CachedSize / SUM(CachedSize) OVER() * 100.0 AS DECIMAL(5,2)) AS [Buffer Pool Percent]
FROM AggregateBufferPoolUsage
ORDER BY [Buffer Pool Rank];
