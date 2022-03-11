SELECT SCHEMA_NAME(t.schema_id) AS schemaName
FROM sys.tables t
INNER JOIN sys.partitions p ON p.object_id = t.object_id
WHERE t.name = 'WtUpgInst_VersionedAssembly'
  AND p.index_id < 2
  AND p.rows > 0;