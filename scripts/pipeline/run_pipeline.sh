#!/bin/bash
# Author: Amber Fedynak
# Date created: 
# Date modified:

BAM_DIR='/Users/afedynak/Covid-19/pipeline/'

NXF_VER=23.10.1 nextflow run nf-core/viralrecon \
--input ${BAM_DIR}/samplesheet.csv \
--platform illumina \
--protocol amplicon \
--primer_set artic \
--primer_set_version 5.3.2 \
--genome 'MN908947.3' \
--fasta ref_genome/MN908947.3.fa \
--skip_assembly \
--skip_markduplicates \
--skip_fastp \
--variant_caller ivar \
-profile docker \
--max_cpus 24 \
--max_memory 200GB \
--schema_ignore_params 'genomes,primer_set_version' \
-r 2.5

samtools depth -a -H -o ${BAM_DIR}/samtools_depth.tsv --reference MN908947.3. -f bam_files.txt

for i in $(cat sequences.txt); do
    alcov find_lineages ${BAM_DIR}/${i}.ivar_trim.sorted.bam alcov_lineages.txt 
done

for i in $(cat mutations.txt); do
    for j in $(cat sequences.txt); do
        alcov find_mutants ${BAM_DIR}/${j}.ivar_trim.sorted.bam ${i}.txt
    done
done



