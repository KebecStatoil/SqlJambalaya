-- ====================================
-- Create the database.
-- ====================================
--CREATE DATABASE dbPartition (EDITION = 'standard', SERVICE_OBJECTIVE ='S3' )

-- ====================================
-- Create the partition function.
-- ====================================
CREATE PARTITION FUNCTION PF_HASH_BY_VALUE (BIGINT) AS RANGE LEFT
FOR VALUES (100000, 200000, 300000, 400000, 500000, 600000, 700000, 800000, 900000)

SELECT * FROM sys.partition_functions

-- ====================================
-- Create the schema partition.
-- ====================================
CREATE PARTITION SCHEME PS_HASH_BY_VALUE
AS PARTITION PF_HASH_BY_VALUE
ALL TO ([PRIMARY]);
GO

SELECT * FROM sys.partition_schemes

-- ====================================
--  Configure the Distribution data.
-- ====================================
SELECT
MY_VALUE,
$PARTITION.PF_HASH_BY_VALUE(MY_VALUE) AS HASH_IDX
FROM
(
VALUES
(1),
(100001),
(200001),
(300001),
(400001),
(500001),
(600001),
(700001),
(800001),
(900001)
) AS TEST (MY_VALUE);
GO

-- ====================================
-- Create the table, add some data and review its Distribution.
-- ====================================

CREATE TABLE [TBL_PARTITION]
( [MY_VALUE] [bigint] NOT NULL,
CONSTRAINT [PK_TBL_PARTITION] PRIMARY KEY CLUSTERED ([MY_VALUE] ASC)
) ON PS_HASH_BY_VALUE ([MY_VALUE])

insert into [TBL_PARTITION] (my_value) values(100001)
insert into [TBL_PARTITION] (my_value) values(200001)
insert into [TBL_PARTITION] (my_value) values(300001)
insert into [TBL_PARTITION] (my_value) values(400001)
insert into [TBL_PARTITION] (my_value) values(500001)
insert into [TBL_PARTITION] (my_value) values(600001)
insert into [TBL_PARTITION] (my_value) values(700001)
insert into [TBL_PARTITION] (my_value) values(800001)
insert into [TBL_PARTITION] (my_value) values(900001)

insert into [TBL_PARTITION] (my_value) values(100002)
insert into [TBL_PARTITION] (my_value) values(200002)
insert into [TBL_PARTITION] (my_value) values(300002)
insert into [TBL_PARTITION] (my_value) values(400002)
insert into [TBL_PARTITION] (my_value) values(500002)
insert into [TBL_PARTITION] (my_value) values(600002)
insert into [TBL_PARTITION] (my_value) values(700002)
insert into [TBL_PARTITION] (my_value) values(800002)
insert into [TBL_PARTITION] (my_value) values(900002)

SELECT
MY_VALUE,
$PARTITION.PF_HASH_BY_VALUE(MY_VALUE) AS HASH_IDX
FROM
( SELECT MY_VALUE FROM [TBL_PARTITION] )  AS TEST (MY_VALUE);

-- ====================================
-- Review the partition distribution.
-- ====================================
SELECT object_name(object_id),* FROM sys.dm_db_partition_stats where object_name(object_id)='TBL_PARTITION'


TRUNCATE TABLE [TBL_PARTITION] 
WITH (PARTITIONS (4));
go
--You can check here about how many partitions with number of rows belongs to the table
select * from sys.partitions where object_id=OBJECT_ID('TBL_PARTITION')
go


CREATE TABLE [TBL_PARTITION_STAGING]
( [MY_VALUE] [bigint] NOT NULL,
CONSTRAINT [PK_TBL_PARTITION_STAGING] PRIMARY KEY CLUSTERED ([MY_VALUE] ASC)
) ON PS_HASH_BY_VALUE ([MY_VALUE])

insert into [TBL_PARTITION_STAGING] (my_value) values(300003)
insert into [TBL_PARTITION_STAGING] (my_value) values(300004)


select * from [TBL_PARTITION_STAGING]


SELECT
MY_VALUE,
$PARTITION.PF_HASH_BY_VALUE(MY_VALUE) AS HASH_IDX
FROM
( SELECT MY_VALUE FROM [TBL_PARTITION_STAGING] ) AS TEST (MY_VALUE);


select * from [TBL_PARTITION]

/*
 *  TODO Make this work
 */
ALTER TABLE [TBL_PARTITION_STAGING] SWITCH PARTITION 4 TO [TBL_PARTITION] PARTITION 4 


---- clean up

--drop TABLE [TBL_PARTITION]
--drop TABLE [TBL_PARTITION_STAGING]
--drop PARTITION SCHEME PS_HASH_BY_VALUE
--drop PARTITION FUNCTION PF_HASH_BY_VALUE