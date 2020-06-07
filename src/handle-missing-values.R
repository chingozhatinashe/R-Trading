#methods of dealing with NAs
temp<-getSymbols(c("A"), auto.assign = FALSE)
temp<-temp[, 4]
plot(temp)

holiday<-seq.Date(from = as.Date("2015-11-23"), to = as.Date("2015-12-03"), by = 'day')
temp%<>%window(start = as.Date("2015-11-01", end = as.Date("2015-12-31")))
temp[index(temp) %in% holiday]<-NA
plot(temp[year(index(temp))==2015])
temp%<>%na.spline()
plot(temp[year(index(temp))==2015])
