library(tidyverse)

# Load the data from RDS
tweets <- readRDS(file = "data/tweets_ampel.rds")

# Filter based on common operators

# Keep only rows from Annalena Baerbock
tweets |> 
  filter(screen_name == "ABaerbock") |> 
  count()

# Her old account has many more tweets...
tweets |> 
  filter(screen_name == "ABaerbockArchiv") |> 
  count()

# Keep tweets from a list of screen names
tweets |> 
  filter(screen_name %in% c("OlafScholz", "c_lindner")) |> 
  count(screen_name)

# Keep only tweets with more then 100 retweets
tweets |> 
  filter(retweet_count > 100)

# ... and only those from the chancellor (AND)
tweets |> 
  filter(retweet_count > 100, screen_name == "OlafScholz")

# .. this is the same (& = AND):
tweets |> 
  filter(retweet_count > 100 & screen_name == "OlafScholz")

# Keep only tweets with more than 1000 retweets OR at least 1000 likes (| = OR)
tweets |> 
  filter(retweet_count > 1000 | favorite_count >= 1000) |> 
  select(screen_name, retweet_count, favorite_count)

# Keep only tweets with either more than 1000 rewteets OR more than 1000 likes
# But not both (XOR)
tweets |> 
  filter(xor(retweet_count > 1000, favorite_count >= 1000)) |> 
  select(screen_name, retweet_count, favorite_count)

# Remove all rows with NAs (here: all of them)
tweets |> 
  drop_na()

# Remove all rows with NA in a specific column only
tweets |> 
  drop_na(lang)

# Remove all rows where "in_reply_to_screen_name" is NA and the the user isn't
# replying to his own tweet
tweets |> 
  filter(!is.na(in_reply_to_screen_name)) |> 
  filter(screen_name != in_reply_to_screen_name) |> 
  select(created_at, screen_name, in_reply_to_screen_name)

# Filter with simple text searches (more in a later session...)
tweets |> 
  select(screen_name, text) |>
  filter(str_detect(text, "❤")) |> 
  filter(!str_starts(text, "RT"))

# Read more ...
# Sauer 2019: Kapitel 7.2.3 ab S. 78
# https://r4ds.hadley.nz/data-transform.html#filter
# https://dplyr.tidyverse.org/reference/filter.html
# https://wordlens.datalit.de/part-1-exploring-data/data-transformation/filter-rows