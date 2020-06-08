## Import Files, checks if files already stored as data frames

if(!exists("NEI")){
    NEI <- readRDS("./data/summarySCC_PM25.rds")
}
if(!exists("SCC")){
    SCC <- readRDS("./data/Source_Classification_Code.rds")
}

## Have total emissions from PM2.5 decreased in the United States from 1999 to 2008?
## Using the base plotting system, make a plot showing the total PM2.5 emission 
## from all sources for each of the years 1999, 2002, 2005, and 2008.
NEI$year <- as.factor(NEI$year)


## Initialize vector for loop
tmp.NEI.TotalLevel <- NULL
tmp.NEI.TotalYear <- NULL

## Loop aggregates data totals by year for pollutants
for(i in 1:length(levels(NEI$year))){
    tmp.NEI.TotalYear <- rbind(tmp.NEI.TotalYear, levels(NEI$year)[i])
    tmp.NEI.TotalLevel <- rbind(tmp.NEI.TotalLevel, sum(NEI[which(NEI$year == levels(NEI$year)[i]),4]))
}

## Creates a data frame with year and aggregate total for pollutants
NEI.Total <- data.frame(tmp.NEI.TotalYear, tmp.NEI.TotalLevel)

names(NEI.Total) <- c("Year", "Total Emissions")

## Begin plot
png(filename = 'plot1.png')

barplot(NEI.Total$`Total Emissions`, 
        names = NEI.Total$Year, 
        xlab = "Year", 
        ylab = "Total PM2.5 Emissions",
        main = "Yearly Totals of PM2.5 Emissions")

dev.off()
