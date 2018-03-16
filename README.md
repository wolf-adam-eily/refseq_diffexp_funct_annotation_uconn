# RNA-Seq_genome_assembly_and_annotation
This repository is a usable, publicly available genome annotation and assembly tutorial.
This tutorial assumes the user is using a Linux system (or Ubuntu 17.0.1 or higher). Headers 1-6 may be performed on a local computer or server with the appropriate scripts. However, header 7 must be performed on the Xanadu cluster.

<div id="toc_container">
<p class="toc_title">Contents</p>
<ul class="toc_list">
<li><a href="#First_Point_Header">1 Overview and programs install</>
<li><a href="#Second_Point_Header">2 Accessing the data using sra-toolkit</a></li>
<li><a href="#Third_Point_Header">3 Quality control using sickle</a></li>
<li><a href="#Fourth_Point_Header">4 Aligning reads to a genome using hisat2</a></li>
<li><a href="#Fifth_Point_Header">5 Generating total read counts from alignment using htseq-count</a></li>
<li><a href="#Sixth_Point_Header">6 Pairwise differential expression with counts in R with DESeq2</a></li>
<li><a href="#EnTAP">7 EnTAP: Functional Annotation for Genomes</a></li>
 <li><a href="#Integration">8 Integrating the DE Results with the Annotation Results</a></li>
<li><a href="#Citation">Citations</a></li>
</ul>
</div>

