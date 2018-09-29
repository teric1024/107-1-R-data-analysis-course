library(ggplot2)
mydata = read.csv("lcs-2017-summer-split-fantasy-player-team-stats/LCS Players Stats Summer Split 2017.csv")

#turn numeric into character
mydata$Name = as.character(mydata$Name)
mydata$Team = as.character(mydata$Team)

#find the data which is not blank and store into getData
getnnonameID = which(nchar(mydata$Name) != 0) 
getData = mydata[getnnonameID,]

#create a vector storing all team names
#https://stat.ethz.ch/R-manual/R-devel/library/base/html/append.html
#how to append value to vector (the website above)
all.team.name <- getData$Team[1]
i <- 2
repeat{
  if( is.na(getData$Team[i]) ) break
  if( !(getData$Team[i] %in% all.team.name) ) {
    all.team.name <- append(all.team.name, getData$Team[i], length(all.team.name))
  }
  i <- i + 1
}

#plot the data of player in team (one by one)

#if(!require(devtools)) install.packages("devtools")
#devtools::install_github("kassambara/ggpubr")
#use above two lines to install package
library(ggpubr)
graph <- vector()
for(i in 1:length(all.team.name)){
  team.name <- all.team.name[i]
  team.Data <- getData[getData[, "Team"] == team.name,]
  graph[i] <- ggplot( data = team.Data, aes(x = Name, y = Game.Played) ) + geom_bar( stat = "identity" ) + ggtitle(team.name)
}
