# process tweet s
# combine the tweets into a big text file to feed them to GloVe
library(pbapply)
library(dplyr)

setwd("/home/fhcwcsy/Documents/2019dsp-summer-project/src_wtv")
raw_data = read.csv( file = "../data_wtv/scrambled.csv", header = TRUE, nrows = 50000) %>% 
  select(2,3)
data = raw_data
colnames(data) = c("label", "text")

cleanText = function(text)
{
  text = gsub( "http\\S+", "url", text)
  text = gsub( "@\\S+", "name", text)
  text = gsub( "(\\d+,?)+", "num", text)
  text = gsub('[[:punct:] ]+',' ',text)
  #deal with non-UTF8 chars
  text = iconv(text, "UTF-8", "UTF-8",sub='')
  text = iconv(gsub("\\n", " ", text), to="ASCII", sub="")
  text
}

data = mutate(data, text = cleanText(text))

write.csv( data, "../data_wtv/cleaned_tweets.csv")
writeText = function(textElement)
{
  cat(as.character(textElement), " ", file = "../data_wtv/all_text_very_clean.txt", append = TRUE )
}

pblapply( data$text, writeText)
  