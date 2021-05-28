#-- try and refine the search to identify protected addresses
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

address_grepl <- function(df = dbs, cols = c("line_1", "line_2", "line_3", "line_4", "line_5"), pattern) {
    res <- apply(df[,colnames(df) %in% cols], 2, function(x) {grepl(pattern, x)})
    v <- apply(res, 1, any)
    return(v)
}

dbs <- dbGetQuery(dbs_con, "
select local_pid as participant_id
    ,trace_result_new_nhs_number as nhs_number
    ,returned_first_forename as forename
    ,returned_surname as surname
    ,returned_date_of_birth as dob
    ,lower(returned_address_line_1) as line_1
    ,lower(returned_address_line_2) as line_2
    ,lower(returned_address_line_3) as line_3
    ,lower(returned_address_line_4) as line_4
    ,lower(returned_address_line_5) as line_5
from dbs.batch_trace_return
;")

dbs$poss_prison <- address_grepl(pattern = "hmp|prison")
dbs$institution <- address_grepl(pattern = "children")
dbs$other <- address_grepl(pattern = "protected|witness")
