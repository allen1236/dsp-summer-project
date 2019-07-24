library(tensorflow)
library(keras)
library(dplyr)
library(abind)

#install_tensorflow( version='gpu' )
#install_keras( tensorflow='gpu' )

setwd('~/2019dsp-summer-project/')

data_name <- '50k'
path_model <- paste0( './data_rnn/model/', data_name, '/model' )
path_vector <- paste0( './data_rnn/wvs/', data_name , '/vector_big_test_' )
path_label <- './data_rnn/label_list'
l <- 30
w <- 200
file_num <- 5
step_begin <- 5
step <- 2
step_lim <- 40
batch_size <- 1024

model <- keras_model_sequential() %>% 
  layer_lstm( units=512, input_shape=c(l, w), activation='relu', kernel_initializer='orthogonal' ) %>% 
  layer_dense( units=512, activation='sigmoid' ) %>% 
  layer_dense( units=256, activation='sigmoid' ) %>% 
  layer_dense( units=128, activation='sigmoid' ) %>% 
  layer_dense( units=1, activation='sigmoid' ) %>% 
  compile( loss = 'binary_crossentropy',
                  optimizer = 'adam',
                  metrics = list("accuracy")
                  )
model %>% summary()

load( file=path_label )
y <- labels[1:(file_num*10000)]
y_test <- labels[50001:55000]
rm( labels ); gc()

load( file=paste0( path_vector, 1, '.dm' ) )
x <- wv
rm( wv ); gc()
for( i in 2:file_num ) {
  load( file=paste0( path_vector, i, '.dm' ) )
  x <<- abind( x, wv, along=1 )
  rm( wv );  gc()
}

load( file=paste0( path_vector, 6, '.dm' ) )
x_test <- wv[1:5000,,]
rm( wv ); gc()

model %>% fit( x, y, epochs=step_begin, batch_size=batch_size, shuffle=T )
scores <-  model %>% evaluate( x_test, y_test, verbose=0 )
save_model_hdf5( model, paste0( paste( path_model, step_begin, scores[2], sep='_' ), '.HDF5' ) )
print( scores )

for( i in seq( (step_begin+step), step_lim, by=step) ) {
  model %>%  fit( x, y, epochs=step, batch_size=batch_size, shuffle=T )
  scores <-  model %>% evaluate( x_test, y_test, verbose=0 )
  save_model_hdf5( model, paste0( paste( path_model, i, scores[2], sep='_' ), '.HDF5' ) )
  print( scores )
}