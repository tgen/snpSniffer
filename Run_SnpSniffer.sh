#!/bin/sh


#This script will execute the SnpSniffer Summary on all files in your current folder

###############################
#
#   VARIABLES
#
#################################

<<<<<<< HEAD
USER=`whoami`

EMPTY_DATABASE=/home/${USER}/snpSniffer/databaseV5.ini
SNP_SNIFFER_JAR=/home/${USER}/snpSniffer/snpSniffer.jar
SnpSniffer_Graph_R=/home/${USER}/snpSniffer/SnpSniffer_Graph.R
=======
function usage(){
  echo -e "\n$0 \$DIR_INSTALL_SNPSNIFFER  \$FULL_PATH_TO_EMPTY_DATABASE"
  
  echo -e "\twhere DIR_INSTALL_SNPSNIFFER is actually the FULL path where you cloned the tool"
  echo -e "\twhere FULL_PATH_TO_EMPTY_DATABASE is actually the FULL path to an original DB. 
  example: \${DIR_INSTALL_SNPSNIFFER}/grch38_hg38_ucsc_contigs/databaseV5_hg38_ucsc.ini "
  echo -e "\n"
}

if [[ $# -ne 2 ]]
then
  echo -e "Expected 2 arguments, found $#" ; usage ; exit 1
fi

#DIR_INSTALL=/home/$(whoami)/tools/snpSniffer_v2.0.0/ 
DIR_INSTALL_SNPSNIFFER=$1

#EMPTY_DATABASE=${DIR_INSTALL_SNPSNIFFER}/grch38_hg38_ucsc_contigs/databaseV5_hg38_ucsc.ini
EMPTY_DATABASE=$2
SNP_SNIFFER_JAR=${DIR_INSTALL_SNPSNIFFER}/snpSniffer.jar
SnpSniffer_Graph_R=${DIR_INSTALL_SNPSNIFFER}/SnpSniffer_Graph.R
>>>>>>> 6e1a4882b027357bf82451cad9884aa1efc4df8d

#EMPTY_DATABASE=/data/tools/snpSniffer.v5/databaseV5_hg38_ucsc.ini
#SNP_SNIFFER_JAR=/data/tools/snpSniffer.v5/snpSniffer.jar
#SnpSniffer_Graph_R=/data/jkeats/scripts/SnpSniffer_Graph.R

## check args
if [[ ${DIR_INSTALL_SNPSNIFFER} == "" || ! -e ${DIR_INSTALL_SNPSNIFFER} ]] ; 
then
  echo -e "ERROR: INVALID DIR_INSTALL PATH ; Check your input; Aborting."
  exit 1
fi
if [[ ${EMPTY_DATABASE} == "" || ! -e ${EMPTY_DATABASE} ]] ; 
then
  echo -e "ERROR: INVALID \$EMPTY_DATABASE==${EMPTY_DATABASE} ; Check your input; Aborting"
  exit 1
fi


##################################
#
#   Code
#
##################################


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
echo Processing Current Folder

# STEP 1
# Add pre-calculated results to a custom project database

# Create an empty version of the database
cat ${EMPTY_DATABASE} > SnpSniffer_DB.ini

# Find all the pre-calculated genotype results

find . -name "*flt.vcf" > Temp_SnpSniffer_Genotype_Paths.txt
find . -name "*snpsniffer.vcf" >> Temp_SnpSniffer_Genotype_Paths.txt
find . -name "*snpSniffer.vcf" >> Temp_SnpSniffer_Genotype_Paths.txt

# Add genotypes to the database

for line in `cat Temp_SnpSniffer_Genotype_Paths.txt`
do

java -jar ${SNP_SNIFFER_JAR} -add ${line} SnpSniffer_DB.ini

done

# Cleanup the temp file
rm Temp_SnpSniffer_Genotype_Paths.txt 


# STEP 2
# Process Database to extract issues

java -jar ${SNP_SNIFFER_JAR} -expected _ 2 SnpSniffer_DB.ini > Temp_Expected_Results.txt
sed 's/ & /\'$'\t''/g' Temp_Expected_Results.txt | sed 's/ count=/\'$'\t''/g' | sed 's/ match=/\'$'\t''/g' | sed 's/ ratio=/\'$'\t''/g' | sed 's/.proj.Aligned.out.sorted.md_flt//g' | sed 's/.proj.md.jr_flt//g' | awk '{print ($1 > $2) ? $0"\t"$1"_"$2 : $0"\t"$2"_"$1}' | awk '!x[$6]++' > SnpSniffer_Expected_Results.txt
cut -f1-4 SnpSniffer_Expected_Results.txt > a.txt
cut -f5 SnpSniffer_Expected_Results.txt | sed 's/hetRatio/Ratio/g' | cut -c1-5 > b.txt
cut -f6 SnpSniffer_Expected_Results.txt > c.txt
cut -f6 SnpSniffer_Expected_Results.txt | awk '{gsub("_","\t",$0); print;}' | awk '{OFS = "\t" ; print $1"_"$2, $9"_"$10, $1"_"$2"_"$3, $9"_"$10"_"$11}' > d.txt
cut -f6 SnpSniffer_Expected_Results.txt | awk '{gsub("_","\t",$0); print;}' | cut -f7,15 | awk '{print ($1 > $2) ? $1"_"$2 : $2"_"$1}' > e.txt
cut -f6 SnpSniffer_Expected_Results.txt | awk '{gsub("_","\t",$0); print;}' | cut -f6 | cut -c1 | sed 's/T/Tumor/g' | sed 's/C/Constitutional/g' > f.txt
cut -f6 SnpSniffer_Expected_Results.txt | awk '{gsub("_","\t",$0); print;}' | cut -f14 | cut -c1 | sed 's/T/Tumor/g' | sed 's/C/Constitutional/g' > g.txt

echo -e BAM1"\t"BAM2"\t"Shared_Calls"\t"Matching_Calls"\t"Ratio"\t"Set_Compared"\t"Patient1"\t"Patient2"\t"Visit1"\t"Visit2"\t"Assay_Pair"\t"Subgroup1"\t"Subgroup2"\t"Subgroup_Pair"\t"Patient_Pair > header.txt
paste a.txt b.txt c.txt d.txt e.txt f.txt g.txt | awk '{print ($12 > $13) ? $0"\t"$12"_"$13 : $0"\t"$13"_"$12}' | awk '{print ($7 == $8) ? $0"\t""Same" : $0"\t""Different"}' > body.txt
cat header.txt body.txt > SnpSniffer_Expected_Results.txt

#cleanup
rm a.txt b.txt c.txt d.txt e.txt f.txt g.txt header.txt body.txt

java -jar ${SNP_SNIFFER_JAR} -notExpected _ 2 SnpSniffer_DB.ini > Temp_NotExpected_Results.txt
sed 's/ & /\'$'\t''/g' Temp_NotExpected_Results.txt | sed 's/ count=/\'$'\t''/g' | sed 's/ match=/\'$'\t''/g' | sed 's/ ratio=/\'$'\t''/g' | sed 's/.proj.Aligned.out.sorted.md_flt//g' | sed 's/.proj.md.jr_flt//g' | awk '{print ($1 > $2) ? $0"\t"$1"_"$2 : $0"\t"$2"_"$1}' | awk '!x[$6]++' > SnpSniffer_NotExpected_Results.txt
cut -f1-4 SnpSniffer_NotExpected_Results.txt > a.txt
cut -f5 SnpSniffer_NotExpected_Results.txt | sed 's/hetRatio/Ratio/g' | cut -c1-5 > b.txt
cut -f6 SnpSniffer_NotExpected_Results.txt > c.txt
cut -f6 SnpSniffer_NotExpected_Results.txt | awk '{gsub("_","\t",$0); print;}' | awk '{OFS = "\t" ; print $1"_"$2, $9"_"$10, $1"_"$2"_"$3, $9"_"$10"_"$11}' > d.txt
cut -f6 SnpSniffer_NotExpected_Results.txt | awk '{gsub("_","\t",$0); print;}' | cut -f7,15 | awk '{print ($1 > $2) ? $1"_"$2 : $2"_"$1}' > e.txt
cut -f6 SnpSniffer_NotExpected_Results.txt | awk '{gsub("_","\t",$0); print;}' | cut -f6 | cut -c1 | sed 's/T/Tumor/g' | sed 's/C/Constitutional/g' > f.txt
cut -f6 SnpSniffer_NotExpected_Results.txt | awk '{gsub("_","\t",$0); print;}' | cut -f14 | cut -c1 | sed 's/T/Tumor/g' | sed 's/C/Constitutional/g' > g.txt

echo -e BAM1"\t"BAM2"\t"Shared_Calls"\t"Matching_Calls"\t"Ratio"\t"Set_Compared"\t"Patient1"\t"Patient2"\t"Visit1"\t"Visit2"\t"Assay_Pair"\t"Subgroup1"\t"Subgroup2"\t"Subgroup_Pair"\t"Patient_Pair > header.txt
paste a.txt b.txt c.txt d.txt e.txt f.txt g.txt | awk '{print ($12 > $13) ? $0"\t"$12"_"$13 : $0"\t"$13"_"$12}' | awk '{print ($7 == $8) ? $0"\t""Same" : $0"\t""Different"}' > body.txt
cat header.txt body.txt > SnpSniffer_NotExpected_Results_All.txt

awk '{if($3 >= 20) print $0}' body.txt > body2.txt
cat header.txt body2.txt > SnpSniffer_NotExpected_Results_SharedCalls20plus.txt

#cleanup
rm a.txt b.txt c.txt d.txt e.txt f.txt g.txt header.txt body.txt body2.txt SnpSniffer_NotExpected_Results.txt

# When -expected or -NotExpect is queried a full comparison is produced to a file called snpSniffer_output.txt

sed 's/ & /\'$'\t''/g' snpSniffer_output.txt | sed 's/ count=/\'$'\t''/g' | sed 's/ match=/\'$'\t''/g' | sed 's/ ratio=/\'$'\t''/g' | sed 's/.proj.Aligned.out.sorted.md_flt//g' | sed 's/.proj.md.jr_flt//g' | awk '{print ($1 > $2) ? $0"\t"$1"_"$2 : $0"\t"$2"_"$1}' | awk '!x[$6]++' > SnpSniffer_AllPairs_Results.txt
rm snpSniffer_output.txt

cut -f1-4 SnpSniffer_AllPairs_Results.txt > a.txt
cut -f5 SnpSniffer_AllPairs_Results.txt | sed 's/hetRatio/Ratio/g' | cut -c1-5 > b.txt
cut -f6 SnpSniffer_AllPairs_Results.txt > c.txt
cut -f6 SnpSniffer_AllPairs_Results.txt | awk '{gsub("_","\t",$0); print;}' | awk '{OFS = "\t" ; print $1"_"$2, $9"_"$10, $1"_"$2"_"$3, $9"_"$10"_"$11}' > d.txt
cut -f6 SnpSniffer_AllPairs_Results.txt | awk '{gsub("_","\t",$0); print;}' | cut -f7,15 | awk '{print ($1 > $2) ? $1"_"$2 : $2"_"$1}' > e.txt
cut -f6 SnpSniffer_AllPairs_Results.txt | awk '{gsub("_","\t",$0); print;}' | cut -f6 | cut -c1 | sed 's/T/Tumor/g' | sed 's/C/Constitutional/g' > f.txt
cut -f6 SnpSniffer_AllPairs_Results.txt | awk '{gsub("_","\t",$0); print;}' | cut -f14 | cut -c1 | sed 's/T/Tumor/g' | sed 's/C/Constitutional/g' > g.txt

echo -e BAM1"\t"BAM2"\t"Shared_Calls"\t"Matching_Calls"\t"Ratio"\t"Set_Compared"\t"Patient1"\t"Patient2"\t"Visit1"\t"Visit2"\t"Assay_Pair"\t"Subgroup1"\t"Subgroup2"\t"Subgroup_Pair"\t"Patient_Pair > header.txt
paste a.txt b.txt c.txt d.txt e.txt f.txt g.txt | awk '{print ($12 > $13) ? $0"\t"$12"_"$13 : $0"\t"$13"_"$12}' | awk '{print ($7 == $8) ? $0"\t""Same" : $0"\t""Different"}' > body.txt
cat header.txt body.txt > SnpSniffer_AllPairs_Results.txt

#cleanup
rm a.txt b.txt c.txt d.txt e.txt f.txt g.txt header.txt body.txt


#HET CALLS
java -jar ${SNP_SNIFFER_JAR} -het SnpSniffer_DB.ini > temp1_HetRate_Results.txt
sed 's/.proj.Aligned.out.sorted.md_flt//g' temp1_HetRate_Results.txt | sed 's/.proj.md.jr_flt//g' > temp2_HetRate_Results.txt
awk 'NR>1' temp2_HetRate_Results.txt | cut -f1 | awk '{gsub("_","\t",$0); print;}' > temp1
cut -f7 temp1 > temp_assay
cut -f6 temp1 | cut -c1 | sed 's/T/Tumor/g' | sed 's/C/Constitutional/g' > temp_type
echo -e Source"\t"Assay > temp_header
paste temp_type temp_assay > temp_sourceAssay
cat temp_header temp_sourceAssay | awk '{OFS="\t" ; print $1, $2, $1"_"$2}' > temp_hetAddOn
cut -f1-4 temp2_HetRate_Results.txt > temp2.txt
cut -f5 temp2_HetRate_Results.txt | sed 's/hetRatio/Ratio/g' | cut -c1-5 > temp3.txt
paste temp2.txt temp3.txt temp_hetAddOn > SnpSniffer_HetRate_Results.txt
rm temp*

# Graph out results
echo Launching R
R <${SnpSniffer_Graph_R} --no-save
echo Finished R

rm Temp_*.txt