<h2 id="First_Point_Header">Overview and programs install</h2>
Marine RNA-Seq
In this tutorial we will be analyzing 2 liver samples from the large yellow croaker (Larimichthys crocea) from the NCBI BioProject (https://www.ncbi.nlm.nih.gov/bioproject/280841) 
Experimental Design: 

Liver mRNA profiles large yellow croaker (Larimichthys crocea) species are sampled during various conditions namely, control group (LB2A), thermal stress group (LC2A), cold stress group (LA2A) and 21-day fasting group (LF1A) were generated by RNA-seq, using Illumina HiSeq 2000. 

We will use the control group (LB2A) and the thermal stress group (LC2A)j

If performing headers 1-6 on a personal computer, continue onward. 

If performing headers 1-6 on the Xanadu cluster, it is important that after connecting via SSH the directory is set to

<pre style="color: silver; background: black;">cd /home/CAM/$your.user.name</pre> 

before proceeding. Your home directory contains 10TB of storage and will not pollute the capacities of other users on the cluster. 

The workflow may be cloned into the appropriate directory using the terminal command:
<pre style="color: silver; background: black;">$git clone https://github.com/wolf-adam-eily/RNA-Seq_genome_assembly_and_annotation.git
$cd RNA-Seq_genome_assembly_and_annotation
$ls  </pre>

If performing headers 1-6 on a local computer, it is recommended the command (in the cloned folder): 
<pre style="color: silver; background: black;">sh -e programs_installation
sh -e r_3.4.3_install
sudo Rscript r_packages_install </pre> 
is run to install <i><b>all</b></i> of the needed software for headers 1-6. If apt-get is not installed on your system, please install that first.
<h2 id="Second_Point_Header">Accessing the data using sra-toolkit </h2>

We will be downloading our data from the sequence-read-archives (SRA), a comprehensive collection of sequenced genetic data submitted to the NCBI by experimenters. The beauty of the SRA is the ease with which genetic data becomes accessible to any scientist with an internet connection, available for download in a variety of formats. Each run in the SRA has a unique identifier. The run may be downloaded using a module of software called the "sratoolkit" and its unique identifier. There are a variety of commands in the sratoolkit, which I invite you to investigate for yourself at https://www.ncbi.nlm.nih.gov/books/NBK158900/.

The data may be accessed at the following web page: 
https://www.ncbi.nlm.nih.gov/bioproject/28084<br>
LB2A : SRR1964642, SRR1964643<br>
LC2A : SRR1964644, SRR1964645<br>

and downloaded with:

<b>Xanadu</b>
<pre style="color: silver; background: black;">
module load sratoolkit
fastq-dump SRR1964642
fastq-dump SRR1964643</pre>

<b>locally</b>
<pre style="color: silver; background: black;">fastq-dump SRR1964642
fastq-dump SRR1964643</pre>

Unless authorized, you cannot add any packages or software to Xanadu. However, you can see all of the software pre-loaded with the following command:
<pre style="color: silver; background: black;">module avail</pre>

Because of this, it is important to manually load modules to be used in the Xanadu bash. For those on a local computer, the "programs_installation" file installs the software globally and in the executable path, removing any need for loading the module in the terminal.

Now we must repeat the fastq-dump command for SRR1964644 and SRR1964645 samples, or alternatively run either of the following commands (change directory to the RNA-Seq_genome_assembly_and_annotation folder first): 

<pre style="color: silver; background: black;">sh -e fastqdump_xanadu</pre>
or
<pre style="color: silver; background: black;">sh -e fastqdump_and_trim_local</pre>

The first command will simply download the four fastq files to your Xanadu home directory. If proceeding through this headers 1-6 on a personal computer or laptop without access to Xanadu, run the second command. This command will combine the fastq-dump with the next step, quality control: downloading a fastq file, trimming that file, and the removing the untrimmed file. This is recommended if disk space is an issue (the four files combined consume about 75GB of disk space).
Once download is completed, the files were renamed according to the samples for easy identification using the "mv" command. If the first command was run, you should see the following files in your folder: 
<pre style="color: silver; background: black;">|-- LB2A_SRR1964642.fastq
|-- LB2A_SRR1964643.fastq
|-- LC2A_SRR1964644.fastq
|-- LC2A_SRR1964645.fastq</pre>

<h2 id="Third_Point_Header">Quality control using sickle</h2>

Sickle performs quality control on illumina paired-end and single-end short read data using a sliding window. As the window slides along the fastq file, the average score of all the reads contained in the window is calculated. Should the average window score fall beneath a set threshold, sickle determines the reads responsible and removes them from the run. For more information you can check out https://github.com/najoshi/sickle/blob/master/README.md. 

The following command can be applied to each of the four read fastq files:

<b>Xanadu</b>
<pre style="color: silver; background: black;">module load sickle
sickle se -f LB2A_SRR1964642.fastq -t sanger -o trimmed_LB2A_SRR1964642.fastq -q 30 -l 50</pre>

<b>locally</b>
<pre style="color: silver; background: black;">sickle se -f LB2A_SRR1964642.fastq -t sanger -o trimmed_LB2A_SRR1964642.fastq -q 30 -l 50</pre></pre>

After this point the tutorial will not specify Xanadu or local in its coding excerpts, but assume that the module has been loaded. However, still use the shell scripts for your setups, as they remain differentiated.

The options we use;
<pre style="color: silver; background: black;">Options: 
se    Single end reads
-f    input file name
-t    scoring platform (sanger, illumina, etc.)
-o    output file name
-q    scan the read with the sliding window, cutting when the average quality per base drops below 30 
-l    Removes any reads shorter than 50</pre>

This must be repeated for all four files. If the previous header was run locally, this step has already been performed. Those on Xanadu can run the following shell script to perform the steps:
<pre style="color: silver; background: black;">sh -e fastq_trimming_xanadu</pre>
 
Following the sickle run, the resulting file structure will look as follows:
<pre style="color: silver; background: black;">
|-- trimmed_LB2A_SRR1964642.fastq
|-- trimmed_LB2A_SRR1964643.fastq
|-- trimmed_LC2A_SRR1964644.fastq
|-- trimmed_LC2A_SRR1964645.fastq</pre>
Examine the .out file generated during the run.  It will provide a summary of the quality control process.
<pre style="color: silver; background: black;">Input Reads: 26424138 Surviving: 21799606 (82.50%) Dropped: 4624532 (17.50%)</pre>

<h2 id="Fourth_Point_Header">Aligning reads to a genome using hisat2</h2>
Building an Index:<br>
HISAT2 is a fast and sensitive aligner for mapping next generation sequencing reads against a reference genome. You can find out more about HISAT2 at https://ccb.jhu.edu/software/hisat2/manual.shtml.

In order to map the reads to a reference genome, first we must download the reference genome! Then we must make an index file. We will be downloading the reference genome (https://www.ncbi.nlm.nih.gov/genome/12197) from the ncbi database, using the wget command.
<pre style="color: silver; background: black;">wget ftp://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/972/845/GCF_000972845.1_L_crocea_1.0/GCF_000972845.1_L_crocea_1.0_genomic.fna.gz
gunzip GCF_000972845.1_L_crocea_1.0_genomic.fna.gz</pre>
If you feel to be prudent, you can install the genomic, transcriptomic, and proteomic fastas (yes, all will be used in this tutorial, it is advised you download them now) with the command:
<pre style="color: silver; background: black;">sh -e genomic_and_protein_downloads</pre>
We will use the hisat2-build option to make a HISAT index file for the genome. It will create a set of files with the suffix .ht2, these files together build the index. What is an index and why is it helpful? Genome indexing is the same as indexing a tome, like an encyclopedia. It is much easier to locate information in the vastness of an encyclopedia when you consult the index, which is ordered in an easily navigatable way with pointers to the location of the information you seek within the encylopedia. Genome indexing is thus the structuring of a genome such that it is ordered in an easily navigatable way with pointers to where we can find whichever gene is being aligned. The genome index along with the trimmed fasta files are all you need to align the reads to the reference genome (the build command is included in the genome_indexing_and_alignment* files, so it is not necessary to run now).
<pre style="color: silver; background: black;">hisat2-build -p 4 GCF_000972845.1_L_crocea_1.0_genomic.fna L_crocea

Usage: hisat2-build [options] <reference_in> <bt2_index_base>
reference_in                comma-separated list of files with ref sequences
hisat2_index_base           write ht2 data to files with this dir/basename

Options:
    -p                      number of threads</pre>

After running the command, the following files will be generated as part of the index.  To refer to the index for  mapping the reads in the next step, you will use the file prefix, which in this case is: L_crocea
<pre style="color: silver; background: black;">|-- GCF_000972845.1_L_crocea_1.0_genomic.fna
|-- hisat2_index.sh
|-- L_crocea.1.ht2
|-- L_crocea.2.ht2
|-- L_crocea.3.ht2
|-- L_crocea.4.ht2
|-- L_crocea.5.ht2
|-- L_crocea.6.ht2
|-- L_crocea.7.ht2
|-- L_crocea.8.ht2</pre>

Aligning the reads using HISAT2:<br>
Once we have created the index, the next step is to align the reads with HISAT2 using the index we created. The program will give the output in SAM format. We will not delve into the intricacies of the SAM format here, but it is recommended to peruse https://en.wikipedia.org/wiki/SAM_(file_format) to garner a greater understanding. We align our reads with the following code:
<pre style="color: silver; background: black;">hisat2 -p 4 --dta -x ../index/L_crocea -q ../quality_control/trim_LB2A_SRR1964642.fastq -S trim_LB2A_SRR1964642.sam

Usage: hisat2 [options]* -x <ht2-idx>  [-S <sam>]
-x <ht2-idx>        path to the Index-filename-prefix (minus trailing .X.ht2) 

Options:
-q                  query input files are FASTQ .fq/.fastq (default)
-p                  number threads
--dta               reports alignments tailored for transcript assemblers</pre>

The above must be repeated for all the files. You may run:
<pre style="color: silver; background: black;">sh -e genome_indexing_and_alignment_xanadu</pre>
or
<pre style="color: silver; background: black;">sh -e genome_indexing_and_alignment_local</pre>

to process all four files appropriate for your setup.

Once the mapping have been completed, the file structure is as follows:
<pre style="color: silver; background: black;">
|-- mapping.sh
|-- trim_LB2A_SRR1964642.sam
|-- trim_LB2A_SRR1964643.sam
|-- trim_LC2A_SRR1964644.sam
|-- trim_LC2A_SRR1964645.sam</pre>

When HISAT2 completes its run, it will summarize each of it’s alignments, and it is written to the standard error file, which can be found in the same folder once the run is completed.

<pre style="color: silver; background: black;">
21799606 reads; of these:
  21799606 (100.00%) were unpaired; of these:
    1678851 (7.70%) aligned 0 times
    15828295 (72.61%) aligned exactly 1 time
    4292460 (19.69%) aligned >1 times
92.30% overall alignment rate</pre>

The sam file is quite dense and must be stored in a more easily tractable format for future programs. Therefore, we convert the sam file to bam, the binary of the sam file, with the following command:
<pre style="color: silver; background: black;">samtools view -@ 4 -uhS trim_LB2A_SRR1964642.sam | samtools sort -@ 4 - sort_trim_LB2A_SRR1964642

Usage: samtools [command] [options] in.sam

Command:
view     prints all alignments in the specified input alignment file (in SAM, BAM, or CRAM format) to standard output in SAM format 

Options:
-h      Include the header in the output<br.
-S      Indicate the input was in SAM format
-u      Output uncompressed BAM. This option saves time spent on compression/decompression and is thus preferred when the output is piped to another samtools command
-@      Number of processors</pre>

Usage: samtools [command] [-o out.bam]

Command:
sort    Sort alignments by leftmost coordinates

-o      Write the final sorted output to FILE, rather than to standard output.</pre>

All samples may be run by executing the following command:
<pre style="color: silver; background: black;">sh -e sam_to_bam_xanadu</pre>
or
<pre style="color: silver; background: black;">sh -e sam_to_bam_local</pre>
appropriate for your set-up.

Once the conversion is done you will have the following files in the directory.
<pre style="color: silver; background: black;">|-- sort_trim_LB2A_SRR1964642.bam
|-- sort_trim_LB2A_SRR1964643.bam
|-- sort_trim_LC2A_SRR1964644.bam
|-- sort_trim_LC2A_SRR1964645.bam</pre>

<h2 id="Fifth_Point_Header">Generating total read counts from alignent using htseq-count</h2>
Now we will be using the htseq-count program to count the reads which is mapping to the genome. The thought behind htseq-count is quite intuitive, enumerating matching alignments into a "counts" file. However, this belies the complexity of alignment counting. For those still interested in the inner workings of htseq-count, you can visit http://htseq.readthedocs.io/en/master/count.html. htseq-count is used in the following manner:

<pre style="color: silver; background: black;">htseq-count -s no -r pos -t gene -i Dbxref -f bam ../mapping/sort_trim_LB2A_SRR1964642.bam GCF_000972845.1_L_crocea_1.0_genomic.gff > LB2A_SRR1964642.counts
Usage: htseq-count [options] alignment_file gff_file</pre>

This script takes an alignment file in SAM/BAM format and a feature file in
GFF format and calculates for each feature the number of reads mapping to it.
<pre style="color: silver; background: black;">Options:
  -f SAMTYPE, --format=SAMTYPE
                        type of  data, either 'sam' or 'bam'
                        (default: sam)
  -r ORDER, --order=ORDER
                        'pos' or 'name'. Sorting order of
                        (default: name). Paired-end sequencing data must be
                        sorted either by position or by read name, and the
                        sorting order must be specified. Ignored for single-
                        end data.
  -s STRANDED, --stranded=STRANDED
                        whether the data is from a strand-specific assay.
                        Specify 'yes', 'no', or 'reverse' (default: yes).
                        'reverse' means 'yes' with reversed strand
                        interpretation
  -t FEATURETYPE, --type=FEATURETYPE
                        feature type (3rd column in GFF file) to be used, all
                        features of other type are ignored (default, suitable
                        for Ensembl GTF files: exon)
  -i IDATTR, --idattr=IDATTR
                        GFF attribute to be used as feature ID (default,
                        suitable for Ensembl GTF files: gene_id)</pre>

 
The above command should be repeated for all other BAM files as well. You can process all the BAM files with the command:
<pre style="color: silver; background: black;">sh -e htseq_count_xanadu</pre>
or
<pre style="color: silver; background: black;">sh -e htseq_count_local</pre>
appropriate for your set-up.
Once all the bam files have been counted, we will be having the following files in the directory.<br
<pre style="color: silver; background: black;">|-- sort_trim_LB2A_SRR1964642.counts
|-- sort_trim_LB2A_SRR1964643.counts
|-- sort_trim_LC2A_SRR1964644.counts
|-- sort_trim_LC2A_SRR1964645.counts</pre>

<h2 id="Sixth_Point_Header">Pairwise differential expression with counts in R using DESeq2</h2>
This part of the tutorial <i>must</i> be run locally. 

To identify differentially expressed genes, we will transfer the count files generated by HTSeq onto our local machine. We will use the DESeq2 package within Bioconductor in R to process to provide normalization and statistical analysis of differences among our two sample groups. This R is executed in RStudio for R version 3.4.3 (if the r_installation file did not properly install R 3.4.3 you may visit https://linode.com/docs/development/r/how-to-install-r-on-ubuntu-and-debian/ to troubleshoot. Note that Bioconductor will not run on any previous version of R in Linux, so it is imperative that you successfully install R 3.4.3):
<pre style="color: silver; background: black;">library("DESeq2")

&num; Set the working directory
directory <- "~/RNA-Seq_genome_assembly_and_annotation"
setwd(directory)
list.files(directory)

&num; Set the prefix for each output file name
outputPrefix <- "Croaker_DESeq2"

sampleFiles<- c("sort_trim_LB2A_SRR1964642.counts","sort_trim_LB2A_SRR1964643.counts",
                "sort_trim_LC2A_SRR1964644.counts", "sort_trim_LC2A_SRR1964645.counts")

&num; Liver mRNA profiles of 
&num; control group (LB2A), * 
&num; thermal stress group (LC2A), *
sampleNames <- c("LB2A_1","LB2A_2","LC2A_1","LC2A_2")
sampleCondition <- c("control","control","treated","treated")

sampleTable <- data.frame(sampleName = sampleNames,
                          fileName = sampleFiles,
                          condition = sampleCondition)

ddsHTSeq <- DESeqDataSetFromHTSeqCount(sampleTable = sampleTable,
                                       directory = directory,
                                       design = ~ condition)

&num;By default, R will choose a reference level for factors based on alphabetical order. 
&num; To chose the reference we can use: factor()
treatments <- c("control","treated")
ddsHTSeq$condition
&num;Setting the factor levels
colData(ddsHTSeq)$condition <- factor(colData(ddsHTSeq)$condition,
                                      levels = treatments)
ddsHTSeq$condition

&num; Differential expression analysis
&num;differential expression analysis steps are wrapped into a single function, DESeq()
dds <- DESeq(ddsHTSeq)
&num; restuls talbe will be generated using results() which will include:
&num;  log2 fold changes, p values and adjusted p values
res <- results(dds)
res
summary(res)
&num; filter results by p value
res= subset(res, padj<0.05)

&num; order results by padj value (most significant to least)
res <- res[order(res$padj),]
&num; should see DataFrame of baseMean, log2Foldchange, stat, pval, padj

&num; save data results and normalized reads to csv
resdata <- merge(as.data.frame(res), 
                 as.data.frame(counts(dds,normalized =TRUE)), 
                 by = 'row.names', sort = FALSE)
names(resdata)[1] <- 'gene'

write.csv(resdata, file = paste0(outputPrefix, "-results-with-normalized.csv"))

&num; send normalized counts to tab delimited file for GSEA, etc.
write.table(as.data.frame(counts(dds),normalized=T), 
            file = paste0(outputPrefix, "_normalized_counts.txt"), sep = '\t')

&num; produce DataFrame of results of statistical tests
mcols(res, use.names = T)
write.csv(as.data.frame(mcols(res, use.name = T)),
          file = paste0(outputPrefix, "-test-conditions.csv"))

&num; replacing outlier value with estimated value as predicted by distrubution using
&num; "trimmed mean" approach. recommended if you have several replicates per treatment
&num; DESeq2 will automatically do this if you have 7 or more replicates

ddsClean <- replaceOutliersWithTrimmedMean(dds)
ddsClean <- DESeq(ddsClean)
temp_ddsClean <- ddsClean
tab <- table(initial = results(dds)$padj < 0.05,
             cleaned = results(ddsClean)$padj < 0.05)
addmargins(tab)
write.csv(as.data.frame(tab),file = paste0(outputPrefix, "-replaceoutliers.csv"))
resClean <- results(ddsClean)
resClean = subset(res, padj<0.05)
resClean <- resClean[order(resClean$padj),]
write.csv(as.data.frame(resClean),file = paste0(outputPrefix, "-replaceoutliers-results.csv"))

&num;&num;&num;&num;&num;&num;&num;&num;&num;&num;&num;&num;&num;&num;&num;&num;&num;&num;&num;&num;&num;&num;&num;&num;&num;&num;&num;&num;&num;&num;&num;&num;&num;&num;&num;&num;&num;&num;&num;&num;&num;&num;&num;&num;&num;&num;&num;&num;&num;&num;&num;&num;&num;&num;&num;&num;&num;&num;&num;&num;&num;&num;&num;&num;&num;&num;&num;&num;&num;&num;&num;&num;&num;&num;&num;&num;&num;&num;&num;&num;&num;&num;&num;&num;
&num; Exploratory data analysis of RNAseq data with DESeq2
&num;
&num; these next R scripts are for a variety of visualization, QC and other plots to
&num; get a sense of what the RNAseq data looks like based on DESEq2 analysis
&num;
&num; 1) MA plot
&num; 2) rlog stabilization and variance stabiliazation
&num; 3) PCA plot
&num; 4) heatmap of clustering analysis
&num;
&num;
&num;&num;&num;&num;&num;&num;&num;&num;&num;&num;&num;&num;&num;&num;&num;&num;&num;&num;&num;&num;&num;&num;&num;&num;&num;&num;&num;&num;&num;&num;&num;&num;&num;&num;&num;&num;&num;&num;&num;&num;&num;&num;&num;&num;&num;&num;&num;&num;&num;&num;&num;&num;&num;&num;&num;&num;&num;&num;&num;&num;&num;&num;&num;&num;&num;&num;&num;&num;&num;&num;&num;&num;&num;&num;&num;&num;&num;&num;&num;&num;&num;&num;&num;&num;

