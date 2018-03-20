#!/bin/bash#SBATCH --job-name=fastq_trimming_xanadu
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -c 8
#SBATCH --partition=general
#SBATCH --mail-type=END
#SBATCH --mail-user=
#SBATCH --mem=50G
#SBATCH -o fastq_trimming_xanadu_%j.out
#SBATCH -e fastq_trimming_xanadu_%j.err
module load sickle
sickle se -f LB2A_SRR1964642.fastq -t sanger -o trimmed_LB2A_SRR1964642.fastq -q 30 -l 50
sickle se -f LB2A_SRR1964643.fastq -t sanger -o trimmed_LB2A_SRR1964643.fastq -q 30 -l 50
sickle se -f LC2A_SRR1964644.fastq -t sanger -o trimmed_LC2A_SRR1964644.fastq -q 30 -l 50
sickle se -f LC2A_SRR1964645.fastq -t sanger -o trimmed_LC2A_SRR1964645.fastq -q 30 -l 50
