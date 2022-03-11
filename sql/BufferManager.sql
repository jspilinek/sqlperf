SELECT counter_name,
  cntr_value
FROM sys.dm_os_performance_counters
WHERE (counter_name='Free list stalls/sec'
    OR counter_name='Lazy writes/sec')
AND object_name like '%Buffer Manager%';
