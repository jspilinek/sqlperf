SELECT t.name as TableName,
  f.name as FilegroupName,
  SUM(au.total_pages) * 8 / 1024 as Total_MB,
  SUM(au.used_pages) * 8 / 1024 as Used_MB,
  SUM(au.data_pages) * 8 / 1024 as Data_MB
FROM sys.allocation_units au
INNER JOIN sys.partitions p ON au.container_id = p.partition_id
INNER JOIN sys.tables t ON t.object_id = p.object_id
INNER JOIN sys.filegroups f ON au.data_space_id = f.data_space_id
WHERE au.type = 2
GROUP BY t.name, f.name
HAVING SUM(au.total_pages) * 8 / 1024 > 1024 --Filter by 1 GB
ORDER BY Total_MB DESC;
