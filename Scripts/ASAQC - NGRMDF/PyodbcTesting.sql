----GRANT EXECUTE ON schema::developer_p TO [shards_data_writer]
----GRANT SELECT ON schema::developer  TO [shards_data_writer]
----create schema developer

----CREATE USER [shards_data_writer]
----	FOR LOGIN [shards_data_writer]
----	WITH DEFAULT_SCHEMA = dbo
----GO


----/****** Object:  Table [dbo].[db2db_testing]    Script Date: 04.04.2019 14:14:40 ******/
----DROP TABLE [dbo].[db2db_testing]
----GO

----/****** Object:  Table [dbo].[db2db_testing]    Script Date: 04.04.2019 14:14:40 ******/
----SET ANSI_NULLS ON
----GO

----SET QUOTED_IDENTIFIER ON
----GO

----CREATE TABLE [developer].[db2db_testing](
----	[test_text] [nvarchar](50) NULL
----) ON [PRIMARY]
----GO




