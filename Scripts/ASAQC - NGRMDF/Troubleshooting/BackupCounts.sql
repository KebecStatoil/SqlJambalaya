----select
----	'select * into ' + s.name + '.' + t.name + '_BAK from ' +s.name + '.' + t.name,
----	s.name,
----	t.name
----from sys.tables t join sys.schemas s on t.schema_id = s.schema_id
----where
----	s.name = 'acquisition'
----	and t.name in (
----		'ShotInfo',
----		'ShotInfoDeviation',
----		'LatestShotInfo',
----		'GunInfo'
----	)


----select * into acquisition.GunInfo_BAK from acquisition.GunInfo
----select * into acquisition.LatestShotInfo_BAK from acquisition.LatestShotInfo
----select * into acquisition.ShotInfo_BAK from acquisition.ShotInfo
----select * into acquisition.ShotInfoDeviation_BAK from acquisition.ShotInfoDeviation


select 'acquisition.ShotInfo' TableName, count(*) TableCount from acquisition.ShotInfo UNION
select 'acquisition.ShotInfoDeviation' TableName, count(*) TableCount from acquisition.ShotInfoDeviation UNION
select 'acquisition.LatestShotInfo' TableName, count(*) TableCount from acquisition.LatestShotInfo UNION
select 'acquisition.GunInfo' TableName, count(*) TableCount from acquisition.GunInfo UNION


select 'acquisition.ShotInfo_BAK' TableName, count(*) TableCount from acquisition.ShotInfo_BAK UNION
select 'acquisition.ShotInfoDeviation_BAK' TableName, count(*) TableCount from acquisition.ShotInfoDeviation_BAK UNION
select 'acquisition.LatestShotInfo_BAK' TableName, count(*) TableCount from acquisition.LatestShotInfo_BAK UNION
select 'acquisition.GunInfo_BAK' TableName, count(*) TableCount from acquisition.GunInfo_BAK


/*
 *  Less dangerous code. ^^)
 */
----select
----	'select ''' + s.name + '.' + t.name + ''' TableName, count(*) TableCount from ' +s.name + '.' + t.name,
----	s.name,
----	t.name
----from sys.tables t join sys.schemas s on t.schema_id = s.schema_id
----where
----	s.name = 'acquisition'
----	and t.name like '%[_]BAK'