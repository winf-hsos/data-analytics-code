library(tidyverse)
library(lubridate)

# Load the data from RDS
tweets <- readRDS(file = "./data/tweets_ampel.rds")

# Tweets from Christian Lindner (only original)
tweets_lindner <-
  tweets %>% 
  filter(screen_name == "c_lindner") %>% 
  filter(is_retweet == FALSE)

# How many are there?
tweets_lindner %>% count()

# How are the likes distributed?
ggplot(tweets_lindner) +
  aes(x = favorite_count) +
  geom_histogram(bins = 20)
  
# How is the number of retweets distributed?
num_retweets <- 
  tweets %>% 
  filter(screen_name %in% c("c_lindner", "OlafScholz", "ABaerbock"))
  filter(is_retweet == FALSE) %>% 
  select(screen_name, retweet_count)

# 3 boxes
ggplot(num_retweets) +
  aes(x = retweet_count, y = screen_name) + 
  geom_boxplot() +
  xlim(0, 200)

# Adding the original points with jitter
ggplot(num_retweets) +
  aes(x = retweet_count, y = screen_name) + 
  geom_boxplot() +
  geom_jitter(alpha = 0.1) +
  xlim(0, 200)
