SELECT counter_name, cntr_value
FROM sys.dm_os_performance_counters
WHERE (counter_name='SQL Re-Compilations/sec'
    OR counter_name='SQL Compilations/sec'
    OR counter_name='Batch Requests/sec')
AND (object_name like '%SQL Statistics%');