&num; MA plot of RNAseq data for entire dataset
&num; http://en.wikipedia.org/wiki/MA_plot
&num; genes with padj < 0.1 are colored Red
plotMA(dds, ylim=c(-8,8),main = "RNAseq experiment")
dev.copy(png, paste0(outputPrefix, "-MAplot_initial_analysis.png"))
dev.off()

&num; transform raw counts into normalized values
&num; DESeq2 has two options:  1) rlog transformed and 2) variance stabilization
&num; variance stabilization is very good for heatmaps, etc.
rld <- rlogTransformation(dds, blind=T)
vsd <- varianceStabilizingTransformation(dds, blind=T)

&num; save normalized values
write.table(as.data.frame(assay(rld),file = paste0(outputPrefix, "-rlog-transformed-counts.txt"), sep = '\t'))
write.table(as.data.frame(assay(vsd),file = paste0(outputPrefix, "-vst-transformed-counts.txt"), sep = '\t'))


&num; clustering analysis
&num; excerpts from http://dwheelerau.com/2014/02/17/how-to-use-deseq2-to-analyse-rnaseq-data/
library("RColorBrewer")
library("gplots")
sampleDists <- dist(t(assay(rld)))
suppressMessages(library("RColorBrewer"))
sampleDistMatrix <- as.matrix(sampleDists)
rownames(sampleDistMatrix) <- paste(colnames(rld), rld$type, sep="")
colnames(sampleDistMatrix) <- paste(colnames(rld), rld$type, sep="")
colors <- colorRampPalette( rev(brewer.pal(8, "Blues")) )(255)
heatmap(sampleDistMatrix,col=colors,margin = c(8,8))
dev.copy(png,paste0(outputPrefix, "-clustering.png"))
dev.off()

