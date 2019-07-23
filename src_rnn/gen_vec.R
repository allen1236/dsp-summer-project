library(tokenizers)
library(dplyr)
library(Matrix)
setwd("/home/fhcwcsy/Documents/2019dsp-summer-project/")

path_raw <- './data_wtv/scrambled.csv'
path_table <- './data_wtv/word_vectors.csv'
path_output <- './data_rnn/tweet_vec/'
fix_length <- 40

N <- 20000
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

for (sk in c(1:80)) {

raw <- read.csv( path_raw, header=T, nrows=N , skip = ((sk-1) * 20000))

wv <- tokenize_tweets( as.character(raw[,3]), lowercase=T, strip_punct=F, simplify=F ) %>% 
    lapply( ws2v ) %>% 
    lapply( extend ) %>% 
    lapply( as.matrix ) %>% 
    lapply( t ) %>%
    unlist(  recursive=F ) %>%  
    as.array()
dim( wv ) <- c( N, 40, 200 )
save( wv, file=paste0(path_output, 'vector', sk) )

}

labels <- as.numeric( raw[,2] == 4 ) 
save( labels, file=paste0(path_output, 'label') )
