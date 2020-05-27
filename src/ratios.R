# ratio functions
#not the most efficient
MD<-function(curve, n = 1){
  
    time <- length(curve)
    v <- rep(NA, (time * (time - 1)) / 2)
    k <- 1
    for(i in 1:(length(curve)-1)){
      for(j in (i+1):length(curve)){
        v[k] <- curve[i] - curve[j]
        k <- k + 1
      }
    }
    m <- rep(NA, length(n))
    for(i in 1:n){
      m[i] <- max(v)
      v[which.max(v)] <- -Inf
    }
    return(m)
}

#partial moment function
PM <- function(Rt, upper = FALSE, n = 2, Rb = 0){
  if(n != 0){
    if(!upper) return(mean(pmax(Rb - Rt, 0, na.rm = TRUE)^n))
    if(upper) return(mean(pmax(Rt - Rb, 0, na.rm = TRUE)^n))
  } else {
    if(!upper) return(mean(Rb >= Rt))
    if(upper) return(mean(Rt > Rb))
  }
}
