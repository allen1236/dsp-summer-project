library(tensorflow)
library(keras)
library(dplyr)

install_tensorflow( version='gpu' )
install_keras( tensorflow='gpu' )

setwd('~/2019dsp-summer-project/')


path_model <- './data_rnn/model_0724/model'
N <- 10000
l <- 30
w <- 200

model <- keras_model_sequential() %>% 
  layer_lstm( units=512, input_shape=c(l, w), activation='relu' ) %>% 
  layer_dense( units=512, activation='sigmoid' ) %>% 
  layer_dense( units=256, activation='sigmoid' ) %>% 
  layer_dense( units=128, activation='sigmoid' ) %>% 
  layer_dense( units=1, activation='sigmoid' )
model %>% compile( loss = 'binary_crossentropy',
                  optimizer = 'adam',
                  metrics = list("accuracy")
)
model %>% summary()

load( file='data_wtv/label_list')
load( file='data_rnn/vector_test_test' ) 
wv_test <- wv
labels_test <- labelList[40001:45000] == 4
labels <- labelList[1:10000] == 4
load( file='data_rnn/vector_test' ) 

model %>% fit( wv, labels, epochs=5, batch_size=500, shuffle=T )
save_model_hdf5( model, paste0( paste( path_model, 'manual', sep='_' ), '.HDF5' ) )

for( i in seq(2,20,by=2) ) {
    model %>% fit( wv, labels, epochs=2, batch_size=500, shuffle=F )
    scores <-  model %>% evaluate( wv_test, labels_test, verbose=0 )
    save_model_hdf5( model, paste0( paste( path_model, i, sep='_' ), '.HDF5' ) )
    print( scores )
} 
