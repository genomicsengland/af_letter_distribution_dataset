select *
from (values 
    ('116001352', 'completed deceased form but not coming through as deceased in PMI or DBS'),
    ('124000092', 'completed deceased form but not coming through as deceased in PMI or DBS'),
    ('115009971', 'completed deceased form but not coming through as deceased in PMI or DBS'),
    ('112005595', 'not confident in match made by DBS'),
    ('115001573', 'not confident in match made by DBS'),
    ('115008571', 'not confident in match made by DBS')
) as t (participant_id, reason)
;

