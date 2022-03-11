SELECT DISTINCT CAST(vs.volume_mount_point AS VARCHAR(18)) AS volume_mount_point, 
  CAST(vs.file_system_type AS VARCHAR(16)) AS file_system_type,
  CONVERT(DECIMAL(18,2),vs.total_bytes/1073741824.0) AS [Total Size (GB)],
  CONVERT(DECIMAL(18,2),vs.available_bytes/1073741824.0) AS [Available Size (GB)],  
  CONVERT(DECIMAL(18,2), vs.available_bytes * 1. / vs.total_bytes * 100.) AS [Space Free %] 
FROM sys.master_files AS f
CROSS APPLY sys.dm_os_volume_stats(f.database_id, f.file_id) vs;
