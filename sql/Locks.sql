SELECT counter_name, cntr_value
FROM sys.dm_os_performance_counters
WHERE (object_name = 'SQLServer:Locks')
AND ((counter_name='Lock Timeouts/sec')
  OR (counter_name='Lock Wait Time (ms)')
  OR (counter_name='Number of Deadlocks/sec'))
AND instance_name LIKE '_Total%';