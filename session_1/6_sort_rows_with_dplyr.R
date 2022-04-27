library(tidyverse)

# Load the data from RDS
tweets <- readRDS(file = "./data/tweets_ampel.rds")

# Sort tweets by date of creation in descending order (latest first)
tweets %>% 
  select(screen_name, created_at, text) %>% 
  filter(screen_name == "OlafScholz") %>% 
  arrange(desc(created_at))

# Sort tweets by number of likes, also in descending order
# With numeric columns, the minus sign sorts descending
tweets %>% 
  select(screen_name, favorite_count, text) %>% 
  filter(screen_name == "OlafScholz") %>% 
  arrange(-favorite_count)

# ... for completeness in ascending order, but without RTs
tweets %>% 
  filter(is_retweet == FALSE) %>% 
  select(screen_name, favorite_count, text) %>% 
  filter(screen_name == "OlafScholz") %>% 
  arrange(favorite_count)

# Sort by more than one column
tweets %>% 
  arrange(favorite_count, created_at)

# Read more...
# Wickham & Grolemund 2017: Kapitel 3 ab S. 47
# Sauer 2019: Kapitel 7.2.4 ab S. 82
# https://dplyr.tidyverse.org/reference/arrange.html



