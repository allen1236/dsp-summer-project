library(tensorflow)
library(keras)
library(dplyr)

install_tensorflow( version='gpu' )
install_keras( tensorflow='gpu' )

setwd('~/2019dsp-summer-project/')

path_model <- './data_rnn/model_0724_new/model'
path_vector <- './data_wtv/wvs/vector'
l <- 30
w <- 200

model <- keras_model_sequential() %>% 
  layer_lstm( units=256, input_shape=c(l, w), activation='relu' ) %>% 
  layer_dense( units=256, activation='sigmoid' ) %>% 
  layer_dense( units=128, activation='sigmoid' ) %>% 
  layer_dense( units=128, activation='sigmoid' ) %>% 
  layer_dense( units=1, activation='sigmoid' )
model %>% compile( loss = 'binary_crossentropy',
                  optimizer = 'adam',
                  metrics = list("accuracy")
)
model %>% summary()

load( file='data_wtv/label_list' )
labelList <- as.integer( labelList == 4 )
load( file='data_rnn/wvs/vector_big_test_11.dm' ) 
wv_test <- wv
load( file='data_rnn/wvs/vector50.dm' ) 
wv_test2 <- wv

load( file=paste0('data_rnn/wvs/vector_big_1.dm') ) 
model %>% fit( wv, labelList[1:50000], epochs=10, batch_size=1000, shuffle=T )
scores <-  model %>% evaluate( wv_test, labelList[50001:55000], verbose=0 )
scores <-  model %>% evaluate( wv_test2, labelList[245001:250000], verbose=0 )
save_model_hdf5( model, paste0( paste( path_model, 'manual', sep='_' ), '.HDF5' ) )
print( scores )
} 
