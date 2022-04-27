library(tidyverse)

# Load the data from RDS
tweets <- readRDS(file = "./data/tweets_ampel.rds")

# 1. Create a data frame with the months of 2022 in one column and the average
# number of retweets in another! Group the data by screen name!

library(lubridate)

tweets %>% 
  filter(year(created_at) == 2022) %>% 
  mutate(month = factor(month(created_at))) %>% 
  group_by(screen_name, month) %>% 
  summarise(avg_retweet_count = mean(retweet_count))

# 2. Who uses the most hashtags on average?
tweets %>% 
  transmute(screen_name, num_hashtags = lengths(hashtags)) %>% 
  group_by(screen_name) %>% 
  summarise(avg_num_hashtags = mean(num_hashtags)) %>% 
  arrange(-avg_num_hashtags)

# 3. What is the average length of a tweet in the data set?
# (Hint: the function nchar() returns the length of a string)

tweets %>% 
  transmute(tweet_length = nchar(text)) %>% 
  summarise(avg_tweet_length = mean(tweet_length))

# 4. Who writes the longest tweets? Consider only original tweets!

tweets %>% 
  filter(!is_retweet) %>% 
  transmute(screen_name, tweet_length = nchar(text)) %>% 
  group_by(screen_name) %>% 
  summarise(avg_tweet_length = mean(tweet_length)) %>% 
  arrange(-avg_tweet_length)

# 5. Who tweeted the most in March 2022?

tweets %>% 
  filter(year(created_at) == 2022, month(created_at) == 3) %>% 
  count(screen_name, sort = TRUE)

# 6. What hour of the day is the most active regarding the number of tweets?

tweets %>% 
  mutate(hour = factor(hour(created_at))) %>% 
  count(hour, sort = TRUE)

# 7. What time does Annalena Baerbock go to bed? When does she wake up?

tweets %>% 
  filter(screen_name == "ABaerbock") %>% 
  mutate(hour = factor(hour(created_at))) %>% 
  count(hour) %>% 
  arrange(hour)

# No tweets before 6 am and none after 21 pm!

# 8. Which account do each of the ministers retweet most often? (Hint: check slice_max() for help)

tweets %>% 
  select(screen_name, retweeted_user) %>% 
  filter(!is.na(retweeted_user)) %>% 
  group_by(screen_name, retweeted_user) %>% 
  summarise(times_retweeted = n()) %>% 
  arrange(screen_name, -times_retweeted) %>% 
  mutate(rn = row_number()) %>% 
  slice_max(order_by = -rn, n = 1) %>% 
  select(-rn)

# We use the row_number() function to have only one result in per minister,
# even if two accounts or more were retweeted the same number of times