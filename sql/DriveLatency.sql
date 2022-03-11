SELECT [Drive],
    CASE 
        WHEN num_of_reads = 0 THEN 0 
        ELSE (io_stall_read_ms/num_of_reads) 
    END AS [Read Latency],
    CASE 
        WHEN io_stall_write_ms = 0 THEN 0 
        ELSE (io_stall_write_ms/num_of_writes) 
    END AS [Write Latency],
    CASE 
        WHEN (num_of_reads = 0 AND num_of_writes = 0) THEN 0 
        ELSE (io_stall/(num_of_reads + num_of_writes)) 
    END AS [Overall Latency],
    CASE 
        WHEN num_of_reads = 0 THEN 0 
        ELSE (num_of_bytes_read/num_of_reads) 
    END AS [Avg Bytes/Read],
    CASE 
        WHEN io_stall_write_ms = 0 THEN 0 
        ELSE (num_of_bytes_written/num_of_writes) 
    END AS [Avg Bytes/Write],
    CASE 
        WHEN (num_of_reads = 0 AND num_of_writes = 0) THEN 0 
        ELSE ((num_of_bytes_read + num_of_bytes_written)/(num_of_reads + num_of_writes)) 
    END AS [Avg Bytes/Transfer],
    io_stall,
    num_of_reads,
    num_of_bytes_read,
    io_stall_read_ms,
    num_of_writes,
    num_of_bytes_written,
    io_stall_write_ms,
    size_on_disk_GB
FROM (SELECT LEFT(UPPER(mf.physical_name), 2) AS Drive, SUM(num_of_reads) AS num_of_reads,
             SUM(io_stall_read_ms) AS io_stall_read_ms, SUM(num_of_writes) AS num_of_writes,
             SUM(io_stall_write_ms) AS io_stall_write_ms, SUM(num_of_bytes_read) AS num_of_bytes_read,
             SUM(num_of_bytes_written) AS num_of_bytes_written, SUM(io_stall) AS io_stall,
             CONVERT(DECIMAL(18,2),SUM(size_on_disk_bytes) / 1073741824.0) AS size_on_disk_GB
      FROM sys.dm_io_virtual_file_stats(NULL, NULL) AS vfs
      INNER JOIN sys.master_files AS mf WITH (NOLOCK) ON vfs.database_id = mf.database_id AND vfs.file_id = mf.file_id
      GROUP BY LEFT(UPPER(mf.physical_name), 2)) AS tab
ORDER BY [Overall Latency];
