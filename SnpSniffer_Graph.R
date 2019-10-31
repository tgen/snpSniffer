#Load the ggplot library
library(ggplot2)

rescale_gradient <- function(values, limits=c(0,400), break_minor=50, colors=rainbow(7), legend_title="Shared_Genotype"){
  return( scale_color_gradientn(aes(colour = values), limits = limits, breaks=c(seq(limits[1],limits[2],break_minor)), colors = colors, na.value = "black", guide = guide_colorbar(title = legend_title )))
}
## Jitter width values
jw = 0.365



#####
##
##  ALL
##
#####

#Read in the AllPairs Table
All <- read.table("SnpSniffer_AllPairs_Results.txt", header=T)

#Generate Box Plot of Match Ratio by Patient Pair
ggplot(All, aes(factor(Patient_Pair), Ratio)) + geom_boxplot( outlier.shape = NA, size = 1 ) + geom_jitter(aes(colour = Shared_Calls), width=jw) + ylab(label = "Percent Matching Calls") + xlab(label = "Patient Pair") + theme(axis.text = element_text(size=12), axis.title = element_text(size=16)) + theme(axis.text.x = element_text(angle=45, hjust = 1)) + rescale_gradient(Shared_Calls)
ggsave(file="SnpSniffer_MatchRatio_ByPatientPairType_All.png")


#Generate Box Plot of Match Ratio by Assay Pair
ggplot(All, aes(factor(Assay_Pair), Ratio)) + geom_boxplot( outlier.shape = NA, size = 1 ) + geom_jitter(aes(colour = Shared_Calls), width=jw) + ylab(label = "Percent Matching Calls") + xlab(label = "Patient Pair") + theme(axis.text = element_text(size=12), axis.title = element_text(size=16)) + theme(axis.text.x = element_text(angle=45, hjust = 1)) + rescale_gradient(Shared_Calls)
ggsave(file="SnpSniffer_MatchRatio_ByAssayPairType_All.png")


#SUBSET ABOVE SHARED CALLS = 100
ALL_Above100 <- subset(All, Shared_Calls >= 100)
#Generate Box Plot of Match Ratio by Patient Pair
ggplot(ALL_Above100, aes(factor(Patient_Pair), Ratio)) + geom_boxplot( outlier.shape = NA, size = 1 ) + geom_jitter(aes(colour = Shared_Calls), width=jw) + ylab(label = "Percent Matching Calls") + xlab(label = "Patient Pair") + theme(axis.text = element_text(size=12), axis.title = element_text(size=16)) + theme(axis.text.x = element_text(angle=45, hjust = 1)) + rescale_gradient(Shared_Calls)
ggsave(file="SnpSniffer_MatchRatio_ByPatientPairType_SharedCalls100plus.png")

#Generate Box Plot of Match Ratio by Assay Pair
ggplot(ALL_Above100, aes(factor(Assay_Pair), Ratio)) + geom_boxplot( outlier.shape = NA, size = 1 ) + geom_jitter(aes(colour = Shared_Calls), width=jw) + ylab(label = "Percent Matching Calls") + xlab(label = "Patient Pair") + theme(axis.text = element_text(size=12), axis.title = element_text(size=16)) + theme(axis.text.x = element_text(angle=45, hjust = 1)) + rescale_gradient(Shared_Calls)
ggsave(file="SnpSniffer_MatchRatio_ByAssayPairType_SharedCalls100plus.png")


#SUBSET ABOVE SHARED CALLS = 50
ALL_Above50 <- subset(All, Shared_Calls >= 50)
#Generate Box Plot of Match Ratio by Patient Pair
ggplot(ALL_Above50, aes(factor(Patient_Pair), Ratio)) + geom_boxplot( outlier.shape = NA, size = 1 ) + geom_jitter(aes(colour = Shared_Calls), width=jw) + ylab(label = "Percent Matching Calls") + xlab(label = "Patient Pair") + theme(axis.text = element_text(size=12), axis.title = element_text(size=16)) + theme(axis.text.x = element_text(angle=45, hjust = 1)) + rescale_gradient(Shared_Calls)
ggsave(file="SnpSniffer_MatchRatio_ByPatientPairType_SharedCalls50plus.png")

