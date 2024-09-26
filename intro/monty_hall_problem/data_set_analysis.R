library(tidyverse)
library(readxl)

# Load the data
lmad_data <- read_xlsx("data/monty_hall_problem/lets_make_a_deal.xlsx")

# Take a peek at the data
lmad_data |>
    glimpse()

# Transform "decision" column to factor
lmad_data <- lmad_data |>
    mutate(decision = as.factor(decision))

# How many rows and columns are in the data?
lmad_data |>
    dim()

# How many games are in the data?
lmad_data |>
    count()

# What are the column names?
lmad_data |>
    colnames()

# Choose only a subset of the columns
lmad_data |>
    select(contestant_choice, prize_door, decision)

# Determine if a contestant won and create a new column for the result
lmad_data_won <- lmad_data |>
    mutate(
        won =
            # Contestant wins if they stay and the prize is behind their door
            (contestant_choice == prize_door & decision == "stay") |
            # Contestant wins if they switch and the prize is not behind their door
            (contestant_choice != prize_door & decision == "switch")
    )

# How many games did the contestant win, how many did they lose?
lmad_data_won |>
    count(won)

# How many games did the contestant win, how many did they lose, by decision?
lmad_data_won |>
    count(won, decision)

# What is the overall probability of winning, no matter the decision?
lmad_data_won |>
    count(won) |>
    mutate(probability = n / sum(n))

# What is the probability of winning if the contestant stays?
lmad_data_won |>
    filter(decision == "stay") |>
    count(won) |>
    mutate(probability = n / sum(n))

# What is the probability of winning if the contestant switches?
lmad_data_won |>
    filter(decision == "switch") |>
    count(won) |>
    mutate(probability = n / sum(n))

# How often do contestants switch?
lmad_data |>
    count(decision) |>
    mutate(probability = n / sum(n))
