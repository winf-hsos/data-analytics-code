library(tidyverse)

# Load the data from RDS
tweets <- readRDS(file = "data/tweets_ampel.rds")

# How are likes and retweets associated?
fav_ret <- 
  tweets |> 
  filter(!is_retweet) |> 
  select(favorite_count, retweet_count) 

fav_ret |> 
  count()

# Scatter plot
ggplot(fav_ret) +
  aes(x = favorite_count, y = retweet_count) +
  geom_point(alpha = 0.5)

# Use the color
fav_ret_by_user <- 
  tweets |> 
  filter(!is_retweet) |> 
  filter(screen_name %in% c("ABaerbock", "c_lindner")) |> 
  filter(created_at >= "2022-04-01") |> 
  select(screen_name, favorite_count, retweet_count) 

# Scatter plot with colors
ggplot(fav_ret_by_user) +
  aes(x = favorite_count, y = retweet_count, color = screen_name) +
  geom_point(alpha = 0.5)
