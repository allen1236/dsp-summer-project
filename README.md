# Twitter Sentiment Analysis

**Data Science Programming, final project** <br>
**2019 Summer Course**

## Abstract

In this project, we use the data from [Kaggle](https://www.kaggle.com/kazanova/sentiment140), which provides 1,600,000 tweets, with sentiment labels. Our goal is to construct a model to analyze tweets and attempt to guess the sentiment. We used [**GloVe**](https://nlp.stanford.edu/projects/glove/) and recurrent neural networks (LSTM), with the help of [**text2vec**](http://text2vec.org/glove.html) package, [**Tensorflow**](https://www.tensorflow.org/) and [**Keras**](https://keras.io/). Due to the limitation of RAM size, we can only use 50,000 tweets to train our models. We ended up with a 78.7% accuracy in the test (accuracy over 5,000 tweets). Possible improvements of this project include extending corpus size with `ff` and `parallel` packages, and less restrictions on maximum tweets length.

## Model Details

- Training and testing data are both from [Kaggle](https://www.kaggle.com/kazanova/sentiment140). Training data are 50,000 tweets which are randomly selected, so are the 5,000 testing tweets.
- Punctuation other than commas `,` and periods `.` are ignored. URLs are replaced by characters `url`, usernames ( `@usernames` ) are replaced by `name` and numbers are replaced by `num`. 
- Vector dimension: 200
- Maximum tweets length: 30 tokens ( tokens: words that are in the dictionary generated with the 50,000 training tweets )
- One layer of LSTM neurons (512 units, activation function: relu)
- A fully connected feed-forward network (3 hidden layers with 512/256/128 units,  activation function: sigmoid)
- Loss function: binary cross-entropy

## Method

1. Combine all training tweets into a single string and remove/replace unwanted aforementioned characters.
2. Tokenize the string, create co-occurence matrix and feed it to GloVe function to create word vector matrix.
5. Tokenize all tweets, lookup each tokens in the word vector matrix to create a 3-D array. Tweets shorter than 30 tokens are filled with zero vectors, and so are the words which are not in the list.
4. Train the RNN model with the 3-D array.
5. Test the result with testing tweets. 

## Script Description

```
.
+-- README.md : This file.
+-- src_wtv : R scripts that convert text to vectors
|   +-- append.R : combine all tweets to a single string and clean the text.
|   +-- scramble.R : shuffle and tokenize the tweets.
|   +-- wtv.R : generate word vectors.
|   +-- stopwords.csv : a file containing stopwords but later we found that leaving stopwords in the text leads to better results, so it is not used.
+-- src_rnn : scripts related to RNN
|   +-- gen_vec.R : lookup tweet tokens and generate 3-D array.
|   +-- rnn_#.R : some tests of rnn models.
|   +-- rnn_demo.R : test the models with user inputs.
|   +-- rnn_train.R : the script to train the model.
|   +-- w2v_header : some basic functions to turn words into vectors.
+-- slides
|   +-- slides.tex : original beamer tex script.
|   +-- slides.pdf : compiled beamer pdf file.
+-- data_raw
|   +-- raw_data.csv : raw data
+-- data_wtv
|   +-- all_text* : various versions containing all tweets in a single string.
|   +-- cleaned_tweets.csv : a dataframe containing tweets with unwanted characters removed/replaced
|   +-- scrambled.csv : a dataframe containing shuffled and cleaned tweets.
|   +-- label_list : R object file. An interger vector containing all labels (sentiment) of tweets. Has the same order with scrambled.csv and token_list.
|   +-- token_list : R object file. A list containing all tokens of tweets. Has the same order with scrambled.csv and label_list.
|   +-- w2v_table.dm : R object file. A matrix containing all word vectors, with words being the row names.
|   +-- word_vectors*.csv : A csv file containing various versions of word vectors.
+-- data_rnn
|   +-- wvs : containing various versions of 3-D array containing tokens of tweets. Separated R object files.
|   +-- model : saved RNN models
|   +-- plot: the plot of the result of the final model.
```

