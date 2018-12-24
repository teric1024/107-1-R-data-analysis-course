rm(list=ls(all.names = TRUE))

#set working directory here
setwd(dirname(rstudioapi::getSourceEditorContext()$path))

filenames <- list.files('./raw_data', pattern="*.csv")

makecomma <- function(filename){
  path <- './raw_data/'
  filepath <- paste(path, filename, sep = '')
  data1<-read.csv(filepath, header=T, sep="\t")
  write.csv(data1, file = paste("new",filename), row.names = FALSE)
}

for (ele in filenames){
  makecomma(ele)
}

#data <- read.table('new 臺南市 市長選舉.csv', header = T, sep = ",")
