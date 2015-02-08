# plot1.R
# part of the Peer Assessment Project 1 for Exploratory Data Analysis
# this code snippet, produces a single plot which details the
# electric power consumption in households with a one-minute sampling rate 
# based on the data collected 
# during the period 01/Feb/2007 and 02/Feb/2007. 
# 
# this program creates a single .png file with the following histogram 
# using the base plotting system in R
#   1 - Global Active Power (kilowatts)

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
fullData <- read.table(fileConn, header = TRUE, na.strings = "?", sep = ";", colClasses = colClasses)  
fullData$fDate <- as.Date(fullData$Date, "%d/%m/%Y")

# the dates for which we are looking for ...
dateFilter = c(as.Date("2007-02-01"), as.Date("2007-02-02"))

message("starting the plot...")

#subset the data now ...
plotData <- fullData[fullData$fDate %in% dateFilter,]

#prepare to plot now ... 
png(filename = "plot1.png", width = 480, height = 480, units="px", bg = "transparent")

#histogram plot plot1
hist( plotData$Global_active_power, 
      col="red", 
      xlab = "Global Active Power (kilowatts)", 
      main="Global Active Power" )

#save the file
dev.off()

message("...done!")