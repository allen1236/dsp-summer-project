library(tokenizers)
library(dplyr)
library(Matrix)
setwd('~/Documents/2019dsp-summer-project')

path_token_list <- './data_wtv/token_list'
path_label_list <- './data_wtv/label_list'
path_table <- './data_wtv/w2v_table.dm'
path_output <- './data_rnn/'
fix_length <- 30

N <- 20000

load(path_token_list)
load(path_label_list)
load(path_table)
tokenList <- tokenList[1:N]
labelList <- labelList[1:N]

#width <- ncol(w2v_table)
#length <- nrow(w2v_table)
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
wv <- tokenize_tweets( as.character(tokenList), lowercase=T, strip_punct=F, simplify=F ) %>% 
    lapply( ws2v ) %>% 
    lapply( extend ) %>% 
    lapply( as.matrix ) %>% 
    lapply( t ) %>%
    unlist( recursive=F ) %>%  
    as.array()
dim( wv ) <- c( N, fix_length, 200 )
save( wv, file=paste0(path_output, 'vector_test') )

labels <- as.numeric(  labelList==4 ) 
save( labels, file=paste0(path_output, 'label_test') )
