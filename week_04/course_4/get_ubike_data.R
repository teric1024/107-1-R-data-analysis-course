rm(list=ls(all.names = TRUE))

library(jsonlite)

# The TPE Bike opendata json url
url <- 'http://data.ntpc.gov.tw/api/v1/rest/datastore/382000000A-000352-001'

#Get it with jsonlite package
jsonData <- fromJSON(url, flatten = TRUE)

#Write it into csv.
write.csv(file = 'test_ubike.csv', jsonData , fileEncoding = 'utf-8')
