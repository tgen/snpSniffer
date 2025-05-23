#!/usr/bin/env bash

#SBATCH --job-name="snpSniffer_Genotype"
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2
#SBATCH --mem=4G
#SBATCH --time=0-8:00:00

# User must provide the CRAM/BAM full, and build Reference FASTA, snpSniffer Sites, and rename

# Usage example
# sbatch snpSniffer_Genotype_Slurm_Singularity.sh <CRAM/BAM Full Path> <Output_Basename>

INPUT_ALIGNMENT=$1
OUTPUT_BASENAME=$2

# Define needed containers
BCFTOOLS_SIF=docker://ghcr.io/tgen/containers/bcftools:1.17-23080313
SNP_SNIFFER_SIF=docker://ghcr.io/tgen/containers/snpsniffer:7.0.0-23080810

# Define the location of the reference file and alts file
REFERENCE=/home/tgenref/homo_sapiens/grch38_hg38/hg38tgen/genome_reference/GRCh38tgen_decoy_alts_hla.fa
TARGET_SNPS=/home/tgenref/homo_sapiens/grch38_hg38/hg38_tempe/tool_resources/snpSniffer/positions_387_hg38_ucsc.txt
CONTIG_ANNOTATION_UPDATE=/home/tgenref/homo_sapiens/grch38_hg38/hg38_tempe/tool_resources/bcftools/GRCh38_PrimaryContigs_UCSC_2_Ensembl_CrossMap.txt

# Load singularity
module load singularity

{# Genotype the 387 test positions across the genome, filter to calls with DP >= 5, sort, remove chr from contig names #}
singularity exec --bind $PWD --pwd $PWD --workdir /scratch/$USER --cleanenv --contain -B /home -B /scratch ${BCFTOOLS_SIF} \
  bcftools mpileup \
  --no-BAQ \
  --max-depth 5000 \
  --min-MQ 0 \
  --min-BQ 13 \
  --fasta-ref ${REFERENCE} \
  --regions-file ${TARGET_SNPS} \
  ${INPUT_ALIGNMENT} \
  | \
singularity exec --bind $PWD --pwd $PWD --workdir /scratch/$USER --cleanenv --contain -B /home -B /scratch ${BCFTOOLS_SIF} \
  bcftools call \
  --consensus-caller \
  --skip-variants indels \
  | \
singularity exec --bind $PWD --pwd $PWD --workdir /scratch/$USER --cleanenv --contain -B /home -B /scratch ${BCFTOOLS_SIF} \
  bcftools sort \
  | \
singularity exec --bind $PWD --pwd $PWD --workdir /scratch/$USER --cleanenv --contain -B /home -B /scratch ${BCFTOOLS_SIF} \
  bcftools annotate \
  --threads 2 \
  --include 'INFO/DP >= 5' \
  --rename-chrs ${CONTIG_ANNOTATION_UPDATE} \
  --output-type v \
  --output ${OUTPUT_BASENAME}.snpSniffer.vcf

