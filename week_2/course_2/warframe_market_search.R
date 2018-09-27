library(httr)

url <- "https://api.warframe.market/v1/items/saryn_prime_blueprint"
res = GET(url)
res_json = content(res)
do.call(rbind,res_json$payload$item$items_in_set)
View(data.frame(do.call(rbind,res_json$payload$item$items_in_set)))
