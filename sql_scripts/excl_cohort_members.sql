with cohorts as (
    select *
    from (values 
('ALL (acutelymphoblastic leukaemia)', 'ALL', true),
('Breast Cancer Now', 'BCN', true),
('CLL ', 'CLL', true),
('MAJIC', 'MAJ', true),
('NIHR350 (BioResource/BRIDGE)', 'NB3', true),
('OCCAMS Oesophageal', 'EOC', true),
('OxPloreD', 'TBC', false),
('Partner Personalised Breast Cancer ', 'TBC', false),
('PATHOS Oropharyngeal ', 'ORP', true),
('PEACE (never submitted)', 'TBC', false),
('Phazar', 'PHA', true),
('Rare Disease NEQAS ', 'NEQ', true),
('Tessa Jowell BRAIN MATRIX ', 'TBC', false),
('Tracer X Lung', 'TRX', true),
('Tracer x Renal', 'TRR', true),
('TRACERx Melanoma', 'TRM', true)
    ) as t (cohort_name, ods_code, exclude)
)
select p.participant_id
    ,p.registered_at_ldp_ods_code
    ,c.clinic_sample_collected_at_ldp_ods_code
from cdm.vw_participant_level_data p
join cdm.vw_clinic_sample_level_data c 
    on p.participant_sk = c.participant_sk
join cohorts co
    on p.registered_at_ldp_ods_code = co.ods_code or 
    c.clinic_sample_collected_at_ldp_ods_code = co.ods_code
where co.exclude = true
;

