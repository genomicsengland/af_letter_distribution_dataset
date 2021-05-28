-- query to get all full or partial withdrawals from PMI
select sp.identifier_value as participant_id, it_c.concept_code, dg_c.concept_code, ds_c.concept_code, fv_c.concept_code
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
join pmi.concept fv_c 
    on de.value_cid = fv_c.uid
join pmi.concept ds_c 
    on dg.data_source_cid = ds_c.uid
where it_c.concept_code = '100k_participant_id' and 
    dg_c.concept_code = '100k_withdrawal' and 
    de_c.concept_code = '100k_withdrawal_option' and 
    fv_c.concept_code in ('full_withdrawal', 'partial_withdrawal') and
    dg.stale = false and 
    dg.blacklisted = false
;
