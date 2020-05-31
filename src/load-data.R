#load data from memory
setwd("~/Algorithmic Trading scripts/R-Trading/")

stock.symb<-sub(".csv", "", list.files("stockdata/"))

DATA <- list()

for(i in stock.symb){
  DATA[[i]] <- fread(paste0("stockdata/", i, ".csv"), sep = ",")
  DATA[[i]]%<>%arrange()
}

temp<-read.csv("stockdata/temp.csv", sep = " ")
write.zoo(curr_symbol, "stockdata/temp.csv", index.name = "Date")
