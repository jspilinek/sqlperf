SELECT is_enabled,
  max_size,
  max_files,
  path
FROM sys.dm_os_server_diagnostics_log_configurations;
