library(tensorflow)
library(keras)
library(dplyr)
library(abind)
setwd('~/2019dsp-summer-project/')
source( './src_rnn/w2v_header.R')
# word2vec()
# tokenize()

install_tensorflow( version='gpu' )
install_keras( tensorflow='gpu' )
model <- load_model_hdf5( './data_rnn/model/50k/model_10_0.763400018215179.HDF5')

x <- c( 'I hate this world', 'I am so happy', 'fuck you', "I'm having a bad headache" ) %>% tokenize() %>% word2vec()

model %>% predict( x, verbose=0 )
