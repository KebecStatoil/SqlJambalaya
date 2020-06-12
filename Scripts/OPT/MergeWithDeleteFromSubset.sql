/*
 * create the tables

CREATE TABLE [safran].[DUMMY](
	[META_SourceDatabase] [int] NOT NULL,
	[SEQ] [int] NOT NULL,
	[NET_ID] [int] NOT NULL,
	[SomeData] [nvarchar](64) NULL
 CONSTRAINT [PK_DUMMY] PRIMARY KEY CLUSTERED 
(
	[META_SourceDatabase] ASC,
	[NET_ID] ASC,
	[SEQ] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF)
)
GO

CREATE TABLE [safran_staging].[DUMMY](
	[META_SourceDatabase] [int] NOT NULL,
	[SEQ] [int] NOT NULL,
	[NET_ID] [int] NOT NULL,
	[SomeData] [nvarchar](64) NULL
 CONSTRAINT [PK_DUMMY] PRIMARY KEY CLUSTERED 
(
	[META_SourceDatabase] ASC,
	[NET_ID] ASC,
	[SEQ] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF)
)
GO
 */


/*
 * set up the data

insert into [safran_staging].[DUMMY]
select *
from
	(values
		(299, 1, 1, 'a')
	) AS T (
		META_SourceDatabase,
		SEQ,
		NET_ID,
		SomeData
	)

insert into [safran].[DUMMY]
select *
from
	(values
		(299, 1, 1, 'a'),
		(299, 2, 1, 'b'),
		(299, 1, 2, 'q')
	) AS T (
		META_SourceDatabase,
		SEQ,
		NET_ID,
		SomeData
	)
 */


/*
 * the experiment

select 'pre-condition: staging & destination'
select * from safran_staging.dummy
select * from safran.dummy

declare @target_network int = 1;

with target_network as (
  select *
  from safran.dummy
  where net_id = @target_network
)
merge
	target_network as target
using
	safran_staging.dummy as source
on
	target.META_SourceDatabase = source.META_SourceDatabase
	and target.SEQ = source.SEQ
	and target.NET_ID = source.NET_ID
when
	matched and target.SomeData <> source.SomeData
then
	update
	set
		target.SomeData = source.SomeData
when
	not matched by target
then
	insert (
		META_SourceDatabase,
		SEQ,
		NET_ID,
		SomeData
	)
	values (
		source.META_SourceDatabase,
		source.SEQ,
		source.NET_ID,
		source.SomeData
	)
when
	not matched by source
then
	delete;

select 'post-condition: staging & destination'
select * from safran_staging.dummy
select * from safran.dummy
 */


/*
 * reset

delete safran.dummy
delete safran_staging.dummy
 */


/*
 * clean up
DROP TABLE [safran].[DUMMY]
GO

DROP TABLE [safran_staging].[DUMMY]
GO
 */
