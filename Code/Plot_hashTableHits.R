# It  plots cnf completion analysis plots
# It plots all models in one plot and generates a plot per measure
rm(list=ls())

home_path <- '/Users/nafiseh/Dropbox/'

setwd(paste(home_path, 'MONET_MetabolicNetworks/Code/MATLAB_Code/', sep =''))
data_path <- paste(home_path, "MONET_MetabolicNetworks/Results/", sep ='')
save_path <- paste(home_path, "MONET_MetabolicNetworks/Results/Figures/", sep ='')
library(scales)
library(ggplot2)
library(RColorBrewer)
library(stringr)
# library(cowplot)

addline_format <- function(x,...){
  gsub('\\s','\n',x)
}

models = c('BIOMD0000000106','BIOMD0000000107', 'BIOMD0000000108', 'BIOMD0000000110',
           'BIOMD0000000162', 'BIOMD0000000163', 'BIOMD0000000165', 'BIOMD0000000166',
           'BIOMD0000000169', 'BIOMD0000000170', 'BIOMD0000000171', 'BIOMD0000000173',
           'BIOMD0000000048','BIOMD0000000089', 'BIOMD0000000034','BIOMD0000000093',
           'BIOMD0000000228', 'BIOMD0000000042', 'BIOMD0000000094')

data <- data.frame(read.csv(paste('/Users/nafiseh/Dropbox/MONET_MetabolicNetworks/Results/allSettings_HashTableHits.csv', sep=''), header=T, stringsAsFactors = T), stringsAsFactors = T)

GenerateName <- function(tab){
  paste('tab', tab)
  name = NULL
  i=1
  tmp = ''
  
  if (tab['SplittingMethod'] == 'mostFreq')
    tmp = paste(tmp, 'F', sep='')
  
  if (tab['SplittingMethod'] == 'weightedVars')
    tmp = paste(tmp, 'W', sep='')
  
  if (tab['Hashing']==1)
    tmp = paste(tmp, 'H', sep='')
  
  if (tab['Canonical']==1)
    tmp = paste(tmp, 'C', sep='')
  
  if (tab['Shrinkage']==1)
    tmp = paste(tmp, 'S', sep='')
  
  if (tab['Ordering']==1)
    tmp = paste(tmp, 'O', sep='')
  
  if (tab['recentHist']==1)
    tmp = paste(tmp, 'R', sep='')
  name = c(name, tmp);
  
  return(name)
}
methods <- apply(data[,c(2:7)], 1, GenerateName)

data <- data[, c(1, 8, 9, 10)]
data$Method <- methods
data$hashInd <- 0
model <- models[1]
for (model in models)
{
  inds1 <- which(data$Model == model)
  for (meth in unique(data$Method[inds1])){
    inds <- inds1[which(data$Method[inds1]  == meth, arr.ind = T)]
    data$hashInd[inds] <- 1:length(inds)
  }
}


n_methods <- length(unique(data$Method))
shapes <-  0:(n_methods-1)

data$label <- paste(data$CNF_Length, data$DNF_Length, sep='+')
data$label[data$NumofHits == 0] <- ''


data <- data[is.element(data$Method, c('FH', 'FHC')),]
# data <- data[(data$NumofHits !=0),]

for (model in unique(data$Model)){
  pdf(paste('/Users/nafiseh/Dropbox/MONET_MetabolicNetworks/Figures/',  model, '_HashTableHit.pdf', sep=''))
  
  tmp <- data[(data$Model == model & data$NumofHits !=0),]
  hashSize <- c(max(data[(data$Model == model  & data$Method == 'FH'), 'hashInd']), max(data[(data$Model == model  & data$Method == 'FHC'), 'hashInd']))
  # if !all(data$label[data$Method == 'FH'] == data$label[data$Method == 'FHC'])
  #   stopxx 
  tmp$hashInd <- factor(tmp$hashInd)
  
  
  p <- ggplot(tmp, aes(x=hashInd, y=NumofHits, label=label, group=Method, fill=Method)) +
    geom_bar(stat="identity", position=position_dodge(), width = 0.4) +
    labs(x = 'Hash table indices', y = "Number of hits") +
    geom_text(position=position_dodge(width=0.4), size = 3, vjust=0.2, hjust= 1.3, angle = 90, color='black') +
    theme(axis.text=element_text(size=14,angle =90),
          axis.title=element_text(size=16),
          legend.title = element_text(size = 14),
          legend.text = element_text(size=13))+ theme(aspect.ratio= 0.5)+
    ggtitle(paste('Hash table size = ', hashSize, sep='')) +
    theme(plot.title = element_text(vjust = - 10, hjust = 0.1))
  
  print(p)  
  dev.off()
  
}