&num;Principal components plot shows additional but rough clustering of samples
library("genefilter")
library("ggplot2")
library("grDevices")

rv <- rowVars(assay(rld))
select <- order(rv, decreasing=T)[seq_len(min(500,length(rv)))]
pc <- prcomp(t(assay(vsd)[select,]))

&num; set condition
condition <- treatments
scores <- data.frame(pc$x, condition)

(pcaplot <- ggplot(scores, aes(x = PC1, y = PC2, col = (factor(condition))))
  + geom_point(size = 5)
  + ggtitle("Principal Components")
  + scale_colour_brewer(name = " ", palette = "Set1")
  + theme(
    plot.title = element_text(face = 'bold'),
    legend.position = c(.9,.2),
    legend.key = element_rect(fill = 'NA'),
    legend.text = element_text(size = 10, face = "bold"),
    axis.text.y = element_text(colour = "Black"),
    axis.text.x = element_text(colour = "Black"),
    axis.title.x = element_text(face = "bold"),
    axis.title.y = element_text(face = 'bold'),
    panel.grid.major.x = element_blank(),
    panel.grid.major.y = element_blank(),
    panel.grid.minor.x = element_blank(),
    panel.grid.minor.y = element_blank(),
    panel.background = element_rect(color = 'black',fill = NA)
  ))
