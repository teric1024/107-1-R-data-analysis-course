rm(list = ls(all=TRUE))
library(leaflet)
library(magrittr)
data <- read.csv("test_ubike.csv")
options(digits=8)
lng <- data$result.records.lng[]
b=lat=locate$Latitude
c=popup=locate$loc


map <- leaflet() %>%
  addMarkers(lng=data$result.records.lng[1:504],lat=data$result.records.lat[1:504]) %>%
  addTiles() 
map
