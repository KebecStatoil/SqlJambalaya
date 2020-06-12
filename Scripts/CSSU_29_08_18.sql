SELECT distinct(sa.ActivityId),sa.Description,sa.SRiskFactor,sa.ActivityNumber,TRY_CONVERT(int,ISNULL(sa.Location, 0)) as Location, convert(datetime,sa.EarlyStart) as EarlyStart,convert(datetime,sa.EarlyFinish) as EarlyFinish,sa.CheckListOk 
                ,(select sat2.FieldValue from  cssu.vw_SafranActivityTextsOSS sat2 where sat2.FieldNr =1 and sat2.ActivityId = sa.ActivityId) as Vendor 
    ,(select sat3.FieldValue from  cssu.vw_SafranActivityTextsOSS sat3 where sat3.FieldNr =2 and sat3.ActivityId = sa.ActivityId) as WorkOrder
    ,(select sat4.FieldValue from  cssu.vw_SafranActivityTextsOSS sat4 where sat4.FieldNr =3 and sat4.ActivityId = sa.ActivityId) as InfoRisk
    ,(select sat5.FieldValue from  cssu.vw_SafranActivityTextsOSS sat5 where sat5.FieldNr =5 and sat5.ActivityId = sa.ActivityId) as InfoRiskOps,r.Short as RiskFactor,opc.Description as Discipline,ISNULL(sact.ManpowerDec, 0)  + ISNULL(sact.N11, 0)  as PersonellOnBoard  
    ,TRY_CONVERT(bit,ISNULL(sa.CoordinationFlag, 0)) as Coord ,mParent.Description as TaskOwner 
    ,sact2.FieldValue as Logistics, o.Short as ResponsibleOnshore, o2.Short as ResponsiblePlant 
    
    FROM cssu.vw_SafranActivitiesOpsPlan sa
    left join  cssu.vw_SafranActivityTextsOSS sat on sa.ActivityId = sat.ActivityId
    left join cssu.vw_safranActivities sact on sa.ActivityId = sact.ActivityId 
    left join cssu.vw_SafranActivityTextsOSS sact2 on sa.ActivityId = sact2.ActivityId and sact2.FieldNr =19 
    left join safran.Codeset o on sa.SfTaskResponsible = o.Code and o.RField_Nr = 13 and o.Config_Id = 1233 
    left join safran.Codeset o2 on sa.SfResponsiblePlant = o2.Code and o2.RField_Nr = 29 and o2.Config_Id = 1233 
    left join safran.Codeset r on sact.SRiskFactor = r.Code and r.rField_nr = 8 and r.config_id = 123
	join safran.Codeset c on c.rfield_nr = 2 and c.short = '1766' and c.config_id = 1235
    left join safran.outline_codes m on sa.MOPlanstructure = m.Seq and m.oc_Field = 1 and m.Config_Id = 1235 and m.Seq not in (5,57) 
    join  safran.outline_codes mParent on m.Parent_seq = mParent.Seq and mParent.Parent_seq <> 53 and  mParent.Oc_Field = 1 and mParent.Config_Id = 1235 
    left join  safran.outline_codes opc on sa.MoPlanStructure = opc.Seq 
    where sa.EarlyFinish >= getdate() and opc.oc_field = 1 and opc.Config_Id = 1235 and sa.NetId = 23 and sa.sPlant = c.CODE
    and (sact.PercentComplete is null or sact.PercentComplete < 100) and (sact.CancelledDate is null or sact.CancelledDate >= getDate())