#Generate Box Plot of Match Ratio by Assay Pair
ggplot(ALL_Above50, aes(factor(Assay_Pair), Ratio)) + geom_boxplot( outlier.shape = NA, size = 1 ) + geom_jitter(aes(colour = Shared_Calls), width=jw) + ylab(label = "Percent Matching Calls") + xlab(label = "Patient Pair") + theme(axis.text = element_text(size=12), axis.title = element_text(size=16)) + theme(axis.text.x = element_text(angle=45, hjust = 1)) + rescale_gradient(Shared_Calls)
ggsave(file="SnpSniffer_MatchRatio_ByAssayPairType_SharedCalls50plus.png")


#SUBSET ABOVE SHARED CALLS = 20
ALL_Above20 <- subset(All, Shared_Calls >= 20)
#Generate Box Plot of Match Ratio by Patient Pair
ggplot(ALL_Above20, aes(factor(Patient_Pair), Ratio)) + geom_boxplot( outlier.shape = NA, size = 1 ) + geom_jitter(aes(colour = Shared_Calls), width=jw) + ylab(label = "Percent Matching Calls") + xlab(label = "Patient Pair") + theme(axis.text = element_text(size=12), axis.title = element_text(size=16)) + theme(axis.text.x = element_text(angle=45, hjust = 1)) + rescale_gradient(Shared_Calls)
ggsave(file="SnpSniffer_MatchRatio_ByPatientPairType_SharedCalls20plus.png")

#Generate Box Plot of Match Ratio by Assay Pair
ggplot(ALL_Above50, aes(factor(Assay_Pair), Ratio)) + geom_boxplot( outlier.shape = NA, size = 1 ) + geom_jitter(aes(colour = Shared_Calls), width=jw) + ylab(label = "Percent Matching Calls") + xlab(label = "Patient Pair") + theme(axis.text = element_text(size=12), axis.title = element_text(size=16)) + theme(axis.text.x = element_text(angle=45, hjust = 1)) + rescale_gradient(Shared_Calls)
ggsave(file="SnpSniffer_MatchRatio_ByAssayPairType_SharedCalls20plus.png")



#####
##
##  HETS
##
#####


#Read in the hets table
Hets <- read.table("SnpSniffer_HetRate_Results.txt", header=T)

#Generate Box Plot of Het Frequency by assay
ggplot(Hets, aes(factor(Assay), Ratio)) + geom_boxplot( outlier.shape = NA, size = 1 ) + geom_jitter(aes(colour = Total), width=jw) + ylab(label = "Percent Heterozygous") + xlab(label = "Assay Tag") + theme(axis.text = element_text(size=12), axis.title = element_text(size=16)) + theme(axis.text.x = element_text(angle=45, hjust = 1)) + rescale_gradient(Total)
ggsave(file="SnpSniffer_HetsByAssay_All.png")

#Generate Box Plot of Het Fequency by Source and Assay
ggplot(Hets, aes(factor(Source_Assay), Ratio)) + geom_boxplot( outlier.shape = NA ) + geom_jitter(aes(colour = Total), width=jw) + ylab(label = "Percent Heterozygous") + xlab(label = "Source and Assay Tag") + theme(axis.text = element_text(size=12), axis.title = element_text(size=16)) + theme(axis.text.x = element_text(angle=45, hjust = 1)) + rescale_gradient(Total)
ggsave(file="SnpSniffer_HetsBySourceAssay_All.png")


