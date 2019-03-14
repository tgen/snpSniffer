### Version Notes
This folder contains resource files and templates to support Homo sapiens GRCh38 reference genome build using UCSC style contig names.

* The database and position files DO NOT have identical contig names
    * positions file (positions_387_hg38_ucsc.txt)
        * contig names match the reference genome fasta contig names with "chr" prefixing the primary chromosome contigs
    * database file (databaseV5_hg38_ucsc.ini)
        * contig names DO NOT include "chr" prefix
        * This is because the -add option seems to require that the contig names are single character strings.  To support this limitation the "geno" script produces a VCF without chr contig names even though the input targets file and input BAM have contigs with the "chr" prefix

### Changes
* Genotyping is now executed by bcftools 1.0 or later.  Removing the previous limitation that genotyping need to be done with older samtools (v0.19) mpileup and bcftools.


### Issues
* The lift-over of the defined 387 variants failed for one variant
    * Partially deleted in new:
        * chr1:206760685-206760686
* Because the database MUST be 387 variants we need to add one additional variant
    * Added the following for testing (Might Update in future):
        * chr22 32491163
        
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