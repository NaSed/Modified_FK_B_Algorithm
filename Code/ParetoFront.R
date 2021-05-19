
rm(list=ls())

home_path <- '/Users/nafiseh/Dropbox/'

setwd(paste(home_path, 'MONET_MetabolicNetworks/Code/MATLAB_Code/', sep =''))
data_path <- paste(home_path, "MONET_MetabolicNetworks/Results/", sep ='')
save_path <- paste(home_path, "MONET_MetabolicNetworks/Results/Figures/", sep ='')
library(scales)
library(ggplot2)
library(stringr)
# library(cowplot)
addline_format <- function(x,...){
  gsub('\\s','\n',x)
}

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

models = sort(c('BIOMD0000000106','BIOMD0000000107', 'BIOMD0000000108', 'BIOMD0000000110',
                'BIOMD0000000162', 'BIOMD0000000163', 'BIOMD0000000165', 'BIOMD0000000166',
                'BIOMD0000000169', 'BIOMD0000000170', 'BIOMD0000000171', 'BIOMD0000000173',
                'BIOMD0000000048','BIOMD0000000089', 'BIOMD0000000034','BIOMD0000000093',
                'BIOMD0000000228', 'BIOMD0000000042', 'BIOMD0000000094'))

data <- data.frame(read.csv(paste('/Users/nafiseh/Dropbox/MONET_MetabolicNetworks/Results/allSettings_Measurements_Experiments.csv', sep=''), 
                            header=T, stringsAsFactors = F), stringsAsFactors = F)


############################################################
SummaryTab <- NULL
for (i in models){
  subTable <- data[which(data$Model == i),]
  
  temp <- subTable
  temp$Canonical = temp$Canonical * 0
  temp <- temp[!duplicated(temp),]
  if (nrow(temp) < nrow(subTable))
    subTable <- subTable[subTable$Canonical==0,]
  
  
  temp <- subTable
  temp$recentHist = temp$recentHist * 0
  temp <- temp[!duplicated(temp),]
  if (nrow(temp) < nrow(subTable))
    subTable <- subTable[subTable$recentHist==0,]
  
  temp <- subTable
  temp$Ordering = temp$Ordering * 0
  temp <- temp[!duplicated(temp),]
  if (nrow(temp) < nrow(subTable))
    subTable <- subTable[subTable$Ordering==0,]
  
  temp <- subTable
  temp$Hashing = temp$Hashing * 0
  temp <- temp[!duplicated(temp),]
  if (nrow(temp) < nrow(subTable))
    subTable <- subTable[subTable$Hashing==0,]
  
  
  SummaryTab <- rbind(SummaryTab, subTable)
}

SummaryTab$SplittingMethod <- 1*(SummaryTab$SplittingMethod == "weightedVars")
colnames(SummaryTab)
dt <- SummaryTab[,c(2,3,5,6,8)]
pc.cr <- prcomp(~ SplittingMethod + Hashing + Shrinkage,
                data = dt, cor = TRUE)

library(MASS)
r3 <- lda(FK_calls ~ ., # training model
          dt)
#############################################################
# For minimizing FK calls
#############################################################
Calls.Tab <- NULL
for (i in models){
  subTable <- data[which(data$Model == i),]
  subTable <- subTable[which(subTable$FK_calls == min(subTable$FK_calls)),]
  
  temp <- subTable
  temp$Canonical = temp$Canonical * 0
  temp <- temp[!duplicated(temp),]
  if (nrow(temp) < nrow(subTable))
    subTable <- subTable[subTable$Canonical==0,]
  
  
  temp <- subTable
  temp$recentHist = temp$recentHist * 0
  temp <- temp[!duplicated(temp),]
  if (nrow(temp) < nrow(subTable))
    subTable <- subTable[subTable$recentHist==0,]
  
  temp <- subTable
  temp$Ordering = temp$Ordering * 0
  temp <- temp[!duplicated(temp),]
  if (nrow(temp) < nrow(subTable))
    subTable <- subTable[subTable$Ordering==0,]
  
  temp <- subTable
  temp$Hashing = temp$Hashing * 0
  temp <- temp[!duplicated(temp),]
  if (nrow(temp) < nrow(subTable))
    subTable <- subTable[subTable$Hashing==0,]
  
  
  Calls.Tab <- rbind(Calls.Tab, subTable)
}

