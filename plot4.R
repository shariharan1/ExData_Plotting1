# plot4.R
# part of the Peer Assessment Project 1 for Exploratory Data Analysis
# this code snippet, plots 4 plots which details the
# electric power consumption in households with a one-minute sampling rate 
# based on the data collected 
# during the period 01/Feb/2007 and 02/Feb/2007. 
# 
# this program creates a single .png file with the following plots
#   1 - Global Active Power
#   2 - Voltage
#   3 - Sub-metering levels (3 diff levels)
#   4 - Global Reactive Power

linkUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
zipFile <- "exdata-data-household_power_consumption.zip"
textFile <- "household_power_consumption.txt"

## Check and download the file if necessary
## will not download if the .txt file is already present in the current folder!
if (!file.exists(zipFile) ) {
  if (!file.exists(textFile)) {
    download.file(linkUrl, zipFile)
    dateDownloaded <- date()
    useZip <- TRUE
  } else {
    useZip <- FALSE
  }
} else {
  useZip <- TRUE
}

## open the connection, based on the mode determined above!
fileConn <- NULL
if (useZip == TRUE) {
  fileConn<-unz(zipFile, textFile)
} else {
  fileConn<-file(textFile)
}

## identify the colClasses
colClasses <- c("character", "character", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric" )

## read the data in to the table!
fullData <- read.table(fileConn, header = TRUE, na.strings = "?", sep = ";", colClasses = colClasses)  
fullData$fDate <- as.Date(fullData$Date, "%d/%m/%Y")

# the dates for which we are looking for ...
dateFilter = c(as.Date("2007-02-01"), as.Date("2007-02-02"))

#subset the data now ...
plotData <- fullData[fullData$fDate %in% dateFilter,]

#add the time column ... 
plotData$fTime <- strptime(paste(plotData$Date, plotData$Time), format = "%d/%m/%Y %H:%M:%S")

#prepare to plot now ... 
png(filename = "plot4.png", width = 480, height = 480, units="px", bg = "transparent")

par(mfrow = c(2, 2))

with(plotData,
  {
    # draw the first plot ...
    plot(fTime, Global_active_power, type="l", ylab = "Global Active Power", xlab="")  
    
    # draw the second plot
    plot(fTime, Voltage, type="l", ylab = "Voltage", xlab="datetime")  

    # draw the third plot
    plot(fTime, Sub_metering_1, main = "", type="l", xlab="", ylab="Energy sub metering")
    lines(fTime, Sub_metering_2, col = "red") 
    lines(fTime, Sub_metering_3, col = "blue") 
    legend("topright", lwd=2, bty="n",
           col = c("black", "red", "blue"), 
           legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3")
    )
    
    # draw the fourth plot
    plot(fTime, Global_reactive_power, type="l", ylab = "Global_reactive_power", xlab="datetime")  
    
  } )

#save the file
dev.off()
