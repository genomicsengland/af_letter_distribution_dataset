select *
from (values 
    ('124000092', 'completed deceased form but not coming through as deceased in PMI or DBS'),
    ('115009971', 'completed deceased form but not coming through as deceased in PMI or DBS')
) as t (participant_id, reason)
;

