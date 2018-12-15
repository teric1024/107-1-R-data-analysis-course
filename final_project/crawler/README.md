# 2018 縣市首長選舉資料

資料來源：[中央選舉委員會](http://vote.2018.nat.gov.tw/pc/zh_TW/IDX/index701.html)
爬蟲程式參考：[ Python 網路爬蟲 抓取並整理 2018 公投選舉資料](https://www.youtube.com/watch?v=pADAYCJ707E)

---
## 程式介紹
- **crawler_all.ipynb**：爬下所有縣市首長資料的爬蟲程式
- **crawler_gov_vote_Taipei.ipynb**：爬下台北市長資料的爬蟲程式
- **change_into_comma.R**：把用tab隔開的csv檔改成用逗點隔開
- **reorganize.R**：將爬下來的資料整理成一份的程式

---
## 資料介紹
- **all_votes_data.csv**：所有縣市首長選舉資料
- **new 南投縣 縣長選舉.csv**：南投縣縣長選舉資料
- **南投縣 縣長選舉.csv**：南投縣縣長選舉資料



### csv 命名方式
- 檔案名含有new：以逗號區隔資料。例：new 南投縣 縣長選舉.csv
- 檔案名不含有new：以tab區隔資料。例：南投縣 縣長選舉.csv
