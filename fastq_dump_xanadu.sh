#!/bin/bash
#SBATCH --job-name=fastq_dump_xanadu
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -c 8
#SBATCH --partition=general
#SBATCH --mail-type=END
#SBATCH --mail-user=
#SBATCH --mem=50G
#SBATCH -o fastq_dump_xanadu_%j.out
#SBATCH -e fastq_dump_xanadu_%j.err
module load sratoolkit
fastq-dump SRR1964642
mv SRR1964642.fastq LB2A_SRR1964642.fastq
fastq-dump SRR1964643
mv SRR1964643.fastq LB2A_SRR1964643.fastq
fastq-dump SRR1964644
mv SRR1964644.fastq LC2A_SRR1964644.fastq
fastq-dump SRR1964645
mv SRR1964645.fastq LC2A_SRR1964645.fastq
