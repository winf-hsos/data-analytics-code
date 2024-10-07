# Introduction to data frames in R ####

## Load vectors from file ####
prize_door <- scan("data/monty_hall_problem/prize_door.txt")
contestant_choice <- scan("data/monty_hall_problem/contestant_choice.txt")
decision <- scan("data/monty_hall_problem/decision.txt", what = "character")

## Create a data frame from the vectors ####
monty_hall <- data.frame(prize_door, contestant_choice, decision)

View(monty_hall)

## Access columns ####
monty_hall$prize_door
monty_hall$contestant_choice
monty_hall$decision

monty_hall["prize_door"]
monty_hall["contestant_choice"]
monty_hall["decision"]

monty_hall[, 1]     # first column as a vector (!)
monty_hall[, 1:2]   # first two columns as a data frame
monty_hall[, ncol(monty_hall)]  # last column

## Change columns data type ####
monty_hall$decision <- as.factor(monty_hall$decision)
levels(monty_hall$decision)

# Storage mode, type and class of the decision column
mode(monty_hall$decision)
typeof(monty_hall$decision)
class(monty_hall$decision)

## Add new columns ####
monty_hall$won <- (monty_hall$prize_door == monty_hall$contestant_choice & monty_hall$decision == "stay") |
  (monty_hall$prize_door != monty_hall$contestant_choice & monty_hall$decision == "switch") 


## Access rows and columns ####

## First 10 rows, all columns
monty_hall[1:10,]

## All rows, first 2 columns
monty_hall[,1:2]

## First 10 rows, first 2 columns
monty_hall[1:10,1:2]

## Last row
monty_hall[nrow(monty_hall),]

## All rows, all columns except the last one
monty_hall[, -ncol(monty_hall)]

ncol(monty_hall)

## Last row, two columns by name
monty_hall[nrow(monty_hall), c("prize_door", "contestant_choice")]

## Filter data frames ####
games_won <- monty_hall[monty_hall$won == TRUE, ]
nrow(games_won)

switch_and_won <- monty_hall[monty_hall$decision == "switch" & monty_hall$won == TRUE,]
nrow(switch_and_won)

## Ordering data frames ####
monty_hall_sorted <- monty_hall[order(monty_hall$prize_door),]

## Decreasing order
monty_hall[order(monty_hall$prize_door, decreasing = TRUE),]

## Load a data frame from a CSV file ####
monty_hall <- read.csv("data/monty_hall_problem/lets_make_a_deal.csv", sep = ";", header = TRUE)

colnames(monty_hall)

monty_hall$contestant

summary(monty_hall)