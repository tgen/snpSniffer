#!/usr/bin/env Rscript --vanilla

# Load required modules
suppressPackageStartupMessages(require(tidyverse))
suppressPackageStartupMessages(require(optparse))

# Define Options
option_list = list(
  make_option(c("-p", "--pair_file"),
              type="character",
              default=NULL,
              help="Pairwise Comparison File from snpSniffer",
              metavar="filename"),
  make_option(c("-f", "--het_file"),
              type="character",
              default=NULL,
              help="Heterozygous Summary File from snpSniffer",
              metavar="filename")
  );

opt_parser = OptionParser(option_list=option_list);
opt = parse_args(opt_parser);

####################################
## Validate Required Options are Provided
####################################

if (is.null(opt$pair_file)){
  print_help(opt_parser)
  stop("You must provide an input file to -p/--pair_file", call.=FALSE)
}

if (is.null(opt$het_file)){
  print_help(opt_parser)
  stop("You must provide an input file -h/--het_file", call.=FALSE)
}

####################################
## Import Data Tables
####################################

### Import pair comparison data table
all_pairs <- read_tsv(opt$pair_file, col_names = c("BAM1", "BAM2", "Shared_Calls", "Matching_Calls", "Match_Ratio", "Ordered_Pair"))

# Add required columns
all_pairs <- all_pairs %>% 
  separate(Ordered_Pair, c("File1", "File2"), sep = "-", remove = FALSE) %>% 
  separate(File1, c("Study1", "Patient1", "Visit1", "Source1", "Fraction1", "Increment1", "Assay1"), sep = "_", remove = FALSE) %>% 
  unite(PatientID1, c("Study1", "Patient1"), sep = "_", remove = FALSE) %>% 
  unite(VisitID1, c("Study1", "Patient1", "Visit1"), sep = "_", remove = TRUE) %>% 
  separate(File2, c("Study2", "Patient2", "Visit2", "Source2", "Fraction2", "Increment2", "Assay2"), sep = "_", remove = FALSE) %>% 
  unite(PatientID2, c("Study2", "Patient2"), sep = "_", remove = FALSE) %>% 
  unite(VisitID2, c("Study2", "Patient2", "Visit2"), sep = "_", remove = TRUE) %>% 
  mutate(Assay_Pair = if_else(Assay1 < Assay2, paste(Assay1, Assay2, sep = "-"), paste(Assay2, Assay1, sep = "-"), "Fail")) %>% 
  mutate(Subgroup1 = case_when(str_detect(Increment1, "C") ~ "Constitutional", 
                               str_detect(Increment1, "T") ~ "Tumor", 
                               TRUE ~ "Other")) %>% 
  mutate(Subgroup2 = case_when(str_detect(Increment2, "C") ~ "Constitutional", 
                               str_detect(Increment2, "T") ~ "Tumor", 
                               TRUE ~ "Other")) %>% 
  mutate(Subgroup_Pair = case_when(Subgroup1 == "Constitutional" & Subgroup2 == "Constitutional" ~ "Constitutional-Constitutional", 
                                   Subgroup1 == "Constitutional" & Subgroup2 == "Tumor" ~ "Constitutional-Tumor", 
                                   Subgroup1 == "Tumor" & Subgroup2 == "Constitutional" ~ "Constitutional-Tumor", 
                                   Subgroup1 == "Tumor" & Subgroup2 == "Tumor" ~ "Tumor-Tumor", 
                                   TRUE ~ "Other")) %>%
  mutate(Patient_Pair = if_else(PatientID1 == PatientID2, "Same", "Different", "NA"))

# Create final table to match historic table
all_pairs <- all_pairs %>% 
  select(File1, File2, Shared_Calls, Matching_Calls, Match_Ratio, Ordered_Pair, 
         PatientID1, PatientID2, VisitID1, VisitID2, 
         Assay_Pair, Subgroup1, Subgroup2, Subgroup_Pair, Patient_Pair)

# Save summarized pair table
write_tsv(all_pairs, "SnpSniffer_AllPairs_Summary.tsv")


### Import heterozygous rate data table
het_data <- read_tsv(opt$pair_file, col_names = c("Sample", "Homozygous", "Heterozygous", "Total", "Het_Ratio"))

# Add columns to summarize by Assay and Subgroup
het_data <- het_data %>% 
  separate(Sample, c("Study", "Patient", "Visit", "Source", "Fraction", "Increment", "Assay"), sep = "_", remove = FALSE) %>% 
  mutate(Subgroup = case_when(str_detect(Increment, "C") ~ "Constitutional", 
                              str_detect(Increment, "T") ~ "Tumor", 
                              TRUE ~ "Other")) %>% 
  select(-c(Study, Patient, Visit, Source, Fraction, Increment))

###################################
##  Define Graph Functions
###################################

