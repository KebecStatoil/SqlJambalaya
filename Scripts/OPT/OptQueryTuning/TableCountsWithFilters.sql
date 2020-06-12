

select 'workorder' [table & filter], count(*) [count] from workorder w with (nolock)
union all

select 'Workorderuserstatus' [table & filter], count(*) [count] from Workorderuserstatus wss with (nolock)
union all
select 'Workorderuserstatus where convert(nvarchar(1), Inact) not like ''X''' [table & filter], count(*) [count] from Workorderuserstatus wss with (nolock) where convert(nvarchar(1), Inact) not like 'X'
union all
select 'Workorderuserstatus where txt04 = ''PLAN''' [table & filter], count(*) [count] from Workorderuserstatus wss with (nolock) where txt04 = 'PLAN'
union all

select 'Workorderoperation' [table & filter], count(*) [count] from Workorderoperation wo with (nolock)
union all
select 'Workorderoperation where fsedd > getdate()' [table & filter], count(*) [count] from Workorderoperation wo with (nolock) where wo.fsedd > getdate()


