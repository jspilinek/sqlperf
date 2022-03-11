SELECT DB_NAME(fs.database_id) AS [Database Name], 
  CAST(fs.io_stall_read_ms/(1.0 + fs.num_of_reads) AS NUMERIC(10,1)) AS [avg_read_stall_ms],
  CAST(fs.io_stall_write_ms/(1.0 + fs.num_of_writes) AS NUMERIC(10,1)) AS [avg_write_stall_ms],
  CAST((fs.io_stall_read_ms + fs.io_stall_write_ms)/(1.0 + fs.num_of_reads + fs.num_of_writes) AS NUMERIC(10,1)) AS [avg_io_stall_ms],
  CONVERT(DECIMAL(18,2), df.size/128.0) AS [File Size (MB)], 
  df.physical_name,
  df.type_desc,
  fs.io_stall_read_ms, 
  fs.num_of_reads, 
  fs.io_stall_write_ms, 
  fs.num_of_writes, 
  fs.io_stall,
  fs.num_of_reads + fs.num_of_writes AS [total_io],
  fs.file_id
FROM sys.dm_io_virtual_file_stats(null,null) AS fs
LEFT OUTER JOIN sys.database_files AS df ON fs.[file_id]= df.[file_id] AND fs.database_id = DB_ID()
ORDER BY avg_io_stall_ms DESC;
