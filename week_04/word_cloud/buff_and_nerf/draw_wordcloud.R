rm(list=ls(all.names = TRUE))
library(NLP)
library(tm)
library(jiebaRD)
library(jiebaR)
library(RColorBrewer)
library(wordcloud)
filenames <- list.files(getwd(), pattern="*.txt")
files <- lapply(filenames, readLines)
docs <- Corpus(VectorSource(files))

#stem the text
toSpace <- content_transformer(function(x, pattern) {
  return (gsub(pattern, " ", x))}
)
docs <- tm_map(docs, removeNumbers)
docs <- tm_map(docs, stripWhitespace)
docs <- tm_map(docs, removeWords, stopwords("english"))
# docs <- tm_map(docs, toSpace, "\t")
# docs <- tm_map(docs, toSpace, '\\')
# docs <- tm_map(docs, toSpace, "\n")

champion.name <- read.csv("champion_name/champion_name_3.csv")
str(champion.name)
#because the type of champion.name$Name is numeric, turn it into char
champion.name$Name <- as.character(champion.name$Name)

tmIndex(docs, champion.name$Name)
dtm <- TermDocumentMatrix(docs, control = list(tolower = FALSE))
m <- as.matrix(dtm)
v <- sort(rowSums(m),decreasing=TRUE)
d <- data.frame(word = names(v),freq=v)
selected <- d$word %in% champion.name$Name
nameFreq <- cbind.data.frame(Name = d$word[selected], Freq = d$freq[selected] )

par(family=("Heiti TC Light"))
#ref: https://ithelp.ithome.com.tw/articles/10192052
wordcloud(words = nameFreq$Name, freq = nameFreq$Freq,
          scale=c(1,0.1),min.freq=0,max.words=10000,
          random.order=TRUE, random.color=FALSE, 
          rot.per=.1, colors=brewer.pal(8, "Dark2"),
          ordered.colors=FALSE,use.r.layout=FALSE,
          fixed.asp=TRUE)
