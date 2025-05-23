#!/usr/bin/env bash

# This code generates the needed genotype calls for snpSniffer summaries

## Usage help message
usage()
{
  # `cat << EOF` This means that cat should stop reading when EOF is detected
  cat << EOF

  Usage: $0 [ options ]

  -h      Display Help

  Required Options
  -b      Input Alignment file (CRAM, BAM, SAM)
  -o      Output Name (final output will be ${OUTPUT_BASENAME}.snpSniffer.vcf)
  -c      Containerized Workflow (No, Singularity, Docker) [No]
  -r      Reference fasta
  -s      SNP positions to genotype (grch38_hg38_ucsc_contigs/positions_387_hg38_ucsc.txt)
  -u      Update Contig Names (Yes,No) [Yes]
  -a      Contig annotation update file (accessory_files/GRCh38_PrimaryContigs_UCSC_2_Ensembl_CrossMap.txt)

  NOTES:  Summary step expects single character contig names 1-22, X, Y not chr1,chr2,...,chrY
          update contig names as needed with -u and -a options

          Containerized Workflow only supports Singularity currently. Singularity MUST be available in the $PATH at runtime
          Non containerized workflow requires bcftools to be available in the $PATH at runtime

EOF
# EOF is found above and hence cat command stops reading. This is equivalent to echo but much neater when printing out.
  exit 2
}

## Assign default values
CONTAINER=No
UPDATE_STATUS=Yes

## Capture and assign variables from inputs
while getopts 'd:f:?h' flag
do
    case ${flag} in
        b) BAM=${OPTARG};;
        o) OUTPUT_BASENAME=${OPTARG};;
        c) CONTAINER=${OPTARG};;
        r) REFERENCE=${OPTARG};;
        s) TARGET_SNPS=${OPTARG};;
        u) UPDATE_STATUS=${OPTARG};;
        a) CONTIG_ANNOTATION_UPDATE=${OPTARG};;
        h|?) usage;;
    esac
done


###############################################
## Define needed containers
###############################################

BCFTOOLS_SIF=docker://ghcr.io/tgen/containers/bcftools:1.17-23080313
SNP_SNIFFER_SIF=docker://ghcr.io/tgen/containers/snpsniffer:7.0.0-23080810

###############################################
## Define testing paths
###############################################

#REFERENCE=/home/tgenref/homo_sapiens/grch38_hg38/hg38tgen/genome_reference/GRCh38tgen_decoy_alts_hla.fa
#TARGET_SNPS=/home/tgenref/homo_sapiens/grch38_hg38/hg38_tempe/tool_resources/snpSniffer/positions_387_hg38_ucsc.txt
#CONTIG_ANNOTATION_UPDATE=/home/tgenref/homo_sapiens/grch38_hg38/hg38_tempe/tool_resources/bcftools/GRCh38_PrimaryContigs_UCSC_2_Ensembl_CrossMap.txt

###############################################
## Generate Genotype Calls
###############################################

if [ $CONTAINER == "Singularity" ]
then

  echo "Running in Singularity containerized mode, assumes singularity is available in the path"

  if [UPDATE_STATUS == "Yes"]
  then
    echo "Generating genotypes and updating contig names"

    # Genotype the test positions across the genome, filter to calls with DP >= 5, sort, remove chr from contig names
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
      --include 'INFO/DP >= 5' \
      --rename-chrs ${CONTIG_ANNOTATION_UPDATE} \
      --output-type v \
      --output ${OUTPUT_BASENAME}.snpSniffer.vcf

  elif [ UPDATE_STATUS == "No" ]
  then
    echo "Generating genotypes and maintaining contig names in CRAM/BAM/SAM"

    # Genotype the test positions across the genome, filter to calls with DP >= 5, sort, remove chr from contig names
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
      --include 'INFO/DP >= 5' \
      --output-type v \
      --output ${OUTPUT_BASENAME}.snpSniffer.vcf

  else
    echo "Unsupported variable provided to -u option"
    echo $UPDATE_STATUS
    echo "Exiting script"
    exit 1
  fi

elif [ $CONTAINER == "No" ]
then

  echo "Running in native mode, assumes bcftools is available in the path"

  if [UPDATE_STATUS == "Yes"]
  then
    echo "Generating genotypes and updating contig names"

    # Genotype the test positions across the genome, filter to calls with DP >= 5, sort, remove chr from contig names
    bcftools mpileup \
      --no-BAQ \
      --max-depth 5000 \
      --min-MQ 0 \
      --min-BQ 13 \
      --fasta-ref ${REFERENCE} \
      --regions-file ${TARGET_SNPS} \
      ${INPUT_ALIGNMENT} \
      | \
      bcftools call \
      --consensus-caller \
      --skip-variants indels \
      | \
      bcftools sort \
      | \
      bcftools annotate \
      --include 'INFO/DP >= 5' \
      --rename-chrs ${CONTIG_ANNOTATION_UPDATE} \
      --output-type v \
      --output ${OUTPUT_BASENAME}.snpSniffer.vcf

  elif [ UPDATE_STATUS == "No" ]
  then
    echo "Generating genotypes and maintaining contig names in CRAM/BAM/SAM"

    # Genotype the test positions across the genome, filter to calls with DP >= 5, sort, remove chr from contig names
    bcftools mpileup \
      --no-BAQ \
      --max-depth 5000 \
      --min-MQ 0 \
      --min-BQ 13 \
      --fasta-ref ${REFERENCE} \
      --regions-file ${TARGET_SNPS} \
      ${INPUT_ALIGNMENT} \
      | \
      bcftools call \
      --consensus-caller \
      --skip-variants indels \
      | \
      bcftools sort \
      --include 'INFO/DP >= 5' \
      --output-type v \
      --output ${OUTPUT_BASENAME}.snpSniffer.vcf

  else
    echo "Unsupported variable provided to -u option"
    echo $UPDATE_STATUS
    echo "Exiting script"
    exit 1
  fi

else
  echo "Unsupported variable provided to -c option"
  echo $CONTAINER
  echo "Exiting script"
  exit 1
fi

