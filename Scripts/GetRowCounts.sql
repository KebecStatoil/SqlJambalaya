SELECT
  S.Name SchemaName,
  T.name ObjectName,
  i.Rows NumberOfRows,
  T.Type ObjectType
FROM
  sys.tables T
  JOIN sys.sysindexes I ON T.OBJECT_ID = I.ID
  JOIN sys.schemas S ON T.schema_id = S.schema_ID
WHERE
  indid IN (0, 1)
order by
  NumberOfRows desc

----[?03.?09.?2018 13:58]  Morten Pedersen (MORTEPE):
--SELECT
--  S.Name SchemaName,
--  T.name ObjectName,
--  i.Rows NumberOfRows,
--  T.Type ObjectType
--FROM
--  sys.tables T
--  JOIN sys.sysindexes I ON T.OBJECT_ID = I.ID
--  JOIN sys.schemas S ON T.schema_id = S.schema_ID
--WHERE
--  indid IN (0, 1)
--UNION
--SELECT
--  S.Name SchemaName,
--  T.name ObjectName,
--  i.Rows NumberOfRows,
--  T.Type ObjectType
--FROM
--  sys.views T
--  JOIN sys.sysindexes I ON T.OBJECT_ID = I.ID
--  JOIN sys.schemas S ON T.schema_id = S.schema_ID
--WHERE
--  indid IN (0, 1)
--order by
--  ObjectName



-- Raghunanda Vaidya
--Select A.name,B.rows From sys.objects A
--Inner Join sys.partitions B on A.object_id = B.object_id
--Where B.index_id <=1 and a.type='U' and a.name like '%BKPF%' 