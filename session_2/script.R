library(tidyverse)
library(lubridate)

# Load the data from RDS
tweets <- readRDS(file = "./data/tweets_ampel.rds")

# Durchschnittliche Like pro Tweet / Nutzer

# Anzahl Tweets pro Nutzer

num_tweets_2022 <-
  tweets %>% 
    group_by(screen_name) %>% 
    filter(created_at >= "2022-01-01") %>% 
    summarise(num_tweets = n())

num_tweets_2022

ggplot(num_tweets_2022) +
  aes(x = screen_name, y = num_tweets) +
  geom_col() +
  coord_flip()


tweets %>%  filter(created_at >= "2022-01-01") %>% 
ggplot() +
  aes(x = screen_name) +
  geom_bar() +
  coord_flip()

tweets %>%
  filter(favorite_count <= 2000) %>% 
  ggplot() +
  aes(x = favorite_count) +
  geom_histogram(binwidth = 250)








