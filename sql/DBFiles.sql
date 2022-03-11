SELECT DB_NAME(database_id) AS [DB Name], 
  file_id, 
  name AS [Logical Name], 
  type_desc,
  state_desc,
  size / 128 AS [Size(MB)],
  CASE max_size
    WHEN -1 THEN 'unlimited'
    WHEN 0 THEN 'no growth'
    ELSE CAST((CAST (max_size AS BIGINT)) / 128 AS VARCHAR(10))
    END AS [MaxSize(MB)],
  CASE is_percent_growth
    WHEN 1 THEN CAST(growth AS VARCHAR(3)) + ' %'
    WHEN 0 THEN CAST(growth/128 AS VARCHAR(10)) + ' mb'
    END AS Growth,
  physical_name
FROM sys.master_files
ORDER BY DB_NAME(database_id), name;