&num;dev.copy(png,paste0(outputPrefix, "-PCA.png"))
ggsave(pcaplot,file=paste0(outputPrefix, "-ggplot2.png"))


&num; heatmap of data
library("RColorBrewer")
library("gplots")
&num; 1000 top expressed genes with heatmap.2
select <- order(rowMeans(counts(ddsClean,normalized=T)),decreasing=T)[1:100]
my_palette <- colorRampPalette(c("blue",'white','red'))(n=100)
heatmap.2(assay(vsd)[select,], col=my_palette,
          scale="row", key=T, keysize=1, symkey=T,
          density.info="none", trace="none",
          cexCol=0.6, labRow=F,
          main="Heatmap of 100 DE Genes in Liver Tissue Comparison")
dev.copy(png, paste0(outputPrefix, "-HEATMAP.png"))
dev.off()</pre>

It is recommended the user study and attempt the code on one's own before moving onward. The resulting files are located in the directory.

<h2 id = "EnTAP">Entap:Functional Annotation for Genomes</h2>

Unfortunately for those proceeding through this tutorial locally, an HPC is required to complete the annotation. We will be using the program EnTAP, which serves as a functional annotation for genomes. The installation for EnTAP has not been included in this tutorial as the software must be installed on the server through which one wishes to run her or his commands. The installation file <i>does</i>, however, contain all of the dependcies, with the exception of the InterProScan and EGGNOG-MAPPER databases due to their size, required to run EnTAP. For full download instructions of EnTAP visit http://entap.readthedocs.io/en/latest/index.html.

