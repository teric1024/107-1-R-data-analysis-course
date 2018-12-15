rm(list=ls(all.names = TRUE))

filenames <- list.files(getwd(), pattern="*.csv")

makecomma <- function(filename){
data1<-read.table(filename, header=T, sep="\t")
write.table(data1, file = paste("new",filename), sep = ",")
}
for (ele in filenames){
  makecomma(ele)
}
