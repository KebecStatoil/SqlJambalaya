/*
 *  find text in sql objects
 */
DECLARE @Search varchar(255)
SET
  @Search = 'MP_MEMBER'
SELECT
  DISTINCT
  s.name Schema_Name,
  o.name AS Object_Name,
  o.type_desc
FROM
  sys.sql_modules m
  INNER JOIN sys.objects o ON m.object_id = o.object_id
  join sys.schemas s on s.schema_id = o.schema_id
WHERE
  m.definition Like '%' + @Search + '%'
ORDER BY
  type_desc,
  Object_Name