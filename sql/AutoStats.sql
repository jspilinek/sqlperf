SELECT name, 
  is_auto_update_stats_on, 
  is_auto_update_stats_async_on, 
  is_auto_create_stats_on
FROM sys.databases
WHERE database_id = DB_ID();
