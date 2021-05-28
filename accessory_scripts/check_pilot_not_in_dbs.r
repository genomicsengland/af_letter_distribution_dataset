#-- check that there aren't any pilot cases in dbs return, i.e. check all
# participant IDs are 9 digits long
rm(list = objects())
options(stringsAsFactors = FALSE,
    scipen = 200)
library(wrangleR)
library(tidyverse)
library(DBI)
p <- getprofile("indx_con")

dbs_con <- dbConnect(RPostgres::Postgres(),
             dbname = "cohorts",
             host     = p$host,
             port     = p$port,
             user     = p$user,
             password = p$password)

pid_lengths <- dbGetQuery(dbs_con, "
    select distinct length(local_pid) as pid_length
    from dbs.batch_trace_return
;")

stopifnot(nrow(pid_lengths) == 1 & pid_lengths$pid_length[1] == 9)

prefixes <- dbGetQuery(dbs_con, "
    select distinct left(local_pid, 3) as prefix
    from dbs.batch_trace_return
    where record_type in (20,30,33,40)
;")

prefixes
