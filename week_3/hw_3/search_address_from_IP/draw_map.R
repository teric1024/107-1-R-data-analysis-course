#----------install ggmap with register_google--------
#install.packages("devtools")
#library(devtools)
#install_github("dkahle/ggmap")
#---------------------------------------------------

#get the data
address <- read.csv("address.csv")
longitude <- as.numeric(address["longitude"])
lantitude <- as.numeric(address["lantitude"])

#ref: https://blog.gtwang.org/r/r-ggmap-package-spatial-data-visualization/
#install.packages('ggmap')
#install.packages("mapproj")
library(ggmap)
library(mapproj)
library(ggplot2)
register_google(key = "AIzaSyCYIbzoIJnDaWbTjYg2do0cJvnKvQcfdos", day_limit = 1000)
ggmap_credentials()

#make the camera in place
map <- get_map(location = c(lon = longitude, lat = lantitude),
               zoom = 15, maptype = "roadmap")

#plot the location
ggmap(map, darken = c(0.5, "white")) + geom_point(aes(x = longitude, y = lantitude), data = address, color = "red")
