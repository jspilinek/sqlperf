SELECT total_physical_memory_kb/1024 AS [Physical Memory (MB)], 
       available_physical_memory_kb/1024 AS [Available Physical Memory (MB)], 
       (100*available_physical_memory_kb)/total_physical_memory_kb AS [% Available],
       total_page_file_kb/1024 AS [Total Page File (MB)], 
       available_page_file_kb/1024 AS [Available Page File (MB)], 
       system_cache_kb/1024 AS [System Cache (MB)],
       system_memory_state_desc AS [System Memory State]
FROM sys.dm_os_sys_memory;
