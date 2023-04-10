library(tidyverse)
library(lubridate)

# Load the data from RDS
tweets <- readRDS(file = "data/tweets_ampel.rds")

# Tweets from Christian Lindner (only original)
tweets_lindner <-
  tweets |> 
  filter(screen_name == "c_lindner") |> 
  filter(is_retweet == FALSE)

# 1 box for distribution of likes
ggplot(tweets_lindner) +
  aes(x = favorite_count) + 
  geom_boxplot()

# With original points as jitter
ggplot(tweets_lindner) +
  aes(x = favorite_count, y = screen_name) + 
  geom_boxplot() +
  geom_jitter(alpha = 0.1)

# How is the number of retweets distributed in 3 users?
num_retweets <- 
  tweets |> 
  filter(screen_name %in% c("c_lindner", "OlafScholz", "ABaerbock"))
  filter(is_retweet == FALSE) |> 
  select(screen_name, retweet_count)

# 3 boxes - What's the problem?
ggplot(num_retweets) +
  aes(x = retweet_count, y = screen_name) + 
  geom_boxplot()

# Adding the original points with jitter
ggplot(num_retweets) +
  aes(x = retweet_count, y = screen_name) + 
  geom_boxplot() +
  geom_jitter(alpha = 0.05) +
  coord_cartesian(xlim = c(0, 500))


# CAUTION: Setting the scale's limits removes data and replaces it with NA
tweets |> 
  filter(screen_name %in% c("Karl_Lauterbach", "ABaerbock")) |> 
  ggplot() +
  aes(x = favorite_count, y = screen_name) |> 
  geom_boxplot() +
  scale_x_continuous(limits = c(0, 2000)) # short would be xlim(0, 2000)

# Using coord_cartesian zooms in without changing the data
tweets |> 
  filter(screen_name %in% c("Karl_Lauterbach", "ABaerbock")) |> 
  ggplot() +
  aes(x = favorite_count, y = screen_name) +
  geom_boxplot() +
  coord_cartesian(xlim = c(0, 2000))
