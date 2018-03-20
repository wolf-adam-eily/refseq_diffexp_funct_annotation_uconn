#!/bin/bash
#SBATCH --job-name=genome_indexing_and_alignment_xanadu
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -c 8
#SBATCH --partition=general
#SBATCH --mail-type=END
#SBATCH --mail-user=
#SBATCH --mem=50G
#SBATCH -o genome_indexing_and_alignment_xanadu_%j.out
#SBATCH -e genome_indexing_and_alignment_xanadu_%j.err
module load hisat-build
module load hisat2
hisat2-build GCF_000972845.1_L_crocea_1.0_genomic.fna L_crocea -p 4
hisat2 -p 8 --dta -x L_crocea -U trimmed_LB2A_SRR1964642.fastq -S trimmed_LB2A_SRR1964642.sam
hisat2 -p 8 --dta -x L_crocea -U trimmed_LB2A_SRR1964643.fastq -S trimmed_LB2A_SRR1964643.sam
hisat2 -p 8 --dta -x L_crocea -U trimmed_LC2A_SRR1964644.fastq -S trimmed_LC2A_SRR1964644.sam
hisat2 -p 8 --dta -x L_crocea -U trimmed_LC2A_SRR1964645.fastq -S trimmed_LC2A_SRR1964645.sam
