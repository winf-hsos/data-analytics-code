# Run this script to play the Monty Hall game with 3 doors 
round <- 1

repeat {
  
  # Inform the contestant which round they are playing
  cat(paste0("\nRound ", round, " \n"))
  
  # Determine randomly where the prize is located
  prize_door <- sample(1:3, size=1)
  
  # Ask contestant for door
  door_chosen <- readline("Which door do you choose? ")
  
  # Convert choice to integer
  door_chosen <- as.integer(door_chosen)
  
  # Determine which door to open
  door_opened <- sample(setdiff(1:3, c(prize_door, door_chosen)), size=1)
  
  # Inform the contestant which door was opened
  cat(paste0("Monty opened door ", door_opened, ". There is no prize behind this door.\n"))
  
  # Determine the door that stays closed, sample if two doors are left
  door_remaining_closed <- sample(setdiff(1:3, c(door_chosen, door_opened)), size=1)
  
  # Ask contestant if they want to switch
  switch <- readline(paste0("Do you want to switch to door ", door_remaining_closed, " (y/n)? "))
  
  # If the contestant wants to switch, then the door chosen is the remaining closed door
  if (switch == "y") {
    door_chosen <- door_remaining_closed
  }
  
  # Inform the contestant where the prize was located
  cat(paste0("The prize was behind door ", prize_door, ".\n"))
  
  # Did the contestant win?
  if (door_chosen == prize_door) {
    cat("Congratulations! You won the prize!\n\n")
  } else {
    cat("Sorry, you did not win the prize.\n\n")
  }
  
  # Ask the contestant if they want to play again
  play_again <- readline("Do you want to play again (y/n)? ")
  
  # End the game if the contestant does not want to play again
  if (play_again == "n") {
    break
  }
  
  round <- round + 1
}