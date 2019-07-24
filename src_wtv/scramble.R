library(dplyr)
library(tokenizers)
library(rlist)

setwd("/home/fhcwcsy/Documents/2019dsp-summer-project/src_wtv")

cleanedData = read.csv( file = "../data_wtv/cleaned_tweets.csv") 

sortData = cleanedData %>% 
  arrange( user ) %>%
  select( target, text )

write.csv( sortData, file = "../data_wtv/scrambled.csv")

tokenList = tokenize_words( as.character(scrambledData[,2]), lowercase=T, strip_punct=F, simplify=F )

shortIndices = list.which(tokenList, length(.) <= 30)

tokenList = tokenList[shortIndices]
labelList = scrambledData$target[shortIndices]

#save(tokenList, file = "../data_wtv/token_list")
#save(labelList, file = "../data_wtv/label_list")
