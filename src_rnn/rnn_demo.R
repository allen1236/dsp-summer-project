library(tensorflow)
library(keras)
library(dplyr)
library(abind)
setwd('~/2019dsp-summer-project/')
source( './src_rnn/w2v_header.R')
# word2vec()
# tokenize()

model <- load_model_hdf5( './data_rnn/model/very_clean/model_7_0.786800026893616.HDF5')

while( T ) {
    msg <- readline( prompt="Enter a sentence: " )
    x <- c( msg ) %>% tokenize() %>% word2vec()
    eval <- model %>% predict( x, verbose=0 )
    ifelse(eval<0.5, 'Negative', 'Positive') %>% paste0( '   (', eval, ')' ) %>% print() 
}

