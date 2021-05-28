#-- check that duplicate participants are genuine duplicates
rm(list = objects())
options(stringsAsFactors = FALSE,
    scipen = 200)
library(wrangleR)
library(tidyverse)
library(DBI)
p <- getprofile("indx_con")
metrics_con <- dbConnect(RPostgres::Postgres(),
             dbname = "metrics",
             host     = p$host,
             port     = p$port,
             user     = p$user,
             password = p$password)
dbs_con <- dbConnect(RPostgres::Postgres(),
             dbname = "cohorts",
             host     = p$host,
             port     = p$port,
             user     = p$user,
             password = p$password)

dups <- dbGetQuery(metrics_con, "
select participant_id as participant_id_x,
    duplicated_participant_id as participant_id_y
from dict.vw_duplicate_participants
;")

dbs <- dbGetQuery(dbs_con, "
select local_pid as participant_id
    ,trace_result_new_nhs_number as nhs_number
    ,returned_first_forename as forename
    ,returned_surname as surname
    ,returned_date_of_birth as dob
    ,record_type in (20,30,33,40) as traced
from dbs.batch_trace_return
;")

table(duplicated(dbs$participant_id))
table(duplicated(dbs$nhs_number[dbs$nhs_number != ""]))

d <- merge(dups, dbs, by.x = "participant_id_x", by.y = "participant_id",
all.x = TRUE)
d <- merge(d, dbs, by.x = "participant_id_y", by.y = "participant_id",
all.x = TRUE, suffixes = c("_x", "_y"))

d$mismatch <- (d$nhs_number_x != d$nhs_number_y) & d$traced_x & d$traced_y

dtv(d[d$mismatch,])
