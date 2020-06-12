SET
  ANSI_PADDING ON
GO
  /****** Object:  Index [IX_WORKORDEROPERATION_FSEDD]    Script Date: 06.11.2018 15:13:44 ******/
  CREATE NONCLUSTERED INDEX [IX_WORKORDEROPERATION_FSEDD] ON [dbo].[WorkOrderOperation] (
    [Fsedd] ASC
  ) INCLUDE (
    [Vornr],
    [Arbpl],
    [Ltxa1],
    [Arbei],
    [Ismnw],
    [Fsavd],
    [Aufnr_fk]
  ) WITH (
    STATISTICS_NORECOMPUTE = OFF,
    DROP_EXISTING = OFF,
    ONLINE = OFF
  ) ON [PRIMARY]
GO