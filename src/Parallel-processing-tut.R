#parallel tutorial
library(foreach)
library(doParallel)

workers <- 3
registerDoParallel(cores = workers)

# Returns a list
foreach( i = 1:10 ) %dopar% {
  j <- i + 1
  sqrt(j)
}

delegate <- function( i = i, n = n, k = k, p = workers ){
  nOut <- n - k + 1
  nProc <- ceiling( nOut / p )
  return( (( i - 1 ) * nProc + 1) : min(i * nProc + k - 1, n) )
}

# Test i as 1 through 4 to verify it matches our example
lapply(1:4, function(i) delegate(i, n = 100, k = 5, p = 4))

calc_return<-function(in_vec){
  out <- in_vec/lag.xts(in_vec, 1) - 1
  return(out)
}

dateindex <- index(DATA[["Close"]])

temp <- DATA[["Close"]][ , 6:10]

RETURN <- foreach(i = 1:ncol(DATA[["Close"]]), .combine = cbind, .packages = "zoo") %do%
  {
  temp<-DATA[["Close"]][, i]
  calc_return(temp)
}

colnames(RETURN) <- colnames(DATA[["Close"]])
RETURN%>%view()
