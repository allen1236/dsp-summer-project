library(dplyr)
library(text2vec)
library(tokenizers)
library(stringi)
setwd("/home/fhcwcsy/Documents/2019dsp-summer-project/src_wtv")

text_raw = readLines("../data/all_text.txt") 

# Create iterator over tokens
#tokens <- word_tokenizer(text_raw)
tokens <- text_raw %>%
  stri_enc_toutf8() %>%
  #tokenize_words( lowercase=T, strip_punct=T, strip_numeric=F, simplify=F)
  tokenize_tweets( lowercase=T, strip_punct=F, simplify=F)

tokens <- word_tokenizer(text_raw)
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

write.csv( word_vectors, file = "../data_wtv/word_vectors.csv")

# numFiles = nrow(word_vectors) %/% 50000 + 1
# for (i in c(1:numFiles)) 
# {
#  fileNameCsv = paste0( "../data/word_vectors/wv", i, ".csv")
# }
