# Manually enter the door number of the prize door
prize_door <- scan()

# Load from file
prize_door <- scan("data/monty_hall_problem/prize_door.txt")
contestant_choice <- scan("data/monty_hall_problem/contestant_choice.txt")
decision <- scan("data/monty_hall_problem/decision.txt", what = "character")

num_door_1 <- length(prize_door[prize_door == 1])
num_door_2 <- length(prize_door[prize_door == 2])
num_door_3 <- length(prize_door[prize_door == 3])

# Did the contestant guess correct from the beginning?
right_guess <- prize_door == contestant_choice
mean(right_guess)

# How often did the contestant win overall
won <- (decision == "switch" & contestant_choice != prize_door) | (decision == "stay" & contestant_choice == prize_door)
mean(won)


# Determine wins for switch and stay
won_option_a = decision == "switch" & contestant_choice != prize_door
won_option_b = decision == "stay" & contestant_choice == prize_door

# Merge both options
won <- won_option_a | won_option_b
mean(won)

# How many times did the contestant win when they switched doors?
switched <- decision == "switch"
won_when_switched <- contestant_choice[switched] != prize_door[switched]
sum(won_when_switched) / length(won_when_switched)
mean(won_when_switched)

# How many times did the contestant win when they did not switch doors?
stayed <- decision == "stay"
won_when_stayed <- contestant_choice[stayed] == prize_door[stayed]
sum(won_when_stayed) / length(won_when_stayed)
mean(won_when_stayed)

