library(readr)
all_votes_data <- read_csv("data/all_votes_data.csv")
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
  data[[6]][i]=sub("%", " ", data[[6]][i],fixed = TRUE)
  if(data[[9]][i]=="東區")
    data[[9]][i]=paste("東區",data[[8]][i],sep=" ")
  else if(data[[9]][i]=="南區")
    data[[9]][i]=paste("南區",data[[8]][i],sep=" ")
  else if(data[[9]][i]=="西區")
    data[[9]][i]=paste("西區",data[[8]][i],sep=" ")
  else if(data[[9]][i]=="北區")
    data[[9]][i]=paste("北區",data[[8]][i],sep=" ")
  else if(data[[9]][i]=="中區")
    data[[9]][i]=paste("中區",data[[8]][i],sep=" ")
  else if(data[[9]][i]=="信義區")
    data[[9]][i]=paste("信義區",data[[8]][i],sep=" ")
  else if(data[[9]][i]=="中正區")
    data[[9]][i]=paste("中正區",data[[8]][i],sep=" ")
  else if(data[[9]][i]=="中山區")
    data[[9]][i]=paste("中山區",data[[8]][i],sep=" ")
  else if(data[[9]][i]=="大安區")
    data[[9]][i]=paste("大安區",data[[8]][i],sep=" ")
  
}
maxs=data.frame("votes"=as.numeric(data[[6]]),"country"=as.character(data[[8]]),"town"=as.character(data[[9]]),"party"=as.character(data[[7]]))
#maxs[] <- lapply(maxs, function(x) if(is.factor(x)) as.numeric(x) else x)
df.agg <- aggregate(votes~town,data=maxs, max)
# then simply merge with the original
df.max <- merge(df.agg, maxs)
df.max[] <- lapply(df.max, function(x) if(is.factor(x)) as.character(x) else x)
#ref data processing
niggar=0
X7 <- read_csv("data/use_these/7.csv")
X8 <- read_csv("data/use_these/8.csv")
X9 <- read_csv("data/use_these/9.csv")
X10 <- read_csv("data/use_these/10.csv")
X11 <- read_csv("data/use_these/11.csv")
X12 <- read_csv("data/use_these/12.csv")
X13 <- read_csv("data/use_these/13.csv")
X14 <- read_csv("data/use_these/14.csv")
X15 <- read_csv("data/use_these/15.csv")
X16 <- read_csv("data/use_these/16.csv")
for(wxyz in 7:16){
  ddt=get(paste0("X",wxyz))
  #addc=function(ddt){
  for(i in 1:15887){
    #ddt[[19]][i]=sub("%", " ", ddt[[19]][i],fixed = TRUE)
    if(ddt[[3]][i]=="西區"||ddt[[3]][i]=="北區"||ddt[[3]][i]=="南區"||ddt[[3]][i]=="中區"||ddt[[3]][i]=="東區"||ddt[[3]][i]=="大安區"||ddt[[3]][i]=="信義區"||ddt[[3]][i]=="中正區"||ddt[[3]][i]=="中山區"){
      ddt[[3]][i]=paste(ddt[[3]][i], ddt[[2]][i], sep=" ")
      
    }
  }
  #X9[[19]]=as.numeric(as.character(X9[[19]]))
  ddt[[22]]=ddt[[9]]/ddt[[11]]
  #x9 sum
  newdata=aggregate(ddt[[22]], by=list(Category=ddt[[3]]), FUN=mean)
  #}
  #addc(X10)
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
  
  library(stringr)
  test$vot=as.numeric(as.character(test$vot))
  for(i in 1:368){
    test$rate[i]=100*(test$ref[i])/test$vot[i]
    if(str_length(test$townname[i])==6){
      test$townname[i]=substr( test$townname[i],1,2)
    }
    else if(str_length(test$townname[i])==7){
      test$townname[i]=substr( test$townname[i],1,3)
    }
  }
  test$rate=abs(1-test$rate)
  write.csv(test,paste0("result_",wxyz,"_3.csv"),fileEncoding = "UTF-8")
}


#print(test$rate)
