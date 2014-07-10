### 2014-7-10 exdata project 1

library(data.table)
src.filename <- 'household_power_consumption.txt'
power.data <- 'power.RData'

## returns a data.table (9 columns)
getData <- function(fn=src.filename) {
    ## find the subset of rows quickly, by using data.table::fread()
    ## (skip loading columns 2:9)

    d <- fread(fn, sep=';', colClasses=c('character',rep('NULL', 8)))
    start <- match('1/2/2007', d$Date)
    end <- match('3/2/2007', d$Date)

    ## now read the column names, and the rows of interest
    header <- fread(fn, sep=';', nrows=0)
    d <- fread(fn, sep=';', skip=start, nrows=end-start)

    ## setup column names & types
    setnames(d, names(header))
    d$datetime <- as.POSIXct(paste(d$Date, d$Time), format='%d/%m/%Y %H:%M')
    d
}

if (file.exists(power.data)) {
    load(power.data)
} else {
    d <- getData()
}

## PLOT 3
png('plot3.png', width=480, height=480)

plot(Sub_metering_1~datetime, data=d, type='l', col='black', xlab='', ylab='Energy sub metering')
lines(Sub_metering_2~datetime, data=d, col='red')
lines(Sub_metering_3~datetime, data=d, col='blue')
legend('topright', legend=names(d)[7:9], col=c('black', 'red', 'blue'), lty='solid')

dev.off()
