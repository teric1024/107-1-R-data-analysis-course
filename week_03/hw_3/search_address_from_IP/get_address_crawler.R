#ref : https://blog.gtwang.org/r/rselenium-r-selenium-browser-web-scraping-tutorial/
#      https://blog.csdn.net/Eastmount/article/details/48108259
#      https://blog.gtwang.org/r/rvest-web-scraping-with-r/
#      https://ropensci.org/tutorials/rselenium_tutorial/
#install.packages("RSelenium")
library(RSelenium)

#start up 
#input the string below this row into cmd
#java -Dwebdriver.chrome.driver=D:\chromedriver.exe -jar D:\selenium-server-standalone-3.14.0.jar

#connect to Selenium server, use chrome
remDr <- remoteDriver(
  remoteServerAddr = "localhost",
  port = 4444,
  browserName = "chrome")

#open the browser
remDr$open()

#open a website eg: google
remDr$navigate("http://dir.twseo.org/ip-check.php")

#get elements
web.elem.input <- remDr$findElement(using = "name", value = "inputip")

#input ip
web.elem.input$sendKeysToElement(list("111.248.209.209"))
web.elem.input$sendKeysToElement(list("\uE007"))

#get output data
web.elem.output <- remDr$findElement(using = 'id', value = "log_res")

#manipulate data
output <- web.elem.output$getElementText()
output <- as.character(output)

#mine longitude and latitude
pos.longitude <- regexpr("¸g«×", output)
pos.end <- nchar(output)
longitude <- substr(output, start = pos.longitude+3, stop = pos.end)
pos.lantitude <- regexpr("½n«×", output)
lantitude <- substr(output, start = pos.lantitude+3, stop = pos.longitude-3)


#save longitude and latitude as list
gold <- list(longitude = longitude, lantitude = lantitude)
write.csv(gold, file = "address.csv")

#close the window
remDr$close()
