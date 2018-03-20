#!/bin/bash
#SBATCH --job-name=htseq_count_xanadu
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -c 8
#SBATCH --partition=general
#SBATCH --mail-type=END
#SBATCH --mail-user=
#SBATCH --mem=50G
#SBATCH -o htseq_count_xanadu_%j.out
#SBATCH -e htseq_count_xanadu_%j.err
module load htseq-count
htseq-count -s no -r pos -t gene -i Dbxref -f bam sort_trim_LB2A_SRR1964642.bam GCF_000972845.1_L_crocea_1.0_genomic.gff > LB2A_SRR1964642.counts
htseq-count -s no -r pos -t gene -i Dbxref -f bam sort_trim_LB2A_SRR1964643.bam GCF_000972845.1_L_crocea_1.0_genomic.gff > LB2A_SRR1964643.counts
htseq-count -s no -r pos -t gene -i Dbxref -f bam sort_trim_LC2A_SRR1964644.bam GCF_000972845.1_L_crocea_1.0_genomic.gff > LC2A_SRR1964644.counts
htseq-count -s no -r pos -t gene -i Dbxref -f bam sort_trim_LC2A_SRR1964645.bam GCF_000972845.1_L_crocea_1.0_genomic.gff > LC2A_SRR1964645.counts
