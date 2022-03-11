--column_id for each PK
WITH pk_column_id AS (
select ic.column_id, i.object_id 
from sys.indexes i 
JOIN sys.index_columns ic
ON i.object_id = ic.object_id AND i.index_id = ic.index_id
where i.is_primary_key = 1
),

IndexSummary1 AS (
SELECT OBJECT_NAME(i.object_id) [TableName],
  i.name [IndexName],
  case when i.is_unique = 1 then 'UNIQUE ' else '' end + i.type_desc [IndexType],
i.object_id,
i.index_id,
SUBSTRING((SELECT ', ' + c.name 
    FROM sys.index_columns ic
    JOIN sys.columns c
        ON c.object_id = ic.object_id
        AND c.column_id = ic.column_id
    WHERE ic.object_id = i.object_id
        AND ic.index_id = i.index_id
    ORDER BY ic.key_ordinal
    FOR XML PATH('')
    ), 3, 2048) [index_key_columns]
FROM sys.indexes i
WHERE i.type > 0 AND i.object_id > 100
AND i.is_primary_key = 0
),

IndexSummary2 AS (
SELECT OBJECT_NAME(i.object_id) [TableName],
  i.name [IndexName],
  case when i.is_unique = 1 then 'UNIQUE ' else '' end + i.type_desc [IndexType],
i.object_id,
i.index_id,
SUBSTRING((SELECT ', ' + c.name 
    FROM pk_column_id
	JOIN sys.index_columns ic
		ON ic.object_id = pk_column_id.object_id AND ic.column_id <> pk_column_id.column_id
    JOIN sys.columns c
        ON c.object_id = ic.object_id
        AND c.column_id = ic.column_id
    WHERE ic.object_id = i.object_id
        AND ic.index_id = i.index_id
    ORDER BY ic.key_ordinal
    FOR XML PATH('')
    ), 3, 2048) [index_key_columns without PK],
SUBSTRING((SELECT ', ' + c.name 
    FROM sys.index_columns ic
    JOIN sys.columns c
        ON c.object_id = ic.object_id
        AND c.column_id = ic.column_id
    WHERE ic.object_id = i.object_id
        AND ic.index_id = i.index_id
    ORDER BY ic.key_ordinal
    FOR XML PATH('')
    ), 3, 2048) [index_key_columns]
FROM sys.indexes i
WHERE i.type > 0 AND i.object_id > 100
AND i.is_primary_key = 0
)

SELECT i1.TableName, i1.IndexName, i1.IndexType, i1.index_id, i1.index_key_columns,
  i2.IndexName [Dupe IndexName], i2.IndexType [Dupe IndexType], i2.index_id [Dupe index_id], i2.[index_key_columns without PK] [Dupe index_key_columns without PK]
FROM IndexSummary1 i1
JOIN IndexSummary2 i2
	ON i2.object_id = i1.object_id
	AND i2.[index_key_columns without PK] = i1.index_key_columns
	AND i2.index_id <> i1.index_id
ORDER BY i1.TableName, i1.IndexName
;
