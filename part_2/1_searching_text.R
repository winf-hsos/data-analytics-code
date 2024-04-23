#### Searching in text columns ####
library(tidyverse)

# Load the tweets data set ####
tweets <- readRDS('data/tweets_ampel.rds')

# 1. Looking for matches somewhere in text ####

# Has someone mentioned ChatGPT?
tweets |> 
  filter(str_detect(str_to_lower(text), "chatgpt")) |> 
  select(screen_name, text)

# What about original tweets only?
tweets |> 
  mutate(text = str_to_lower(text)) |> 
  filter(str_detect(text, "chatgpt")) |> 
  filter(!is_retweet) |> 
  select(screen_name, text)

# 2. Looking for matches at the start or end of text ####

# This should be the same as filtering out all retweets
tweets |> 
  filter(str_starts(text, "RT", negate = T)) |> 
  select(screen_name, text)

tweets |> 
  filter(str_ends(text, "#SPD")) |> 
  select(screen_name, text)

# 3. Searching with regular expressions ####

# Search for multiple keywords
tweets |> 
  mutate(text = str_to_lower(text)) |> 
  filter(str_detect(text, "chatgpt|gpt3|gpt4|openai|künstliche intelligenz")) |> 
  select(id, text)

# Same but with keywords in a vector that is easier to reuse
search <- c("chatgpt", "gpt3", "gpt4", "künstliche intelligenz")
search_regex <- paste0(search, collapse = "|")
search_regex

tweets |> 
  mutate(text = str_to_lower(text)) |> 
  filter(str_detect(text, search_regex)) |>
  select(id, text)

# Search for tweets with user mentions
tweets |> 
  mutate(text = str_to_lower(text)) |> 
  filter(str_detect(text, "@\\w+"))

# You can test regular expressions with str_view()
test_str <- "I would love to see @RealDonaldTrump lose the 2024 elections #usa #gobiden"
str_view(test_str, "@\\w+")
str_view(test_str, "#[A-Za-z0-9_]+")

# 4. Extracting search results ####

# Extracting the key word matches (only the first match)
tweets |> 
  mutate(text = str_to_lower(text)) |> 
  mutate(keyword_matches = str_extract(text, "chatgpt|gpt3|gpt4|openai|künstliche intelligenz")) |>
  filter(!is.na(keyword_matches)) |> 
  select(keyword_matches, text) |> 
  arrange(id)

# Extracting all matches as a list and sort by length of list
tweets |> 
  mutate(text = str_to_lower(text)) |> 
  mutate(matches = str_extract_all(text, "chatgpt|gpt3|gpt4")) |>
  filter(!is.na(matches)) |> 
  select(matches, text) |> 
  arrange(desc(lengths(matches)))

# Extracting the key word matches (all matches) in separate rows
tweets |> 
  mutate(text = str_to_lower(text)) |> 
    mutate(keyword_matches = str_extract_all(text, "chatgpt|gpt3|gpt4|openai|künstliche intelligenz")) |>
  unnest_longer(keyword_matches) |> 
  filter(!is.na(keyword_matches)) |> 
  select(keyword_matches, text) |> 
  print(n = 100)

# Extracting the keyword matches (all matches) into one string column
tweets |> 
  mutate(text = str_to_lower(text)) |> 
  mutate(keyword_matches = str_extract_all(text, "chatgpt|gpt3|gpt4|openai|künstliche intelligenz")) |> 
  mutate(keyword_matches_flat = str_c(unlist(keyword_matches), collapse = ",")) |> 
  select(id, keyword_matches, keyword_matches_flat) |> 
  arrange(-lengths(keyword_matches))

# Alternative with stringi
tweets |> 
  mutate(text = str_to_lower(text)) |> 
  mutate(keyword_matches = str_extract_all(text, "chatgpt|gpt3|gpt4|openai|künstliche intelligenz")) |> 
  filter(lengths(keyword_matches) > 0) |> 
  mutate(keyword_matches_flat = stringi::stri_join_list(keyword_matches, sep = ",")) |> 
  select(id, keyword_matches, keyword_matches_flat)

# Extract all URLs from tweets
tweets |> 
  mutate(extracted_urls = str_extract_all(text, "https?://\\S+"),  .before = 1) |> 
  unnest_longer(extracted_urls, keep_empty = TRUE) |> # keep those with no URLs
  select(id, screen_name, extracted_urls, text) |> 
  arrange(id)



