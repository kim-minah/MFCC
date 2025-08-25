#---------------------------------------------------------------
# Program: Plot MFCC Feature Vectors 
# Author: Minah Kim
# Date Created: 10/1/2020
# Revised: 2/28/21

# Input: 
# * matlab output (csv file/s) of time averaged set of MFCC coefficients 1 - 13 saved in MFCC_summary
# Output: 
# * plots for each file, saved in MFCC_plots
#---------------------------------------------------------------

# Set working directory
setwd('C:/Users/mk7kc/Desktop/mfcc/output/MFCC_summary')

# Don't really need tidry and matrixStats anymore cause my revised matlab script generates the mean/sd/sem for each file. Changed it so that matlab does this part because it was taking too long for R to read in the non-averaged data
library(ggplot2)
# library(tidyr)
# library(matrixStats)

# Read in all summary data and put them into list 
filename <- sort(Sys.glob('*.csv'), decreasing = TRUE)
myDatasets <- lapply(filename, function(i){read.csv(paste0(i),header=FALSE)})
num_dat <- length(myDatasets)
# get rid of '.csv' substring
for (i in 1:num_dat){
filename[i] <- substr(filename[i],1,nchar(filename[i])-4)
}

# Assign col names and get rid of first row of data (in matlab output, zeroth coefficient is outputted but excluded from being plotted)
# F0 related to pitch, provides no value in speech recognition
for (i in 1:num_dat){
  myDatasets[[i]] <- myDatasets[[i]][-1,]
  colnames(myDatasets[[i]]) <- c("Coefficient","SD","SEM")
  myDatasets[[i]]$MFCC.Feature <- as.factor(1:12)
}

# Don't need to do these steps cause my revised matlab script generate the mean/sd/sem for each file
# time_averaged_13 <- rowMeans(dat)
# time_averaged_12 <- time_averaged_13[2:length(time_averaged_13)]
# 
# # time averaged SD 
# SD_13 <- rowSds(dat)
# dat <- as.matrix(dat)
# SD_12 <- SD_13[2:length(SD_13)]
# 
# # standard error of the mean
# dim(dat)
# dat_graph <- data.frame("MFCC Feature" = 1:12, "Coefficient" = time_averaged_12,"SD"=SD_12)
# dat_graph$sem <- dat_graph$SD/sqrt((dim(dat)[2]))


# Plot and save as png
for (i in 1:num_dat) {
  png(sprintf("/Users/mk7kc/Desktop/mfcc/output/MFCC_plots/%s.jpg", filename[i]))
  theme_set(theme_classic())
  plot <- ggplot(data = myDatasets[[i]], aes(x=MFCC.Feature, y = Coefficient, group = 1))+
      geom_line(color = "magenta", lty = 1, lwd=2) +
      geom_errorbar(aes(ymin=Coefficient-SEM,ymax=Coefficient+SEM),position="dodge",width=.3,color="magenta",lwd=2) +
      labs(title = paste("MFCC Feature Vectors for",filename), x = "MFCC Feature", y = "Coefficient (weight)")+
      scale_x_discrete(breaks=seq(1,12,by=2),labels = c("1","3","5","7","9","11"))
  print(plot)
  dev.off()
}
