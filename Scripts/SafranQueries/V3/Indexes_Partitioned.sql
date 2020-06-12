/****** Object:  Index [IX_ACTIVITIES_NETID_R2]    Script Date: 01.11.2019 10:52:52 ******/
CREATE NONCLUSTERED INDEX [IX_ACTIVITIES_NETID_R2] ON [safran].[ACTIVITIES] ([NET_ID] ASC, [R2] ASC) WITH (
  STATISTICS_NORECOMPUTE = OFF,
  DROP_EXISTING = OFF,
  ONLINE = OFF
) ON PS_SOURCE_DATABASE ([META_SourceDatabase])
GO
  /****** Object:  Index [IX_ACTIVITIES_PlantID]    Script Date: 01.11.2019 10:52:52 ******/
  CREATE NONCLUSTERED INDEX [IX_ACTIVITIES_PlantID] ON [safran].[ACTIVITIES] ([R2] ASC) WITH (
    STATISTICS_NORECOMPUTE = OFF,
    DROP_EXISTING = OFF,
    ONLINE = OFF
  ) ON PS_SOURCE_DATABASE ([META_SourceDatabase])
GO
  /****** Object:  Index [IX_ACTIVITIES_SEQ_EF_CANCELLED]    Script Date: 01.11.2019 10:52:52 ******/
  CREATE NONCLUSTERED INDEX [IX_ACTIVITIES_SEQ_EF_CANCELLED] ON [safran].[ACTIVITIES] ([SEQ] ASC, [EF] ASC, [CANCELLED] ASC) INCLUDE ([PC], [R8], [N3], [N11]) WITH (
    STATISTICS_NORECOMPUTE = OFF,
    DROP_EXISTING = OFF,
    ONLINE = OFF
  ) ON PS_SOURCE_DATABASE ([META_SourceDatabase])
GO
  /****** Object:  Index [IX_ACTIVITIES_NETID_R2]    Script Date: 01.11.2019 10:52:52 ******/
  CREATE NONCLUSTERED INDEX [IX_ACTIVITIES_NETID_R2] ON [safran_staging].[ACTIVITIES] ([NET_ID] ASC, [R2] ASC) WITH (
    STATISTICS_NORECOMPUTE = OFF,
    DROP_EXISTING = OFF,
    ONLINE = OFF
  ) ON PS_SOURCE_DATABASE ([META_SourceDatabase])
GO
  /****** Object:  Index [IX_ACTIVITIES_PlantID]    Script Date: 01.11.2019 10:52:52 ******/
  CREATE NONCLUSTERED INDEX [IX_ACTIVITIES_PlantID] ON [safran_staging].[ACTIVITIES] ([R2] ASC) WITH (
    STATISTICS_NORECOMPUTE = OFF,
    DROP_EXISTING = OFF,
    ONLINE = OFF
  ) ON PS_SOURCE_DATABASE ([META_SourceDatabase])
GO
  /****** Object:  Index [IX_ACTIVITIES_SEQ_EF_CANCELLED]    Script Date: 01.11.2019 10:52:52 ******/
  CREATE NONCLUSTERED INDEX [IX_ACTIVITIES_SEQ_EF_CANCELLED] ON [safran_staging].[ACTIVITIES] ([SEQ] ASC, [EF] ASC, [CANCELLED] ASC) INCLUDE ([PC], [R8], [N3], [N11]) WITH (
    STATISTICS_NORECOMPUTE = OFF,
    DROP_EXISTING = OFF,
    ONLINE = OFF
  ) ON PS_SOURCE_DATABASE ([META_SourceDatabase])
GO
  -------------------------------------------------------------------------------
  -------------------------------------------------------------------------------
  -------------------------------------------------------------------------------
  /****** Object:  Index [IX_CODESET_CONFIG_ID_CODE_SHORT]    Script Date: 01.11.2019 10:52:52 ******/
  CREATE NONCLUSTERED INDEX [IX_CODESET_CONFIG_ID_CODE_SHORT] ON [safran].[CODESET] ([CONFIG_ID] ASC, [CODE] ASC, [SHORT] ASC) WITH (
    STATISTICS_NORECOMPUTE = OFF,
    DROP_EXISTING = OFF,
    ONLINE = OFF
  ) ON PS_SOURCE_DATABASE ([META_SourceDatabase])
GO
SET
  ANSI_PADDING ON
GO
  /****** Object:  Index [IX_CODESET_CONFIG_ID_CODE_SHORT]    Script Date: 01.11.2019 10:52:52 ******/
  CREATE NONCLUSTERED INDEX [IX_CODESET_CONFIG_ID_CODE_SHORT] ON [safran_staging].[CODESET] ([CONFIG_ID] ASC, [CODE] ASC, [SHORT] ASC) WITH (
    STATISTICS_NORECOMPUTE = OFF,
    DROP_EXISTING = OFF,
    ONLINE = OFF
  ) ON PS_SOURCE_DATABASE ([META_SourceDatabase])
GO
SET
  ANSI_PADDING ON
GO
  -------------------------------------------------------------------------------
  -------------------------------------------------------------------------------
  -------------------------------------------------------------------------------
  CREATE NONCLUSTERED INDEX [IX_ACTIVITY_TEXTS_SEQ_NET_ID_FIELD_NR] ON [safran].[ACTIVITY_TEXTS] ([SEQ], [NET_ID], [FIELD_NR]) INCLUDE ([FIELD_VALUE]) WITH (
    STATISTICS_NORECOMPUTE = OFF,
    DROP_EXISTING = OFF,
    ONLINE = OFF
  ) ON PS_SOURCE_DATABASE ([META_SourceDatabase])
GO
  CREATE NONCLUSTERED INDEX [IX_ACTIVITY_TEXTS_SEQ_NET_ID_FIELD_NR] ON [safran_staging].[ACTIVITY_TEXTS] ([SEQ], [NET_ID], [FIELD_NR]) INCLUDE ([FIELD_VALUE]) WITH (
    STATISTICS_NORECOMPUTE = OFF,
    DROP_EXISTING = OFF,
    ONLINE = OFF
  ) ON PS_SOURCE_DATABASE ([META_SourceDatabase])
GO