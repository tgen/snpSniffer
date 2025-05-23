# Create input BED file for UCSC LiftOver web tool
awk -F"\t" '{start=$2-1} {print $1,start,$2}' OFS="\t" ../CanFam3_1_default_contigs/positions_394_CanFam3_1.txt > positions_394_CanFam3_1.bed

# Upload to UCSC LiftOver
https://genome.ucsc.edu/cgi-bin/hgLiftOver
Output: ucsc_hgLiftOver_canfam4.bed

# UCSC LiftOver Output Log
ucsc_hgliftover_canfam3_1_to_canfam4_log.txt
Note: One position failed conversion

# Create positions file
awk -F"\t" '{print $1,$3}' OFS="\t" ucsc_hgLiftOver_canfam4.bed | sed "s/chr//g" > positions_393_CanFam4.txt

# Create database ini file
awk -F"\t" 'BEGIN{print "Sample"} ; {print $1,$3}' OFS=":" ucsc_hgLiftOver_canfam4.bed | sed "s/chr//g" > databaseV6_CanFam4_ucsc.ini

