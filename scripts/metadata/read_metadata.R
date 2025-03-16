library(dplyr)
library(stringr)

setwd("/Users/amber/SARS-CoV-2/trials")

df1 <- read.csv('template.csv', sep = ",", check.names = FALSE)
df1$`Primer set` <- gsub("^V5.3.2", "Artic V5.3.2", df1$`Primer set`)
df1$Comments[df1$Comments == ''] <- 'None'

df2 <- read.csv('nextclade.tsv', sep = "\t", check.names = FALSE)
df2$Site <- gsub("_S.*$", "", df2$Site)

df3 <- read.csv('summary_variants_metrics_mqc.csv', sep = ",", check.names = FALSE)
df3 <- df3 %>% filter(!str_detect(Sample, '_1|_2'))

df4 <- read.csv('input_lineages.csv', sep = ",", check.names = FALSE)
df4 <- df4 %>% select(-Site)
df4 <- df4[, colSums(df4) != 0]
df4 <- df4[, colSums(df4) >= 0.01]

df5 <- read.csv('heatmap_data2plot.csv', sep = ",", check.names = FALSE)
df5 <- as.matrix(df5)
df5 <- df5[, colSums(df5) != 0]
df5 <- as.data.frame(t(df5))
df5$total <- round(rowSums(df5, na.rm = TRUE), 0)

df6 <- read.csv('samtools.tsv', sep = "\t", check.names = FALSE)
df6 <- as.matrix(df6)
df6 <- as.data.frame(t(df6))
df6$avg <- rowMeans(df6, na.rm = TRUE)

df7 <- df1 %>%
  left_join(df2, by = "Site ID") %>%
  left_join(df3, by = "Site ID") %>%
  left_join(df4, by = "Site ID") %>%
  left_join(df5, by = "Site ID") %>%
  left_join(df6, by = "Site ID") 
colnames(df7) <- gsub("Frequencies", "Frequencies of reads with VOC mutation", colnames(df7))

write.table(df7, file = "metadata.tsv", sep = "\t", row.names = FALSE)

