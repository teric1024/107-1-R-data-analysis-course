#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(bitops)
library(httr)
library(RCurl)
library(XML)
library(tm)
library(NLP)
library(tmcn)
library(jiebaRD)
library(jiebaR)


#cleaning and add new words
d.corpus <- Corpus( DirSource("./DATA") )
toSpace <- content_transformer(function(x, pattern) {
  return (gsub(pattern, " ", x))
})

d.corpus <- tm_map(d.corpus, toSpace, "　")
d.corpus <- tm_map(d.corpus, toSpace, "︳")
d.corpus <- tm_map(d.corpus, toSpace, "・")
d.corpus <- tm_map(d.corpus, toSpace, "ー")
d.corpus <- tm_map(d.corpus, toSpace, "小說")
d.corpus <- tm_map(d.corpus, toSpace, "覺得")
d.corpus <- tm_map(d.corpus, toSpace, "可以")
d.corpus <- tm_map(d.corpus, toSpace, "沒有")
d.corpus <- tm_map(d.corpus, toSpace, "就是")
d.corpus <- tm_map(d.corpus, toSpace, "標題")
d.corpus <- tm_map(d.corpus, toSpace, "編輯")
d.corpus <- tm_map(d.corpus, toSpace, "發信站")
d.corpus <- tm_map(d.corpus, toSpace, "批踢踢實業坊")
d.corpus <- tm_map(d.corpus, toSpace, "自己")
d.corpus <- tm_map(d.corpus, toSpace, "應該")
d.corpus <- tm_map(d.corpus, toSpace, "知道")
d.corpus <- tm_map(d.corpus, toSpace, "真的")
d.corpus <- tm_map(d.corpus, toSpace, "不會")
d.corpus <- tm_map(d.corpus, toSpace, "動畫")
d.corpus <- tm_map(d.corpus, toSpace, "不是")
d.corpus <- tm_map(d.corpus, toSpace, "只是")
d.corpus <- tm_map(d.corpus, toSpace, "所以")
d.corpus <- tm_map(d.corpus, toSpace, "不會")

d.corpus <- tm_map(d.corpus, toSpace, "pttcc")
d.corpus <- tm_map(d.corpus, toSpace, "CChat")
d.corpus <- tm_map(d.corpus, toSpace, "enfis")
d.corpus <- tm_map(d.corpus, toSpace, "Wed")
d.corpus <- tm_map(d.corpus, toSpace, "Thu")
d.corpus <- tm_map(d.corpus, toSpace, "Fri")
d.corpus <- tm_map(d.corpus, toSpace, "Sat")
d.corpus <- tm_map(d.corpus, toSpace, "Sun")
d.corpus <- tm_map(d.corpus, toSpace, "Mon")
d.corpus <- tm_map(d.corpus, toSpace, "Tue")
d.corpus <- tm_map(d.corpus, toSpace, "Wed")
d.corpus <- tm_map(d.corpus, toSpace, "dukemon")#person's ID


d.corpus <- tm_map(d.corpus, removePunctuation)
d.corpus <- tm_map(d.corpus, removeNumbers)

mixseg = worker()
new_user_word(mixseg,'哥布林',"n")
new_user_word(mixseg,'哥殺',"n")
new_user_word(mixseg,'哥布林殺手',"n")
new_user_word(mixseg,'魔禁',"n")
new_user_word(mixseg,'魔法禁書目錄',"n")
new_user_word(mixseg,'提拉米斯',"n")
new_user_word(mixseg,'魔導少年',"n")
new_user_word(mixseg,'妖尾',"n")
new_user_word(mixseg,'妖精的尾巴',"n")
new_user_word(mixseg,'電光超人',"n")
new_user_word(mixseg,'繽紛世界',"n")
new_user_word(mixseg,'青春豬頭少年',"n")
new_user_word(mixseg,'終將成為妳',"n")
new_user_word(mixseg,'莉茲與青鳥',"n")
new_user_word(mixseg,'逆轉裁判',"n")
new_user_word(mixseg,'弦音',"n")
new_user_word(mixseg,'佐賀偶像',"n")
new_user_word(mixseg,'莉茲與青鳥',"n")


jieba_tokenizer = function(d)
{
  unlist( segment(d[[1]], mixseg) )
}
seg = lapply(d.corpus, jieba_tokenizer)

count_token = function(d)
{
  as.data.frame(table(d))
}
tokens = lapply(seg, count_token)