Before running EnTAP we must complete a series of needed 'warm-up' tasks first, starting with retrieving the protein IDs of our differentially expressed genes. Let's begin this objective by moving our first 9 differentially expressed genes from our Croaker_DESeq2-results-with-normalized.csv file to a temporary file, temp.csv, then use those 9 gene ids to retrieve the 9 corresponding protein ids and AA-sequences from the protein table found at https://www.ncbi.nlm.nih.gov/genome/proteins/12197?genome_assembly_id=229515 (this must be downloaded now). To do this, we will use csvgeneID2fasta.py with the following code:

<pre style="color: silver; background: black;">head -n 10 Croaker_DESeq2-results-with-normalized.csv > temp.csv 
python csvgeneID2fasta.py
</pre>

Which will prompt us with a series of questions we must answer:

<pre style="color: silver; background: black;">Please enter the file destination containing your differentially expressed Gene IDs 
temp.csv
Please enter the file destination containing the appropriate NIH protein table 
ProteinTable12197_229515.txt
Please enter the file destination of your protein fasta 
GCF_000972845.1_L_crocea_1.0_protein.faa
Please enter your desired fasta output destination 
fasta_out.fasta</pre>

After generating our new fasta file, we must now create the databases against which we will be searching for our annotations. We will be using the 'vertebrate_other' databases found here ftp://ftp.ncbi.nlm.nih.gov/refseq/release/vertebrate_other/. If you look at the link you will see that there are four types of files for each index. Because our "fasta_out" file has protein sequences, we are only interested in the amino acid fastas, the 'faa.gz' files. We may use the '-A' argument of wget (along with other arguments I encourage you to look up) to select only the amino acid fastas. To do this, we use the following code:

