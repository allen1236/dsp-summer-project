library(tensorflow)
library(keras)
library(dplyr)

install_tensorflow( version='gpu' )
install_keras( tensorflow='gpu' )

setwd('~/Documents/2019dsp-summer-project/')


path_model <- './data_rnn/model_0724/model'
N <- 10000
l <- 30
w <- 200

model <- keras_model_sequential() %>% 
  layer_lstm( units=128, input_shape=c(l, w), activation='relu' ) %>% 
  layer_dense( units=128, activation='sigmoid' ) %>% 
  layer_dense( units=128, activation='sigmoid' ) %>% 
  layer_dense( units=128, activation='sigmoid' ) %>% 
  layer_dense( units=1, activation='sigmoid' )
model %>% compile( loss = 'binary_crossentropy',
                  optimizer = 'adam',
                  metrics = list("accuracy")
)
model %>% summary()

load( file='data_rnn/vector_test' ) 
wv_test <- wv
labels_test <- labelList[10001:11000]
labels <- labelList[1:10000]
load( file='data_rnn/vector' ) 

model %>% fit( wv, labels, epochs=30, batch_size=500, shuffle=T )
save_model_hdf5( model, paste0( paste( path_model, 'manual', sep='_' ), '.HDF5' ) )

for( i in seq(2,20,by=2) ) {
    model %>% fit( wv, labels, epochs=2, batch_size=500, shuffle=F )
    scores <-  model %>% evaluate( wv_test, labels_test, verbose=0 )
    save_model_hdf5( model, paste0( paste( path_model, i, sep='_' ), '.HDF5' ) )
    print( scores )
} 
