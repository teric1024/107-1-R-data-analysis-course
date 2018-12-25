library(readr)
result_7 <- read_csv("result_7_3.csv")
result_8 <- read_csv("result_8_3.csv")
result_9 <- read_csv("result_9_3.csv")
result_10 <- read_csv("result_10_3.csv")
result_11 <- read_csv("result_11_3.csv")
result_12 <- read_csv("result_12_3.csv")
result_13 <- read_csv("result_13_3.csv")
result_14 <- read_csv("result_14_3.csv")
result_15 <- read_csv("result_15_3.csv")
result_16 <- read_csv("result_16_3.csv")

test <- data.frame("countryname" =result_7$countryname,"townname" =result_7$townname, "ref7"=1:368,"ref8"=1:368,"ref9"=1:368,"ref10"=1:368,"ref11"=1:368,"ref12"=1:368,"ref13"=1:368,"ref14"=1:368,"ref15"=1:368,"ref16"=1:368, "vot"=result_7$vot,"rate"=0,"party"=result_7$party)
for(i in 3:12){
  n=get(paste0("result_",(i+4)))
      test[[i]]=n$ref
}
newone <- data.frame( "ref7"=1:368,"ref8"=1:368,"ref9"=1:368,"ref10"=1:368,"ref11"=1:368,"ref12"=1:368,"ref13"=1:368,"ref14"=1:368,"ref15"=1:368,"ref16"=1:368)
for(i in 1:10)
newone[[i]]=test[[i+2]]
j1 <- max.col(newone, "first")
value <- newone[cbind(1:nrow(newone), j1)]
cluster <- names(newone)[j1]
res <- data.frame(value, cluster)
test[[16]]=res[[1]]
test[[17]]=res[[2]]
#library(stringr)
#for(i in 1:368)
test$rate=(100*test[[16]])/test$vot[i]
 
test$rate=abs(1-test$rate)
write.csv(test,"resultsss.csv")

#print(test$rate)