#SUBSET ABOVE SHARED CALLS = 100
Hets_Above100 <- subset(Hets, Total >= 100)
#Generate Box Plot of Het Frequency by assay
ggplot(Hets_Above100, aes(factor(Assay), Ratio)) + geom_boxplot( outlier.shape = NA, size = 1 ) + geom_jitter(aes(colour = Total), width=jw) + ylab(label = "Percent Heterozygous") + xlab(label = "Assay Tag") + theme(axis.text = element_text(size=12), axis.title = element_text(size=16)) + theme(axis.text.x = element_text(angle=45, hjust = 1)) + rescale_gradient(Total)
ggsave(file="SnpSniffer_HetsByAssay_TotalCalls100plus.png")

#Generate Box Plot of Het Fequency by Source and Assay
ggplot(Hets_Above100, aes(factor(Source_Assay), Ratio)) + geom_boxplot( outlier.shape = NA, size = 1 ) + geom_jitter(aes(colour = Total), width=jw) + ylab(label = "Percent Heterozygous") + xlab(label = "Source and Assay Tag") + theme(axis.text = element_text(size=12), axis.title = element_text(size=16)) + theme(axis.text.x = element_text(angle=45, hjust = 1)) + rescale_gradient(Total)
ggsave(file="SnpSniffer_HetsBySourceAssay_TotalCalls100plus.png")


#SUBSET ABOVE SHARED CALLS = 50
Hets_Above50 <- subset(Hets, Total >= 50)
#Generate Box Plot of Het Frequency by assay
ggplot(Hets_Above50, aes(factor(Assay), Ratio)) + geom_boxplot( outlier.shape = NA, size = 1 ) + geom_jitter(aes(colour = Total), width=jw) + ylab(label = "Percent Heterozygous") + xlab(label = "Assay Tag") + theme(axis.text = element_text(size=12), axis.title = element_text(size=16)) + theme(axis.text.x = element_text(angle=45, hjust = 1)) + rescale_gradient(Total)
ggsave(file="SnpSniffer_HetsByAssay_TotalCalls50plus.png")

#Generate Box Plot of Het Fequency by Source and Assay
ggplot(Hets_Above50, aes(factor(Source_Assay), Ratio)) + geom_boxplot( outlier.shape = NA, size = 1 ) + geom_jitter(aes(colour = Total), width=jw) + ylab(label = "Percent Heterozygous") + xlab(label = "Source and Assay Tag") + theme(axis.text = element_text(size=12), axis.title = element_text(size=16)) + theme(axis.text.x = element_text(angle=45, hjust = 1)) + rescale_gradient(Total)
ggsave(file="SnpSniffer_HetsBySourceAssay_TotalCalls50plus.png")


#SUBSET ABOVE SHARED CALLS = 20
Hets_Above20 <- subset(Hets, Total >= 20)
#Generate Box Plot of Het Frequency by assay
ggplot(Hets_Above20, aes(factor(Assay), Ratio)) + geom_boxplot( outlier.shape = NA, size = 1 ) + geom_jitter(aes(colour = Total), width=jw) + ylab(label = "Percent Heterozygous") + xlab(label = "Assay Tag") + theme(axis.text = element_text(size=12), axis.title = element_text(size=16)) + theme(axis.text.x = element_text(angle=45, hjust = 1)) + rescale_gradient(Total)
ggsave(file="SnpSniffer_HetsByAssay_TotalCalls20plus.png")

#Generate Box Plot of Het Fequency by Source and Assay
ggplot(Hets_Above20, aes(factor(Source_Assay), Ratio)) + geom_boxplot( outlier.shape = NA, size = 1 ) + geom_jitter(aes(colour = Total), width=jw) + ylab(label = "Percent Heterozygous") + xlab(label = "Source and Assay Tag") + theme(axis.text = element_text(size=12), axis.title = element_text(size=16)) + theme(axis.text.x = element_text(angle=45, hjust = 1)) + rescale_gradient(Total)
ggsave(file="SnpSniffer_HetsBySourceAssay_TotalCalls20plus.png")


#Quit R Session
q()
