SELECT counter_name, cntr_value
FROM sys.dm_os_performance_counters
WHERE (counter_name='Full Scans/sec'
    OR counter_name='Index Searches/sec')
AND (object_name like '%Access Methods%');
