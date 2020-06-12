SET
  ANSI_PADDING ON
GO
  /****** Object:  Index [IX_WORKORDERUSERSTATUS_TXT04]    Script Date: 06.11.2018 15:22:02 ******/
  CREATE NONCLUSTERED INDEX [IX_WORKORDERUSERSTATUS_TXT04] ON [dbo].[WorkOrderUserStatus] (
    [Txt04] ASC
  ) INCLUDE (
    [Aufnr_fk],
	[Udate],
	[Inact]
  ) WITH (
    STATISTICS_NORECOMPUTE = OFF,
    DROP_EXISTING = OFF,
    ONLINE = OFF
  ) ON [PRIMARY]
GO