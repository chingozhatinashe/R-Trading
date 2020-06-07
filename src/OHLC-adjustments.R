# Divedend split adjustments

# Declare new zoo data frame of adjustment factors
MULT <- DATA[["Adjusted"]] / DATA[["Close"]]
# Store Close and Open Prices in new variable "Price" and "OpenPrice"
DATA[["Price"]] <- DATA[["Close"]]
DATA[["OpenPrice"]] <- DATA[["Open"]]
# Adjust Open, High, and Low
DATA[["Open"]] <- DATA[["Open"]] * MULT
DATA[["High"]] <- DATA[["High"]] * MULT
DATA[["Low"]] <- DATA[["Low"]] * MULT
# Copy Adjusted Close to Close
DATA[["Close"]] <- DATA[["Adjusted"]]
# Delete Adjusted Close
DATA[["Adjusted"]] <- NULL

# For inactive symbols do last observation carried forward NA replacement
# Set volume to zero for inactive period
for( s in names(DATA[["Close"]]) ){
  
  if(is.na(DATA[["Close"]][nrow(DATA[["Close"]]), s])){
    maxInd <- max(which(!is.na(DATA[["Close"]][,s])))
    for( i in c("Close", "Open", "High", "Low")){
      DATA[[i]][(maxInd+1):nrow(DATA[["Close"]]),s] <- DATA[["Close"]][maxInd,s]
    }
    for( i in c("Price", "OpenPrice") ){
      DATA[[i]][(maxInd+1):nrow(DATA[["Close"]]),s] <- DATA[["Price"]][maxInd,s]
    }
    DATA[["Volume"]][(maxInd+1):nrow(DATA[["Close"]]),s] <- 0
  }
}
