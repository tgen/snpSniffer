### Version Notes
This folder contains resource files and templates to support Homo sapiens T2T consortium CHM13v1.1 reference genome build using UCSC style contig names.

* The database and position files DO NOT have identical contig names
    * positions file (positions_387_t2t_chm13.txt)
        * contig names match the reference genome fasta contig names with "chr" prefixing the primary chromosome contigs
    * database file (databaseV5_t2t_chm13.ini)
        * contig names DO NOT include "chr" prefix
        * This is because the -add option seems to require that the contig names are single character strings.  To support this limitation the "geno" script produces a VCF without chr contig names even though the input targets file and input BAM have contigs with the "chr" prefix

### Changes
* Genotyping is now executed by bcftools 1.0 or later.  Removing the previous limitation that genotyping need to be done with older samtools (v0.19) mpileup and bcftools.
* Use the "geno" script in the grch38_hg38_ucsc_contigs folder

### Lift-Over
* The lift-over of the 387 variants is based on the hg38 variant list which has 1 unique variant compared to GRCh37 list
``` 
 #Lift-over using UCSC lift-over utility and T2T consortium chain files
 module load liftOver
 #Create a 1-based positions file for lift-Over from a SAMPLE output file used in Phoenix
 grep -v "#" SAMPLE.vcf | awk '{print "chr"$1":"$2"-"$2}' > snpSniffer_GRCh38_SNP.positions
 #Lift over to T2T_CHM13 coordinates
 liftOver -positions snpSniffer_GRCh38_SNP.positions /home/tgenref/homo_sapiens/liftover_files/hg38.t2t-chm13-v1.0.over.chain.gz snpSniffer_T2T_chm13_SNP.positions liftOverFails.txt
 #All 387 positions lifted over successfully
 #Create positions file needed for geno script
 cut -d"-" -f1 snpSniffer_T2T_chm13_SNP.positions | sed 's/:/ /g' > positions_387_t2t_chm13.txt
 #Create the .ini and
 echo "Sample" > databaseV5_t2t_chm13.ini
 cut -d"-" -f1 snpSniffer_T2T_chm13_SNP.positions | sed 's/chr//g' >> databaseV5_t2t_chm13.ini
```
        
### Requirements (available in user $PATH)
* java
* bcftools v1.0 or later

### Tested Enviroment
* java
    * openjdk version "1.8.0_141"
    * OpenJDK Runtime Environment (build 1.8.0_141-b16)
    * OpenJDK 64-Bit Server VM (build 25.141-b16, mixed mode)
* bcftools
    * Program: bcftools (Tools for variant calling and manipulating VCFs and BCFs)
    * Version: 1.9 (using htslib 1.9)