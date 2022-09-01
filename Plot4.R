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

# A dataframe for types of coal emissions from the SCC file
CoalCombustionSCC0 <- subset(SCC, EI.Sector %in% c("Fuel Comb - Comm/Instutional - Coal",
                                                   "Fuel Comb - Electric Generation - Coal",
                                                   "Fuel Comb - Industrial Boilers, ICEs - Coal"))

# A Coal and Comb dataframe from the SCC file 
CoalCombustionSCC1 <- subset(SCC, grepl("Comb", Short.Name) & 
                                     grepl("Coal", Short.Name))

# Codes of Comb and Coal from SCC file to subset the NEI file
CoalCombustionSCCCodes <- union(CoalCombustionSCC0$SCC, CoalCombustionSCC1$SCC)

# A dataframe for the subsetted NEI file based on Coal and Comb
CoalCombustion <- subset(NEI, SCC %in% CoalCombustionSCCCodes)

# The sum of emissions by type for the Coal emission per years
coalCombustionPM25ByYear <- CoalCombustion %>% select(year, type, Emissions) %>%
        group_by(year, type) %>%
        summarise_each(funs(sum))

# The answered plot
qplot(year, Emissions, data = coalCombustionPM25ByYear, color = type, geom = "line") + 
        stat_summary(fun.y = "sum", aes(year, Emissions, color = "Total"), geom = "line") +
        ggtitle(expression("Coal Combustion" ~ PM[2.5] ~ "Emissions by Source Type and Year")) + 
        xlab("Year") + 
        ylab(expression  ("Total" ~ PM[2.5] ~ "Emissions (tons)"))

# Save plot in a PNG format
dev.copy(png, file = "plot4.png", height = 650, width = 650)
dev.off()