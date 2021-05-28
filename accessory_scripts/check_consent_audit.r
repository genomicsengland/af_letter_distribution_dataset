#-- script to check that those with more than one valid form have got a good completion date
rm(list = objects())
options(stringsAsFactors = FALSE,
    scipen = 200)
library(wrangleR)
library(tidyverse)
library(DBI)
p <- getprofile("indx_con")
indx_con <- dbConnect(RPostgres::Postgres(),
             dbname = "metrics",
             host     = p$host,
             port     = p$port,
             user     = p$user,
             password = p$password)

all_rows <- dbGetQuery(indx_con, "
    select v.participant_id
        ,m.completion_date
        ,m.form_type
    from consent_audit.vw_participant_md5 v 
    join consent_audit.md5 m 
        on v.md5 = m.md5
    where m.dismissed_id is null
;")

d <- all_rows %>% group_by(participant_id) %>%
    summarise(n_forms = n(),
        valid_completion_date = all(completion_date > '1000-01-01'),
        fts = paste(form_type, collapse = ';'))
