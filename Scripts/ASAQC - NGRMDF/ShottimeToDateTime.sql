/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000)
	[shottime],
	DATEADD(s, [shottime], CAST('19700101' AS datetime2) ),
	[shottime] - floor([shottime])
FROM
	[acquisition].[ShotInfo]
