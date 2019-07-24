library(tokenizers)
library(dplyr)
library(Matrix)
library(abind)
library(tokenizers)

# setup
path_table <- './data_wtv/w2v_table.dm'
load(path_table)
fix_length <- 30
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
cleanText <- function(text) {
    # strip punctuation?
  text = gsub( "http\\S+", "url", text)
  text = gsub( "@\\S+", "name", text)
  text = gsub( "(\\d+,?)+", "num", text)
  text = iconv(text, "UTF-8", "UTF-8",sub='')
  text = iconv(gsub("\\n", " ", text), to="ASCII", sub="")
  text
}

# main function
tokenize <- function( text_list ) {
    cleanText( text_list )
    text_list %>% tokenize_words( lowercase=T, strip_punct=F, simplify=F)
}
word2vec <- function( token_list ) {
    wv <- token_list %>%
        lapply( ws2v ) %>%
        lapply( extend ) %>%
        lapply( as.matrix ) %>%
        lapply( t ) %>%
        unlist( recursive=F ) %>%
        as.array()
    dim( wv ) <- c( 200, fix_length, length(token_list) )
    aperm(wv)
}