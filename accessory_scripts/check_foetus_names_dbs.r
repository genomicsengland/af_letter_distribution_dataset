#-- check whether there are any foetal names in the dbs return
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

dbs <- dbGetQuery(dbs_con, "
select local_pid as participant_id
    ,trace_result_new_nhs_number as nhs_number
    ,returned_first_forename as forename
    ,returned_surname as surname
    ,returned_date_of_birth as dob
    ,returned_current_central_register_posting
from dbs.batch_trace_return
;")

foetus_name_pattern <- "foetus|fetus|baby|unborn|birth|born|child|toddler|foetal|fetal|infant|f/o|twin"
dbs$foetus_name <- grepl(foetus_name_pattern, tolower(dbs$forename))

dbs[dbs$foetus_name, ]

nl_data <- readRDS("/Users/simonthompson/Documents/Projects/short-projects/archive/newsletter-investigation-mar-2019/aggregated-dataset-20190417.rds")
nl_foetus_name_pids <- nl_data$participant_id[nl_data$foetus_name]
dbs[dbs$participant_id %in% nl_foetus_name_pids,]
