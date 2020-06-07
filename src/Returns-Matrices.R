#returns matrices
# Compute Daily Close-to-Close Returns
RETURN <- (DATA[["Close"]] / xts::lag.xts(DATA[["Close"]], k = -1)) - 1
# Compute Overnight Returns (Close-to-Open)
OVERNIGHT <- (DATA[["Open"]] / xts::lag.xts(DATA[["Close"]], k = -1)) - 1
