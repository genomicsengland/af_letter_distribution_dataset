#-- gather the required data and generate the distribution list
rm(list = objects())
options(stringsAsFactors = FALSE,
    scipen = 200)
library(wrangleR)
library(tidyverse)
library(DBI)
p <- getprofile(c("indx_con", "mis_con", "aws_pmi"))

indx_con <- dbConnect(RPostgres::Postgres(),
             dbname = "metrics",
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

read_in_xlsx <- function(f) {
    # read in an Excel file into a dataframe
    require(openxlsx)
    d <- read.xlsx(f)
    cat(paste0(f, " - ", nrow(d), "Rx", ncol(d), "C\n"))
    return(d)
}

p <- run_query(dbs_con, "./sql_scripts/participant_data_from_dbs.sql")

# bring in form_type
ft <- run_query(indx_con, "./sql_scripts/form_type.sql")
p <- merge(p, ft, by = "participant_id", all.x = TRUE)

# get each of the different list of PIDS to exclude
p$excl_withdrawals <- p$participant_id %in% run_exclude_query(pmi_con,
                            "./sql_scripts/excl_withdrawals_from_pmi.sql")
p$excl_deceased <- p$participant_id %in% run_exclude_query(pmi_con,
                            "./sql_scripts/excl_deceased_from_pmi.sql")
p$excl_cohorts <- p$participant_id %in% run_exclude_query(mis_con,
                            "./sql_scripts/excl_cohort_members.sql")
p$excl_epilepsy <- p$participant_id %in% run_exclude_query(mis_con,
                            "./sql_scripts/excl_epilepsy_cohort.sql")
p$excl_scottish <- p$participant_id %in% run_exclude_query(mis_con,
                            "./sql_scripts/excl_scottish.sql")
p$excl_adult_on_child <- p$age >= 18 & grepl("c5|r5", p$form_type)

# exclude NT cohort

# aggregate the excludes
p$exclude <- apply(p[, grepl("^excl_", names(p))], 1, any)
stopifnot(all(!is.na(p$exclude)))

# establish the participant IDs which are valid from Tim's line-by-line
lbl <- read_in_xlsx("/Users/simonthompson/scratch/210429 AF Database v1.xlsx")
acceptable_af_status <- c("Include if full family and requested Afs")
valid_lbl <- lbl$Participant[
                    lbl$Can.be.included.in.Afs %in% acceptable_af_status]
p$valid_lbl <- p$participant_id %in% valid_lbl
stopifnot(all(!is.na(p$valid_lbl)))
stopifnot(length(valid_lbl) > 85000)

# bring everything together
p$send_letter <- p$valid_lbl & !p$exclude
stopifnot(all(!is.na(p$send_letter)))

# save dataset
saveRDS(p, "p.rds")

#TODO: need to add step here to remove duplicate NHS numbers
# hceck this
# p <- p[!duplicated(p$nhs_number), ]



