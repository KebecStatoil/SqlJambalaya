select
	'select * from '+s.name+'.'+o.name+''
from
	sys.objects o
	join sys.schemas s
	on s.schema_id = o.schema_id
where
	s.name in ('security', 'security_v')
	and o.name like '%'
	and type in ('u', 'v')