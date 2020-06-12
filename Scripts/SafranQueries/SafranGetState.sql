
/*
 *  Check staging table states: should be zeroes when not running.
 */
SELECT
  S.Name SchemaName,
  T.name ObjectName,
  i.Rows NumberOfRows
FROM
  sys.tables T
  JOIN sys.sysindexes I ON T.OBJECT_ID = I.ID
  JOIN sys.schemas S ON T.schema_id = S.schema_ID
WHERE
  indid IN (0, 1)
  and S.name like 'safran'
  and (
    T.name like'%[_]Staging[_]Delta'
    or T.name like '%[_Staging_]Full'
    or T.name like '%[_]Staging[_]Keylist'
  )
order by
  ObjectName

/*
 *  Show Highwater Mark
 */
select *
from
	safran.HighWaterMark m
order by
	ExtractionTimeUTC desc

