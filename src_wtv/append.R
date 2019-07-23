# process tweets
# combine the tweets into a big text file to feed them to GloVe
library(pbapply)

setwd("~/Documents/dsp2019summer-project/script")

raw_data = read.csv( file = "../data/raw_data.csv", header = FALSE)
data = raw_data
colnames(data) = c( "target", "id", "date", "flag", "user", "text")

cleanText = function(text)
{
  text = gsub( "http\\S+", "url", text)
  text = gsub( "@\\S+", "name", text)
  text = gsub( "(\\d+,?)+", "num", text)
  #deal with non-UTF8 chars
  text = iconv(text, "UTF-8", "UTF-8",sub='')
  text = iconv(gsub("\\n", " ", text), to="ASCII", sub="")
  text
}

data = mutate(data, text = cleanText(text))

write.csv( data, "../data/cleaned_tweets.csv")
writeText = function(textElement, i)
{
  textElement %>%
    cat(file = "../data/all_text.txt", append = TRUE )
}

pblapply( data$text, writeText)