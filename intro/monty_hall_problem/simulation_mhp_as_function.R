# Define a function to simulate the Monty Hall problem
simulate_monty_hall <- function(n, decision) {
  # Variables to keep track of the wins and games played
  wins <- 0
  games_played <- 0
  
  # Define the doors 1, 2, and 3
  doors <- seq(1, 3)
  
  # Loop to simulate the game n times
  for (i in 1:n) {
    # Draw a random number from 1 to 3 to set the car's location
    car_position <- sample(1:3, 1)
    
    # Define the contestant's choice
    contestant_choice <- sample(1:3, 1)
    
    # Is the user choice the same as the car's location?
    contestant_correct <- contestant_choice == car_position
    
    # Monty can open one of the following doors:
    montys_options <- setdiff(doors, c(car_position, contestant_choice))
    
    # Monty opens one of the doors that the contestant did not choose
    # and that does not contain the car
    montys_choice <- sample(montys_options, 1)
    
    # Contestant wins based on the decision to "switch" or "stay"
    if (decision == "switch") {
      user_wins <- !contestant_correct  # Wins if contestant switches and was initially wrong
    } else if (decision == "stay") {
      user_wins <- contestant_correct  # Wins if contestant stays and was initially right
    } else {
      stop("Invalid decision! Use 'stay' or 'switch'.")  # Error handling for invalid input
    }
    
    # Update the wins and games played
    wins <- wins + user_wins
    games_played <- games_played + 1
  }
  
  # Output the winning percentage
  win_percentage <- wins / n
  return(win_percentage)
}

n_games <- 10000
decision <- "switch"  # "switch" or "stay"
result <- simulate_monty_hall(n_games, decision)

print(result)
