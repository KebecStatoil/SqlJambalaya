-------------------------------------------------------------------------------
ALTER TABLE [Any2Omnia].[Jobs_Datasets_SpecialColumns] DROP CONSTRAINT [FK_Jobs_Datasets_SpecialColumns]
GO

ALTER TABLE [Any2Omnia].[Jobs_Datasets_SpecialColumns]  WITH CHECK ADD  CONSTRAINT [FK_Jobs_Datasets_SpecialColumns] FOREIGN KEY([JobName], [SourceSchema], [SourceTableOrView])
REFERENCES [Any2Omnia].[Jobs_Datasets] ([JobName], [SourceSchema], [SourceTableOrView])
ON DELETE CASCADE
ON UPDATE CASCADE
GO

ALTER TABLE [Any2Omnia].[Jobs_Datasets_SpecialColumns] CHECK CONSTRAINT [FK_Jobs_Datasets_SpecialColumns]
GO
-------------------------------------------------------------------------------
ALTER TABLE [Any2Omnia].[Jobs_Datasets] DROP CONSTRAINT [FK_Jobs_Datasets_Jobs]
GO

ALTER TABLE [Any2Omnia].[Jobs_Datasets]  WITH CHECK ADD  CONSTRAINT [FK_Jobs_Datasets_Jobs] FOREIGN KEY([JobName])
REFERENCES [Any2Omnia].[Jobs] ([JobName])
ON DELETE CASCADE
ON UPDATE CASCADE
GO

ALTER TABLE [Any2Omnia].[Jobs_Datasets] CHECK CONSTRAINT [FK_Jobs_Datasets_Jobs]
GO
