SELECT CAST(DB_NAME(database_id) AS VARCHAR(30)) AS [Database Name], 
  COUNT(page_id) AS [Page Count],
  CAST(COUNT(*)/128.0 AS DECIMAL(10, 2)) AS [Buffer size(MB)], 
  AVG(read_microsec) AS [Avg Read Time (microseconds)]
FROM sys.dm_os_buffer_descriptors
WHERE database_id <> 32767
AND is_in_bpool_extension = 1
GROUP BY DB_NAME(database_id) ;
