#clean enviroment
rm(list=ls(all.names = TRUE))

library(NLP)
library(tm)
library(jiebaRD)
library(jiebaR)
library(RColorBrewer)
library(wordcloud)

#get name of file
filename <- list.files(getwd(), pattern="*.csv")

#get data from selected file
files <- read.csv(filename)
docs <- files$result.records.sarea

#
freqFrame = as.data.frame(table(unlist(docs)))

par(family=("Heiti TC Light"))
wordcloud(freqFrame$Var1,freqFrame$Freq,
          min.freq=1,max.words=1000,
          random.order=TRUE, random.color=FALSE,
          scale=c(2,0.1), rot.per=.1, colors=brewer.pal(8, "Dark2"),
          ordered.colors=FALSE,use.r.layout=FALSE,
          fixed.asp=TRUE)
