#this file converts the same files from this tutorial to bam files
samtools view -@ 4 -uhS trim_LB2A_SRR1964642.sam | samtools sort -@ 4 -o sort_trim_LB2A_SRR1964642.bam
samtools view -@ 4 -uhS trim_LB2A_SRR1964643.sam | samtools sort -@ 4 -o sort_trim_LB2A_SRR1964643.bam
samtools view -@ 4 -uhS trim_LC2A_SRR1964644.sam | samtools sort -@ 4 -o sort_trim_LC2A_SRR1964644.bam
samtools view -@ 4 -uhS trim_LC2A_SRR1964645.sam | samtools sort -@ 4 -o sort_trim_LC2A_SRR1964645.bam