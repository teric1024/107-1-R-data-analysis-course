library(httr)

# web.pchome.1 <- ' https://ecshweb.pchome.com.tw/search/v3.3/all/results?q='
# search <- 'macbook'
# web.pchome.2 <- '&page=1&sort=rnk/dc'
# web <- paste(web.pchome.1, search, web.pchome.2, sep = "")
web <- 'https://ecshweb.pchome.com.tw/search/v3.3/all/results?q=macbook&page=1&sort=rnk/dc'
result <- GET(web)
result.json <- content(result)
raw.data <- data.frame(do.call(rbind, result.json$prods))
View(raw.data)

