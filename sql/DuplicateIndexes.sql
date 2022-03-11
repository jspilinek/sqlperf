WITH IndexSummary AS
(
SELECT DISTINCT sys.tables.name AS [Table Name], 
    sys.indexes.name AS [Index Name], 
    SUBSTRING((SELECT ', ' +  sys.columns.name as [text()]
        FROM sys.columns
            INNER JOIN sys.index_columns
                ON sys.index_columns.column_id = sys.columns.column_id
                AND sys.index_columns.object_id = sys.columns.object_id
        WHERE sys.index_columns.index_id = sys.indexes.index_id
            AND sys.index_columns.object_id = sys.indexes.object_id
            AND sys.index_columns.is_included_column = 0
        ORDER BY sys.index_columns.index_column_id
    FOR XML Path('')), 2, 10000) AS [Indexed Column Names],
    ISNULL(SUBSTRING((SELECT ', ' +  sys.columns.name as [text()]
        FROM sys.columns
            INNER JOIN sys.index_columns
            ON sys.index_columns.column_id = sys.columns.column_id
            AND sys.index_columns.object_id = sys.columns.object_id
        WHERE sys.index_columns.index_id = sys.indexes.index_id
            AND sys.index_columns.object_id = sys.indexes.object_id
            AND sys.index_columns.is_included_column = 1
        ORDER BY sys.columns.name
        FOR XML Path('')), 2, 10000), '') AS [Included Column Names],
    sys.indexes.index_id, sys.indexes.object_id,
    case when sys.indexes.is_unique = 1 then 'UNIQUE ' else '' end + sys.indexes.type_desc AS [Index Type]
FROM sys.indexes
    INNER JOIN sys.index_columns
        ON sys.indexes.index_id = sys.index_columns.index_id
            AND sys.indexes.object_id = sys.index_columns.object_id
    INNER JOIN sys.tables
        ON sys.tables.object_id = sys.indexes.object_id    
)
SELECT IndexSummary.[Table Name], 
    IndexSummary.[Index Name], 
    IndexSummary.[Indexed Column Names], 
    IndexSummary.[Included Column Names],
    IndexSummary.[Index Type]
FROM IndexSummary
WHERE (SELECT COUNT(*) as Computed 
        FROM IndexSummary Summary2 
        WHERE Summary2.[Table Name] = IndexSummary.[Table Name]
            AND Summary2.[Indexed Column Names] = IndexSummary.[Indexed Column Names]
            AND Summary2.[Index Type] = IndexSummary.[Index Type] ) > 1
ORDER BY [Table Name], [Indexed Column Names], [Included Column Names], [Index Name];
