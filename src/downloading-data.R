#download stock data to local directory tutorial
setwd("~/Algorithmic Trading scripts/R-Trading/")
#get complete list of S&P 500 symbols
SPY_symb<-read.csv("SPY_symbols/S&P500.csv", stringsAsFactors = FALSE)
SPY_symb%<>%pull(Symbol)
#get list of blaclisted symbols
blacklist<-read_lines(file = "SPY_symbols/black_list.csv", skip_empty_rows = TRUE)

#get symbols in stockdata directory
in_file<-list.files("stockdata/")
in_file<-unlist(strsplit(in_file, ".", fixed =TRUE))
in_file<-in_file[in_file != "csv"]
SPY_symb<-union(setdiff(blacklist, SPY_symb), setdiff(SPY_symb, blacklist))

to_load<-NA
if(is_empty(in_file)){
  to_load<-SPY_symb
}else{
  to_load <- union(setdiff(in_file, SPY_symb), setdiff(SPY_symb, in_file))
}

#load the data
flag <- 1

for(i in 1:length(to_load)){
  
  curr_symbol<-tryCatch({
    getSymbols(to_load[i])
  },warning = function(w){
    write_lines(x = to_load[i], path = "SPY_symbols/black_list.csv", append = TRUE)
    next()
  })
  
  write.zoo(curr_symbol, file = paste0("stockdata/", to_load[i], ".csv"), index.name = "Date")

}
