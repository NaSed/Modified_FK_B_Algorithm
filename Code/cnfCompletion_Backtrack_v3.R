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

data1 <- data.frame(read.csv(paste('/Users/nafiseh/Dropbox/MONET_MetabolicNetworks/Results/allSettings_CNF_Completion_Experiments.csv', sep=''), header=T, stringsAsFactors = T), stringsAsFactors = T)
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
methods_1 <- GenerateName(tab=data1[,2:7])
data1 <- data1[, c(1, 8)]
data1$Method <- methods_1
data1$Iteration <- 0
model <- models[1]
for (model in models)
{
  inds1 <- which(data1$Model == model)
  for (meth in unique(data1$Method[inds1])){
  inds <- inds1[which(data1$Method[inds1]  == meth, arr.ind = T)]
  data1$Iteration[inds] <- 1:length(inds)
  }
}

methods_2 <- GenerateName(tab=data2[,2:7])
data2 <- data2[, c(1, 8:12)]
data2$Method <- methods_2

n_methods <- length(unique(data1$Method))
shapes <-  0:(n_methods-1)

qual_col_pals = brewer.pal.info[brewer.pal.info$category == 'qual',]
colors = unlist(mapply(brewer.pal, qual_col_pals$maxcolors, rownames(qual_col_pals)))
# pie(rep(1,n_methods), col=sample(colors, n_methods))

consideredMethods <- c("F", "W", "FS", "FH", "FHC", "FO", "FOR")

inds <- which(data1$Method %in% consideredMethods)
data1 <- data1[inds,]

inds <- which(data2$Method %in% consideredMethods)
data2 <- data2[inds,]

model <- models[1]
for (model in models)
{
  ind <- which(data1$Model == model)
  dt1 <- data1[ind,]
  
  ncol(data1)
  pdf(paste('/Users/nafiseh/Dropbox/MONET_MetabolicNetworks/Figures/',  model, '_IterationBacktrack.pdf', sep=''))
  
  p1 = ggplot(dt1, aes(x=Iteration, y=CNF_Length, color=Method, shape= Method, linetype = Method)) +
    geom_line() + geom_point(size = 2) +
    labs(x = "Iteration", y = "Length of CNF") +
    scale_colour_manual(values = colors, aesthetics = c("color"))+
    scale_shape_manual(values=shapes) +  
    theme(axis.text=element_text(size=14),
          axis.title=element_text(size=16),
          legend.title = element_text(size = 14),
          legend.text = element_text(size=13))+ theme(aspect.ratio=1)
  
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
  
  # rm.indx <- newDt3 <- NULL
  # measure <- dt3$Measure[2]
  # for (measure in unique(dt3$Measure)){
  #   temp2 <- dt3[which(dt3$Measure == measure),]
  #   unique.vals <- unique(temp2$Value)
  #   i=1
  #   for (i in 1:length(unique.vals)){
  #     ind <- which(temp2$Value == unique.vals[i])
  #     meth <- paste(sort(temp2[ind,"Method"]), collapse = ', ')
  #     rm.inx <- c(rm.indx, intersect(which(dt3$Model == model), which(dt3$Value == unique.vals[i])))
  #     newDt3 <- rbind(newDt3, c(model, meth, measure, unique.vals[i]))
  #   }
  # }
  # #_____________________________________
  # colnames(newDt3) <- colnames(dt3)
  # newDt3 <- data.frame(newDt3, check.names = F, stringsAsFactors = F)
  # newDt3$Value <- as.numeric(newDt3$Value)
  # newDt3$Value[which(newDt3$Value==0)] <- 1 # to make it zero in log scale
  # 
  p2 <- ggplot(dt3, aes(x=Measure, y=Value, fill=Method)) +
    geom_bar(width = 0.8, stat="identity", position=position_dodge()) +
    labs(x = "", y = "") +
    scale_colour_manual(values = colors, aesthetics = c("color", "fill"))+
    # scale_y_continuous(trans='log10') +
    scale_y_log10(breaks = trans_breaks("log10", function(x) 10^x),
                  labels = trans_format("log10", math_format(10^.x))) +
    scale_x_discrete(breaks=unique(dt3$Measure),
                     labels=addline_format(unique(dt3$Measure)))+
    theme(axis.text=element_text(size=14,angle =30),
          axis.title=element_text(size=16),
          legend.title = element_text(size = 14),
          legend.text = element_text(size=13))+ theme(aspect.ratio=1)
  
  print(p1)
  
  print(p2)
  
  dev.off()
}

