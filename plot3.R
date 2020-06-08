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

## Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad) variable,
## which of these four sources have seen decreases in emissions from 1999–2008 for Baltimore City? 
## Which have seen increases in emissions from 1999–2008? Use the ggplot2 plotting system to make a plot answer this question.

## Reform data to only include data from Baltimore
NEI.Baltimore <- NEI[which(NEI$fips == "24510"),]

## Create Bar Plot of data with facet wrap to split data into separate graphs by source of pollution
png("plot3.png")

ggplot(NEI.Baltimore, aes(year, Emissions, fill = type)) +
    geom_bar(stat = "identity") +
    facet_wrap(. ~ type) +
    labs(title = "Baltimore Yearly Emissions of PM 2.5 by Source of Pollution")

dev.off()