rm(list = ls())

#load packages
library(bitops)
library(httr)
library(RCurl)
library(XML)
library(tm)
library(NLP)
library(tmcn)
library(jiebaRD)
library(jiebaR)

#get the website url of all the article from every pages
from <- 17412 # 2018-10-10
to   <- 17550 # 2018-10-17
prefix = "https://www.ptt.cc/bbs/C_Chat/index"
data <- list()
for( id in c(from:to) )
{
  url  <- paste0( prefix, as.character(id), ".html" )
  html <- htmlParse( GET(url) )
  url.list <- xpathSApply( html, "//div[@class='title']/a[@href]", xmlAttrs )
  data <- rbind( data, as.matrix(paste('https://www.ptt.cc', url.list, sep='')) )
}
data <- unlist(data)
head(data)

#get all the context, and sort them by date
library(dplyr)
getdoc <- function(url)
{
  html <- htmlParse( getURL(url) )
  doc  <- xpathSApply( html, "//div[@id='main-content']", xmlValue )
  time <- xpathSApply( html, "//*[@id='main-content']/div[4]/span[2]", xmlValue )
  temp <- gsub( "  ", " 0", unlist(time) )
  part <- strsplit( temp, split=" ", fixed=T )
  #part form like -> "Tue"      "Oct"      "09"       "23:43:27" "2018"
  date <- part[[1]][3]
  day <- part[[1]][1]
  #print(date and dat)
  name <- paste0('./DATA/', date, "__", day, ".txt")
  write(doc, name, append = TRUE)
}
test.data <- data[1:1058]
sapply(test.data, getdoc)
#structure of data[1059] is not as same as the others
#https://www.ptt.cc/bbs/C_Chat/M.1539346213.A.3D3.html
test.data = data[1060:1437]
sapply(test.data, getdoc)

#structure of data[1438] is not as same as the others
#https://www.ptt.cc/bbs/C_Chat/M.1539438107.A.869.html
test.data <- data[1439:2724]
sapply(test.data, getdoc)

#cannot opent data[2161]
#https://www.ptt.cc/bbs/C_Chat/M.1539603620.A.E09.html
test.data <- data[2162:2724]
sapply(test.data, getdoc)

#stop at data[2311]
#https://www.ptt.cc/bbs/C_Chat/M.1539645748.A.C76.html
test.data <- data[2311:2724]
sapply(test.data, getdoc)

#stop at data[2724]
#https://www.ptt.cc/bbs/C_Chat/M.1539747042.A.B75.html