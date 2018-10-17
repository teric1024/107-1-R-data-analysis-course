source('pttTestFunction.R')
id = c(17412:17550)
#from 10/10 to 10/17
URL = paste0("https://www.ptt.cc/bbs/C_Chat/index", id, ".html")
filename = paste0(id, ".txt")
pttTestFunction(URL[1], filename[1])
mapply(pttTestFunction, 
       URL = URL, filename = filename)
