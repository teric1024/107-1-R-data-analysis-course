#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

### 0. reference
# 0-1中文亂碼解決
# https://github.com/dspim/R/wiki/R-&-RStudio-Troubleshooting-Guide
# 0-2tar: Failed to set default locale
# system('defaults write org.R-project.R force.LANG zh_TW.UTF-8')
# 0-3sysfonts not loading/Image not found
# https://www.xquartz.org/  use XQuartz

####
#  1.載入packages
####
library(knitr)
library(shiny)
library(ggfortify)
library(bitops)
library(httr)
library(RCurl)
library(XML)
library(tm)
library(NLP)
library(tmcn)
library(jiebaRD)
library(jiebaR)
library(ggplot2)
library(varhandle)
library(wordcloud)
library(showtext)

####
#  2.建立Corpus並清洗
####

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
d.corpus <- tm_map(d.corpus, toSpace, "[a-zA-Z]")#清除帳號id的影響
d.corpus <- tm_map(d.corpus, removePunctuation)
d.corpus <- tm_map(d.corpus, removeNumbers)

####
#  3.建立詞庫(2018秋季動畫詞庫)
####
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
new_user_word(mixseg,'青春豬頭',"n")
new_user_word(mixseg,'終將成為妳',"n")
new_user_word(mixseg,'莉茲與青鳥',"n")
new_user_word(mixseg,'逆轉裁判',"n")
new_user_word(mixseg,'弦音',"n")
new_user_word(mixseg,'佐賀偶像',"n")
new_user_word(mixseg,'刀劍神域',"n")

####
#  4.進行斷詞，並依照日期建立文本矩陣 TermDocumentMatrix
####
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

####
#  5.TDM  -> TF-IDF
####

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
stopLine["6050"] <- 1 #哥布林
stopLine["6051"] <- 1 #哥布林殺手
delID = which(stopLine == 0)


kable(head(doc.tfidf[delID,1]))
kable(tail(doc.tfidf[delID,1]))
TDM = TDM[-delID,]
doc.tfidf = doc.tfidf[-delID,]

####
#  6.取得關鍵字
####

#TF-IDF
TopWords.tfidf = data.frame()
for( id in c(1:n) )
{
  dayMax = order(doc.tfidf[,id+1], decreasing = TRUE)
  showResult = t(as.data.frame(doc.tfidf[dayMax[1:5],1]))
  TopWords.tfidf = rbind(TopWords.tfidf, showResult)
}
rownames(TopWords.tfidf) = colnames(doc.tfidf)[2:(n+1)]
TopWords.tfidf <- TopWords.tfidf[1:7,]
TopWords.tfidf = droplevels(TopWords.tfidf)

#TDM
TopWords.TDM = data.frame()
for( id in c(1:n) )
{
  dayMax = order(TDM[,id+1], decreasing = TRUE)
  showResult = t(as.data.frame(TDM[dayMax[1:5],1]))
  TopWords.TDM = rbind(TopWords.TDM, showResult)
}
rownames(TopWords.TDM) = colnames(TDM)[2:(n+1)]
TopWords.TDM <- TopWords.TDM[1:7,]
TopWords.TDM = droplevels(TopWords.TDM)


####
#  7.用取得的關鍵字(TF-IDF)將TDM視覺化
####
AllTop = as.data.frame( table(as.matrix(TopWords.tfidf)) )
AllTop = AllTop[order(AllTop$Freq, decreasing = TRUE),]

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


tempGraph$freq = unfactor(tempGraph$freq)


####
#  8.發文時間與發文量的關係作圖
####

#發文量與時間
filenames = as.array(paste0("./DATA/",colnames(doc.tfidf)[2:(n+1)],".txt"))
sizeResult = apply(filenames, 1, file.size) / 1024
showSize = data.frame(colnames(doc.tfidf)[2:(n+1)], sizeResult)
names(showSize) = c("date", "size_KB")

####
#  9.wordcloud
####

#TDM
wc.matrix.tdm <- data.frame(
  word = TDM$d,
  freq = rowSums(TDM[,2:8])
)
par(family=("Heiti TC Light"))
row.names(wc.matrix.tdm)=NULL
wordcloud(wc.matrix.tdm$word, wc.matrix.tdm$freq, scale=c(5,0.1),max.words=50,
          random.order=FALSE, random.color=TRUE, 
          rot.per=.1, colors=brewer.pal(8,"Dark2"),
          ordered.colors=FALSE,use.r.layout=FALSE,
          fixed.asp=TRUE)

####
#  10.manipulate data
####
word.doc.tfidf <- subset(doc.tfidf,select = -d)
row.names(word.doc.tfidf) <- doc.tfidf$d

