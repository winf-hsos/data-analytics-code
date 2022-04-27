library(tidyverse)

# Load the data from RDS
tweets <- readRDS(file = "./data/tweets_ampel.rds")

# Count records (here: tweets)
tweets %>% 
  count()

# Count records by the value of another variable (the shortcut)
tweets %>% 
  count(screen_name) %>% 
  arrange(-n)

# Same result with group_by
tweets %>% 
  group_by(screen_name) %>% 
  summarise(n = n()) %>% 
  arrange(-n)

# Only original tweets in April 2022
tweets %>% 
  filter(!is_retweet) %>%
  filter(created_at >= "2022-04-01") %>% 
  count(screen_name) %>% 
  arrange(-n)

# Average number of likes by user
tweets %>% 
  filter(!is_retweet) %>%
  group_by(screen_name) %>% 
  summarise(avg_num_favs = mean(favorite_count)) %>% 
  arrange(-avg_num_favs)
  
# What percentage are original tweets?
tweets %>% 
  group_by(screen_name, is_retweet) %>% 
  summarise(n = n()) %>% 
  mutate(pct = n / sum(n)) %>% 
  filter(!is_retweet) %>% 
  arrange(-pct)

# The janitor package allows a shortcut
install.packages("janitor")
library(janitor)

tweets %>% 
  tabyl(is_retweet)

tweets %>%
  tabyl(screen_name, is_retweet) %>% 
  mutate(pct_original = `FALSE` / (`FALSE` + `TRUE`)) %>% 
  arrange(-pct_original)

# Read more ...
# Wickham & Grolemund 2017: Kapitel 3 ab S. 55
# https://dplyr.tidyverse.org/reference/group_by.html
# https://dplyr.tidyverse.org/reference/summarise.html
#https://analytics.datalit.de/r/15-daten-veraendern/daten-zusammenfassen
  