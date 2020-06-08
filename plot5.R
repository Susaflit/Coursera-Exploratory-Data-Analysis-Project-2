library("ggplot2")
## Import Files, checks if files already stored as data frames

if(!exists("NEI")){
    NEI <- readRDS("./data/summarySCC_PM25.rds")
}
if(!exists("SCC")){
    SCC <- readRDS("./data/Source_Classification_Code.rds")
}

NEI$year <- as.factor(NEI$year)
NEI$fips <- as.factor(NEI$fips)


## combines data if a combined set is not found in environment
if(!exists("data.combined")){
    data.combined <- merge(NEI, SCC, by = "SCC")
}

data.combined.Baltimore <- data.combined[which(data.combined$fips == "24510"),]

## finds index of motor vehicle related emissions in Baltimore, stores those rows in new data frame
if(!exists("Baltimore.Car")){
    index <- grepl("vehicle", data.combined.Baltimore$SCC.Level.Two, ignore.case=TRUE)
    Baltimore.Car <- data.combined.Baltimore[index,]
}

## How have emissions from motor vehicle sources changed from 1999–2008 in Baltimore City?

png("plot5.png")

ggplot(Baltimore.Car,aes(year,Emissions)) +
    geom_bar(stat="identity", fill = Baltimore.Car$year) +
    labs(title="Baltimore Yearly Emissions of PM 2.5 from Motor Vehicles")

dev.off()