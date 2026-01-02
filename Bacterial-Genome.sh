#!/bin/bash
# STEP 1 - QC:
fastqc /home/lion/Bacteria/ERR072246_1.fastq.gz /home/lion/Bacteria/ERR072246_2.fastq.gz  -o /home/lion/Bacteria

#Trimming
fastp -i /home/lion/Bacteria/ERR072246_1.fastq.gz\
  -I /home/lion/Bacteria/ERR072246_2.fastq.gz\
  -o /home/lion/Bacteria/Trimmed_ERR072246_1.fastq.gz\
  -O /home/lion/Bacteria/Trimmed_ERR072246_2.fastq.gz\
  -h /home/lion/Bacteria/fastp_report.html\
  -j /home/lion/Bacteria/fastp_report.json\
  -w 4
  
# Quality check after trimming:
fastqc /home/lion/Bacteria/Trimmed_ERR072246_1.fastq.gz /home/lion/Bacteria/Trimmed_ERR072246_2.fastq.gz -o /home/lion/Bacteria

#Multi QC:
multiqc /home/lion/Bacteria -o /home/lion/Bacteria

# Step 2 - Genome Assembly(with spades_env):
spades.py --isolate \
 -1 /home/lion/Bacteria/ERR072246_1.fastq.gz \
 -2 /home/lion/Bacteria/ERR072246_2.fastq.gz \
 -o /home/lion/Bacteria/spades_out


grep '>' /home/lion/Bacteria/spades_out/contigs.fasta |wc -l

# Step 3 - Genome Annotate(with prokka_env):
prokka --prefix sty --locustag sty --cpus 4 --kingdom Bacteria /home/lion/Bacteria/spades_out/contigs.fasta

#Antimicrobial Resistance gene(with AMR_env):
abricate /home/lion/Bacteria/spades_out/contigs.fasta --db ncbi --csv > /home/lion/Bacteria/AMR/AMR.csv




