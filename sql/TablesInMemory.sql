SELECT tbl.name, tbl.is_memory_optimized
FROM sys.tables as tbl
WHERE tbl.is_memory_optimized = 1;
