library(tmcn)
library(rvest)
LOLTestFunction <- function(URL, filename)
{
  html  = read_html(URL)
  
  #ref: https://rpubs.com/SatoshiLiang/159348
  #'.' stands for class, '#' stands for id
  title = html_nodes(html, ".default-2-3 a")
  href  = html_attr(title, "href")
  data = data.frame(title = html_text(title),
                    href = href)
  getContent <- function(x) {
    url  = paste0("https://na.leagueoflegends.com", x)
    tag  = html_node(read_html(url), 'div#patch-notes-container')
    text = html_text(tag)
  }
  #getContent(data$href[1])
  allText = sapply(data$href, getContent)
  allText
  #out <- file(filename, "w", encoding="BIG-5") 
  write.table(allText, filename) 
  #close(out) 
}