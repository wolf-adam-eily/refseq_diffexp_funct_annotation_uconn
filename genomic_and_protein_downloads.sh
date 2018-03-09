#this file contains the code to download and unzip the yellow croaker protein and genomic fasta and gff files
wget ftp://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/972/845/GCF_000972845.1_L_crocea_1.0/GCF_000972845.1_L_crocea_1.0_protein.faa.gz
gunzip GCF_000972845.1_L_crocea_1.0_protein.faa.gz
wget ftp://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/972/845/GCF_000972845.1_L_crocea_1.0/GCF_000972845.1_L_crocea_1.0_genomic.fna.gz
gunzip GCF_000972845.1_L_crocea_1.0_genomic.fna.gz
wget ftp://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/972/845/GCF_000972845.1_L_crocea_1.0/GCF_000972845.1_L_crocea_1.0_genomic.gff.gz
gunzip GCF_000972845.1_L_crocea_1.0_genomic.gff.gz
