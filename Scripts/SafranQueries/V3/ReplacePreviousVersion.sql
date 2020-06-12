
-- ACTION REQUIRED: TAKE "WITH SCHEMABINDING" OFF [om].[Planning_Activities]

--select 'drop table safran.' + o.name
--from sys.objects o join sys.schemas s on s.schema_id = o.schema_id where type = 'u' and o.name not like '%staging%' and s.name = 'v5_safran'

--select 'ALTER SCHEMA safran TRANSFER OBJECT::v5_safran.' + o.name + ';'
--from sys.objects o join sys.schemas s on s.schema_id = o.schema_id where type = 'u' and o.name not like '%staging%' and s.name = 'v5_safran'

-- ACTION REQUIRED: PUT "WITH SCHEMABINDING" BACK ON [om].[Planning_Activities]

--select 'ALTER SCHEMA safran_staging TRANSFER OBJECT::v5_safran_staging.' + o.name + ';'
--from sys.objects o join sys.schemas s on s.schema_id = o.schema_id where type = 'u' and s.name = 'v5_safran_staging'

--select 'drop table safran.' + o.name + ';'
--from sys.objects o join sys.schemas s on s.schema_id = o.schema_id where type = 'u' and (o.name like '%staging%' or o.name like 'HighWaterMark') and s.name = 'safran'

--select 'drop procedure safran.' + o.name + ';'
--from sys.objects o join sys.schemas s on s.schema_id = o.schema_id where type = 'p' and s.name = 'safran'

--select 'ALTER SCHEMA safran_staging TRANSFER OBJECT::v5_safran_staging.' + o.name + ';'
--from sys.objects o join sys.schemas s on s.schema_id = o.schema_id where type = 'p' and s.name = 'v5_safran_staging'

--select 'select top 10 * from om.' + o.name + ' order by newid()'
--from sys.objects o join sys.schemas s on s.schema_id = o.schema_id where type = 'v' and s.name = 'om'
