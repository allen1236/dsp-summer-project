library(tensorflow)
library(keras)
library(dplyr)
setwd('~/Documents/2019dsp-summer-project/')

install_tensorflow( version='gpu' )
install_keras( tensorflow='gpu' )

N <- 10000
l <- 40
w <- 200

str <- "
set.seed(123)
n <-  seq(1:N)
x <-  rnorm(N*l*w)
dim(x) <- c(N,l,w)
y <- rep( c(0,1,0), N )
dim(y) <- c(N,3)
"
model <- keras_model_sequential() %>% 
  layer_lstm( units=512, input_shape=c(l, w), activation='relu' ) %>% 
  layer_dense( units=256, activation='relu' ) %>% 
  layer_dense( units=128, activation='sigmoid' ) %>% 
  layer_dense( units=1, activation='sigmoid' )
model %>% compile( loss = 'binary_crossentropy',
                  optimizer = 'adam',
                  metrics = list("accuracy")
)

load( 'data_rnn/label' )
load( 'data_rnn/vector' ) 

model %>% summary()
model %>% fit( wv, labels, epochs=10, batch_size=500, shuffle=FALSE )
y_pred <- model %>% predict( wv )
scores <-  model %>% evaluate( wv, labels, verbose=0 )
print( scores )
