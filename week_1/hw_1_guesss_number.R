rm(list = ls())
# 猜數字遊戲
# 基本功能
# 1. 請寫一個由"電腦隨機產生"不同數字的四位數(1A2B遊戲)

nswer <- sample(0:9, size = 4)
flag <- FALSE         #if guess is same as answer
count <- 0            #the time user guess

# 2. 玩家可"重覆"猜電腦所產生的數字，並提示猜測的結果(EX:1A2B)

while(flag == FALSE){
  guess <- readline("Please input a four digit number.(not repeat)>>")
  count <- count + 1
  guess <- substring(guess, 1:4, 1:4)
  
  #-----compare answer with guess----
  if(answer == guess)
  {
    flag <- TRUE
  }else
  {
    cat("Wrong answer.\n")
  }
  #-----------------------------------
}
# 3. 一旦猜對，系統可自動計算玩家猜測的次數
cat("You are right! You have guessed", count, "times.")
# 額外功能：每次玩家輸入完四個數字後，檢查玩家的輸入是否正確(錯誤檢查)

