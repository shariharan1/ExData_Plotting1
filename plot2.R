# plot2.R
# part of the Peer Assessment Project 1 for Exploratory Data Analysis
# this code snippet, produces a single plot which details the
# electric power consumption in households with a one-minute sampling rate 
# based on the data collected 
# during the period 01/Feb/2007 and 02/Feb/2007. 
# 
# this program creates a single .png file with the following scatter plots using 
# the base plotting system in R
#   1 - Global Active Power (kilowatts)

# setwd("/Users/shariharan/Dropbox/OnlineCourses/Coursera/ExpDataAnalysis/Project1")

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
#data <- read.table(fileConn, header = TRUE, colClasses = colClasses, na.strings = "?")
fullData <- read.table(fileConn, header = TRUE, na.strings = "?", sep = ";", colClasses = colClasses)  
fullData$fDate <- as.Date(fullData$Date, "%d/%m/%Y")

# the dates for which we are looking for ...
dateFilter = c(as.Date("2007-02-01"), as.Date("2007-02-02"))

#subset the data now ...
plotData <- fullData[fullData$fDate %in% dateFilter,]

#add the time column ... 
plotData$fTime <- strptime(paste(plotData$Date, plotData$Time), format = "%d/%m/%Y %H:%M:%S")

#prepare to plot now ... 
png(filename = "plot2.png", width = 480, height = 480, units="px")

#scatter plot plot2
plot(plotData$fTime, 
      plotData$Global_active_power, 
      type="l", 
      ylab = "Global Active Power (kilowatts)", 
      xlab="" )  

#save the file
dev.off()
