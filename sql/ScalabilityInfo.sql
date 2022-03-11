SELECT qs.total_worker_time AS [CPU Time (sec)],
  qs.total_elapsed_time AS [Elapsed Time (sec)],
  qs.total_logical_reads,
  qs.total_physical_reads,
  CAST(ROUND((CAST(qs.total_logical_reads - qs.total_physical_reads AS float) / CAST (qs.total_logical_reads AS float) * 100.00), 2) AS numeric(7,2))  AS [Cache Hit Ratio]
FROM (
SELECT SUM(total_worker_time)/1000000 AS total_worker_time, 
  SUM(total_elapsed_time)/1000000 AS total_elapsed_time,
  SUM(total_logical_reads) AS total_logical_reads,
  SUM(total_physical_reads) AS total_physical_reads
FROM sys.dm_exec_query_stats) qs;