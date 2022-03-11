SELECT bpe.file_id,
  bpe.state,
  bpe.state_description,
  CAST(bpe.current_size_in_kb/1048576.0 AS DECIMAL(10,2)) AS [current_size_in_GB],
  bpe.path
FROM sys.dm_os_buffer_pool_extension_configuration bpe;
