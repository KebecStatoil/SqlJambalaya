
select type, count(*)
from survey.Events
group by type

select type, seq_num, sailline_num, count(*)
from survey.Events
group by type, seq_num, sailline_num
order by count(*) desc, seq_num, sailline_num, type

select type, seq_num, sailline_num, count(*)
from survey.Events
group by type, seq_num, sailline_num
order by count(*) desc, seq_num, sailline_num, type

select * from survey.Events where type = 'event.qc.p111'