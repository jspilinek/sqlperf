select s.name as schema_name,
	   t.name as table_name,
	   'ALTER TABLE ' + QUOTENAME(s.name) + '.' + QUOTENAME(t.name) + ' REBUILD WITH (DATA_COMPRESSION = ROW, MAXDOP = 16, SORT_IN_TEMPDB = ON);'
from sys.indexes i
inner join sys.tables t
on i.object_id = t.object_id
inner join sys.schemas s
on t.schema_id = s.schema_id
where i.type = 0
      and
	  -- include only uncompressed heaps
	  exists (
		     select 1
			 from sys.partitions p
			 where p.object_id = t.object_id
			       and
				   p.index_id = i.index_id
				   and
				   p.data_compression_desc = 'NONE'
			 )
order by schema_name, table_name
;