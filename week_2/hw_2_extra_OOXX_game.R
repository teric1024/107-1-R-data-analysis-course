#---a function could print the position/value-----
print.point <- function(pos, value){
  if(value == 0){
    cat(" ")
  }else if(value == 1){
    cat("O")
  }else if(value == 2){
    cat("X")
  }
}
#-----------

#-----print the whole game display-----
print.game <- function(matrix_data){
  pos <- 1 #position
  for(x in 1:3){
    for(y in 1:3){
      cat(print.point(pos, matrix_data[x,y]))
      pos <- pos + 1
      if(y != 3){
        cat("|")
      }else{
        cat("\n")
      }
    }
    if(x != 3){
      cat("-+-+-\n")
    }
  }
}
#----------

#-----check if anyone wins-----
game.win <- function(matrix_data){
  #check column
  flag <- FALSE
  for(i in 1:3){
    if(matrix_data[i,1] == 0)
      next
    if(matrix_data[i,1] == matrix_data[i,2] && matrix_data[i,2] == matrix_data[i,3])
    {
      flag <- TRUE
      break
    }
  }
  #check row
  if(!flag)
  {
    for(i in 1:3){
      if(matrix_data[1,i] == 0)
        next
      if(matrix_data[1,i] == matrix_data[2,i] && matrix_data[2,i] == matrix_data[3,i])
      {
        flag <- TRUE
        break
      }
    }
  }
  #check X
  if(!flag){
    if(matrix_data[1,1] == matrix_data[2,2] && matrix_data[2,2] == matrix_data[3,3]){
      if(matrix_data[2,2] != 0)
        flag <- TRUE
    }
    if(matrix_data[1,3] == matrix_data[2,2] && matrix_data[2,2] == matrix_data[3,1]){
      if(matrix_data[2,2] != 0)
        flag <- TRUE
    }
  }
  return (flag)
}
#--------------------

#check if input is "exit"
isExit <- function(input){
  input <- substring(input, 1:4, 1:4)
  str_exit <- "exit"
  str_exit <- substring(str_exit, 1:4, 1:4)
  flag <- TRUE
  for(i in 1:4){
    flag <- flag & (input[i] == str_exit[i])
  }
  return (flag)
}

#body of this program
game <- matrix(0, nrow = 3, ncol = 3)
round <- 0
repeat
{
  isInputv <- TRUE #the flag to check if input is valid
  isOccupied <- TRUE #the flag to check if the position is occupied
  
  #-----cope with invalid answers----
  repeat{
    if(!isInputv)
    {
      cat("Invalid input! Please re-enter!\n")
    }
    if(!isOccupied)
    {
      cat("This position is already occupied!\n")
    }
    #---A's turn or B's turn----
    cat("Round", round,"\n")
    if(round %% 2 == 0){
      cat("Now is player A's tern!\n")
      cat("Player A input(1~9) :")
    }else{
      cat("Now is player B's tern!\n")
      cat("Player B input(1~9) :")
    }
    #--------
    input <- readline()
    if(isExit(input)) break
    digit <- as.character(seq(from = 0, to = 9, by = 1))
    isInputv <- input %in% digit
    
    #---check if the position is occupied----
    game_position <- 1
    for(x in 1:3){
      for(y in 1:3){
        if(game_position == input[1]){
          if(game[x,y] != 0)
            isOccupied <- FALSE
          else
            isOccupied <- TRUE
        }
        game_position <- game_position + 1
      }
    }
    #-----
    if(isInputv && isOccupied) break
  }
  #------
  
  #------draw O/X-----
  game_position <- 1
  for(x in 1:3){
    for(y in 1:3){
      if(game_position == input[1]){
        if(round %% 2 == 0)
          game[x,y] <- 1
        else
          game[x,y] <- 2
      }
      game_position <- game_position + 1
    }
  }
  #-------
  if(isExit(input)){
    cat("Bye-Bye")
    break
  }
  if(game.win(game)){
    print.game(game)
    cat("Player")
    if(round %% 2 == 0)
      cat("A")
    else
      cat("B")
    cat("wins!!!")
    break
  }
  round <- round + 1
  if(round == 9){
    print.game(game)
    cat("End in a draw!!")
    break
  }
}
