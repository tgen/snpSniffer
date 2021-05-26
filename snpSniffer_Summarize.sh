#!/usr/bin/env bash

# This code will replace the old "Run_SnpSniffer.sh" script

# Capture the current script path to dynamically link default input database.ini file
SCRIPT_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/$(basename "${BASH_SOURCE[0]}")"
SCRIPT_DIR=`dirname ${SCRIPT_PATH}`

## Usage help message
usage()
{
  # `cat << EOF` This means that cat should stop reading when EOF is detected
  cat << EOF

  Usage: $0 [ options ]

  -h      Display Help

  Required Options
  -d      Input Database File (databaseV5_hg38_ucsc.ini)
  -f      Filter Library Level Results (Yes/No) [Yes]

  NOTES:  Default database supports human GRCh38/hg38 coordinates WITHOUT chr prefixes

EOF
# EOF is found above and hence cat command stops reading. This is equivalent to echo but much neater when printing out.
  exit 2
}

## Assign default values
DATABASE=${SCRIPT_DIR}/grch38_hg38_ucsc_contigs/databaseV5_hg38_ucsc.ini
FILTER=Yes

## Capture and assign variables from inputs
while getopts 'd:e:?h' flag
do
    case ${flag} in
        d) VCF=${OPTARG};;
        f) DATABASE=${OPTARG};;
        h|?) usage;;
    esac
done


###############################################
## Define Paths to Required scripts based on location of initial script
###############################################

SNP_SNIFFER_JAR=${SCRIPT_DIR}/snpSniffer.jar
SNP_SNIFFER_GRAPH=${SCRIPT_DIR}/snpSniffer_Summarize.R

###############################################
## Collect available genotype results and add to fresh database
###############################################

## Print the help result to the terminal
echo
echo
echo
java -jar ${SNP_SNIFFER_JAR} -help
echo
echo
echo
echo "---------------------------------------"
echo
echo "Creating snpSniffer Summary of Current Folder"

# Create an empty version of the database
cat ${DATABASE} > SnpSniffer_DB.ini

# Find all the pre-calculated genotype results (search for all expected extensions)
# Drop the library level results for simplified viewing
if [ $FILTER == "Yes" ]
then
  find . -type f -name "*flt.vcf" ! -name "*[A-Z][0-9][0-9][0-9][0-9][0-9]*" > Temp_SnpSniffer_Genotype_Paths.txt
  find . -type f -name "*snpsniffer.vcf" ! -name "*[A-Z][0-9][0-9][0-9][0-9][0-9]*" >> Temp_SnpSniffer_Genotype_Paths.txt
  find . -type f -name "*snpSniffer.vcf" ! -name "*[A-Z][0-9][0-9][0-9][0-9][0-9]*" >> Temp_SnpSniffer_Genotype_Paths.txt
elif [ $FILTER == "No" ]
then
  find . -type f -name "*flt.vcf" > Temp_SnpSniffer_Genotype_Paths.txt
  find . -type f -name "*snpsniffer.vcf" >> Temp_SnpSniffer_Genotype_Paths.txt
  find . -type f -name "*snpSniffer.vcf" >> Temp_SnpSniffer_Genotype_Paths.txt
else
  echo
  echo "------------------------"
  echo ERROR incorrect value provided to option -f, only Yes or No are expected
  echo
  echo
  exit 1
fi

# Add genotypes to the database
for line in `cat Temp_SnpSniffer_Genotype_Paths.txt`
do
  java -jar ${SNP_SNIFFER_JAR} -add ${line} SnpSniffer_DB.ini
done

# Cleanup the temp file
rm Temp_SnpSniffer_Genotype_Paths.txt

###############################################
## Generate All Pairwise Comparisons
###############################################

# When -expected or -NotExpect is queried a full comparison is produced to a file called snpSniffer_output.txt, that is used for all summaries
java -jar ${SNP_SNIFFER_JAR} -expected _ 2 SnpSniffer_DB.ini > Temp_Expected_Results.txt

# Remove the unwanted file
rm Temp_Expected_Results.txt

# Preprocess the generic full comparison output
## Replace unwanted features with tab-separtor
## Create sorted list of line by line comparisons and drop duplicates
sed 's/ & /\'$'\t''/g' snpSniffer_output.txt \
  | \
  sed 's/ count=/\'$'\t''/g' \
  | \
  sed 's/ match=/\'$'\t''/g' \
  | \
  sed 's/ ratio=/\'$'\t''/g' \
  | \
  sed 's/.bwa.bam.snpSniffer//g' \
  | \
  sed 's/.star.bam.snpSniffer//g' \
  | \
  awk '{print ($1 > $2) ? $0"\t"$1"-"$2 : $0"\t"$2"-"$1}' \
  | \
  awk '!x[$6]++'> SnpSniffer_AllPairs_Results.txt

# Remove preliminary output file
rm snpSniffer_output.txt

###############################################
## Generate Heterozygous Genotype Summary
###############################################

# Extract het summary from database using snpSniffer.jar
java -jar ${SNP_SNIFFER_JAR} -het SnpSniffer_DB.ini > Temp1_HetRate_Results.txt

# Remove header lines
awk 'NR>2' Temp1_HetRate_Results.txt \
  | \
  sed 's/.bwa.bam.snpSniffer//g' \
  | \
  sed 's/.star.bam.snpSniffer//g' > Temp2_HetRate_Results.txt

###############################################
## Summarize and Graph with R (Tidyverse)
###############################################

Rscript --vanilla ${SNP_SNIFFER_GRAPH} \
  --comp_file SnpSniffer_AllPairs_Results.txt \
  --het_file Temp2_HetRate_Results.txt

# Remove unneeded files
rm SnpSniffer_AllPairs_Results.txt
rm Temp1_HetRate_Results.txt
rm Temp2_HetRate_Results.txt
