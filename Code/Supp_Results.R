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

models = sort(c('BIOMD0000000106','BIOMD0000000107', 'BIOMD0000000108', 'BIOMD0000000110',
           'BIOMD0000000162', 'BIOMD0000000163', 'BIOMD0000000165', 'BIOMD0000000166',
           'BIOMD0000000169', 'BIOMD0000000170', 'BIOMD0000000171', 'BIOMD0000000173',
           'BIOMD0000000048','BIOMD0000000089', 'BIOMD0000000034','BIOMD0000000093',
           'BIOMD0000000228', 'BIOMD0000000042', 'BIOMD0000000094'))

data2 <- data.frame(read.csv(paste('/Users/nafiseh/Dropbox/MONET_MetabolicNetworks/Results/allSettings_Measurements_Experiments.csv', sep=''), header=T, stringsAsFactors = F), stringsAsFactors = F)

GenerateName <- function(tab){
  name = NULL
  i=1
  for (i in 1:nrow(tab))
  {
    tmp = ''
    
    if (tab[i,'SplittingMethod'] == 'mostFreq')
      tmp = paste(tmp, 'F', sep='')
    
    if (tab[i,'SplittingMethod'] == 'weightedVars')
      tmp = paste(tmp, 'W', sep='')
    
    if (tab[i,'Hashing']==1)
      tmp = paste(tmp, 'H', sep='')
    
    if (tab[i,'Canonical']==1)
      tmp = paste(tmp, 'C', sep='')
    
    if (tab[i,'Shrinkage']==1)
      tmp = paste(tmp, 'S', sep='')
    
    if (tab[i,'Ordering']==1)
      tmp = paste(tmp, 'O', sep='')
    
    if (tab[i,'recentHist']==1)
      tmp = paste(tmp, 'R', sep='')
    name = c(name, tmp);
  }
  return(name)
}
methods_2 <- GenerateName(tab=data2[,2:7])
data2 <- data2[, c(1, 8:12)]
data2$Method <- methods_2


resTable <- NULL
model <- models[1]
for (model in models)
{

  ind <- which(data2$Model == model)
  dt2 <- data2[ind,]
  colnames(dt2)
  library(reshape2)
  dt3 <- melt(dt2, id = c("Model","Method"))
  colnames(dt3)[3:4] <- c("Measure", "Value")
  dt3$Measure <- as.character(dt3$Measure)
  ind <- which(dt3[,'Measure'] == "FK_calls")
  dt3[ind,'Measure'] <- "FK Calls"
  
  ind <- which(dt3[,'Measure'] == "Successful_Hashtable_Fetch")
  dt3[ind,'Measure'] <- "Hash fetch"
  
  ind <- which(dt3[,'Measure'] == "Backtracking_Counts")
  dt3[ind,'Measure'] <- "Backtrack count"
  
  ind <- which(dt3[,'Measure'] == "Backtracking_Length")
  dt3[ind,'Measure'] <- "Backtrack length"
  
  ind <- which(dt3[,'Measure'] == "Seen_Nodes")
  dt3[ind,'Measure'] <- "Seen nodes"
  
  #_____________________________________
  
  rm.indx <- newDt3 <- NULL
  measure <- dt3$Measure[2]
  for (measure in unique(dt3$Measure)){
    temp2 <- dt3[which(dt3$Measure == measure),]
    unique.vals <- unique(temp2$Value)
    i=1
    for (i in 1:length(unique.vals)){
      ind <- which(temp2$Value == unique.vals[i])
      meth <- paste(sort(temp2[ind,"Method"]), collapse = ', ')
      rm.inx <- c(rm.indx, intersect(which(dt3$Model == model), which(dt3$Value == unique.vals[i])))
      newDt3 <- rbind(newDt3, c(model, meth, measure, unique.vals[i]))
    }
  }
  #_____________________________________
  colnames(newDt3) <- colnames(dt3)
  newDt3 <- data.frame(newDt3, check.names = F, stringsAsFactors = F)
  newDt3$Value <- as.numeric(newDt3$Value)
  newDt3$Value[which(newDt3$Value==0)] <- 1 # to make it zero in log scale
  keepInd <- NULL
  for (x in newDt3$Measure){
    inds <- which(newDt3[,'Measure'] == x)
    if (length(inds)>3){
      keepInd <- unique(c(keepInd, inds[order(newDt3[inds,'Value'])][(1:2)]))
    }else
      keepInd <- unique(c(keepInd, inds))
  }
  
  resTable = rbind(resTable, newDt3[keepInd,])
}

write.csv(resTable, file=paste(data_path, "SummaryResults_FORSupplementary.csv", sep=''), row.names = FALSE)
