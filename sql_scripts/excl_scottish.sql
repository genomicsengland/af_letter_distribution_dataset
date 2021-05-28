-- query to get all the scottish participant IDs
select p.participant_id
from cdm.participant p 
where left(p.participant_id, 3) in ('125', '226')
;
