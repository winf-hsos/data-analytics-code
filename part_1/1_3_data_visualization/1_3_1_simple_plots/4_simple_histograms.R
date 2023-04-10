library(tidyverse)
library(lubridate)

# Load the data from RDS
tweets <- readRDS(file = "data/tweets_ampel.rds")

# Tweets from Christian Lindner (only original)
tweets_lindner <-
  tweets |> 
  filter(screen_name == "c_lindner") |> 
  filter(is_retweet == FALSE)

# How many are there?
tweets_lindner |> 
  count()

# How are the likes distributed?
ggplot(tweets_lindner) +
  aes(x = favorite_count) +
  geom_histogram(bins = 20)