#-- check that all the withdrawals in PMI are in Arjumand's tracker
rm(list = objects())
options(stringsAsFactors = FALSE,
    scipen = 200)
library(wrangleR)
library(tidyverse)
library(DBI)
p <- getprofile("aws_pmi")
pmi_con <- dbConnect(RPostgres::Postgres(),
             dbname = "trifacta",
             host     = p$host,
             port     = p$port,
             user     = p$user,
             password = p$password)

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

wt <- read_in_xlsx('/Users/simonthompson/Downloads/100K Withdrawal Requests _ Action Tracker.xlsx')
wt_pids <- trimws(unique(wt$Participant.Identifiers.ID))

pmi <- run_exclude_query(pmi_con, "./sql_scripts/excl_withdrawals_from_pmi.sql")

table(wt_pids %in% pmi)