<pre style="color: silver; background: black;">wget -A faa.gz -m -p -E -k -K -np ftp://ftp.ncbi.nlm.nih.gov/refseq/release/vertebrate_other/</pre>

Now we must compile all of the fastas into a single fasta:

<pre style="color: silver; background: black;">cd ftp.ncbi.nlm.nih.gov/refseq/release/vertebrate_other
gunzip &#42;.faa.gz
cat &#42;.faa > vertebrate_other_fasta.txt</pre>

We will also be scanning against the Uniprot-Swiss-Prot databases, which may be downloaded with the following code:

<pre style="color: silver; background: black;">wget ftp://ftp.uniprot.org/pub/databases/uniprot/current_release/knowledgebase/complete/uniprot_sprot.fasta.gz
gunzip uniprot_sprot.fasta.gz</pre>

It is absolutely critical that all of the databases and software are loaded *onto the server* where you intend to run EnTAP. More ideally, the databases should be in the same directory as the executable EnTAP file. This is why there are no longer directories included in the example coding, so be responsible and assure all your ducks are in a row! The quickest way to install EnTAP on the server is to run the "programs_installation" script then download the interproscan and eggnog-mapper databases, followed lastly by installing, making EnTAP, and configuring EnTAP (EnTAP must be configured by editing its configuration text file and resaving that file, bear that in mind!).

EnTAP operates through DIAMOND, therefore, we will be using DIAMOND to create our scannable databases. To do this, we run the following code:

<pre style="color: silver; background: black;">diamond makedb --in vertebrate_other.fasta -d vertebrate-other
diamond makedb --in uniprot_sprot.fasta -d uniprot_sprot</pre>

Now we may run EnTAP with the following code:

<pre style="color: silver; background: black;">cd EnTAP/
./EnTAP  --runP -i fasta_out.fasta -d vertebrate_other.protein.faa.dmnd -d uniprot_sprot.dmnd --ontology 0  --threads 8

Required Flags:
--runP      with a protein input, frame selection will not be ran and annotation will be executed with protein sequences (blastp)
-i          Path to the transcriptome file (either nucleotide or protein)
-d          Specify up to 5 DIAMOND indexed (.dmnd) databases to run similarity search against

Optional:
-threads    Number of threads
--ontology  0 - EggNOG (default)</pre>

Once the job is done it will create a folder called “outfiles” which will contain the output of the program:

