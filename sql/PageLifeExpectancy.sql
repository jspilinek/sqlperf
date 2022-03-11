SELECT counter_name, cntr_value
FROM sys.dm_os_performance_counters
WHERE (counter_name='Page life expectancy')
AND object_name like '%Buffer Manager%';
