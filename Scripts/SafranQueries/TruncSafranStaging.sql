select
	query = 'truncate table [' + s.name + '].[' + t.name + ']',
	s.name,
	t.name
from
	sys.objects t
	join sys.schemas s
		on s.schema_id = t.schema_id
where
	s.name = 'safran'
	and t.name like '%[_]staging[_]%'
	and t.type = 'u'