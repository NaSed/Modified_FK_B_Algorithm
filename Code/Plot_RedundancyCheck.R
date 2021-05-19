# It  plots mean of depths using line plots 
rm(list=ls())

home_path <- '/Users/nafiseh/Dropbox/'

setwd(paste(home_path, 'MONET_MetabolicNetworks/Code/MATLAB_Code/', sep =''))
data_path <- paste(home_path, "MONET_MetabolicNetworks/Results/", sep ='')
save_path <- paste(home_path, "MONET_MetabolicNetworks/Results/Figures/", sep ='')

library(ggplot2)
library(scales)

models = c('BIOMD-106','BIOMD-107', 'BIOMD-108', 'BIOMD-110',
           'BIOMD-162', 'BIOMD-163', 'BIOMD-165', 'BIOMD-166',
           'BIOMD-169', 'BIOMD-170', 'BIOMD-171', 'BIOMD-173',
           'BIOMD-048','BIOMD-089', 'BIOMD-034','BIOMD-093',
           'BIOMD-228', 'BIOMD-042', 'BIOMD-094')
colors <- c('dodgerblue2', 'darkgoldenrod1', 'mediumorchid4', 
            'sienna1','darkslategray4',
            'deeppink3', 'mediumseagreen',  
            'goldenrod1','bisque4', 'darkseagreen2','mediumpurple1')


data <- data.frame(read.csv(paste('/Users/nafiseh/Dropbox/MONET_MetabolicNetworks/Results/redundancy_Comp_chk.csv', sep=''), header=T, stringsAsFactors = T), stringsAsFactors = T)
data$Model <- gsub('0000000', '-', data$Model)

data['Redundancy_FK'] = NULL
data['Redundancy_FKR'] = NULL

library(reshape2)

# Specify id.vars: the variables to keep but not split apart on
data <- melt(data, id.vars=c("Model"))
colnames(data) <- c('Model', 'Method', 'Pair_Comparisons')



levels(data$Method)[levels(data$Method)=="Comparisons_FK"] <- "FK"
levels(data$Method)[levels(data$Method)=="Comparisons_FKR"] <- "Modified FK"


pdf(paste('/Users/nafiseh/Dropbox/MONET_MetabolicNetworks/Figures/PairComparisons.pdf', sep=''))
p <- ggplot(data, aes(x=Model, y=Pair_Comparisons, fill=Method)) +
  geom_bar(stat="identity", position=position_dodge()) +
  labs(x = "", y = "Num of pair comparisons") +
  geom_text(aes(label=Pair_Comparisons), position=position_dodge(width=0.9), size = 2.8, vjust=0.5, hjust= 1.1, angle =90)+
  scale_colour_manual(values = colors, aesthetics = c("color", "fill"))+
  # scale_y_continuous(trans='log10') +
  scale_y_log10(breaks = trans_breaks("log10", function(x) 10^x),
                labels = trans_format("log10", math_format(10^.x))) +
  scale_x_discrete(breaks=unique(data$Model),
                   labels=unique(data$Model))+
  theme(axis.text=element_text(size=14,angle =90),
        axis.title=element_text(size=16),
        legend.title = element_text(size = 14),
        legend.text = element_text(size=13))+ theme(aspect.ratio= 0.5)

print(p)  

dev.off()

