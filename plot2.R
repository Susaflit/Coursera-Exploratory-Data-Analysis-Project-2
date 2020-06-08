## Import Files, checks if files already stored as data frames

if(!exists("NEI")){
    NEI <- readRDS("./data/summarySCC_PM25.rds")
}
if(!exists("SCC")){
    SCC <- readRDS("./data/Source_Classification_Code.rds")
}

NEI$year <- as.factor(NEI$year)
NEI$fips <- as.factor(NEI$fips)

## Have total emissions from PM2.5 decreased in the Baltimore City, Maryland (fips == "24510") 
## from 1999 to 2008? Use the base plotting system to make a plot answering this question.

## Reform data to only include data from Baltimore
NEI.Baltimore <- NEI[which(NEI$fips == "24510"),]



## Initialize vector for loop
tmp.NEI.TotalLevel <- NULL
tmp.NEI.TotalYear <- NULL

## Loop aggregates data totals by year for pollutants
for(i in 1:length(levels(NEI.Baltimore$year))){
    tmp.NEI.TotalYear <- rbind(tmp.NEI.TotalYear, levels(NEI.Baltimore$year)[i])
    tmp.NEI.TotalLevel <- rbind(tmp.NEI.TotalLevel, sum(NEI.Baltimore[which(NEI.Baltimore$year == levels(NEI.Baltimore$year)[i]),4]))
}

## Creates a data frame with year and aggregate total for pollutants
NEI.Total <- data.frame(tmp.NEI.TotalYear, tmp.NEI.TotalLevel)

names(NEI.Total) <- c("Year", "Total Emissions")


## Begin plot
png(filename = 'plot2.png')

barplot(NEI.Total$`Total Emissions`, 
        names = NEI.Total$Year, 
        xlab = "Year", 
        ylab = "Total PM2.5 Emissions",
        main = "Baltimore Yearly Totals of PM2.5 Emissions")

## End plot
dev.off()
