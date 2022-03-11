SELECT TOP 10 migs.avg_total_user_cost * migs.avg_user_impact * (migs.user_seeks + migs.user_scans) AS [Cost],
  migs.unique_compiles,
  migs.user_seeks,
  migs.avg_user_impact,
  migs.avg_total_user_cost,
  migs.last_user_seek,
  mid.statement AS [TableName],
  mid.equality_columns,
  mid.inequality_columns,
  mid.included_columns
FROM sys.dm_db_missing_index_group_stats migs
INNER JOIN sys.dm_db_missing_index_groups mig ON migs.group_handle = mig.index_group_handle
INNER JOIN sys.dm_db_missing_index_details mid ON mig.index_handle = mid.index_handle
WHERE mid.database_id = DB_ID()
ORDER BY Cost DESC;
