library(tokenizers)
library(dplyr)
#setwd('~/Documents/dsp2019summer-project')
setwd('~/Documents/tmp')

#path_input <- './data/cleaned_tweet.csv'
path_raw <- './data/raw_data.csv'
path_table <- './data/word_vectors.csv'

raw <- read.csv(path_raw, header=F, nrows=10L)
raw <- tibble( laber=as.integer(raw[,1]), text=as.character(raw[,6]) ) 
tokens <- mutate( raw, text=tokenize_tweets( text, lowercase=T, strip_punct=F, simplify=F) )

