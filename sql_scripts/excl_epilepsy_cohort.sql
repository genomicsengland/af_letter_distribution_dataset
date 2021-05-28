-- query to return the participants who are part of the epilepsy cohort
-- that cohort doesn't seem to have had it's own ODS code
select p.participant_id
    ,p.consent_form_id
    ,p.information_sheet_id
from cdm.vw_participant_level_data p 
where p.consent_form_id ilike '%epilepsy%' or
p.information_sheet_id ilike '%epilepsy%'
;
