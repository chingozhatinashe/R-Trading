#calculating indicators

exampleset <- c("AAPL", "GOOGL", "TIF")

DATA <- getSymbols(exampleset, auto.assign = TRUE)

temp <- AAPL[, "AAPL.Adjusted"]
plot(temp)
#simple moving average
n <- 20
SMA_20 <- rollapply(temp, width = n,
                    FUN = mean, align = "right", by.column = TRUE,
                    fill = NA)

plot(SMA_20)
############################################################################
n1 <- 2
n2 <- 100
MACDseries <- rollapply(temp,
            width = n2,
            FUN = function(v) mean(v[(n2 - n1 + 1):n2]) - mean(v),
            by.column = TRUE,
            fill = NA,
            align = "right")
plot(MACDseries)
###############################Bollinger bands###################################################
n <- 20
mean_series <- rollapply(temp, width = n,
                         FUN = mean, align = "right", by.column = TRUE,
                         fill = NA)

rollsd <- rollapply(temp,
                    width = n,
                    FUN = sd,
                    by.column = TRUE,
                    fill = NA,
                    align = "right")
upperseries <- mean_series + 2 * rollsd
lowerseries <- mean_series + 2 - rollsd
datetemp <- index(mean_series)
mean_series <- as.vector(mean_series$AAPL.Adjusted)
upper_series <- as.vector(upperseries$AAPL.Adjusted)
lowerseries <- as.vector(lowerseries$AAPL.Adjusted)
actual <- as.vector(temp$AAPL.Adjusted)
plot_ly(x = datetemp, y = mean_series, type = 'scatter', mode = 'lines', name = "Mean")%>%
  add_trace(y = upper_series, name = "Upper")%>%
  add_trace(y = lowerseries, name = "Lower")%>%
  add_trace(y = actual, name = "Actual")
#################################Custom indicator##############################
n <- 10
customseries <-
  rollapply(as.vector(temp[, "AAPL.Adjusted"]),
            width = n,
            FUN = function(v) cor(v, n:1)^2 * ((v[n] - v[1])/n),
            by.column = TRUE,
            fill = NA,
            align = "right")
plot_ly(x = datetemp, y = customseries, type = 'scatter', mode = 'lines')
######################################################################################