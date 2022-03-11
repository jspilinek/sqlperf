SELECT t.name as TableName, c.name as ColumnName, y.name as Type, c.max_length, c.is_nullable, c.is_computed
FROM sys.tables t
INNER JOIN sys.columns c ON c.object_id = t.object_id
INNER JOIN sys.types y ON c.user_type_id = y.user_type_id
ORDER BY t.name, c.name;
