import pandas as pd
import numpy as np
import keras
from keras.models import Sequential
from keras.layers.core import Dense, Dropout, Activation
from keras.layers import Conv2D, MaxPooling2D, Flatten
from keras.optimizers import SGD, Adam, Adagrad
from keras.utils import np_utils
from keras.losses import categorical_crossentropy

from load import *
x_train, y_train = read( './train.csv' )


model = Sequential()

model.add( Conv2D( 50, 3, 3, input_shape=( 48, 48, 1 ) ) )  # 46
model.add( MaxPooling2D( (2, 2) ) )                         # 23
model.add( Conv2D( 50, 4, 4 ) )                             # 20
model.add( MaxPooling2D( (2, 2) ) )                         # 10
model.add( Conv2D( 50, 3, 3 ) )                             # 8
model.add( MaxPooling2D( (2, 2) ) )                         # 4
model.add( Flatten() )                                      # 100 * 16
model.add( Dense( units=400, activation="sigmoid" ) )
model.add( Dense( units=400, activation="sigmoid" ) )
model.add( Dense( units=7, activation="softmax" ) )

model.compile( loss='categorical_crossentropy', optimizer='adam', metrics=['accuracy'] )

interval = 2
count = 4
max_count = 20


model.fit( x_train, y_train, batch_size=400, epochs=count )
model.save( "model_" + str(count) + ".h5" )
x_test, y_test = read( './test.csv' )
score = model.evaluate( x_test, y_test, verbose=0 )
print( str(count) + ': loss:', score[0], 'accuracy:', score[1] )

while count < max_count:
    model.fit( x_train, y_train, batch_size=400, epochs=interval )
    count += interval
    model.save( "model_" + str(count) + ".h5" )
    score = model.evaluate( x_test, y_test, verbose=0 )
    print( str(count) + ': loss:', score[0], 'accuracy:', score[1] )
