#-- check that everyone on deceased form is also down as deceased in PMI
rm(list = objects())
options(stringsAsFactors = FALSE,
    scipen = 200)
library(wrangleR)
library(tidyverse)
library(DBI)
p <- getprofile(c("indx_con", "aws_pmi"))
indx_con <- dbConnect(RPostgres::Postgres(),
             dbname = "metrics",
             host     = p$indx_con$host,
             port     = p$indx_con$port,
             user     = p$indx_con$user,
             password = p$indx_con$password)
dbs_con <- dbConnect(RPostgres::Postgres(),
             dbname = "cohorts",
             host     = p$indx_con$host,
             port     = p$indx_con$port,
             user     = p$indx_con$user,
             password = p$indx_con$password)
pmi_con <- dbConnect(RPostgres::Postgres(),
             dbname = "trifacta",
             host     = p$aws_pmi$host,
             port     = p$aws_pmi$port,
             user     = p$aws_pmi$user,
             password = p$aws_pmi$password)

run_query <- function(conn, f) {
    # run the contents of sql file - f- on a given db connection - conn
    require(DBI)
    q <- trimws(readLines(f))
    # remove lines starting with -- and any comments after #
    q <- gsub("^--.*$", "",
        gsub("#.*$", "", q)
    )
    d <- dbGetQuery(conn, paste(q, collapse = " "))
    cat(paste0(f, ' - ', nrow(d), 'Rx', ncol(d), 'C\n'))
    return(d)
}

run_exclude_query <- function(conn, f) {
    # run the contents of the query and then extend the exclude list
    # with returned participants
    pids <- run_query(conn, f)$participant_id
    stopifnot(length(pids) > 0)
    return(pids)
}

deceased_forms <- dbGetQuery(indx_con, "
select v.participant_id, m.form_type, m.md5
from consent_audit.vw_participant_md5 v 
join consent_audit.md5 m 
    on m.md5 = v.md5
where m.form_type similar to 'c6%|r6%|c8%|r8%' and 
m.dismissed_id is null and v.participant_match = 'y'
;")

dbs_returned <- run_query(dbs_con, "./sql_scripts/participant_data_from_dbs.sql")

deceased_pmi <- run_exclude_query(pmi_con, "./sql_scripts/excl_deceased_from_pmi.sql")

deceased_forms$in_pmi <- deceased_forms$participant_id %in% deceased_pmi
deceased_forms$in_dbs <- deceased_forms$participant_id %in% dbs_returned$participant_id

dtv(deceased_forms)

# On JUn 10th, gives three participants who have completed deceased form but not
# deceased in PMI and returned by DBS.
# 116001352 - form doesn't seem to match participant
# 124000092 - form matches participant, date of death is recorded on form
# 115009971 - form matches participant, date of death is recorded on form
