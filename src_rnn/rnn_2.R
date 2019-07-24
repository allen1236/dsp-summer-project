library(tensorflow)
library(keras)
library(dplyr)

install_tensorflow( version='gpu' )
install_keras( tensorflow='gpu' )

setwd('~/2019dsp-summer-project/')

path_model <- './data_rnn/model_0724_new/model'
path_vector <- './data_wtv/wvs/vector'
file_num <- 2
l <- 30
w <- 200

model <- keras_model_sequential() %>% 
  layer_lstm( units=512, input_shape=c(l, w), activation='relu' ) %>% 
  layer_dense( units=256, activation='sigmoid' ) %>% 
  layer_dense( units=256, activation='sigmoid' ) %>% 
  layer_dense( units=128, activation='sigmoid' ) %>% 
  layer_dense( units=1, activation='sigmoid' )
model %>% compile( loss = 'binary_crossentropy',
                  optimizer = 'adam',
                  metrics = list("accuracy")
)
model %>% summary()

load( file='data_wtv/label_list' )
labelList <- as.integer( labelList == 4 )
load( file='data_rnn/vector_test_test' ) 
wv_test <- wv

for( i in 1:6 ) {
    for ( j in 1:file_num ) {
        load( file=paste0('data_rnn/wvs/vector', j, '.dm') ) 
        model %>% fit( wv, labelList[((j-1)*20000+1):(j*20000)], epochs=1, batch_size=1000, shuffle=T )
    }
    scores <-  model %>% evaluate( wv_test[1:1000,,], labelList[40001:41000], verbose=0 )
    save_model_hdf5( model, paste0( paste( path_model, i, sep='_' ), '.HDF5' ) )
    print( scores )
} 
