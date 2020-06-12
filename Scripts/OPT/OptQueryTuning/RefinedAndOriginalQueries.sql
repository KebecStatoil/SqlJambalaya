
/*
 *  Refactored Query
 */
with cte_Workorderuserstatus as (
	select
		us.Aufnr_fk,
		max(us.udate) max_udate
	from
		workOrderUserStatus us with (nolock)
	where
		Inact <> 'X'
		and txt04 = 'PLAN'
	group by
		us.Aufnr_fk    
)
, cte_Workorderoperation as (
	select
		wo.aufnr_fk,
		wo.Vornr,
		wo.Ltxa1,
		wo.Arbei,
		wo.Ismnw,
		wo.Arbpl,
		wo.fsavd,
		wo.fsedd
	from
		Workorderoperation wo with (nolock)
	where
		wo.fsedd > getdate()
)
select
  w.aufnr as OrderNum,
  w.arbpl as MainWorkCenter,
  w.vaplztxt as MainWorkCenterDescription,
  w.Auart as OrderType,
  w.revnr as Revision,
  wo.Vornr as Activity,
  w.Tplnr as FunctionalLocation,
  wo.Ltxa1 as OperationShortDescription,
  w.Eqfnr as SortField,
  wo.Arbei as Work,
  wo.Ismnw as ActualWork,
  w.iwerk,
  w.ktext as Description,
  w.Gstrp as OrderStartDate,
  w.gltrp as OrderFinishDate,
  w.beber as System,
  wo.Arbpl as WorkCenter,
  w.Stort as Location,
  wo.fsavd as earlystart,
  wo.fsedd as earlyfinish,
  w.Ingpr as PlannerGroup
from
  workorder w with (nolock)
  join cte_Workorderuserstatus wss with (nolock) on w.aufnr = wss.aufnr_fk
  join cte_Workorderoperation wo with (nolock) on w.aufnr = wo.aufnr_fk
where
  w.Auart != 'PM04'
  and w.iwerk = 1766

/*
 *  Original Query
 */
select
  distinct w.aufnr as OrderNum,
  w.arbpl as MainWorkCenter,
  w.vaplztxt as MainWorkCenterDescription,
  w.Auart as OrderType,
  w.revnr as Revision,
  wo.Vornr as Activity,
  w.Tplnr as FunctionalLocation,
  wo.Ltxa1 as OperationShortDescription,
  w.Eqfnr as SortField,
  wo.Arbei as Work,
  wo.Ismnw as ActualWork,
  w.iwerk,
  ktext as Description,
  w.Gstrp as OrderStartDate,
  gltrp as OrderFinishDate,
  w.beber as System,
  wo.Arbpl as WorkCenter,
  w.Stort as Location,
  wo.fsavd as earlystart,
  wo.fsedd as earlyfinish,
  w.Ingpr as PlannerGroup
from
  workorder w
  left join Workorderuserstatus wss on w.aufnr = wss.aufnr_fk
  left join Workorderoperation wo on w.aufnr = wo.aufnr_fk
where
  wss.Udate = (
    select
      max(us.udate)
    from
      workOrderUserStatus us
    where
      us.Aufnr_fk = wss.aufnr_fk
      and convert(nvarchar(1), Inact) not like 'X'
      and txt04 = 'PLAN'
  )
  and wo.fsedd > getdate()
  and w.Auart != 'PM04'
  and w.iwerk = 1766
