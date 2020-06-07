#calculating indicators

exampleset <- c("AAPL", "GOOGL", "TIF")

#simple moving average
n <- 20
SMA_20 <- rollapply(DATA[["Close"]][, exampleset], width = n,
                    FUN = mean, align = "right", by.column = TRUE,
                    fill = NA)
################plot##################################
temp <- tidy()