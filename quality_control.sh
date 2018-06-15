#!/bin/bash
#SBATCH --job-name=quality_control
#SBATCH --mail-user=
#SBATCH --mail-type=ALL
#SBATCH -n 1
#SBATCH -N 1
#SBATCH -c 16
#SBATCH --mem=120G
#SBATCH -o quality_control_%j.out
#SBATCH -e quality_control_%j.err
#SBATCH --partition=general

mkdir /home/CAM/$USER/tmp/
export TMPDIR=/home/CAM/$USER/tmp/

module load fastqc
module load MultiQC

fastqc trimmed_LB2A_SRR1964642.fastq
fastqc trimmed_LB2A_SRR1964643.fastq
fastqc trimmed_LC2A_SRR1964644.fastq
fastqc trimmed_LC2A_SRR1964645.fastq
multiqc -f -n trimmed trimmed*
