for i in $(cat filenames.txt); do
 	
    seqtk seq -a ${i}.fastq > ${i}.fasta

    minimap2 -c -t 8 /media/Disk1/amr_db/megares_db/megares_v3.00/megares_database_v3.00.fasta ${i}.unmapped.fastq > ${i}.amr_mutation.megares.paf
	minimap2 -c -t 8 /media/Disk1/amr_db/arg_annot_db/ARG-ANNOT_NT_V6_July2019.fasta ${i}.unmapped.fastq > ${i}.amr.argannot.paf
	minimap2 -c -t 8 /media/Disk1/amr_db/card_db/nucleotide_fasta_protein_homolog_model.fasta ${i}.unmapped.fastq > ${i}.amr.card_homolog.paf
	minimap2 -c -t 8 /media/Disk1/amr_db/card_db/nucleotide_fasta_protein_knockout_model.fasta ${i}.unmapped.fastq > ${i}.amr.card_knockout.paf
	minimap2 -c -t 8 /media/Disk1/amr_db/resfinder_db/resfinder_db/all.fsa ${i}.unmapped.fastq > ${i}.amr.resfinder.paf

done
