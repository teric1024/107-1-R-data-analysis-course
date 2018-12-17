data=all_votes_data
l<-c()
#kill loser
#for(i in 1:1488){
#  if(is.na(data[[2]][i])){
#    l<-c(l,i)
#  }
#}

#data = data[-l,]
#percent to numeric
for(i in 1:1488){
  data[[7]][i]=sub("%", " ", data[[7]][i],fixed = TRUE)
  if(data[[10]][i]=="在東區")
    data[[10]][i]=paste("東區",data[[9]][i],sep=" ")
  else if(data[[10]][i]=="在南區")
    data[[10]][i]=paste("南區",data[[9]][i],sep=" ")
  else if(data[[10]][i]=="在西區")
    data[[10]][i]=paste("西區",data[[9]][i],sep=" ")
  else if(data[[10]][i]=="在北區")
    data[[10]][i]=paste("北區",data[[9]][i],sep=" ")
  else if(data[[10]][i]=="在中區")
    data[[10]][i]=paste("中區",data[[9]][i],sep=" ")
  else if(data[[10]][i]=="信義區")
    data[[10]][i]=paste("信義區",data[[9]][i],sep=" ")
  else if(data[[10]][i]=="中正區")
    data[[10]][i]=paste("中正區",data[[9]][i],sep=" ")
  else if(data[[10]][i]=="中山區")
    data[[10]][i]=paste("中山區",data[[9]][i],sep=" ")
  else if(data[[10]][i]=="大安區")
    data[[10]][i]=paste("大安區",data[[9]][i],sep=" ")
  
}
data[[7]]=as.numeric(as.character(data[[7]]))
maxs=data.frame("votes"=data[[7]],"country"=data[[9]],"town"=data[[10]],"party"=data[[8]])

df.agg <- aggregate(votes~town,data=maxs, max)
# then simply merge with the original
df.max <- merge(df.agg, maxs)
df.max[] <- lapply(df.max, function(x) if(is.factor(x)) as.character(x) else x)
write.csv(data,"fucktheloosers.csv")
#ref data processing
for(i in 1:15887){
  X9[[19]][i]=sub("%", " ", X9[[19]][i],fixed = TRUE)
  if(X9[[3]][i]=="西區"||X9[[3]][i]=="北區"||X9[[3]][i]=="南區"||X9[[3]][i]=="中區"||X9[[3]][i]=="東區"||X9[[3]][i]=="大安區"||X9[[3]][i]=="信義區"||X9[[3]][i]=="中正區"||X9[[3]][i]=="中山區"){
    X9[[3]][i]=paste(X9[[3]][i], X9[[2]][i], sep=" ")
  }
}
X9[[19]]=as.numeric(as.character(X9[[19]]))
l<-c()
#kmt win
for(i in 1:368){
  if(data[[8]][i]!="中國國民黨")
    l<-c(l,i)
}
kmtdata = data[-l,]
#x9 sum
newdata=aggregate(X9[[19]], by=list(Category=X9[[3]]), FUN=mean)
#new file

test <- data.frame("countryname" =NA,"townname" =NA, "ref"=1:368, "vot"=0,"rate"=0,"party"=NA)
for(i in 1:368){
  for(j in 1:368){
    if(newdata$Category[i]==df.max$town[j]){
      test$townname[i]=newdata$Category[i]
      test$ref[i]=newdata$x[i]
      test$countryname[i]=df.max[[3]][j]
      test$vot[i]=df.max[[2]][j]
      test$party[i]=df.max[[4]][j]
      break
    }
      
  }
}
l<-c()

for(i in 1:368){
  if(is.na(test$townname[i])){
    l<-c(l,i)
  }
}
test = test[-l,]
library(stringr)
for(i in 1:364){
  test$rate[i]=test$ref[i]/test$vot[i]
  if(str_length(test$townname[i])==6){
    test$townname[i]=substr( test$townname[i],1,2)
  }
  else if(str_length(test$townname[i])==7){
    test$townname[i]=substr( test$townname[i],1,3)
  }
}
write.csv(test,"result_9_2.csv")

print(test$rate)
