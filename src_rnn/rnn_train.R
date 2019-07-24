library(tensorflow)
library(keras)
library(dplyr)
library(abind)

install_tensorflow( version='gpu' )
install_keras( tensorflow='gpu' )

setwd('~/2019dsp-summer-project/')

path_model <- './data_rnn/model_0724_new/model'
path_vector <- './data_wtv/wvs/vector'
l <- 30
w <- 200
file_num <- 2

model <- keras_model_sequential() %>% 
  layer_lstm( units=256, input_shape=c(l, w), activation='relu' ) %>% 
  layer_dense( units=256, activation='sigmoid' ) %>% 
  layer_dense( units=128, activation='sigmoid' ) %>% 
  layer_dense( units=128, activation='sigmoid' ) %>% 
  layer_dense( units=1, activation='sigmoid' ) %>% 
  compile( loss = 'binary_crossentropy',
                  optimizer = 'adam',
                  metrics = list("accuracy")
                  )
model %>% summary()

rm( tokenList )

model %>% fit( wv, y, epochs=10, batch_size=1000, shuffle=T )
scores <-  model %>% evaluate( wv_test, labelList[50001:55000], verbose=0 )
scores <-  model %>% evaluate( wv_test2, labelList[245001:250000], verbose=0 )
save_model_hdf5( model, paste0( paste( path_model, 'manual', sep='_' ), '.HDF5' ) )
print( scores )
