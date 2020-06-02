#just playing around and trying out stuff in here
library(quantmod)
library(plotly)
library(dplyr)
library(magrittr)
library(tidyverse)
library(data.table)
#supress warnings
options("getSymbols.warning4.0" = FALSE,
        "getSymbols.auto.assign" = FALSE)

#load S&P 500 ETF data, closing prices
SPY <- suppressWarnings(
  getSymbols(c("SPY"), from = "2012-01-01"))
SPY <- as.numeric(SPY$SPY.Close)[1:987]

set.seed(123)

#create time index
t <- 1:(length(SPY))
#tradable capital vector
Vt<-c(rep(10000, length(SPY)))
#create benchmark return(derivative of SPY closing values using order 1 backward difference)
Rb<-c(rep(NA, length(t)))

for(i in 2:length(Rb)){
  Rb[i]<-(SPY[i]/SPY[i - 1]) - 1
}
#benchmark equity curve
Eb <- rep(NA, length(t))
Eb[1] <- Vt[1]
for(i in 2:length(t)) { Eb[i] <- Eb[i-1] * (1 + Rb[i]) }

#Simulated returns series 1
Rt <- rep(NA, length(t))
for(i in 2:length(t)){
  Rt[i] <- Rb[i] + rnorm(n = 1,
                         mean = 0.24/length(t),
                         sd = 2.5 * sd(Rb, na.rm = TRUE))
}

# Randomly Simulated Return Series 2
Rt2 <- rep(NA, length(t))
for(i in 2:length(t)){
  Rt2[i] <- Rb[i] + rnorm(n = 1,
                          mean = 0.02/length(t),
                          sd = .75 * sd(Rb, na.rm = TRUE))
}

# Randomly Simulated Equity Curve 1
Et <- rep(NA, length(t))
Et <- Vt[1]
for(i in 2:length(t)) { Et[i] <- Et[i-1] * (1 + Rt[i]) }
# Randomly Simulated Equity Curve 2
Et2 <- rep(NA, length(t))
Et2 <- Vt[1]
for(i in 2:length(t)) { Et2[i] <- Et2[i-1] * (1 + Rt2[i]) }
# Plot of Et1 against the SPY Portfolio
plot_ly(x = t, y = Eb, type = 'scatter', mode = 'lines', name = "SPY")%>%
  add_trace(y = Et, name = "Portfolio 1")%>%
  add_trace(y = Et2, name = "Portfolio 2")%>%
  add_segments(x = 0, xend = 900, y = 10000, yend = 10000)%>%
  layout(xaxis = list('title' = "time"), yaxis = list('title' = "Equity ($)"))
#################calculating ratios#####################################################
#Sharpe ratio
SR<-mean(Rt, na.rm = TRUE)/sd(Rt, na.rm = TRUE)
SR2<-mean(Rt2, na.rm = TRUE)/sd(Rt2, na.rm = TRUE)
SRb<-mean(Rb, na.rm = TRUE)/sd(Rb, na.rm = TRUE)

temp<-getSymbols(c("AAL"), auto.assign = FALSE, from = strptime(currentTime, "%Y-%m-%d"))
