#-- script to do some QC on Tim's line by line data
rm(list = objects())
options(stringsAsFactors = FALSE,
    scipen = 200)
library(wrangleR)

read_in_xlsx <- function(f) {
    # read in an Excel file into a dataframe
    require(openxlsx)
    d <- read.xlsx(f)
    cat(paste0(f, " - ", nrow(d), "Rx", ncol(d), "C\n"))
    return(d)
}

lbl <- read_in_xlsx("/Users/simonthompson/scratch/210429 AF Database v1.xlsx")

# check that we don't have different status for same participant
d <- unique(lbl[, c("Participant", "Can.be.included.in.Afs")])
table(duplicated(d$Participant))
