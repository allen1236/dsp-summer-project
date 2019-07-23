library(tensorflow)
library(keras)
library(dplyr)

install_tensorflow( version='gpu' )
install_keras( tensorflow='gpu' )

N <- 500
l <- 20
w <- 20

set.seed(123)
n <-  seq(1:N)
x <-  rnorm(N*l*w)
dim(x) <- c(N,l,w)
y <- rep( c(0,1,0), N )
dim(y) <- c(N,3)

model <- keras_model_sequential() %>% 
  layer_lstm( units=128, input_shape=c(l, w), activation='sigmoid' ) %>% 
  layer_dense( units=64, activation='sigmoid' ) %>% 
  layer_dense( units=32, activation='sigmoid' ) %>% 
  layer_dense( units=3, activation='softmax' )
model %>% compile( loss = 'categorical_crossentropy',
                  optimizer = 'adam',
                  metrics = list("accuracy")
)
model %>% summary()
model %>% fit( x, y, epochs=30, batch_size=32, shuffle=FALSE )
y_pred <- model %>% predict( x )
scores <-  model %>% evaluate( x, y, verbose=0 )
print( scores )
