SELECT sys.tables.name AS [Table Name], 
  sys.computed_columns.name AS [Computed Column Name], 
  sys.computed_columns.definition 
FROM sys.tables INNER JOIN sys.computed_columns ON sys.tables.object_id = sys.computed_columns.object_id
ORDER BY sys.tables.name, sys.computed_columns.name;
