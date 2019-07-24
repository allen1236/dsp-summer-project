library(tokenizers)
library(dplyr)
library(Matrix)
library(pbapply)
#library(parallel)
#library(ff)
setwd("/home/fhcwcsy/Documents/2019dsp-summer-project/data_rnn")

#cpuCores = detectCores()
#cl <- makeCluster(cpuCores, type = "FORK")

path_token_list <- '../data_wtv/token_list'
path_table <- '../data_wtv/word_vectors_50000.csv'
path_output <- '../data_rnn/vector/50000/'
fix_length <- 30

N <- 10000

load(path_token_list)
w2v_table = read.csv(file = path_table)

rownames( w2v_table ) <- w2v_table[,1]
w2v_table <- select( w2v_table, -X )
#save(w2v_table, file = "../data_wtv/w2v_table.dm")
count = 1
ws2v <- function(w) { 
    if(count %% 100 == 0)
    {
        print(count/100)
    }
    count <<- count + 1
    v <- w2v_table[w,] 
    v[is.na(v)] <- 0
    return( v )
}

stepRecord = F

extend <- function( d ) {
    len = nrow(d)
    if ( len > fix_length ) {
        print("Warning: Tweet is truncated.")
        return( d[1:fix_length,] )
    }
    else {
        return( rbind( d, matrix(0, fix_length-len, 200 ) ) )
    }
    if(stepRecord == F)
    {
    	count <<- 0
    	stepRecord <<- T
    }
    if(count %% 100 == 0)
    {
	    print(count/100)
    }
    count <<- count + 1
}

for (k in 1:6) {

wv = tokenList[(N * (k-1) + 1):( N * k)] %>% 
    pblapply( ws2v ) %>%
    pblapply( extend ) %>%
    pblapply( as.matrix ) %>%
    pblapply( t ) %>%
    unlist( recursive=F ) %>%
    as.array()
print("saving...")
dim( wv ) <- c( 200, fix_length, N )
wv <- aperm(wv)
save( wv, file=paste0(path_output, 'vector_big_test_', k, ".dm") )
}
#print(paste0("done: ", k, "/5"))
print("done")


#stopCluster(cl)
