library(tidyverse)
library(tidyr)

tweets <- readRDS('./data/tweets_ampel.rds')

# Working with array-columns that contain strings (lists in R)
ht <- tweets %>% 
  select(id, screen_name, hashtags) %>%
  unnest(hashtags, keep_empty = T ) %>% 
  mutate(hashtag = str_to_lower(hashtags))

ht %>% 
  drop_na() %>% 
  count(hashtag, sort = T)

# We can also create a columns for every element in the array
ht_wide <- tweets %>% 
  select(id, hashtags) %>%
  unnest_wider(hashtags)

# We now have as many columns as the maximum number of hashtags in a tweet
ht_wide %>% colnames()

# Only the first hashtag
ht_wide %>% select(...1)

# An array-columns that contains data frames expands into multiple columns
tweets %>% 
  select(id, screen_name, urls) %>% 
  unnest(urls)

# Extract information from each URL with the 'urltools' package

#install.packages("urltools")
library(urltools)

tweets %>% 
  select(id, screen_name, urls) %>% 
  unnest(urls) %>%
  select(clean_url) %>% 
  head(1000) %>% 
  mutate(tld = list(host_extract(domain(clean_url)))) %>% 
  unnest(tld)

# A third array of data frames is the 'photos' column
tweets %>% 
  select(id, screen_name, photos) %>% 
  unnest(photos, names_repair = "unique")

# We can retrieve the length of an array
tweets %>% 
  select(urls) %>% 
  transmute(num_urls = lengths(urls), urls) %>% 
  arrange(-num_urls)

tweets %>% 
  select(hashtags) %>% 
  transmute(num_hashtags = lengths(hashtags), hashtags) %>% 
  arrange(-num_hashtags)

# READ MORE: https://tidyr.tidyverse.org/articles/rectangle.html

