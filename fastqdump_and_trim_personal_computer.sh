#this file will download the fastqs and trim them, removing each one after processing so as to save disk memory
fastq-dump SRR1964642
sickle se -f SRR1964642.fastq -t sanger -o trimmed_LB2A_SRR1964642.fastq -q 30 -l 50
rm SRR1964642.fastq
fastq-dump SRR1964643
sickle se -f SRR1964643.fastq -t sanger -o trimmed_LB2A_SRR1964643.fastq -q 30 -l 50
rm SRR1964643.fastq
fastq-dump SRR1964644
sickle se -f SRR1964644.fastq -t sanger -o trimmed_LC2A_SRR1964644.fastq -q 30 -l 50
rm SRR1964644.fastq
fastq-dump SRR1964645
sickle se -f SRR1964645.fastq -t sanger -o trimmed_LC2A_SRR1964645.fastq -q 30 -l 50
rm SRR1964645.fastq
