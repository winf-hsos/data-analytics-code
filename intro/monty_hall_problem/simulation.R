# Variables to keep track of the wins and games played
wins <- 0
games_played <- 0

# Define the doors 1, 2, and 3
doors <- seq(1, 3)

# How many games to simulate?
n <- 1000

# Does the contestant switch?
contestant_switches <- TRUE

# Repeat 100 times 
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

    # Contestant wins if switches and was previously wrong
    if (contestant_switches) {
        user_wins <- !contestant_correct
    # Contestant wins if does not switch and was previously right
    } else {
        user_wins <- contestant_correct
    }

    # Update the wins and games played
    wins <- wins + user_wins
    games_played <- games_played + 1
}
