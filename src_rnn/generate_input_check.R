library(tokenizers)
library(dplyr)
library(Matrix)
setwd('~/2019dsp-summer-project')

path_token_list <- './data_wtv/token_list'
path_table <- './data_wtv/w2v_table.dm'
path_output <- './data_rnn/'
fix_length <- 30

start <- 40001
N <- 5000
#start <- 1
# N <- 10000

load(path_token_list)
load(path_table)
tokenList <- tokenList[start:(start+N-1)]


#rownames( w2v_table ) <- w2v_table[,1]
#w2v_table <- select( w2v_table, -X )

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
wv <- tokenList %>%
    lapply( ws2v ) %>%
    lapply( extend ) %>%
    lapply( as.matrix ) %>%
    lapply( t ) %>%
    unlist( recursive=F ) %>%
    as.array()
dim( wv ) <- c( 200, fix_length, N )
wv <- aperm(wv)
save( wv, file=paste0(path_output, 'vector_test_test') )
