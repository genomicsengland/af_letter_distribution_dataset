-- query to get all deceased participants from PMI
select sp.identifier_value as participant_id, it_c.concept_code, dg_c.concept_code, de.value_datetime, ds_c.concept_code
from pmi.study_participant sp 
join pmi.data_group dg 
    on sp.identifier_value = dg.identifier_value and sp.identifier_type_cid = dg.identifier_type_cid
join pmi.data_element de 
    on dg.uid = de.data_group_uid
join pmi.concept it_c
    on sp.identifier_type_cid = it_c.uid 
join pmi.concept dg_c 
    on dg.data_group_type_cid = dg_c.uid
join pmi.concept de_c 
    on de.field_type_cid = de_c.uid
join pmi.concept ds_c 
    on dg.data_source_cid = ds_c.uid
where it_c.concept_code = '100k_participant_id' and 
    dg_c.concept_code = 'date_of_death' and 
    de_c.concept_code = 'date_of_death' and 
    de.value_datetime is not null and 
    dg.stale = false and 
    dg.blacklisted = false
;
