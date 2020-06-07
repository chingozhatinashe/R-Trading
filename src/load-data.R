#load data from memory
setwd("~/Algorithmic Trading scripts/R-Trading/")

stock.symb<-sub(".csv", "", list.files("stockdata/"))

DATA <- list()

for(i in stock.symb){
  DATA[[i]] <- fread(paste0("stockdata/", i, ".csv"), sep = " ")
  DATA[[i]]%<>%arrange(Date)
}

###################update data##############################
#set system time to EST necessary for Yahoo API
Sys.setenv(TZ = 'EST')

currentTime <- Sys.time()

for(i in stock.symb){
  curr_symbol <- DATA[[i]]
  maxdate <- curr_symbol%>%
    pull(Date)%>%
    max()
  
#has the YAHOO API updated since maxdate
  if(as.numeric(difftime(currentTime, maxdate, units = "hours")) > 40.25){
    
    #push maxdate 1 day forward
    maxdate<-strptime(maxdate, "%Y-%m-%d") + 86400
    
    #is it the weekend
    weekend <- sum(c("Saturday", "Sunday") %in% 
                     weekdays(c(maxdate, currentTime)))==2
    span <- FALSE
    
    if(weekend){
      span <- as.numeric(difftime(currentTime, maxdate, units = "hours")) >= 48
    }
    
    if(!weekend & !span){
      #download data from API
      df = tryCatch({
        getSymbols(c(i), from = strptime(maxdate, "%Y-%m-%d"), auto.assign = FALSE)
      }, error = function(e){
        NULL
      })
      #df <- getSymbols(i, from = strptime(currentTime, "%Y-%m-%d"))
      
      if(!is.null(df)){
        if(all(!is.na(df)) & nrow(df) > 0){
          df<-df[nrow(df):1]
          write.zoo(df, file = paste0("stockdata/", i, ".csv"), index.name = "Date", append = TRUE, col.names = FALSE)
          DATA[[i]]<-rbind(DATA[[i]], df)
        }
      }
    }
  }
}