#this file will generate count files on the alignments, removing each alignment file after processing as to save disk space
htseq-count -s no -r pos -t gene -i Dbxref -f bam sort_trim_LB2A_SRR1964642.bam GCF_000972845.1_L_crocea_1.0_genomic.gff/data > LB2A_SRR1964642.counts
rm sort_trim_LB2A_SRR1964642.bam
htseq-count -s no -r pos -t gene -i Dbxref -f bam sort_trim_LB2A_SRR1964643.bam GCF_000972845.1_L_crocea_1.0_genomic.gff/data > LB2A_SRR1964643.counts
rm sort_trim_LB2A_SRR1964643.bam
htseq-count -s no -r pos -t gene -i Dbxref -f bam sort_trim_LC2A_SRR1964644.bam GCF_000972845.1_L_crocea_1.0_genomic.gff/data > LC2A_SRR1964644.counts
rm sort_trim_LC2A_SRR1964644.bam
htseq-count -s no -r pos -t gene -i Dbxref -f bam sort_trim_LC2A_SRR1964645.bam GCF_000972845.1_L_crocea_1.0_genomic.gff/data > LC2A_SRR1964645.counts
rm sort_trim_LC2A_SRR1964645.bam