# Define UI for application that draws a histogram
ui <- navbarPage(
   theme = shinythemes::shinytheme("flatly"),
   
   "C_Chat版10/10~10/16發文關係",
   
   
   tabPanel("簡介",
            tags$h4("作者：凃皓瑋"),
            br(),
            br(),
            tags$h4("想觀察在此段時間內的動畫討論度"),
            br()),
   
   tabPanel(
     "詞語出現頻率",
     tags$h2("C_Chat 10/10~10/16"),
     br(),
     sidebarPanel(
       selectInput("date_1", "date(10/?):",
                   choices = c(10:16)),
       hr(),
       helpText("看看C_Chat每一天的前幾名關鍵字出現量(選擇\"日\")")
     ),
     mainPanel(plotOutput("word.freq.bar_1"))
   ),
     tabPanel(
       "文字雲(TDM)",
       tags$h2("C_Chat 10/10~10/16"),
       br(),
       sidebarPanel(sliderInput(
         "wc_max_1",
         "字詞數量",
         min = 1,
         max = 1000,
         value = 30
       )),
       mainPanel(plotOutput("WordCloud_1"))
     ),
     tabPanel(
       "文字雲(TF-IDF)",
       tags$h2("C_Chat 10/10~10/16"),
       br(),
       sidebarPanel(sliderInput(
         "wc_max_2",
         "字詞數量",
         min = 1,
         max = 1000,
         value = 30
       )),
       mainPanel(plotOutput("WordCloud_2"))
     ),
   
   tabPanel("折線圖",
            tags$h2("日期與詞出現頻率之折線圖"), br(),
            mainPanel(plotOutput("line.chart_1"))),
   
   tabPanel(
     "長條圖",
     tags$h2("日期與發文量之長條圖"),
     br(),
     br(),
     tags$h4("發文量以檔案大小(KB)表示"),
     br(),
     mainPanel(plotOutput("bar.graph_1"))
   ),
   
   tabPanel("PCA_1",
            mainPanel(plotOutput("pca.graph_1"))),
   tabPanel("PCA_2",
            mainPanel(plotOutput("pca_graph_2"))),
   tabPanel("日子之間的關聯性",
            sidebarPanel(numericInput(
              "k1",
              "Number of k:",
              min = 2,
              max = 7,
              value = 5
            )),
            mainPanel(plotOutput("pcak.graph_1")))
)
library(showtext)
# Define server logic required to draw a histogram
server <- function(input, output) {
   
  output$WordCloud_1 <- renderPlot({
    showtext.begin()
    wc.matrix.tdm <- data.frame(
      word = TDM$d,
      freq = rowSums(TDM[,2:8])
    )
    par(family=("Heiti TC Light"))
    row.names(wc.matrix.tdm)=NULL
    wordcloud(wc.matrix.tdm$word, wc.matrix.tdm$freq, scale=c(5,0.1),max.words=50,
              random.order=FALSE, random.color=TRUE, 
              rot.per=.1, colors=brewer.pal(8,"Dark2"),
              ordered.colors=FALSE,use.r.layout=FALSE,
              fixed.asp=TRUE)
    showtext.end()
  })
  output$WordCloud_2 <- renderPlot({
    showtext.begin()
    wc.matrix.tfidf <- data.frame(
      word = doc.tfidf$d,
      freq = rowSums(doc.tfidf[,2:8])
    )
    par(family=("Heiti TC Light"))
    row.names(wc.matrix.tfidf)=NULL
    print(wordcloud(wc.matrix.tfidf$word, wc.matrix.tfidf$freq, scale=c(3,0.1),max.words=50,
              random.order=FALSE, random.color=TRUE, 
              rot.per=.1, colors=brewer.pal(8,"Dark2"),
              ordered.colors=FALSE,use.r.layout=FALSE,
              fixed.asp=TRUE)
    )
    showtext.end()
  })
  output$line.chart_1 <- renderPlot({
    showtext.begin()
    print(ggplot(tempGraph, aes(date, freq)) + 
            geom_point(aes(color = words, shape = words), size = 5) +
            geom_line(aes(group = words, linetype = words)) + 
            theme(text = element_text(family = "黑體-繁 中黑"))
          )
    showtext.end()
  })
  output$bar.graph_1 <- renderPlot({
    showtext.begin()
    print(
      ggplot(showSize, aes(x = date, y = size_KB)) + geom_bar(stat="identity") 
    )
    showtext.end()
  })
  output$word.freq.bar_1 <- renderPlot({
    showtext.begin()
    i <- as.numeric(input$date_1)-8
    top10ID = head(order(TDM[, i], decreasing = TRUE), 10)
    nn2 = data.frame(count = TDM[top10ID,i], names = TDM[top10ID,"d"])
    print(
      ggplot(nn2, aes(reorder(names,count), count)) +
        geom_bar(stat = "identity") + coord_flip() +
        xlab("Terms") + ylab("count") +
        ggtitle(paste("10/", i + 8))+
        theme(text = element_text(family = "黑體-繁 中黑"))
    )
    showtext.end()
  })
  output$pca.graph_1 <- renderPlot({
    pcs.date <- prcomp(t(word.doc.tfidf), center = F, scale = F)
    autoplot(pcs.date$x,data = newdoc, shape = FALSE, label.size = 3)
    princomp.date <- data.frame(pcs.date$x[,1:7])
    plot(princomp.date, pch = 19, cex = 0.8)
  })
  output$pca.graph_2 <- renderPlot({
    pcs.date <- prcomp(t(word.doc.tfidf), center = F, scale = F)
    princomp.date <- data.frame(pcs.date$x[,1:7])
    plot(princomp.date, pch = 19, cex = 0.8)
  })
  output$pcak.graph_1 <- renderPlot({
    k.date <- input$k1
    km.date <- kmeans(princomp.date,centers = k.date,nstart=25, iter.max=1000)
    plot(princomp.date, col=km.date$cluster, pch=16)
    autoplot(km.date, data = pcs.date, label = TRUE, label.size = 3)
  })
  # output$pcak.graph_2 <- renderPlot({
  #   k.word <- input$k2
  #   
  # })
}

# Run the application 
shinyApp(ui = ui, server = server)

