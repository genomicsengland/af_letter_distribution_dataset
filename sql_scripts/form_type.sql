-- query to get the best guess of form_type for each participant
with rank_forms as (
    -- get latest form_type per participant
    select v.participant_id
        ,m.form_type
        ,row_number() over(partition by v.participant_id order by m.completion_date desc) as rank
    from consent_audit.vw_participant_md5 v 
    join consent_audit.md5 m 
        on v.md5 = m.md5
    where m.dismissed_id is null
),
all_matched as (
    -- get whether participant has all forms matched to them or not
    select v.participant_id
        ,bool_and(v.participant_match is not distinct from 'y' and m.completion_date is not null and m.completion_date > '1000-01-01') as all_matched
    from consent_audit.vw_participant_md5 v 
    join consent_audit.md5 m 
        on v.md5 = m.md5
    group by v.participant_id, m.dismissed_id
    having m.dismissed_id is null
)
select rf.participant_id
    ,rf.form_type
from rank_forms rf 
join all_matched am
    on rf.participant_id = am.participant_id
where rf.rank = 1 and am.all_matched = true
;
