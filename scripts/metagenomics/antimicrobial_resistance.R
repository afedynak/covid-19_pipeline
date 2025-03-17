library(dplyr)
library(stringr)
library(pafr)
library(ggplot2)
library(ggpubr)
library(taxonomizr)

setwd("AMR/PHO_Covid_regions")
my_file <- 'As.card.paf'
my_df <- read.csv(my_file, sep="\t", check.names=FALSE)

colnames(my_df) <- c("qid", "qlen", "qstart", "qend", "pos_neg", 
                     "sid", "slen", "sstart", "send", "num_match", 
                     "num_bases", "quality")
write.table(my_df, file = "As.card.tsv", sep="\t", row.names=TRUE)

# Read PAF file and generate plots
ali <- read_paf("As.card.paf")

ggplot(ali, aes(alen, de)) + 
  geom_point(alpha=0.6, colour="steelblue", size=2) + 
  scale_x_continuous("Alignment length (bp)") +
  scale_y_continuous("Per base divergence") + 
  theme_pubr()

ggplot(ali, aes(alen, de)) + 
  geom_point(alpha=0.6, colour="steelblue", size=2) + 
  scale_x_continuous("Alignment length (kb)", labels = function(x) x / 1e3) + 
  scale_y_continuous("Per base divergence (gap compressed)") + 
  theme_pubr()

# Filter primary alignments and plot coverage
prim_alignment <- filter_secondary_alignments(ali)
dotplot(prim_alignment)

long_ali <- subset(ali, alen > 150 & mapq > 40)
plot_coverage(long_ali)
plot_coverage(long_ali, target=FALSE)
plot_coverage(long_ali, fill='qname') + scale_fill_brewer(palette="Set1")

# Taxonomy assignment for accessions
taxaId <- accessionToTaxa(c("LN847353.1", "AL079352.3"), "accessionTaxa.sql")
print(taxaId)
getTaxonomy(taxaId, 'accessionTaxa.sql')

taxaId <- accessionToTaxa(c("NR_113696.1", "NR_125536.1"), "accessionTaxa.sql")
print(taxaId)
getTaxonomy(taxaId, 'accessionTaxa.sql')

# Filter BLAST results and save
blastf <- subset(blastf, pid >= 70 & cov >= 80 & evalue <= 0.001)
write.table(blastf, file = "blastx_uniref50_filtered.tsv", sep="\t", row.names=TRUE)

sub_data <- subset(mydata, age >= 20 | age < 10, select=c(ID, Weight))
subset <- blastf[, 5:70] > 7
blastf <- blastf[, which(colSums(lineages) >= 0.01)]
