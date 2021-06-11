#-- check what the non-nhs_number matches in DBS look like compared to pmi details
rm(list = objects())
options(stringsAsFactors = FALSE,
    scipen = 200)
library(wrangleR)
library(tidyverse)
library(DBI)
p <- getprofile(c("mis_con", "indx_con"))
dbs_con <- dbConnect(RPostgres::Postgres(),
             dbname = "cohorts",
             host     = p$indx_con$host,
             port     = p$indx_con$port,
             user     = p$indx_con$user,
             password = p$indx_con$password)
mis_con <- dbConnect(RPostgres::Postgres(),
             dbname = "gel_mi",
             host     = p$mis_con$host,
             port     = p$mis_con$port,
             user     = p$mis_con$user,
             password = p$mis_con$password)

dbs <- dbGetQuery(dbs_con, "
select local_pid as participant_id
    ,trace_result_new_nhs_number as dbs_nhs_number
    ,upper(returned_first_forename) as dbs_forename
    ,upper(returned_surname) as dbs_surname
    ,returned_date_of_birth as dbs_dob
from dbs.batch_trace_return
where record_type in (20, 40, 33)
;")
dbs$dbs_name_dob <- paste0(dbs$dbs_forename, dbs$dbs_surname, dbs$dbs_dob)

mis <- dbGetQuery(mis_con, "
select p.participant_id
    ,p.nhs_number as mis_nhs_number
    ,upper(p.forenames) as mis_forename
    ,upper(p.surname) as mis_surname
    ,p.date_of_birth as mis_dob
from cdm.vw_participant_level_data p
;")
mis$mis_name_dob <- paste0(mis$mis_forename, mis$mis_surname, mis$mis_dob)

d <- merge(dbs, mis, by = "participant_id", all.x = T)
d$exact_match <- d$dbs_name_dob == d$mis_name_dob
dtv(d)
