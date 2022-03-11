WITH mdop AS (SELECT value FROM sys.configurations (NOLOCK) WHERE name = 'max degree of parallelism')
SELECT mdop.value AS MaxDOP,
  cpu_count, 
  hyperthread_ratio,
  physical_memory_kb/1024 AS [Physical Memory (MB)], 
  virtual_memory_kb/1024 AS [Virtual Memory (MB)], 
  committed_kb/1024 AS [Committed Memory (MB)],
  committed_target_kb/1024 AS [Committed Target Memory (MB)],
  scheduler_count, 
  max_workers_count, 
  affinity_type_desc, 
  virtual_machine_type_desc
FROM sys.dm_os_sys_info, mdop;