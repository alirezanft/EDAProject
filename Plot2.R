# Data URL
Url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"

# Getting files from a Zip file
if (!file.exists("exdata_data_NEI_data")){
        temp <- tempfile()
        download.file(Url, temp)
        unzip(temp)
        unlink(temp)
}

# This first line will likely take a few seconds. Be patient!
NEI <- readRDS("exdata_data_NEI_data/summarySCC_PM25.rds")
SCC <- readRDS("exdata_data_NEI_data/Source_Classification_Code.rds")

# Getting only the Baltimore city data
BaltimoreCity <- subset(NEI, fips == "24510")

# The sum of emissions for the Baltimore city per years
totalPM25ofBCByYear <- tapply(BaltimoreCity$Emissions, BaltimoreCity$year, sum)

# The answered plot
plot(names(totalPM25ofBCByYear), totalPM25ofBCByYear, type = "l", xlab = "Year", 
     ylab = expression("Total" ~ PM[2.5] ~ "Emissions (tons)"), 
     main = expression("Total Baltimore City" ~ PM[2.5] ~ "Emissions by Year"))

# Save plot in a PNG format
dev.copy(png, file = "plot2.png", height = 850, width = 650)
dev.off()