matchRatio_pairType_Plot <- function(data, output_name) {
  #Generate Box Plot of Match Ratio by Patient Pair
  ggplot(data, aes(Patient_Pair, Match_Ratio)) + 
    geom_boxplot( outlier.shape = NA, size = 1 ) + 
    geom_jitter(aes(colour = Shared_Calls), width = 0.365) + 
    scale_y_continuous(name = "Percent Matching Calls", breaks = c(0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1.0)) + 
    xlab(label = "Expected Genotype Comparison") + 
    scale_color_gradientn(aes(color = Shared_Calls), 
                          limits = c(0,400), 
                          breaks = c(seq(0,400,50)), 
                          colors = rainbow(7), 
                          na.value = "black", 
                          guide = guide_colorbar(title = "Shared Calls")) +
    theme(axis.text = element_text(size=12), 
          axis.title = element_text(size=16), 
          axis.text.x = element_text(angle=45, hjust = 1))
  image_name <- paste("SnpSniffer_MatchRatio_ByPatientPairType_", output_name, ".png", sep = "")
  ggsave(file = image_name)
}

matchRatio_assayPair_Plot <- function(data, output_name) {
  #Generate Box Plot of Match Ratio by Assay Pair
  ggplot(data, aes(Assay_Pair, Match_Ratio)) + 
    geom_boxplot(outlier.shape = NA, size = 1 ) + 
    geom_jitter(aes(colour = Shared_Calls), width = 0.365) + 
    scale_y_continuous(name = "Percent Matching Calls", breaks = c(0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1.0)) + 
    xlab(label = "Assay Pair") + 
    scale_color_gradientn(aes(color = Shared_Calls), 
                          limits = c(0,400), 
                          breaks = c(seq(0,400,50)), 
                          colors = rainbow(7), 
                          na.value = "black", 
                          guide = guide_colorbar(title = "Shared Calls")) +
    theme(axis.text = element_text(size=12), 
          axis.title = element_text(size=16), 
          axis.text.x = element_text(angle=45, hjust = 1))
  image_name <- paste("SnpSniffer_MatchRatio_ByAssayPairType_", output_name, ".png", sep = "")
  ggsave(file = image_name)
}


hetRate_assayType_Plot <- function(data, output_name) {
  #Generate Box Plot of Match Ratio by Assay Pair
  ggplot(data, aes(Assay, Het_Ratio)) + 
    geom_boxplot(outlier.shape = NA, size = 1 ) + 
    geom_jitter(aes(colour = Total), width = 0.365) + 
    scale_y_continuous(name = "Heterozygous Rate", breaks = c(0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1.0)) + 
    xlab(label = "Assay") + 
    scale_color_gradientn(aes(color = Total), 
                          limits = c(0,400), 
                          breaks = c(seq(0,400,50)), 
                          colors = rainbow(7), 
                          na.value = "black", 
                          guide = guide_colorbar(title = "Genotypes")) +
    theme(axis.text = element_text(size=12), 
          axis.title = element_text(size=16), 
          axis.text.x = element_text(angle=45, hjust = 1))
  image_name <- paste("SnpSniffer_HetRate_ByAssayType_", output_name, ".png", sep = "")
  ggsave(file = image_name)
}

genotypes_assayType_Plot <- function(data, output_name) {
  #Generate Box Plot of Match Ratio by Assay Pair
  ggplot(data, aes(Assay, Total)) + 
    geom_boxplot(outlier.shape = NA, size = 1 ) + 
    geom_jitter(color = "black", width = 0.365) + 
    geom_hline(yintercept = 382, color = "red", linetype = "dashed") +
    scale_y_continuous(name = "Total Genotypes", breaks = c(seq(0,400,25))) + 
    xlab(label = "Assay") + 
    theme(axis.text = element_text(size=12), 
          axis.title = element_text(size=16), 
          axis.text.x = element_text(angle=45, hjust = 1))
  image_name <- paste("SnpSniffer_Genotypes_ByAssayType_", output_name, ".png", sep = "")
  ggsave(file = image_name)
}

###################################
##  Graph Summary
###################################

# Generate plots for full data table
matchRatio_pairType_Plot(all_pairs, "All")
matchRatio_assayPair_Plot(all_pairs, "All")

# Generate plots for samples with at least 100 Shared Calls
above100 <- all_pairs %>% filter(Shared_Calls >= 100)
matchRatio_pairType_Plot(above100, "SharedCalls100plus")
matchRatio_assayPair_Plot(above100, "SharedCalls100plus")

# Generate plots for samples with at least 50 Shared Calls
above50 <- all_pairs %>% filter(Shared_Calls >= 50)
matchRatio_pairType_Plot(above50, "SharedCalls50plus")
matchRatio_assayPair_Plot(above50, "SharedCalls50plus")

# Generate plots for samples with at least 50 Shared Calls
above20 <- all_pairs %>% filter(Shared_Calls >= 20)
matchRatio_pairType_Plot(above20, "SharedCalls20plus")
matchRatio_assayPair_Plot(above20, "SharedCalls20plus")

hetRate_assayType_Plot(het_data, "All")
genotypes_assayType_Plot(het_data, "All")