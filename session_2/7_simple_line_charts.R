library(tidyverse)
library(lubridate)

# Load the data from RDS
tweets <- readRDS(file = "./data/tweets_ampel.rds")

tweets_per_day <-
  tweets %>% 
  mutate(day = as_date(created_at)) %>% 
  filter(day >= "2022-01-01") %>% 
  count(day)

# Development of tweets per day
ggplot(tweets_per_day) + 
  aes(x = day, y = n) +
  geom_line()

tweets_per_week <-
  tweets %>% 
  filter(created_at >= "2022-01-01") %>% 
  mutate(week = week(created_at)) %>% 
  filter(week != 53, week <= 15) %>% 
  count(week)

# Tweets per week
ggplot(tweets_per_week) + 
  aes(x = week, y = n) +
  geom_line()

# Tweets per month all in one command :)
tweets %>% 
  transmute(month = floor_date(created_at, unit = "months")) %>% 
  count(month) %>% 
  ggplot() + 
  aes(x = month, y = n) +
  geom_line()