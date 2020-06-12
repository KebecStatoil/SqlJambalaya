
select distinct w.*
from
  [dbo].[WorkOrder] w
  join [dbo].[WorkOrderOperation] wo
    on wo.aufnr_fk = w.aufnr
where
  Iwerk = 1766
  and fsavd <= '2018-10-25'
  and fsedd >= '2018-10-05'

select distinct wo.*
from
  [dbo].[WorkOrder] w
  join [dbo].[WorkOrderOperation] wo
    on wo.aufnr_fk = w.aufnr
where
  Iwerk = 1766
  and fsavd <= '2018-10-25'
  and fsedd >= '2018-10-05'
