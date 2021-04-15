#!/usr/bin/env bash

# This code will replace the old "Run_SnpSniffer.sh" script

# Requirements:
# - R with tidyverse available at runtime

# Usage: snpSniffer_Summarize.sh </Full/Path/Template_Database.ini>

# Check that the required file was provided at the command line
if [[ $# -ne 1 ]]
then
  echo -e "Expected 1 arguments, found $#"
  echo -e "Usage: snpSniffer_Summarize.sh </Full/Path/Template_Database.ini>"
  exit 1
fi

###############################################
## Define Required Variables
###############################################

# The required JAVA -jar and R Script files will be in the same folder as this script, detect dynamically
SCRIPT_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/$(basename "${BASH_SOURCE[0]}")"
SCRIPT_DIR=`dirname ${SCRIPT_PATH}`

SNP_SNIFFER_JAR=${SCRIPT_DIR}/snpSnifferV5.jar
SNP_SNIFFER_GRAPH=${SCRIPT_DIR}/snpSniffer_Summarize.R

EMPTY_DATABASE=$1

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
cat ${EMPTY_DATABASE} > SnpSniffer_DB.ini

# Find all the pre-calculated genotype results (search for all expected extensions)
# Drop the library level results for simplified viewing
find . -type f -name "*flt.vcf" ! -name "*[A-Z][0-9][0-9][0-9][0-9][0-9]*" > Temp_SnpSniffer_Genotype_Paths.txt
find . -type f -name "*snpsniffer.vcf" ! -name "*[A-Z][0-9][0-9][0-9][0-9][0-9]*" >> Temp_SnpSniffer_Genotype_Paths.txt
find . -type f -name "*snpSniffer.vcf" ! -name "*[A-Z][0-9][0-9][0-9][0-9][0-9]*" >> Temp_SnpSniffer_Genotype_Paths.txt

# Add genotypes to the database
for line in `cat Temp_SnpSniffer_Genotype_Paths.txt`
do
  #Test code to remove when jar file error is fixed for dealing with homo-ref input to database
  ##
  VCF=`basename ${line}`
  awk '{OFS="\t" ; if($10 == "0/0:0") {print $1, $2, $3, $4, $5, $6, $7, $8, $9, "0"} else{print $0}}' ${line} > ${VCF}
  ##
  # When corrected update "-add ${VCF}" to "-add ${line}
  java -jar ${SNP_SNIFFER_JAR} -add ${VCF} SnpSniffer_DB.ini
  rm ${VCF}
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