n = length(seg)
TDM = tokens[[1]]
colNames <- names(seg)
colNames <- gsub(".txt", "", colNames)
for( id in c(2:n) )
{
  TDM = merge(TDM, tokens[[id]], by="d", all = TRUE)
  names(TDM) = c('d', colNames[1:id])
}
TDM[is.na(TDM)] <- 0
#take out
TDM$d <- as.character(TDM$d)
TDM <- TDM[nchar(TDM$d)>1,]#去除字數是1的詞
library(knitr)
kable(head(TDM))
kable(tail(TDM))


#TDM -> TF-IDF
tf <- apply(as.matrix(TDM[,2:(n+1)]), 2, sum)

library(Matrix)
idfCal <- function(word_doc)
{ 
  log2( n / nnzero(word_doc) ) 
}
idf <- apply(as.matrix(TDM[,2:(n+1)]), 1, idfCal)

doc.tfidf <- TDM

tempY = matrix(rep(c(as.matrix(tf)), each = length(idf)), nrow = length(idf))
tempX = matrix(rep(c(as.matrix(idf)), each = length(tf)), ncol = length(tf), byrow = TRUE)
doc.tfidf[,2:(n+1)] <- (doc.tfidf[,2:(n+1)] / tempY) * tempX

stopLine = rowSums(doc.tfidf[,2:(n+1)])
delID = which(stopLine == 0)

kable(head(doc.tfidf[delID,1]))
kable(tail(doc.tfidf[delID,1]))
TDM = TDM[-delID,]
doc.tfidf = doc.tfidf[-delID,]


#get key words
TopWords = data.frame()
for( id in c(1:n) )
{
  dayMax = order(doc.tfidf[,id+1], decreasing = TRUE)
  showResult = t(as.data.frame(doc.tfidf[dayMax[1:5],1]))
  TopWords = rbind(TopWords, showResult)
}
rownames(TopWords) = colnames(doc.tfidf)[2:(n+1)]
TopWords <- TopWords[1:9,]
TopWords = droplevels(TopWords)
kable(TopWords)

#
AllTop = as.data.frame( table(as.matrix(TopWords)) )
AllTop = AllTop[order(AllTop$Freq, decreasing = TRUE),]

kable(head(AllTop))

TopNo = 5
tempGraph = data.frame()
for( t in c(1:TopNo) )
{
  word = matrix( rep(c(as.matrix(AllTop$Var1[t])), each = n), nrow = n )
  temp = cbind( colnames(doc.tfidf)[2:(n+1)], t(TDM[which(TDM$d == AllTop$Var1[t]), 2:(n+1)]), word )
  colnames(temp) = c("date", "freq", "words")
  tempGraph = rbind(tempGraph, temp)
  names(tempGraph) = c("date", "freq", "words")
}

library(ggplot2)
library(varhandle)
tempGraph$freq = unfactor(tempGraph$freq)
par(family=("Heiti TC Light"))
ggplot(tempGraph, aes(date, freq)) + 
  geom_point(aes(color = words, shape = words), size = 5) +
  geom_line(aes(group = words, linetype = words)) + 
  theme(axis.text.x = element_text(angle = 90, hjust = 1))
kable(tail(AllTop))

#發文量與時間
filenames = as.array(paste0("./DATA/",colnames(doc.tfidf)[2:(n+1)],".txt"))
sizeResult = apply(filenames, 1, file.size) / 1024
showSize = data.frame(colnames(doc.tfidf)[2:(n+1)], sizeResult)
names(showSize) = c("date", "size_KB")

ggplot(showSize, aes(x = date, y = size_KB)) + geom_bar(stat="identity")+ 
  theme(axis.text.x = element_text(angle = 90, hjust = 1))



# Define UI for application that draws a histogram
ui <- fluidPage(
   
   tabPanel(
     "文字雲",
     tags$h2("C_Chat 10/10~10/16"),br(),
     sidebarPanel(
       sliderInput("wc_max",
                   "字詞數量",
                   min = 1,
                   max = 100000,
                   value = 30)
     ),
     mainPanel(
       plotOutput("WordCloud_1")
     )
   ),
   tabPanel(
     "日期與詞出現頻率之長條圖"
   )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
   
  output$WordCloud_1 <- renderPlot({
    showtext.begin()
    print(wordcloud(docs.df_author$word, docs.df_author$freq, scale=c(5,0.8),max.words=input$wc_max,
                    random.order=FALSE, random.color=TRUE, 
                    rot.per=.1, colors=brewer.pal(8,"Dark2"),
                    ordered.colors=FALSE,use.r.layout=FALSE,
                    fixed.asp=TRUE))
    showtext.end()
  })
}

# Run the application 
shinyApp(ui = ui, server = server)

