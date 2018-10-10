rm(list=ls(all.names = TRUE))

champion.name <- read.table("champion_name.txt")

#ref:https://stackoverflow.com/questions/652136/how-can-i-remove-an-element-from-a-list
#how to remove a column by the way "close up" the hole

#fixed Aurelion Sol
champion.name$V9 <- "Aurelion Sol"
champion.name$V10 <- NULL

#fixed Dr. Mundo
champion.name$V23 <- "Dr. Mundo"
champion.name$V24 <- NULL

#fixed Jarvan IV
champion.name$V45 <- "Jarvan IV"
champion.name$V46 <- NULL

#fixed Lee Sin
champion.name$V65 <- "Lee Sin"
champion.name$V66 <- NULL

#fixed Master Yi
champion.name$V75 <- "Master Yi"
champion.name$V76 <- NULL

#fixed Miss Fortune
champion.name$V77 <- "Miss Fortune"
champion.name$V78 <- NULL

#fixed Nunu
#here only use Nunu
champion.name$V87 <- NULL
champion.name$V88 <- NULL

#fixed Tahm Kench
champion.name$V116 <- "Tahm Kench"
champion.name$V117 <- NULL

#fixed Twisted Fate
champion.name$V126 <- "Twisted Fate"
champion.name$V127 <- NULL

#fixed Xin Zhao
champion.name$V143 <- "Xin Zhao"
champion.name$V144 <- NULL

#fixed completed

write.csv(champion.name, file = "champion_name_1.csv")

#delete the first line by hands

a.champion.name <- read.csv("champion_name_3.csv", na ="")
b <- a.champion.name$Name
