for i in $(cat filenames.txt); do

    # Kraken2 analysis
    /home/kraken2 -db /media/Disk1/bacteria --threads 24 --output ${i}.bacteria.tsv --report ${i}.report.bacteria.tsv unmapped_reads.fastq
    python /home/KrakenTools/kreport2krona.py --no-intermediate-ranks -r ${i}.report.bacteria.tsv -o ${i}.bacteria.krona
    ktImportText ${i}.bacteria.krona -o ${i}.bacteria.krona.html

    # Bracken analysis
    /home/bracken -d /media/bacteria -i ${i}.report.bacteria.tsv -o ${i}.bracken -l S -t 0.01

    # Kraken2 with minimizer options
    /home/kraken2 -db /media/Disk1/bacteria --threads 24 --report-minimizer-data --output ${i}.bacteria.tsv --report ${i}.report.min.bacteria.tsv ${i}.fastq
    cut -f1-3,6-8 ${i}.report.min.bacteria.tsv > ${i}.report.min.bacteria.tsv

done

