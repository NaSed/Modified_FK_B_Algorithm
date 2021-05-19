# It  plots 
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


data <- data.frame(read.csv(paste('/Users/nafiseh/Dropbox/MONET_MetabolicNetworks/Results/FK_FKM_CNF_Completion_Experiments.csv', sep=''), header=T, stringsAsFactors = F), stringsAsFactors = F)

data$Method[data$Method =='FKM'] <- 'Modified FK'

data$Model <- gsub('0000000', '-', data$Model)
data$Iteration <- 0
model <- models[1]
for (model in data$Model)
{
  inds1 <- which(data$Model == model)
  for (meth in unique(data$Method[inds1])){
    inds <- inds1[which(data$Method[inds1]  == meth, arr.ind = T)]
    data$Iteration[inds] <- 1:length(inds)
  }
}

#++++++++++++++++++++++++++++++++++++
#   Create another table for bar chart
#++++++++++++++++++++++++++++++++++++

barData <- data.frame()
for (model in models){
  ind <- which(data$Model == model)
  dt <- data[ind,]
  
  for (meth in unique(data$Method)){
    barData <- rbind(barData, cbind(model, meth, as.numeric(max(dt[which(dt$Method == meth),]$Iteration))))
  }
}
colnames(barData) <- c('Model', 'Method', 'Iteration')
barData$Iteration <- as.numeric(as.character(barData$Iteration))
pdf(paste('/Users/nafiseh/Dropbox/MONET_MetabolicNetworks/Figures/MultipleCAs.pdf', sep=''))
p <- ggplot(barData, aes(x=Model, y=Iteration, fill=Method)) +
  geom_bar(stat="identity", position=position_dodge()) +
  labs(x = "", y = "Iterations to Complete CNF") +
  geom_text(aes(label=Iteration), position=position_dodge(width=0.9), size = 3.5, vjust=0.5, hjust= 1.1, angle =90)+
  scale_colour_manual(values = colors, aesthetics = c("color", "fill"))+
  scale_y_continuous(trans='log10') +
  # scale_y_log10(breaks = trans_breaks("log10", function(x) 10^x),
  #               labels = trans_format("log10", math_format(10^.x))) +
  scale_x_discrete(breaks=unique(data$Model),
                   labels=unique(data$Model))+
  theme(axis.text=element_text(size=14,angle =90),
        axis.title=element_text(size=16),
        legend.title = element_text(size = 14),
        legend.text = element_text(size=13))+ theme(aspect.ratio= 0.5)

print(p)  
dev.off()
#+++++++++++++++++++++++++++++++++++
n_methods <- length(unique(data$Method))
shapes <-  0:(n_methods-1)
model = models[1]
for (model in models)
{
  ind <- which(data$Model == model)
  dt <- data[ind,]
  
  pdf(width=11, height=10, paste('/Users/nafiseh/Dropbox/MONET_MetabolicNetworks/Figures/',  model, '_MutipleCAs.pdf', sep=''))
  
  p <- ggplot(dt, aes(x=Iteration, y=CNF_Length, color=Method, shape= Method, linetype = Method)) +
    geom_line() + geom_point(size = 2) +
    labs(x = "Iteration", y = "Length of CNF") +
    scale_colour_manual(values = colors, aesthetics = c("color"))+
    scale_shape_manual(values=shapes) +  
    theme(axis.text=element_text(size=14),
          axis.title=element_text(size=16),
          legend.title = element_text(size = 14), legend.position = c(0.92, 0.09),
          legend.text = element_text(size=13))+ theme(aspect.ratio=1)
  
  print(p)  

  dev.off()
}