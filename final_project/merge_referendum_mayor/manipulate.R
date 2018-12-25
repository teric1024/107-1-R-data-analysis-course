rm(list=ls(all.names = TRUE))

#set working directory here
setwd(dirname(rstudioapi::getSourceEditorContext()$path))

filenames <- list.files('../data/公投結果(已分區)', pattern="*.csv")

manipulate <- function(name){
  folderpath <- "../data/公投結果(已分區)/"
  #refe <- read.csv('../data/公投結果(已分區)/7.csv')
  refe <- read.csv(paste0(folderpath, name))
  
  #turn the variable from factor to numeric
  agree <- as.character(refe$同意票數)
  agree <- gsub(',', replacement = '', agree)
  agree <- as.numeric(agree)
  disagree <- as.character(refe$不同意票數)
  disagree <- gsub(',', replacement = '', disagree)
  disagree <- as.numeric(disagree)
  total.vote <- agree + disagree
  rate <- agree/total.vote*100
  rate <- round(rate, digit = 2)
  refe$同意票數對票數比率 <- rate
  
  mayor <- read.csv('../crawler/all_votes_data.csv')
  kmt.no <- which(mayor$推薦之政黨 == '中國國民黨')
  mayor.vote.kmt <- mayor[kmt.no,]
  mayor.kmt.vote.no <- c()
  mayor.kmt.vote.rate <- c()
  for (i in c(1:nrow(mayor.vote.kmt))){
    town.name <- as.character(mayor.vote.kmt$鄉鎮市區[i])
    country.name <- as.character(mayor.vote.kmt$縣市[i])
    refe.row.no <- which(refe$地區 == town.name & refe$縣市 == country.name)
    mayor.kmt.vote.no[refe.row.no] <- mayor.vote.kmt$得票數[i]
    mayor.kmt.vote.rate[refe.row.no] <- as.character(mayor.vote.kmt$得票率[i])
  }
  mayor.kmt.vote.rate <-  gsub('%', replacement = '', mayor.kmt.vote.rate)
  refe$縣市首長得票率 <- mayor.kmt.vote.rate
  refe$縣市首長得票數 <- mayor.kmt.vote.no
  
  difference <- c()
  mayor.kmt.vote.rate <- as.numeric(mayor.kmt.vote.rate)
  for (i in c(1:length(rate))){
    if(is.na(mayor.kmt.vote.rate[i])){
      difference[i] <- NA
    }else{
      difference[i] <- rate[i] - mayor.kmt.vote.rate[i] 
    }
  }
  refe$公投同意率對縣市首長得票率差距 <- difference
  newfile.name <- paste0("國民黨第", gsub(".csv",replacement = "", name), "案.csv")
  write.csv(refe, file = newfile.name)
}

for (i in filenames){
  manipulate(i)
}
