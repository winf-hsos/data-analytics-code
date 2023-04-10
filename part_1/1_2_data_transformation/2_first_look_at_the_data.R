library(tidyverse)

# Load the data from RDS
tweets <- readRDS(file = "data/tweets_ampel.rds")

# Get an overview of the data set (column names and types and preview)
glimpse(tweets)

# Or, with the pipe
tweets |> 
  glimpse()

# Get a list of column names
colnames(tweets)

# How many rows do we have? 
tweets |> 
  count()

# Show the first few lines (5 per default)
tweets |>
  head()

# Show the first 20 lines
tweets |> 
  head(n = 20)

# Show the last 20 lines
tweets |> 
  tail(n = 20)

# Show the dimensions (number of rows and columns)
dim(tweets)

# Which unique screen names are part of the data set?
tweets |> 
  distinct(screen_name)

# How many tweets (1 row = a tweet) per screen name?
tweets |> 
  count(screen_name)

# The same, but sorted by number of rows (here: tweets)
tweets |>
  count(screen_name) |> 
  arrange(-n)

# The count function can sort in descending order, too
tweets |> 
  count(screen_name, sort = TRUE)

# Summarize a column
summary(tweets$retweet_count)

# Get a column and all it's values as a vector
tweets |> 
  distinct(screen_name) |> 
  pull()

# The package skimr contains neat summary functions

#install.packages("skimr")
library(skimr)
skim(tweets)

# Show only missing values and complete rate for each column 
# and sort by complete rate
tweets |> 
  skim() |> 
  select(skim_variable, n_missing, complete_rate) |> 
  arrange(-complete_rate) |> 
  print(n = 22)
