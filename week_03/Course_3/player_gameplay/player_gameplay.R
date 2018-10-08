library(ggplot2)
mydata = read.csv("lcs-2017-summer-split-fantasy-player-team-stats/LCS Players Stats Summer Split 2017.csv")

#turn numeric into character
mydata$Name = as.character(mydata$Name)
mydata$Team = as.character(mydata$Team)

#find the data which is not blank and store into getData
getnnonameID = which(nchar(mydata$Name) != 0) 
getData = mydata[getnnonameID,]

#get the data of player in Cloud9
#https://stackoverflow.com/questions/5391124/select-rows-of-a-matrix-that-meet-a-condition
#how to extract rows that meet a condition
team.name <- "Cloud9"
Cloud9.Data <- getData[getData[, "Team"] == team.name,]

#if you want to geom_bar with x,y -> stat = "identity"
ggplot( data = getData, aes(x = Name, y = Game.Played) ) + geom_bar( stat = "identity" ) 
