-- query to get all the scottish participant IDs
-- 125 SCO RD 
-- 226 SCO CA 
-- 123 WAL RD 
-- 224 WAL CA 
-- 124 NIR RD 
-- 225 NIR CA 
select p.participant_id
from cdm.participant p 
where left(p.participant_id, 3) in (
    '125', 
    '226', 
    '123', 
    '224', 
    '124', 
    '225'  
)
;
