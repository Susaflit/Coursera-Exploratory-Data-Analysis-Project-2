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

## Create data table for Baltimore related rows
data.combined.Baltimore <- data.combined[which(data.combined$fips == "24510"),]

## finds index of motor vehicle related emissions in Baltimore, stores those rows in new data frame
if(!exists("Baltimore.Car")){
    index <- grepl("vehicle", data.combined.Baltimore$SCC.Level.Two, ignore.case=TRUE)
    Baltimore.Car <- data.combined.Baltimore[index,]
}

## Create data table for Los Angeles County related rows
data.combined.LA <- data.combined[which(data.combined$fips == "06037"),]

## finds index of motor vehicle related emissions in Los Angeles County, stores those rows in new data frame
if(!exists("LA.Car")){
    index <- grepl("vehicle", data.combined.LA$SCC.Level.Two, ignore.case=TRUE)
    LA.Car <- data.combined.LA[index,]
}

## Compare emissions from motor vehicle sources in Baltimore City with emissions 
## from motor vehicle sources in Los Angeles County, California (fips == "06037").
## Which city has seen greater changes over time in motor vehicle emissions?

car.combined <- rbind(LA.Car, Baltimore.Car)

## Rename fips to City
##names(car.combined)[2] <- "City"
##car.combined$City <- as.character(car.combined$City)
##car.combined$City[which(car.combined$City == "06037")] <- "Los Angeles"
##car.combined$City[which(car.combined$City == "24510")] <- "Baltimore"
##car.combined$City <- as.factor(car.combined$City)
    
levels(car.combined$fips)[which(levels(car.combined$fips) == "06037")] <- "Los Angeles"
levels(car.combined$fips)[which(levels(car.combined$fips) == "24510")] <- "Baltimore"

names(car.combined)[which(names(car.combined) == "fips")] <- "City"

png("plot6.png")

ggplot(car.combined, aes(x = year, y = Emissions, fill = City)) +
    geom_bar(aes(fill = year), stat="identity") +
    facet_wrap(. ~ City) +
    labs(title = "Baltimore vs LA Vehicle Emissions by Year PM2.5") +
    guides(fill = guide_legend(title = "Year"))

dev.off()





