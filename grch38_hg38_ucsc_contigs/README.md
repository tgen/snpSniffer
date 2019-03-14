This folder contains resource files and templates to support Homo sapiens GRCh38 reference genome build using UCSC style contig names

It also supports the usage of updated variant calling using samtools v1.9 or later

### Issues
* The lift-over of the defined 387 variants failed for one variant
    * Partially deleted in new:
        * chr1:206760685-206760686
* Because the database MUST be 387 variants we need to add one additional variant
    * Added the following for testing (May Update):
        * chr22 32491163