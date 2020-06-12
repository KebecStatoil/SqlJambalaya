-- src: https://stackoverflow.com/questions/7892334/get-size-of-all-tables-in-database


SELECT 
	s.Name AS SchemaName,
    t.NAME AS TableName,
    --p.rows AS RowCounts,
    --SUM(a.total_pages) * 8 AS TotalSpaceKB, 
    CAST(ROUND(((SUM(a.total_pages) * 8) / 1024.00), 2) AS NUMERIC(36, 2)) AS TotalSpaceMB,
    --SUM(a.used_pages) * 8 AS UsedSpaceKB, 
    CAST(ROUND(((SUM(a.used_pages) * 8) / 1024.00), 2) AS NUMERIC(36, 2)) AS UsedSpaceMB, 
    --(SUM(a.total_pages) - SUM(a.used_pages)) * 8 AS UnusedSpaceKB,
    CAST(ROUND(((SUM(a.total_pages) - SUM(a.used_pages)) * 8) / 1024.00, 2) AS NUMERIC(36, 2)) AS UnusedSpaceMB
FROM 
    sys.tables t
INNER JOIN      
    sys.indexes i ON t.OBJECT_ID = i.object_id
INNER JOIN 
    sys.partitions p ON i.object_id = p.OBJECT_ID AND i.index_id = p.index_id
INNER JOIN 
    sys.allocation_units a ON p.partition_id = a.container_id
LEFT OUTER JOIN 
    sys.schemas s ON t.schema_id = s.schema_id
WHERE
	t.NAME NOT LIKE 'dt%' 
	and t.name like '%[_]staging[_]%'
    AND t.is_ms_shipped = 0
    AND i.OBJECT_ID > 255 
	and s.name = 'safran'
	--and p.rows = 0
	--and a.total_pages <> 0
GROUP BY 
    s.Name,
	t.name
ORDER BY 
    TotalSpaceMB desc




--SELECT 
--    s.Name AS SchemaName,
--    CAST(ROUND(((SUM(a.total_pages) * 8) / 1024.00), 2) AS NUMERIC(36, 2)) AS TotalSpaceMB,
--    CAST(ROUND(((SUM(a.used_pages) * 8) / 1024.00), 2) AS NUMERIC(36, 2)) AS UsedSpaceMB, 
--    CAST(ROUND(((SUM(a.total_pages) - SUM(a.used_pages)) * 8) / 1024.00, 2) AS NUMERIC(36, 2)) AS UnusedSpaceMB
--FROM 
--    sys.tables t
--INNER JOIN      
--    sys.indexes i ON t.OBJECT_ID = i.object_id
--INNER JOIN 
--    sys.partitions p ON i.object_id = p.OBJECT_ID AND i.index_id = p.index_id
--INNER JOIN 
--    sys.allocation_units a ON p.partition_id = a.container_id
--LEFT OUTER JOIN 
--    sys.schemas s ON t.schema_id = s.schema_id
--WHERE
--	t.NAME NOT LIKE 'dt%' 
--    AND t.is_ms_shipped = 0
--    AND i.OBJECT_ID > 255 
--GROUP BY 
--    s.Name
--ORDER BY
--	TotalSpaceMB desc