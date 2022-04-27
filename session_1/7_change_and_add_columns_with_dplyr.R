library(tidyverse)
library(lubridate)

# Load the data from RDS
tweets <- readRDS(file = "./data/tweets_ampel.rds")

# Add new calculated column (and insert it before the first column)
tweets %>% 
  mutate(created_at_hour = hour(created_at), .before = 1)

# What are tweet with the most hashtags?
tweets %>% 
  mutate(number_hashtags = lengths(hashtags), .before = 1) %>% 
  arrange(-number_hashtags)

# Add new columns and drop all others
tweets %>% 
  transmute(created_at_date = as_date(created_at))

# Add a new column and keep all columns used in the calculation
tweets %>% 
  mutate(created_at_truncated = floor_date(created_at, unit = "hour"), .keep = "used")

# Same effect, but manually (simply select the column by name)
tweets %>% 
  transmute(created_at_truncated = floor_date(created_at, unit = "hour"), created_at)

tweets %>% 
  mutate(created_at_month = format.Date(created_at, "%Y-%m"), .before = 1)

# Add a column to indicate if a specific word is present in the tweet
tweets %>% 
  mutate(about_ukraine = str_detect(str_to_lower(text), "ukraine"), .before = 1) %>% 
  filter(about_ukraine == TRUE) %>% 
  select(screen_name, text)

tweets %>%
  filter(!is_retweet) %>% 
  mutate(is_top_tweet = retweet_count >= quantile(retweet_count, 0.99)) %>% 
  filter(is_top_tweet) %>% 
  select(retweet_count, screen_name, text) %>% 
  arrange(-retweet_count)

# Read more ...
# Wickham & Grolemund 2017: Kapitel 3 ab S. 51
# Sauer 2019: Kapitel 7.4 ab S. 93
# https://dplyr.tidyverse.org/reference/mutate.html
# https://analytics.datalit.de/r/15-daten-veraendern/spalten-veraendern