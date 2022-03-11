SELECT SCHEMA_NAME(schema_id) AS [Schema Name],
  name AS [View name],
  definition
FROM sys.views v
JOIN sys.sql_modules m on m.object_id = v.object_id;
