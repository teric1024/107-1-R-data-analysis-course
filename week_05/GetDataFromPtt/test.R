html <- htmlParse( getURL('https://www.ptt.cc/bbs/C_Chat/M.1539346213.A.3D3.html') )
doc  <- xpathSApply( html, "//div[@id='main-content']", xmlValue )
time <- xpathSApply( html, "//*[@id='main-content']/div[3]/span[2]", xmlValue )
temp <- gsub( "  ", " 0", unlist(time) )
part <- strsplit( temp, split=" ", fixed=T )
#part form like -> "Tue"      "Oct"      "09"       "23:43:27" "2018"
date <- part[[1]][3]
day <- part[[1]][1]
#print(date and dat)
name <- paste0('./DATA/', date, "_", day, ".txt")
write(doc, name, append = TRUE)
