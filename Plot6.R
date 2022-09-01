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

# The moving veheicles emission data collectore for Baltimore city and Los Angeles
MV <- subset(NEI, (fips == "24510" | fips == "06037") & type == "ON-ROAD")

# Change the fips code with the names of cities
MV <- transform(MV, region = ifelse(fips == "24510", "Baltimore City", 
                                    "Los Angeles"))

# The sum of emissions for the MV data collectore for the Baltimore and Los Angeles city per years
MVPM25ByYearAndRegion <- MV %>% select (year, region, Emissions) %>% 
        group_by(year, region) %>% 
        summarise_each(funs(sum))

# The answered plot
qplot(year, Emissions, data=MVPM25ByYearAndRegion, geom="line", color=region) +
        ggtitle(expression("Total" ~ PM[2.5] ~ "Motor Vehicle Emissions")) + 
        xlab("Year") +
        ylab(expression("Normalized" ~ PM[2.5] ~ "Emissions"))

# Save plot in a PNG format
dev.copy(png, file = "plot6.png", height = 650, width = 650)
dev.off()
