library(httr)

url <- "https://www.pixiv.net/search.php?s_mode=s_tag&word=warframe"
res = GET(url)
res_json = content(res)
do.call(rbind,res_json$prods)
View(data.frame(do.call(rbind,res_json$prods)))