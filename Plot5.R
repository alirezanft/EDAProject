# Needed libraries
library(dplyr)
library(ggplot2)

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

# The moving veheicles emission data collectore for Baltimore city
BaltimoreCityMV <- subset(NEI, fips == "24510" & type=="ON-ROAD")

# The sum of emissions for the MV data collectore for the Baltimore city per years
BaltimoreMVPM25ByYear <- BaltimoreCityMV %>% select (year, Emissions) %>% 
        group_by(year) %>% 
        summarise_each(funs(sum))

# The answered plot
qplot(year, Emissions, data=BaltimoreMVPM25ByYear, geom="line") +
        ggtitle(expression("Baltimore City" ~ PM[2.5] ~ "Motor Vehicle Emissions by Year")) +
        xlab("Year") + 
        ylab(expression("Total" ~ PM[2.5] ~ "Emissions (tons)"))

# Save plot in a PNG format
dev.copy(png, file = "plot5.png", height = 650, width = 650)
dev.off()
