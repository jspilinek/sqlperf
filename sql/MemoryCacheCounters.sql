SELECT top 10 type, 
  name,
  pages_kb,
  entries_count
FROM sys.dm_os_memory_cache_counters
ORDER BY pages_kb DESC;
