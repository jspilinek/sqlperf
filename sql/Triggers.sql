SELECT tab.name AS [Table],
    trg.name AS [Trigger],
    CASE WHEN is_instead_of_trigger = 1 THEN 'Instead of'
        ELSE 'After' END AS [Activation],
    (CASE WHEN objectproperty(trg.object_id, 'ExecIsUpdateTrigger') = 1
                THEN 'Update ' ELSE '' END 
    + CASE WHEN objectproperty(trg.object_id, 'ExecIsDeleteTrigger') = 1
                THEN 'Delete ' ELSE '' END
    + CASE WHEN objectproperty(trg.object_id, 'ExecIsInsertTrigger') = 1
                THEN 'Insert' ELSE '' END
    ) AS [Event],
    CASE WHEN trg.parent_class = 1 THEN 'Table trigger'
        WHEN trg.parent_class = 0 THEN 'Database trigger' 
    END AS [ParentClass], 
    CASE WHEN trg.[type] = 'TA' THEN 'Assembly (CLR) trigger'
        WHEN trg.[type] = 'TR' THEN 'SQL trigger' 
        ELSE '' END AS [Type],
    CASE WHEN is_disabled = 1 THEN 'Disabled'
        ELSE 'Active' END AS [Status],
    object_definition(trg.object_id) AS [Definition]
FROM sys.triggers trg
LEFT JOIN sys.objects tab ON trg.parent_id = tab.object_id
ORDER BY tab.name;
