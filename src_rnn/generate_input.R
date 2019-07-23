library(tokenizers)
library(dplyr)
library(Matrix)
setwd('~/Documents/2019dsp-summer-project')

path_raw <- './data_wtv/cleaned_tweets.csv'
path_table <- './data_wtv/word_vectors.csv'
path_output <- './data_rnn/'
fix_length <- 40


raw <- read.csv( path_raw, header=T, nrows=1000L )
w2v_table <- read.csv( path_table, header=T )


width <- ncol(w2v_table)
length <- nrow(w2v_table)
rownames( w2v_table ) <- w2v_table[,1]
w2v_table <- select( w2v_table, -X )

ws2v <- function(w) { 
    v <- w2v_table[w,] 
    v[is.na(v)] <- 0
    return( v )
}
extend <- function( d ) {
    len = nrow(d)
    if ( len >= fix_length ) {
        return( d[1:fix_length,] )
    }
    else {
        return( rbind( d, matrix(0, fix_length-len, 200 ) ) )
    }
}
wv <- tokenize_tweets( as.character(raw[,7]), lowercase=T, strip_punct=F, simplify=F )
wv <- lapply( wv, ws2v ) %>% lapply( extend )


save( wv, file=paste0(path_output, 'vector') )

labels <- function(y) { as.integer( c(y==4, y==2, y==0) ) }
labels <- lapply( raw$target, labels )
save( labels, file=paste0(path_output, 'label') )