Calls.Tab$Method <- GenerateName(tab=Calls.Tab[,2:7])
Calls.Tab[,2:7] <- NULL

#############################################################
# For minimizing backtracking length
#############################################################
BackLen.Tab <- NULL
for (i in models){
  subTable <- data[which(data$Model == i),]
  subTable <- subTable[which(subTable$Backtracking_Length == min(subTable$Backtracking_Length)),]
  
  temp <- subTable
  temp$Canonical = temp$Canonical * 0
  temp <- temp[!duplicated(temp),]
  if (nrow(temp) < nrow(subTable))
    subTable <- subTable[subTable$Canonical==0,]
  
  
  temp <- subTable
  temp$recentHist = temp$recentHist * 0
  temp <- temp[!duplicated(temp),]
  if (nrow(temp) < nrow(subTable))
    subTable <- subTable[subTable$recentHist==0,]
  
  temp <- subTable
  temp$Ordering = temp$Ordering * 0
  temp <- temp[!duplicated(temp),]
  if (nrow(temp) < nrow(subTable))
    subTable <- subTable[subTable$Ordering==0,]
  
  temp <- subTable
  temp$Hashing = temp$Hashing * 0
  temp <- temp[!duplicated(temp),]
  if (nrow(temp) < nrow(subTable))
    subTable <- subTable[subTable$Hashing==0,]
  subTable <- subTable[which(subTable$FK_calls == min(subTable$FK_calls)),]
  
  BackLen.Tab <- rbind(BackLen.Tab, subTable)
}

BackLen.Tab$Method <- GenerateName(tab=BackLen.Tab[,2:7])
BackLen.Tab[,2:7] <- NULL


#############################################################
# For minimizing seen nodes
#############################################################
SeenNode.Tab <- NULL
for (i in models){
  subTable <- data[which(data$Model == i),]
  subTable <- subTable[which(subTable$Seen_Nodes == min(subTable$Seen_Nodes)),]
  
  temp <- subTable
  temp$Canonical = temp$Canonical * 0
  temp <- temp[!duplicated(temp),]
  if (nrow(temp) < nrow(subTable))
    subTable <- subTable[subTable$Canonical==0,]
  
  
  temp <- subTable
  temp$recentHist = temp$recentHist * 0
  temp <- temp[!duplicated(temp),]
  if (nrow(temp) < nrow(subTable))
    subTable <- subTable[subTable$recentHist==0,]
  
  temp <- subTable
  temp$Ordering = temp$Ordering * 0
  temp <- temp[!duplicated(temp),]
  if (nrow(temp) < nrow(subTable))
    subTable <- subTable[subTable$Ordering==0,]
  
  temp <- subTable
  temp$Hashing = temp$Hashing * 0
  temp <- temp[!duplicated(temp),]
  if (nrow(temp) < nrow(subTable))
    subTable <- subTable[subTable$Hashing==0,]
  subTable <- subTable[which(subTable$FK_calls == min(subTable$FK_calls)),]
  
  SeenNode.Tab <- rbind(SeenNode.Tab, subTable)
}


SeenNode.Tab$Method <- GenerateName(tab=SeenNode.Tab[,2:7])
SeenNode.Tab[,2:7] <- NULL

############################################################
all(Calls.Tab$Model== SeenNode.Tab$Model)

write.csv(Calls.Tab, file = paste(data_path, 'MinimumFKcalls.csv', sep=''), row.names = F)
write.csv(BackLen.Tab, file = paste(data_path, 'MinimumBacktrackingLen.csv', sep=''), row.names = F)
write.csv(SeenNode.Tab, file = paste(data_path, 'MinimumSeenNodes.csv', sep=''), row.names = F)




alltogether <- cbind(Calls.Tab$Model, Calls.Tab$Method, BackLen.Tab$Method ,SeenNode.Tab$Method)
commonModifications <- unlist(sapply(seq(1,nrow(alltogether)), function(x){ tmp = paste(alltogether[x,2:4], sep='', collapse='')
chars <- c('F','H','W','S','C')
paste(chars[which(str_count(tmp, chars) == 3)], sep='', collapse = '')
}))
alltogether <- cbind(alltogether, commonModifications)
colnames(alltogether) <- c('Model', 'Minimum FK calls', 'Minimum Backtracking Length', 'Minimum Seen Nodes', 'Common
modification')

write.csv(alltogether, file = paste(data_path, 'CommonModifications.csv', sep=''), row.names = F)

