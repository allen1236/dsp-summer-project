library(dplyr)
library(text2vec)
library(tokenizers)
library(stringi)
setwd("/home/fhcwcsy/Documents/2019dsp-summer-project/src_wtv")

text_raw = readLines("../data_wtv/all_text_50000.txt") 

# Create iterator over tokens
#tokens <- word_tokenizer(text_raw)
tokens <- text_raw %>%
  stri_enc_toutf8() %>%
  #tokenize_words( lowercase=T, strip_punct=T, strip_numeric=F, simplify=F)
  tokenize_words( lowercase=T, strip_punct=F, simplify=F)

stopwords = c('i', 'me', 'my', 'myself', 'we', 'our', 'ours', 'ourselves', 'you', "you're", "you've", "you'll", "you'd", 'your', 'yours', 'yourself', 'yourselves', 'he', 'him', 'his', 'himself', 'she', "she's", 'her', 'hers', 'herself', 'it', "it's", 'its', 'itself', 'they', 'them', 'their', 'theirs', 'themselves', 'what', 'which', 'who', 'whom', 'this', 'that', "that'll", 'these', 'those', 'am', 'is', 'are', 'was', 'were', 'be', 'been', 'being', 'have', 'has', 'had', 'having', 'do', 'does', 'did', 'doing', 'a', 'an', 'the', 'and', 'but', 'if', 'or', 'because', 'as', 'until', 'while', 'of', 'at', 'by', 'for', 'with', 'about', 'against', 'between', 'into', 'through', 'during', 'before', 'after', 'above', 'below', 'to', 'from', 'up', 'down', 'in', 'out', 'on', 'off', 'over', 'under', 'again', 'further', 'then', 'once', 'here', 'there', 'when', 'where', 'why', 'how', 'all', 'any', 'both', 'each', 'few', 'more', 'most', 'other', 'some', 'such', 'no', 'nor', 'not', 'only', 'own', 'same', 'so', 'than', 'too', 'very', 'can', 'will', 'just', "don't", 'should', "should've", 'now', "aren't", "couldn't", "didn't", 'doesn', "doesn't", "hadn't", "hasn't",  "haven't", "isn't", "mightn't", "mustn't",  "needn't", "shouldn't", "wasn't", "weren't", "won't", "wouldn't")

tokens[[1]] = tokens[[1]][! tokens[[1]] %in% stopwords ]
# Create vocabulary. Terms will be unigrams (simple words).
it = itoken(tokens, progressbar = TRUE)
vocab <- create_vocabulary(it)

vocab <- prune_vocabulary(vocab, term_count_min = 5L)

# Use our filtered vocabulary
vectorizer <- vocab_vectorizer(vocab)
# use window of 5 for context words
tcm <- create_tcm(it, vectorizer, skip_grams_window = 5L)

glove = GlobalVectors$new(word_vectors_size = 200, vocabulary = vocab, x_max = 10)
wv_main = glove$fit_transform(tcm, n_iter = 50, convergence_tol = 0.01)

wv_context = glove$components
dim(wv_context)

word_vectors = wv_main + t(wv_context)

write.csv( word_vectors, file = "../data_wtv/word_vectors_50000.csv")

# numFiles = nrow(word_vectors) %/% 50000 + 1
# for (i in c(1:numFiles)) 
# {
#  fileNameCsv = paste0( "../data/word_vectors/wv", i, ".csv")
# }
