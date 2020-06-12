
/*
 *  src: https://stackoverflow.com/questions/6406287/how-to-trace-the-foreign-keys
 *
 *  This is a quick sketch.
 *
 *  Assumptions
 *
 *  1) There are only two levels of foreign keys
 *     For a deeper relation tree use a recursive CTE to build up the table joins
 *     Maintain a root to find ancester with a timestamp
 *
 *  2) The parent HighWaterMark column is "timestamp"
 *     To allow variability in the column name, join in a table that maintains the those columns
 *
 */
with KeyRelationTable as (
	SELECT 
		FK.TABLE_NAME as child_table, 
		CU.COLUMN_NAME as child_column, 
		PK.TABLE_NAME  as parent_table, 
		PT.COLUMN_NAME as parent_column,
		C.CONSTRAINT_NAME 
	FROM 
	INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS C 
	INNER JOIN 
	INFORMATION_SCHEMA.TABLE_CONSTRAINTS FK 
		ON C.CONSTRAINT_NAME = FK.CONSTRAINT_NAME 
	INNER JOIN 
	INFORMATION_SCHEMA.TABLE_CONSTRAINTS PK 
		ON C.UNIQUE_CONSTRAINT_NAME = PK.CONSTRAINT_NAME 
	INNER JOIN 
	INFORMATION_SCHEMA.KEY_COLUMN_USAGE CU 
		ON C.CONSTRAINT_NAME = CU.CONSTRAINT_NAME 
	INNER JOIN 
	( 
		SELECT 
			i1.TABLE_NAME, i2.COLUMN_NAME
		FROM 
			INFORMATION_SCHEMA.TABLE_CONSTRAINTS i1 
			INNER JOIN 
			INFORMATION_SCHEMA.KEY_COLUMN_USAGE i2 
			ON i1.CONSTRAINT_NAME = i2.CONSTRAINT_NAME 
			WHERE i1.CONSTRAINT_TYPE = 'PRIMARY KEY' 
	) PT 
	ON PT.TABLE_NAME = PK.TABLE_NAME 
)

select 
	* 
from KeyRelationTable fk


