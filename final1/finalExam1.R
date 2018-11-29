#### 注意事項 ####
# 1. 變數名稱請勿改動，若造成判斷錯誤一蓋不負責。
# 2. 請不要用 rm(list=ls()) 之類的東西，我們的 judge 會壞掉。
# 3. ggplot2 的 ggplot() 會回傳東西，第二大題的所有答案都請存到變數中
# ex: gg_exam <- ggplot(data=..., aes(...)) + ...
# 4. 提交答案之前請再次檢查變數存的東西是否符合題目要求。
# 5. 答案只有三種結果: correct, wrong, lost
# 分別是答對、答錯、未答，沒有對一半、部份給分。

####  1  ####
## 以下是小明各科的學期成績
subjects <- c("Calculus", "Python", "R", "Chinese", 
              "Algebra", "Physics", "Tennis", "English")
credits <- c(5, 2, 1, 3, 4, 4, 2, 3)
scores <- c("A", "B", "A", "C", "B", "D", "C", "C")
each_GPA <- c(4, 3, 4, 2, 3, 1, 2, 2) 

# 1.1 (5%) 
# 把 scores 轉換成類別變數 (factor) 存在 score_factor 
# 並賦予其順序屬性 D<C<B<A 
score_factor <- factor(score, order = T, levels = c("D","C","B","A"))

# 1.2 (5%)
# 把四筆資料做成一個 dataframe 存到變數 ming1 中
# column names 分別是 Subject, Credit, Score, GPA
ming1 <- data.frame(Subject = subjects, Credit = credits, Score = scores, GPA = each_GPA)

# 1.3 (5%)
# 計算小明這學期的加權 GPA 並存到變數 GPA 中
# hint: 加權GPA = (該科GPA * 該科學分數)的平均
GPA <- sum(credits * each_GPA) / sum(credits)

# 1.4 (5%)
# 把上一題改寫成函數 calc_GPA ，輸入是學分與分別的GPA
calc_GPA <- function(credit, gpa){
  return (sum(credit * gpa) / sum(credit))
}
calc_GPA(credits, each_GPA)
# 1.5 (10%)
# 小明看到成績單之後發明了時光機，想回到停修截止日前停修某科
# 好讓自己的成績好看點，但是他不知道停修哪科會讓 GPA 變高最多
# 請幫他寫一個函數 which_to_withdraw 
# 輸入是某個科目(ex: "which_to_withdraw("Calculus")")
# 輸出是停修該科後的加權 GPA
which_to_withdraw <- function(credit, gpa){
  
}

# 1.6 (5%)
# 在 ming 多新增一欄 "if_withdraw" 並存到變數 ming2
# 值為「若捨棄該科，GPA會變成多少」
# 注意：請不要變動 ming1 
ming2 <- 

# 1.7 (5%)
# 小明要出發回到過去了，他應該停修哪一科？存到變數 withdrawal 中
# 本題不能直接寫答案，應寫出運算過程 (即不能用肉眼判斷)
withdrawal <- 

# 1.8 (15%)
# 把上述流程寫一個函數 withdrawal_machine
# 輸入是 4 個向量: subjects、credits、scores、each_GPA
# 輸出是該停修哪一科
# hint: 上面的兩個函數都可以直接用，請不要在 function 裡面寫 function
withdrawal_machine <- 

####  2  ####

# 2.1 (10%)
# 利用 ggplot2 畫出內建資料集 iris 中 Species 為 setosa 的資料
# Sepal.Length 與 Sepal.Width 的 x-y 關係點圖
# 並把圖存到變數 gg1 中
gg1 <-

# 2.2 (10%)
# 利用 ggplot2 畫出 iris 中 Sepal.Length, Sepal.Width 
# 的 x-y 關係點圖，並依據不同的 Species 分出不同顏色
# 並把圖存到變數 gg2 中
gg2 <-

# 2.3 (10%)
# 利用 ggplo2 畫出內建資料集 diamonds 隨機抽樣 5% 資料
# 中 carat 與 price 的 x-y 關係點圖以及其回歸直線
# 並把圖存到變數 gg3 中
gg3 <-

# 2.4 (15%)
# (本題請設定解壓縮後的資料夾 final1 為 working directory
# 並以相對路徑讀檔)
# 讀取 "state_real_estate_data.csv" 檔，存到變數 my_csv 中
# 用 ggplot2 繪製其中 Land.Price.Index 與 Home.Price.Index 
# 的關係點圖，且以顏色區分不同 region ()
# 並把圖存到變數 gg4 中
my_csv <- 

gg4 <- 
