library(dplyr)
library(ggplot2)
library(reshape2)

setwd("/home/fhcwcsy/Documents/2019dsp-summer-project")

data = read.csv( file = "./data_rnn/plot/rnn.csv", header = T)

lossPlot = ggplot(data, aes( x = epoch, y = loss)) + geom_line(stat = "identity")
meltedData = data %>% 
  select(1,3,4) %>%
  melt(id = "epoch")
colnames(meltedData) = c( "epoch", "type", "accuracy")

accPlot = meltedData[which( ! is.na(meltedData$accuracy)),] %>% 
  ggplot( aes( x = epoch, y = accuracy, color = type)) + geom_line(aes(color = type), stat = "identity")
