library(tensorflow)
library(keras)
library(dplyr)

install_tensorflow( version='gpu' )
install_keras( tensorflow='gpu' )

setwd('~/Documents/2019dsp-summer-project/')

load( 'data_rnn/label' )
load( 'data_rnn/vector' ) 
load( 'data_rnn/label_test' )
load( 'data_rnn/vector_test' ) 

path_model <- './data_rnn/model'
N <- 10000
l <- 30
w <- 200

model <- keras_model_sequential() %>% 
  layer_lstm( units=512, input_shape=c(l, w), activation='sigmoid' ) %>% 
  layer_dense( units=256, activation='sigmoid' ) %>% 
  layer_dense( units=256, activation='sigmoid' ) %>% 
  layer_dense( units=1, activation='sigmoid' )
model %>% compile( loss = 'binary_crossentropy',
                  optimizer = 'adam',
                  metrics = list("accuracy")
)


model %>% summary()
for( i in seq(2,10,by=2) ) {
    model %>% fit( wv, labels, epochs=2, batch_size=1000, shuffle=F )
    #y_pred <- model %>% predict( wv )
    scores <-  model %>% evaluate( wv_test, labels_test, verbose=0 )
    save( paste( path_model, i, scores, sep='_' ) )
    print( scores )
} 
