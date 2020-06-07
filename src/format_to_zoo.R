#convert to zoo objects

datetemp<-sort(unique(unlist(lapply(DATA, function(x) x$Date))))
datetemp<-tibble("Date" = datetemp)

DATA<-lapply(DATA, function(v) unique(v[order(v$Date), ]))
DATA[["Open"]]<-DATA[["High"]]<-DATA[["Low"]]<-DATA[["Close"]]<-DATA[["Adjusted"]]<-DATA[["Volume"]]<-datetemp

# This loop will sequentially append the columns of each symbol
# to the appropriate Open, High, Low, etc. object
S<-stock.symb
for(s in S){
  #i in paste(s, c("Open", "High", "Low", "Close", "Volume", "Adjusted"))
  for(i in rev(c("Open", "High", "Low", "Close", "Adjusted", "Volume"))){
    
    i_alt<-paste(s, i, sep = ".")
    temp <-data.frame(cbind(DATA[[s]][["Date"]], DATA[[s]][[i_alt]]),
                      stringsAsFactors = FALSE)
    
    names(temp) <- c("Date", s)
    temp[,2] <- as.numeric (temp[,2])
    
    if(!any(!DATA[[i]][["Date"]][(nrow(DATA[[i]]) - nrow(temp)+1): nrow(DATA[[i]])]== temp[,1])){
      
      temp <- rbind(t(matrix (nrow = 2, ncol = nrow(DATA[[i]]) - nrow(temp),
                              dimnames = list(names(temp)))), temp)
      
      DATA[[i]] <- cbind(DATA[[i]], temp[,2])
    }else{
      DATA[[i]] <- merge(DATA[[i]], temp, all.x = TRUE, by = "Date")
    }
    names(DATA[[i]]) <- c ( names (DATA[[i]])[-( ncol (DATA[[i]]))], s)
  }
  
  DATA[[s]] <- NULL
  # Update user on progress
  if( which ( S == s ) %% 25 == 0 ){
    cat(paste0(round(100*which(S == s)/length(S), 1), "% Complete\n"))
  }
}

# Declare them as zoo objects for use with time-series functions
DATA <- lapply (DATA, function(v) zoo (v[,2: ncol (v)], strptime (v[,1], "%Y-%m-%d")))
