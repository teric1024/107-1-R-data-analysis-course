rm(list = ls(all.names = T))
source('patch_test_function.R')
id = c(0:10)
URL = paste0("https://na.leagueoflegends.com/en/news/game-updates/patch?page=", id)
filename = paste0(id, ".txt")
mapply(LOLTestFunction, 
       URL = URL, filename = filename)
