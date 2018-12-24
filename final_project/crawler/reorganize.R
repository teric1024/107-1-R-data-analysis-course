rm(list=ls(all.names = TRUE))

#set working directory here
setwd(dirname(rstudioapi::getSourceEditorContext()$path))

filenames <- list.files('./', pattern="*new")

sortdata <- function(filename){
#filename = filenames[1]
  data1<-read.csv(filename, header=T, sep=",")
  areaname <- as.vector(data1[["地區"]])
  split.area <- function(name){
    name <- as.character(name)
    return (c(strsplit(name,split=" ",fixed=T)))
  }
  areaname <- as.data.frame(sapply(areaname, split.area))
  areaname <- t(areaname)
  data1$"縣市" <- areaname[,1]
  data1$"鄉鎮市區" <- areaname[,2]
  data1$"X" <- NULL
  data1$"地區" <- NULL
  return (data1)
}

alldata <- data.frame()
for (x in filenames){
  data.vote <- sortdata(x)
  alldata <- rbind(data.vote, alldata)
}
write.csv(alldata, file = "all_votes_data.csv", row.names = F)
