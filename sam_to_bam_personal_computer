#this file will convert our tutorial sam files to bam, removing each one after processing
samtools view -@ 4 -uhS trim_LB2A_SRR1964642.sam | samtools sort -@ 4 -o sort_trim_LB2A_SRR1964642.bam
rm trimmed_LB2A_SRR1964642.sam
samtools view -@ 4 -uhS trim_LB2A_SRR1964643.sam | samtools sort -@ 4 -o sort_trim_LB2A_SRR1964643.bam
rm trimmed_LB2A_SRR1964643.sam
samtools view -@ 4 -uhS trim_LC2A_SRR1964644.sam | samtools sort -@ 4 -o sort_trim_LC2A_SRR1964644.bam
rm trimmed_LC2A_SRR1964644.sam
samtools view -@ 4 -uhS trim_LC2A_SRR1964645.sam | samtools sort -@ 4 -o sort_trim_LC2A_SRR1964645.bam
rm trimmed_LC2A_SRR1964645.sam

