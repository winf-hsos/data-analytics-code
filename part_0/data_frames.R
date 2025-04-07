# Read some vectors
decision <- scan("data/monty_hall_problem/decision.txt", what = "character")
choice_door <- scan("data/monty_hall_problem/contestant_choice.txt")
prize_door <- scan("data/monty_hall_problem/prize_door.txt")

# Make a data frame out of the vectors
monty <- data.frame(decision, choice_door, prize_door)

# Get the column names as a vector
colnames(monty)

# Get number of rows and columns
nrow(monty)
ncol(monty)
dim(monty)
summary(monty)
str(monty)

# Get a tabular view in RStudio
View(monty)

# Select columns
monty$decision
monty$choice_door
monty$prize_door

monty["decision"]
monty[c("decision", "prize_door")]

# Access by index
monty[2, 2]   # Zelle an Koordinate 2,2
monty[ , 2]   # Alle Zeilen, nur Spalte 2
monty[ , 1]   # Alle Zeilen, nur Spalte 1
monty[ , 3]   # Alle Zeilen, nur Spalte 3
monty[ , 2:3] # Alle Zeilen, Spalten 2 und 3

monty[1, ]    # Zeile 1, alle Spalten
monty[1:10, ] # Zeilen 1 - 10, alle Spalten

monty[, -3]
monty[ , -c(1, 2)]

# Filter a data frame
subset(monty, monty$decision == "switch")

monty[monty$decision == "switch", c("decision", "prize_door")]

monty[monty$decision == "switch" & prize_door == 1, ]
monty[monty$decision == "switch" | prize_door == 1, ]

# Add new columns
monty$won <-
  (monty$decision == "switch" & monty$choice_door != monty$prize_door) |
  (monty$decision == "stay" & monty$choice_door == monty$prize_door)

# Edit existing columns
monty$decision <- as.factor(monty$decision)
str(monty)

# Create a data frame from a CSV file
monty_from_csv <- read.csv("data/monty_hall_problem/lets_make_a_deal.csv", sep = ";")
colnames(monty_from_csv)

