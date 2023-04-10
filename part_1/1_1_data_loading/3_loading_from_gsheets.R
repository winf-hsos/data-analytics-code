library(tidyverse)
library(lubridate)

# We can read a published GSheet just like any CSV-file

# Read more on publishing a GSheet here: 
# https://analytics.datalit.de/sql/multiple-data-sets-with-sql/datensaetze-anreichern

meta_data <- read_csv("https://docs.google.com/spreadsheets/d/e/2PACX-1vTbaWxR5XodD0gr0grhpJSbw1eb-VWqYt2KUVUQoZGKaaBfVtsf2gA09an67ky7pVKzRhKRYajt5cn9/pub?gid=0&single=true&output=csv&t=1")

meta_data %>% 
  glimpse()

# And now we can join both data sets
tweets_meta <- tweets %>% 
  left_join(meta_data, by = c("screen_name" = "user")) %>% 
  select(screen_name, created_at, party, birthyear, gender, followers, favorite_count)

# This means we can now use additional variables to analyze our data :-)
tweets_meta %>% 
  filter(year(created_at) == 2022) %>% 
  count(party, sort = T)

# Do women or men get more likes on average?
tweets_meta %>% 
  group_by(gender) %>% 
  summarise(avg_likes = mean(favorite_count), num_tweets = n())
  
# When put in context with their followers?
tweets_meta %>% 
  group_by(gender) %>% 
  summarise(avg_likes = mean(favorite_count / followers), num_tweets = n())

# Alternative is the googlesheets4 package: 
# https://r4ds.hadley.nz/spreadsheets.html#google-sheets




