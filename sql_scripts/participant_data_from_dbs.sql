-- query to get participant details from dbs
select local_pid as participant_id
    ,trace_result_new_nhs_number as nhs_number
    ,returned_date_of_birth as dob
    ,extract(year from age(now() + interval '1 month', returned_date_of_birth)) as age
    ,returned_first_forename as forename
    ,returned_surname as surname
    ,returned_address_line_1 as address_1
    ,returned_address_line_2 as address_2
    ,returned_address_line_3 as address_3
    ,returned_address_line_4 as address_4
    ,returned_address_line_5 as address_5
    ,returned_postcode as postcode
from dbs.batch_trace_return
where record_type in (20,30,33,40)
;
