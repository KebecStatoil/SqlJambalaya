
-- 1 -- Rename
EXEC sp_rename 'acquisition.ShotInfoDeviation', 'ShotInfoDeviation_prev';
EXEC sp_rename 'acquisition.ShotInfoDeviation2', 'ShotInfoDeviation';

-- 2 -- Drop mis-named Constraints
ALTER TABLE [acquisition].[ShotInfoDeviation] DROP CONSTRAINT [PK_ShotInfoDeviation2] WITH ( ONLINE = OFF )
GO
ALTER TABLE [acquisition].[ShotInfoDeviation] DROP CONSTRAINT [FK_ShotInfoDeviation2_ShotInfo]
GO
ALTER TABLE [acquisition].[ShotInfoDeviation] DROP CONSTRAINT [DF_ShotInfoDeviation2_Created]
GO


---- 3 -- Move correctly named Constraints from prev to new
ALTER TABLE [acquisition].[ShotInfoDeviation_prev] DROP CONSTRAINT [PK_ShotInfoDeviation] WITH ( ONLINE = OFF )
GO
ALTER TABLE [acquisition].[ShotInfoDeviation] ADD  CONSTRAINT [PK_ShotInfoDeviation] PRIMARY KEY CLUSTERED 
(
	[SurveyID] ASC,
	[ShotInfoID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY]
GO

ALTER TABLE [acquisition].[ShotInfoDeviation_prev] DROP CONSTRAINT [FK_ShotInfoDeviation_ShotInfo]
GO
ALTER TABLE [acquisition].[ShotInfoDeviation]  WITH CHECK ADD  CONSTRAINT [FK_ShotInfoDeviation_ShotInfo] FOREIGN KEY([SurveyID], [ShotInfoID])
REFERENCES [acquisition].[ShotInfo] ([SurveyID], [ShotInfoID])
GO
ALTER TABLE [acquisition].[ShotInfoDeviation] CHECK CONSTRAINT [FK_ShotInfoDeviation_ShotInfo]
GO

ALTER TABLE [acquisition].[ShotInfoDeviation_prev] DROP CONSTRAINT [DF_ShotInfoDeviation_Created]
GO
ALTER TABLE [acquisition].[ShotInfoDeviation] ADD  CONSTRAINT [DF_ShotInfoDeviation_Created]  DEFAULT (sysutcdatetime()) FOR [Created]
GO



---- 4 -- Move index from prev to new
DROP INDEX [IX_ShotInfoDeviation_ShotInfoID] ON [acquisition].[ShotInfoDeviation_prev]
GO
CREATE NONCLUSTERED INDEX [IX_ShotInfoDeviation_ShotInfoID] ON [acquisition].[ShotInfoDeviation]
(
	[ShotInfoID] ASC
)
INCLUDE([InlineDeviation],[CrosslineDeviation],[RadialDeviation],[Latency]) WITH (STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
GO