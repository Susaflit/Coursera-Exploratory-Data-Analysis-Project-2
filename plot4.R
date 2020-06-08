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

## Across the United States, how have emissions from coal combustion-related sources changed from 1999–2008?

## combines data if a combined set is not found in environment
if(!exists("data.combined")){
    data.combined <- merge(NEI, SCC, by = "SCC")
}

## finds index of coal related emissions, stores those rows in new data frame
if(!exists("data.combined.coal")){
    index <- grepl("coal", data.combined$Short.Name, ignore.case=TRUE)
    data.combined.coal <- data.combined[index,]
}

## Initialize vector for loop
tmp.data.combined.TotalLevel <- NULL
tmp.data.combined.TotalYear <- NULL

## Loop aggregates data totals by year for pollutants
for(i in 1:length(levels(data.combined.coal$year))){
    tmp.data.combined.TotalYear <- rbind(tmp.data.combined.TotalYear, 
                                         levels(data.combined.coal$year)[i])
    tmp.data.combined.TotalLevel <- rbind(tmp.data.combined.TotalLevel, 
                                          sum(data.combined[which(data.combined.coal$year == levels(data.combined.coal$year)[i]),4]))
}

## Creates a data frame with year and aggregate total for pollutants
data.combined.coal.total <- data.frame(tmp.data.combined.TotalYear, 
                                       tmp.data.combined.TotalLevel)

names(data.combined.coal.total) <- c("Year", "TotalEmissions")

## Create Bar Plot of data with facet wrap to split data into separate graphs by source of pollution
png("plot4.png")

ggplot(data.combined.coal.total, aes(Year, TotalEmissions)) +
    geom_bar(stat = "identity", fill = data.combined.coal.total$Year) +
    labs(title = "Yearly Coal Emissions")

dev.off()




