library(ggplot2)

#turn numeric into character
mydata$Name = as.character(mydata$Name)  

#find the data which is not blank and store into getData
getnnonameID = which(nchar(mydata$Name) != 0) 
getData = mydata[getnnonameID,]

#if you want to geom_bar with x,y -> stat = "identity"
ggplot( data = getData, aes(x = Name, y = Game.Played) ) + geom_bar( stat = "identity" ) 
