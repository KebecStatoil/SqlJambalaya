SELECT
  distinct(sa.ActivityId),
  sa.Description,
  sa.SRiskFactor,
  sa.ActivityNumber,
  TRY_CONVERT(int, ISNULL(sa.Location, 0)) as Location,
  CONVERT(datetime, sa.EarlyStart) as EarlyStart,
  CONVERT(datetime, sa.EarlyFinish) as EarlyFinish,
  sa.CheckListOk,(
    select
      sat2.FieldValue
    from
      om.Planning_ActivityTexts sat2
    where
      sat2.FieldNr = 1
      and sat2.SequenceNumber = sa.ActivityId
      and sat2.NetworkId = 1233
  ) as Vendor,(
    select
      sat3.FieldValue
    from
      om.Planning_ActivityTexts sat3
    where
      sat3.FieldNr = 2
      and sat3.SequenceNumber = sa.ActivityId
      and sat3.NetworkId = 1233
  ) as WorkOrder,(
    select
      sat4.FieldValue
    from
      om.Planning_ActivityTexts sat4
    where
      sat4.FieldNr = 3
      and sat4.SequenceNumber = sa.ActivityId
      and sat4.NetworkId = 1233
  ) as InfoRiskTaskOwner,(
    select
      sat5.FieldValue
    from
      om.Planning_ActivityTexts sat5
    where
      sat5.FieldNr = 5
      and sat5.SequenceNumber = sa.ActivityId
      and sat5.NetworkId = 1233
  ) as InfoRiskOps,
  r.ShortCode as RiskFactor,
  opc.OutlineCodeDescription as Discipline,
  opc.OutlineCodeShortDescription as DisciplineCode,
  ISNULL(sa.ManpowerDec, 0) + ISNULL(sa.N11, 0) as PersonellOnBoard,
  TRY_CONVERT(bit, ISNULL(sa.CoordinationFlag, 0)) as Coord,
  mParent.OutlineCodeDescription as TaskOwner,
  mParent.OutlineCodeShortDescription as TaskOwnerCode,
  sact2.FieldValue as Logistics,
  o.ShortCode as ResponsibleOnshore,
  o2.ShortCode as ResponsiblePlant,
  TRY_CONVERT(bit, ISNULL(sa.HSERiskFlag, 0)) as HSERiskFlag,
  TRY_CONVERT(bit, ISNULL(sa.EconomyRiskFlag, 0)) as EconomyRiskFlag
FROM
  om.Planning_ActivitiesOperationalPlan sa
  left join om.Planning_ActivityTexts sact2 on sa.ActivityId = sact2.SequenceNumber
  and sact2.FieldNr = 19
  and sact2.NetworkId = 23
  left join om.Planning_CodeSets o on sa.SfTaskResponsible = o.InternalId
  and o.ReferenceFieldNumberNetwork = 13
  and o.CodesetId = 1233
  left join om.Planning_CodeSets o2 on sa.SfResponsiblePlant = o2.InternalId
  and o2.ReferenceFieldNumberNetwork = 29
  and o2.CodesetId = 1233
  left join om.Planning_CodeSets r on sa.SRiskFactor = r.InternalId
  and r.ReferenceFieldNumberNetwork = 8
  and r.CodesetId = 1235
  join om.Planning_CodeSets c on c.ShortCode = '1766'
  and c.CodesetId = 1235
  and c.ReferenceFieldNumberNetwork = 2
  left join om.Planning_OutlineCodes m on sa.MOPlanstructure = m.SequenceNumber
  and m.OutlineFieldCode = 1
  and m.CodesetId = 1235
  and m.SequenceNumber not in (5, 57)
  join om.Planning_OutlineCodes mParent on m.OutlineParentSequece = mParent.SequenceNumber
  and mParent.OutlineParentSequece <> 53
  and mParent.OutlineFieldCode = 1
  and mParent.CodesetId = 1235
  left join om.Planning_OutlineCodes opc on sa.MoPlanStructure = opc.SequenceNumber
  and opc.OutlineFieldCode = 1
  and opc.CodesetId = 1235
WHERE
  sa.EarlyFinish >= getdate()
  and sa.NetId = 23
  and sa.sPlant = c.InternalId
  and (
    sa.PercentComplete is null
    or sa.PercentComplete < 100
  )
  and (
    sa.CancelledDate is null
    or sa.CancelledDate >= getDate()
  )