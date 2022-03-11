SELECT systab.name AS [Table Name], 
    (c.total_pages - c.used_pages)*100/c.total_pages AS [% Unused],
    c.rows, 
    c.total_pages, 
    c.used_pages,
    (c.total_pages - c.used_pages) AS [Unused Pages],
    c.data_pages
  FROM sys.tables systab,
  (SELECT rows, 
        object_id, 
        SUM(total_pages) total_pages, 
        SUM(used_pages) used_pages, 
        SUM(data_pages) data_pages 
      FROM sys.partitions a 
      INNER JOIN sys.allocation_units b 
      ON a.hobt_id = b.container_id 
      GROUP BY object_id, rows
  ) c
  WHERE systab.object_id = c.object_id
    AND (c.total_pages - c.used_pages) > 131072 --8kb * 131072 = 1 GB
ORDER BY [Unused Pages] desc;