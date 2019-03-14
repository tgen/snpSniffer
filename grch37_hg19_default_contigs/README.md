### Version Notes
This folder contains resource files and templates to support Homo sapiens GRCh37 reference genome build (hs37d5).

* The database and position files have identical contig names
    * positions file (positions_387_hg19.txt)
    * database file (databaseV5.ini)

### Changes
* Genotyping is now executed by bcftools 1.0 or later.  Removing the previous limitation that genotyping need to be done with older samtools (v0.19) mpileup and bcftools.
        
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