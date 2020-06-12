
/*
 *  src: https://stackoverflow.com/questions/2566844/how-can-i-check-sql-server-views-dependencies
 */

SELECT DISTINCT 
	referenced_schema_name, 
	referenced_entity_name,
	*
FROM
	sys.dm_sql_referenced_entities ('survey_v.AllEventsCombined', 'OBJECT');