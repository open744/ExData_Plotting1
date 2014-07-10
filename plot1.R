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

## PLOT 1
png('plot1.png', width=480, height=480)
hist(d$Global_active_power, col='red', main='Global Active Power', xlab='Global Active Power (kilowatts)')
dev.off()
