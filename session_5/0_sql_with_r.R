library(tidyverse)
library(sqldf)

tweets <- readRDS('./data/tweets_ampel.rds')

# sqldf can't handle lists or arrays
tweets <- tweets %>% 
  select(-hashtags, -urls, -photos, -user_mentions)

# We can use sqldf function and pass an SQL statement
screen_names <- sqldf("select distinct screen_name from tweets")
screen_names