<pre style="color: silver; background: black;">entap/
|-- outfiles/
|   |-- debug_2018.2.25-2h49m29s.txt
|   |-- entap_out/
|   |-- final_annotated.faa
|   |-- final_annotations_lvl0_contam.tsv
|   |-- final_annotations_lvl0_no_contam.tsv
|   |-- final_annotations_lvl0.tsv
|   |-- final_annotations_lvl3_contam.tsv
|   |-- final_annotations_lvl3_no_contam.tsv
|   |-- final_annotations_lvl3.tsv
|   |-- final_annotations_lvl4_contam.tsv
|   |-- final_annotations_lvl4_no_contam.tsv
|   |-- final_annotations_lvl4.tsv
|   |-- final_unannotated.faa
|   |-- final_unannotated.fnn
|   |-- log_file_2018.2.25-2h49m29s.txt
|   |-- ontology/
|   |-- similarity_search/</pre>

<h2 id = "Integration">Integrating the DE Results with the Annotation Results</h2>

You must copy the following two files from the entap run to your computer, which is “GeneID_proteinID.txt” and “final_annotations_lvl0_contam.tsv” file from the previous run. The two files may be found in:

<pre style="color: silver; background: black;">
entap/
|-- GeneID_proteinID.txt
|-- outfiles/
|   |-- final_annotations_lvl0_contam.tsv</pre>



Lastly, we integrate the annotations with the DE genes using the following R code:

<pre style="color: silver; background: black;">library("readr")
&num;read the csv file with DE genes
csv <- read.csv("Croaker_DESeq2-results-with-normalized.csv")
&num;read the file with geneID to proteinID relationship
gene_protein_list <- read.table("GeneID_proteinID.txt")
names(gene_protein_list) <- c('GeneID','table', 'tableID','protein', 'protienID')
gene_protein_list <- gene_protein_list[,c("GeneID","protienID")]

&num;merging the two dataframes
DEgene_proteinID <- merge(csv, gene_protein_list, by.x="gene", by.y="GeneID")

&num;read_tsv
annotation_file <- read_tsv('final_annotations_lvl0.tsv', col_names = TRUE)
names(annotation_file)[1] <- 'query_seqID'

&num;merging the DEgene_proteinID with annotation_file dataframes
annotated_DEgenes <- merge(DEgene_proteinID, annotation_file, by.x="protienID", by.y="query_seqID")
View(annotated_DEgenes)
write.csv(annotated_DEgenes, file = paste0("annotated_DEgenes_final.csv"))</pre>

Congratulations on completing your differential expression and functional annotation tutorial!

<h2 id="Citation">Citations</h2>

Alex Hart, Jill Wegrzyn http://entap.readthedocs.io/en/latest/index.html

Anders, Simon, Paul Theodor Pyl, and Wolfgang Huber. “HTSeq—a Python Framework to Work with High-Throughput Sequencing Data.” Bioinformatics 31.2 (2015): 166–169. PMC. Web. 8 Mar. 2018.

B. Buchfink, Xie C., D. Huson, "Fast and sensitive protein alignment using DIAMOND", Nature Methods 12, 59-60 (2015).

E. Neuwirth, RColorBrewer https://cran.r-project.org/web/packages/RColorBrewer/index.html

Gentleman R, Carey V, Huber W and Hahne F (2017). genefilter: genefilter: methods for filtering genes from high-throughput experiments. R package version 1.60.0. 

Gregory R. Warnes, Ben Bolker, Lodewijk Bonebakker, Robert Gentleman, Wolfgang Huber Andy Liaw, Thomas Lumley, Martin Maechler, Arni Magnusson, Steffen Moeller, Marc Schwartz, Bill Venables, gplots https://cran.r-project.org/web/packages/gplots/index.html

H. Wickham. ggplot2: Elegant Graphics for Data Analysis. Springer-Verlag New York, 2009. 

Joshi NA, Fass JN. (2011). Sickle: A sliding-window, adaptive, quality-based trimming tool for FastQ files 
(Version 1.33) [Software].  Available at https://github.com/najoshi/sickle.

Leinonen, Rasko, Hideaki Sugawara, and Martin on behalf of the International Nucleotide Sequence Database Collaboration. “The Sequence Read Archive.” Nucleic Acids Research 39.Database issue (2011): D19–D21. PMC. Web. 8 Mar. 2018.

Li H, Handsaker B, Wysoker A, Fennell T, Ruan J, Homer N, Marth G, Abecasis G, Durbin R, and 1000 Genome Project Data Processing Subgroup, The Sequence alignment/map (SAM) format and SAMtools, Bioinformatics (2009) 25(16) 2078-9

Love MI, Huber W and Anders S (2014). “Moderated estimation of fold change and dispersion for RNA-seq data with DESeq2.” Genome Biology, 15, pp. 550. doi: 10.1186/s13059-014-0550-8. 
