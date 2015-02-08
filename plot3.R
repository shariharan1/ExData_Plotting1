# plot3.R
# part of the Peer Assessment Project 1 for Exploratory Data Analysis
# this code snippet, produces a single plot which details the
# electric power consumption in households with a one-minute sampling rate 
# based on the data collected 
# during the period 01/Feb/2007 and 02/Feb/2007. 
# 
# this program creates a single .png file with the following plots
#   1 - Energy Sub metering

# this program expects either the .zip or .txt file available in the current directory
# else will download the .zip from the URL and then processes it

linkUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
zipFile <- "exdata-data-household_power_consumption.zip"
textFile <- "household_power_consumption.txt"

## Check and download the file if necessary
## will not download if the .txt file is already present in the current folder!
if (!file.exists(zipFile) ) {
  if (!file.exists(textFile)) {
    message ("Both zip & txt doesn't exist! Starting download ...")
    download.file(linkUrl, zipFile, method="curl", quiet = TRUE)
    dateDownloaded <- date()
    useZip <- TRUE
  } else {
    message ("txt file found! using the txt file...")
    useZip <- FALSE
  }
} else {
  message ("zip file found! using the zip file...")
  useZip <- TRUE
}

## open the connection, based on the mode determined above!
fileConn <- NULL
if (useZip == TRUE) {
  fileConn<-unz(zipFile, textFile)
} else {
  fileConn<-file(textFile)
}

message("loading the data ...")

## identify the colClasses
colClasses <- c("character", "character", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric" )

## read the data in to the table!
#data <- read.table(fileConn, header = TRUE, colClasses = colClasses, na.strings = "?")
fullData <- read.table(fileConn, header = TRUE, na.strings = "?", sep = ";", colClasses = colClasses)  
fullData$fDate <- as.Date(fullData$Date, "%d/%m/%Y")

# the dates for which we are looking for ...
dateFilter = c(as.Date("2007-02-01"), as.Date("2007-02-02"))

#subset the data now ...
plotData <- fullData[fullData$fDate %in% dateFilter,]

#add the time column ... 
plotData$fTime <- strptime(paste(plotData$Date, plotData$Time), format = "%d/%m/%Y %H:%M:%S")

message("starting the plot...")

#prepare to plot now ... 
png(filename = "plot3.png", width = 480, height = 480, units="px", bg = "transparent")

#scatter plot plot3
with(plotData, 
     { plot(fTime, Sub_metering_1, 
            main = "", 
            type="l", 
            xlab="", 
            ylab="Energy sub metering")
       lines(fTime, Sub_metering_2, col = "red") 
       lines(fTime, Sub_metering_3, col = "blue") 
      } )

legend("topright", 
       lwd=2, 
       col = c("black", "red", "blue"), 
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3")
      )

#save the file
dev.off()

message("...Done!")

