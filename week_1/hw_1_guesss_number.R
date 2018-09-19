rm(list = ls())
# 猜數字遊戲
# 基本功能
# 1. 請寫一個由"電腦隨機產生"不同數字的四位數(1A2B遊戲)
# 2. 玩家可"重覆"猜電腦所產生的數字，並提示猜測的結果(EX:1A2B)
# 3. 一旦猜對，系統可自動計算玩家猜測的次數
# 額外功能：每次玩家輸入完四個數字後，檢查玩家的輸入是否正確(錯誤檢查)

#initiate
answer <- as.character(sample(0:9, size = 4))
count <- 0            #the frequency user guess


#body
repeat{
  A <- 0
  B <- 0
  flag <- FALSE         #determine if guess is input correctly
  
  #------------take out invalid answers------
  while(!flag){
    guess <- readline("Please input a four digit number.(not repeat)>>")
    guess <- substring(guess, 1:4, 1:4) #split into four character(a vector)
    
    #-------check digits-------
    digit <- as.character(seq(from = 0, to = 9, by = 1)) #generate a vector from 0 to 9
    IsDigit <- guess %in% digit     #determine if input value is digit
    IsDigitFlag <- TRUE
    for(i in 1:4){
      IsDigitFlag <- IsDigitFlag & IsDigit[i]  #check one by one
    }
    if(IsDigitFlag)
    {
      flag <- TRUE
    }else{
      flag <- FALSE
      cat("Please only input digits.\n")
    }
    #--------------------------
    
    #-------check repeated-----
    if(flag == TRUE){
      repeated <- FALSE
      for(i in 1:4)
      {
        if(repeated == TRUE){
          break
        }
        for(j in 1:4)
        {
          if(i == j) break
          if(guess[i] == guess[j])
          {
            repeated <- TRUE
            break
          }
        }
      }
      if(repeated == TRUE){
        cat("Repeated digits.\n")
        flag <- FALSE
        next
      }else{ 
        flag <- TRUE
      }
    }
    #--------------------------
    
  }
  #------------------------------------------
  
  count <- count + 1
  
  #-----compare answer with guess----
  for(i in 1:4){
    for(j in 1:4){
      if(answer[i] == guess[i]){
        A <- A + 1
        guess[i] <- "_"
        break
      }else if(answer[i] == guess[j]){
        B <- B + 1
        guess[j] <- "_"
        break
      }
    }
  }
  #-----------------------------------
  
  cat(A,"A",B,"B\n")
  if (A == 4) break
}

cat("You are right! You have guessed", count, "times.")
