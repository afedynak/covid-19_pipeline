library(dplyr)
library(stringr)

setwd("/Users/afedynak/SARS-CoV-2/")

df1 <- read.csv('checksums.csv', sep=",", check.names=FALSE)

df2 <- data.frame(
  select(df1, as.name("Site ID")), 
  select(df1, as.name("Note")), 
  check.names=FALSE
)

df2 <- data.frame(
  select(df1, as.name("Site ID")), 
  check.names=FALSE
)
colnames(df2)[2] <- "InterOp file checksum"

df3 <- data.frame(
  select(df1, as.name("Site ID")), 
  check.names=FALSE
)
df3$seq_method <- 'Generate FastQ'
colnames(df3)[colnames(df3) == 'folder'] <- 'Run folder name'
colnames(df3)[colnames(df3) == 'seq_method'] <- 'Raw sequence data processing method'

df4 <- read.csv('R1.txt', sep=" ", check.names=FALSE, header=FALSE)
df4$Site <- gsub("_S.*$", "", df4$filename_r1)
df4 <- select(df4, c('Site ID', 'filename_r1', 'check_r1'))

df5 <- read.csv('R2.txt', sep=" ", check.names=FALSE, header=FALSE)
df5$Site <- gsub("_S.*$", "", df5$filename_r2)
df5 <- select(df5, c('Site ID', 'filename_r2', 'check_r2'))

df6 <- df2 %>%
  left_join(df3, by = "Site ID") %>%
  left_join(df4, by = "Site ID") %>%
  left_join(df5, by = "Site ID")

df6$Site <- gsub("^GTATRIT", "At20", df6$Site)
df6$date <- as.Date(df6$date, format = "%d-%b-%Y")
df6[is.na(df6)] <- ""

df6 <- df6 %>%
  filter(!grepl('Not sequenced', df6$note)) %>%
  filter(!grepl('Negative after ARTIC PCR', df6$note)) %>%
  filter(!grepl('next week', df6$note))

write.table(df6, file="metadata.csv", sep=",", row.names=FALSE)

