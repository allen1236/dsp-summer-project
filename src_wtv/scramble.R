library(dplyr)

setwd("/home/fhcwcsy/Documents/2019dsp-summer-project/src_wtv")

cleanedData = read.csv( file = "../data_wtv/cleaned_tweets.csv") 

sortData = cleanedData %>% 
  arrange( user ) %>%
  select( target, text )

write.csv( sortData, file = "../data_wtv/scrambled.csv")

